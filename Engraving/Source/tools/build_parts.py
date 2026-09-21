"""Derive individual parts from the approved absolute-pitch player variables.
Run in the project root. No changes to the canonical musical score are made here.
"""
from pathlib import Path
import re, json, sys

W=Path(__file__).resolve().parent.parent
D=W/'sources/parts'; D.mkdir(exist_ok=True)
SOURCE=(W/'weber-symphony-2.ly').read_text(encoding='utf-8')
COUNTS={'I':237,'II':59,'III':36,'IV':203}
NAMES={'flute':'Flute','oboeOne':'Oboe I','oboeTwo':'Oboe II','bassoonOne':'Bassoon I','bassoonTwo':'Bassoon II','hornOne':'Horn I','hornTwo':'Horn II','trumpetOne':'Trumpet I','trumpetTwo':'Trumpet II','timpani':'Timpani','violinOne':'Violin I','violinTwo':'Violin II','viola':'Viola','cello':'Violoncello','bass':'Double Bass'}
SHORT={'flute':'Fl.','oboeOne':'Ob. I','oboeTwo':'Ob. II','bassoonOne':'Fg. I','bassoonTwo':'Fg. II','hornOne':'Cor. I','hornTwo':'Cor. II','trumpetOne':'Tr. I','trumpetTwo':'Tr. II','timpani':'Timp.','violinOne':'Vl. I','violinTwo':'Vl. II','viola':'Vla.','cello':'Vc.','bass':'Cb.'}
SHORT['violaSolo']='Vla. solo'
TITLES={'I':'I. Allegro','II':'II. Adagio ma non troppo','III':'III. Menuetto — Allegro','IV':'IV. Finale — Scherzo, presto'}
GP={'I':[],'II':[],'III':[25,35],'IV':[32,200]}
def body(v): return re.search(r'(?m)^'+v+r' = \{\n(.*?)\n\}',SOURCE,re.S)[1]
def balanced_end(s,start):
    depth=0; quoted=False; escaped=False
    for n in range(start,len(s)):
        c=s[n]
        if c=='"' and not escaped:quoted=not quoted
        if not quoted:
            if c=='{':depth+=1
            if c=='}':
                depth-=1
                if depth==0:return n+1
        escaped=(c=='\\' and not escaped)
    raise ValueError(s[start:])
def clean(s):
    while (m:=re.search(r"\\tag #'score\s*\{",s)):
        e=balanced_end(s,s.index('{',m.start()));s=s[:m.start()]+s[e:]
    s=re.sub(r'\\(?:pageBreak|break|noBreak|noPageBreak)\b','',s)
    return s.strip()

def part_clean(s):
    # LilyPond's ottava changes printed register only; absolute pitches remain intact.
    return re.sub(r'\\ottava\s+#-?\d+\s*|\\scoreTrioAnnotation\b','',clean(s))
def rawbars(v):return {int(n):part_clean(t) for n,t in re.findall(r'\\barNumberCheck #(\d+) (.*?) \| % m\.',body(v))}
BARS={p+m:rawbars(p+m) for m in COUNTS for p in NAMES}
BARS['violaSoloII']=rawbars('violaSoloII')
def globals(mov):
    d={}
    for t,n in re.findall(r'([^\n]+) \| % (\d+)\n?',body('global'+mov)):
        t=clean(t);a,b=re.split(r'\bs(?:1|2\.)\b',t,maxsplit=1) if mov in ['I','II'] else re.split(r'\bs2\.',t,maxsplit=1)
        d[int(n)]=(a.strip(),b.strip())
    assert len(d)==COUNTS[mov],(mov,len(d))
    return d
GLOBALS={m:globals(m) for m in COUNTS}
def without_key(s):return re.sub(r'\\key\s+[a-g][a-z]*\s+\\(?:major|minor)\b','',s)
def empty(t):
    t=without_key(t);t=re.sub(r'\\(?:oneVoice|voiceOne|voiceTwo)\b','',t)
    return re.fullmatch(r'\s*R(?:1|2\.)\s*',t) is not None
def plain_rest(t):return re.fullmatch(r'R(?:1|2\.)',t.strip()) is not None
def clef(p):return 'bass' if p in ['bassoonOne','bassoonTwo','timpani','cello','bass'] else 'alto' if p in ['viola','violaSolo'] else 'treble'
def instrument_pitch(p,m,modern=False):
    if p.startswith('horn'):return 'f' if modern or m=='II' else 'c'
    if p.startswith('trumpet'):return 'bes' if modern else "d'" if m=='II' else "c'"
    return 'c' if p=='bass' else "c'"
def transpose(p,m,modern):
    if modern and p.startswith('horn') and m!='II':return 'c g,'
    if modern and p.startswith('trumpet'):return 'c e' if m=='II' else 'c d'
    return "c c"
