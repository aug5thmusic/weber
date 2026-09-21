"""Add part covers, a print index, duplex blanks, bookmarks and PDF labels."""
from pathlib import Path
import json,re,hashlib
from io import BytesIO
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.utils import simpleSplit
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle
from pypdf import PdfReader,PdfWriter
from pypdf.constants import PageLabelStyle
from pypdf.annotations import Link
import build_parts as b

D=b.D;W,H=648,864;M=20*72/25.4
import os
fontdir=Path(os.environ.get('WEBER_FONT_DIR','C:/Windows/Fonts'))
files=['times.ttf','timesbd.ttf','timesi.ttf']
if not all((fontdir/f).exists() for f in files):
 for candidate in ['/usr/share/fonts/truetype/liberation2','/usr/share/fonts/truetype/liberation']:
  if Path(candidate,'LiberationSerif-Regular.ttf').exists():
   fontdir=Path(candidate);files=['LiberationSerif-Regular.ttf','LiberationSerif-Bold.ttf','LiberationSerif-Italic.ttf'];break
if not all((fontdir/f).exists() for f in files):raise RuntimeError('Set WEBER_FONT_DIR to a folder containing times.ttf, timesbd.ttf and timesi.ttf, or install Liberation Serif.')
for face,file in zip(['Text','Bold','Italic'],files):pdfmetrics.registerFont(TTFont(face,str(fontdir/file)))
pdfmetrics.registerFontFamily('Text',normal='Text',bold='Bold',italic='Italic',boldItalic='Italic')
manifest=json.loads((D/'manifest.json').read_text());entries=[];cursor=3
ORDER={p:f'{i:02}' for i,p in enumerate(b.NAMES,1)}
PDFDIR=b.W/'Parts';PDFDIR.mkdir(exist_ok=True)
for item in manifest:
 item['number']=ORDER[item['player']]+(' alt.' if item['modern'] else '')
 suffix=(' - Modern F' if item['player'].startswith('horn') else ' - Modern B-flat') if item['modern'] else (' - Original C-F' if item['player'].startswith('horn') else ' - Original C-D' if item['player'].startswith('trumpet') else '')
 item['filename']=ORDER[item['player']]+' '+b.NAMES[item['player']]+'.pdf'
 r=PdfReader(D/(item['id']+'.pdf'));texts=[p.extract_text() for p in r.pages]
 starts={'I':2}
 for m in ['II','III','IV']:
  prefix={'II':'II. Adagio','III':'III. Menuetto','IV':'IV. Finale'}[m]
  hits=[n+2 for n,t in enumerate(texts) if prefix in t];assert len(hits)==1,(item['id'],m,hits)
  starts[m]=hits[0]
 n=len(r.pages);leaves=n+1;blank=leaves%2==1;total=leaves+int(blank)
 entries.append(dict(**item,start=cursor,end=cursor+total-1,music_pages=n,movements=starts,blank=blank,reader=r))
 cursor+=total

def center(c,text,y,size=14,font='Text'):
 c.setFont(font,size);c.drawCentredString(W/2,y,text)
def lines(c,text,x,y,width,size=11,leading=15,font='Text'):
 if '<i>' in text:
  paragraph=Paragraph(text,ParagraphStyle('CoverNote',fontName=font,fontSize=size,leading=leading))
  _,height=paragraph.wrap(width,1000)
  paragraph.drawOn(c,x,y-height+size)
  return y-height
 c.setFont(font,size)
 for line in simpleSplit(text,font,size,width):c.drawString(x,y,line);y-=leading
 return y
def publisher(c):
 center(c,'Augmented Fifth',118,12,'Bold');center(c,'the intersection between classical music & AI',101,10,'Italic');center(c,'http://aug5th.substack.com',85,10)
 center(c,'September 2026',70,10)