def keylabel(p,m,modern=False):
    if p.startswith('horn'):return 'in F' if modern or m=='II' else 'in C'
    if p.startswith('trumpet'):return 'in B-flat' if modern else 'in D' if m=='II' else 'in C'
    return ''

# Last two bars of a substantial wait: choose an audible melody in the actual score.
# Separate quotes are the original instruments, never the condensed staff.
CUES={}; cue_ledger=[]
for m,total in COUNTS.items():
 for p in NAMES:
    if p=='timpani' and m=='II':continue
    b=BARS[p+m];a=None
    for n in range(1,total+2):
        isrest=n<=total and empty(b[n]) and n not in GP[m] and n-1 not in GP[m]
        if isrest and a is None:a=n
        if not isrest and a is not None:
            z=n-1
            if z-a+1 >= (5 if m=='II' else 8) and n<=total and not empty(b[n]):
                # Musical source preferences: melodic winds or violin I; bass cues for low instruments.
                candidates=['flute','oboeOne','violinOne','bassoonOne','cello','hornOne']
                if m=='IV' and 100<=z<=141:candidates=['flute','oboeOne','violinTwo','cello','hornOne','bassoonOne']
                if m=='II':candidates=['oboeOne','flute','violinOne','bassoonOne','cello','hornOne']
                valid=[]
                for q in candidates:
                    if q==p:continue
                    ts=[BARS[q+m][k] for k in range(z-1,z+1)]
                    if any(empty(t) for t in ts):continue
                    if any(re.search(r'\\(?:grace|afterGrace|appoggiatura|acciaccatura)|<<|:\d|\\ottava',t) for t in ts):continue
                    valid.append(q)
                if valid:
                    q=valid[0];CUES[p+m,z-1]=(q,z)
                    cue_ledger.append(dict(player=p,movement=m,rest_start=a,start=z-1,end=z,entry=n,source=q))
            a=None

# The Adagio's opening melody belongs to the solo viola. Quote its clear bars
# 7-8, followed by two counted rests, rather than the bassoon accompaniment.
for p in NAMES:
    if all(empty(BARS[p+'II'][n]) for n in range(1,11)) and not empty(BARS[p+'II'][11]):
        CUES.pop((p+'II',9),None)
        cue_ledger[:]=[c for c in cue_ledger if not (c['player']==p and c['movement']=='II' and c['entry']==11)]
        CUES[p+'II',7]=('violaSolo',8)
        cue_ledger.append(dict(player=p,movement='II',rest_start=1,start=7,end=8,entry=11,source='violaSolo',reason='Audible opening solo, followed by two counted bars.'))

def add_cue(p,m,a,z,q,entry,reason):
    assert all(empty(BARS[p+m][n]) for n in range(a,z+1))
    CUES[p+m,a]=(q,z)
    cue_ledger.append(dict(player=p,movement=m,start=a,end=z,entry=entry,source=q,reason=reason))
for p in ['oboeTwo','hornOne','hornTwo','trumpetOne','trumpetTwo','timpani']:
    add_cue(p,'I',205,206,'oboeOne',209,'Audible oboe phrase before two further counted rests; avoids a grace-note-heavy violin cue.')
add_cue('bass','II',19,20,'flute',22,'Flute phrase followed by one counted rest.')
for p in ['oboeTwo','bassoonOne','bassoonTwo','trumpetOne','trumpetTwo','timpani']:
    add_cue(p,'III',31,32,'oboeOne',33,'Trio melody after the intervening general pause.')
for p in ['hornOne','hornTwo']:
    add_cue(p,'III',29,30,'violinOne',31,'Audible string figure before the return of the horns.')
add_cue('bass','III',23,24,'oboeOne',27,'Trio melody before the two-bar general pause.')
for p in ['bassoonTwo','hornOne','hornTwo']:
    CUES.pop((p+'II',21))
    cue_ledger[:]=[c for c in cue_ledger if not (c['player']==p and c['movement']=='II' and c['entry']==23)]
    add_cue(p,'II',22,22,'bassoonOne',23,'The final bar of the bassoon figure gives a clear cue without its preceding extreme register jump.')

# Shared musical definitions, without the condensed-score merger or page layout.
defs=SOURCE[SOURCE.index('% A real turn Script'):SOURCE.index('\\paper {')]
lib='\\version "2.26.0"\n\\language "nederlands"\n'+defs
for m in COUNTS:
 for p in NAMES:
    lib+=p+m+' = {\n'+part_clean(body(p+m))+'\n}\n'
lib+='violaSoloII = {\n'+clean(body('violaSoloII'))+'\n}\n'
(D/'source-music.ily').write_text(lib,encoding='utf-8')

LAYOUT=r'''
#(set-object-property! 'weberCueLabel 'translation-type? (lambda (x) (or (string? x) (not x))))
#(set-object-property! 'weberCueLabel 'translation-doc "Pending cue source label, consumed by the first cue notehead.")
#(set-object-property! 'weberCueId 'translation-type? string?)
#(set-object-property! 'weberCueId 'translation-doc "Source and start bar for a proofed cue.")
#(define (weber-cue-label-engraver context)
   (make-engraver
     (acknowledgers
       ((note-head-interface engraver head source)
        (let* ((staff (ly:context-find context 'Staff))
               (label (ly:context-property staff 'weberCueLabel #f)))
          (let* ((cause (ly:grob-property head 'cause))
                 (pitch (ly:event-property cause 'pitch))
                 (moment (ly:context-current-moment context)))
            (ly:message "CUE_NOTE ~a ~a/~a ~a" (ly:context-property staff 'weberCueId "unknown")
              (ly:moment-main-numerator moment) (ly:moment-main-denominator moment)
              (+ 60 (ly:pitch-semitones pitch))))
          (if label
            (let ((text (ly:engraver-make-grob engraver 'TextScript (ly:grob-property head 'cause))))
              (ly:grob-set-property! text 'text label)
              (ly:grob-set-property! text 'direction UP)
              (ly:grob-set-property! text 'self-alignment-X LEFT)
              (ly:grob-set-property! text 'staff-padding 2)
              (ly:grob-set-property! text 'outside-staff-priority 500)
              (ly:grob-set-parent! text X head)
              (ly:pointer-group-interface::add-grob text 'side-support-elements head)
              (ly:context-set-property! staff 'weberCueLabel #f))))))))

% Trio is a subordinate heading, flush left and without movement-title space.
#(define-markup-command (weber-part-title layout props) ()
   (let* ((title (chain-assoc-get 'header:title props #f))
          (piece (chain-assoc-get 'header:piece props #f))
          (composer (chain-assoc-get 'header:composer props #f)))
     (if (markup? title)
       (interpret-markup layout props #{ \markup \column {
    \fill-line { \fontsize #3 \bold \fromproperty #'header:title }
    \fill-line { \fromproperty #'header:subtitle }
    \fill-line { "" \fontsize #-1 \fromproperty #'header:composer }
    \vspace #0.8
    \fill-line { \fontsize #2 \bold \fromproperty #'header:piece }
    \vspace #0.5
  } #})
       (interpret-markup layout props
       (make-column-markup
         (append
           (if (markup? title)
             (list (make-fill-line-markup (list (make-fontsize-markup 3 (make-bold-markup title))))) '())
           (if (markup? composer)
             (list (make-fill-line-markup (list "" (make-fontsize-markup -1 composer))) (make-vspace-markup 0.5)) '())
           (if (equal? piece "Trio")
             (list (make-bold-markup "Trio") (make-vspace-markup 0.15))
             (if (markup? piece)
               (list (make-fill-line-markup (list (make-fontsize-markup 2 (make-bold-markup piece)))) (make-vspace-markup 0.3)) '()))))))))

#(set-global-staff-size 21.34)
\paper {
  paper-width = 228.6\mm
  paper-height = 304.8\mm
  top-margin = 20\mm bottom-margin = 20\mm
  left-margin = 20\mm right-margin = 20\mm
  inner-margin = 20\mm outer-margin = 20\mm binding-offset = 0\mm
  two-sided = ##t
  first-page-number = #2
  indent = 10\mm short-indent = 0\mm
  ragged-last = ##f ragged-bottom = ##f ragged-last-bottom = ##f
  max-systems-per-page = #10
  page-breaking = #ly:optimal-breaking
  print-all-headers = ##t print-page-number = ##t print-first-page-number = ##t
  system-system-spacing = #'((basic-distance . 14) (minimum-distance . 11) (padding . 3) (stretchability . 12))
  markup-system-spacing = #'((basic-distance . 8) (minimum-distance . 6) (padding . 2) (stretchability . 0))
  score-system-spacing = #'((basic-distance . 12) (minimum-distance . 9) (padding . 2.5) (stretchability . 0))
  score-markup-spacing = #'((basic-distance . 10) (minimum-distance . 8) (padding . 2) (stretchability . 0))
  top-system-spacing = #'((basic-distance . 6) (minimum-distance . 4) (padding . 2))
  last-bottom-spacing = #'((basic-distance . 2) (minimum-distance . 1) (padding . 1))
  oddHeaderMarkup = \markup \fill-line { \fontsize #-1 "WEBER / SYMPHONY No. 2" \fontsize #-1 \fromproperty #'header:instrument \fromproperty #'page:page-number-string }
  evenHeaderMarkup = \markup \fill-line { \fromproperty #'page:page-number-string \fontsize #-1 \fromproperty #'header:instrument \fontsize #-1 "WEBER / SYMPHONY No. 2" }
  oddFooterMarkup = ##f evenFooterMarkup = ##f
  bookTitleMarkup = ##f
  scoreTitleMarkup = \markup \weber-part-title
}
\layout {
  \context { \CueVoice \consists #weber-cue-label-engraver }
  \context { \Score
    \remove Mark_engraver \remove Metronome_mark_engraver
    \override NonMusicalPaperColumn.page-break-permission = ##f
    \override BarNumber.font-size = #-1
    \override BarNumber.break-visibility = ##(#f #f #t)
    \override SpacingSpanner.uniform-stretching = ##t
    \override Slur.minimum-length = #2.5
    \override Accidental.hide-tied-accidental-after-break = ##t
    \override TupletBracket.direction = #UP
    \override DynamicText.font-size = #-0.5
    \override MultiMeasureRest.expand-limit = #1
    skipBars = ##t
  }
  \context { \Staff
    \consists Mark_engraver \consists Metronome_mark_engraver
    \override RehearsalMark.font-size = #1.5
    \override RehearsalMark.self-alignment-X = #LEFT
    \override RehearsalMark.staff-padding = #2
    \override MetronomeMark.staff-padding = #2
    \consists Measure_spanner_engraver
    \override MeasureSpanner.stencil = #weber-general-pause-print
    \override MeasureSpanner.staff-padding = #2
    \accidentalStyle modern
    \override StaffSymbol.thickness = #0.9
  }
}
'''