def make_cover(e):
 stream=BytesIO();c=canvas.Canvas(stream,pagesize=(W,H));c.setTitle(e['title'])
 center(c,'CARL MARIA VON WEBER',686,16)
 center(c,'SYMPHONY No. 2',635,27,'Bold');center(c,'in C major · J. 51',608,15)
 center(c,b.NAMES[e['player']],539,24,'Bold')
 if e['player'].startswith(('horn','trumpet')):
  center(c,e['title'].split(' — ')[1],508,14)
 else:center(c,'PERFORMANCE PART',508,11)
 y=452
 for m,txt in b.TITLES.items():
  c.setFont('Text',12);c.drawString(M+32,y,txt);c.drawRightString(W-M-32,y,str(e['movements'][m]));y-=24
 notes=['Small notes are cues.','Keep this cover when printing double-sided; music begins on page 2.']
 if e['player'].startswith(('horn','trumpet')):
  if e['modern']:notes.insert(0,'Modern alternative: '+b.keylabel(e['player'],'I',True)+', at the same sounding pitches as the original part.')
  else:notes.insert(0,'Movements I, III and IV: in C'+(' (basso)' if e['player'].startswith('horn') else '')+'. Movement II: '+b.keylabel(e['player'],'II')+'.')
 if e['player']=='viola':notes.append('In Adagio bars 2–10, the upper staff is the solo viola and the lower staff the accompanying viola line.')
 if e['player']=='bass':notes.append('Double bass sounds an octave lower than written. The written low C requires a C extension or a suitable five-string instrument.')
 if e['player'] in ['viola','cello']:notes.append('In the Finale, <i>Soli (sezione)</i> means the exposed full section; retain normal divisi. <i>Tutti</i> marks the orchestral return.')
 if '(8va)' in (D/(e['id']+'.ly')).read_text(encoding='utf-8'):
  notes.append('An 8va cue label means the source sounds an octave above the cue’s normal reading in this part.')
 if e['player'].startswith(('horn','trumpet')) and not e['modern']:
  alt=next(a for a in entries if a['player']==e['player'] and a['modern'])
  notes.append('The complete '+('F-horn' if e['player'].startswith('horn') else 'B-flat-trumpet')+' alternative follows at the end of this player PDF, starting on PDF page '+str(e['end']-e['start']+2)+'. Each version has its own page numbering.')
 if e['player']=='timpani':notes.insert(0,'Timpani in C and G. The Adagio is tacet; its rehearsal points and fermatas are retained for orientation.')
 y=330
 for note in notes:y=lines(c,note,M+18,y,W-2*M-36,11,15)-10
 assert y>=145,(e['id'],'cover notes approach publisher credit',y)
 publisher(c);c.showPage();c.save();stream.seek(0);return PdfReader(stream)

front=BytesIO();c=canvas.Canvas(front,pagesize=(W,H))
center(c,'CARL MARIA VON WEBER',691,17)
center(c,'SYMPHONY No. 2',639,28,'Bold');center(c,'in C major · J. 51',610,16)
center(c,'ORCHESTRAL PARTS',523,19,'Bold')
center(c,'Original parts and modern brass alternatives',491,14)
center(c,'15 player PDFs · 4 appended brass alternatives',464,12)
y=349
for text in ['9 × 12 inches · 7.5 mm staves · 20 mm margins','Print at 100% on 9 × 12 inch paper, double-sided, flipping on the long edge.','Use the complete part ranges on the next page. Each range includes its cover and any blank verso needed for the planned page turns.','The modern F-horn and B-flat-trumpet alternatives follow their corresponding original parts.']:
 y=lines(c,text,M+30,y,W-2*M-60,12,17)-16
publisher(c);c.showPage()
center(c,'PRINT INDEX',791,19,'Bold')
c.setFont('Text',10);c.drawString(M,763,'Ranges refer to physical PDF pages, counting this volume’s title as page 1.')
c.setFont('Bold',11);c.drawString(M,731,'Part');c.drawRightString(W-M,731,'PDF pages')
c.setLineWidth(.5);c.line(M,720,W-M,720)
index_rects=[];y=699
for e in entries:
 c.setFont('Text',11);c.drawString(M,y,e['number']+'  '+e['title']);c.drawRightString(W-M,y,f"{e['start']}–{e['end']}")
 index_rects.append((e,(M,y-4,W-M,y+13)));y-=21
lines(c,'Print each complete range as a separate part. Each part’s own numbering starts with its cover (page 1, with no printed number); the music begins on page 2.',M,y-18,W-2*M,11,15)
lines(c,'Cues, practical clefs, rehearsal letters and G.P. labels are editorial aids. Engraving Notes in the full score explain selected musical decisions.',M,152,W-2*M,10,14)
c.setFont('Text',10);c.drawCentredString(W/2,63,'ii');c.showPage();c.save();front.seek(0)