# Local page-turn refinements are data, so rebuilding does not lose them.
OVERRIDES=json.loads((D/'layout-overrides.json').read_text()) if (D/'layout-overrides.json').exists() else {}
PAGE_ENDS=json.loads((D/'page-ends.json').read_text())
# Editor-approved facing-page redistribution; actual leaf turns stay fixed.
PAGE_ENDS['violinOne']=[['II',41] if x==['II',46] else x for x in PAGE_ENDS['violinOne']]
PAGE_ENDS['violinTwo']=[['II',41] if x==['II',46] else x for x in PAGE_ENDS['violinTwo']]
# Timpani later movements share one facing spread; first-movement turns stay fixed.
PAGE_ENDS['timpani']=[['I',102],['I',237],['IV',49]]
TRANSITION_LINES={
 'timpani':{'III':[8,16,36],'IV':[20,37,49,99,129,145,158,171,181,191,203]},
 'bass':{'III':[8,16,27,36]},
 'violinOne':{'II':[11,15,18,22,27,34,37,41,46,51,59],'III':[8,16,26,36]},
 'violinTwo':{'II':[14,21,27,34,38,41,46,51,59],'III':[8,16,26,36]},
}
MOVEMENT_PAGE_BREAKS={('bassoonTwo','II'),('violinOne','III'),('cello','III')}


def cue_octave_down(p,m,modern,q,a,z):
    if not (modern and p.startswith(('horn','trumpet'))):return False
    source_offset=(-7 if m=='II' else -12) if q.startswith('horn') else (2 if m=='II' else 0) if q.startswith('trumpet') else -12 if q=='bass' else 0
    shift=source_offset+(7 if p.startswith('horn') else 2)
    pitches=[]
    for n in range(a,z+1):
        for name,acc,octaves in re.findall(r"(?<![A-Za-z\\])([a-g])(isis|eses|is|es|s)?([',]*)(?=\d|[ >])",BARS[q+m][n]):
            sem={'c':0,'d':2,'e':4,'f':5,'g':7,'a':9,'b':11}[name]
            sem+={'':0,'is':1,'isis':2,'es':-1,'eses':-2,'s':-1}[acc]
            pitches.append(48+sem+12*(octaves.count("'")-octaves.count(','))+shift)
    return max(pitches)>84