w=PdfWriter();w.append(PdfReader(front));w.set_page_label(0,1,style=PageLabelStyle.LOWERCASE_ROMAN,start=1)
w.add_outline_item('Volume title',0);w.add_outline_item('Print index',1)
index=[]
for e in entries:
 start=len(w.pages);assert start+1==e['start'] and start%2==0
 w.append(make_cover(e),import_outline=False)
 for page in e['reader'].pages:
  # Point-and-click paths are for the local engraving proof, not the distributed PDF.
  if '/Annots' in page:del page['/Annots']
  w.add_page(page)
 prefix=b.SHORT[e['player']]+(' F' if e['modern'] and e['player'].startswith('horn') else ' Bb' if e['modern'] else '')+' '
 w.set_page_label(start,len(w.pages)-1,style=PageLabelStyle.DECIMAL,prefix=prefix,start=1)
 parent=w.add_outline_item(e['title'],start)
 for m,partpage in e['movements'].items():w.add_outline_item(b.TITLES[m],start+partpage-1,parent=parent)
 if e['blank']:
  w.add_blank_page(width=W,height=H);w.set_page_label(len(w.pages)-1,len(w.pages)-1,prefix=prefix+'blank')
 index.append({k:v for k,v in e.items() if k not in ['reader','source']})
for e,rect in index_rects:
 annotation=w.add_annotation(page_number=1,annotation=Link(rect=rect,target_page_index=e['start']-1))
 # Internal explicit destinations reference a page object, rather than a remote-style page number.
 annotation['/Dest'][0]=w.pages[e['start']-1].indirect_reference
w.add_metadata({'/Title':'Weber — Symphony No. 2: Orchestral parts','/Author':'Carl Maria von Weber','/Subject':'15 original player parts with F-horn and B-flat-trumpet alternatives; Augmented Fifth edition','/Creator':'LilyPond 2.26.0; Augmented Fifth edition'})
out=PDFDIR/'00 Weber Symphony No. 2 - Complete Parts.pdf'
with out.open('wb') as f:w.write(f)
(D/'print-index.json').write_text(json.dumps(index,indent=2),encoding='utf-8')
check=PdfReader(out);assert len(check.pages)==cursor-1
assert all(abs(float(p.mediabox.width)-W)<.05 and abs(float(p.mediabox.height)-H)<.05 for p in check.pages)
assert len(check.pages[1].get('/Annots',[]))==19
print('Parts volume:',len(check.pages),'pages;',sum(e['music_pages'] for e in entries),'music pages;',len(entries),'versions.')
individuals=[]
for player in b.NAMES:
 group=[e for e in entries if e['player']==player]
 begin=group[0]['start']-1;end=group[-1]['end'];part=PdfWriter()
 for n in range(begin,end):part.add_page(check.pages[n])
 for e in group:
  local=e['start']-1-begin
  prefix=('F ' if player.startswith('horn') else 'Bb ') if e['modern'] else 'Original ' if player.startswith(('horn','trumpet')) else ''
  part.set_page_label(local,local+e['music_pages'],style=PageLabelStyle.DECIMAL,prefix=prefix,start=1)
  if e['blank']:part.set_page_label(e['end']-1-begin,e['end']-1-begin,prefix=prefix+'blank')
  parent=part.add_outline_item(e['title'],local)
  for m,n in e['movements'].items():part.add_outline_item(b.TITLES[m],local+n-1,parent=parent)
 part.add_metadata({'/Title':'Weber - Symphony No. 2: '+b.NAMES[player],'/Author':'Carl Maria von Weber','/Creator':'LilyPond 2.26.0; Augmented Fifth edition'})
 target=PDFDIR/group[0]['filename']
 with target.open('wb') as f:part.write(f)
 single=PdfReader(target)
 assert len(single.pages)==end-begin and len(single.pages)%2==0
 for j,page in enumerate(single.pages):
  original=check.pages[begin+j]
  assert page.get_contents().get_data()==original.get_contents().get_data() if page.get_contents() else not original.get_contents()
  assert page.mediabox==original.mediabox
 individuals.append(dict(filename=target.name,player=player,pages=len(single.pages),music_pages=sum(e['music_pages'] for e in group),combined_start=begin+1,combined_end=end,versions=[dict(id=e['id'],start=e['start']-begin,end=e['end']-begin,music_pages=e['music_pages'],movements=e['movements']) for e in group],content_matches_volume=True))
(D/'individual-pdfs.json').write_text(json.dumps(individuals,indent=2),encoding='utf-8')
assert len(individuals)==15
print('Exported and content-verified',len(individuals),'numbered player PDFs; brass alternatives appended.')