def cue_rest_position(p,m,modern,q,a,z,qclef):
    """Keep the full-size rest away from the cue's actual printed register."""
    shift=(4 if p.startswith('horn') and (modern or m=='II') else
           1 if p.startswith('trumpet') and modern else
           -1 if p.startswith('trumpet') and m=='II' else 0)
    if cue_octave_down(p,m,modern,q,a,z):shift-=7
    if q.startswith('horn'):shift-=4 if m=='II' else 7
    if q.startswith('trumpet') and m=='II':shift+=1
    center={'treble':34,'alto':28,'bass':22}[qclef]
    positions=[]
    for n in range(a,z+1):
        for name,octaves in re.findall(r"(?<![A-Za-z])([a-g](?:is|es|s|isis|eses)?)([',]*)\d",BARS[q+m][n]):
            diatonic=21+'cdefgab'.index(name[0])+7*(octaves.count("'")-octaves.count(','))
            positions.append(diatonic+shift-center)
    assert positions,(p,m,q,a,z)
    low,high=min(positions),max(positions)
    if high<=-3:return 2
    return min(-4,2*((low-4)//2))

def modern_horn_clefs(p,m):
    """Balance ledger-line reading against unnecessary clef changes.
    Work in diatonic positions after the down-fourth C-to-F conversion;
    change clef only at a new attack, never between tied noteheads.
    """
    states={'treble':(0,{}),'bass':(30,{1:'bass'})}
    prev_tied=False
    for n,t in BARS[p+m].items():
        found=re.findall(r"(?<![A-Za-z\\])([a-g])(?:isis|eses|is|es|s)?([',]*)(\d+)",t)
        notes=[(21+'cdefgab'.index(name)+7*(o.count("'")-o.count(','))-3,1/int(d)) for name,o,d in found]
        costs={}
        for c,(lo,hi) in {'treble':(30,38),'bass':(18,26)}.items():
            costs[c]=sum((max(0,lo-x-2, x-hi-2)/2)**2*w*4 for x,w in notes)+(0.6 if c=='bass' and notes else 0)
        next_states={}
        for c in states:
            options=[]
            for before,(cost,changes) in states.items():
                if c!=before and (prev_tied or not notes):continue
                cc=dict(changes)
                if c!=before:cc[n]=c
                options.append((cost+costs[c]+(12 if c!=before else 0),cc))
            next_states[c]=min(options,key=lambda x:x[0])
        states=next_states
        prev_tied=bool(re.search(r'~[^a-g\d]*$',t))
    return min(states.values(),key=lambda x:x[0])[1]

HORN_CLEFS={(p,m):modern_horn_clefs(p,m) for p in ['hornOne','hornTwo'] for m in ['I','III','IV']}
# The first horn's last few low notes need only modest ledger lines; avoid a
# clef change in the closing cadence merely to save one or two ledger lines.
HORN_CLEFS['hornOne','I']={}
# Publication proof: clef changes follow the notes within III/16 and the
# sudden high attacks in IV/167-168, rather than the whole-bar cost estimate.
HORN_CLEFS['hornTwo','III'].pop(16,None)
HORN_CLEFS['hornTwo','III'][17]='bass'
HORN_CLEFS['hornTwo','IV'].update({167:'treble',169:'bass'})

def make_music(p,m,modern=False,second=False):
    b=BARS[(p+m) if not second else 'violaSoloII'];g=GLOBALS[m]
    dur='1' if m in ['I','II'] else '2.'
    lines=[];quote_sources=set();n=1;total=COUNTS[m]
    nokey=p.startswith('horn') or (p.startswith('trumpet') and not modern) or p=='timpani'
    label=keylabel(p,m,modern)
    initial='\\clef "'+clef(p)+'" \\transposition '+instrument_pitch(p,m,modern)+' '
    # Transposition commands lie outside \transpose so the sounding instrument property is stable.
    if p.startswith('trumpet') and modern:
        initial+='\\key '+('g \\major' if m=='II' else 'd \\minor' if m=='III' else 'd \\major')+' '
    music=[]
    if label:music.append('s1*0^\\markup \\bold "'+label+'"')
    while n<=total:
        start=n;pre,post=g[n];t=b[n]
        if p=='flute' and m=='IV' and n==182:
            pre=r'\once \override Staff.RehearsalMark.staff-padding = #4.5 '+pre
        if p=='flute' and m=='IV' and n==181:
            # Preserve the boundary served by the canonical incoming tie glyph.
            post+=r'\break'
        # Shape the II/35–38 slur for each part's existing break. Interior
        # control points stay above their adjacent endpoints: no reversed hooks.
        if p=='cello' and m=='II' and n==35:
            t=r"\shape #'(((0 . -1.5) (0 . -0.2) (0 . 2.5) (0 . 3.5)) ((0 . 0) (0 . 0) (0 . 0) (0 . 0))) Slur "+t
        if p=='bass' and m=='II' and n==35:
            t=r"\shape #'(((0 . 0) (0 . 0) (0 . 0) (0 . 0)) ((0 . 3) (0 . 2) (0 . -1) (0 . 0))) Slur "+t
        if (p,m,n) in [('hornTwo','I',64),('bassoonOne','I',116),('bassoonOne','IV',59)]:
            pre=r'\undo \omit Staff.CueEndClef '+pre
        if p in ['bassoonOne','cello'] and m=='II' and n==44:t=r"\override TupletNumber.extra-offset = #'(0 . 1.4) "+t+r' \revert TupletNumber.extra-offset'
        if p in ['bassoonOne','bassoonTwo'] and m=='II' and n==44:t=r"\once \override TextScript.extra-offset = #'(-2 . 0) "+t
        if p in ['bassoonOne','bassoonTwo','cello','bass'] and m=='II' and n==45:t=t.replace(r'\tuplet 3/2',r"\once \override TupletNumber.extra-offset = #'(0 . 2.2) \tuplet 3/2",1)
        if p=='bass' and m=='II' and n==45:
            t=r"\override TupletBracket.padding = #1.2 \override TupletBracket.outside-staff-priority = #200 "+t+r' \revert TupletBracket.padding \revert TupletBracket.outside-staff-priority'
        if p=='hornOne' and m=='IV' and n==100:t=r'\once \override Hairpin.minimum-length = #5 \once \override Hairpin.springs-and-rods = #ly:spanner::set-spacing-rods '+t
        if p=='hornOne' and m=='II' and n==2:t=r'\once \override Hairpin.minimum-length = #4 '+t
        if p.startswith('horn') and m=='II' and n==49:t=t.replace('"Soli"','"Solo"')
        if nokey:pre=without_key(pre);t=without_key(t)
        if p.startswith('trumpet') and modern:
            pre=without_key(pre);t=without_key(t)
            if m=='III' and n==17:pre='\\key c \\major '+pre
        if second:pre='';post=''
        if (km:=re.match(r'(\\key\s+[a-g][a-z]*\s+\\(?:major|minor))\s*',t)):
            pre+=' '+km[1];t=t[km.end():]
        # Existing absolute layout offsets are narrowly score presentation choices.
        t=re.sub(r'\\oneVoice\b','',t) if p!='viola' else t
        local_clefs={}
        if p=='bassoonOne':
            local_clefs={
                'I':{61:'tenor',74:'bass',85:'tenor',91:'bass',115:'tenor',134:'bass',144:'tenor',154:'bass'},
                'II':{3:'tenor',7:'bass',23:'tenor',28:'bass',43:'bass'},
                'IV':{58:'tenor',66:'bass'},
            }.get(m,{})
        if p=='cello':
            local_clefs={'I':{107:'tenor',115:'bass',184:'tenor',200:'bass'},'IV':{186:'tenor',191:'bass'}}.get(m,{})
        if p=='hornTwo':
            if m=='I' and not modern:local_clefs={63:'bass',65:'treble',232:'bass'}
            if m=='II':
                local_clefs={5:'treble',55:'bass'}
                if n==3:t=t.replace('g2',r'\clef bass g2')
            if m=='IV':local_clefs={50:'bass',65:'treble'}
        if modern and p.startswith('horn'):
            if m!='II':local_clefs=HORN_CLEFS[p,m]
        if modern and p=='hornTwo' and m=='III' and n==16:
            t=t.replace(' c4',r' \clef bass c4',1)
        # Upper Adagio writing starts at beat 3, after the preceding slur.
        if p=='bassoonOne' and m=='II' and n==34:
            t=t.replace("ges'2",r"\clef tenor ges'2",1)
        if n in local_clefs:pre+=' \\clef "'+local_clefs[n]+'"'
        if (p+m,n) in CUES and not second:
            q,z=CUES[p+m,n];quote_sources.add(q+m)
            # Quoted notes are transposed automatically to the recipient's reading key.
            qclef='treble' if q in ['flute','oboeOne','violinOne','violinTwo'] else clef(q)
            if p.startswith(('horn','trumpet')) or q=='violaSolo':qclef='treble'
            if p=='bassoonOne' and m=='IV' and n==138:qclef='bass'
            # Use bass/alto only for genuinely low cue sources; players see the cue clef.
            cuebars=[]
            rest_position=cue_rest_position(p,m,modern,q,n,z,qclef)
            for k in range(n,z+1):
                a,c=g[k]
                if nokey:a=without_key(a)
                if k==n:a=''
                cue_label=SHORT[q]+(' (8va)' if p=='bass' or (p.startswith('horn') and not modern and m!='II') or cue_octave_down(p,m,modern,q,n,z) else '')
                cuebars.append(a+' R'+dur+' '+c+(' \\noBreak' if k<z else '')+' |')
            # Temporary clefs must use the actual cue clef even when the player's
            # prevailing clef has changed locally (e.g. tenor-clef bassoon).
            cmd='\\cueDuringWithClef "'+q+m+'" #UP "'+qclef+'"'
            if p=='bass':cmd='\\cueClef "'+qclef+'" \\transposedCueDuring "'+q+m+'" #UP c\''
            if p.startswith('horn') and not modern and m!='II':cmd='\\cueClef "'+qclef+'" \\transposedCueDuring "'+q+m+'" #UP c\''
            if cue_octave_down(p,m,modern,q,n,z):
                # Explicit cue transpositions are themselves affected by the enclosing
                # written-note transpose. Compensate here; cueDuring's automatic
                # instrument transposition does not require this compensation.
                cue_pitch=("g" if m=='II' else "c'") if p.startswith('horn') else ('bes,' if m=='II' else 'c')
                cmd='\\cueClef "'+qclef+'" \\transposedCueDuring "'+q+m+'" #UP '+cue_pitch
            if m=='III' and n>=17:cmd=cmd.replace('"'+q+m+'"','"'+q+m+'trio"')
            # An unnecessary cue clef suppresses the repeated key signature
            # at the beginning of the modern trumpet's IV/156 system.
            if p=='trumpetOne' and modern and m=='IV' and n==156:
                cmd=cmd.replace('\\cueClef "treble" ','')
                cmd=cmd.replace('\\cueDuringWithClef "'+q+m+'" #UP "treble"','\\cueDuring "'+q+m+'" #UP')
            t='\\set Staff.weberCueId = "'+q+m+':'+str(n)+'" \\set Staff.weberCueLabel = "'+cue_label+'" '+cmd+' { \\voiceTwo \\override MultiMeasureRest.staff-position = #'+str(rest_position)+' '+' '.join(cuebars)+' \\revert MultiMeasureRest.staff-position } \\oneVoice'
            if (p,m,z+1) in [('hornTwo','I',63),('bassoonOne','I',115),('bassoonOne','IV',58)]:
                t=r'\omit Staff.CueEndClef '+t
            if p=='bass':t+=' \\cueClefUnset'
            if p.startswith('horn') and not modern and m!='II':t+=' \\cueClefUnset'
            if cue_octave_down(p,m,modern,q,start,z) and not (p=='trumpetOne' and modern and m=='IV' and start==156):t+=' \\cueClefUnset'
            post='';n=z+1
        elif not second and n in GP[m]:
            # Exactly two written bars, bounded separately from any adjoining wait.
            t='R'+dur+'*2';post=g[n+1][1];n+=2
        elif second and re.fullmatch(r's1',t):
            n+=1
            while n<=total and b[n]=='s1':n+=1
            t='s1*'+str(n-start)
        elif plain_rest(t) and not post:
            n+=1
            while n<=total:
                if [m,n-1] in PAGE_ENDS[p+('-modern' if modern else '')]:break
                if n in local_clefs:break
                a,c=g[n];u=b[n]
                if second:a='';c=''
                if nokey:a=without_key(a);u=without_key(u)
                if a or c or not plain_rest(u) or (p+m,n) in CUES or n in GP[m] or n-1 in GP[m]:break
                n+=1
            t='R'+dur+('*'+str(n-start) if n-start>1 else '')
        else:n+=1
        if m=='III' and not second:
            if n-1==16:post+=' \\once \\override Score.TextMark.direction = #DOWN \\textEndMark \\markup \\italic "Fine"'
            if n-1==36:post+=' \\once \\override Score.TextMark.direction = #DOWN \\once \\override Score.TextMark.staff-padding = #8 \\once \\override Score.TextMark.outside-staff-priority = #10000 \\textEndMark \\markup \\italic "Menuetto da capo"'
            else:post+=' \\noPageBreak'
        ident=p+('-modern' if modern else '')
        if not second and [m,n-1] in PAGE_ENDS[ident]:post+=' \\pageBreak'
        edits=OVERRIDES.get(p+('-modern' if modern else ''),{}).get(m,{})
        if str(n-1) in edits:post+=' '+edits[str(n-1)]

        # Explicitly reproduce the approved transition sample; other movements
        # retain their existing rhythmic spacing and automatic system choices.
        planned=TRANSITION_LINES.get(ident,{}).get(m)
        if planned is not None and not second:
            post+=r'\break' if n-1 in planned else r'\noBreak'
        music.append(f'\\barNumberCheck #{start} {pre} {t} {post} | % PART {m} {start}-{n-1}')
    music.append(f'\\barNumberCheck #{total+1}')
    tr=transpose(p,m,modern)
    return initial+'\\transpose '+tr+' {\n'+'\n'.join(music)+'\n}',quote_sources

def build(p,modern=False):
    ident=p+('-modern' if modern else '')
    title=NAMES[p]+(' — '+('F' if p.startswith('horn') else 'B-flat') if modern else ' — original C/F' if p.startswith('horn') else ' — original C/D' if p.startswith('trumpet') else '')
    src='\\version "2.26.0"\n\\language "nederlands"\n\\include "source-music.ily"\n'+LAYOUT
    if p=='bassoonOne':
        src+=r"\paper { page-count = #8 system-system-spacing.padding = #2.5 }"+'\n'
    if p=='timpani':
        src+=r'\paper { page-count = #4 }'+'\n'
    bodies=[];quotes=set()
    for m in COUNTS:
        music,qs=make_music(p,m,modern);quotes|=qs
        if m=='III':
            # Keep the native section boundary, but put Trio in the same mark as B.
            # Keep both sections on the same physical page for the da capo.
            a,z=music.split('\\barNumberCheck #17 ',1)
            a='\\bar ":|."'.join(a.rsplit('\\bar ":|.|:"',1))+'\\barNumberCheck #17\n}'
            z=re.sub(r'\\once \\override Staff.SectionLabel\.(?:staff-padding|font-size) = #[\d.]+\s*','',z)
            z=re.sub(r'\\once \\override Staff.SectionLabel\.[^=]+ = (?:#\'\(\)|##f|#LEFT|#[\d.]+)\s*','',z)
            z=re.sub(r'\\sectionLabel \\markup \\bold \\pad-around #0.4 "Trio"','',z)
            z=z.replace(r'''\mark \markup \override #'(box-padding . 0.4) \box \bold "B"''', r'''\mark \markup \line { \override #'(box-padding . 0.4) \box \bold "B" \hspace #0.6 \fontsize #-1.5 \bold "Trio" }''')
            trio_clef=clef(p)
            if modern and p.startswith('horn'):
                for k,c in sorted(HORN_CLEFS[p,m].items()):
                    if k<=17:trio_clef=c
            init='\\clef "'+trio_clef+'" \\transposition '+instrument_pitch(p,m,modern)+' \\time 3/4 \\set Score.currentBarNumber = #17 \\bar ".|:" '
            if not (p.startswith('horn') or (p.startswith('trumpet') and not modern) or p=='timpani'):
                init+='\\key '+('d' if p.startswith('trumpet') and modern else 'c')+' \\major '
            z=init+'\\transpose '+transpose(p,m,modern)+' {\n\\barNumberCheck #17 '+z
            for n,(section,heading) in enumerate([(a,TITLES[m]),(z,'Trio')]):
                staff='\\new Staff \\with { \\remove Page_turn_engraver } { '+section+' }'
                header='\\header { piece = "'+heading+'" title = ##f subtitle = ##f composer = ##f opus = ##f }'
                if n==1:header=header.replace('piece = "Trio"','piece = ##f')
                bodies.append('\\score {\n'+staff+'\n'+header+'\n'+(r'\layout { indent = 0\mm }' if n==1 else '')+'\n} '+('\\noPageBreak' if n==0 else '\\pageBreak' if (p,'III') in MOVEMENT_PAGE_BREAKS else ''))
            continue
        if p=='viola' and m=='II':
            # Both manuscript viola lines remain playable; the solo has its own staff.
            solo,qs=make_music(p,m,modern,second=True)
            staff='\\new StaffGroup << \\new Staff \\with { instrumentName = \\markup \\italic "Solo" \\RemoveAllEmptyStaves \\remove Page_turn_engraver \\remove Mark_engraver \\remove Metronome_mark_engraver \\remove Measure_spanner_engraver } { '+solo+' } \\new Staff \\with { instrumentName = "Vla." } { '+music+' } >>'
        else:staff='\\new Staff '+('\\with { \\remove Page_turn_engraver } ' if p=='flute' and m in ['II','IV'] else '')+'{ '+music+' }'
        head='\\header { piece = "'+TITLES[m]+'" title = ##f subtitle = ##f composer = ##f opus = ##f }'
        if p=='timpani' and m=='II':head=head.replace(TITLES[m],TITLES[m]+' (tacet)')
        if m=='I':head='\\header { title = "SYMPHONY No. 2" subtitle = ##f composer = "Carl Maria von Weber (1786–1826)" piece = "I. Allegro" }'
        local_layout=''
        if p=='viola' and m=='II':
            local_layout=r'''\layout {
              indent = 10\mm
              \context { \Score \consists Mark_engraver \consists Metronome_mark_engraver
                \override RehearsalMark.self-alignment-X = #LEFT
                \override RehearsalMark.staff-padding = #2
                \override MetronomeMark.staff-padding = #2 }
              \context { \Staff \remove Mark_engraver \remove Metronome_mark_engraver }
            }'''
        if p=='violinOne' and m=='II':
            local_layout=r'\layout { \context { \Score \override SpacingSpanner.spacing-increment = #1.3 \override SpacingSpanner.shortest-duration-space = #2.2 } }'
        bodies.append('\\score {\n'+staff+'\n'+head+'\n'+local_layout+'\n} '+('\\pageBreak' if (p,m) in MOVEMENT_PAGE_BREAKS else ''))
    for q in sorted(quotes):
        p0=re.sub(r'I[V]?$','',q) # resolve actual canonical name without ambiguous Roman stripping
        m0=next(m for m in ['III','II','IV','I'] if q.endswith(m));p0=q[:-len(m0)]
        src+='\\addQuote "'+q+'" { \\transposition '+instrument_pitch(p0,m0)+' \\'+q+' }\n'
        if m0=='III':
            src+='\\addQuote "'+q+'trio" { \\transposition '+instrument_pitch(p0,m0)+' '+ ' '.join(BARS[q][n]+' |' for n in range(17,37))+' }\n'
    src+='\\book {\n\\header { instrument = "'+title+'" tagline = ##f }\n'+'\n'.join(bodies)+'\n}\n'
    (D/(ident+'.ly')).write_text(src,encoding='utf-8')
    return dict(id=ident,player=p,title=title,modern=modern,source='sources/parts/'+ident+'.ly')

if __name__=='__main__':
    selected=sys.argv[1:]
    products=[]
    for p in NAMES:
        if not selected or p in selected:products.append(build(p))
        if p.startswith(('horn','trumpet')) and (not selected or p+'-modern' in selected):products.append(build(p,True))
    (D/'manifest.json').write_text(json.dumps(products,indent=2),encoding='utf-8')
    (D/'cue-ledger.json').write_text(json.dumps(cue_ledger,indent=2),encoding='utf-8')
    print('Built',len(products),'part sources; planned',len(cue_ledger),'cues in the 15 originals.')

