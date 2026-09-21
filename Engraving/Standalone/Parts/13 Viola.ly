% Self-contained Weber Symphony No. 2 performance part.
% Compile this file directly with LilyPond 2.26.0; no project include files are needed.
% Music begins on page 2; keep the cover and any final blank for the planned turns.
% The embedded library supports quoted cues. The performed music follows below
% in the music bookpart, with PART movement/bar comments.
\version "2.26.0"
\language "nederlands"
% BEGIN embedded music and cue donor library (formerly source-music.ily)
\version "2.26.0"
\language "nederlands"
% A real turn Script and shared engraving helpers.

% Use LilyPond's normal tie geometry. Redundant accidentals on tied
% continuations are hidden at system starts, so the tip can meet the head
% without a steep detour around a repeated accidental.
% A stencil tweak keeps the actual p dynamic event (including playback and
% shared-staff merging) while engraving the expression on the same baseline.
#(define (weber-p-dolce grob)
   (grob-interpret-markup grob
     (make-concat-markup (list (make-dynamic-markup "p") (make-hspace-markup 0.6)
                           (make-normal-text-markup (make-italic-markup "dolce"))))))

% Center the p glyph on its normal dynamic anchor; retain the full phrase's
% extent for collision avoidance and hairpin attachment.
#(define (weber-p-dolce-alignment grob)
   (let* ((p (grob-interpret-markup grob (make-dynamic-markup "p")))
          (phrase (weber-p-dolce grob))
          (p-x (ly:stencil-extent p X))
          (all-x (ly:stencil-extent phrase X)))
     (- (/ (- (cdr p-x) (car p-x)) (- (cdr all-x) (car all-x))) 1)))

% A real turn Script, with its lower-neighbour natural as one compact stencil.
% The accidental is centered below the turn; it is not a separate TextScript.
#(define (weber-turn-natural grob)
   (let* ((turn (ly:script-interface::print grob))
          (natural (grob-interpret-markup grob
                    (markup #:fontsize -3 #:musicglyph "accidentals.natural")))
          (turn-centered (ly:stencil-aligned-to turn X CENTER))
          (natural-centered (ly:stencil-aligned-to natural X CENTER)))
     (ly:stencil-combine-at-edge turn-centered Y DOWN natural-centered 0.15)))
turnNatural = -\tweak stencil #weber-turn-natural -\tweak padding #0.4 -\tweak avoid-slur #'outside \turn

% General pauses are global musical annotations, shared by score and parts.
% These spans are bounded by bar columns, so the label follows the two-bar span.
#(define (weber-general-pause-print grob)
   (let* ((left (ly:spanner-bound grob LEFT))
          (right (ly:spanner-bound grob RIGHT))
          (reference (ly:grob-common-refpoint left right X))
          (start (if (= (ly:item-break-dir left) RIGHT)
                     (cdr (ly:grob-extent left reference X))
                     (ly:grob-relative-coordinate left reference X)))
          (end (ly:grob-relative-coordinate right reference X))
          (origin (ly:grob-relative-coordinate grob reference X))
          (label (grob-interpret-markup grob (markup #:bold "G.P."))))
     (if (< (- end start) 1)
         empty-stencil
         (ly:stencil-translate-axis
          (ly:stencil-aligned-to label X CENTER)
          (- (/ (+ start end) 2) origin) X))))

% Keep the Trio heading on the rehearsal mark's baseline, to its right.
#(define (weber-trio-mark grob)
   (ly:stencil-combine-at-edge
    (ly:text-interface::print grob) X RIGHT
    (grob-interpret-markup grob (markup #:bold "Trio")) 1.5))

% Enlarge the opening title upwards within its existing vertical footprint.
#(define-markup-command (weber-opening-title layout props) ()
   (let* ((old (interpret-markup layout props (markup "I. Allegro")))
          (new (interpret-markup layout props (markup #:abs-fontsize 36 #:bold "SYMPHONY NO. 2")))
          (old-y (ly:stencil-extent old Y))
          (new-y (ly:stencil-extent new Y))
          (placed (ly:stencil-translate-axis new (- (car old-y) (car new-y)) Y)))
     (ly:make-stencil (ly:stencil-expr placed) (ly:stencil-extent placed X) old-y)))

fluteI = {
\barNumberCheck #1 \key c \major c'''4..\ff c'''16 e'''4.. e'''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f'''4-. a'''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g''4\pp g''8. g''16 g''4 g''4 | % m. 3; MIDI bar 3
\barNumberCheck #4 d'''2(-> g''4) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g''4..\ff g''16 b''4.. b''16 | % m. 5; MIDI bar 5
\barNumberCheck #6 d'''4-. f'''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g''4\pp g''8. g''16 g''4 g''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c'''2 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 r4 fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 c'''8 r8 r4 r2 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 r4 fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 c'''8 r8 r4 r2 | % m. 26; MIDI bar 26
\barNumberCheck #27 c''4\ff c'''4 r4 g''4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c''8 c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c''4 r4 r2 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1 | % m. 31; MIDI bar 31
\barNumberCheck #32 b'8\< c''8 d''8 e''8 f''8 g''8 a''8 b''8 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'''4..\ff c'''16 e'''4.. e'''16 | % m. 33; MIDI bar 33
\barNumberCheck #34 e'''4-. e'''4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g''4.. g''16 b''4.. b''16 | % m. 35; MIDI bar 35
\barNumberCheck #36 d'''4-. f'''4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 a''4.. a''16 c'''4.. c'''16 | % m. 37; MIDI bar 37
\barNumberCheck #38 e'''4-. e'''4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 g''4.. g''16 b''4.. b''16 | % m. 39; MIDI bar 39
\barNumberCheck #40 e'''4-. e'''4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c''4 e'''8. e'''16 e'''4 e'''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 d'''1 | % m. 42; MIDI bar 42
\barNumberCheck #43 c'''8 d''16( e''16 fis''16 g''16 a''16 b''16 c'''2)->~ | % m. 43; MIDI bar 43
\barNumberCheck #44 c'''8 d''16( e''16 fis''16 g''16 a''16 b''16 c'''2)->( | % m. 44; MIDI bar 44
\barNumberCheck #45 b''4) bes''4(-> a''4) cis'''4(-> | % m. 45; MIDI bar 45
\barNumberCheck #46 d'''4) bes''4(-> a''4) cis'''4(-> | % m. 46; MIDI bar 46
\barNumberCheck #47 d'''8) r8 r4 r2 | % m. 47; MIDI bar 47
\barNumberCheck #48 r8_\markup \italic "cresc." fis''8\<( g''8 gis''8 a''8\!-.) a''8\<( bes''8 b''8 | % m. 48; MIDI bar 48
\barNumberCheck #49 c'''16\ff b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16) | % m. 49; MIDI bar 49
\barNumberCheck #50 c'''4-. fis'''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1 | % m. 59; MIDI bar 59
\barNumberCheck #60 R1 | % m. 60; MIDI bar 60
\barNumberCheck #61 R1 | % m. 61; MIDI bar 61
\barNumberCheck #62 R1 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 ees''2-\tweak stencil #weber-p-dolce -\tweak self-alignment-X #weber-p-dolce-alignment \p^\markup \italic "Soli"~ ees''8 f''16( ees''16) d''8-. c''8-. | % m. 69; MIDI bar 69
\barNumberCheck #70 f''2 \grace { f''8^( } ees''8 d''8 ees''8 c''8) | % m. 70; MIDI bar 70
\barNumberCheck #71 \after 4 \turn bes'2 d''4(-> c''4) | % m. 71; MIDI bar 71
\barNumberCheck #72 b'2~ b'8( c''8 d''8 ees''8) | % m. 72; MIDI bar 72
\barNumberCheck #73 \after 8 \turnNatural f''4( f''8. g''16 aes''4) r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 r8 b''8-.\p c'''8-. cis'''8-. d'''8-. r8 r4 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 b''8\f r8 c'''8 r8 a''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 r2 r8 b''8-.\p c'''8-. cis'''8-. | % m. 79; MIDI bar 79
\barNumberCheck #80 d'''8-. r8 r4 r2 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 b''8\f r8 c'''8 r8 a''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g''8\ff g''16 g''16 aes''8-. g''8-. a''8-. g''8-. bes''8-. g''8-. | % m. 83; MIDI bar 83
\barNumberCheck #84 b''8-. g''8-. c'''8-. g''8-. cis'''8-. g''8-. d'''8-. g''8-. | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'''4.. ees'''16 ees'''4.. ees'''16 | % m. 85; MIDI bar 85
\barNumberCheck #86 ees'''4 ees'''2.-> | % m. 86; MIDI bar 86
\barNumberCheck #87 ees'''4.. ees'''16 ees'''4.. ees'''16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees'''4 ees'''2.-> | % m. 88; MIDI bar 88
\barNumberCheck #89 ees'''4 ees'''8. ees'''16 ees'''4 ees'''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 ees'''2(-> d'''4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c'''4\ff c'''8. c'''16 c'''4 c'''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c'''2(-> b''8-.) r8 b''4 | % m. 92; MIDI bar 92
\barNumberCheck #93 b''4. b''8 c'''4. d'''8 | % m. 93; MIDI bar 93
\barNumberCheck #94 e'''4 fis'''4 g'''4 e'''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d'''4 d'''4 r4 b''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 g''4 r4 d''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 g''16( fis''16 e''16 d''16 cis''16 d''16 e''16 fis''16 g''16 fis''16 g''16 a''16 b''16 a''16 b''16 c'''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'''4 e'''4 d'''4 fis'''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g'''1 | % m. 99; MIDI bar 99
\barNumberCheck #100 g''1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g''4.. g''16 b''4.. d'''16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g'''4 g'''4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 e''2\p^\markup \italic "Solo"~ e''8( fis''16 e''16) dis''8-. e''8-. | % m. 107; MIDI bar 107
\barNumberCheck #108 g''8-. b'8-. e''4.-> b'8-. cis''8-. dis''8-. | % m. 108; MIDI bar 108
\barNumberCheck #109 e''8-. fis''8-. g''8-. a''8-. b''4-. b''4-. | % m. 109; MIDI bar 109
\barNumberCheck #110 c'''2(-> dis''4) r4 | % m. 110; MIDI bar 110
\barNumberCheck #111 a''2~ a''8 g''8-. fis''8-. e''8-. | % m. 111; MIDI bar 111
\barNumberCheck #112 dis''2~ dis''8 b'8 c''8(-> b'8) | % m. 112; MIDI bar 112
\barNumberCheck #113 dis''8( e''8 fis''8 g''8 a''8 b''8 c'''8.) b''16 | % m. 113; MIDI bar 113
\barNumberCheck #114 a''2( g''8) \grace { c''16( b'16 ais'16 } b'8) e''8-. fis''8-. | % m. 114; MIDI bar 114
\barNumberCheck #115 g''4-.( g''4-. g''4-. g''4-.) | % m. 115; MIDI bar 115
\barNumberCheck #116 b''4.( a''8 g''4) r4 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 r2 r8 b'8-.^\markup \italic "risoluto" b'8-. b'8-. | % m. 118; MIDI bar 118
\barNumberCheck #119 e''2-> \grace { e''8 } e'''2-> | % m. 119; MIDI bar 119
\barNumberCheck #120 b'2~ b'8 fis'8-. gis'8-. a'8-. | % m. 120; MIDI bar 120
\barNumberCheck #121 b'8-. dis''8-. e''8-. fis''8-. g''4.-> ais'8 | % m. 121; MIDI bar 121
\barNumberCheck #122 b'2\ff b''2~ | % m. 122; MIDI bar 122
\barNumberCheck #123 b''8 fis'''8( e'''8 d'''8 cis'''8 b''8 ais''8 b''8) | % m. 123; MIDI bar 123
\barNumberCheck #124 cis'''1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 cis'''8 e'''8( d'''8 cis'''8 b''8 ais''8 gis''8 ais''8) | % m. 125; MIDI bar 125
\barNumberCheck #126 b''1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 b''8 fis'''8( e'''8 d'''8 cis'''8 b''8 ais''8 b''8) | % m. 127; MIDI bar 127
\barNumberCheck #128 cis'''1 | % m. 128; MIDI bar 128
\barNumberCheck #129 r8 fis''8( f''8 ees''8 d''8 c''8 b'8 c''8) | % m. 129; MIDI bar 129
\barNumberCheck #130 a''1 | % m. 130; MIDI bar 130
\barNumberCheck #131 r8 c''8( bes'8 a'8 g'8 f'8 e'8 f'8) | % m. 131; MIDI bar 131
\barNumberCheck #132 des''1~ | % m. 132; MIDI bar 132
\barNumberCheck #133 des''8 f''8( ees''8 des''8 c''8 bes'8 a'8 bes'8) | % m. 133; MIDI bar 133
\barNumberCheck #134 d'''1\f~ | % m. 134; MIDI bar 134
\barNumberCheck #135 d'''8 f'''8( ees'''8 d'''8 c'''8 bes''8 a''8 bes''8) | % m. 135; MIDI bar 135
\barNumberCheck #136 ees'''1~ | % m. 136; MIDI bar 136
\barNumberCheck #137 ees'''8 g'''8( f'''8 ees'''8 d'''8 ees'''8 f'''8 ees'''8) | % m. 137; MIDI bar 137
\barNumberCheck #138 d'''1~ | % m. 138; MIDI bar 138
\barNumberCheck #139 d'''8 g'''8( f'''8 ees'''8 d'''8 c'''8 b''8 f'''8) | % m. 139; MIDI bar 139
\barNumberCheck #140 ees'''1~ | % m. 140; MIDI bar 140
\barNumberCheck #141 ees'''8 g'8( g''8 f''8 ees''8 d''8 ees''8 c''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 b'8 g''16( a''16 b''16 c'''16 d'''16 ees'''16 f'''2)->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 f'''8 g''16( a''16 b''16 c'''16 d'''16 ees'''16 f'''2)-> | % m. 143; MIDI bar 143
\barNumberCheck #144 f'''4 ees'''2-> ees'''4-> | % m. 144; MIDI bar 144
\barNumberCheck #145 ges'''1-> | % m. 145; MIDI bar 145
\barNumberCheck #146 f'''1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 f'''1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g''4\pp g''8. g''16 g''4 g''4 | % m. 152; MIDI bar 152
\barNumberCheck #153 d'''2(-> g''8) r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'''4..\ff c'''16 e'''4.. e'''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f'''4-. a'''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g''4\pp g''8. g''16 g''4 g''4 | % m. 156; MIDI bar 156
\barNumberCheck #157 d'''2(-> g''4) r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g''4..\ff g''16 b''4.. b''16 | % m. 158; MIDI bar 158
\barNumberCheck #159 d'''4-. f'''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g''4\pp g''8. g''16 g''4 g''4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c'''2 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 fis''4.\!\sf-> g''8-.\p a''8-. b''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 c'''8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c'''8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 c''4\ff c'''4 r4 g''4 | % m. 176; MIDI bar 176
\barNumberCheck #177 c''8 c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c''4 r4 r2 | % m. 178; MIDI bar 178
\barNumberCheck #179 R1 | % m. 179; MIDI bar 179
\barNumberCheck #180 R1 | % m. 180; MIDI bar 180
\barNumberCheck #181 r8 b''8\<( c'''8 cis'''8\!) d'''8-. d'''8\<( ees'''8 e'''8\!) | % m. 181; MIDI bar 181
\barNumberCheck #182 f'''16(\ff e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16) | % m. 182; MIDI bar 182
\barNumberCheck #183 f'''4-. f'''4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 R1 | % m. 191; MIDI bar 191
\barNumberCheck #192 b''2\p^\markup \italic "Solo" a''8( g''8 fis''8 g''8) | % m. 192; MIDI bar 192
\barNumberCheck #193 e''4.( fis''8 gis''8 a''8 b''8 c'''8) | % m. 193; MIDI bar 193
\barNumberCheck #194 d'''1(-> | % m. 194; MIDI bar 194
\barNumberCheck #195 g''4) r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 R1 | % m. 196; MIDI bar 196
\barNumberCheck #197 R1 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 e'2(\p g'2 | % m. 200; MIDI bar 200
\barNumberCheck #201 f'2 aes'2) | % m. 201; MIDI bar 201
\barNumberCheck #202 f'1 | % m. 202; MIDI bar 202
\barNumberCheck #203 ees'2( f'2 | % m. 203; MIDI bar 203
\barNumberCheck #204 g'2 aes'2) | % m. 204; MIDI bar 204
\barNumberCheck #205 g'1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 R1 | % m. 209; MIDI bar 209
\barNumberCheck #210 R1 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 e'''8\f r8 f'''8 r8 d'''8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 r2 r8 e'''8-.\p f'''8-. fis'''8-. | % m. 212; MIDI bar 212
\barNumberCheck #213 g'''8 r8 r4 r2 | % m. 213; MIDI bar 213
\barNumberCheck #214 R1 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 e'''8\f r8 f'''8 r8 d'''8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'''8\ff c'''16 c'''16 des'''8-. c'''8-. d'''8-. c'''8-. ees'''8-. c'''8-. | % m. 216; MIDI bar 216
\barNumberCheck #217 e'''8-. c'''8-. f'''8-. c'''8-. fis'''8-. c'''8-. g'''8-. c'''8-. | % m. 217; MIDI bar 217
\barNumberCheck #218 aes'''4.. aes'''16 aes'''4.. aes'''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 aes'''4 aes'''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 aes'''4.. aes'''16 aes'''4.. aes'''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes'''4 aes'''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 aes'''4 aes'''8. aes'''16 aes'''4 aes'''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 aes'''2(-> g'''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 f'''4\f f'''8. f'''16 f'''4 f'''4 | % m. 224; MIDI bar 224
\barNumberCheck #225 f'''2(-> e'''8) r8 e'''4 | % m. 225; MIDI bar 225
\barNumberCheck #226 e'''4. e'''8 f'''4. g'''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 a'''4 b''4-. c'''4-. a''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g''4 c'''4 r4 g''4 | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g'16 a'16 b'16 c''16 d''16 e''16 f''16 g''16 c''16 d''16 e''16 f''16 g''16 a''16 b''16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'''16 b''16 a''16 g''16 fis''16 g''16 a''16 b''16 c'''16 b''16 c'''16 d'''16 e'''16 d'''16 e'''16 f'''16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'''4 a'''4 g'''4 b''4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'''4..\ff c''16 e''4.. e''16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g''4 g''2 g''4 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'''4.. c'''16 e'''4.. e'''16 | % m. 234; MIDI bar 234
\barNumberCheck #235 g'''2 e'''2 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'''4 r4 c'''4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c''1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
oboeOneI = {
\barNumberCheck #1 \key c \major g''4..\ff g''16 a''4.. a''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 a''4-. a''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 d''4\pp d''8. d''16 d''4 d''4 | % m. 3; MIDI bar 3
\barNumberCheck #4 d''2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 d''4..\ff d''16 g''4.. g''16 | % m. 5; MIDI bar 5
\barNumberCheck #6 b''4-. d'''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 d''4\pp d''8. d''16 d''4 d''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c''2^\markup \italic "Solo"~ c''8( d''16 c''16) b'8 c''8 | % m. 8; MIDI bar 8
\barNumberCheck #9 e''8 g'8 c''4~ c''8 g'8-. a'8-. b'8-. | % m. 9; MIDI bar 9
\barNumberCheck #10 c''8-. d''8-. e''8-. f''8-. g''4 g''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 aes''2( b'4) r4 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 r2 r8 g'8-.\pp c''8-. d''8-. | % m. 15; MIDI bar 15
\barNumberCheck #16 e''4-.(\pp\< e''4-. e''4-. e''4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 g''4.(\!->\> f''8 e''8)\! g'8-. c''8-. d''8-. | % m. 17; MIDI bar 17
\barNumberCheck #18 e''4-.(\pp\< e''4-. e''4-. e''4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 a''4.(\!->\> g''8 e''8)\! g'8-. c''8-. d''8-. | % m. 19; MIDI bar 19
\barNumberCheck #20 e''8 r8 e''4(\< d''4 e''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 f''4) fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 c'''8 r8 a''8 r8 g''8 r8 f''8 r8 | % m. 22; MIDI bar 22
\barNumberCheck #23 f''4.(-> g''16 f''16 e''8) g'8-. c''8-. d''8-. | % m. 23; MIDI bar 23
\barNumberCheck #24 e''8 r8 e''4(\< d''4 e''4 | % m. 24; MIDI bar 24
\barNumberCheck #25 f''4) fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 c'''8 r8 a''8 r8 g''8 r8 b'8 r8 | % m. 26; MIDI bar 26
\barNumberCheck #27 c''8\ff c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c''8 c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c'8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'4 fis'4 g'4 e''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 f''16( e''16 f''16 e''16 f''16 e''16 f''16 e''16) f''8 e''8 d''8 c''8 | % m. 31; MIDI bar 31
\barNumberCheck #32 b'8\< c''8 d''8 e''8 f''8 g''8 a''8 b''8 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'''4..\ff c'''16 c'''4.. c'''16 | % m. 33; MIDI bar 33
\barNumberCheck #34 e'''4-. e'''4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g''4.. g''16 g''4.. g''16 | % m. 35; MIDI bar 35
\barNumberCheck #36 b''4-. d'''4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 a''4.. a''16 a''4.. a''16 | % m. 37; MIDI bar 37
\barNumberCheck #38 a''4-. a''4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 g''4.. g''16 g''4.. g''16 | % m. 39; MIDI bar 39
\barNumberCheck #40 g''4-. g''4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c''4 g''8. g''16 g''4 g''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 g''1 | % m. 42; MIDI bar 42
\barNumberCheck #43 fis''8 d''16( e''16 fis''16 g''16 a''16 b''16 c'''2)->~ | % m. 43; MIDI bar 43
\barNumberCheck #44 c'''8 d''16( e''16 fis''16 g''16 a''16 b''16 c'''2)->( | % m. 44; MIDI bar 44
\barNumberCheck #45 b''4) bes''4(-> a''4) cis'''4(-> | % m. 45; MIDI bar 45
\barNumberCheck #46 d'''4) bes''4(-> a''4) g''4(-> | % m. 46; MIDI bar 46
\barNumberCheck #47 fis''8) fis'8\<( g'8 gis'8 a'8\!-.) a'8\<( bes'8 b'8 | % m. 47; MIDI bar 47
\barNumberCheck #48 c''8-.)\!_\markup \italic "cresc." fis''8\<( g''8 gis''8 a''8\!-.) a''8\<( bes''8 b''8 | % m. 48; MIDI bar 48
\barNumberCheck #49 c'''16\ff b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16) | % m. 49; MIDI bar 49
\barNumberCheck #50 c'''4-. c'''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 \partCombineApart fis''2(^\markup \italic "Solo"-\tweak stencil #weber-p-dolce -\tweak self-alignment-X #weber-p-dolce-alignment \p e''8 d''8 cis''8 d''8) | % m. 59; MIDI bar 59
\barNumberCheck #60 b'4.( cis''8 dis''8 e''8 fis''8 g''8) | % m. 60; MIDI bar 60
\barNumberCheck #61 a''1(-> | % m. 61; MIDI bar 61
\barNumberCheck #62 d''4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 \partCombineAutomatic R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 \partCombineApart c''1(\pp | % m. 69; MIDI bar 69
\barNumberCheck #70 bes'2 c''2 | % m. 70; MIDI bar 70
\barNumberCheck #71 d''2 ees''2 | % m. 71; MIDI bar 71
\barNumberCheck #72 d''4) r4 r2 | % m. 72; MIDI bar 72
\barNumberCheck #73 \partCombineAutomatic R1 | % m. 73; MIDI bar 73
\barNumberCheck #74 g''4\p^\markup \italic "Solo" g''8. g''16 g''4 g''4 | % m. 74; MIDI bar 74
\barNumberCheck #75 bes''2( cis''2) | % m. 75; MIDI bar 75
\barNumberCheck #76 d''8-. r8 r4. b'8-.\p c''8-. cis''8-. | % m. 76; MIDI bar 76
\barNumberCheck #77 d''8-. r8 r4 r2 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 b''8\f r8 c'''8 r8 a''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 r8 b'8-.\p c''8-. cis''8-. d''8-. r8 r4 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 b''8\f r8 c'''8 r8 a''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g''8\ff g''16 g''16 aes''8-. g''8-. a''8-. g''8-. bes''8-. g''8-. | % m. 83; MIDI bar 83
\barNumberCheck #84 b''8-. g''8-. c'''8-. g''8-. cis'''8-. g''8-. d'''8-. g''8-. | % m. 84; MIDI bar 84
\barNumberCheck #85 a''4.. a''16 a''4.. a''16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a''4 a''2.-> | % m. 86; MIDI bar 86
\barNumberCheck #87 a''4.. a''16 a''4.. a''16 | % m. 87; MIDI bar 87
\barNumberCheck #88 a''4 a''2.-> | % m. 88; MIDI bar 88
\barNumberCheck #89 \partCombineApart a''4 a''8. a''16 a''4 a''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 a''2(-> g''4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 \partCombineAutomatic fis''4\ff fis''8. fis''16 fis''4 fis''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 fis''2->~ fis''8-. r8 fis''4 | % m. 92; MIDI bar 92
\barNumberCheck #93 g''8-. fis''8-. g''8-. f''8-. e''8-. f''8-. e''8-. d''8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e''4 a''4 b''4 a''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 b''4 b''4 r4 g''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 b'4 d''16 g'16 a'16 b'16 c''16 d''16 e''16 fis''16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g''16( fis''16 e''16 d''16 cis''16 d''16 e''16 fis''16 g''16 fis''16 g''16 a''16 b''16 a''16 b''16 c'''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'''4 g''4 b''4 a''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 b''1 | % m. 99; MIDI bar 99
\barNumberCheck #100 g''1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g''4.. g''16 g''4.. g''16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g''4 g''4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 fis''1\ff~ | % m. 122; MIDI bar 122
\barNumberCheck #123 fis''8 fis''8( e''8 d''8 cis''8 b'8 ais'8 b'8) | % m. 123; MIDI bar 123
\barNumberCheck #124 fis''1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 fis''8 e''8( d''8 cis''8 b'8 ais'8 gis'8 ais'8) | % m. 125; MIDI bar 125
\barNumberCheck #126 fis''1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 fis''8 fis''8( e''8 d''8 cis''8 b'8 ais'8 b'8) | % m. 127; MIDI bar 127
\barNumberCheck #128 ees''1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 ees''8 fis''8( f''8 ees''8 d''8 c''8 b'8 c''8) | % m. 129; MIDI bar 129
\barNumberCheck #130 ees''1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 ees''8 c''8( bes'8 a'8 g'8 f'8 e'8 f'8) | % m. 131; MIDI bar 131
\barNumberCheck #132 des''1~ | % m. 132; MIDI bar 132
\barNumberCheck #133 des''8 f''8( ees''8 des''8 c''8 bes'8 a'8 bes'8) | % m. 133; MIDI bar 133
\barNumberCheck #134 aes''1\f~ | % m. 134; MIDI bar 134
\barNumberCheck #135 aes''8 f''8( ees''8 d''8 c''8 bes'8 a'8 bes'8) | % m. 135; MIDI bar 135
\barNumberCheck #136 ees''1~ | % m. 136; MIDI bar 136
\barNumberCheck #137 ees''8 g''8( f''8 ees''8 d''8 ees''8 f''8 ees''8) | % m. 137; MIDI bar 137
\barNumberCheck #138 f''1~ | % m. 138; MIDI bar 138
\barNumberCheck #139 f''8 g''8( f''8 ees''8 d''8 c''8 b'8 f''8) | % m. 139; MIDI bar 139
\barNumberCheck #140 ees''1~ | % m. 140; MIDI bar 140
\barNumberCheck #141 ees''8 g'8( g''8 f''8 ees''8 d''8 ees''8 c''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 b'8 g'16( a'16 b'16 c''16 d''16 ees''16 f''2)->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 f''8 g'16( a'16 b'16 c''16 d''16 ees''16 f''2)-> | % m. 143; MIDI bar 143
\barNumberCheck #144 f''4 ees''2-> ees''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 ges''1-> | % m. 145; MIDI bar 145
\barNumberCheck #146 f''1( | % m. 146; MIDI bar 146
\barNumberCheck #147 aes''1) | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 b'4\pp b'8. b'16 b'4 b'4 | % m. 152; MIDI bar 152
\barNumberCheck #153 d''2( b'8) r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 g''4..\ff g''16 a''4.. a''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 a''4-. a''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 d''4\pp d''8. d''16 d''4 d''4 | % m. 156; MIDI bar 156
\barNumberCheck #157 d''2~ d''4 r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 d''4..\ff d''16 g''4.. g''16 | % m. 158; MIDI bar 158
\barNumberCheck #159 b''4-. d'''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 d''4\pp d''8. d''16 d''4 d''4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c''2^\markup \italic "Solo"~ c''8( d''16 c''16) b'8-. c''8-. | % m. 161; MIDI bar 161
\barNumberCheck #162 e''8-. g'8-. c''4~ c''8 g'8-. a'8-. b'8-. | % m. 162; MIDI bar 162
\barNumberCheck #163 c''8-. d''8-. e''8-. f''8-. g''4 g''4 | % m. 163; MIDI bar 163
\barNumberCheck #164 aes''2( b'4) r4 | % m. 164; MIDI bar 164
\barNumberCheck #165 r8 b'8 b'8 b'8 b'4 r4 | % m. 165; MIDI bar 165
\barNumberCheck #166 r8 b'8 b'8 b'8 b'4 r4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 b'4( b'4 d''4) | % m. 167; MIDI bar 167
\barNumberCheck #168 c''2 r2 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 fis''4.\!\sf-> g''8-.\p a''8-. b''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 c'''8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c'''8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 c''8\ff c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c''8 c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c'8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'4 fis'4 g'4 e''4 | % m. 179; MIDI bar 179
\barNumberCheck #180 f''8 b'8\<( c''8 cis''8\! ) d''8-. d''8\<( ees''8 e''8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 f''8-. b'8\<( c''8 cis''8\! ) d''8-. d''8\<( ees''8 e''8\!) | % m. 181; MIDI bar 181
\barNumberCheck #182 f''16(\ff e''16 f''16 e''16 f''16 e''16 f''16 e''16 f''16 e''16 f''16 e''16 f''16 e''16 f''16 e''16) | % m. 182; MIDI bar 182
\barNumberCheck #183 f''4-. b''4-. r4.\fermata r16 g''16\p-\tweak layer #3 ^\markup \whiteout \pad-markup #0.2 \italic "Solo" | % m. 183; MIDI bar 183
\barNumberCheck #184 g''2(-> e''4..) c'''16 | % m. 184; MIDI bar 184
\barNumberCheck #185 c'''2(-> a''4) r4 | % m. 185; MIDI bar 185
\barNumberCheck #186 a''8( g''8) g''8. g''16 g''4 g''4 | % m. 186; MIDI bar 186
\barNumberCheck #187 a''4.(-> g''8 e''4) r8. g''16 | % m. 187; MIDI bar 187
\barNumberCheck #188 g''2(-> e''4..) aes''16 | % m. 188; MIDI bar 188
\barNumberCheck #189 aes''2(-> b'2) | % m. 189; MIDI bar 189
\barNumberCheck #190 a''4 a''8. a''16 a''4 a''4 | % m. 190; MIDI bar 190
\barNumberCheck #191 bes''1(\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 b''2)\pp b'2( | % m. 192; MIDI bar 192
\barNumberCheck #193 a'2) c''2~ | % m. 193; MIDI bar 193
\barNumberCheck #194 c''1 | % m. 194; MIDI bar 194
\barNumberCheck #195 b'4 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 R1 | % m. 196; MIDI bar 196
\barNumberCheck #197 R1 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 bes'4\pp^\markup \italic "Solo" bes'8. bes'16 bes'4 bes'4 | % m. 205; MIDI bar 205
\barNumberCheck #206 des''2(-> e'4) r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 r8 e''8-.\p f''8-. fis''8-. g''8-. r8 r4 | % m. 209; MIDI bar 209
\barNumberCheck #210 R1 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 c'''8\f r8 d'''8 r8 b''8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 r8 e''8-. f''8-. fis''8-. g''8-. r8 r4 | % m. 213; MIDI bar 213
\barNumberCheck #214 R1 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 c'''8\f r8 d'''8 r8 b''8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'''8\ff c''16 c''16 des''8-. c''8-. d''8-. c''8-. ees''8-. c''8-. | % m. 216; MIDI bar 216
\barNumberCheck #217 e''8-. c''8-. f''8-. c''8-. fis''8-. c''8-. g''8-. c''8-. | % m. 217; MIDI bar 217
\barNumberCheck #218 aes''4.. aes''16 aes''4.. aes''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 aes''4 aes''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 aes''4.. aes''16 aes''4.. aes''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes''4 aes''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 aes''4 aes''8. aes''16 aes''4 aes''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 aes''2(-> g''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 b''4 b''8. b''16 b''4 b''4 | % m. 224; MIDI bar 224
\barNumberCheck #225 b''2->~ b''8 r8 b''4 | % m. 225; MIDI bar 225
\barNumberCheck #226 c'''8-. b''8-. c'''8-. b''8-. a''8-. b''8-. a''8-. g''8-. | % m. 226; MIDI bar 226
\barNumberCheck #227 a''4 b''4-. c'''4-. a''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g''4 c'''4 r4 g''4 | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g'16 a'16 b'16 c''16 d''16 e''16 f''16 g''16 c''16 d''16 e''16 f''16 g''16 a''16 b''16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'''16 b''16 a''16 g''16 fis''16 g''16 a''16 b''16 c'''4 e''16 d''16 e''16 f''16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g''4 a''4 g''4 b''4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'''4..\ff c''16 e''4.. e''16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g''4 g''2 g''4 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'''4.. c'''16 c'''4.. c'''16 | % m. 234; MIDI bar 234
\barNumberCheck #235 e'''2 c'''2 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'''4 r4 c'''4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237  c'1\fermata  | % m. 237; MIDI bar 237
\barNumberCheck #238
}
oboeTwoI = {
\barNumberCheck #1 \key c \major e''4..\ff e''16 e''4.. e''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f''4-. f''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 b'4\pp b'8. b'16 b'4 b'4 | % m. 3; MIDI bar 3
\barNumberCheck #4 b'2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 b'4..\ff b'16 d''4.. d''16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g''4-. g''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 b'4\pp b'8. b'16 b'4 b'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 g'2 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9  R1 | % m. 9; MIDI bar 9
\barNumberCheck #10  R1 | % m. 10; MIDI bar 10
\barNumberCheck #11  R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15  R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 c''4-.(\pp\< c''4-. c''4-. c''4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 d''2(\!->\> c''8)\! r8 r4 | % m. 17; MIDI bar 17
\barNumberCheck #18 c''4-.(\pp\< c''4-. c''4-. c''4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 d''2(\!->\> c''8)\! r8 r4 | % m. 19; MIDI bar 19
\barNumberCheck #20 r4 g'4\< g'4 g'4 | % m. 20; MIDI bar 20
\barNumberCheck #21 a'4 ees''4.\!\sf e''8-.\p ees''8-. d''8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 c''8 r8 f''8 r8 e''8 r8 d''8 r8 | % m. 22; MIDI bar 22
\barNumberCheck #23 b'2(-> c''8) r8 r4 | % m. 23; MIDI bar 23
\barNumberCheck #24 r4 g'4(\< f'4 g'4 | % m. 24; MIDI bar 24
\barNumberCheck #25 a'4) ees''4.\!\sf e''8-.\p ees''8-. d''8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 c''8 r8 f''8 r8 e''8 r8 f'8 r8 | % m. 26; MIDI bar 26
\barNumberCheck #27 e'8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c'8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'4 fis'4 g'4 cis''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 d''16( cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16) d''8 c''8 b'8 a'8 | % m. 31; MIDI bar 31
\barNumberCheck #32 g'8\< a'8 b'8 c''8 d''8 e''8 f''8 g''8 | % m. 32; MIDI bar 32
\barNumberCheck #33 e''4..\ff e''16 g''4.. g''16 | % m. 33; MIDI bar 33
\barNumberCheck #34 c'''4-. c'''4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 b'4.. b'16 b'4.. b'16 | % m. 35; MIDI bar 35
\barNumberCheck #36 b'4-. b'4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 c''4.. c''16 c''4.. c''16 | % m. 37; MIDI bar 37
\barNumberCheck #38 c''4-. c''4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 b'4.. b'16 b'4.. b'16 | % m. 39; MIDI bar 39
\barNumberCheck #40 b'4-. b'4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 e'4 e''8. e''16 e''4 e''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 d''1 | % m. 42; MIDI bar 42
\barNumberCheck #43 d''8 d'16( e'16 fis'16 g'16 a'16 b'16 c''2)->~ | % m. 43; MIDI bar 43
\barNumberCheck #44 c''8 d'16( e'16 fis'16 g'16 a'16 b'16 c''2)->( | % m. 44; MIDI bar 44
\barNumberCheck #45 b'4) bes'4(-> a'4) cis''4(-> | % m. 45; MIDI bar 45
\barNumberCheck #46 d''4) g''4(-> fis''4) e''4(-> | % m. 46; MIDI bar 46
\barNumberCheck #47 d''8) d'8\<( e'8 f'8 fis'8\!-.) fis'8\<( g'8 gis'8 | % m. 47; MIDI bar 47
\barNumberCheck #48 a'8-.)\!_\markup \italic "cresc." d''8\<( e''8 f''8 fis''8\!-.) fis''8\<( g''8 gis''8 | % m. 48; MIDI bar 48
\barNumberCheck #49 a''16\ff gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16) | % m. 49; MIDI bar 49
\barNumberCheck #50 a''4-. a''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 a'2(\p fis'2 | % m. 59; MIDI bar 59
\barNumberCheck #60 g'2 b'2) | % m. 60; MIDI bar 60
\barNumberCheck #61 cis''1(-> | % m. 61; MIDI bar 61
\barNumberCheck #62 d''4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 a'1(\pp | % m. 69; MIDI bar 69
\barNumberCheck #70 f'2 g'2 | % m. 70; MIDI bar 70
\barNumberCheck #71 f'2 a'2 | % m. 71; MIDI bar 71
\barNumberCheck #72 b'4) r4 r2 | % m. 72; MIDI bar 72
\barNumberCheck #73 R1 | % m. 73; MIDI bar 73
\barNumberCheck #74  R1 | % m. 74; MIDI bar 74
\barNumberCheck #75  R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 r2 r8 g'8-. a'8-. ais'8-. | % m. 76; MIDI bar 76
\barNumberCheck #77 b'8-. r8 r4 r2 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 g''8\f r8 a''8 r8 fis''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 r8 g'8-. a'8-. ais'8-. b'8-. r8 r4 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 g''8\f r8 a''8 r8 fis''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g''8\ff g'16 g'16 aes'8-. g'8-. a'8-. g'8-. bes'8-. g'8-. | % m. 83; MIDI bar 83
\barNumberCheck #84 b'8-. g'8-. c''8-. g'8-. cis''8-. g'8-. d''8-. g'8-. | % m. 84; MIDI bar 84
\barNumberCheck #85 fis''4.. fis''16 fis''4.. fis''16 | % m. 85; MIDI bar 85
\barNumberCheck #86 fis''4 fis''2.-> | % m. 86; MIDI bar 86
\barNumberCheck #87 fis''4.. fis''16 fis''4.. fis''16 | % m. 87; MIDI bar 87
\barNumberCheck #88 fis''4 fis''2.-> | % m. 88; MIDI bar 88
\barNumberCheck #89 fis''4 fis''8. fis''16 fis''4 fis''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 fis''2(-> g''4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 fis'4\ff fis'8. fis'16 fis'4 fis'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 fis'2->~ fis'8-. r8 fis'4 | % m. 92; MIDI bar 92
\barNumberCheck #93 g'8-. fis'8-. g'8-. f'8-. e'8-. f'8-. e'8-. d'8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4 fis''4 g''4 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d''4 d''4 r4 b'4 | % m. 95; MIDI bar 95
\barNumberCheck #96 g'16 d'16 e'16 fis'16 g'16 a'16 b'16 c''16 d''16 g'16 a'16 b'16 c''16 d''16 e''16 fis''16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g''16( fis''16 e''16 d''16 cis''16 d''16 e''16 fis''16 g''16 fis'16 g'16 a'16 b'16 a'16 b'16 c''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 e''4 g''4 fis''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 d''1 | % m. 99; MIDI bar 99
\barNumberCheck #100 b'1 | % m. 100; MIDI bar 100
\barNumberCheck #101 b'4.. b'16 b'4.. b'16 | % m. 101; MIDI bar 101
\barNumberCheck #102 b'4 b'4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 b'1\ff~ | % m. 122; MIDI bar 122
\barNumberCheck #123 b'8 fis''8( e''8 d''8 cis''8 b'8 ais'8 b'8) | % m. 123; MIDI bar 123
\barNumberCheck #124 ais'1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 ais'8 e''8( d''8 cis''8 b'8 ais'8 gis'8 ais'8) | % m. 125; MIDI bar 125
\barNumberCheck #126 b'1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 b'8 fis''8( e''8 d''8 cis''8 b'8 ais'8 b'8) | % m. 127; MIDI bar 127
\barNumberCheck #128 fis'1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 fis'8 fis''8( f''8 ees''8 d''8 c''8 b'8 c''8) | % m. 129; MIDI bar 129
\barNumberCheck #130 f'1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 f'8 c''8( bes'8 a'8 g'8 f'8 e'8 f'8) | % m. 131; MIDI bar 131
\barNumberCheck #132 f'1~ | % m. 132; MIDI bar 132
\barNumberCheck #133 f'8 f''8( ees''8 des''8 c''8 bes'8 a'8 bes'8) | % m. 133; MIDI bar 133
\barNumberCheck #134 bes'1\f~ | % m. 134; MIDI bar 134
\barNumberCheck #135 bes'8 f''8( ees''8 d''8 c''8 bes'8 a'8 bes'8) | % m. 135; MIDI bar 135
\barNumberCheck #136 bes'1~ | % m. 136; MIDI bar 136
\barNumberCheck #137 bes'8 g'8( f'8 ees'8 d'8 ees'8 f'8 ees'8) | % m. 137; MIDI bar 137
\barNumberCheck #138 f'2 b'2~ | % m. 138; MIDI bar 138
\barNumberCheck #139 b'8 g''8( f''8 ees''8 d''8 c''8 b'8 f''8) | % m. 139; MIDI bar 139
\barNumberCheck #140 g'1~ | % m. 140; MIDI bar 140
\barNumberCheck #141 g'8 g'8( g''8 f''8 ees''8 d''8 ees''8 c''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 b'8 g'16( a'16 b'16 c''16 d''16 ees''16 f''2)->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 f''8 g'16( a'16 b'16 c''16 d''16 ees''16 f''2)-> | % m. 143; MIDI bar 143
\barNumberCheck #144 d''4 c''2-> c''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 ees''1-> | % m. 145; MIDI bar 145
\barNumberCheck #146 d''1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 d''1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g'4\pp g'8. g'16 g'4 g'4 | % m. 152; MIDI bar 152
\barNumberCheck #153 b'2( g'8) r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 e''4..\ff e''16 e''4.. e''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f''4-. f''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 b'4\pp b'8. b'16 b'4 b'4 | % m. 156; MIDI bar 156
\barNumberCheck #157 b'2~ b'4 r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 b'4..\ff b'16 d''4.. d''16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g''4-. g''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 b'4\pp b'8. b'16 b'4 b'4 | % m. 160; MIDI bar 160
\barNumberCheck #161 g'2 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162  R1 | % m. 162; MIDI bar 162
\barNumberCheck #163  R1 | % m. 163; MIDI bar 163
\barNumberCheck #164  R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 r8 f'8 f'8 f'8 f'4 r4 | % m. 165; MIDI bar 165
\barNumberCheck #166 r8 f'8 f'8 f'8 f'4 r4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 f'4( f'4 b'4) | % m. 167; MIDI bar 167
\barNumberCheck #168 g'2 r2 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 ees''4.\!\sf e''8-.\p fis''8-. f''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 e''8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 ees''4.\!\sf e''8-.\p ees''8-. d''8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c''8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 e'8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 c'16 c'16 c'8 c'8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c'8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'4 fis'4 g'4 cis''4 | % m. 179; MIDI bar 179
\barNumberCheck #180 d''8 g'8\<( a'8 ais'8\! ) b'8-. b'8\<( c''8 cis''8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 d''8-. g'8\<( a'8 ais'8\! ) b'8-. b'8\<( c''8 cis''8\!) | % m. 181; MIDI bar 181
\barNumberCheck #182 d''16(\ff cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16) | % m. 182; MIDI bar 182
\barNumberCheck #183 d''4-. d''4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184  R1 | % m. 184; MIDI bar 184
\barNumberCheck #185  R1 | % m. 185; MIDI bar 185
\barNumberCheck #186  R1 | % m. 186; MIDI bar 186
\barNumberCheck #187  R1 | % m. 187; MIDI bar 187
\barNumberCheck #188  R1 | % m. 188; MIDI bar 188
\barNumberCheck #189  R1 | % m. 189; MIDI bar 189
\barNumberCheck #190  R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 des''1(\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 d''2)\pp g'2( | % m. 192; MIDI bar 192
\barNumberCheck #193 e'2) a'2~ | % m. 193; MIDI bar 193
\barNumberCheck #194 a'1 | % m. 194; MIDI bar 194
\barNumberCheck #195 g'4 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 R1 | % m. 196; MIDI bar 196
\barNumberCheck #197 R1 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205  R1 | % m. 205; MIDI bar 205
\barNumberCheck #206  R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 r8 c''8-.\p d''8-. dis''8-. e''8-. r8 r4 | % m. 209; MIDI bar 209
\barNumberCheck #210 R1 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 a''8\f r8 a''8 r8 f''8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 r8 c''8-. d''8-. dis''8-. e''8-. r8 r4 | % m. 213; MIDI bar 213
\barNumberCheck #214 R1 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 a''8\f r8 a''8 r8 f''8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 e''8\ff c'16 c'16 r8 c'8-. d'8-. c'8-. ees'8-. c'8-. | % m. 216; MIDI bar 216
\barNumberCheck #217 e'8-. c'8-. f'8-. c'8-. fis'8-. c'8-. g'8-. c'8-. | % m. 217; MIDI bar 217
\barNumberCheck #218 b'4.. b'16 b'4.. b'16 | % m. 218; MIDI bar 218
\barNumberCheck #219 b'4 b'2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 b'4.. b'16 b'4.. b'16 | % m. 220; MIDI bar 220
\barNumberCheck #221 b'4 b'2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 b'4 b'8. b'16 b'4 b'4 | % m. 222; MIDI bar 222
\barNumberCheck #223 b'2(-> c''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 f''4 f''8. f''16 f''4 f''4 | % m. 224; MIDI bar 224
\barNumberCheck #225 f''2(-> e''8) r8 e''4 | % m. 225; MIDI bar 225
\barNumberCheck #226 e''4. e''8 f''4. g''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 a''4 d''4-. e''4-. c''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 c''4 e''4 g'16 c'16( d'16 e'16 f'16 g'16 a'16 b'16) | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g'16 a'16 b'16 c''16 d''16 e''16 f''16 g''16 c''16 d''16 e''16 f''16 g''16 a''16 b''16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'''16 b''16 a''16 g''16 fis'16 g'16 a'16 b'16 c''16 b'16 c''16 d''16 e''16 d''16 e''16 f''16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g''4 f''4 e''4 d''4 | % m. 231; MIDI bar 231
\barNumberCheck #232 e''4..\ff e'16 c''4.. c''16 | % m. 232; MIDI bar 232
\barNumberCheck #233 e''4 e''2 e''4 | % m. 233; MIDI bar 233
\barNumberCheck #234 e''4.. e''16 e''4.. e''16 | % m. 234; MIDI bar 234
\barNumberCheck #235 e''2 c''2 | % m. 235; MIDI bar 235
\barNumberCheck #236 e''4 r4 e''4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237  c'1\fermata  | % m. 237; MIDI bar 237
\barNumberCheck #238
}
bassoonOneI = {
\barNumberCheck #1 \key c \major c'4..\ff c'16 a4.. a16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f4-. f4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 f'4\pp f'8. f'16 f'4 f'4 | % m. 3; MIDI bar 3
\barNumberCheck #4 f'2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 d'4..\ff d'16 d'4.. d'16 | % m. 5; MIDI bar 5
\barNumberCheck #6 d'4-. d'4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 f'4\pp f'8. f'16 f'4 f'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 e'4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 d'2^\markup \italic "Solo"~ d'8( e'16 d'16) cis'8-. d'8-. | % m. 12; MIDI bar 12
\barNumberCheck #13 b8-. g,8-. f'4.-> e'8-. d'8-. c'8-. | % m. 13; MIDI bar 13
\barNumberCheck #14 b8-. a8-. g8-. f8-. e8-. d8-. g8-. f8-. | % m. 14; MIDI bar 14
\barNumberCheck #15 e4 c,2-> r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 r4 c'4(\p\< b4 bes4 | % m. 20; MIDI bar 20
\barNumberCheck #21 a4) aes4.\!\sf g8-.\p fis8-. f8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 e8 r8 f8 r8 g8 r8 g8 r8 | % m. 22; MIDI bar 22
\barNumberCheck #23 g2( c'8) r8 r4 | % m. 23; MIDI bar 23
\barNumberCheck #24 r4 c'4(\< b4 bes4 | % m. 24; MIDI bar 24
\barNumberCheck #25 a4) aes4.\!\sf g8-.\p fis8-. f8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 e8 r8 f8 r8 g8 r8 g,8 r8 | % m. 26; MIDI bar 26
\barNumberCheck #27 c8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c8 r8 c4_\markup \italic "cresc." d4 e4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f4 fis4 g2 | % m. 30; MIDI bar 30
\barNumberCheck #31 g2:8 g2:8 | % m. 31; MIDI bar 31
\barNumberCheck #32 g8\< a8 b8 c'8 d'8 e'8 f'8 g'8 | % m. 32; MIDI bar 32
\barNumberCheck #33 g'4..\ff g'16 e'4.. e'16 | % m. 33; MIDI bar 33
\barNumberCheck #34 g4-. g4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 b4.. b16 b4.. b16 | % m. 35; MIDI bar 35
\barNumberCheck #36 b4-. b4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 a4.. a16 a4.. a16 | % m. 37; MIDI bar 37
\barNumberCheck #38 a4-. a4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 e4.. e16 e4.. e16 | % m. 39; MIDI bar 39
\barNumberCheck #40 e4-. e4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c4 c8. c16 c4 c4 | % m. 41; MIDI bar 41
\barNumberCheck #42  b,1  | % m. 42; MIDI bar 42
\barNumberCheck #43 r8 d16( e16 fis16 g16 a16 b16 c'2)->~ | % m. 43; MIDI bar 43
\barNumberCheck #44 c'8 d16( e16 fis16 g16 a16 b16 c'2)->( | % m. 44; MIDI bar 44
\barNumberCheck #45 b4) bes4(-> a4) cis'4(-> | % m. 45; MIDI bar 45
\barNumberCheck #46 d'4) bes4(-> a4) cis'4(-> | % m. 46; MIDI bar 46
\barNumberCheck #47 d'8) fis8\<( g8 gis8 a8\!-.) a8\<( bes8 b8 | % m. 47; MIDI bar 47
\barNumberCheck #48 c'8-.)\!_\markup \italic "cresc." fis8\<( g8 gis8 a8\!-.) a8\<( bes8 b8 | % m. 48; MIDI bar 48
\barNumberCheck #49 c'8-.)\ff r8 fis4 fis8 fis8 fis8 fis8 | % m. 49; MIDI bar 49
\barNumberCheck #50 fis4-. fis4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 b1(\pp | % m. 51; MIDI bar 51
\barNumberCheck #52 e'1) | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 bes,1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59  a,1\pp  | % m. 59; MIDI bar 59
\barNumberCheck #60 g,2.( e,4) | % m. 60; MIDI bar 60
\barNumberCheck #61 g'1( | % m. 61; MIDI bar 61
\barNumberCheck #62 fis'8) d8(^\markup \italic "Solo" fis8 g8 a8 b8 c'8 cis'8) | % m. 62; MIDI bar 62
\barNumberCheck #63 \grace { cis'16( d'16 e'16 } d'2)-> b4.. g'16 | % m. 63; MIDI bar 63
\barNumberCheck #64 g'2(-> e'4) r4 | % m. 64; MIDI bar 64
\barNumberCheck #65 e'8( d'8) d'8.-. d'16-. d'4 d'4 | % m. 65; MIDI bar 65
\barNumberCheck #66 e'4.( d'8 b4) r8. d'16 | % m. 66; MIDI bar 66
\barNumberCheck #67 d'2( b4) r8. ees'16 | % m. 67; MIDI bar 67
\barNumberCheck #68 ees'2( fis2) | % m. 68; MIDI bar 68
\barNumberCheck #69 ees'2\p~ ees'8 f'16( ees'16) d'8-. c'8-. | % m. 69; MIDI bar 69
\barNumberCheck #70 f'2 \grace { f'8( } ees'8 d'8 ees'8 c'8) | % m. 70; MIDI bar 70
\barNumberCheck #71 bes2 d'4(-> c'4) | % m. 71; MIDI bar 71
\barNumberCheck #72 b2~ b8( c'8 d'8 ees'8) | % m. 72; MIDI bar 72
\barNumberCheck #73 \after 8 \turnNatural f'4( f'8. g'16 aes'4) r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 d8 r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 r8 b,8-. c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 r8 b,8-.\p c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g8\ff g16 g16 aes8-. g8-. a8-. g8-. bes8-. g8-. | % m. 83; MIDI bar 83
\barNumberCheck #84 b8-. g8-. c'8-. g8-. cis'8-. g8-. d'8-. g8-. | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'4.. ees'16 ees'4.. ees'16 | % m. 85; MIDI bar 85
\barNumberCheck #86 ees'4 ees'2.-> | % m. 86; MIDI bar 86
\barNumberCheck #87 ees'4.. ees'16 ees'4.. ees'16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees'4 ees'2.-> | % m. 88; MIDI bar 88
\barNumberCheck #89 ees'4 ees'8. ees'16 ees'4 ees'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 ees'2(-> d'4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 dis4 dis8. dis16 dis4 dis4 | % m. 91; MIDI bar 91
\barNumberCheck #92 dis2->~ dis8-. r8 dis'4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e'8-. dis'8-. e'8-. d'8-. c'8-. d'8-. c'8-. b8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 c'4 c'4 b4 cis'4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d'4 d4 d16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g16 a16 b16 c'16 d'16 e'16 fis'16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g'16( fis'16 e'16 d'16 cis'16 d'16 e'16 fis'16 g'8) r8 b16( a16 b16 c'16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'4 c4 d4 a4 | % m. 98; MIDI bar 98
\barNumberCheck #99 b1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 b1 | % m. 100; MIDI bar 100
\barNumberCheck #101 b4.. b16 b4.. b16 | % m. 101; MIDI bar 101
\barNumberCheck #102 b4 b4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 g'4-.(\pp\< g'4-. g'4-. g'4-.) | % m. 115; MIDI bar 115
\barNumberCheck #116 fis'2(\!\> g'4)\! r4 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 fis'1\ff~ | % m. 122; MIDI bar 122
\barNumberCheck #123 fis'8 fis'8( e'8 d'8 cis'8 b8 ais8 b8) | % m. 123; MIDI bar 123
\barNumberCheck #124 fis'1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 fis'8 e'8( d'8 cis'8 b8 ais8 gis8 ais8) | % m. 125; MIDI bar 125
\barNumberCheck #126 fis'1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 fis'8 fis'8( e'8 d'8 cis'8 b8 ais8 b8) | % m. 127; MIDI bar 127
\barNumberCheck #128 ees'1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 ees'8 fis'8( f'8 ees'8 d'8 c'8 b8 c'8) | % m. 129; MIDI bar 129
\barNumberCheck #130 ees'1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 ees'8 c'8( bes8 a8 g8 f8 e8 f8) | % m. 131; MIDI bar 131
\barNumberCheck #132 des'1~ | % m. 132; MIDI bar 132
\barNumberCheck #133 des'8 f'8( ees'8 des'8 c'8 bes8 a8 bes8) | % m. 133; MIDI bar 133
\barNumberCheck #134 bes,4..\ff bes,16 d4.. f16 | % m. 134; MIDI bar 134
\barNumberCheck #135 bes8 f'8( ees'8 d'8 c'8 bes8 a8 bes8) | % m. 135; MIDI bar 135
\barNumberCheck #136 bes,4.. bes,16 ees4.. g16 | % m. 136; MIDI bar 136
\barNumberCheck #137 bes8 g'8( f'8 ees'8 d'8 ees'8 f'8 ees'8) | % m. 137; MIDI bar 137
\barNumberCheck #138 d'4.. b,16 d4.. g16 | % m. 138; MIDI bar 138
\barNumberCheck #139 b8 g'8( f'8 ees'8 d'8 c'8 b8 f'8) | % m. 139; MIDI bar 139
\barNumberCheck #140 g,4.. g,16 c4.. ees16 | % m. 140; MIDI bar 140
\barNumberCheck #141 g8 g8( g'8 f'8 ees'8 d'8 ees'8 c'8) | % m. 141; MIDI bar 141
\barNumberCheck #142 b8 g16( a16 b16 c'16 d'16 ees'16 f'2)->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 f'8 g16( a16 b16 c'16 d'16 ees'16 f'2)-> | % m. 143; MIDI bar 143
\barNumberCheck #144 f'4 ees'2-> ees'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 ges'1-> | % m. 145; MIDI bar 145
\barNumberCheck #146 f'1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 f'1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 f'4\pp f'8. f'16 f'4 f'4 | % m. 152; MIDI bar 152
\barNumberCheck #153 f'2~ f'8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'4..\ff c'16 a4.. a16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f4-. f4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 f'4\pp f'8. f'16 f'4 f'4 | % m. 156; MIDI bar 156
\barNumberCheck #157 f'2. r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 d'4..\ff d'16 d'4.. d'16 | % m. 158; MIDI bar 158
\barNumberCheck #159 d'4-. d'4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 f'4\pp f'8. f'16 f'4 f'4 | % m. 160; MIDI bar 160
\barNumberCheck #161 e'4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164  R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 d'2^\markup \italic "Solo"~ d'8( e'16 d'16) cis'8-. d'8-. | % m. 165; MIDI bar 165
\barNumberCheck #166 b8-. g,8-. f'4.-> e'8-. d'8-. c'8-. | % m. 166; MIDI bar 166
\barNumberCheck #167 b8-. a8-. g8-. f8-. e8( d8) g8.-. f16-. | % m. 167; MIDI bar 167
\barNumberCheck #168 e4 c,2-> r4 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 aes4.\!\sf-> g8-.\p fis8-. f8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 e8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 aes4.\!\sf-> g8-.\p fis8-. f8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 e8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 c8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c8 r8 c4_\markup \italic "cresc." d4 e4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f4 fis4 g2~ | % m. 179; MIDI bar 179
\barNumberCheck #180 g8 b8\<( c'8 cis'8\! ) d'8-. d'8\<( ees'8 e'8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 f'8-. b8\<( c'8 cis'8\! ) d'8-. d'8\<( ees'8 e'8\!) | % m. 181; MIDI bar 181
\barNumberCheck #182 f'16(\ff e'16 f'16 e'16 f'16 e'16 f'16 e'16 f'16 e'16 f'16 e'16 f'16 e'16 f'16 e'16) | % m. 182; MIDI bar 182
\barNumberCheck #183 f'4-. f'4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 ees1\f->( | % m. 191; MIDI bar 191
\barNumberCheck #192 d2)\pp r2 | % m. 192; MIDI bar 192
\barNumberCheck #193  R1 | % m. 193; MIDI bar 193
\barNumberCheck #194  R1 | % m. 194; MIDI bar 194
\barNumberCheck #195 r8 g,8(^\markup \italic "Solo" b,8 c8 d8 e8 f8 fis8) | % m. 195; MIDI bar 195
\barNumberCheck #196 g2( e4..) c'16 | % m. 196; MIDI bar 196
\barNumberCheck #197 \grace { b16( c'16 d'16 } c'2) a2 | % m. 197; MIDI bar 197
\barNumberCheck #198 a4(-> g8.) g16 g4 g4 | % m. 198; MIDI bar 198
\barNumberCheck #199 a4.(-> g8 e4) r8. g16 | % m. 199; MIDI bar 199
\barNumberCheck #200 g2(-> e4..) aes16 | % m. 200; MIDI bar 200
\barNumberCheck #201 aes2(-> b,2) | % m. 201; MIDI bar 201
\barNumberCheck #202 aes2~ aes8 bes16( aes16) g8-. f8-. | % m. 202; MIDI bar 202
\barNumberCheck #203 bes2 \grace { bes8( } aes8) g8( aes8 f8) | % m. 203; MIDI bar 203
\barNumberCheck #204 \after 4 \turn ees2( g4.-> f8) | % m. 204; MIDI bar 204
\barNumberCheck #205 e2~ e8( f8 g8 aes8) | % m. 205; MIDI bar 205
\barNumberCheck #206 bes4 \grace { c'16( bes16 a16 } bes8.) c'16 des'4 r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 R1 | % m. 209; MIDI bar 209
\barNumberCheck #210 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 210; MIDI bar 210
\barNumberCheck #211 g,4 a8\f r8 f8 r8 g8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 214; MIDI bar 214
\barNumberCheck #215 g,4 a8\f r8 f8 r8 g8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'8-.\ff c'16 c'16 des'8-. c'8-. d'8-. c'8-. ees'8-. c'8-. | % m. 216; MIDI bar 216
\barNumberCheck #217 e'8-. c'8-. f'8-. c'8-. fis'8-. c'8-. g'8-. c'8-. | % m. 217; MIDI bar 217
\barNumberCheck #218 f4.. f16 f4.. f16 | % m. 218; MIDI bar 218
\barNumberCheck #219 b4 b2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 b4.. b16 b4.. b16 | % m. 220; MIDI bar 220
\barNumberCheck #221 b4 b2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 b4 b8. b16 b4 b4 | % m. 222; MIDI bar 222
\barNumberCheck #223 b2(-> c'8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 gis4\f gis8. gis16 gis4 gis4 | % m. 224; MIDI bar 224
\barNumberCheck #225 gis2->~ gis8 r8 gis4 | % m. 225; MIDI bar 225
\barNumberCheck #226 a8-. gis8-. a8-. g8-. f8-. g8-. f8-. e8-. | % m. 226; MIDI bar 226
\barNumberCheck #227 f4 f4 e4 fis4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g16 g,16 a,16 b,16 c16 d16 e16 f16 g16 c,16 d,16 e,16 f,16 g,16 a,16 b,16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c16 g,16 a,16 b,16 c16 d16 e16 f16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'16 b16 a16 g16 fis16 g16 a16 b16 c'16 b16 c'16 d'16 e'16 d'16 e'16 f'16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'4 f4 g4 g4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'4..\ff c'16 c'4.. c'16 | % m. 232; MIDI bar 232
\barNumberCheck #233 c'4 c'2 c'4 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'4.. c'16 c'4.. c'16 | % m. 234; MIDI bar 234
\barNumberCheck #235 e'2 c'2 | % m. 235; MIDI bar 235
\barNumberCheck #236 g4 r4 g4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
bassoonTwoI = {
\barNumberCheck #1 \key c \major c4..\ff c16 a,4.. a,16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f,4-. f,4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 b4\pp b8. b16 b4 b4 | % m. 3; MIDI bar 3
\barNumberCheck #4 b2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 b4..\ff b16 b4.. b16 | % m. 5; MIDI bar 5
\barNumberCheck #6 b4-. b4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 b4\pp b8. b16 b4 b4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c'4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12  R1 | % m. 12; MIDI bar 12
\barNumberCheck #13  R1 | % m. 13; MIDI bar 13
\barNumberCheck #14  R1 | % m. 14; MIDI bar 14
\barNumberCheck #15  R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20  R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 r4 aes,4.\!\sf g,8-.\p fis,8-. f,8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 e,8 r8 f,8 r8 g,8 r8 g,8 r8 | % m. 22; MIDI bar 22
\barNumberCheck #23 g,2( c,8) r8 r4 | % m. 23; MIDI bar 23
\barNumberCheck #24  R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 r4 aes,4.\!\sf g,8-.\p fis,8-. f,8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 e,8 r8 r4 r2 | % m. 26; MIDI bar 26
\barNumberCheck #27 c8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c8 c16 c16 c8 c8 c16(-> b,16 a,16 g,16) g,16(-> f,16 e,16 d,16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c,8 r8 c4_\markup \italic "cresc." d4 e4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f4 fis4 g2 | % m. 30; MIDI bar 30
\barNumberCheck #31 g,2:8 g,2:8 | % m. 31; MIDI bar 31
\barNumberCheck #32 b,8\< c8 d8 e8 f8 g8 a8 b8 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'4..\ff c'16 c4.. c16 | % m. 33; MIDI bar 33
\barNumberCheck #34 c4-. c4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g4.. g16 g4.. g16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g4-. g4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 a,4.. a,16 a,4.. a,16 | % m. 37; MIDI bar 37
\barNumberCheck #38 a,4-. a,4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 e,4.. e,16 e,4.. e,16 | % m. 39; MIDI bar 39
\barNumberCheck #40 e,4-. e,4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c,4 c,8. c,16 c,4 c,4 | % m. 41; MIDI bar 41
\barNumberCheck #42  b,1  | % m. 42; MIDI bar 42
\barNumberCheck #43 r8 d16( e16 fis16 g16 a16 b16 c'2)->~ | % m. 43; MIDI bar 43
\barNumberCheck #44 c'8 d16( e16 fis16 g16 a16 b16 c'2)->( | % m. 44; MIDI bar 44
\barNumberCheck #45 b4) g4(-> fis4) e4(-> | % m. 45; MIDI bar 45
\barNumberCheck #46 fis4) g4(-> fis4) e4(-> | % m. 46; MIDI bar 46
\barNumberCheck #47 fis8) d8\<( e8 f8 fis8\!-.) fis8\<( g8 gis8 | % m. 47; MIDI bar 47
\barNumberCheck #48 a8-.)\!_\markup \italic "cresc." d8\<( e8 f8 fis8\!-.) fis8\<( g8 gis8 | % m. 48; MIDI bar 48
\barNumberCheck #49 a8-.)\ff r8 d,4 d,8 d,8 d,8 d,8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d,4-. d,4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 g,1(\pp | % m. 51; MIDI bar 51
\barNumberCheck #52 c,1) | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 bes,,1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59  a,1\pp  | % m. 59; MIDI bar 59
\barNumberCheck #60 g,2.( e,4) | % m. 60; MIDI bar 60
\barNumberCheck #61 a,1( | % m. 61; MIDI bar 61
\barNumberCheck #62 d8) r8 r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63  R1 | % m. 63; MIDI bar 63
\barNumberCheck #64  R1 | % m. 64; MIDI bar 64
\barNumberCheck #65  R1 | % m. 65; MIDI bar 65
\barNumberCheck #66  R1 | % m. 66; MIDI bar 66
\barNumberCheck #67  R1 | % m. 67; MIDI bar 67
\barNumberCheck #68  R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 f,2(\p ees,2 | % m. 69; MIDI bar 69
\barNumberCheck #70 d,2 ees,2 | % m. 70; MIDI bar 70
\barNumberCheck #71 f,1)~ | % m. 71; MIDI bar 71
\barNumberCheck #72 f,1~ | % m. 72; MIDI bar 72
\barNumberCheck #73 f,2. r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 d,8 r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 r8 b,8-. c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d8 r8 e,8\f r8 c,8 r8 d,8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 r8 b,8-.\p c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d8 r8 e,8\f r8 c,8 r8 d,8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g,8\ff g,16 g,16 aes,8-. g,8-. a,8-. g,8-. bes,8-. g,8-. | % m. 83; MIDI bar 83
\barNumberCheck #84 b,8-. g,8-. c8-. g,8-. cis8-. g,8-. d8-. g,8-. | % m. 84; MIDI bar 84
\barNumberCheck #85 a4.. a16 a4.. a16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a4 a2.-> | % m. 86; MIDI bar 86
\barNumberCheck #87 a4.. a16 a4.. a16 | % m. 87; MIDI bar 87
\barNumberCheck #88 a4 a2.-> | % m. 88; MIDI bar 88
\barNumberCheck #89 a4 a8. a16 a4 a4 | % m. 89; MIDI bar 89
\barNumberCheck #90 a2(-> b!4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 dis,4 dis,8. dis,16 dis,4 dis,4 | % m. 91; MIDI bar 91
\barNumberCheck #92 dis,2->~ dis,8-. r8 dis4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e8-. dis8-. e8-. d8-. c8-. d8-. c8-. b,8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 c4 c4 b,4 cis4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d16 d,16 e,16 fis,16 g,16 a,16 b,16 c16 d16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g16( fis16 e16 d16 cis16 d16 e16 fis16 g16 fis16 g16 a16 b16 a16 b16 c'16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'4 c,4 d,4 d,4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g,1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 g,1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g,4.. g,16 g,4.. g,16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g,4 g,4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 e'4-.(\pp\< e'4-. e'4-. e'4-.) | % m. 115; MIDI bar 115
\barNumberCheck #116 dis'2(\!\> e'4)\! r4 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 b,4..\ff d16 fis4.. b16 | % m. 122; MIDI bar 122
\barNumberCheck #123 d'4 fis'4 r2 | % m. 123; MIDI bar 123
\barNumberCheck #124 fis,4.. ais,16 cis4.. fis16 | % m. 124; MIDI bar 124
\barNumberCheck #125 ais4 cis'4 r2 | % m. 125; MIDI bar 125
\barNumberCheck #126 b,4.. d16 fis4.. b16 | % m. 126; MIDI bar 126
\barNumberCheck #127 d'4 fis'4 r2 | % m. 127; MIDI bar 127
\barNumberCheck #128 a,4.. c16 ees4.. fis16 | % m. 128; MIDI bar 128
\barNumberCheck #129 a4 c'4 r2 | % m. 129; MIDI bar 129
\barNumberCheck #130 a,4.. c16 f4.. a16 | % m. 130; MIDI bar 130
\barNumberCheck #131 c'4 ees'4 r2 | % m. 131; MIDI bar 131
\barNumberCheck #132 f,4.. bes,16 des4.. f16 | % m. 132; MIDI bar 132
\barNumberCheck #133 bes4 des'4 r2 | % m. 133; MIDI bar 133
\barNumberCheck #134 bes,,4..\ff bes,,16 d,4.. f,16 | % m. 134; MIDI bar 134
\barNumberCheck #135 bes,4 d4 r2 | % m. 135; MIDI bar 135
\barNumberCheck #136 bes,,4.. bes,,16 ees,4.. g,16 | % m. 136; MIDI bar 136
\barNumberCheck #137 bes,4 ees4 r2 | % m. 137; MIDI bar 137
\barNumberCheck #138 b,4.. b,16 d4.. g,16 | % m. 138; MIDI bar 138
\barNumberCheck #139 b,4 d4 r2 | % m. 139; MIDI bar 139
\barNumberCheck #140 g,4.. g,16 c4.. ees16 | % m. 140; MIDI bar 140
\barNumberCheck #141 g,4 c4 r2 | % m. 141; MIDI bar 141
\barNumberCheck #142 r8 g16( a16 b16 c'16 d'16 ees'16 f'2)->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 f'8 g16( a16 b16 c'16 d'16 ees'16 f'2)-> | % m. 143; MIDI bar 143
\barNumberCheck #144 d'4 c'2-> c'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 ees'1-> | % m. 145; MIDI bar 145
\barNumberCheck #146 aes1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 aes1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 b4\pp b8. b16 b4 b4 | % m. 152; MIDI bar 152
\barNumberCheck #153 b2~ b8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c4..\ff c16 a,4.. a,16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f,4-. f,4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 b4\pp b8. b16 b4 b4 | % m. 156; MIDI bar 156
\barNumberCheck #157 b2. r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 b4..\ff b16 b4.. b16 | % m. 158; MIDI bar 158
\barNumberCheck #159 b4-. b4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 b4\pp b8. b16 b4 b4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c'4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 r2 r8 c8 c8 c8 | % m. 164; MIDI bar 164
\barNumberCheck #165 b,4 r4 r2 | % m. 165; MIDI bar 165
\barNumberCheck #166  R1 | % m. 166; MIDI bar 166
\barNumberCheck #167  R1 | % m. 167; MIDI bar 167
\barNumberCheck #168  R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 aes,4.\!\sf-> g,8-.\p fis,8-. f,8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 e,8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 aes,4.\!\sf g,8-.\p fis,8-. f,8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 e,8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 c,8\ff c16 c16 c8 c8 c16(-> b,16 a,16 g,16) g,16(-> f,16 e,16 d,16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c,8 c16 c16 c8 c8 c16(-> b,16 a,16 g,16) g,16(-> f,16 e,16 d,16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c,8 r8 c4_\markup \italic "cresc." d4 e4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f4 fis4 g2~ | % m. 179; MIDI bar 179
\barNumberCheck #180 g8 g8\<( a8 ais8\! ) b8-. b8\<( c'8 cis'8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 d'8-. g8\<( a8 ais8\! ) b8-. b8\<( c'8 cis'8\!) | % m. 181; MIDI bar 181
\barNumberCheck #182 d'16(\ff cis'16 d'16 cis'16 d'16 cis'16 d'16 cis'16 d'16 cis'16 d'16 cis'16 d'16 cis'16 d'16 cis'16) | % m. 182; MIDI bar 182
\barNumberCheck #183 d'4-. b4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 ees,1\f->( | % m. 191; MIDI bar 191
\barNumberCheck #192 d,1)\pp | % m. 192; MIDI bar 192
\barNumberCheck #193 c2.( a,4) | % m. 193; MIDI bar 193
\barNumberCheck #194 d1( | % m. 194; MIDI bar 194
\barNumberCheck #195 g,8) r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196  R1 | % m. 196; MIDI bar 196
\barNumberCheck #197  R1 | % m. 197; MIDI bar 197
\barNumberCheck #198  R1 | % m. 198; MIDI bar 198
\barNumberCheck #199  R1 | % m. 199; MIDI bar 199
\barNumberCheck #200  R1 | % m. 200; MIDI bar 200
\barNumberCheck #201  R1 | % m. 201; MIDI bar 201
\barNumberCheck #202  R1 | % m. 202; MIDI bar 202
\barNumberCheck #203  R1 | % m. 203; MIDI bar 203
\barNumberCheck #204  R1 | % m. 204; MIDI bar 204
\barNumberCheck #205  R1 | % m. 205; MIDI bar 205
\barNumberCheck #206  R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 R1 | % m. 209; MIDI bar 209
\barNumberCheck #210 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 210; MIDI bar 210
\barNumberCheck #211 g,4 a,8\f r8 f,8 r8 g,8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 214; MIDI bar 214
\barNumberCheck #215 g,4 a,8\f r8 f,8 r8 g,8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c8\ff c16 c16 des8-. c8-. d8-. c8-. ees8-. c8-. | % m. 216; MIDI bar 216
\barNumberCheck #217 e8-. c8-. f8-. c8-. fis8-. c8-. g8-. c8-. | % m. 217; MIDI bar 217
\barNumberCheck #218 f,4.. f,16 f,4.. f,16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f,4 f,2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 f,4.. f,16 f,4.. f,16 | % m. 220; MIDI bar 220
\barNumberCheck #221 f,4 f,2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 f,4 f,8. f,16 f,4 f,4 | % m. 222; MIDI bar 222
\barNumberCheck #223 f,2(-> e,8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 gis,4\f gis,8. gis,16 gis,4 gis,4 | % m. 224; MIDI bar 224
\barNumberCheck #225 gis,2->~ gis,8 r8 gis,4 | % m. 225; MIDI bar 225
\barNumberCheck #226 a,8-. gis,8-. a,8-. g,8-. f,8-. g,8-. f,8-. e,8-. | % m. 226; MIDI bar 226
\barNumberCheck #227 f,4 f,4 e,4 fis,4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g,8 a,16 b,16 c16 d16 e16 f16 g16 c,16 d,16 e,16 f,16 g,16 a,16 b,16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c16 g,16 a,16 b,16 c16 d16 e16 f16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'16 b16 a16 g16 fis16 g16 a16 b16 c'16 b16 c'16 d'16 e'16 d'16 e'16 f'16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'4 f,4 g,4 g,4 | % m. 231; MIDI bar 231
\barNumberCheck #232 e4..\ff e16 e4.. e16 | % m. 232; MIDI bar 232
\barNumberCheck #233 e4 e2 e4 | % m. 233; MIDI bar 233
\barNumberCheck #234 e4.. e16 e4.. e16 | % m. 234; MIDI bar 234
\barNumberCheck #235 e2 e2 | % m. 235; MIDI bar 235
\barNumberCheck #236 e4 r4 c,4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c,1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
hornOneI = {
\barNumberCheck #1 c''4..\ff c''16 e''4.. e''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f''4-. f''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g'4\pp g'8. g'16 g'4 g'4 | % m. 3; MIDI bar 3
\barNumberCheck #4 d''2(-> g'4) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'4..\ff g'16 g'4.. g'16 | % m. 5; MIDI bar 5
\barNumberCheck #6 d''4-. d''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g'4\pp g'8. g'16 g'4 g'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c''4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 r2 r8 c''8\p^\markup \italic "Soli" c''8 c''8 | % m. 11; MIDI bar 11
\barNumberCheck #12 b'4 r4 r2 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 g'4-.(\pp\< g'4-. g'4-. g'4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 g'2(\!->\> g'8)\! r8 r4 | % m. 17; MIDI bar 17
\barNumberCheck #18 g'4-.(\pp\< g'4-. g'4-. e'4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 f'2(\!->\> e'8)\! r8 r4 | % m. 19; MIDI bar 19
\barNumberCheck #20 r2 r4 c''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c''4 c''4.\!\sf c''8-.\p c''8-. d''8-. | % m. 21; MIDI bar 21
\barNumberCheck #22 c''8 r8 c''8 r8 c''8 r8 d''8 r8 | % m. 22; MIDI bar 22
\barNumberCheck #23 d''2(-> c''8) r8 r4 | % m. 23; MIDI bar 23
\barNumberCheck #24 r2 r4 c''4 | % m. 24; MIDI bar 24
\barNumberCheck #25 c''4 c''4.\!\sf c''8-.\p c''8-. d''8-. | % m. 25; MIDI bar 25
\barNumberCheck #26 c''8 r8 c''8 r8 c''8 r8 d''8 r8 | % m. 26; MIDI bar 26
\barNumberCheck #27 e''8\ff c''16 c''16 c''8 c''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 e''16 e''16 e''8 e''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 28; MIDI bar 28
\barNumberCheck #29 c'8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'4 fis'4 g'2~ | % m. 30; MIDI bar 30
\barNumberCheck #31  g'1  | % m. 31; MIDI bar 31
\barNumberCheck #32 g'4\< g'8. g'16 g'4 g'4 | % m. 32; MIDI bar 32
\barNumberCheck #33 c''4..\ff c''16 c''4.. c''16 | % m. 33; MIDI bar 33
\barNumberCheck #34 c''4-. c''4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g'4.. g'16 g'4.. g'16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g'4-. g'4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 c''4.. c''16 c''4.. c''16 | % m. 37; MIDI bar 37
\barNumberCheck #38 c''4-. c''4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 e''4.. e''16 e''4.. e''16 | % m. 39; MIDI bar 39
\barNumberCheck #40 e''4-. e''4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c''4 c''8. c''16 c''4 c''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 d''1 | % m. 42; MIDI bar 42
\barNumberCheck #43 c''4 r4 r4 c''4->( | % m. 43; MIDI bar 43
\barNumberCheck #44 c''8) r8 r4 r4 c''4->( | % m. 44; MIDI bar 44
\barNumberCheck #45 g'8) r8 d''2-> e''4( | % m. 45; MIDI bar 45
\barNumberCheck #46 d''8) r8 d''2-> e''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 d''4 r4 r2 | % m. 47; MIDI bar 47
\barNumberCheck #48 d''4_\markup \italic "cresc." d''4 d''8 d''8 d''8 d''8 | % m. 48; MIDI bar 48
\barNumberCheck #49 d''8\ff d''8 d''8 d''8 d''8 d''8 d''8 d''8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d''4-. d''4-. r4.\fermata d''8\p^\markup \italic "Solo" | % m. 50; MIDI bar 50
\barNumberCheck #51 d''2(_\markup \italic "dolce" b'4..) g''16 | % m. 51; MIDI bar 51
\barNumberCheck #52 \grace { fis''16( g''16 a''16 } g''2)( e''4) r4 | % m. 52; MIDI bar 52
\barNumberCheck #53 e''4(-> d''8.) d''16 d''4 d''4 | % m. 53; MIDI bar 53
\barNumberCheck #54 e''4.( d''8 b'4) r8. d''16 | % m. 54; MIDI bar 54
\barNumberCheck #55 d''2(-> b'4..) ees''16 | % m. 55; MIDI bar 55
\barNumberCheck #56 ees''2( fis'2) | % m. 56; MIDI bar 56
\barNumberCheck #57 e''4 e''8. e''16 e''4 e''4 | % m. 57; MIDI bar 57
\barNumberCheck #58 f''1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 R1 | % m. 59; MIDI bar 59
\barNumberCheck #60 R1 | % m. 60; MIDI bar 60
\barNumberCheck #61 R1 | % m. 61; MIDI bar 61
\barNumberCheck #62 R1 | % m. 62; MIDI bar 62
\barNumberCheck #63 b'1(\pp | % m. 63; MIDI bar 63
\barNumberCheck #64 e''1) | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 R1 | % m. 69; MIDI bar 69
\barNumberCheck #70 R1 | % m. 70; MIDI bar 70
\barNumberCheck #71 R1 | % m. 71; MIDI bar 71
\barNumberCheck #72 d''4\pp d''8. d''16 d''4 d''4 | % m. 72; MIDI bar 72
\barNumberCheck #73 d''2.-> r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 g'8 r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 e''8\f r8 e''8 r8 d''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 e''8\f r8 e''8 r8 d''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g'8\ff g'8 r8 g'8 r8 g'8 r8 g'8 | % m. 83; MIDI bar 83
\barNumberCheck #84 r8 g'8 r8 g'8 r8 g'8 r8 g'8 | % m. 84; MIDI bar 84
\barNumberCheck #85 c''4.. c''16 c''4.. c''16 | % m. 85; MIDI bar 85
\barNumberCheck #86 c''4 c''4 r2 | % m. 86; MIDI bar 86
\barNumberCheck #87 c''4.. c''16 c''4.. c''16 | % m. 87; MIDI bar 87
\barNumberCheck #88 c''4 c''4 r2 | % m. 88; MIDI bar 88
\barNumberCheck #89 c''4 c''8. c''16 c''4 c''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c''2-> d''4-. r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c''4\ff c''8. c''16 c''4 c''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c''2(-> b'8-.) r8 r4 | % m. 92; MIDI bar 92
\barNumberCheck #93 g''8 r8 r8 g''8 g''4. g''8 | % m. 93; MIDI bar 93
\barNumberCheck #94 g''4 d''4 d''4 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d''4 d''4 r4 d''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 d''4 r4 d''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 d''4 d''4 d''8 d''8 d''8 d''8 | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 e''4 d''4 d''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 d''1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 d''1 | % m. 100; MIDI bar 100
\barNumberCheck #101 d''4.. d''16 d''4.. d''16 | % m. 101; MIDI bar 101
\barNumberCheck #102 d''4 d''4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 g'4..\pp^\markup \italic "Soli" g'16 g'4.. g'16 | % m. 103; MIDI bar 103
\barNumberCheck #104 g'4 g'4 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 d''1\f~ | % m. 122; MIDI bar 122
\barNumberCheck #123 d''1 | % m. 123; MIDI bar 123
\barNumberCheck #124 e''1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 e''1 | % m. 125; MIDI bar 125
\barNumberCheck #126 d''1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 d''1 | % m. 127; MIDI bar 127
\barNumberCheck #128 c''1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 c''1 | % m. 129; MIDI bar 129
\barNumberCheck #130 c''1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 c''1 | % m. 131; MIDI bar 131
\barNumberCheck #132  bes'1~  | % m. 132; MIDI bar 132
\barNumberCheck #133  bes'1  | % m. 133; MIDI bar 133
\barNumberCheck #134 f''1~ | % m. 134; MIDI bar 134
\barNumberCheck #135 f''1 | % m. 135; MIDI bar 135
\barNumberCheck #136 g''1\ff->~ | % m. 136; MIDI bar 136
\barNumberCheck #137 g''1 | % m. 137; MIDI bar 137
\barNumberCheck #138 d''1 | % m. 138; MIDI bar 138
\barNumberCheck #139 d''4 d''8. d''16 d''4 d''4 | % m. 139; MIDI bar 139
\barNumberCheck #140 c''1 | % m. 140; MIDI bar 140
\barNumberCheck #141 c''4 c''8. c''16 c''4 c''4 | % m. 141; MIDI bar 141
\barNumberCheck #142 g'8 r8 g'4.-> r8 g'4->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 g'8 r8 g'4.-> r8 g'4 | % m. 143; MIDI bar 143
\barNumberCheck #144 r4 c''2-> c''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 c''1 | % m. 145; MIDI bar 145
\barNumberCheck #146 d''1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 d''1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 d''4\pp d''8. d''16 d''4 d''4 | % m. 152; MIDI bar 152
\barNumberCheck #153 d''2( g'8) r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c''4..\ff c''16 e''4.. e''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f''4-. f''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g'4\pp g'8. g'16 g'4 g'4 | % m. 156; MIDI bar 156
\barNumberCheck #157 d''2(-> g'4) r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g'4..\ff g'16 g'4.. g'16 | % m. 158; MIDI bar 158
\barNumberCheck #159 d''4-. d''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g'4\pp g'8. g'16 g'4 g'4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c''4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 r8 g'8\pp g'8 g'8 g'4 r4 | % m. 165; MIDI bar 165
\barNumberCheck #166 r8 d''8 d''8 d''8 d''4 r4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 d''4 d''4 g'4 | % m. 167; MIDI bar 167
\barNumberCheck #168 e''2~ e''8 r8 r4 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 c''4.\!\sf c''8-.\p c''8-. d''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 c''8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 c''4.\!\sf c''8-.\p c''8-. g'8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 g'8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 e''8\ff c''16 c''16 c''8 c''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 e''16 e''16 e''8 e''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 177; MIDI bar 177
\barNumberCheck #178 c'8 r8 c'4 d'4 e'4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'4_\markup \italic "cresc." fis'4 g'2 | % m. 179; MIDI bar 179
\barNumberCheck #180 g'2 g'2\< | % m. 180; MIDI bar 180
\barNumberCheck #181 g'4 g'4 g'4 g'4 | % m. 181; MIDI bar 181
\barNumberCheck #182 g'2:8\ff g'2:8 | % m. 182; MIDI bar 182
\barNumberCheck #183 g'4-. g'4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 g'1\f->~ | % m. 191; MIDI bar 191
\barNumberCheck #192 g'2\pp r2 | % m. 192; MIDI bar 192
\barNumberCheck #193 R1 | % m. 193; MIDI bar 193
\barNumberCheck #194 R1 | % m. 194; MIDI bar 194
\barNumberCheck #195 R1 | % m. 195; MIDI bar 195
\barNumberCheck #196  R1 | % m. 196; MIDI bar 196
\barNumberCheck #197  R1 | % m. 197; MIDI bar 197
\barNumberCheck #198  R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 R1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 g'4\sf r4 r2 | % m. 209; MIDI bar 209
\barNumberCheck #210 R1 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 e''8\f r8 f''8 r8 g'8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 R1 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 e''8\f r8 f''8 r8 g'8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c''8\ff c''8 r8 c''8 r8 c''8 r8 c''8 | % m. 216; MIDI bar 216
\barNumberCheck #217 r8 c''8 r8 c''8 r8 c''8 r8 c''8 | % m. 217; MIDI bar 217
\barNumberCheck #218 f''4.. f''16 f''4.. f''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f''4 f''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 f''4.. f''16 f''4.. f''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 f''4 f''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 f''4 f''8. f''16 f''4 f''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 f''2(-> e''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 R1 | % m. 224; MIDI bar 224
\barNumberCheck #225 r2 r8 e''16 e''16 e''8 e''8 | % m. 225; MIDI bar 225
\barNumberCheck #226 e''4. e''8 f''4. g''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 a''4 d''4 g''4 d''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 e''4 g'4 r4 c''4 | % m. 228; MIDI bar 228
\barNumberCheck #229 r4 g'4 r4 c''4 | % m. 229; MIDI bar 229
\barNumberCheck #230 r4 c''4 c''8 c''8 c''8 c''8 | % m. 230; MIDI bar 230
\barNumberCheck #231 c''4 c''4 c''4 g'4 | % m. 231; MIDI bar 231
\barNumberCheck #232 g'4..\ff g'16 g'4.. g'16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g'4 g'2 g'4 | % m. 233; MIDI bar 233
\barNumberCheck #234 g'4.. g'16 g'4.. g'16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c'2 c'2 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'4 r4 c'4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c'1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
hornTwoI = {
\barNumberCheck #1 c'4..\ff c'16 c''4.. c''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c''4-. c''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g4\pp g8. g16 g4 g4 | % m. 3; MIDI bar 3
\barNumberCheck #4 g2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g4..\ff g16 g4.. g16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g4-. g4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g4\pp g8. g16 g4 g4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c'4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 r2 r8 c'8\p^\markup \italic "Soli" c'8 c'8 | % m. 11; MIDI bar 11
\barNumberCheck #12 b4 r4 r2 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 c'4-.(\pp\< c'4-. c'4-. c'4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 b2(\!->\> c'8)\! r8 r4 | % m. 17; MIDI bar 17
\barNumberCheck #18 c'4-.(\pp\< c'4-. c'4-. c'4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 b2(\!->\> c'8)\! r8 r4 | % m. 19; MIDI bar 19
\barNumberCheck #20  R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 r4 c'4.\!\sf r8 r8 g'8\p | % m. 21; MIDI bar 21
\barNumberCheck #22 g'8 r8 r4 g8 r8 r4 | % m. 22; MIDI bar 22
\barNumberCheck #23 g2(-> c'8) r8 r4 | % m. 23; MIDI bar 23
\barNumberCheck #24  R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 r4 c'4.\!\sf r8 r8 g'8\p | % m. 25; MIDI bar 25
\barNumberCheck #26 g'8 r8 r4 r2 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'8\ff c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 28; MIDI bar 28
\barNumberCheck #29 c8 r8 c'4_\markup \italic "cresc." d'4 e'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'4 fis'4 g'2~ | % m. 30; MIDI bar 30
\barNumberCheck #31  g'1  | % m. 31; MIDI bar 31
\barNumberCheck #32 g4\< g8. g16 g4 g4 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'4..\ff c'16 c'4.. c'16 | % m. 33; MIDI bar 33
\barNumberCheck #34 c'4-. c'4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g4.. g16 g4.. g16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g4-. g4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 e'4.. e'16 e'4.. e'16 | % m. 37; MIDI bar 37
\barNumberCheck #38 e'4-. e'4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 g'4.. g'16 g'4.. g'16 | % m. 39; MIDI bar 39
\barNumberCheck #40 g'4-. g'4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 c'4 c'8. c'16 c'4 c'4 | % m. 41; MIDI bar 41
\barNumberCheck #42 g'1 | % m. 42; MIDI bar 42
\barNumberCheck #43 c'4 r4 r4 c'4->( | % m. 43; MIDI bar 43
\barNumberCheck #44 c'8) r8 r4 r4 c'4->( | % m. 44; MIDI bar 44
\barNumberCheck #45 g'8) r8 d''2-> g'4( | % m. 45; MIDI bar 45
\barNumberCheck #46 d''8) r8 d''2-> g'4 | % m. 46; MIDI bar 46
\barNumberCheck #47 d''4 r4 r2 | % m. 47; MIDI bar 47
\barNumberCheck #48 d''4_\markup \italic "cresc." d''4 d''8 d''8 d''8 d''8 | % m. 48; MIDI bar 48
\barNumberCheck #49 d''8\ff d''8 d''8 d''8 d''8 d''8 d''8 d''8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d''4-. d''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51  R1 | % m. 51; MIDI bar 51
\barNumberCheck #52  R1 | % m. 52; MIDI bar 52
\barNumberCheck #53  R1 | % m. 53; MIDI bar 53
\barNumberCheck #54  R1 | % m. 54; MIDI bar 54
\barNumberCheck #55  R1 | % m. 55; MIDI bar 55
\barNumberCheck #56  R1 | % m. 56; MIDI bar 56
\barNumberCheck #57  R1 | % m. 57; MIDI bar 57
\barNumberCheck #58  R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1 | % m. 59; MIDI bar 59
\barNumberCheck #60 R1 | % m. 60; MIDI bar 60
\barNumberCheck #61 R1 | % m. 61; MIDI bar 61
\barNumberCheck #62 R1 | % m. 62; MIDI bar 62
\barNumberCheck #63 g1(\pp | % m. 63; MIDI bar 63
\barNumberCheck #64 c1) | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 R1 | % m. 69; MIDI bar 69
\barNumberCheck #70 R1 | % m. 70; MIDI bar 70
\barNumberCheck #71 R1 | % m. 71; MIDI bar 71
\barNumberCheck #72  R1 | % m. 72; MIDI bar 72
\barNumberCheck #73  R1 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76  R1 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 e'8\f r8 e'8 r8 d''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 e'8\f r8 e'8 r8 d''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g8\ff g8 r8 g8 r8 g8 r8 g8 | % m. 83; MIDI bar 83
\barNumberCheck #84 r8 g8 r8 g8 r8 g8 r8 g8 | % m. 84; MIDI bar 84
\barNumberCheck #85 c'4.. c'16 c'4.. c'16 | % m. 85; MIDI bar 85
\barNumberCheck #86 c'4 c'4 r2 | % m. 86; MIDI bar 86
\barNumberCheck #87 c'4.. c'16 c'4.. c'16 | % m. 87; MIDI bar 87
\barNumberCheck #88 c'4 c'4 r2 | % m. 88; MIDI bar 88
\barNumberCheck #89 c'4 c'8. c'16 c'4 c'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c'2-> g'4-. r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c'4\ff c'8. c'16 c'4 c'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c'2(-> b8-.) r8 r4 | % m. 92; MIDI bar 92
\barNumberCheck #93 g'8 r8 r8 g'8 g'4. g'8 | % m. 93; MIDI bar 93
\barNumberCheck #94 g'4 c''4 g'4 e'4 | % m. 94; MIDI bar 94
\barNumberCheck #95 g'4 g'4 r4 g'4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 g'4 r4 g'4 | % m. 96; MIDI bar 96
\barNumberCheck #97 g'4 d''4 d''8 d''8 d''8 d''8 | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 c''4 g'4 c''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 g1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g4.. g16 g4.. g16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g4 g4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 g4..\pp^\markup \italic "Soli" g16 g4.. g16 | % m. 103; MIDI bar 103
\barNumberCheck #104 g4 g4 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122  R1 | % m. 122; MIDI bar 122
\barNumberCheck #123  R1 | % m. 123; MIDI bar 123
\barNumberCheck #124 e'1\f~ | % m. 124; MIDI bar 124
\barNumberCheck #125 e'1 | % m. 125; MIDI bar 125
\barNumberCheck #126  R1 | % m. 126; MIDI bar 126
\barNumberCheck #127  R1 | % m. 127; MIDI bar 127
\barNumberCheck #128 c'1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 c'1 | % m. 129; MIDI bar 129
\barNumberCheck #130 c'1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 c'1 | % m. 131; MIDI bar 131
\barNumberCheck #132  bes'1~  | % m. 132; MIDI bar 132
\barNumberCheck #133  bes'1  | % m. 133; MIDI bar 133
\barNumberCheck #134 bes'1~ | % m. 134; MIDI bar 134
\barNumberCheck #135 bes'1 | % m. 135; MIDI bar 135
\barNumberCheck #136 bes'1\ff->~ | % m. 136; MIDI bar 136
\barNumberCheck #137 bes'1 | % m. 137; MIDI bar 137
\barNumberCheck #138 g'1 | % m. 138; MIDI bar 138
\barNumberCheck #139 g'4 g'8. g'16 g'4 g'4 | % m. 139; MIDI bar 139
\barNumberCheck #140 g1 | % m. 140; MIDI bar 140
\barNumberCheck #141 g4 g8. g16 g4 g4 | % m. 141; MIDI bar 141
\barNumberCheck #142 g8 r8 g4.-> r8 g4->~ | % m. 142; MIDI bar 142
\barNumberCheck #143 g8 r8 g4.-> r8 g4 | % m. 143; MIDI bar 143
\barNumberCheck #144 r4 c'2-> c'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 c'1 | % m. 145; MIDI bar 145
\barNumberCheck #146  R1 | % m. 146; MIDI bar 146
\barNumberCheck #147  R1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g4\pp g8. g16 g4 g4 | % m. 152; MIDI bar 152
\barNumberCheck #153 g2~ g8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'4..\ff c'16 c''4.. c''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 c''4-. c''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g4\pp g8. g16 g4 g4 | % m. 156; MIDI bar 156
\barNumberCheck #157 g2. r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g4..\ff g16 g4.. g16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g4-. g4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g4\pp g8. g16 g4 g4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c'4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 r8 g8\pp g8 g8 g4 r4 | % m. 165; MIDI bar 165
\barNumberCheck #166 r8 g8 g8 g8 g4 r4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 g4 g4 g4 | % m. 167; MIDI bar 167
\barNumberCheck #168 c'2~ c'8 r8 r4 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 c'4.\!\sf r8 r4 | % m. 170; MIDI bar 170
\barNumberCheck #171  R1 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 c'4.\!\sf r8 r4 | % m. 174; MIDI bar 174
\barNumberCheck #175  R1 | % m. 175; MIDI bar 175
\barNumberCheck #176 c'8\ff c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 177; MIDI bar 177
\barNumberCheck #178 c8 r8 c'4 d'4 e'4 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'4_\markup \italic "cresc." fis'4 g'2 | % m. 179; MIDI bar 179
\barNumberCheck #180 g'2 g'2\< | % m. 180; MIDI bar 180
\barNumberCheck #181 g'4 g'4 g4 g4 | % m. 181; MIDI bar 181
\barNumberCheck #182 g2:8\ff g2:8 | % m. 182; MIDI bar 182
\barNumberCheck #183 g4-. g4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 g1\f->~ | % m. 191; MIDI bar 191
\barNumberCheck #192 g2\pp r2 | % m. 192; MIDI bar 192
\barNumberCheck #193 R1 | % m. 193; MIDI bar 193
\barNumberCheck #194 R1 | % m. 194; MIDI bar 194
\barNumberCheck #195 R1 | % m. 195; MIDI bar 195
\barNumberCheck #196 e'2\p^\markup \italic "Solo" g'2 | % m. 196; MIDI bar 196
\barNumberCheck #197 a'2 c''2 | % m. 197; MIDI bar 197
\barNumberCheck #198 g'4 r4 r2 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 R1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 g4\sf r4 r2 | % m. 209; MIDI bar 209
\barNumberCheck #210 R1 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 c''8\f r8 d''8 r8 g8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 R1 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 c''8\f r8 d''8 r8 g8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'8\ff c'8 r8 c'8 r8 c'8 r8 c'8 | % m. 216; MIDI bar 216
\barNumberCheck #217 r8 c'8 r8 c'8 r8 c'8 r8 c'8 | % m. 217; MIDI bar 217
\barNumberCheck #218 d''4.. d''16 d''4.. d''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 d''4 d''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 d''4.. d''16 d''4.. d''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 d''4 d''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 d''4 d''8. d''16 d''4 d''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 d''2(-> e''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 R1 | % m. 224; MIDI bar 224
\barNumberCheck #225 r2 r8 e'16 e'16 e'8 e'8 | % m. 225; MIDI bar 225
\barNumberCheck #226 e'4. e'8 c''4. c''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 c''4 g'4 g'4 c''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 c''4 g4 r4 g4 | % m. 228; MIDI bar 228
\barNumberCheck #229 r4 c'4 r4 c'4 | % m. 229; MIDI bar 229
\barNumberCheck #230 r4 c'4 c'8 c'8 c'8 c'8 | % m. 230; MIDI bar 230
\barNumberCheck #231 c'4 c'4 c'4 g4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c4..\ff c16 c4.. c16 | % m. 232; MIDI bar 232
\barNumberCheck #233 c4 c2 c4 | % m. 233; MIDI bar 233
\barNumberCheck #234 c4.. c16 c4.. c16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c2 c2 | % m. 235; MIDI bar 235
\barNumberCheck #236 c4 r4 c4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
trumpetOneI = {
\barNumberCheck #1 c''4..\ff c''16 c''4.. c''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c''4-. c''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g'4\pp g'8. g'16 g'4 g'4 | % m. 3; MIDI bar 3
\barNumberCheck #4 g'2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'4..\ff g'16 g'4.. g'16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g'4-. g'4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g'4\pp g'8. g'16 g'4 g'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c''4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'4\ff c''4 r4 g'4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c''8 c''16 c''16 c''8 c''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 28; MIDI bar 28
\barNumberCheck #29 c''8 r8 r4 r2 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1 | % m. 31; MIDI bar 31
\barNumberCheck #32 g'4\p\< g'4 g'4 g'4 | % m. 32; MIDI bar 32
\barNumberCheck #33 c''4..\ff c''16 e''4.. e''16 | % m. 33; MIDI bar 33
\barNumberCheck #34 e''4-. e''4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 d''4.. d''16 d''4.. d''16 | % m. 35; MIDI bar 35
\barNumberCheck #36 d''4-. d''4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 c''4.. c''16 c''4.. c''16 | % m. 37; MIDI bar 37
\barNumberCheck #38 c''4-. c''4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 g'4.. g'16 g'4.. g'16 | % m. 39; MIDI bar 39
\barNumberCheck #40 g'4-. g'4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 e''4 e''8. e''16 e''4 e''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 d''1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 r2 r4 e''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 d''4 r2 e''4 | % m. 46; MIDI bar 46
\barNumberCheck #47  d''1\p~  | % m. 47; MIDI bar 47
\barNumberCheck #48 d''2_\markup \italic "cresc." d''4 d''4 | % m. 48; MIDI bar 48
\barNumberCheck #49 d''4\ff d''4 d''8 d''8 d''8 d''8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d''4-. d''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 d''1\pp | % m. 59; MIDI bar 59
\barNumberCheck #60 e''1\pp~ | % m. 60; MIDI bar 60
\barNumberCheck #61 e''1 | % m. 61; MIDI bar 61
\barNumberCheck #62 d''4 r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 R1 | % m. 69; MIDI bar 69
\barNumberCheck #70 R1 | % m. 70; MIDI bar 70
\barNumberCheck #71 R1 | % m. 71; MIDI bar 71
\barNumberCheck #72 R1 | % m. 72; MIDI bar 72
\barNumberCheck #73 R1 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 R1 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 g'8\f r8 c''8 r8 d''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 g'8\f r8 c''8 r8 d''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g'4 r4 r2 | % m. 83; MIDI bar 83
\barNumberCheck #84 R1 | % m. 84; MIDI bar 84
\barNumberCheck #85 c''4..\f c''16 c''4.. c''16 | % m. 85; MIDI bar 85
\barNumberCheck #86 c''4 c''4 r2 | % m. 86; MIDI bar 86
\barNumberCheck #87 c''4.. c''16 c''4.. c''16 | % m. 87; MIDI bar 87
\barNumberCheck #88 c''4 c''4 r2 | % m. 88; MIDI bar 88
\barNumberCheck #89 c''4 c''8. c''16 c''4 c''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c''2-> d''4-. r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c''4\ff c''8. c''16 c''4 c''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c''2 r2 | % m. 92; MIDI bar 92
\barNumberCheck #93 R1 | % m. 93; MIDI bar 93
\barNumberCheck #94 r4 d''4 d''4 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d''4 d''4 r4 d''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 d''4 r4 d''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 d''4 d''4 d''8 d''8 d''8 d''8 | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 c''4 g'4 d''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g'1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 g'1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g'4.. g'16 g'4.. g'16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g'4 g'4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 g'4..\pp^\markup \italic "Soli" g'16 g'4.. g'16 | % m. 105; MIDI bar 105
\barNumberCheck #106 g'4 g'4 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 d''1\f~ | % m. 122; MIDI bar 122
\barNumberCheck #123 d''2 r2 | % m. 123; MIDI bar 123
\barNumberCheck #124 e'1~ | % m. 124; MIDI bar 124
\barNumberCheck #125 e'2 r2 | % m. 125; MIDI bar 125
\barNumberCheck #126 d''1~ | % m. 126; MIDI bar 126
\barNumberCheck #127 d''2 r2 | % m. 127; MIDI bar 127
\barNumberCheck #128 c''1~ | % m. 128; MIDI bar 128
\barNumberCheck #129 c''2 r2 | % m. 129; MIDI bar 129
\barNumberCheck #130 c''1~ | % m. 130; MIDI bar 130
\barNumberCheck #131 c''2 r2 | % m. 131; MIDI bar 131
\barNumberCheck #132 R1 | % m. 132; MIDI bar 132
\barNumberCheck #133 R1 | % m. 133; MIDI bar 133
\barNumberCheck #134 d''1\f~ | % m. 134; MIDI bar 134
\barNumberCheck #135 d''1 | % m. 135; MIDI bar 135
\barNumberCheck #136 g'1\f~ | % m. 136; MIDI bar 136
\barNumberCheck #137 g'1 | % m. 137; MIDI bar 137
\barNumberCheck #138 g'1\f | % m. 138; MIDI bar 138
\barNumberCheck #139 g'4 g'8. g'16 g'4 g'4 | % m. 139; MIDI bar 139
\barNumberCheck #140 g'1 | % m. 140; MIDI bar 140
\barNumberCheck #141 g'4 c''4 r2 | % m. 141; MIDI bar 141
\barNumberCheck #142 r4 g'4 r4 g'8. g'16 | % m. 142; MIDI bar 142
\barNumberCheck #143 g'4 r2 g'8. g'16 | % m. 143; MIDI bar 143
\barNumberCheck #144 g'8 r8 c''2 c''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 c''4 c''8. c''16 c''4 c''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 d''1~ | % m. 146; MIDI bar 146
\barNumberCheck #147 d''1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g'4\pp g'8. g'16 g'4 g'4 | % m. 152; MIDI bar 152
\barNumberCheck #153 g'2~ g'8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c''4..\ff c''16 c''4.. c''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 c''4-. c''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g'4\pp g'8. g'16 g'4 g'4 | % m. 156; MIDI bar 156
\barNumberCheck #157 g'2. r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g'4..\ff g'16 g'4.. g'16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g'4-. g'4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g'4\pp g'8. g'16 g'4 g'4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c''4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 R1 | % m. 170; MIDI bar 170
\barNumberCheck #171 R1 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 R1 | % m. 174; MIDI bar 174
\barNumberCheck #175 R1 | % m. 175; MIDI bar 175
\barNumberCheck #176 c'4\ff c''4 r4 g'4 | % m. 176; MIDI bar 176
\barNumberCheck #177 c''8 c''16 c''16 c''8 c''8 g'8-> g'16 g'16 g'8-> g'8 | % m. 177; MIDI bar 177
\barNumberCheck #178 c''8 r8 r4 r2 | % m. 178; MIDI bar 178
\barNumberCheck #179 R1 | % m. 179; MIDI bar 179
\barNumberCheck #180 g'1\p | % m. 180; MIDI bar 180
\barNumberCheck #181 g'2\< g'2 | % m. 181; MIDI bar 181
\barNumberCheck #182 g'4\ff g'4 g'2:8 | % m. 182; MIDI bar 182
\barNumberCheck #183 g'4-. g'4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 R1 | % m. 191; MIDI bar 191
\barNumberCheck #192 g'1(\pp^\markup \italic "Solo" | % m. 192; MIDI bar 192
\barNumberCheck #193 e''1) | % m. 193; MIDI bar 193
\barNumberCheck #194 d''1~ | % m. 194; MIDI bar 194
\barNumberCheck #195 d''4 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 c''1\pp~ | % m. 196; MIDI bar 196
\barNumberCheck #197 c''1 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 R1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 g'1\fp~ | % m. 209; MIDI bar 209
\barNumberCheck #210 g'1~ | % m. 210; MIDI bar 210
\barNumberCheck #211 g'4\f c''8 r8 d''8 r8 d''8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 g'1\fp~ | % m. 212; MIDI bar 212
\barNumberCheck #213 g'1\pp~ | % m. 213; MIDI bar 213
\barNumberCheck #214 g'1~ | % m. 214; MIDI bar 214
\barNumberCheck #215 g'4\f c''8 r8 d''8 r8 d''8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c''8\ff c''8 r8 c''8 r8 c''8 r8 c''8 | % m. 216; MIDI bar 216
\barNumberCheck #217 r8 c''8 r8 c''8 r8 c''8 r8 c''8 | % m. 217; MIDI bar 217
\barNumberCheck #218 d''4.. d''16 d''4.. d''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 d''4 d''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 d''4.. d''16 d''4.. d''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 d''4 d''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 d''4 d''8. d''16 d''4 d''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 d''2(-> c''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 R1 | % m. 224; MIDI bar 224
\barNumberCheck #225 r2 r8 e''16 e''16 e''8 e''8 | % m. 225; MIDI bar 225
\barNumberCheck #226 e''4. e''8 c''4. c''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 c''4 g'4 c''4 c''4 | % m. 227; MIDI bar 227
\barNumberCheck #228 c''4 e'4 r4 g'4 | % m. 228; MIDI bar 228
\barNumberCheck #229 r4 c''4 r4 e''4 | % m. 229; MIDI bar 229
\barNumberCheck #230 r4 g''4 g''8 g''8 g''8 g''8 | % m. 230; MIDI bar 230
\barNumberCheck #231 g''4 c''4 e''4 d''4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c''4..\ff c''16 c''4.. c''16 | % m. 232; MIDI bar 232
\barNumberCheck #233 c''4 c''2 c''4 | % m. 233; MIDI bar 233
\barNumberCheck #234 c''4.. c''16 e''4.. e''16 | % m. 234; MIDI bar 234
\barNumberCheck #235 g''2 e''2 | % m. 235; MIDI bar 235
\barNumberCheck #236 c''4 r4 c''4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c''1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
trumpetTwoI = {
\barNumberCheck #1 c'4..\ff c'16 c'4.. c'16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c'4-. c'4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g4\pp g8. g16 g4 g4 | % m. 3; MIDI bar 3
\barNumberCheck #4 g2. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g4..\ff g16 g4.. g16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g4-. g4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g4\pp g8. g16 g4 g4 | % m. 7; MIDI bar 7
\barNumberCheck #8 e'4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'4\ff c'4 r4 g4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 28; MIDI bar 28
\barNumberCheck #29 c'8 r8 r4 r2 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1 | % m. 31; MIDI bar 31
\barNumberCheck #32 g4\p\< g4 g4 g4 | % m. 32; MIDI bar 32
\barNumberCheck #33 e'4..\ff e'16 g'4.. g'16 | % m. 33; MIDI bar 33
\barNumberCheck #34 g'4-. g'4-. r2 | % m. 34; MIDI bar 34
\barNumberCheck #35 g'4.. g'16 g'4.. g'16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g'4-. g'4-. r2 | % m. 36; MIDI bar 36
\barNumberCheck #37 c'4.. c'16 c'4.. c'16 | % m. 37; MIDI bar 37
\barNumberCheck #38 c'4-. c'4-. r2 | % m. 38; MIDI bar 38
\barNumberCheck #39 e'4.. e'16 e'4.. e'16 | % m. 39; MIDI bar 39
\barNumberCheck #40 e'4-. e'4-. r2 | % m. 40; MIDI bar 40
\barNumberCheck #41 g'4 g'8. g'16 g'4 g'4 | % m. 41; MIDI bar 41
\barNumberCheck #42 g'1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 r2 r4 e''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 d''4 r2 e''4 | % m. 46; MIDI bar 46
\barNumberCheck #47  d''1\p~  | % m. 47; MIDI bar 47
\barNumberCheck #48 d''2_\markup \italic "cresc." d''4 d''4 | % m. 48; MIDI bar 48
\barNumberCheck #49 d''4\ff d''4 d''8 d''8 d''8 d''8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d''4-. d''4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59  R1 | % m. 59; MIDI bar 59
\barNumberCheck #60 g'1\pp~ | % m. 60; MIDI bar 60
\barNumberCheck #61 g'1 | % m. 61; MIDI bar 61
\barNumberCheck #62 d''4 r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 R1 | % m. 69; MIDI bar 69
\barNumberCheck #70 R1 | % m. 70; MIDI bar 70
\barNumberCheck #71 R1 | % m. 71; MIDI bar 71
\barNumberCheck #72 R1 | % m. 72; MIDI bar 72
\barNumberCheck #73 R1 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 R1 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 e'8\f r8 e'8 r8 d''8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 e'8\f r8 e'8 r8 d''8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g4 r4 r2 | % m. 83; MIDI bar 83
\barNumberCheck #84 R1 | % m. 84; MIDI bar 84
\barNumberCheck #85 c'4..\f c'16 c'4.. c'16 | % m. 85; MIDI bar 85
\barNumberCheck #86 c'4 c'4 r2 | % m. 86; MIDI bar 86
\barNumberCheck #87 c'4.. c'16 c'4.. c'16 | % m. 87; MIDI bar 87
\barNumberCheck #88 c'4 c'4 r2 | % m. 88; MIDI bar 88
\barNumberCheck #89 c'4 c'8. c'16 c'4 c'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c'2-> g'4-. r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c'4\ff c'8. c'16 c'4 c'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c'2 r2 | % m. 92; MIDI bar 92
\barNumberCheck #93 R1 | % m. 93; MIDI bar 93
\barNumberCheck #94 r4 d''4 d''4 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d''4 d''4 r4 d''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 d''4 r4 d''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 d''4 d''4 d''8 d''8 d''8 d''8 | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 c'4 g4 d''4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g1~ | % m. 99; MIDI bar 99
\barNumberCheck #100 g1 | % m. 100; MIDI bar 100
\barNumberCheck #101 g4.. g16 g4.. g16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g4 g4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 g4..\pp^\markup \italic "Soli" g16 g4.. g16 | % m. 105; MIDI bar 105
\barNumberCheck #106 g4 g4 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122  R1 | % m. 122; MIDI bar 122
\barNumberCheck #123  R1 | % m. 123; MIDI bar 123
\barNumberCheck #124  R1 | % m. 124; MIDI bar 124
\barNumberCheck #125  R1 | % m. 125; MIDI bar 125
\barNumberCheck #126  R1 | % m. 126; MIDI bar 126
\barNumberCheck #127  R1 | % m. 127; MIDI bar 127
\barNumberCheck #128  R1 | % m. 128; MIDI bar 128
\barNumberCheck #129  R1 | % m. 129; MIDI bar 129
\barNumberCheck #130  R1 | % m. 130; MIDI bar 130
\barNumberCheck #131  R1 | % m. 131; MIDI bar 131
\barNumberCheck #132 R1 | % m. 132; MIDI bar 132
\barNumberCheck #133 R1 | % m. 133; MIDI bar 133
\barNumberCheck #134  R1 | % m. 134; MIDI bar 134
\barNumberCheck #135  R1 | % m. 135; MIDI bar 135
\barNumberCheck #136 g1\f~ | % m. 136; MIDI bar 136
\barNumberCheck #137 g1 | % m. 137; MIDI bar 137
\barNumberCheck #138 g1\f | % m. 138; MIDI bar 138
\barNumberCheck #139 g4 g8. g16 g4 g4 | % m. 139; MIDI bar 139
\barNumberCheck #140 g4.. g16 c'4.. c'16 | % m. 140; MIDI bar 140
\barNumberCheck #141 g4 c'4 r2 | % m. 141; MIDI bar 141
\barNumberCheck #142 r4 g4 r4 g8. g16 | % m. 142; MIDI bar 142
\barNumberCheck #143 g4 r2 g8. g16 | % m. 143; MIDI bar 143
\barNumberCheck #144 g8 r8 c'2 c'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 c'4 c'8. c'16 c'4 c'4 | % m. 145; MIDI bar 145
\barNumberCheck #146  R1 | % m. 146; MIDI bar 146
\barNumberCheck #147  R1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g4\pp g8. g16 g4 g4 | % m. 152; MIDI bar 152
\barNumberCheck #153 g2~ g8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'4..\ff c'16 c'4.. c'16 | % m. 154; MIDI bar 154
\barNumberCheck #155 c'4-. c'4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g4\pp g8. g16 g4 g4 | % m. 156; MIDI bar 156
\barNumberCheck #157 g2. r4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g4..\ff g16 g4.. g16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g4-. g4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g4\pp g8. g16 g4 g4 | % m. 160; MIDI bar 160
\barNumberCheck #161 e'4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 R1 | % m. 170; MIDI bar 170
\barNumberCheck #171 R1 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 R1 | % m. 174; MIDI bar 174
\barNumberCheck #175 R1 | % m. 175; MIDI bar 175
\barNumberCheck #176 c'4\ff c'4 r4 g4 | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 c'16 c'16 c'8 c'8 g8-> g16 g16 g8-> g8 | % m. 177; MIDI bar 177
\barNumberCheck #178 c'8 r8 r4 r2 | % m. 178; MIDI bar 178
\barNumberCheck #179 R1 | % m. 179; MIDI bar 179
\barNumberCheck #180  R1 | % m. 180; MIDI bar 180
\barNumberCheck #181 g2\p\< g2 | % m. 181; MIDI bar 181
\barNumberCheck #182 g4\ff g4 g2:8 | % m. 182; MIDI bar 182
\barNumberCheck #183 g4-. g4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 R1 | % m. 191; MIDI bar 191
\barNumberCheck #192  R1 | % m. 192; MIDI bar 192
\barNumberCheck #193  R1 | % m. 193; MIDI bar 193
\barNumberCheck #194  R1 | % m. 194; MIDI bar 194
\barNumberCheck #195  R1 | % m. 195; MIDI bar 195
\barNumberCheck #196 c'1\pp~ | % m. 196; MIDI bar 196
\barNumberCheck #197 c'1 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 R1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 g1\fp~ | % m. 209; MIDI bar 209
\barNumberCheck #210 g1~ | % m. 210; MIDI bar 210
\barNumberCheck #211 g4\f c'8 r8 d''8-. r8 g'8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 g1\fp~ | % m. 212; MIDI bar 212
\barNumberCheck #213 g1\pp~ | % m. 213; MIDI bar 213
\barNumberCheck #214 g1~ | % m. 214; MIDI bar 214
\barNumberCheck #215 g4\f c'8 r8 d''8-. r8 g'8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'8\ff c'8 r8 c'8 r8 c'8 r8 c'8 | % m. 216; MIDI bar 216
\barNumberCheck #217 r8 c'8 r8 c'8 r8 c'8 r8 c'8 | % m. 217; MIDI bar 217
\barNumberCheck #218 d''4.. d''16 d''4.. d''16 | % m. 218; MIDI bar 218
\barNumberCheck #219 d''4 d''2.-> | % m. 219; MIDI bar 219
\barNumberCheck #220 d''4.. d''16 d''4.. d''16 | % m. 220; MIDI bar 220
\barNumberCheck #221 d''4 d''2.-> | % m. 221; MIDI bar 221
\barNumberCheck #222 d''4 d''8. d''16 d''4 d''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 d''2(-> c''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 R1 | % m. 224; MIDI bar 224
\barNumberCheck #225 r2 r8 e'16 e'16 e'8 e'8 | % m. 225; MIDI bar 225
\barNumberCheck #226 e'4. e'8 c'4. c'8 | % m. 226; MIDI bar 226
\barNumberCheck #227 c'4 g4 c'4 c'4 | % m. 227; MIDI bar 227
\barNumberCheck #228 c'4 c'4 r4 c'4 | % m. 228; MIDI bar 228
\barNumberCheck #229 r4 e'4 r4 g'4 | % m. 229; MIDI bar 229
\barNumberCheck #230 r4 e''4 e''8 e''8 e''8 e''8 | % m. 230; MIDI bar 230
\barNumberCheck #231 e''4 c'4 c''4 g'4 | % m. 231; MIDI bar 231
\barNumberCheck #232 e'4..\ff e'16 e'4.. e'16 | % m. 232; MIDI bar 232
\barNumberCheck #233 e'4 e'2 e'4 | % m. 233; MIDI bar 233
\barNumberCheck #234 e'4.. e'16 c''4.. c''16 | % m. 234; MIDI bar 234
\barNumberCheck #235 e''2 c''2 | % m. 235; MIDI bar 235
\barNumberCheck #236 e'4 r4 e'4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c'1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
timpaniI = {
\barNumberCheck #1 c4..\ff c16 c4.. c16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c4 c4 r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 g,4\pp g,8. g,16 g,4 g,4 | % m. 3; MIDI bar 3
\barNumberCheck #4 g,4 r4 r2 | % m. 4; MIDI bar 4
\barNumberCheck #5 g,4..\ff g,16 g,4.. g,16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g,4 g,4 r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 g,4\pp g,8. g,16 g,4 g,4 | % m. 7; MIDI bar 7
\barNumberCheck #8 c4 r4 r2 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c4\ff c4 r4 g,4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c8 c16 c16 c8 c8 g,8-> g,16 g,16 g,8-> g,8 | % m. 28; MIDI bar 28
\barNumberCheck #29 c8 r8 r4 r2 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1 | % m. 31; MIDI bar 31
\barNumberCheck #32 g,1:32\< | % m. 32; MIDI bar 32
\barNumberCheck #33 c1:32\ff | % m. 33; MIDI bar 33
\barNumberCheck #34 c4 c2.:32 | % m. 34; MIDI bar 34
\barNumberCheck #35 g,1:32 | % m. 35; MIDI bar 35
\barNumberCheck #36 g,4 g,2.:32 | % m. 36; MIDI bar 36
\barNumberCheck #37 c1:32 | % m. 37; MIDI bar 37
\barNumberCheck #38 c4 c2.:32 | % m. 38; MIDI bar 38
\barNumberCheck #39 g,1:32 | % m. 39; MIDI bar 39
\barNumberCheck #40 g,4 g,2.:32 | % m. 40; MIDI bar 40
\barNumberCheck #41 c4 c8. c16 c4 c4 | % m. 41; MIDI bar 41
\barNumberCheck #42 g,1:32 | % m. 42; MIDI bar 42
\barNumberCheck #43 c4 r4 r2 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 R1 | % m. 45; MIDI bar 45
\barNumberCheck #46 R1 | % m. 46; MIDI bar 46
\barNumberCheck #47 R1 | % m. 47; MIDI bar 47
\barNumberCheck #48 R1 | % m. 48; MIDI bar 48
\barNumberCheck #49 c1:32\ff | % m. 49; MIDI bar 49
\barNumberCheck #50 c4 c4 r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1 | % m. 59; MIDI bar 59
\barNumberCheck #60 R1 | % m. 60; MIDI bar 60
\barNumberCheck #61 R1 | % m. 61; MIDI bar 61
\barNumberCheck #62 R1 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 R1 | % m. 65; MIDI bar 65
\barNumberCheck #66 R1 | % m. 66; MIDI bar 66
\barNumberCheck #67 R1 | % m. 67; MIDI bar 67
\barNumberCheck #68 R1 | % m. 68; MIDI bar 68
\barNumberCheck #69 R1 | % m. 69; MIDI bar 69
\barNumberCheck #70 R1 | % m. 70; MIDI bar 70
\barNumberCheck #71 R1 | % m. 71; MIDI bar 71
\barNumberCheck #72 R1 | % m. 72; MIDI bar 72
\barNumberCheck #73 R1 | % m. 73; MIDI bar 73
\barNumberCheck #74 R1 | % m. 74; MIDI bar 74
\barNumberCheck #75 R1 | % m. 75; MIDI bar 75
\barNumberCheck #76 R1 | % m. 76; MIDI bar 76
\barNumberCheck #77 R1 | % m. 77; MIDI bar 77
\barNumberCheck #78 r4 g,8\f r8 c8 r8 c8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 R1 | % m. 81; MIDI bar 81
\barNumberCheck #82 r4 g,8\f r8 c8 r8 c8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g,4 r4 r2 | % m. 83; MIDI bar 83
\barNumberCheck #84 R1 | % m. 84; MIDI bar 84
\barNumberCheck #85 c1:32\ff | % m. 85; MIDI bar 85
\barNumberCheck #86 c1:32 | % m. 86; MIDI bar 86
\barNumberCheck #87 c1:32 | % m. 87; MIDI bar 87
\barNumberCheck #88 c1:32 | % m. 88; MIDI bar 88
\barNumberCheck #89 c4 c8. c16 c4 c4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c2:32-> g,4 r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c4 c8. c16 c4 c4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c2:32 r2 | % m. 92; MIDI bar 92
\barNumberCheck #93 r2 r4 r8 g,8 | % m. 93; MIDI bar 93
\barNumberCheck #94 c4 c4 g,4 g,4 | % m. 94; MIDI bar 94
\barNumberCheck #95 r4 g,4 r4 g,4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 g,4 r4 g,4 | % m. 96; MIDI bar 96
\barNumberCheck #97 g,4 g,4 g,8 g,8 g,8 g,8 | % m. 97; MIDI bar 97
\barNumberCheck #98 g,4 c4 g,4 c4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g,1:32 | % m. 99; MIDI bar 99
\barNumberCheck #100 g,1:32 | % m. 100; MIDI bar 100
\barNumberCheck #101 g,4.. g,16 g,4.. g,16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g,4 g,4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 R1 | % m. 117; MIDI bar 117
\barNumberCheck #118 R1 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 R1 | % m. 122; MIDI bar 122
\barNumberCheck #123 R1 | % m. 123; MIDI bar 123
\barNumberCheck #124 R1 | % m. 124; MIDI bar 124
\barNumberCheck #125 R1 | % m. 125; MIDI bar 125
\barNumberCheck #126 R1 | % m. 126; MIDI bar 126
\barNumberCheck #127 R1 | % m. 127; MIDI bar 127
\barNumberCheck #128 c1:32 | % m. 128; MIDI bar 128
\barNumberCheck #129 c1:32 | % m. 129; MIDI bar 129
\barNumberCheck #130 c1:32 | % m. 130; MIDI bar 130
\barNumberCheck #131 c1:32 | % m. 131; MIDI bar 131
\barNumberCheck #132 R1 | % m. 132; MIDI bar 132
\barNumberCheck #133 R1 | % m. 133; MIDI bar 133
\barNumberCheck #134 R1 | % m. 134; MIDI bar 134
\barNumberCheck #135 R1 | % m. 135; MIDI bar 135
\barNumberCheck #136 R1 | % m. 136; MIDI bar 136
\barNumberCheck #137 R1 | % m. 137; MIDI bar 137
\barNumberCheck #138 g,1:32\f | % m. 138; MIDI bar 138
\barNumberCheck #139 g,1:32 | % m. 139; MIDI bar 139
\barNumberCheck #140 g,1:32 | % m. 140; MIDI bar 140
\barNumberCheck #141 g,1:32 | % m. 141; MIDI bar 141
\barNumberCheck #142 g,4 r4 r4 g,4:32 | % m. 142; MIDI bar 142
\barNumberCheck #143 g,8 r8 r4 r4 g,4:32 | % m. 143; MIDI bar 143
\barNumberCheck #144 r4 c2.:32\ff | % m. 144; MIDI bar 144
\barNumberCheck #145 c1:32 | % m. 145; MIDI bar 145
\barNumberCheck #146 R1 | % m. 146; MIDI bar 146
\barNumberCheck #147 R1 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g,4\pp g,8. g,16 g,4 g,4 | % m. 152; MIDI bar 152
\barNumberCheck #153 g,2~ g,8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c4..\ff c16 c4.. c16 | % m. 154; MIDI bar 154
\barNumberCheck #155 c4 c4 r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 g,4\pp g,8. g,16 g,4 g,4 | % m. 156; MIDI bar 156
\barNumberCheck #157 g,4 r4 r2 | % m. 157; MIDI bar 157
\barNumberCheck #158 g,4..\ff g,16 g,4.. g,16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g,4 g,4 r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 g,4\pp g,8. g,16 g,4 g,4 | % m. 160; MIDI bar 160
\barNumberCheck #161 c4 r4 r2 | % m. 161; MIDI bar 161
\barNumberCheck #162 R1 | % m. 162; MIDI bar 162
\barNumberCheck #163 R1 | % m. 163; MIDI bar 163
\barNumberCheck #164 R1 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 R1 | % m. 170; MIDI bar 170
\barNumberCheck #171 R1 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 R1 | % m. 174; MIDI bar 174
\barNumberCheck #175 R1 | % m. 175; MIDI bar 175
\barNumberCheck #176 c4\ff c4 r4 g,4 | % m. 176; MIDI bar 176
\barNumberCheck #177 c8 c16 c16 c8 c8 g,8-> g,16 g,16 g,8-> g,8 | % m. 177; MIDI bar 177
\barNumberCheck #178 c8 r8 r4 r2 | % m. 178; MIDI bar 178
\barNumberCheck #179 R1 | % m. 179; MIDI bar 179
\barNumberCheck #180 g,4\p r4 g,2:32\< | % m. 180; MIDI bar 180
\barNumberCheck #181 g,1:32 | % m. 181; MIDI bar 181
\barNumberCheck #182 g,1:32\ff | % m. 182; MIDI bar 182
\barNumberCheck #183 g,4-. g,4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 R1 | % m. 184; MIDI bar 184
\barNumberCheck #185 R1 | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 R1 | % m. 188; MIDI bar 188
\barNumberCheck #189 R1 | % m. 189; MIDI bar 189
\barNumberCheck #190 R1 | % m. 190; MIDI bar 190
\barNumberCheck #191 R1 | % m. 191; MIDI bar 191
\barNumberCheck #192 R1 | % m. 192; MIDI bar 192
\barNumberCheck #193 R1 | % m. 193; MIDI bar 193
\barNumberCheck #194 R1 | % m. 194; MIDI bar 194
\barNumberCheck #195 R1 | % m. 195; MIDI bar 195
\barNumberCheck #196 c4\p-> r4 r2 | % m. 196; MIDI bar 196
\barNumberCheck #197 c4 r4 r2 | % m. 197; MIDI bar 197
\barNumberCheck #198 R1 | % m. 198; MIDI bar 198
\barNumberCheck #199 R1 | % m. 199; MIDI bar 199
\barNumberCheck #200 R1 | % m. 200; MIDI bar 200
\barNumberCheck #201 R1 | % m. 201; MIDI bar 201
\barNumberCheck #202 R1 | % m. 202; MIDI bar 202
\barNumberCheck #203 R1 | % m. 203; MIDI bar 203
\barNumberCheck #204 R1 | % m. 204; MIDI bar 204
\barNumberCheck #205 R1 | % m. 205; MIDI bar 205
\barNumberCheck #206 R1 | % m. 206; MIDI bar 206
\barNumberCheck #207 R1 | % m. 207; MIDI bar 207
\barNumberCheck #208 R1 | % m. 208; MIDI bar 208
\barNumberCheck #209 g,1:32\fp | % m. 209; MIDI bar 209
\barNumberCheck #210 g,1:32 | % m. 210; MIDI bar 210
\barNumberCheck #211 g,4\f c4 r4 g,4 | % m. 211; MIDI bar 211
\barNumberCheck #212 g,1:32\fp | % m. 212; MIDI bar 212
\barNumberCheck #213 g,1:32 | % m. 213; MIDI bar 213
\barNumberCheck #214 g,1:32 | % m. 214; MIDI bar 214
\barNumberCheck #215 g,4\f c4 r4 g,4 | % m. 215; MIDI bar 215
\barNumberCheck #216 c8 c8 r4 r2 | % m. 216; MIDI bar 216
\barNumberCheck #217 R1 | % m. 217; MIDI bar 217
\barNumberCheck #218 R1 | % m. 218; MIDI bar 218
\barNumberCheck #219 R1 | % m. 219; MIDI bar 219
\barNumberCheck #220 R1 | % m. 220; MIDI bar 220
\barNumberCheck #221 R1 | % m. 221; MIDI bar 221
\barNumberCheck #222 R1 | % m. 222; MIDI bar 222
\barNumberCheck #223 R1 | % m. 223; MIDI bar 223
\barNumberCheck #224 R1 | % m. 224; MIDI bar 224
\barNumberCheck #225 R1 | % m. 225; MIDI bar 225
\barNumberCheck #226 R1 | % m. 226; MIDI bar 226
\barNumberCheck #227 r4 g,4 c4 c4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g,4 g,4 r4 g,4 | % m. 228; MIDI bar 228
\barNumberCheck #229 r4 g,4 r4 g,4 | % m. 229; MIDI bar 229
\barNumberCheck #230 r4 g,4 g,2:32 | % m. 230; MIDI bar 230
\barNumberCheck #231 g,4 c4 c4 g,4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c1:32\ff | % m. 232; MIDI bar 232
\barNumberCheck #233 c1:32 | % m. 233; MIDI bar 233
\barNumberCheck #234 c1:32 | % m. 234; MIDI bar 234
\barNumberCheck #235 c1:32 | % m. 235; MIDI bar 235
\barNumberCheck #236 c4 r4 c4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c1:32\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
violinOneI = {
\barNumberCheck #1 \key c \major c'''4..\ff c'''16 e'''4.. e'''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f'''4-. a'''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 g''4..\ff g''16 b''4.. b''16 | % m. 5; MIDI bar 5
\barNumberCheck #6 d'''4-. f'''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r8 e'8\pp e'8 e'8 e'4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 r8 e'8 e'8 e'8 e'4 r4 | % m. 9; MIDI bar 9
\barNumberCheck #10 r4 e'4 e'4 e'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 f'8( \tuplet 3/2 { g'16 f'16 e'16 }) f'8-. g'8-. aes'4 r4 | % m. 11; MIDI bar 11
\barNumberCheck #12 r8 g'8 g'8 g'8 g'4 r4 | % m. 12; MIDI bar 12
\barNumberCheck #13 r8 g'8 g'8 g'8 g'4 r4 | % m. 13; MIDI bar 13
\barNumberCheck #14 r4 b'4(\pp b'4 d''4) | % m. 14; MIDI bar 14
\barNumberCheck #15 c''2. r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'8\ff c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c''8 c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c'16 b16 c'16 b16 c'16 e'16 g'16 e'16 d'16_\markup \italic "cresc." f'16 g'16 f'16 e'16 g'16 c''16 g'16 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'16 a'16 d''16 a'16 fis'16 a'16 d''16 a'16 g'16 b'16 d''16 b'16 g'16 cis''16 e''16 cis''16 | % m. 30; MIDI bar 30
\barNumberCheck #31 f''16( e''16 f''16 e''16 f''16 e''16 f''16 e''16) f''8:16 e''8:16 d''8:16 c''8:16 | % m. 31; MIDI bar 31
\barNumberCheck #32 b'8:16\< c''8:16 d''8:16 e''8:16 f''8:16 g''8:16 a''8:16 b''8:16 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'''8:16\ff e'''8:16 g'''8:16 e'''8:16 c'''8:16 g''8:16 e'''8:16 c'''8:16 | % m. 33; MIDI bar 33
\barNumberCheck #34 g''8:16 e''8:16 c'''8:16 g''8:16 e''8:16 c''8:16 g''8:16 e''8:16 | % m. 34; MIDI bar 34
\barNumberCheck #35 <f'' d'''>1:16 | % m. 35; MIDI bar 35
\barNumberCheck #36 <f'' d'''>1:16 | % m. 36; MIDI bar 36
\barNumberCheck #37 a''8:16 c'''8:16 e'''8:16 c'''8:16 a''8:16 e''8:16 c'''8:16 a''8:16 | % m. 37; MIDI bar 37
\barNumberCheck #38 e''8:16 c''8:16 a''8:16 e''8:16 c''8:16 a'8:16 e''8:16 c''8:16 | % m. 38; MIDI bar 38
\barNumberCheck #39 <b' g''>1:16 | % m. 39; MIDI bar 39
\barNumberCheck #40 <b' g''>1:16 | % m. 40; MIDI bar 40
\barNumberCheck #41 c''8:16 e'8:16 g'8:16 c''8:16 e''8:16 g''8:16 c'''8:16 e'''8:16 | % m. 41; MIDI bar 41
\barNumberCheck #42 d'''8:16 c'''8:16 b''8:16 a''8:16 g''8:16 fis''8:16 e''8:16 d''8:16 | % m. 42; MIDI bar 42
\barNumberCheck #43 <fis' c''>2~ <fis' c''>8 ees'8:16 d'8:16 ees'8:16 | % m. 43; MIDI bar 43
\barNumberCheck #44 d'2~ d'8 ees'8:16 d'8:16 ees'8:16 | % m. 44; MIDI bar 44
\barNumberCheck #45 d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16 | % m. 45; MIDI bar 45
\barNumberCheck #46 d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16 | % m. 46; MIDI bar 46
\barNumberCheck #47 d'8 fis'8\<( g'8 gis'8 a'8\!-.) a'8\<( bes'8 b'8 | % m. 47; MIDI bar 47
\barNumberCheck #48 c''8-.)\!_\markup \italic "cresc." fis''8:16\< g''8:16 gis''8:16 a''4:16 bes''8:16 b''8:16 | % m. 48; MIDI bar 48
\barNumberCheck #49 c'''16( b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16 c'''16 b''16) | % m. 49; MIDI bar 49
\barNumberCheck #50 c'''4\!-. <d' a' fis''>4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 g8(\pp b8 d'8 b8 g8 b8 d'8 b8) | % m. 51; MIDI bar 51
\barNumberCheck #52 g8( c'8 e'8 c'8 g8 c'8 e'8 c'8) | % m. 52; MIDI bar 52
\barNumberCheck #53 d'4 d'8. d'16 d'4 d'4 | % m. 53; MIDI bar 53
\barNumberCheck #54 d'2. r4 | % m. 54; MIDI bar 54
\barNumberCheck #55 d'1 | % m. 55; MIDI bar 55
\barNumberCheck #56 ees'1 | % m. 56; MIDI bar 56
\barNumberCheck #57 e'4 e'8. e'16 e'4 e'4 | % m. 57; MIDI bar 57
\barNumberCheck #58 <aes f'>1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 a8(\pp d'8 fis'8 d'8) a8( d'8 fis'8 d'8) | % m. 59; MIDI bar 59
\barNumberCheck #60 b8( e'8 g'8 e'8) b8( e'8 g'8 e'8) | % m. 60; MIDI bar 60
\barNumberCheck #61 g'1( | % m. 61; MIDI bar 61
\barNumberCheck #62 fis'4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 d'4\p d'8. d'16 d'4 d'4 | % m. 65; MIDI bar 65
\barNumberCheck #66 d'2. r4 | % m. 66; MIDI bar 66
\barNumberCheck #67 d'1( | % m. 67; MIDI bar 67
\barNumberCheck #68 ees'1 | % m. 68; MIDI bar 68
\barNumberCheck #69 c'1 | % m. 69; MIDI bar 69
\barNumberCheck #70 f'2 ees'2 | % m. 70; MIDI bar 70
\barNumberCheck #71 d'2 ees'2) | % m. 71; MIDI bar 71
\barNumberCheck #72 d'4 f'8. f'16 f'4 f'4 | % m. 72; MIDI bar 72
\barNumberCheck #73 aes'2( b4) r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 c'2 c'8 d'8 ees'8 f'8 | % m. 74; MIDI bar 74
\barNumberCheck #75 g'4( \grace { a'16 g'16 fis'16 } g'8. a'16) bes'2 | % m. 75; MIDI bar 75
\barNumberCheck #76 b'8-. b''8-. c'''8-. cis'''8-. d'''8-. b'8-. c''8-. cis''8-. | % m. 76; MIDI bar 76
\barNumberCheck #77 d''8-. b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d'8 r8 <e'' b''>8\f r8 <e'' c'''>8 r8 <c'' a''>8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 r2 r8 b''8-.\p c'''8-. cis'''8-. | % m. 79; MIDI bar 79
\barNumberCheck #80 d'''8-. b'8-. c''8-. cis''8-. d''8-. r8 r4 | % m. 80; MIDI bar 80
\barNumberCheck #81 r8 b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d'8 r8 <e'' b''>8\f r8 <e'' c'''>8 r8 <c'' a''>8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g''4:16\ff aes''8:16 g''8:16 a''8:16 g''8:16 bes''8:16 g''8:16 | % m. 83; MIDI bar 83
\barNumberCheck #84 b''8:16 g''8:16 c'''8:16 g''8:16 cis'''8:16 g''8:16 d'''8:16 g''8:16 | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'''8:16 c'''8:16 a''8:16 fis''8:16 c'''8:16 a''8:16 fis''8:16 ees''8:16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a''8:16 fis''8:16 ees''8:16 c''8:16 fis''8:16 ees''8:16 c''8:16 a'8:16 | % m. 86; MIDI bar 86
\barNumberCheck #87 ees''8:16 c''8:16 a'8:16 fis'8:16 ees'8:16 fis'8:16 a'8:16 c''8:16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees''8:16 c''8:16 a'8:16 c''8:16 ees''8:16 fis''8:16 a''8:16 c'''8:16 | % m. 88; MIDI bar 88
\barNumberCheck #89 ees'''4 ees'''8. ees'''16 ees'''4 ees'''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 ees'''2(-> d'''4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c'''4 c'''8. c'''16 c'''4 c'''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c'''2(-> b''8) b''16 b''16 b''8 b''8 | % m. 92; MIDI bar 92
\barNumberCheck #93 b''4. b''8 c'''4. d'''8 | % m. 93; MIDI bar 93
\barNumberCheck #94 e'''4 fis'''4 g'''4 e'''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 d'''4 d'4 r4 <d' d'' b''>4 | % m. 95; MIDI bar 95
\barNumberCheck #96 r4 <d' b' g''>4 d''16 g'16 a'16 b'16 c''16 d''16 e''16 fis''16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g''16( fis''16 e''16 d''16 cis''16 d''16 e''16 fis''16 g''16 fis''16 g''16 a''16 b''16 a''16 b''16 c'''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'''4 e'''4 d'''4 <d' a' fis''>4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g''8:16 b''8:16 d'''8:16 b''8:16 g''8:16 d''8:16 b''8:16 g''8:16 | % m. 99; MIDI bar 99
\barNumberCheck #100 d''8:16 b'8:16 g''8:16 d''8:16 b'8:16 g'8:16 d''8:16 b'8:16 | % m. 100; MIDI bar 100
\barNumberCheck #101 g'4.. g'16 b'4.. d''16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g''4 <d' b' g''>4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 r8 g'8\pp g'8 g'8 g'4 r4 | % m. 107; MIDI bar 107
\barNumberCheck #108 r8 g'8 g'8 g'8 g'4 r4 | % m. 108; MIDI bar 108
\barNumberCheck #109 r4 g'4 g'4 g'4 | % m. 109; MIDI bar 109
\barNumberCheck #110 a'4( \grace { b'16 a'16 g'16 } a'8) b'8 c''4 r4 | % m. 110; MIDI bar 110
\barNumberCheck #111 r8 b'8-. b'8-. b'8-. b'4 r4 | % m. 111; MIDI bar 111
\barNumberCheck #112 r8 a'8-. a'8-. a'8-. a'4 r4 | % m. 112; MIDI bar 112
\barNumberCheck #113 r4 a'4( a'4 a'4) | % m. 113; MIDI bar 113
\barNumberCheck #114 fis'2(-> g'8) r8 r4 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 r2 r8 b8-.\p e'8-. fis'8-. | % m. 116; MIDI bar 116
\barNumberCheck #117 g'4-.(\< g'4-. g'4-. g'4-.) | % m. 117; MIDI bar 117
\barNumberCheck #118 b'4.(\!-> a'8 g'4) r4 | % m. 118; MIDI bar 118
\barNumberCheck #119 r8 e'8 e'8 e'8 r8 e'8 e'8 e'8 | % m. 119; MIDI bar 119
\barNumberCheck #120 r8 dis'8 dis'8 dis'8 dis'2~ | % m. 120; MIDI bar 120
\barNumberCheck #121 dis'2 e'2 | % m. 121; MIDI bar 121
\barNumberCheck #122 <d'' b''>1:16\ff | % m. 122; MIDI bar 122
\barNumberCheck #123 <d'' b''>1:16 | % m. 123; MIDI bar 123
\barNumberCheck #124 <e'' cis'''>1:16 | % m. 124; MIDI bar 124
\barNumberCheck #125 <e'' cis'''>1:16 | % m. 125; MIDI bar 125
\barNumberCheck #126 <d'' b''>1:16 | % m. 126; MIDI bar 126
\barNumberCheck #127 <d'' b''>1:16 | % m. 127; MIDI bar 127
\barNumberCheck #128 <ees'' c'''>1:16 | % m. 128; MIDI bar 128
\barNumberCheck #129 <ees'' c'''>1:16 | % m. 129; MIDI bar 129
\barNumberCheck #130 <ees'' c'''>1:16 | % m. 130; MIDI bar 130
\barNumberCheck #131 <ees'' c'''>1:16 | % m. 131; MIDI bar 131
\barNumberCheck #132 <f'' des'''>1:16 | % m. 132; MIDI bar 132
\barNumberCheck #133 <f'' des'''>1:16 | % m. 133; MIDI bar 133
\barNumberCheck #134 <f'' d'''>1:16\f | % m. 134; MIDI bar 134
\barNumberCheck #135 <f'' d'''>1:16 | % m. 135; MIDI bar 135
\barNumberCheck #136 <g'' ees'''>1:16 | % m. 136; MIDI bar 136
\barNumberCheck #137 <g'' ees'''>1:16 | % m. 137; MIDI bar 137
\barNumberCheck #138 <f'' d'''>1:16 | % m. 138; MIDI bar 138
\barNumberCheck #139 <f'' d'''>1:16 | % m. 139; MIDI bar 139
\barNumberCheck #140 <g'' ees'''>1:16 | % m. 140; MIDI bar 140
\barNumberCheck #141 <g'' ees'''>1:16 | % m. 141; MIDI bar 141
\barNumberCheck #142 <d' b' g''>4 r4 r8 aes16 aes16 g16-. g16-. aes16-. aes16-. | % m. 142; MIDI bar 142
\barNumberCheck #143 g2~ g8 aes8:16 g8:16 aes8:16 | % m. 143; MIDI bar 143
\barNumberCheck #144 aes16(\ff g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16) | % m. 144; MIDI bar 144
\barNumberCheck #145 aes16( g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16) | % m. 145; MIDI bar 145
\barNumberCheck #146 aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 | % m. 146; MIDI bar 146
\barNumberCheck #147 aes''8:16 f''8:16 d''8:16 b'8:16 aes'8:16 f'8:16 d'8:16 b8:16 | % m. 147; MIDI bar 147
\barNumberCheck #148 aes1\pp~ | % m. 148; MIDI bar 148
\barNumberCheck #149 aes1~ | % m. 149; MIDI bar 149
\barNumberCheck #150 aes1~ | % m. 150; MIDI bar 150
\barNumberCheck #151 aes1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g1~ | % m. 152; MIDI bar 152
\barNumberCheck #153 g2~ g8 r8 r4^\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'''4..\ff c'''16 e'''4.. e'''16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f'''4-. a'''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 R1 | % m. 156; MIDI bar 156
\barNumberCheck #157 R1 | % m. 157; MIDI bar 157
\barNumberCheck #158 <b' g''>4..\ff <b' g''>16 b''4.. b''16 | % m. 158; MIDI bar 158
\barNumberCheck #159 d'''4-. f'''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 R1 | % m. 160; MIDI bar 160
\barNumberCheck #161 r8 e'8\pp e'8 e'8 e'4 r4 | % m. 161; MIDI bar 161
\barNumberCheck #162 r8 e'8 e'8 e'8 e'4 r4 | % m. 162; MIDI bar 162
\barNumberCheck #163 r4 e'4 e'4 e'4 | % m. 163; MIDI bar 163
\barNumberCheck #164 f'8( \tuplet 3/2 { g'16 f'16 e'16 }) f'8-. g'8-. aes'4 r4 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 r2 r8 g'8-. c''8-. d''8-. | % m. 168; MIDI bar 168
\barNumberCheck #169 e''8-. r8 e''4(\< d''4 e''4 | % m. 169; MIDI bar 169
\barNumberCheck #170 f''4) fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 c'''8 r8 a''8 r8 g''8 r8 f''8 r8 | % m. 171; MIDI bar 171
\barNumberCheck #172 f''4.(-> g''16 f''16 e''8) g'8-. c''8-. d''8-. | % m. 172; MIDI bar 172
\barNumberCheck #173 e''8-. r8 e''4(\< d''4 e''4 | % m. 173; MIDI bar 173
\barNumberCheck #174 f''4) fis''4.\!\sf g''8-.\p a''8-. b''8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c'''8 r8 a''8 r8 g''8 r8 b'8 r8 | % m. 175; MIDI bar 175
\barNumberCheck #176 <e' c''>8\ff c'''16 c'''16 c'''8 c'''8 c'''16(-> b''16 a''16 g''16) g''16(-> f''16 e''16 d''16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c''8 c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c'16 b16 c'16 b16 c'16 e'16 g'16 e'16 d'16 f'16 g'16 f'16 e'16 g'16 c''16 g'16 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'16 a'16 d''16 a'16 fis'16 a'16 d''16 a'16 g'16 b'16 d''16 b'16 g'16 cis''16 e''16 cis''16 | % m. 179; MIDI bar 179
\barNumberCheck #180 f''8 b'8\<( c''8 cis''8\! ) d''8-. d''8\<( ees''8 e''8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 f''8-.\< b''8:16 c'''8:16 cis'''8:16 d'''4:16 ees'''8:16 e'''8:16 | % m. 181; MIDI bar 181
\barNumberCheck #182 f'''16(\ff e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16 f'''16 e'''16) | % m. 182; MIDI bar 182
\barNumberCheck #183 f'''4-. f'''4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 g'1(\pp | % m. 184; MIDI bar 184
\barNumberCheck #185 a'1) | % m. 185; MIDI bar 185
\barNumberCheck #186 g'4 g'8. g'16 g'4 g'4 | % m. 186; MIDI bar 186
\barNumberCheck #187 g'2. r4 | % m. 187; MIDI bar 187
\barNumberCheck #188 g'1( | % m. 188; MIDI bar 188
\barNumberCheck #189 aes'1) | % m. 189; MIDI bar 189
\barNumberCheck #190 a'4 a'8. a'16 a'4 a'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 bes'1\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 b'2(\p g'2 | % m. 192; MIDI bar 192
\barNumberCheck #193 a'1) | % m. 193; MIDI bar 193
\barNumberCheck #194 a'1( | % m. 194; MIDI bar 194
\barNumberCheck #195 g'8) r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 g'2(-> e'4..) c''16 | % m. 196; MIDI bar 196
\barNumberCheck #197 \grace { b'16( c''16 d''16 } c''2)->( a'2) | % m. 197; MIDI bar 197
\barNumberCheck #198 a'4(-> g'8.) g'16 g'4 g'4 | % m. 198; MIDI bar 198
\barNumberCheck #199 a'4.(-> g'8 e'4) r8. g'16 | % m. 199; MIDI bar 199
\barNumberCheck #200 g'2(-> e'4..) aes'16 | % m. 200; MIDI bar 200
\barNumberCheck #201 aes'2(-> b2) | % m. 201; MIDI bar 201
\barNumberCheck #202 aes'2~ aes'8 bes'16( aes'16) g'8-. f'8-. | % m. 202; MIDI bar 202
\barNumberCheck #203 bes'2 \grace { bes'8( } aes'8)( g'8 aes'8 f'8) | % m. 203; MIDI bar 203
\barNumberCheck #204 \after 4 \turn ees'2 g'4.(-> f'8) | % m. 204; MIDI bar 204
\barNumberCheck #205 e'2~ e'8( f'8 g'8 aes'8) | % m. 205; MIDI bar 205
\barNumberCheck #206 bes'4 \grace { c''16( bes'16 a'16 } bes'8.) c''16 des''4 r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 c''4 c''8. c''16 c''4 \grace { d''16( c''16 b'16 } c''8) d''8-. | % m. 207; MIDI bar 207
\barNumberCheck #208 ees''2(-> fis'2) | % m. 208; MIDI bar 208
\barNumberCheck #209 g'8-.\sf r8 r4. e'8-.\p f'8-. fis'8-. | % m. 209; MIDI bar 209
\barNumberCheck #210 g'8 r8 r4 r2 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 e'''8\f r8 f'''8 r8 d'''8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 r2 r8 e'''8-.\p f'''8-. fis'''8-. | % m. 212; MIDI bar 212
\barNumberCheck #213 g'''8-. e''8-. f''8-. fis''8-. g''8-. e'8-. f'8-. fis'8-. | % m. 213; MIDI bar 213
\barNumberCheck #214 g'8 r8 r4 r2 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 e'''8\f r8 f'''8 r8 d'''8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'''8\ff c''8:16 des''8:16 c''8:16 d''8:16 c''8:16 ees''8:16 c''8:16 | % m. 216; MIDI bar 216
\barNumberCheck #217 e''8:16 c''8:16 f''8:16 c''8:16 fis''8:16 c''8:16 g''8:16 c''8:16 | % m. 217; MIDI bar 217
\barNumberCheck #218 aes''8:16 f''8:16 d''8:16 b'8:16 f''8:16 d''8:16 b'8:16 aes'8:16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 aes''8:16 b''8:16 d'''8:16 | % m. 219; MIDI bar 219
\barNumberCheck #220 b''8:16 aes''8:16 f''8:16 d''8:16 aes''8:16 f''8:16 d''8:16 b'8:16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes'8:16 f'8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 | % m. 221; MIDI bar 221
\barNumberCheck #222 aes''4 aes''8. aes''16 aes''4 aes''4 | % m. 222; MIDI bar 222
\barNumberCheck #223 aes''2(-> g''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 f''4 f''8. f''16 f''4 f''4 | % m. 224; MIDI bar 224
\barNumberCheck #225 f''2(-> e''8) e''16 e''16 e''8 e''8 | % m. 225; MIDI bar 225
\barNumberCheck #226 e''4. e''8 f''4. g''8 | % m. 226; MIDI bar 226
\barNumberCheck #227 a''4 <d'' b''>4-. <e'' c'''>4-. <c'' a''>4 | % m. 227; MIDI bar 227
\barNumberCheck #228 g''16 g16 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g'16 a'16 b'16 c''16 d''16 e''16 f''16 g''16 c''16 d''16 e''16 f''16 g''16 a''16 b''16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'''16 b''16 a''16 g''16 fis''16 g''16 a''16 b''16 c'''16 b''16 c'''16 d'''16 e'''16 d'''16 e'''16 f'''16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'''4 a'''4 g'''4 <d'' b''>4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'''8:16\ff e'''8:16 g'''8:16 e'''8:16 c'''8:16 g''8:16 e'''8:16 c'''8:16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g''8:16 e''8:16 c'''8:16 g''8:16 e''8:16 c''8:16 g''8:16 e''8:16 | % m. 233; MIDI bar 233
\barNumberCheck #234 c''8:16 g''8:16 e''8:16 c''8:16 g'8:16 e'8:16 c'8:16 g8:16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'4 r4 <e'' c'''>4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c'1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
violinTwoI = {
\barNumberCheck #1 \key c \major e''4..\ff e''16 <e'' c'''>4.. <e'' c'''>16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c'''4-. f'''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 <d' b'>4..\ff <d' b'>16 <b' g''>4.. <b' g''>16 | % m. 5; MIDI bar 5
\barNumberCheck #6 b''4-. d'''4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r8 g8\pp g8 g8 g4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 r8 g8 g8 g8 g4 r4 | % m. 9; MIDI bar 9
\barNumberCheck #10 r4 g4 c'4 c'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 d'2( f'4) r4 | % m. 11; MIDI bar 11
\barNumberCheck #12 r8 f'8 f'8 f'8 f'4 r4 | % m. 12; MIDI bar 12
\barNumberCheck #13 r8 f'8 f'8 f'8 f'4 r4 | % m. 13; MIDI bar 13
\barNumberCheck #14 r4 d'4( f'4 d'4) | % m. 14; MIDI bar 14
\barNumberCheck #15 e'8( \tuplet 3/2 { f'16 e'16 d'16 }) e'8-. f'8-. g'4 r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'8-.\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g'16(-> f'16 e'16 d'16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c'16 b16 c'16 b16 c'16 e'16 g'16 e'16 d'16_\markup \italic "cresc." f'16 g'16 f'16 e'16 g'16 c''16 g'16 | % m. 29; MIDI bar 29
\barNumberCheck #30 f'16 a'16 d''16 a'16 fis'16 a'16 d''16 a'16 g'16 b'16 d''16 b'16 g'16 cis''16 e''16 cis''16 | % m. 30; MIDI bar 30
\barNumberCheck #31 d''16( cis''16 d''16 cis''16 d''16 cis''16 d''16 cis''16) d''8:16 c''8:16 b'8:16 a'8:16 | % m. 31; MIDI bar 31
\barNumberCheck #32 g'8:16\< a'8:16 b'8:16 c''8:16 d''8:16 e''8:16 f''8:16 d''8:16 | % m. 32; MIDI bar 32
\barNumberCheck #33 e''4:16\ff g''8:16 e''8:16 c''8:16 g'8:16 e''8:16 c''8:16 | % m. 33; MIDI bar 33
\barNumberCheck #34 g'8:16 e'8:16 c''8:16 g'8:16 e'8:16 c'8:16 g'8:16 e'8:16 | % m. 34; MIDI bar 34
\barNumberCheck #35 b'8:16 d''8:16 f''8:16 d''8:16 b'8:16 g'8:16 d''8:16 b'8:16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g'8:16 d'8:16 b'8:16 g'8:16 d'8:16 b8:16 d'8:16 g8:16 | % m. 36; MIDI bar 36
\barNumberCheck #37 a'8:16 c''8:16 e''8:16 c''8:16 a'8:16 e'8:16 c''8:16 a'8:16 | % m. 37; MIDI bar 37
\barNumberCheck #38 e'8:16 c'8:16 a'8:16 e'8:16 c'8:16 a8:16 e'8:16 a8:16 | % m. 38; MIDI bar 38
\barNumberCheck #39 e'8:16 g'8:16 b'8:16 g'8:16 e'8:16 b8:16 g'8:16 e'8:16 | % m. 39; MIDI bar 39
\barNumberCheck #40 b8:16 g8:16 b8:16 e'8:16 g'8:16 b'8:16 g'8:16 e'8:16 | % m. 40; MIDI bar 40
\barNumberCheck #41 c'8:16 e'8:16 g'8:16 c''8:16 e''8:16 g'8:16 c''8:16 e''8:16 | % m. 41; MIDI bar 41
\barNumberCheck #42 d''8:16 c''8:16 b'8:16 a'8:16 g'8:16 fis'8:16 e'8:16 d'8:16 | % m. 42; MIDI bar 42
\barNumberCheck #43 d'2~ d'8 ees'8:16 d'8:16 ees'8:16 | % m. 43; MIDI bar 43
\barNumberCheck #44 d'2~ d'8 ees'8:16 d'8:16 ees'8:16 | % m. 44; MIDI bar 44
\barNumberCheck #45 d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16 | % m. 45; MIDI bar 45
\barNumberCheck #46 d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16 | % m. 46; MIDI bar 46
\barNumberCheck #47 d'8-. d'8\<( e'8 f'8 fis'8\!-.) fis'8\<( g'8 gis'8 | % m. 47; MIDI bar 47
\barNumberCheck #48 a'8-.)\!_\markup \italic "cresc." d''8:16\< e''8:16 f''8:16 fis''4:16 g''8:16 gis''8:16 | % m. 48; MIDI bar 48
\barNumberCheck #49 a''16( gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16 a''16 gis''16) | % m. 49; MIDI bar 49
\barNumberCheck #50 a''4\!-. <d' a' fis''>4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 a4\pp a8. a16 a4 a4 | % m. 53; MIDI bar 53
\barNumberCheck #54 b2. r4 | % m. 54; MIDI bar 54
\barNumberCheck #55 g8( b8 d'8 b8) g8( b8 d'8 b8) | % m. 55; MIDI bar 55
\barNumberCheck #56 a8( c'8 ees'8 c'8) a8( c'8 ees'8 c'8) | % m. 56; MIDI bar 56
\barNumberCheck #57 cis'4 cis'8. cis'16 cis'4 cis'4 | % m. 57; MIDI bar 57
\barNumberCheck #58 d'1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 d'1(\pp | % m. 59; MIDI bar 59
\barNumberCheck #60 e'2 g'2) | % m. 60; MIDI bar 60
\barNumberCheck #61 g8( cis'8 e'8 cis'8 g8 cis'8 e'8 cis'8) | % m. 61; MIDI bar 61
\barNumberCheck #62 a4 r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 a4\p a8. a16 a4 a4 | % m. 65; MIDI bar 65
\barNumberCheck #66 b2. r4 | % m. 66; MIDI bar 66
\barNumberCheck #67 b1( | % m. 67; MIDI bar 67
\barNumberCheck #68 a1 | % m. 68; MIDI bar 68
\barNumberCheck #69 a1 | % m. 69; MIDI bar 69
\barNumberCheck #70 bes2 c'2 | % m. 70; MIDI bar 70
\barNumberCheck #71 bes2 a2) | % m. 71; MIDI bar 71
\barNumberCheck #72 aes4 aes8. aes16 aes4 aes4 | % m. 72; MIDI bar 72
\barNumberCheck #73 b2. r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 c'4-. c'8. c'16 c'4 c'4 | % m. 74; MIDI bar 74
\barNumberCheck #75 cis'1(-> | % m. 75; MIDI bar 75
\barNumberCheck #76 b8-.) g''8-. a''8-. ais''8-. b''8-. g'8-. a'8-. ais'8-. | % m. 76; MIDI bar 76
\barNumberCheck #77 b'8-. b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d'8 r8 <b' g''>8\f r8 <c'' a''>8 r8 <d' a' fis''>8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 r2 r8 g''8-.\p a''8-. ais''8-. | % m. 79; MIDI bar 79
\barNumberCheck #80 b''8-. g'8-. a'8-. ais'8-. b'8-. r8 r4 | % m. 80; MIDI bar 80
\barNumberCheck #81 r8 b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d'8 r8 <b' g''>8\f r8 <c'' a''>8 r8 <d' a' fis''>8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g'4:16\ff aes'8:16 g'8:16 a'8:16 g'8:16 bes'8:16 g'8:16 | % m. 83; MIDI bar 83
\barNumberCheck #84 b'8:16 g'8:16 c''8:16 g'8:16 cis''8:16 g'8:16 d''8:16 g'8:16 | % m. 84; MIDI bar 84
\barNumberCheck #85 ees''8:16 c''8:16 a'8:16 fis'8:16 c''8:16 a'8:16 fis'8:16 ees'8:16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a'8:16 fis'8:16 ees'8:16 c'8:16 fis'8:16 ees'8:16 c'8:16 a8:16 | % m. 86; MIDI bar 86
\barNumberCheck #87 ees'8:16 c'8:16 a8:16 fis'8:16 ees'8:16 fis'8:16 a'8:16 c''8:16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees''8:16 c''8:16 a'8:16 c''8:16 ees''8:16 fis'8:16 a'8:16 c''8:16 | % m. 88; MIDI bar 88
\barNumberCheck #89 <a' fis''>4 <a' fis''>8. <a' fis''>16 <a' fis''>4 <a' fis''>4 | % m. 89; MIDI bar 89
\barNumberCheck #90 <a' fis''>2(-> <b' g''>4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 c''4 c''8. c''16 c''4 c''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 c''2(-> b'8) fis''16 fis''16 fis''8 fis''8 | % m. 92; MIDI bar 92
\barNumberCheck #93 g''8:16 fis''8:16 g''8:16 f''8:16 e''8:16 f''8:16 e''8:16 d''8:16 | % m. 93; MIDI bar 93
\barNumberCheck #94 e''4:16 a''4:16 g''2:16 | % m. 94; MIDI bar 94
\barNumberCheck #95 <d'' b''>4 d'4 d'16 g16 a16 b16 c'16 d'16 e'16 fis'16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g'16 d'16 e'16 fis'16 g'16 a'16 b'16 c''16 d''16 g'16 a'16 b'16 c''16 d''16 e''16 fis''16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g''16( fis''16 e''16 d''16 cis''16 d''16 e''16 fis''16 g''16 fis''16 g''16 a''16 b''16 a''16 b''16 c'''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'''4 <e' c'' g''>4 <d' b' g''>4 <d' c''>4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g'8:16 b'8:16 d''8:16 b'8:16 g'8:16 d'8:16 b'8:16 g'8:16 | % m. 99; MIDI bar 99
\barNumberCheck #100 d'8:16 b8:16 g'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16 | % m. 100; MIDI bar 100
\barNumberCheck #101 g4.. <g g'>16 <d' b'>4.. <d' b'>16 | % m. 101; MIDI bar 101
\barNumberCheck #102 <d' b'>4 <g d' b'>4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 r8 b8\pp b8 b8 b4 r4 | % m. 107; MIDI bar 107
\barNumberCheck #108 r8 b8 b8 b8 b4 r4 | % m. 108; MIDI bar 108
\barNumberCheck #109 r4 b4 b4 e'4 | % m. 109; MIDI bar 109
\barNumberCheck #110 fis'4( \grace { g'16 fis'16 e'16 } fis'8) g'8 a'4 r4 | % m. 110; MIDI bar 110
\barNumberCheck #111 r8 fis'8-. fis'8-. fis'8-. fis'4 r4 | % m. 111; MIDI bar 111
\barNumberCheck #112 r8 fis'8-. fis'8-. fis'8-. fis'4 r4 | % m. 112; MIDI bar 112
\barNumberCheck #113 r4 dis'4( dis'4 dis'4) | % m. 113; MIDI bar 113
\barNumberCheck #114 dis'2(-> e'8) r8 r4 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 b4-.(\p\< b4-. b4-. b4-.) | % m. 117; MIDI bar 117
\barNumberCheck #118 b2.\!-> r4 | % m. 118; MIDI bar 118
\barNumberCheck #119 r8 b8 b8 b8 r8 b8 b8 b8 | % m. 119; MIDI bar 119
\barNumberCheck #120 r8 b8 b8 b8 b2~ | % m. 120; MIDI bar 120
\barNumberCheck #121 b2 cis'2 | % m. 121; MIDI bar 121
\barNumberCheck #122 <b' fis''>1:16\ff | % m. 122; MIDI bar 122
\barNumberCheck #123 <b' fis''>1:16 | % m. 123; MIDI bar 123
\barNumberCheck #124 <ais' fis''>1:16 | % m. 124; MIDI bar 124
\barNumberCheck #125 <ais' fis''>1:16 | % m. 125; MIDI bar 125
\barNumberCheck #126 <b' fis''>1:16 | % m. 126; MIDI bar 126
\barNumberCheck #127 <b' fis''>1:16 | % m. 127; MIDI bar 127
\barNumberCheck #128 <a' fis''>1:16 | % m. 128; MIDI bar 128
\barNumberCheck #129 <a' fis''>1:16 | % m. 129; MIDI bar 129
\barNumberCheck #130 <a' f''>1:16 | % m. 130; MIDI bar 130
\barNumberCheck #131 <a' f''>1:16 | % m. 131; MIDI bar 131
\barNumberCheck #132 <bes' f''>1:16 | % m. 132; MIDI bar 132
\barNumberCheck #133 <bes' f''>1:16 | % m. 133; MIDI bar 133
\barNumberCheck #134 <bes' aes''>1:16\f | % m. 134; MIDI bar 134
\barNumberCheck #135 <bes' aes''>1:16 | % m. 135; MIDI bar 135
\barNumberCheck #136 <bes' g''>1:16 | % m. 136; MIDI bar 136
\barNumberCheck #137 <bes' g''>1:16 | % m. 137; MIDI bar 137
\barNumberCheck #138 <d'' b''>1:16 | % m. 138; MIDI bar 138
\barNumberCheck #139 <d'' b''>1:16 | % m. 139; MIDI bar 139
\barNumberCheck #140 <ees'' c'''>1:16 | % m. 140; MIDI bar 140
\barNumberCheck #141 <ees'' c'''>1:16 | % m. 141; MIDI bar 141
\barNumberCheck #142 <d' b' g''>4 r4 r8 aes16 aes16 g16-. g16-. aes16-. aes16-. | % m. 142; MIDI bar 142
\barNumberCheck #143 g2~ g8 aes8:16 g8:16 aes8:16 | % m. 143; MIDI bar 143
\barNumberCheck #144 aes16(\ff g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16) | % m. 144; MIDI bar 144
\barNumberCheck #145 aes16( g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16 aes16 g16) | % m. 145; MIDI bar 145
\barNumberCheck #146 aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 | % m. 146; MIDI bar 146
\barNumberCheck #147 aes''8:16 f''8:16 d''8:16 b'8:16 aes'8:16 f'8:16 d'8:16 b8:16 | % m. 147; MIDI bar 147
\barNumberCheck #148 aes1\pp~ | % m. 148; MIDI bar 148
\barNumberCheck #149 aes1~ | % m. 149; MIDI bar 149
\barNumberCheck #150 aes1~ | % m. 150; MIDI bar 150
\barNumberCheck #151 aes1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g1~ | % m. 152; MIDI bar 152
\barNumberCheck #153 g2~ g8 r8 r4^\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 e''4..\ff e''16 <e'' c'''>4.. <e'' c'''>16 | % m. 154; MIDI bar 154
\barNumberCheck #155 c'''4-. f'''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 R1 | % m. 156; MIDI bar 156
\barNumberCheck #157 R1 | % m. 157; MIDI bar 157
\barNumberCheck #158 <d' b'>4..\ff <d' b'>16 <b' g''>4.. <b' g''>16 | % m. 158; MIDI bar 158
\barNumberCheck #159 b''4-. d'''4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 R1 | % m. 160; MIDI bar 160
\barNumberCheck #161 r8 g8\pp g8 g8 g4 r4 | % m. 161; MIDI bar 161
\barNumberCheck #162 r8 g8 g8 g8 g4 r4 | % m. 162; MIDI bar 162
\barNumberCheck #163 r4 g4 c'4 c'4 | % m. 163; MIDI bar 163
\barNumberCheck #164 d'2( f'4) r4 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 e'8( \tuplet 3/2 { f'16 e'16 d'16 }) e'8-. f'8-. g'4 r4 | % m. 168; MIDI bar 168
\barNumberCheck #169 \after 4*480/480 \< r2 r4 cis''4( | % m. 169; MIDI bar 169
\barNumberCheck #170 d''4) ees''4.\!\sf-> e''8-.\p ees''8-. d''8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 c''8 r8 f''8 r8 e''8 r8 d''8 r8 | % m. 171; MIDI bar 171
\barNumberCheck #172 b'2(-> c''8-.) r8 r4 | % m. 172; MIDI bar 172
\barNumberCheck #173 r4 g'4(\< aes'4 g'4 | % m. 173; MIDI bar 173
\barNumberCheck #174 a'4) ees''4.\!\sf-> e''8-.\p ees''8-. d''8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c''8 r8 f''8 r8 e''8 r8 f'8 r8 | % m. 175; MIDI bar 175
\barNumberCheck #176 <g e'>8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g'16(-> f'16 e'16 d'16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c'16 b16 c'16 b16 c'16 e'16 g'16 e'16 d'16 f'16 g'16 f'16 e'16 g'16 c''16 g'16 | % m. 178; MIDI bar 178
\barNumberCheck #179 f'16 a'16 d''16 a'16 fis'16 a'16 d''16 a'16 g'16 b'16 d''16 b'16 g'16 cis''16 e''16 cis''16 | % m. 179; MIDI bar 179
\barNumberCheck #180 d''8 g'8\<( a'8 ais'8\! ) b'8-. b'8\<( c''8 cis''8\!) | % m. 180; MIDI bar 180
\barNumberCheck #181 d''8-.\< g''8:16 a''8:16 ais''8:16 b''4:16 c'''8:16 cis'''8:16 | % m. 181; MIDI bar 181
\barNumberCheck #182 d'''16(\ff cis'''16 d'''16 cis'''16 d'''16 cis'''16 d'''16 cis'''16 d'''16 cis'''16 d'''16 cis'''16 d'''16 cis'''16 d'''16 cis'''16) | % m. 182; MIDI bar 182
\barNumberCheck #183 d'''4-. d'''4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 c'1\pp~ | % m. 184; MIDI bar 184
\barNumberCheck #185 c'1 | % m. 185; MIDI bar 185
\barNumberCheck #186 d'4 d'8. d'16 d'4 d'4 | % m. 186; MIDI bar 186
\barNumberCheck #187 e'2. r4 | % m. 187; MIDI bar 187
\barNumberCheck #188 c'1( | % m. 188; MIDI bar 188
\barNumberCheck #189 b1) | % m. 189; MIDI bar 189
\barNumberCheck #190 c'4 c'8. c'16 c'4 c'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 des'1\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 d'8(\p g'8 b'8 g'8) d'8( g'8 b'8 g'8) | % m. 192; MIDI bar 192
\barNumberCheck #193 c'8( e'8 a'8 e'8) c'8( e'8 a'8 e'8) | % m. 193; MIDI bar 193
\barNumberCheck #194 c'8( d'8 a'8 d'8) c'8( d'8 a'8 d'8)~ | % m. 194; MIDI bar 194
\barNumberCheck #195 d'8 r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 c'8( e'8 g'8 e'8) c'8( e'8 g'8 e'8) | % m. 196; MIDI bar 196
\barNumberCheck #197 c'8( f'8 a'8 f'8 c'8 f'8 a'8 f'8) | % m. 197; MIDI bar 197
\barNumberCheck #198 d'4 d'8. d'16 d'4 d'4 | % m. 198; MIDI bar 198
\barNumberCheck #199 e'2. r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 g8( c'8 e'8 c'8) g8( c'8 e'8 c'8) | % m. 200; MIDI bar 200
\barNumberCheck #201 b8( d'8 f'8 d'8) b8( d'8 f'8 d'8) | % m. 201; MIDI bar 201
\barNumberCheck #202 bes8( d'8 f'8 d'8) bes8( d'8 f'8 d'8) | % m. 202; MIDI bar 202
\barNumberCheck #203 bes8( ees'8 bes'8 ees'8 c'8 f'8 c'8 aes8) | % m. 203; MIDI bar 203
\barNumberCheck #204 g8( bes8 ees'8 bes8 aes8 bes8 d'8 bes8) | % m. 204; MIDI bar 204
\barNumberCheck #205 des'4 des'8. des'16 des'4 des'4 | % m. 205; MIDI bar 205
\barNumberCheck #206 des'2. r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 f'4 f'8. f'16 f'4 f'4 | % m. 207; MIDI bar 207
\barNumberCheck #208 fis'2(-> c'2) | % m. 208; MIDI bar 208
\barNumberCheck #209 <g e'>8\sf r8 r4. c'8-.\p d'8-. dis'8-. | % m. 209; MIDI bar 209
\barNumberCheck #210 e'8 r8 r4 r2 | % m. 210; MIDI bar 210
\barNumberCheck #211 r4 <e'' c'''>8\f r8 <f'' d'''>8 r8 <f' d'' b''>8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 r2 r8 c'''8-.\p d'''8-. dis'''8-. | % m. 212; MIDI bar 212
\barNumberCheck #213 e'''8-. c''8-. d''8-. dis''8-. e''8-. c'8-. d'8-. dis'8-. | % m. 213; MIDI bar 213
\barNumberCheck #214 e'8 r8 r4 r2 | % m. 214; MIDI bar 214
\barNumberCheck #215 r4 <e'' c'''>8\f r8 <f'' d'''>8 r8 <f' d'' b''>8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 <e' c'' e''>8\ff c'8:16 des'8:16 c'8:16 d'8:16 c'8:16 ees'8:16 c'8:16 | % m. 216; MIDI bar 216
\barNumberCheck #217 e'8:16 c'8:16 f'8:16 c'8:16 fis'8:16 c'8:16 g'8:16 c'8:16 | % m. 217; MIDI bar 217
\barNumberCheck #218 aes'8:16 f''8:16 d''8:16 b'8:16 f''8:16 d''8:16 b'8:16 aes'8:16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 aes''8:16 b''8:16 d'''8:16 | % m. 219; MIDI bar 219
\barNumberCheck #220 b''8:16 aes''8:16 f''8:16 d''8:16 aes''8:16 f''8:16 d''8:16 b'8:16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes'8:16 f'8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16 f''8:16 | % m. 221; MIDI bar 221
\barNumberCheck #222 b'4 b'8. b'16 b'4 b'4 | % m. 222; MIDI bar 222
\barNumberCheck #223 b'2(-> c''8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 b'4 b'8. b'16 b'4 b'4 | % m. 224; MIDI bar 224
\barNumberCheck #225 b'2->~ b'8 b'16 b'16 b'8 b'8 | % m. 225; MIDI bar 225
\barNumberCheck #226 c''8:16 b'8:16 c''8:16 b'8:16 a'8:16 b'8:16 a'8:16 g'8:16 | % m. 226; MIDI bar 226
\barNumberCheck #227 f'4:16 <b' g''>4:16 <c'' g''>4:16 <d' c''>4:16 | % m. 227; MIDI bar 227
\barNumberCheck #228 <e' c''>16 g16 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g'16 a'16 b'16 c''16 d''16 e''16 f''16 g''16 c''16 d''16 e''16 f''16 g''16 a''16 b''16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'''16 b''16 a''16 g''16 fis''16 g''16 a''16 b''16 c'''16 b'16 c''16 d''16 e''16 d''16 e''16 f''16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g''4 f'''4 e'''4 <b' g''>4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c''8:16\ff e''8:16 g''8:16 e''8:16 c''8:16 g'8:16 e''8:16 c''8:16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g'8:16 e'8:16 c''8:16 g'8:16 e'8:16 c'8:16 g'8:16 e'8:16 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'8:16 g'8:16 e'8:16 c'8:16 g8:16 e'8:16 c'8:16 g8:16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'4 r4 <e' c'' e''>4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c'1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
violaI = {
\barNumberCheck #1 \key c \major g'4..\ff g'16 a'4.. a'16 | % m. 1; MIDI bar 1
\barNumberCheck #2 a'4-. c''4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 d'4..\ff d'16 d'4.. d'16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g'4-. b'4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r8 c'8\pp c'8 c'8 c'4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 r8 c'8 c'8 c'8 c'4 r4 | % m. 9; MIDI bar 9
\barNumberCheck #10 r4 c'4( g4 e'4) | % m. 10; MIDI bar 10
\barNumberCheck #11 d'1~ | % m. 11; MIDI bar 11
\barNumberCheck #12 d'8 d'8 d'8 d'8 d'4 r4 | % m. 12; MIDI bar 12
\barNumberCheck #13 r8 d'8 d'8 d'8 d'4 r4 | % m. 13; MIDI bar 13
\barNumberCheck #14 r4 f'4( d'4 b4) | % m. 14; MIDI bar 14
\barNumberCheck #15 c'4.( d'8) e'4 r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c8 r8 c16 e16 g16 e16 d16_\markup \italic "cresc." f16 g16 f16 e16 g16 c'16 g16 | % m. 29; MIDI bar 29
\barNumberCheck #30 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g16 cis'16 e'16 cis'16 | % m. 30; MIDI bar 30
\barNumberCheck #31 g1:16 | % m. 31; MIDI bar 31
\barNumberCheck #32 g1:16\< | % m. 32; MIDI bar 32
\barNumberCheck #33 <g e'>1:16\ff | % m. 33; MIDI bar 33
\barNumberCheck #34 <g e'>1:16 | % m. 34; MIDI bar 34
\barNumberCheck #35 b8:16 d'8:16 f'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g8:16 d'8:16 b'8:16 g'8:16 d'8:16 b8:16 d'8:16 g8:16 | % m. 36; MIDI bar 36
\barNumberCheck #37 a'8:16 c''8:16 e''8:16 c''8:16 a'8:16 e'8:16 c''8:16 a'8:16 | % m. 37; MIDI bar 37
\barNumberCheck #38 e'8:16 c'8:16 a'8:16 e'8:16 c'8:16 a8:16 e'8:16 a8:16 | % m. 38; MIDI bar 38
\barNumberCheck #39 e'8:16 g'8:16 b'8:16 g'8:16 e'8:16 b8:16 g'8:16 e'8:16 | % m. 39; MIDI bar 39
\barNumberCheck #40 b8:16 g8:16 b8:16 e'8:16 g'8:16 b'8:16 g'8:16 e'8:16 | % m. 40; MIDI bar 40
\barNumberCheck #41 <g e'>1:16 | % m. 41; MIDI bar 41
\barNumberCheck #42 <g d'>1:16 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2~ d8 ees8:16 d8:16 ees8:16 | % m. 43; MIDI bar 43
\barNumberCheck #44 d2~ d8 ees8:16 d8:16 ees8:16 | % m. 44; MIDI bar 44
\barNumberCheck #45 d8:16 ees8:16 d8:16 cis8:16 d8:16 fis8:16 a4:16 | % m. 45; MIDI bar 45
\barNumberCheck #46 d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16 | % m. 46; MIDI bar 46
\barNumberCheck #47 d'4 d4 d4 d4 | % m. 47; MIDI bar 47
\barNumberCheck #48 d8_\markup \italic "cresc." <d' fis'>8:16\<^\markup \upright "div." <e' g'>8:16 <f' gis'>8:16 <fis' a'>4:16 <g' bes'>8:16 <gis' b'>8:16 | % m. 48; MIDI bar 48
\barNumberCheck #49 <a' c''>16( <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16) | % m. 49; MIDI bar 49
\barNumberCheck #50 <a' c''>4\!-. d4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 c'4\pp^\markup \upright "unis." c'8. c'16 c'4 c'4 | % m. 53; MIDI bar 53
\barNumberCheck #54 b2. r4 | % m. 54; MIDI bar 54
\barNumberCheck #55 g1 | % m. 55; MIDI bar 55
\barNumberCheck #56 fis1 | % m. 56; MIDI bar 56
\barNumberCheck #57 g4 g8. g16 g4 g4 | % m. 57; MIDI bar 57
\barNumberCheck #58 aes1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 a1(\pp | % m. 59; MIDI bar 59
\barNumberCheck #60 b1) | % m. 60; MIDI bar 60
\barNumberCheck #61 cis'1( | % m. 61; MIDI bar 61
\barNumberCheck #62 d'4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 g8(\pp b8 d'8 b8 g8 b8 d'8 b8) | % m. 63; MIDI bar 63
\barNumberCheck #64 g8( c'8 e'8 c'8 g8 c'8 e'8 c'8) | % m. 64; MIDI bar 64
\barNumberCheck #65 c'4\p c'8. c'16 c'4 c'4 | % m. 65; MIDI bar 65
\barNumberCheck #66 b2. r4 | % m. 66; MIDI bar 66
\barNumberCheck #67 g8( b8 d'8 b8 g8 b8 d'8 b8) | % m. 67; MIDI bar 67
\barNumberCheck #68 fis8( a8 c'8 a8 fis8 a8 c'8 a8) | % m. 68; MIDI bar 68
\barNumberCheck #69 a8( c'8 ees'8 c'8) f8( a8 c'8 a8 | % m. 69; MIDI bar 69
\barNumberCheck #70 f8 bes8 f'8 bes8 g8 c'8 ees'8 c'8 | % m. 70; MIDI bar 70
\barNumberCheck #71 f8 bes8 d'8 bes8 f8 a8 c'8 a8) | % m. 71; MIDI bar 71
\barNumberCheck #72 b4 <b d'>8. <b d'>16 <b d'>4 <b d'>4 | % m. 72; MIDI bar 72
\barNumberCheck #73 <b d'>2.-> r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 g4 g8. g16 g4 g4 | % m. 74; MIDI bar 74
\barNumberCheck #75 g1~ | % m. 75; MIDI bar 75
\barNumberCheck #76 g8-. r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 r8 b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d'8 r8 e'8\f r8 c'8 r8 d'8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 r2 r8 b8-.\p c'8-. cis'8-. | % m. 80; MIDI bar 80
\barNumberCheck #81 d'8-. r8 r8 cis8-. d8-. cis8-. d8-. cis8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d8 r8 e'8\f r8 c'8 r8 <g d'>8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g4:16\ff aes8:16 g8:16 a8:16 g8:16 bes8:16 g8:16 | % m. 83; MIDI bar 83
\barNumberCheck #84 b8:16 g8:16 c'8:16 g8:16 cis'8:16 g8:16 d'8:16 g8:16 | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'8:16 c'8:16 a8:16 fis8:16 c''8:16 a'8:16 fis'8:16 ees'8:16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a'8:16 fis'8:16 ees'8:16 c'8:16 fis'8:16 ees'8:16 c'8:16 a8:16 | % m. 86; MIDI bar 86
\barNumberCheck #87 ees'8:16 c'8:16 a8:16 fis8:16 ees8:16 fis8:16 a8:16 c'8:16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees'8:16 c'8:16 a8:16 c'8:16 ees'8:16 fis'8:16 a'8:16 c''8:16 | % m. 88; MIDI bar 88
\barNumberCheck #89 ees''4 a'8. a'16 a'4 a'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 a'2(-> b'4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 fis'4 fis'8. fis'16 fis'4 fis'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 fis'2->~ fis'8 dis'16 dis'16 dis'8 dis'8 | % m. 92; MIDI bar 92
\barNumberCheck #93 e'8:16 dis'8:16 e'8:16 d'8:16 c'8:16 d'8:16 c'8:16 b8:16 | % m. 93; MIDI bar 93
\barNumberCheck #94 c'4:16 d''2:16 a'4:16 | % m. 94; MIDI bar 94
\barNumberCheck #95 g'16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g16 a16 b16 c'16 d'16 e'16 fis'16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g'16 d'16 e'16 fis'16 g'16 a'16 b'16 c''16 d''16 g16 a16 b16 c'16 d'16 e'16 fis'16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g'16( fis'16 e'16 d'16 cis'16 d'16 e'16 fis'16 g'16 fis'16 g'16 a'16 b'16 a'16 b'16 c''16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d''4 <g e' c''>4 <g d' b'>4 <d' a'>4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g'8:16 b'8:16 d''8:16 b'8:16 g'8:16 d'8:16 b'8:16 g'8:16 | % m. 99; MIDI bar 99
\barNumberCheck #100 d'8:16 b8:16 g'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16 | % m. 100; MIDI bar 100
\barNumberCheck #101 <g d'>4.. <g d'>16 <g d'>4.. <g d'>16 | % m. 101; MIDI bar 101
\barNumberCheck #102 <g d'>4 <g d'>4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 r8 e'8\pp e'8 e'8 e'4 r4 | % m. 107; MIDI bar 107
\barNumberCheck #108 r8 e'8 e'8 e'8 e'4 r4 | % m. 108; MIDI bar 108
\barNumberCheck #109 r4 e'4 b4 b4 | % m. 109; MIDI bar 109
\barNumberCheck #110 e2~ e8 e8 e8 e8 | % m. 110; MIDI bar 110
\barNumberCheck #111 dis8 r8 r4 r2 | % m. 111; MIDI bar 111
\barNumberCheck #112 r8 dis'8-. dis'8-. dis'8-. dis'4 r4 | % m. 112; MIDI bar 112
\barNumberCheck #113 r4 fis'4( fis'4 fis'4) | % m. 113; MIDI bar 113
\barNumberCheck #114 a'2(-> g'8) r8 r4 | % m. 114; MIDI bar 114
\barNumberCheck #115 b4-.(\pp\< b4-. b4-. b4-.) | % m. 115; MIDI bar 115
\barNumberCheck #116 b2->\!\>~ b8\! r8 r4 | % m. 116; MIDI bar 116
\barNumberCheck #117 e'4-.(\< e'4-. e'4-. e'4-.) | % m. 117; MIDI bar 117
\barNumberCheck #118 fis'2(\!-> e'4) r4 | % m. 118; MIDI bar 118
\barNumberCheck #119 r8 g8 g8 g8 r8 g8 g8 g8 | % m. 119; MIDI bar 119
\barNumberCheck #120 r8 fis8 fis8 fis8 fis2~ | % m. 120; MIDI bar 120
\barNumberCheck #121 fis2 ais4( fis4) | % m. 121; MIDI bar 121
\barNumberCheck #122 b1:16\ff | % m. 122; MIDI bar 122
\barNumberCheck #123 b1:16 | % m. 123; MIDI bar 123
\barNumberCheck #124 fis1:16 | % m. 124; MIDI bar 124
\barNumberCheck #125 fis1:16 | % m. 125; MIDI bar 125
\barNumberCheck #126 b1:16 | % m. 126; MIDI bar 126
\barNumberCheck #127 b1:16 | % m. 127; MIDI bar 127
\barNumberCheck #128 a1:16 | % m. 128; MIDI bar 128
\barNumberCheck #129 a1:16 | % m. 129; MIDI bar 129
\barNumberCheck #130 f1:16 | % m. 130; MIDI bar 130
\barNumberCheck #131 f8 c'8( bes8 a8 g8 f8 e8 f8) | % m. 131; MIDI bar 131
\barNumberCheck #132 f1:16 | % m. 132; MIDI bar 132
\barNumberCheck #133 f1:16 | % m. 133; MIDI bar 133
\barNumberCheck #134 bes1:16\f | % m. 134; MIDI bar 134
\barNumberCheck #135 bes1:16 | % m. 135; MIDI bar 135
\barNumberCheck #136 <ees bes>1:16 | % m. 136; MIDI bar 136
\barNumberCheck #137 <ees bes>1:16 | % m. 137; MIDI bar 137
\barNumberCheck #138 <g g'>1:16 | % m. 138; MIDI bar 138
\barNumberCheck #139 <g d'>1:16 | % m. 139; MIDI bar 139
\barNumberCheck #140 <g ees'>1:16 | % m. 140; MIDI bar 140
\barNumberCheck #141 <g ees'>1:16 | % m. 141; MIDI bar 141
\barNumberCheck #142 <g d'>4 r4 r8 aes16 aes16 g16-. g16-. aes16-. aes16-. | % m. 142; MIDI bar 142
\barNumberCheck #143 g2~ g8 aes8:16 g8:16 aes8:16 | % m. 143; MIDI bar 143
\barNumberCheck #144 aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) | % m. 144; MIDI bar 144
\barNumberCheck #145 aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) | % m. 145; MIDI bar 145
\barNumberCheck #146 aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b8:16 d'8:16 f'8:16 | % m. 146; MIDI bar 146
\barNumberCheck #147 aes'8:16 f'8:16 d'8:16 b8:16 aes8:16 f8:16 d8:16 b8:16 | % m. 147; MIDI bar 147
\barNumberCheck #148 aes1\pp~ | % m. 148; MIDI bar 148
\barNumberCheck #149 aes1~ | % m. 149; MIDI bar 149
\barNumberCheck #150 aes1~ | % m. 150; MIDI bar 150
\barNumberCheck #151 aes1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g1~ | % m. 152; MIDI bar 152
\barNumberCheck #153 g2~ g8 r8 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 g'4..\ff g'16 a'4.. a'16 | % m. 154; MIDI bar 154
\barNumberCheck #155 a'4-. c''4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 R1 | % m. 156; MIDI bar 156
\barNumberCheck #157 R1 | % m. 157; MIDI bar 157
\barNumberCheck #158 <g d'>4..\ff <g d'>16 <g d'>4.. <g d'>16 | % m. 158; MIDI bar 158
\barNumberCheck #159 <g g'>4-. b'4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 R1 | % m. 160; MIDI bar 160
\barNumberCheck #161 r8 c'8\pp c'8 c'8 c'4 r4 | % m. 161; MIDI bar 161
\barNumberCheck #162 r8 c'8 c'8 c'8 c'4 r4 | % m. 162; MIDI bar 162
\barNumberCheck #163 r4 c'4( g4 e'4) | % m. 163; MIDI bar 163
\barNumberCheck #164 d'1 | % m. 164; MIDI bar 164
\barNumberCheck #165 R1 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 c'8 \once \override TupletBracket.direction = #DOWN \tuplet 3/2 { d'16( c'16 b16) } c'8-. d'8-. e'4 r4 | % m. 168; MIDI bar 168
\barNumberCheck #169 r4 g'4(\< aes'4 g'4 | % m. 169; MIDI bar 169
\barNumberCheck #170 a'!4) c''4.\!\sf-> c''8-.\p c''8-. g'8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 g'8 r8 c'8 r8 c'8 r8 b8 r8 | % m. 171; MIDI bar 171
\barNumberCheck #172 d'2(-> g8-.) r8 r4 | % m. 172; MIDI bar 172
\barNumberCheck #173 \after 4*480/480 \< r2 r4 cis''4( | % m. 173; MIDI bar 173
\barNumberCheck #174 d''4) c''4.\!\sf-> c''8-.\p c''8-. g'8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 g'8 r8 c'8 r8 c'8 r8 d'8 r8 | % m. 175; MIDI bar 175
\barNumberCheck #176 <c g>8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c8 r8 c16 e16 g16 e16 d16 f16 g16 f16 e16 g16 c'16 g16 | % m. 178; MIDI bar 178
\barNumberCheck #179 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g16 cis'16 e'16 cis'16 | % m. 179; MIDI bar 179
\barNumberCheck #180 g2:8 g2:8 | % m. 180; MIDI bar 180
\barNumberCheck #181 r8\<^\markup \upright "div." <g b>8:16 <a c'>8:16 <ais cis'>8:16 <b d'>4:16 <c' ees'>8:16 <cis' e'>8:16 | % m. 181; MIDI bar 181
\barNumberCheck #182 <d' f'>16(\ff <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16) | % m. 182; MIDI bar 182
\barNumberCheck #183 <d' f'>4-. <d' b'>4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 e8^\markup \upright "unis."(\pp g8 c'8 e'8 g'8 e'8 c'8 g8) | % m. 184; MIDI bar 184
\barNumberCheck #185 f8( a8 d'8 f'8 a'8 f'8 d'8 a8) | % m. 185; MIDI bar 185
\barNumberCheck #186 f4 f'8. f'16 f'4 f'4 | % m. 186; MIDI bar 186
\barNumberCheck #187 e'2. r4 | % m. 187; MIDI bar 187
\barNumberCheck #188 e8( g8 c'8 e'8 g'8 e'8 c'8 g8) | % m. 188; MIDI bar 188
\barNumberCheck #189 b8( d'8 f'8 g'8 aes'8 f'8 d'8 f'8) | % m. 189; MIDI bar 189
\barNumberCheck #190 ges'4 ges'8. ges'16 ges'4 ges'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g'1\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 g'1(\p | % m. 192; MIDI bar 192
\barNumberCheck #193 e'2 c'2) | % m. 193; MIDI bar 193
\barNumberCheck #194 c'1( | % m. 194; MIDI bar 194
\barNumberCheck #195 b8) r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 e2( g2 | % m. 196; MIDI bar 196
\barNumberCheck #197 a2 c'2) | % m. 197; MIDI bar 197
\barNumberCheck #198 b4 f'8. f'16 f'4 f'4 | % m. 198; MIDI bar 198
\barNumberCheck #199 e'2. r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 e2( g2 | % m. 200; MIDI bar 200
\barNumberCheck #201 f2 aes2) | % m. 201; MIDI bar 201
\barNumberCheck #202 d'1 | % m. 202; MIDI bar 202
\barNumberCheck #203 ees'2( c'2 | % m. 203; MIDI bar 203
\barNumberCheck #204 bes2 d'2) | % m. 204; MIDI bar 204
\barNumberCheck #205 bes4 bes8. bes16 bes4 bes4 | % m. 205; MIDI bar 205
\barNumberCheck #206 e'2. r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 f2~ f8 g8( aes8 bes8 | % m. 207; MIDI bar 207
\barNumberCheck #208 c'4) \grace { d'16( c'16 b16 } c'8.) d'16 ees'2 | % m. 208; MIDI bar 208
\barNumberCheck #209 e'8\sf r8 r4 r2 | % m. 209; MIDI bar 209
\barNumberCheck #210 r8 e8-.\p f8-. fis8-. g8-. fis8-. g8-. fis8-. | % m. 210; MIDI bar 210
\barNumberCheck #211 g4 a'8\f r8 a'8 r8 <g g'>8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 r8 e8-.\p f8-. fis8-. g8-. fis8-. g8-. fis8-. | % m. 214; MIDI bar 214
\barNumberCheck #215 g4 a'8\f r8 a'8 r8 <g g'>8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 <c c'>8\ff^\markup \upright "div." <c c'>8:16 <des des'>8:16 <c c'>8:16 <d d'>8:16 <c c'>8:16 <ees ees'>8:16 <c c'>8:16 | % m. 216; MIDI bar 216
\barNumberCheck #217 <e e'>8:16 <c c'>8:16 <f f'>8:16 <c c'>8:16 <fis fis'>8:16 <c c'>8:16 <g g'>8:16 <c c'>8:16 | % m. 217; MIDI bar 217
\barNumberCheck #218 aes'8:16^\markup \upright "unis." f'8:16 d'8:16 b8:16 f'8:16 d'8:16 b8:16 aes8:16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f8:16 aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16 | % m. 219; MIDI bar 219
\barNumberCheck #220 b'8:16 aes'8:16 f'8:16 d'8:16 aes'8:16 f'8:16 d'8:16 b8:16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes8:16 f8:16 d8:16 f8:16 aes8:16 b8:16 d'8:16 f'8:16 | % m. 221; MIDI bar 221
\barNumberCheck #222 aes'4 d'8. d'16 d'4 d'4 | % m. 222; MIDI bar 222
\barNumberCheck #223 d'2(-> e'8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 gis4 gis8. gis16 gis4 gis4 | % m. 224; MIDI bar 224
\barNumberCheck #225 gis2->~ gis8 gis16 gis16 gis8 gis8 | % m. 225; MIDI bar 225
\barNumberCheck #226 a8:16 gis8:16 a8:16 g8:16 f8:16 g8:16 f8:16 e8:16 | % m. 226; MIDI bar 226
\barNumberCheck #227 f2:16 e4:16 fis4:16 | % m. 227; MIDI bar 227
\barNumberCheck #228 g8 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c''16 g16 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c''16 b'16 a'16 g'16 fis'16 g'16 a'16 b'16 c''16 b16 c'16 d'16 e'16 d'16 e'16 f'16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'4 c''4 c''4 <g d' b'>4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'8:16\ff e'8:16 g'8:16 e'8:16 c'8:16 g'8:16 e''8:16 c''8:16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g'8:16 e'8:16 c''8:16 g'8:16 e'8:16 c'8:16 g'8:16 e'8:16 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'8:16 g'8:16 e'8:16 c'8:16 g8:16 e'8:16 c'8:16 g8:16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 | % m. 235; MIDI bar 235
\barNumberCheck #236 c'4 r4 <c g e' c''>4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
celloI = {
\barNumberCheck #1 \key c \major c'4..\ff c'16 a4.. a16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f4-. f,4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 g4..\ff g16 g4.. g16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g4-. g4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r8 c8\pp c8 c8 c4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 r8 c8 c8 c8 c4 r4 | % m. 9; MIDI bar 9
\barNumberCheck #10 r4 c4 c'4 c'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 c'2~ c'8 r8 r4 | % m. 11; MIDI bar 11
\barNumberCheck #12 r8 b8 b8 b8 b4 r4 | % m. 12; MIDI bar 12
\barNumberCheck #13 r8 b8 b8 b8 b4 r4 | % m. 13; MIDI bar 13
\barNumberCheck #14 r4 g4 g4 g4 | % m. 14; MIDI bar 14
\barNumberCheck #15 c2. r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c,8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c8 c16 c16 c8 c8 c16(-> b,16 a,16 g,16) g,16(-> f,16 e,16 d,16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c,8 r8 c16 e16 g16 e16 d16_\markup \italic "cresc." f16 g16 f16 e16 g16 c'16 g16 | % m. 29; MIDI bar 29
\barNumberCheck #30 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g4 | % m. 30; MIDI bar 30
\barNumberCheck #31 g4 g4 g4 g4 | % m. 31; MIDI bar 31
\barNumberCheck #32 g4\< g4 g2 | % m. 32; MIDI bar 32
\barNumberCheck #33 c'1:16\ff | % m. 33; MIDI bar 33
\barNumberCheck #34 c'1:16 | % m. 34; MIDI bar 34
\barNumberCheck #35 b8:16 d'8:16 f'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16 | % m. 35; MIDI bar 35
\barNumberCheck #36 g8:16 d8:16 b8:16 g8:16 d8:16 b,8:16 d8:16 g,8:16 | % m. 36; MIDI bar 36
\barNumberCheck #37 a1:16 | % m. 37; MIDI bar 37
\barNumberCheck #38 a1:16 | % m. 38; MIDI bar 38
\barNumberCheck #39 e8:16 g8:16 b8:16 g8:16 e8:16 b,8:16 g8:16 e8:16 | % m. 39; MIDI bar 39
\barNumberCheck #40 b,8:16 g,8:16 b,8:16 e8:16 g8:16 b8:16 g8:16 e8:16 | % m. 40; MIDI bar 40
\barNumberCheck #41 c1:16 | % m. 41; MIDI bar 41
\barNumberCheck #42 b,1:16 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2~ d8 ees8:16 d8:16 ees8:16 | % m. 43; MIDI bar 43
\barNumberCheck #44 d2~ d8 ees8:16 d8:16 ees8:16 | % m. 44; MIDI bar 44
\barNumberCheck #45 d8:16 ees8:16 d8:16 cis8:16 d8:16 fis8:16 a8:16 a,8:16 | % m. 45; MIDI bar 45
\barNumberCheck #46 d8:16 ees8:16 d8:16 cis8:16 d8:16 fis8:16 a8:16 a,8:16 | % m. 46; MIDI bar 46
\barNumberCheck #47 d4 d4 d4 d4 | % m. 47; MIDI bar 47
\barNumberCheck #48 d8_\markup \italic "cresc." d8 d8 d8 d8 d8 d8 d8 | % m. 48; MIDI bar 48
\barNumberCheck #49 d'1:16 | % m. 49; MIDI bar 49
\barNumberCheck #50 d'4-. d4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 fis4\pp fis8. fis16 fis4 fis4 | % m. 53; MIDI bar 53
\barNumberCheck #54 g2. r4 | % m. 54; MIDI bar 54
\barNumberCheck #55 b1(\p | % m. 55; MIDI bar 55
\barNumberCheck #56 c'1) | % m. 56; MIDI bar 56
\barNumberCheck #57 bes4 bes,8. bes,16 bes,4 bes,4 | % m. 57; MIDI bar 57
\barNumberCheck #58 bes,1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 a,1(\pp | % m. 59; MIDI bar 59
\barNumberCheck #60 g,2. e,4) | % m. 60; MIDI bar 60
\barNumberCheck #61 a,1( | % m. 61; MIDI bar 61
\barNumberCheck #62 d4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 fis4\pp fis8. fis16 fis4 fis4 | % m. 65; MIDI bar 65
\barNumberCheck #66 g2. r4 | % m. 66; MIDI bar 66
\barNumberCheck #67 g,1( | % m. 67; MIDI bar 67
\barNumberCheck #68 c1 | % m. 68; MIDI bar 68
\barNumberCheck #69 f,2 ees,2 | % m. 69; MIDI bar 69
\barNumberCheck #70 d,2 ees,2 | % m. 70; MIDI bar 70
\barNumberCheck #71 f,1)~ | % m. 71; MIDI bar 71
\barNumberCheck #72 f,1~ | % m. 72; MIDI bar 72
\barNumberCheck #73 f,2-> f4 r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 ees4 ees8. ees16 ees4 ees4 | % m. 74; MIDI bar 74
\barNumberCheck #75 ees,1( | % m. 75; MIDI bar 75
\barNumberCheck #76 d,8-.) r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 r8 b,8-. c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 r2 r8 g8-.\p a8-. ais8-. | % m. 80; MIDI bar 80
\barNumberCheck #81 b8-. b,8-. c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g4:16\ff aes8:16 g8:16 a8:16 g8:16 bes8:16 g8:16 | % m. 83; MIDI bar 83
\barNumberCheck #84 b8:16 g8:16 c'8:16 g8:16 cis'8:16 g8:16 d'8:16 g8:16 | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'8:16 c'8:16 a8:16 fis8:16 c'8:16 a8:16 fis8:16 ees8:16 | % m. 85; MIDI bar 85
\barNumberCheck #86 a8:16 fis8:16 ees8:16 c8:16 fis8:16 ees'8:16 c'8:16 a8:16 | % m. 86; MIDI bar 86
\barNumberCheck #87 ees'8:16 c'8:16 a8:16 fis8:16 ees8:16 fis8:16 a8:16 c'8:16 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees'8:16 c'8:16 a8:16 c'8:16 ees'8:16 fis8:16 a8:16 c'8:16 | % m. 88; MIDI bar 88
\barNumberCheck #89 c'4 c'8. c'16 c'4 c'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c'2(-> b4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 dis4 dis8. dis16 dis4 dis4 | % m. 91; MIDI bar 91
\barNumberCheck #92 dis2->~ dis8 dis'16 dis'16 dis'8 dis'8 | % m. 92; MIDI bar 92
\barNumberCheck #93 e'8:16 dis'8:16 e'8:16 d'8:16 c'8:16 d'8:16 c'8:16 b8:16 | % m. 93; MIDI bar 93
\barNumberCheck #94 c'2:16 b4:16 cis'4:16 | % m. 94; MIDI bar 94
\barNumberCheck #95 d'16 d,16 e,16 fis,16 g,16 a,16 b,16 c16 d16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g16 a16 b16 c'16 d'16 e'16 fis'16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g'16( fis'16 e'16 d'16 cis'16 d'16 e'16 fis'16 g'8) r8 b16( a16 b16 c'16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'8 r8 c4 d4 d4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g8:16 b8:16 d'8:16 b8:16 g8:16 d8:16 b8:16 g8:16 | % m. 99; MIDI bar 99
\barNumberCheck #100 d8:16 b,8:16 g8:16 d8:16 b,8:16 g,8:16 d8:16 b,8:16 | % m. 100; MIDI bar 100
\barNumberCheck #101 g,4.. g16 g4.. g16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g4 g4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 r8 e'8\pp e'8 e'8 e'4 r4 | % m. 107; MIDI bar 107
\barNumberCheck #108 r8 e'8 e'8 e'8 e'4 r4 | % m. 108; MIDI bar 108
\barNumberCheck #109 r4 e'4 e'4 e'4 | % m. 109; MIDI bar 109
\barNumberCheck #110 e'2~ e'8 r8 r4 | % m. 110; MIDI bar 110
\barNumberCheck #111 r8 dis'8-. dis'8-. dis'8-. dis'4 r4 | % m. 111; MIDI bar 111
\barNumberCheck #112 r8 b8-. b8-. b8-. b4 r4 | % m. 112; MIDI bar 112
\barNumberCheck #113 r4 b4( b4 b4) | % m. 113; MIDI bar 113
\barNumberCheck #114 b2(-> e8) r8 r4 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 e4-.(\p\< e4-. e4-. e4-.) | % m. 117; MIDI bar 117
\barNumberCheck #118 dis2(\!-> e4) r4 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 b,4..\ff d16 fis4.. b16 | % m. 122; MIDI bar 122
\barNumberCheck #123 d'4-. fis'4-. r2 | % m. 123; MIDI bar 123
\barNumberCheck #124 fis,4.. ais,16 cis4.. fis16 | % m. 124; MIDI bar 124
\barNumberCheck #125 ais4-. cis'4-. r2 | % m. 125; MIDI bar 125
\barNumberCheck #126 b,4.. d16 fis4.. b16 | % m. 126; MIDI bar 126
\barNumberCheck #127 d'4-. fis'4-. r2 | % m. 127; MIDI bar 127
\barNumberCheck #128 a,4.. c16 ees4.. fis16 | % m. 128; MIDI bar 128
\barNumberCheck #129 a4-. c'4-. r2 | % m. 129; MIDI bar 129
\barNumberCheck #130 a,4.. c16 f4.. a16 | % m. 130; MIDI bar 130
\barNumberCheck #131 c'4-. ees'4-. r2 | % m. 131; MIDI bar 131
\barNumberCheck #132 f,4.. bes,16 des4.. f16 | % m. 132; MIDI bar 132
\barNumberCheck #133 bes4-. des'4-. r2 | % m. 133; MIDI bar 133
\barNumberCheck #134 bes,4.. bes,16 d4.. f16 | % m. 134; MIDI bar 134
\barNumberCheck #135 bes4-. d'4-. r2 | % m. 135; MIDI bar 135
\barNumberCheck #136 bes,4.. bes,16 ees4.. g16 | % m. 136; MIDI bar 136
\barNumberCheck #137 bes4-. ees'4-. r2 | % m. 137; MIDI bar 137
\barNumberCheck #138 b,!4.. b,16 d4.. g16 | % m. 138; MIDI bar 138
\barNumberCheck #139 b!4-. d'4-. r2 | % m. 139; MIDI bar 139
\barNumberCheck #140 g,4.. g,16 c4.. ees16 | % m. 140; MIDI bar 140
\barNumberCheck #141 g4-. c'4-. r2 | % m. 141; MIDI bar 141
\barNumberCheck #142 <g, d b>4 r4 r8 aes,16 aes,16 g,16-. g,16-. aes,16-. aes,16-. | % m. 142; MIDI bar 142
\barNumberCheck #143 g,2~ g,8 aes,8:16 g,8:16 aes,8:16 | % m. 143; MIDI bar 143
\barNumberCheck #144 aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) | % m. 144; MIDI bar 144
\barNumberCheck #145 aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) | % m. 145; MIDI bar 145
\barNumberCheck #146 aes,8:16 b,8:16 d8:16 f8:16 aes8:16 b8:16 d'8:16 f'8:16 | % m. 146; MIDI bar 146
\barNumberCheck #147 aes'8:16 f'8:16 d'8:16 b8:16 aes8:16 f8:16 d8:16 b,8:16 | % m. 147; MIDI bar 147
\barNumberCheck #148 aes,1\pp~ | % m. 148; MIDI bar 148
\barNumberCheck #149 aes,1~ | % m. 149; MIDI bar 149
\barNumberCheck #150 aes,1~ | % m. 150; MIDI bar 150
\barNumberCheck #151 aes,1 | % m. 151; MIDI bar 151
\barNumberCheck #152 g,4 r4 r2 | % m. 152; MIDI bar 152
\barNumberCheck #153 r2 r4 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'4..\ff c'16 a4.. a16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f4-. f,4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 R1 | % m. 156; MIDI bar 156
\barNumberCheck #157 R1 | % m. 157; MIDI bar 157
\barNumberCheck #158 g4..\ff g16 g4.. g16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g4-. g4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 R1 | % m. 160; MIDI bar 160
\barNumberCheck #161 r8 c8\pp c8 c8 c4 r4 | % m. 161; MIDI bar 161
\barNumberCheck #162 r8 c8 c8 c8 c4 r4 | % m. 162; MIDI bar 162
\barNumberCheck #163 r4 c4 c'4 c'4 | % m. 163; MIDI bar 163
\barNumberCheck #164 c'2~ c'8 c8-.( c8-. c8-.) | % m. 164; MIDI bar 164
\barNumberCheck #165 b,4 r4 r2 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 r4 c'4(\< b4 bes4 | % m. 169; MIDI bar 169
\barNumberCheck #170 a4) aes4.\!\sf-> g8-.\p fis8-. f8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 e8 r8 f8 r8 g8 r8 g,8 r8 | % m. 171; MIDI bar 171
\barNumberCheck #172 g,2(-> c,8-.) r8 r4 | % m. 172; MIDI bar 172
\barNumberCheck #173 r4 c'4(\< b4 bes4 | % m. 173; MIDI bar 173
\barNumberCheck #174 a4) aes4.\!\sf g8-.\p fis8-. f8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 e8 r8 f8 r8 g8 r8 g,8 r8 | % m. 175; MIDI bar 175
\barNumberCheck #176 <c, c>8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c16 b,16 c16 b,16 c16 e16 g16 e16 d16 f16 g16 f16 e16 g16 c'16 g16 | % m. 178; MIDI bar 178
\barNumberCheck #179 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g4 | % m. 179; MIDI bar 179
\barNumberCheck #180 g4 g4 g4 g4 | % m. 180; MIDI bar 180
\barNumberCheck #181 g2:8\< g2:8 | % m. 181; MIDI bar 181
\barNumberCheck #182 g1:16\ff | % m. 182; MIDI bar 182
\barNumberCheck #183 g4-. g4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 e'1(\pp | % m. 184; MIDI bar 184
\barNumberCheck #185 f'1) | % m. 185; MIDI bar 185
\barNumberCheck #186 b4 b8. b16 b4 b4 | % m. 186; MIDI bar 186
\barNumberCheck #187 c'2. r4 | % m. 187; MIDI bar 187
\barNumberCheck #188 e'1( | % m. 188; MIDI bar 188
\barNumberCheck #189 d'1) | % m. 189; MIDI bar 189
\barNumberCheck #190 ges'4 ges'8. ges'16 ges'4 ges'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g'1\f->~ | % m. 191; MIDI bar 191
\barNumberCheck #192 g'2\p b2( | % m. 192; MIDI bar 192
\barNumberCheck #193 a2 e'2) | % m. 193; MIDI bar 193
\barNumberCheck #194 fis'1( | % m. 194; MIDI bar 194
\barNumberCheck #195 g'8) r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 c1( | % m. 196; MIDI bar 196
\barNumberCheck #197 f,1) | % m. 197; MIDI bar 197
\barNumberCheck #198 b4 b8. b16 b4 b4 | % m. 198; MIDI bar 198
\barNumberCheck #199 c'2. r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 c1( | % m. 200; MIDI bar 200
\barNumberCheck #201 f1) | % m. 201; MIDI bar 201
\barNumberCheck #202 bes,2( aes,2 | % m. 202; MIDI bar 202
\barNumberCheck #203 g,2 aes,2 | % m. 203; MIDI bar 203
\barNumberCheck #204 bes,1)~ | % m. 204; MIDI bar 204
\barNumberCheck #205 bes,1~ | % m. 205; MIDI bar 205
\barNumberCheck #206 bes,2. r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 f2~ f8 g8( aes8 bes8 | % m. 207; MIDI bar 207
\barNumberCheck #208 c'4) \grace { d'16( c'16 b16 } c'8.) d'16 ees'2 | % m. 208; MIDI bar 208
\barNumberCheck #209 e'8\sf r8 r4 r2 | % m. 209; MIDI bar 209
\barNumberCheck #210 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 210; MIDI bar 210
\barNumberCheck #211 g,8 r8 a8\f r8 f8 r8 g8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 214; MIDI bar 214
\barNumberCheck #215 g,8 r8 a8\f r8 f8 r8 g8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c'8\ff c'16 c'16 des'8:16 c'8:16 d'8:16 c'8:16 ees'8:16 c'8:16 | % m. 216; MIDI bar 216
\barNumberCheck #217 e'8:16 c'8:16 f'8:16 c'8:16 fis'8:16 c'8:16 g'8:16 c'8:16 | % m. 217; MIDI bar 217
\barNumberCheck #218 aes'8:16 f'8:16 d'8:16 b8:16 f'8:16 d'8:16 b8:16 aes8:16 | % m. 218; MIDI bar 218
\barNumberCheck #219 f8:16 aes8:16 b8:16 d'8:16 f8:16 aes8:16 b8:16 d'8:16 | % m. 219; MIDI bar 219
\barNumberCheck #220 b8:16 aes8:16 f8:16 d8:16 aes8:16 f'8:16 d'8:16 b8:16 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes8:16 f8:16 d8:16 f8:16 aes8:16 b8:16 d'8:16 f'8:16 | % m. 221; MIDI bar 221
\barNumberCheck #222 aes'4 f'8. f'16 f'4 f'4 | % m. 222; MIDI bar 222
\barNumberCheck #223 f'2(-> e'8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 gis4 gis8. gis16 gis4 gis4 | % m. 224; MIDI bar 224
\barNumberCheck #225 gis2->~ gis8 gis16 gis16 gis8 gis8 | % m. 225; MIDI bar 225
\barNumberCheck #226 a8:16 gis8:16 a8:16 g8:16 f8:16 g8:16 f8:16 e8:16 | % m. 226; MIDI bar 226
\barNumberCheck #227 f2:16 e4:16 fis4:16 | % m. 227; MIDI bar 227
\barNumberCheck #228 g16 g,16 a,16 b,16 c16 d16 e16 f!16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c'16 g,16 a,16 b,16 c16 d16 e16 f16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'16 b16 a16 g16 fis16 g16 a16 b16 c'16 b16 c'16 d'16 e'16 d'16 e'16 f'16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'4 f4 g4 g4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'8:16\ff e'8:16 g'8:16 e'8:16 c'8:16 g8:16 e'8:16 c'8:16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g8:16 e8:16 c'8:16 g8:16 e'8:16 c'8:16 g'8:16 e'8:16 | % m. 233; MIDI bar 233
\barNumberCheck #234 c'8:16 g'8:16 e'8:16 c'8:16 g8:16 e8:16 c8:16 g,8:16 | % m. 234; MIDI bar 234
\barNumberCheck #235 c8:16 g,8:16 c8:16 g,8:16 c8:16 g,8:16 c8:16 g,8:16 | % m. 235; MIDI bar 235
\barNumberCheck #236 c4 r4 <c, g, e c'>4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 <c, c>1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
bassI = {
\barNumberCheck #1 \key c \major c'4..\ff c'16 a4.. a16 | % m. 1; MIDI bar 1
\barNumberCheck #2 f4-. f,4-. r2 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 g4..\ff g16 g4.. g16 | % m. 5; MIDI bar 5
\barNumberCheck #6 g4-. g4-. r2 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r8 c8\pp c8 c8 c4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 r8 c8 c8 c8 c4 r4 | % m. 9; MIDI bar 9
\barNumberCheck #10 r4 c4 c'4 c'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 c'2~ c'8 r8 r4 | % m. 11; MIDI bar 11
\barNumberCheck #12 r8 b8 b8 b8 b4 r4 | % m. 12; MIDI bar 12
\barNumberCheck #13 r8 b8 b8 b8 b4 r4 | % m. 13; MIDI bar 13
\barNumberCheck #14 r4 g4 g4 g4 | % m. 14; MIDI bar 14
\barNumberCheck #15 c2. r4 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 c,8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 27; MIDI bar 27
\barNumberCheck #28 c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 28; MIDI bar 28
\barNumberCheck #29 c16 b,16 c16 b,16 c16 e16 g16 e16 d16_\markup \italic "cresc." f16 g16 f16 e16 g16 c'16 g16 | % m. 29; MIDI bar 29
\barNumberCheck #30 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g4 | % m. 30; MIDI bar 30
\barNumberCheck #31 g4 g4 g4 g4 | % m. 31; MIDI bar 31
\barNumberCheck #32 g4\< g4 g2 | % m. 32; MIDI bar 32
\barNumberCheck #33 c8\ff c8 c8 c8 c8 c8 c8 c8 | % m. 33; MIDI bar 33
\barNumberCheck #34 c8 c8 c8 c8 c8 c8 c8 c8 | % m. 34; MIDI bar 34
\barNumberCheck #35 b8 d'8 f'8 d'8 b8 g8 d'8 b8 | % m. 35; MIDI bar 35
\barNumberCheck #36 g8 d8 b8 g8 d8 b,8 d8 g,8 | % m. 36; MIDI bar 36
\barNumberCheck #37 a,8 a,8 a,8 a,8 a,8 a,8 a,8 a,8 | % m. 37; MIDI bar 37
\barNumberCheck #38 a,8 a,8 a,8 a,8 a,8 a,8 a,8 a,8 | % m. 38; MIDI bar 38
\barNumberCheck #39 e8 g8 b8 g8 e8 b,8 g8 e8 | % m. 39; MIDI bar 39
\barNumberCheck #40 b,8 g,8 b,8 e8 g8 b8 g8 e8 | % m. 40; MIDI bar 40
\barNumberCheck #41 c8 c8 c8 c8 c8 c8 c8 c8 | % m. 41; MIDI bar 41
\barNumberCheck #42 b,8 b,8 b,8 b,8 b,8 b,8 b,8 b,8 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2~ d8 ees8 d8 ees8 | % m. 43; MIDI bar 43
\barNumberCheck #44 d2~ d8 ees8 d8 ees8 | % m. 44; MIDI bar 44
\barNumberCheck #45 d8 ees8 d8 cis8 d8 fis8 a8 a,8 | % m. 45; MIDI bar 45
\barNumberCheck #46 d8 ees8 d8 cis8 d8 fis8 a8 a,8 | % m. 46; MIDI bar 46
\barNumberCheck #47 d4 d4 d4 d4 | % m. 47; MIDI bar 47
\barNumberCheck #48 d8_\markup \italic "cresc." d8 d8 d8 d8 d8 d8 d8 | % m. 48; MIDI bar 48
\barNumberCheck #49 d8 d8 d8 d8 d8 d8 d8 d8 | % m. 49; MIDI bar 49
\barNumberCheck #50 d4-. d4-. r2\fermata | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 fis4\pp fis8. fis16 fis4 fis4 | % m. 53; MIDI bar 53
\barNumberCheck #54 g2. r4 | % m. 54; MIDI bar 54
\barNumberCheck #55 g,1(\p | % m. 55; MIDI bar 55
\barNumberCheck #56 c1) | % m. 56; MIDI bar 56
\barNumberCheck #57 bes,4 bes,8. bes,16 bes,4 bes,4 | % m. 57; MIDI bar 57
\barNumberCheck #58 bes,1\f-> | % m. 58; MIDI bar 58
\barNumberCheck #59 a,1(\pp | % m. 59; MIDI bar 59
\barNumberCheck #60 g,2. e,4) | % m. 60; MIDI bar 60
\barNumberCheck #61 a,1( | % m. 61; MIDI bar 61
\barNumberCheck #62 d4) r4 r2 | % m. 62; MIDI bar 62
\barNumberCheck #63 R1 | % m. 63; MIDI bar 63
\barNumberCheck #64 R1 | % m. 64; MIDI bar 64
\barNumberCheck #65 fis4\pp fis8. fis16 fis4 fis4 | % m. 65; MIDI bar 65
\barNumberCheck #66 g2. r4 | % m. 66; MIDI bar 66
\barNumberCheck #67 g,1( | % m. 67; MIDI bar 67
\barNumberCheck #68 c1 | % m. 68; MIDI bar 68
\barNumberCheck #69 f,2 ees,2 | % m. 69; MIDI bar 69
\barNumberCheck #70 d,2 ees,2 | % m. 70; MIDI bar 70
\barNumberCheck #71 f,1)~ | % m. 71; MIDI bar 71
\barNumberCheck #72 f,1~ | % m. 72; MIDI bar 72
\barNumberCheck #73 f,2-> f4 r4 | % m. 73; MIDI bar 73
\barNumberCheck #74 ees4 ees8. ees16 ees4 ees4 | % m. 74; MIDI bar 74
\barNumberCheck #75 ees,1( | % m. 75; MIDI bar 75
\barNumberCheck #76 d,8-.) r8 r4 r2 | % m. 76; MIDI bar 76
\barNumberCheck #77 r8 b,8-. c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 77; MIDI bar 77
\barNumberCheck #78 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 78; MIDI bar 78
\barNumberCheck #79 R1 | % m. 79; MIDI bar 79
\barNumberCheck #80 R1 | % m. 80; MIDI bar 80
\barNumberCheck #81 r8 b,8-.\p c8-. cis8-. d8-. cis8-. d8-. cis8-. | % m. 81; MIDI bar 81
\barNumberCheck #82 d8 r8 e8\f r8 c8 r8 d8 r8 | % m. 82; MIDI bar 82
\barNumberCheck #83 g4\ff aes8 g8 a8 g8 bes8 g8 | % m. 83; MIDI bar 83
\barNumberCheck #84 b8 g8 c'8 g8 cis'8 g8 d'8 g8 | % m. 84; MIDI bar 84
\barNumberCheck #85 ees'8 c'8 a8 fis8 c'8 a8 fis8 ees8 | % m. 85; MIDI bar 85
\barNumberCheck #86 a8 fis8 ees8 c8 fis8 ees8 c8 a,8 | % m. 86; MIDI bar 86
\barNumberCheck #87 ees8 c8 a,8 fis,8 ees,8 fis,8 a,8 c8 | % m. 87; MIDI bar 87
\barNumberCheck #88 ees8 c8 a,8 c8 ees8 fis8 a8 c'8 | % m. 88; MIDI bar 88
\barNumberCheck #89 c'4 c'8. c'16 c'4 c'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 c'2(-> b4-.) r4 | % m. 90; MIDI bar 90
\barNumberCheck #91 dis4 dis8. dis16 dis4 dis4 | % m. 91; MIDI bar 91
\barNumberCheck #92 dis2->~ dis8 dis16 dis16 dis8 dis8 | % m. 92; MIDI bar 92
\barNumberCheck #93 e8 dis8 e8 d8 c8 d8 c8 b,8 | % m. 93; MIDI bar 93
\barNumberCheck #94 c8 c8 c8 c8 b,8 b,8 cis8 cis8 | % m. 94; MIDI bar 94
\barNumberCheck #95 d16 d,16 e,16 fis,16 g,16 a,16 b,16 c16 d16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 95; MIDI bar 95
\barNumberCheck #96 g16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g,16 a,16 b,16 c16 d16 e16 fis16 | % m. 96; MIDI bar 96
\barNumberCheck #97 g16( fis16 e16 d16 cis16 d16 e16 fis16 g16 fis16 g16 a16 b16 a16 b16 c'16) | % m. 97; MIDI bar 97
\barNumberCheck #98 d'8 r8 c4 d4 d4 | % m. 98; MIDI bar 98
\barNumberCheck #99 g8 b8 d'8 b8 g8 d8 b8 g8 | % m. 99; MIDI bar 99
\barNumberCheck #100 d8 b,8 g8 d8 b,8 g,8 d8 b,8 | % m. 100; MIDI bar 100
\barNumberCheck #101 g,4.. g,16 g,4.. g,16 | % m. 101; MIDI bar 101
\barNumberCheck #102 g,4 g,4 r2 | % m. 102; MIDI bar 102
\barNumberCheck #103 R1 | % m. 103; MIDI bar 103
\barNumberCheck #104 r2 r2\fermata | % m. 104; MIDI bar 104
\barNumberCheck #105 R1 | % m. 105; MIDI bar 105
\barNumberCheck #106 r2 r2\fermata | % m. 106; MIDI bar 106
\barNumberCheck #107 R1 | % m. 107; MIDI bar 107
\barNumberCheck #108 R1 | % m. 108; MIDI bar 108
\barNumberCheck #109 R1 | % m. 109; MIDI bar 109
\barNumberCheck #110 R1 | % m. 110; MIDI bar 110
\barNumberCheck #111 R1 | % m. 111; MIDI bar 111
\barNumberCheck #112 R1 | % m. 112; MIDI bar 112
\barNumberCheck #113 R1 | % m. 113; MIDI bar 113
\barNumberCheck #114 R1 | % m. 114; MIDI bar 114
\barNumberCheck #115 R1 | % m. 115; MIDI bar 115
\barNumberCheck #116 R1 | % m. 116; MIDI bar 116
\barNumberCheck #117 e4-.(\p\< e4-. e4-. e4-.) | % m. 117; MIDI bar 117
\barNumberCheck #118 dis2(\!-> e4) r4 | % m. 118; MIDI bar 118
\barNumberCheck #119 R1 | % m. 119; MIDI bar 119
\barNumberCheck #120 R1 | % m. 120; MIDI bar 120
\barNumberCheck #121 R1 | % m. 121; MIDI bar 121
\barNumberCheck #122 b,4..\ff d16 fis4.. b16 | % m. 122; MIDI bar 122
\barNumberCheck #123 d'4-. fis'4-. r2 | % m. 123; MIDI bar 123
\barNumberCheck #124 fis,4.. ais,16 cis4.. fis16 | % m. 124; MIDI bar 124
\barNumberCheck #125 ais4-. cis'4-. r2 | % m. 125; MIDI bar 125
\barNumberCheck #126 b,4.. d16 fis4.. b16 | % m. 126; MIDI bar 126
\barNumberCheck #127 d'4-. fis'4-. r2 | % m. 127; MIDI bar 127
\barNumberCheck #128 a,4.. c16 ees4.. fis16 | % m. 128; MIDI bar 128
\barNumberCheck #129 a4-. c'4-. r2 | % m. 129; MIDI bar 129
\barNumberCheck #130 a,4.. c16 f4.. a16 | % m. 130; MIDI bar 130
\barNumberCheck #131 c'4-. ees'4-. r2 | % m. 131; MIDI bar 131
\barNumberCheck #132 f,4.. bes,16 des4.. f16 | % m. 132; MIDI bar 132
\barNumberCheck #133 bes4-. des'4-. r2 | % m. 133; MIDI bar 133
\barNumberCheck #134 bes,4.. bes,16 d4.. f16 | % m. 134; MIDI bar 134
\barNumberCheck #135 bes4-. d'4-. r2 | % m. 135; MIDI bar 135
\barNumberCheck #136 bes,4.. bes,16 ees4.. g16 | % m. 136; MIDI bar 136
\barNumberCheck #137 bes4-. ees'4-. r2 | % m. 137; MIDI bar 137
\barNumberCheck #138 b,!4.. b,16 d4.. g16 | % m. 138; MIDI bar 138
\barNumberCheck #139 b!4-. d'4-. r2 | % m. 139; MIDI bar 139
\barNumberCheck #140 g,4.. g,16 c4.. ees16 | % m. 140; MIDI bar 140
\barNumberCheck #141 g4-. c'4-. r2 | % m. 141; MIDI bar 141
\barNumberCheck #142 g,4 r4 r8 aes,16 aes,16 g,16-. g,16-. aes,16-. aes,16-. | % m. 142; MIDI bar 142
\barNumberCheck #143 g,2~ g,8 aes,16 aes,16 g,16 g,16 aes,16 aes,16 | % m. 143; MIDI bar 143
\barNumberCheck #144 aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) | % m. 144; MIDI bar 144
\barNumberCheck #145 aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) aes,16( g,16 aes,16 g,16) | % m. 145; MIDI bar 145
\barNumberCheck #146 aes,8 b,8 d8 f8 aes8 b8 d'8 f'8 | % m. 146; MIDI bar 146
\barNumberCheck #147 aes'8 f'8 d'8 b8 aes8 f8 d8 b,8 | % m. 147; MIDI bar 147
\barNumberCheck #148 R1 | % m. 148; MIDI bar 148
\barNumberCheck #149 R1 | % m. 149; MIDI bar 149
\barNumberCheck #150 R1 | % m. 150; MIDI bar 150
\barNumberCheck #151 R1 | % m. 151; MIDI bar 151
\barNumberCheck #152 R1 | % m. 152; MIDI bar 152
\barNumberCheck #153 r2 r4 r4\fermata | % m. 153; MIDI bar 153
\barNumberCheck #154 c'4..\ff c'16 a4.. a16 | % m. 154; MIDI bar 154
\barNumberCheck #155 f4-. f,4-. r2 | % m. 155; MIDI bar 155
\barNumberCheck #156 R1 | % m. 156; MIDI bar 156
\barNumberCheck #157 R1 | % m. 157; MIDI bar 157
\barNumberCheck #158 g4..\ff g16 g4.. g16 | % m. 158; MIDI bar 158
\barNumberCheck #159 g4-. g4-. r2 | % m. 159; MIDI bar 159
\barNumberCheck #160 R1 | % m. 160; MIDI bar 160
\barNumberCheck #161 r8 c8\pp c8 c8 c4 r4 | % m. 161; MIDI bar 161
\barNumberCheck #162 r8 c8 c8 c8 c4 r4 | % m. 162; MIDI bar 162
\barNumberCheck #163 r4 c4 c'4 c'4 | % m. 163; MIDI bar 163
\barNumberCheck #164 c'2~ c'8 c8-.( c8-. c8-.) | % m. 164; MIDI bar 164
\barNumberCheck #165 b,4 r4 r2 | % m. 165; MIDI bar 165
\barNumberCheck #166 R1 | % m. 166; MIDI bar 166
\barNumberCheck #167 R1 | % m. 167; MIDI bar 167
\barNumberCheck #168 R1 | % m. 168; MIDI bar 168
\barNumberCheck #169 R1 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 aes4.\sf g8-.\p fis8-. f8-. | % m. 170; MIDI bar 170
\barNumberCheck #171 e8 r8 r4 r2 | % m. 171; MIDI bar 171
\barNumberCheck #172 R1 | % m. 172; MIDI bar 172
\barNumberCheck #173 R1 | % m. 173; MIDI bar 173
\barNumberCheck #174 r4 aes4.\sf g8-.\p fis8-. f8-. | % m. 174; MIDI bar 174
\barNumberCheck #175 e8 r8 r4 r2 | % m. 175; MIDI bar 175
\barNumberCheck #176 c8\ff c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16) | % m. 176; MIDI bar 176
\barNumberCheck #177 c8 c16 c16 c8 c8 c16(-> b,16 a,16 g,16) g,16(-> f,16 e,16 d,16) | % m. 177; MIDI bar 177
\barNumberCheck #178 c,8 r8 c16 e16 g16 e16 d16 f16 g16 f16 e16 g16 c'16 g16 | % m. 178; MIDI bar 178
\barNumberCheck #179 f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g4 | % m. 179; MIDI bar 179
\barNumberCheck #180 g4 g4 g4 g4 | % m. 180; MIDI bar 180
\barNumberCheck #181 g2:8\< g2:8 | % m. 181; MIDI bar 181
\barNumberCheck #182 g8\ff g8 g8 g8 g8 g8 g8 g8 | % m. 182; MIDI bar 182
\barNumberCheck #183 g4-. g4-. r2\fermata | % m. 183; MIDI bar 183
\barNumberCheck #184 c1(\pp | % m. 184; MIDI bar 184
\barNumberCheck #185 f,1) | % m. 185; MIDI bar 185
\barNumberCheck #186 R1 | % m. 186; MIDI bar 186
\barNumberCheck #187 R1 | % m. 187; MIDI bar 187
\barNumberCheck #188 c1( | % m. 188; MIDI bar 188
\barNumberCheck #189 f1) | % m. 189; MIDI bar 189
\barNumberCheck #190 ees4 ees8. ees16 ees4 ees4 | % m. 190; MIDI bar 190
\barNumberCheck #191 ees,1\f-> | % m. 191; MIDI bar 191
\barNumberCheck #192 d,1\p | % m. 192; MIDI bar 192
\barNumberCheck #193 c2.( a,4) | % m. 193; MIDI bar 193
\barNumberCheck #194 d1( | % m. 194; MIDI bar 194
\barNumberCheck #195 g8) r8 r4 r2 | % m. 195; MIDI bar 195
\barNumberCheck #196 c1( | % m. 196; MIDI bar 196
\barNumberCheck #197 f,1) | % m. 197; MIDI bar 197
\barNumberCheck #198 b4 b8. b16 b4 b4 | % m. 198; MIDI bar 198
\barNumberCheck #199 c'2. r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 c1( | % m. 200; MIDI bar 200
\barNumberCheck #201 f1) | % m. 201; MIDI bar 201
\barNumberCheck #202 bes,2( aes,2 | % m. 202; MIDI bar 202
\barNumberCheck #203 g,2 aes,2 | % m. 203; MIDI bar 203
\barNumberCheck #204 bes,1)~ | % m. 204; MIDI bar 204
\barNumberCheck #205 bes,1~ | % m. 205; MIDI bar 205
\barNumberCheck #206 bes,2. r4 | % m. 206; MIDI bar 206
\barNumberCheck #207 aes,4 aes,8. aes,16 aes,4 aes,4 | % m. 207; MIDI bar 207
\barNumberCheck #208 aes,1( | % m. 208; MIDI bar 208
\barNumberCheck #209 g,8)\sf r8 r4 r2 | % m. 209; MIDI bar 209
\barNumberCheck #210 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 210; MIDI bar 210
\barNumberCheck #211 g,8 r8 a8\f r8 f8 r8 g8 r8 | % m. 211; MIDI bar 211
\barNumberCheck #212 R1 | % m. 212; MIDI bar 212
\barNumberCheck #213 R1 | % m. 213; MIDI bar 213
\barNumberCheck #214 r8 e,8-.\p f,8-. fis,8-. g,8-. fis,8-. g,8-. fis,8-. | % m. 214; MIDI bar 214
\barNumberCheck #215 g,8 r8 a8\f r8 f8 r8 g8 r8 | % m. 215; MIDI bar 215
\barNumberCheck #216 c8\ff c8 des8 c8 d8 c8 ees8 c8 | % m. 216; MIDI bar 216
\barNumberCheck #217 e8 c8 f8 c8 fis8 c8 g8 c8 | % m. 217; MIDI bar 217
\barNumberCheck #218 aes8 f8 d8 b,8 f'8 d'8 b8 aes8 | % m. 218; MIDI bar 218
\barNumberCheck #219 f8 aes,8 b,8 d8 f8 aes8 b8 d'8 | % m. 219; MIDI bar 219
\barNumberCheck #220 b8 aes8 f8 d8 aes,8 f,8 d8 b,8 | % m. 220; MIDI bar 220
\barNumberCheck #221 aes,8 f,8 d,8 f,8 aes,8 b,8 d8 f8 | % m. 221; MIDI bar 221
\barNumberCheck #222 aes4 f8. f16 f4 f4 | % m. 222; MIDI bar 222
\barNumberCheck #223 f2(-> e8) r8 r4 | % m. 223; MIDI bar 223
\barNumberCheck #224 gis4 gis8. gis16 gis4 gis4 | % m. 224; MIDI bar 224
\barNumberCheck #225 gis2->~ gis8 gis16 gis16 gis8 gis8 | % m. 225; MIDI bar 225
\barNumberCheck #226 a8 gis8 a8 g8 f8 g8 f8 e8 | % m. 226; MIDI bar 226
\barNumberCheck #227 f8 f8 f8 f8 e8 e8 fis8 fis8 | % m. 227; MIDI bar 227
\barNumberCheck #228 g16 g,16 a,16 b,16 c16 d16 e16 f!16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 228; MIDI bar 228
\barNumberCheck #229 c'16 g,16 a,16 b,16 c16 d16 e16 f16 g16 c16 d16 e16 f16 g16 a16 b16 | % m. 229; MIDI bar 229
\barNumberCheck #230 c'16 b16 a16 g16 fis16 g16 a16 b16 c'16 b16 c'16 d'16 e'16 d'16 e'16 f'16 | % m. 230; MIDI bar 230
\barNumberCheck #231 g'4 f4 g4 g4 | % m. 231; MIDI bar 231
\barNumberCheck #232 c'8:16\ff e'8:16 g'8:16 e'8:16 c'8:16 g8:16 e'8:16 c'8:16 | % m. 232; MIDI bar 232
\barNumberCheck #233 g8:16 e8:16 c'8:16 g8:16 e8:16 c8:16 g8:16 e8:16 | % m. 233; MIDI bar 233
\barNumberCheck #234 c8 g8 e8 c8 g8 e8 c8 g,8 | % m. 234; MIDI bar 234
\barNumberCheck #235 c8 g,8 c8 g,8 c8 g,8 c8 g,8 | % m. 235; MIDI bar 235
\barNumberCheck #236 c4 r4 c4 r4 | % m. 236; MIDI bar 236
\barNumberCheck #237 c1\fermata | % m. 237; MIDI bar 237
\barNumberCheck #238
}
fluteII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 f'2(\p e'2 | % m. 11; MIDI bar 11
\barNumberCheck #12 f'1) | % m. 12; MIDI bar 12
\barNumberCheck #13 bes'2 a'2 | % m. 13; MIDI bar 13
\barNumberCheck #14 c''4( b'4-> c''4) r4 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 e'1~ | % m. 16; MIDI bar 16
\barNumberCheck #17 e'1 | % m. 17; MIDI bar 17
\barNumberCheck #18 f'2( c''2 | % m. 18; MIDI bar 18
\barNumberCheck #19 bes'1 | % m. 19; MIDI bar 19
\barNumberCheck #20 a'2.) r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 r4. g'''8(\f\< fis'''8 f'''8 e'''8 d'''8) | % m. 23; MIDI bar 23
\barNumberCheck #24 d'''4.(\!-> dis'''8 e'''4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 r2 r4 r8. c''16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 aes''2->( g''8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 r4 g''8(\p-> fis''16)-. r16 r4 a''8(-> g''16)-. r16 | % m. 27; MIDI bar 27
\barNumberCheck #28 R1 | % m. 28; MIDI bar 28
\barNumberCheck #29 r2 des'''8(-> e''16)-. r16 r4 | % m. 29; MIDI bar 29
\barNumberCheck #30 r4 e'''8(->\pp f'''16)-. r16 r2 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 R1 | % m. 34; MIDI bar 34
\barNumberCheck #35 R1 | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 3/2 { r8\p aes''8( des'''8 } \tuplet 3/2 { f'''8 aes''8 des'''8 } \tuplet 3/2 4 { f''8 aes''8 des''8 f''8 aes'8 des''8 }) | % m. 36; MIDI bar 36
\barNumberCheck #37 R1 | % m. 37; MIDI bar 37
\barNumberCheck #38 R1 | % m. 38; MIDI bar 38
\barNumberCheck #39 R1 | % m. 39; MIDI bar 39
\barNumberCheck #40 \override TupletBracket.padding = #1.2 \override TupletBracket.outside-staff-priority = #200 \tuplet 3/2 { r8 c'''8(\f f'''8 } \tuplet 3/2 { aes''8 c'''8 f''8 } \tuplet 3/2 4 { aes''8 c''8 e''8 f''8 g''8 aes''8) } \revert TupletBracket.padding \revert TupletBracket.outside-staff-priority | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 R1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 \override TupletBracket.padding = #1.2 \override TupletBracket.outside-staff-priority = #200 \tuplet 3/2 { r8 f'''8\f ees'''8 } d'''8-. r8 r2 \revert TupletBracket.padding \revert TupletBracket.outside-staff-priority | % m. 45; MIDI bar 45
\barNumberCheck #46 \override TupletBracket.padding = #1.2 \override TupletBracket.outside-staff-priority = #200 \tuplet 3/2 { r8\ff f'''8 ees'''8 } \tuplet 3/2 { d'''8 c'''8 bes''8 } \tuplet 3/2 { c'''8 bes''8 a''8 } aes''4-> \revert TupletBracket.padding \revert TupletBracket.outside-staff-priority | % m. 46; MIDI bar 46
\barNumberCheck #47 a''1\pp | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 3/2 4 { b'8-.\ff d''8-. f''8-. aes''8-. b''8-. d'''8-. } f'''2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 R1 | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 a''2\pp^\markup \italic "Solo" \grace { a''8( } g''8.[) fis''16 g''8. a''16] | % m. 52; MIDI bar 52
\barNumberCheck #53 \after 4*480/480 \< f''2( fis''2) | % m. 53; MIDI bar 53
\barNumberCheck #54 \tuplet 3/2 4 { g''8(\! bes''8 cis'''8 e'''8 d'''8 bes''8) } \grace { a''8( } g''8.[) fis''16 g''8. c'''16] | % m. 54; MIDI bar 54
\barNumberCheck #55 f''4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
oboeOneII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 a''2\(\p^\markup \italic "Solo" \grace { f''16( g''16 a''16 } g''8.[) fis''16 g''8. a''16]\) | % m. 11; MIDI bar 11
\barNumberCheck #12 f''!8.( g''32 f''32 e''32 f''32 g''32 a''32  \tuplet 6/4 { g''32-> f''32 e''32 g''32 f''32 d''32 } \afterGrace 15/16 c''2 { c''32 d''32 e''32 f''32) } | % m. 12; MIDI bar 12
\barNumberCheck #13 g''2 a''8.( bes''32 a''32 g''8 f''8) | % m. 13; MIDI bar 13
\barNumberCheck #14 e''8( g''16) r16 d''8( g''16) r16 c''4. cis''8( | % m. 14; MIDI bar 14
\barNumberCheck #15 d''8\< ees''8 e''8 f''8 \tuplet 3/2 { fis''8 g''8 aes''8 } \tuplet 3/2 { a''8 bes''8 b''8 }) | % m. 15; MIDI bar 15
\barNumberCheck #16 c'''4.(\! b''8 bes''8 g''8 \tuplet 5/4 { e''16 c''16 b'16 g'16 e'16 } | % m. 16; MIDI bar 16
\barNumberCheck #17 c'2)-> bes''2( | % m. 17; MIDI bar 17
\barNumberCheck #18 a''2\> aes''2) | % m. 18; MIDI bar 18
\barNumberCheck #19 g''2\pp \grace { f''16( g''16 a''16 } g''8.[) fis''16 g''8. c'''16] | % m. 19; MIDI bar 19
\barNumberCheck #20 f''2. r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 f'4\f a''8.( b''32 a''32 g''8 f''8 e''8 d''8 | % m. 22; MIDI bar 22
\barNumberCheck #23 c''8\f\< b'8) g''8.( a''32 g''32 fis''8 f''8 e''8 d''8 | % m. 23; MIDI bar 23
\barNumberCheck #24 d''4.\!-> dis''8 e''4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 r2 r4 r8. c''16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 aes''2->( g''8) r8 r8. g''16\p | % m. 26; MIDI bar 26
\barNumberCheck #27 g''8(-> fis''16)-. r16 r4 a''8(-> g''16)-. r16 r4 | % m. 27; MIDI bar 27
\barNumberCheck #28 bes''8(-> a''16)-. r16 r4 c'''8(-> bes''16)-. r16 r4 | % m. 28; MIDI bar 28
\barNumberCheck #29 a''8(-> bes''16)-. r16 r4 des''8(-> e'16)-. r16 r4 | % m. 29; MIDI bar 29
\barNumberCheck #30 r4 e''8(->\pp f''16)-. r16 r2 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 r2 aes''2\f | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { f''8[ f''8 f''8] f''8[ f''8 f''8] ees''8[ ees''8 ees''8] ees''8[ ees''8 ees''8] } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 3/2 4 { des''8\(\p aes'8 des''8 f''8 aes'8 des''8 } \tuplet 3/2 4 { f'8 aes'8 des''8 f''8 aes'8 des''8 }\) | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { ees''2.:8 } \tuplet 6/4 { f''2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { c''8 c''8 c''8 bes'8 bes'8 bes'8 } aes'4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { f''2.:8\f } \tuplet 6/4 { e''2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 \tuplet 3/2 4 { f''8( c''8 f''8 aes''8 c'''8 f''8 } \tuplet 3/2 4 { aes''8 c''8 e''8 f''8 g''8 aes''8) } | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 g'1->\ff | % m. 42; MIDI bar 42
\barNumberCheck #43 a'2 \tuplet 6/4 { a'2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 \override TupletBracket.padding = #1.2 \override TupletBracket.outside-staff-priority = #200 \tuplet 3/2 { r8 f''8(\f ees''8 } \tuplet 3/2 { d''8) f'8( ees'8 } d'8) r8 r4 \revert TupletBracket.padding \revert TupletBracket.outside-staff-priority | % m. 45; MIDI bar 45
\barNumberCheck #46 r2\ff \tuplet 3/2 { c'''8 bes''8 a''8 } aes''4-> | % m. 46; MIDI bar 46
\barNumberCheck #47 a''2\pp fis''2 | % m. 47; MIDI bar 47
\barNumberCheck #48 f''2\ff \tuplet 6/4 { d''2.:8 } | % m. 48; MIDI bar 48
\barNumberCheck #49 R1 | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 a''2\pp^\markup \italic "Soli" \grace { a''8( } g''8.[) fis''16 g''8. a''16] | % m. 52; MIDI bar 52
\barNumberCheck #53 \after 4*480/480 \< f''2( fis''2) | % m. 53; MIDI bar 53
\barNumberCheck #54 g''4\! r4 \grace { a''8( } g''8.[) fis''16 g''8. c'''16] | % m. 54; MIDI bar 54
\barNumberCheck #55 f''4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
oboeTwoII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 c''2(\p bes'2 | % m. 11; MIDI bar 11
\barNumberCheck #12 a'1) | % m. 12; MIDI bar 12
\barNumberCheck #13 e'2( f'2 | % m. 13; MIDI bar 13
\barNumberCheck #14 g'2.) r4 | % m. 14; MIDI bar 14
\barNumberCheck #15  R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 g'1\p~ | % m. 16; MIDI bar 16
\barNumberCheck #17 g'1 | % m. 17; MIDI bar 17
\barNumberCheck #18 f'1~ | % m. 18; MIDI bar 18
\barNumberCheck #19 f'2\pp e'2 | % m. 19; MIDI bar 19
\barNumberCheck #20 f'2. r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22  R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 d'8\f\< d'8 b'8 b'8 c''8( d''8 c''8 b'8) | % m. 23; MIDI bar 23
\barNumberCheck #24 b'2(\!-> c''4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 r2 r4 r8. c''16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 b'2->( c''8) r8 r8. g'16\p | % m. 26; MIDI bar 26
\barNumberCheck #27 g'8(->\p fis'16)-. r16 g'8(-> fis'16)-. r16 a'8(-> g'16)-. r16 a'8(-> g'16)-. r16 | % m. 27; MIDI bar 27
\barNumberCheck #28 bes'8(-> a'16)-. r16 r4 c''8(-> bes'16)-. r16 r4 | % m. 28; MIDI bar 28
\barNumberCheck #29 a'8(-> bes'16)-. r16 r4 r2 | % m. 29; MIDI bar 29
\barNumberCheck #30 r4 e'8\pp(-> f'16)-. r16 r2 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 r2 c''2\f | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { aes'8[ aes'8 aes'8] aes'8[ aes'8 aes'8] aes'8[ aes'8 aes'8] aes'8[ aes'8 aes'8] } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 6/4 { aes'2.:8 } \tuplet 6/4 { aes'2.:8 } | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { aes'2.:8 } \tuplet 6/4 { aes'2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { aes'8 aes'8 aes'8 g'8 g'8 g'8 } ees'4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { aes'2.:8\f } \tuplet 6/4 { bes'2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 \tuplet 3/2 4 { aes'8 f'8 f'8 f'8 f'8 f'8 } \tuplet 6/4 { f'2.:8 } | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 ees'1\ff | % m. 42; MIDI bar 42
\barNumberCheck #43 ees'2 \tuplet 6/4 { ees'2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45  \tuplet 3/2 { r8 f'8(\f ees'8 } \tuplet 3/2 { d'8) f'8( ees'8 } d'8) r8 r4  | % m. 45; MIDI bar 45
\barNumberCheck #46 r2\ff r4 \tuplet 3/2 { f'8( e'8 d'8) } | % m. 46; MIDI bar 46
\barNumberCheck #47 d'1\pp | % m. 47; MIDI bar 47
\barNumberCheck #48 d'2\ff  \tuplet 6/4 { aes'2.:8 } | % m. 48; MIDI bar 48
\barNumberCheck #49 R1 | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 a'2\pp^\markup \italic "Soli" \grace { a'8( } g'8.[) fis'16 g'8. a'16] | % m. 52; MIDI bar 52
\barNumberCheck #53 \after 4*480/480 \< f'2( fis'2) | % m. 53; MIDI bar 53
\barNumberCheck #54 \tuplet 3/2 4 { g'8(\! bes'8 cis''8 e''8 d''8 bes'8) } g'8.[ fis'16 g'8. c''16] | % m. 54; MIDI bar 54
\barNumberCheck #55 f'4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
bassoonOneII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 r2 e'2(\pp | % m. 3; MIDI bar 3
\barNumberCheck #4 f'4 c'4 a4) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 e'2(-> f'4 a'4) | % m. 5; MIDI bar 5
\barNumberCheck #6 c'8(\p e'16) r16 f'4( e'4) r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 f2(\< e2) | % m. 7; MIDI bar 7
\barNumberCheck #8 gis2\f~ \tuplet 3/2 { gis8( f8 d8) } b,4-> | % m. 8; MIDI bar 8
\barNumberCheck #9 c2( e'2) | % m. 9; MIDI bar 9
\barNumberCheck #10 e'2(-> f'4) r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 c,4->^\markup \italic "Solo" g'8.( a'32 g'32 f'8 e'8 d'8 c'8 | % m. 21; MIDI bar 21
\barNumberCheck #22 b8 a8) r4 r2 | % m. 22; MIDI bar 22
\barNumberCheck #23 g8\f\< g8 b8 b8 c'8( d'8 e'8 f'8) | % m. 23; MIDI bar 23
\barNumberCheck #24 f'2(\!-> e'4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 f'2(\ff-> ees'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 r4 bes8(->\p a16)-. r16 r4 c'8(-> bes16)-. r16 | % m. 28; MIDI bar 28
\barNumberCheck #29 r4 a8(-> bes16)-. r16 r4 des'8(-> e16)-. r16 | % m. 29; MIDI bar 29
\barNumberCheck #30 e8(-> f16)-. r16 r4 r2 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 r2 r4  bes4(\<^\markup \italic "Solo" | % m. 33; MIDI bar 33
\barNumberCheck #34 aes2) ges'2\ff-> | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { f'8[ f'8 f'8] f'8[ f'8 f'8] ges'8[ ges'8 ges'8] ges'8[ ges'8 ges'8] } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 6/4 { f'2.:8 } \tuplet 6/4 { f'2.:8 } | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { ges'2.:8 } \tuplet 6/4 { f'2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { ees'8 ees'8 ees'8 des'8 des'8 des'8 } c'4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { des'2.:8\f } \tuplet 6/4 { des'2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { c'2.:8 } | % m. 40; MIDI bar 40
\barNumberCheck #41 fis'4.\fp^\markup \italic "Solo" ees'8( d'8\< c'8 f'8 fis'8) | % m. 41; MIDI bar 41
\barNumberCheck #42 g'4.(\ff ees'8) c'4 r4 | % m. 42; MIDI bar 42
\barNumberCheck #43 fis2 \tuplet 6/4 { fis2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 \tuplet 3/2 4 { g,8\p^\markup \italic "Soli" bes,8 ees8 g8 bes8 ees'8 } g'2-> | % m. 44; MIDI bar 44
\barNumberCheck #45 f'4\f f4~ \tuplet 3/2 { f8 f8( ees8 } \tuplet 3/2 { d8 c8 b,8) } | % m. 45; MIDI bar 45
\barNumberCheck #46 bes,4\ff bes,,2 \tuplet 3/2 { f8( e8 d8) } | % m. 46; MIDI bar 46
\barNumberCheck #47 fis'2(\p d'2) | % m. 47; MIDI bar 47
\barNumberCheck #48 b2\ff \tuplet 6/4 { b2.:8 } | % m. 48; MIDI bar 48
\barNumberCheck #49 a2(\pp f2) | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 r2 c'4(\pp bes4) | % m. 51; MIDI bar 51
\barNumberCheck #52 a2( cis'2 | % m. 52; MIDI bar 52
\barNumberCheck #53 a1 | % m. 53; MIDI bar 53
\barNumberCheck #54 g2 bes2) | % m. 54; MIDI bar 54
\barNumberCheck #55 a4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 ees'4(\p^\markup \italic "Solo" d'8. c'16) ges'4(-> f'8 ees'8) | % m. 56; MIDI bar 56
\barNumberCheck #57 d'2 r2 | % m. 57; MIDI bar 57
\barNumberCheck #58 d'2(\pp\> c'4 b4 | % m. 58; MIDI bar 58
\barNumberCheck #59 c'1)\ppp\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
bassoonTwoII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3  R1 | % m. 3; MIDI bar 3
\barNumberCheck #4  R1 | % m. 4; MIDI bar 4
\barNumberCheck #5  R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 g,2(\p c,4) r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 f,2( e,2) | % m. 7; MIDI bar 7
\barNumberCheck #8 e,2( f,4 b,4) | % m. 8; MIDI bar 8
\barNumberCheck #9 c1 | % m. 9; MIDI bar 9
\barNumberCheck #10 c,2(-> f,4) r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21  R1 | % m. 21; MIDI bar 21
\barNumberCheck #22  R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 g,8\f\< g,8 g8 g8 a8( b8 c'8 d'8) | % m. 23; MIDI bar 23
\barNumberCheck #24 b2(\!-> c'4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 f'2(\ff-> ees'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 r4 bes8(->\p a16)-. r16 r4 c'8(-> bes16)-. r16 | % m. 28; MIDI bar 28
\barNumberCheck #29 r4 a8(-> bes16)-. r16 r4 des8(-> e,16)-. r16 | % m. 29; MIDI bar 29
\barNumberCheck #30 e,8(-> f,16)-. r16 r4 r2 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 r4 aes4(\p^\markup \italic "Solo" g2\< | % m. 33; MIDI bar 33
\barNumberCheck #34 aes2) aes,2\ff-> | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { des8[ des8 des8] des8[ des8 des8] c'8[ c'8 c'8] c'8[ c'8 c'8] } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 6/4 { des'2.:8 } \tuplet 6/4 { des'2.:8 } | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { des'2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { ees'8 ees8 ees8 ees8 ees8 ees8 } aes,4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { des2.:8\f } \tuplet 6/4 { g2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 \tuplet 6/4 { aes2.:8 } \tuplet 6/4 { aes2.:8 } | % m. 40; MIDI bar 40
\barNumberCheck #41 aes,1\fp | % m. 41; MIDI bar 41
\barNumberCheck #42 g,1\ff | % m. 42; MIDI bar 42
\barNumberCheck #43 fis,2 \once \override TupletBracket.padding = #2 \tuplet 6/4 { fis,2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44  \override TupletNumber.extra-offset = #'(0 . 1.4) \tuplet 3/2 4 { g,8\p^\markup \italic "Soli" bes,8 ees8 g8 bes8 ees'8 } g'2-> \revert TupletNumber.extra-offset  | % m. 44; MIDI bar 44
\barNumberCheck #45 f'4\f f4~ \tuplet 3/2 { f8 f8( ees8 } \tuplet 3/2 { d8 c8 b,8) } | % m. 45; MIDI bar 45
\barNumberCheck #46 bes,4\ff bes,,2 bes,4 | % m. 46; MIDI bar 46
\barNumberCheck #47 a,1\p | % m. 47; MIDI bar 47
\barNumberCheck #48 b,2\ff \tuplet 6/4 { b,2.:8 } | % m. 48; MIDI bar 48
\barNumberCheck #49 c2\pp c,2 | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 r2 c2(\pp | % m. 51; MIDI bar 51
\barNumberCheck #52 f2 e2 | % m. 52; MIDI bar 52
\barNumberCheck #53 d2 c2 | % m. 53; MIDI bar 53
\barNumberCheck #54 bes,2 c2) | % m. 54; MIDI bar 54
\barNumberCheck #55 f4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56  R1 | % m. 56; MIDI bar 56
\barNumberCheck #57  R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 bes2(\pp\> a4 gis4 | % m. 58; MIDI bar 58
\barNumberCheck #59 a1)\ppp\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
hornOneII = {
\barNumberCheck #1 c''2...\ff^\markup \italic "Soli" c''16 | % m. 1; MIDI bar 1
\barNumberCheck #2 \after 2 \pp c''1(->\>~ | % m. 2; MIDI bar 2
\barNumberCheck #3 c''2 g'2 | % m. 3; MIDI bar 3
\barNumberCheck #4 c'2.) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'2. c''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 d''2. r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g'1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r2 ees''2\sf | % m. 8; MIDI bar 8
\barNumberCheck #9 e''2(\pp f''2) | % m. 9; MIDI bar 9
\barNumberCheck #10 f''2(-> e''4) r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 d''2:8\f e''8\< d''8 d''8 c''8 | % m. 23; MIDI bar 23
\barNumberCheck #24 d''2(\!-> d''4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 r2 r4 r8. g'16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 ees''2( d''8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27  R1 | % m. 27; MIDI bar 27
\barNumberCheck #28  R1 | % m. 28; MIDI bar 28
\barNumberCheck #29  R1 | % m. 29; MIDI bar 29
\barNumberCheck #30  R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 f'4\(\pp^\markup \italic "Solo" \grace { g'16( f'16 e'16 } f'8.\)) g'16 aes'4\( \grace { bes'16( aes'16 g'16 } aes'8.\)) bes'16 | % m. 32; MIDI bar 32
\barNumberCheck #33 c''2( bes'2)\<~ | % m. 33; MIDI bar 33
\barNumberCheck #34 bes'2 ees''2->\f | % m. 34; MIDI bar 34
\barNumberCheck #35 c''2( bes'2 | % m. 35; MIDI bar 35
\barNumberCheck #36 aes'2 c''2) | % m. 36; MIDI bar 36
\barNumberCheck #37 des''2( c''2 | % m. 37; MIDI bar 37
\barNumberCheck #38 bes'2.) r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 c''2\f d''2 | % m. 39; MIDI bar 39
\barNumberCheck #40 c''1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 g'1->\ff | % m. 42; MIDI bar 42
\barNumberCheck #43 g''2 \tuplet 6/4 { g''2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 c''4.\f r8 r4 c''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 ees''1\f | % m. 46; MIDI bar 46
\barNumberCheck #47 \tuplet 3/2 4 { e''8\pp[ e'8 e'8] e'8[ e'8 e'8] e'8[ e'8 e'8] e'8[ e'8 e'8] } | % m. 47; MIDI bar 47
\barNumberCheck #48 c'2\ff \tuplet 3/2 4 { ees''8[ ees''8 ees''8] ees''8[ ees''8 ees''8] } | % m. 48; MIDI bar 48
\barNumberCheck #49 \tuplet 3/2 4 { g8\p^\markup \italic "Soli" c'8 e'8 g'8 c''8 e''8 } g''2 | % m. 49; MIDI bar 49
\barNumberCheck #50  R1 | % m. 50; MIDI bar 50
\barNumberCheck #51  R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 e''2(\pp f''2 | % m. 52; MIDI bar 52
\barNumberCheck #53 e''1) | % m. 53; MIDI bar 53
\barNumberCheck #54 f''2( d''4 g'4) | % m. 54; MIDI bar 54
\barNumberCheck #55 \tuplet 3/2 4 { c''8 c'8 c'8 c'8 c'8 c'8 } \tuplet 6/4 { c'2.:8 } | % m. 55; MIDI bar 55
\barNumberCheck #56 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { c'2.:8 } | % m. 56; MIDI bar 56
\barNumberCheck #57 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { c'2.:8 } | % m. 57; MIDI bar 57
\barNumberCheck #58 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { c'2.:8 } | % m. 58; MIDI bar 58
\barNumberCheck #59 \tuplet 6/4 { c'2.:8\ppp } c'2\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
hornTwoII = {
\barNumberCheck #1 c'2...\ff^\markup \italic "Soli" c'16 | % m. 1; MIDI bar 1
\barNumberCheck #2 c'1(->\>~ | % m. 2; MIDI bar 2
\barNumberCheck #3 c'2\pp g2 | % m. 3; MIDI bar 3
\barNumberCheck #4 c2.) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g2( c'4) g'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 g'4 fis'4( g'4) r4 | % m. 6; MIDI bar 6
\barNumberCheck #7  R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 r2 c''2\sf | % m. 8; MIDI bar 8
\barNumberCheck #9 c''2(\pp g'2) | % m. 9; MIDI bar 9
\barNumberCheck #10 g'2(-> c'4) r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 d''2:8\f e''8\< d''8 d''8 c''8 | % m. 23; MIDI bar 23
\barNumberCheck #24 d''2(\!-> g'4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 r2 r4 r8. g'16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 fis'2( g'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 e'2\pp( f'2 | % m. 27; MIDI bar 27
\barNumberCheck #28 g'2 aes'2 | % m. 28; MIDI bar 28
\barNumberCheck #29 aes'1 | % m. 29; MIDI bar 29
\barNumberCheck #30 g'2.) r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 r2  f'4\(\pp^\markup \italic "Solo" \grace { g'16( f'16 e'16 } f'8.\)) g'16 | % m. 32; MIDI bar 32
\barNumberCheck #33 \after 4*960/480 \< aes'1~ | % m. 33; MIDI bar 33
\barNumberCheck #34 aes'2 g'2->\f | % m. 34; MIDI bar 34
\barNumberCheck #35 aes'2( ees'2 | % m. 35; MIDI bar 35
\barNumberCheck #36 c'2 aes'2) | % m. 36; MIDI bar 36
\barNumberCheck #37 g'2( aes'2 | % m. 37; MIDI bar 37
\barNumberCheck #38 g'4 f'4 g'4) r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 aes'2\f f'2 | % m. 39; MIDI bar 39
\barNumberCheck #40 g'1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 g1->\ff | % m. 42; MIDI bar 42
\barNumberCheck #43 g'2 \tuplet 6/4 { g'2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 c'4.\f r8 r4 c'4 | % m. 45; MIDI bar 45
\barNumberCheck #46 c''1\f | % m. 46; MIDI bar 46
\barNumberCheck #47 \tuplet 3/2 4 { e'8\pp[ e'8 e'8] e'8[ e'8 e'8] e'8[ e'8 e'8] e'8[ e'8 e'8] } | % m. 47; MIDI bar 47
\barNumberCheck #48 c'2\ff \tuplet 3/2 4 { c''8[ c''8 c''8] c''8[ c''8 c''8] } | % m. 48; MIDI bar 48
\barNumberCheck #49 \tuplet 3/2 4 { g8\p^\markup \italic "Soli" c'8 e'8 g'8 c''8 e''8 } g''2 | % m. 49; MIDI bar 49
\barNumberCheck #50 g2( aes4.-> g8 | % m. 50; MIDI bar 50
\barNumberCheck #51 fis2 g2) | % m. 51; MIDI bar 51
\barNumberCheck #52 c2\pp r2 | % m. 52; MIDI bar 52
\barNumberCheck #53 r2 g'2( | % m. 53; MIDI bar 53
\barNumberCheck #54 f'2 g'4 g4) | % m. 54; MIDI bar 54
\barNumberCheck #55 \tuplet 3/2 4 { c'8 c8 c8 c8 c8 c8 } \tuplet 6/4 { c2.:8 } | % m. 55; MIDI bar 55
\barNumberCheck #56 \tuplet 6/4 { c2.:8 } \tuplet 6/4 { c2.:8 } | % m. 56; MIDI bar 56
\barNumberCheck #57 \tuplet 6/4 { c2.:8 } \tuplet 6/4 { c2.:8 } | % m. 57; MIDI bar 57
\barNumberCheck #58 \tuplet 6/4 { c2.:8 } \tuplet 6/4 { c2.:8 } | % m. 58; MIDI bar 58
\barNumberCheck #59 \tuplet 6/4 { c2.:8\ppp } c2\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
trumpetOneII = {
\barNumberCheck #1 R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 R1 | % m. 28; MIDI bar 28
\barNumberCheck #29 R1 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 R1 | % m. 34; MIDI bar 34
\barNumberCheck #35 R1 | % m. 35; MIDI bar 35
\barNumberCheck #36 R1 | % m. 36; MIDI bar 36
\barNumberCheck #37 R1 | % m. 37; MIDI bar 37
\barNumberCheck #38 R1 | % m. 38; MIDI bar 38
\barNumberCheck #39 R1 | % m. 39; MIDI bar 39
\barNumberCheck #40 R1 | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 R1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 R1 | % m. 45; MIDI bar 45
\barNumberCheck #46 R1 | % m. 46; MIDI bar 46
\barNumberCheck #47 \tuplet 3/2 4 { g8\pp^\markup \italic "Solo" c'8 e'8 g'8 c''8 e''8 } g''2 | % m. 47; MIDI bar 47
\barNumberCheck #48 c''2\f \tuplet 3/2 4 { c''8\ff[ c''8 c''8] c''8[ c''8 c''8] } | % m. 48; MIDI bar 48
\barNumberCheck #49 g'1\pp | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52  g'1\pp  | % m. 52; MIDI bar 52
\barNumberCheck #53 c''1(~ | % m. 53; MIDI bar 53
\barNumberCheck #54 c''2 d''2) | % m. 54; MIDI bar 54
\barNumberCheck #55 g'1~ | % m. 55; MIDI bar 55
\barNumberCheck #56 g'2 r2 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 g'1\ppp\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
trumpetTwoII = {
\barNumberCheck #1 R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 R1 | % m. 28; MIDI bar 28
\barNumberCheck #29 R1 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 R1 | % m. 34; MIDI bar 34
\barNumberCheck #35 R1 | % m. 35; MIDI bar 35
\barNumberCheck #36 R1 | % m. 36; MIDI bar 36
\barNumberCheck #37 R1 | % m. 37; MIDI bar 37
\barNumberCheck #38 R1 | % m. 38; MIDI bar 38
\barNumberCheck #39 R1 | % m. 39; MIDI bar 39
\barNumberCheck #40 R1 | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 R1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 R1 | % m. 45; MIDI bar 45
\barNumberCheck #46 R1 | % m. 46; MIDI bar 46
\barNumberCheck #47 \tuplet 3/2 4 { g8\pp c'8 e'8 g'8 c'8 e'8 } g'2 | % m. 47; MIDI bar 47
\barNumberCheck #48 c'2\f \tuplet 3/2 4 { c'8\ff[ c'8 c'8] c'8[ c'8 c'8] } | % m. 48; MIDI bar 48
\barNumberCheck #49 g1\pp | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52  g'1\pp~  | % m. 52; MIDI bar 52
\barNumberCheck #53 g'1 | % m. 53; MIDI bar 53
\barNumberCheck #54 c'2 r2 | % m. 54; MIDI bar 54
\barNumberCheck #55  R1 | % m. 55; MIDI bar 55
\barNumberCheck #56  R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 g1\ppp\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
timpaniII = {
\barNumberCheck #1 R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 R1 | % m. 22; MIDI bar 22
\barNumberCheck #23 R1 | % m. 23; MIDI bar 23
\barNumberCheck #24 R1 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 R1 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 R1 | % m. 28; MIDI bar 28
\barNumberCheck #29 R1 | % m. 29; MIDI bar 29
\barNumberCheck #30 R1 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 R1 | % m. 34; MIDI bar 34
\barNumberCheck #35 R1 | % m. 35; MIDI bar 35
\barNumberCheck #36 R1 | % m. 36; MIDI bar 36
\barNumberCheck #37 R1 | % m. 37; MIDI bar 37
\barNumberCheck #38 R1 | % m. 38; MIDI bar 38
\barNumberCheck #39 R1 | % m. 39; MIDI bar 39
\barNumberCheck #40 R1 | % m. 40; MIDI bar 40
\barNumberCheck #41 R1 | % m. 41; MIDI bar 41
\barNumberCheck #42 R1 | % m. 42; MIDI bar 42
\barNumberCheck #43 R1 | % m. 43; MIDI bar 43
\barNumberCheck #44 R1 | % m. 44; MIDI bar 44
\barNumberCheck #45 R1 | % m. 45; MIDI bar 45
\barNumberCheck #46 R1 | % m. 46; MIDI bar 46
\barNumberCheck #47 R1 | % m. 47; MIDI bar 47
\barNumberCheck #48 R1 | % m. 48; MIDI bar 48
\barNumberCheck #49 R1 | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 R1 | % m. 52; MIDI bar 52
\barNumberCheck #53 R1 | % m. 53; MIDI bar 53
\barNumberCheck #54 R1 | % m. 54; MIDI bar 54
\barNumberCheck #55 R1 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
violinOneII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 \tuplet 6/4 { a8(\pp c'8 f'8 a'8 f'8 c'8 } \tuplet 6/4 { bes8 c'8 e'8 g'8 e'8 c'8) } | % m. 11; MIDI bar 11
\barNumberCheck #12 \tuplet 6/4 { a8( c'8 f'8 a'8 f'8 c'8) } \tuplet 6/4 { a8( c'8 f'8 a'8 f'8 c'8) } | % m. 12; MIDI bar 12
\barNumberCheck #13 \tuplet 6/4 { bes8( c'8 e'8 g'8 e'8 c'8) } \tuplet 6/4 { a8( c'8 f'8 a'8 f'8 c'8) } | % m. 13; MIDI bar 13
\barNumberCheck #14 \tuplet 6/4 { g8( c'8 e'8 b8 d'8 f'8) } e'4 r4 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 \tuplet 6/4 { bes8( c'8 e'8 g'8 e'8 c'8) } \tuplet 6/4 { bes8( c'8 e'8 g'8 e'8 c'8) } | % m. 16; MIDI bar 16
\barNumberCheck #17 \tuplet 6/4 { bes8( c'8 e'8 g'8 e'8 c'8) } \tuplet 6/4 { bes8( c'8 e'8 g'8 e'8 c'8) } | % m. 17; MIDI bar 17
\barNumberCheck #18 \tuplet 6/4 { a8( c'8 f'8 a'8 f'8 c'8) } \tuplet 6/4 { aes8( c'8 f'8 aes'8 f'8 c'8) } | % m. 18; MIDI bar 18
\barNumberCheck #19 \tuplet 6/4 { bes8( des'8 f'8 g'8 f'8 des'8) } \tuplet 6/4 { c'8( e'8 g'8 e'8 c'8 bes8) } | % m. 19; MIDI bar 19
\barNumberCheck #20 \tuplet 6/4 { a8( c'8 e'8 f'8 c'8 a'8) } f'4 r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 e'8(\p-. e'8-. e'8-. e'8-.) e'2:8 | % m. 21; MIDI bar 21
\barNumberCheck #22 f'2:8 f'2:8 | % m. 22; MIDI bar 22
\barNumberCheck #23 g4\f\< g''8.( a''32 g''32 fis''8 f''8 e''8 d''8) | % m. 23; MIDI bar 23
\barNumberCheck #24 d''4.(\!-> dis''8 e''4) \after 4*240/480 \p r8. c''16 | % m. 24; MIDI bar 24
\barNumberCheck #25 f''2->( e''8) r8 r8. c''16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 aes''2(-> g''8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 fis'2:8\pp g'2:8 | % m. 27; MIDI bar 27
\barNumberCheck #28 a'2:8 bes'2:8 | % m. 28; MIDI bar 28
\barNumberCheck #29 g'2:8 bes'2:8 | % m. 29; MIDI bar 29
\barNumberCheck #30 a'2.:8\pp r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 \tuplet 3/2 { r8 ees'8\p ees'8\< } \tuplet 3/2 { ees'8 ees'8 ees'8 } \tuplet 3/2 4 { ees'8\f-> ees'8 ees'8 ees'8 ees'8 ees'8 } | % m. 34; MIDI bar 34
\barNumberCheck #35 f''2\(\f \grace { des''16( ees''16 f''16 } ees''8.[) des''16 ees''8. f''16]\) | % m. 35; MIDI bar 35
\barNumberCheck #36 des''4( \grace { ees''16 des''16 c''16 } \tuplet 3/2 { des''8 ees''8 f''8 }) aes'4 \tuplet 6/4 { aes'16(-. bes'16-. c''16-. des''16-. ees''16-. f''16-.) } | % m. 36; MIDI bar 36
\barNumberCheck #37 ges''2-> f''8.( ges''32 f''32 ees''8 des''8) | % m. 37; MIDI bar 37
\barNumberCheck #38 c''8( ees''16) r16 bes'8( ees''16) r16 aes'8.\(( a'16) bes'32 b'32 c''32 des''32 \tuplet 3/2 { d''16 ees''16 e''16 }\) | % m. 38; MIDI bar 38
\barNumberCheck #39 f''2->\f \grace { f''8( } e''8.[) dis''16 e''8. g''16] | % m. 39; MIDI bar 39
\barNumberCheck #40 f''1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 fis''4.(->\fp ees''8 d''8\< c''8) f''8-.( fis''8-.) | % m. 41; MIDI bar 41
\barNumberCheck #42 g''4.(\f ees''8) c''4 r4 | % m. 42; MIDI bar 42
\barNumberCheck #43 \tuplet 3/2 4 { r8\ff ees'''8-. c'''8-. a''8-. fis''8-. ees''8-. c'''8-. a''8-. fis''8-. ees''8-. c''8-. a'8-. } | % m. 43; MIDI bar 43
\barNumberCheck #44 \tuplet 6/4 { bes'2.:8\pp } \tuplet 6/4 { bes'2.:8 } | % m. 44; MIDI bar 44
\barNumberCheck #45 \tuplet 6/4 { b'2.:8\f } \tuplet 6/4 { d''2.:8 } | % m. 45; MIDI bar 45
\barNumberCheck #46 \override TupletNumber.avoid-slur = #'ignore \override TupletNumber.extra-offset = #'(0 . 1.2) \tuplet 3/2 4 { aes'8\ff f''8( ees''8 d''8 c''8 bes'8) } \tuplet 3/2 { c''8( bes'8 a'8) } aes'4-> \revert TupletNumber.avoid-slur \revert TupletNumber.extra-offset | % m. 46; MIDI bar 46
\barNumberCheck #47 a'2.(\pp d''4) | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 3/2 4 { b'8-.\ff d''8-. f''8-. aes''8-. b''8-. d'''8-. } f'''2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 a'2\pp \tuplet 6/4 { a'2.:8 } | % m. 49; MIDI bar 49
\barNumberCheck #50 \tuplet 6/4 { g'2.:8 } \tuplet 6/4 { g'2.:8 } | % m. 50; MIDI bar 50
\barNumberCheck #51 \tuplet 6/4 { g'2.:8 } \tuplet 6/4 { g'2.:8 } | % m. 51; MIDI bar 51
\barNumberCheck #52 \tuplet 6/4 { f'8\pp( c'8 f'8 a'8 f'8 c'8) } \tuplet 6/4 { a8( cis'8 e'8 g'8 e'8 cis'8) } | % m. 52; MIDI bar 52
\barNumberCheck #53 \tuplet 6/4 { a8( d'8 f'8 a'8 f'8 d'8) } \tuplet 6/4 { a8( d'8 fis'8 a'8 fis'8 d'8) } | % m. 53; MIDI bar 53
\barNumberCheck #54 g'1_\markup \italic "dim." | % m. 54; MIDI bar 54
\barNumberCheck #55 f'4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
violinTwoII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 c'1\pp~ | % m. 11; MIDI bar 11
\barNumberCheck #12 c'1~ | % m. 12; MIDI bar 12
\barNumberCheck #13 c'1~ | % m. 13; MIDI bar 13
\barNumberCheck #14 c'4 f'8(-> b8) c'4 r4 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 bes'1~ | % m. 16; MIDI bar 16
\barNumberCheck #17 bes'2 c'2~ | % m. 17; MIDI bar 17
\barNumberCheck #18 c'1 | % m. 18; MIDI bar 18
\barNumberCheck #19 des'2-> c'2~ | % m. 19; MIDI bar 19
\barNumberCheck #20 c'2 a4 r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 g2:8\p g2:8 | % m. 21; MIDI bar 21
\barNumberCheck #22 a2:8 a2:8 | % m. 22; MIDI bar 22
\barNumberCheck #23 b8\f\< b8 b'8 b'8 c''8 d''8 c''8 b'8 | % m. 23; MIDI bar 23
\barNumberCheck #24 b'2(\!-> c''4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 c''2\p->~ c''8 r8 r8. c''16\ff | % m. 25; MIDI bar 25
\barNumberCheck #26 b'2(-> c''8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 ees'2:8\pp d'2:8 | % m. 27; MIDI bar 27
\barNumberCheck #28 ges'2:8 f'2:8 | % m. 28; MIDI bar 28
\barNumberCheck #29 e'2:8 f'2:8 | % m. 29; MIDI bar 29
\barNumberCheck #30 c'2.:8\pp r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 \tuplet 3/2 { r8 des'8\p des'8\< } \tuplet 3/2 { des'8 des'8 des'8 } \tuplet 3/2 4 { c'8\f c'8 c'8 c'8 c'8 c'8 } | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { aes'8[ aes'8 aes'8] aes'8[ aes'8 aes'8] ges'8[ ges'8 ges'8] ges'8[ ges'8 ges'8] } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 6/4 { f'2.:8 } \tuplet 6/4 { f'2.:8 } | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { ees'2.:8 } \tuplet 6/4 { f'2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { ees'8 ees'8 ees'8 des'8 des'8 des'8 } c'4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { des''2.:8\f } \tuplet 6/4 { des''2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 c''1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 \tuplet 6/4 { ees'2.:8\fp } \tuplet 6/4 { ees'2.:8 } | % m. 41; MIDI bar 41
\barNumberCheck #42 \tuplet 6/4 { ees'2.:8\f } \tuplet 6/4 { ees'2.:8 } | % m. 42; MIDI bar 42
\barNumberCheck #43 \tuplet 3/2 4 { r8\ff ees''8-. c''8-. a'8-. fis'8-. ees'8-. c''8-. a'8-. fis'8-. ees'8-. c'8-. a8-. } | % m. 43; MIDI bar 43
\barNumberCheck #44 \tuplet 6/4 { bes2.:8\pp } \tuplet 6/4 { bes2.:8 } | % m. 44; MIDI bar 44
\barNumberCheck #45 \tuplet 6/4 { aes'2.:8\f } \tuplet 6/4 { aes'2.:8 } | % m. 45; MIDI bar 45
\barNumberCheck #46 \tuplet 6/4 { aes'2.:8\ff } \tuplet 3/2 4 { f'8 f'8 f'8 f'8( e'8 d'8) } | % m. 46; MIDI bar 46
\barNumberCheck #47 d'2.(\pp a'4) | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 6/4 { aes'2.:8\ff } aes'2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 f'2\pp \tuplet 6/4 { f'2.:8 } | % m. 49; MIDI bar 49
\barNumberCheck #50 \tuplet 6/4 { f'2.:8 } \tuplet 6/4 { f'2.:8 } | % m. 50; MIDI bar 50
\barNumberCheck #51 \tuplet 6/4 { f'2.:8 } \tuplet 6/4 { e'2.:8 } | % m. 51; MIDI bar 51
\barNumberCheck #52 c'2(\pp e'2 | % m. 52; MIDI bar 52
\barNumberCheck #53 f'2) d'2 | % m. 53; MIDI bar 53
\barNumberCheck #54 d'2(_\markup \italic "dim." e'2) | % m. 54; MIDI bar 54
\barNumberCheck #55 c'4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
violaII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2  R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 c'2(\pp bes2 | % m. 3; MIDI bar 3
\barNumberCheck #4 a2.) r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 bes2( a4 c'4) | % m. 5; MIDI bar 5
\barNumberCheck #6 c'8( g16) r16 b8( g16) r16 g4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 c'1 | % m. 7; MIDI bar 7
\barNumberCheck #8 b2. d'4-> | % m. 8; MIDI bar 8
\barNumberCheck #9 f'4 r4 r2 | % m. 9; MIDI bar 9
\barNumberCheck #10 g'2-> f'4 r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 \oneVoice R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 c'2:8\pp c'2:8 | % m. 21; MIDI bar 21
\barNumberCheck #22 c'2:8 c'2:8 | % m. 22; MIDI bar 22
\barNumberCheck #23 f'8\f\< f'8 d'8 d'8 d'8 d'8 e'8 f'8 | % m. 23; MIDI bar 23
\barNumberCheck #24 f'2(\!-> e'4) \after 4*240/480 \p r8. c'16 | % m. 24; MIDI bar 24
\barNumberCheck #25 a'2->( g'8) r8 r8. c'16 | % m. 25; MIDI bar 25
\barNumberCheck #26 d'2(\ff-> ees'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 c'2:8\pp bes2:8 | % m. 27; MIDI bar 27
\barNumberCheck #28 ees'2:8 des'2:8 | % m. 28; MIDI bar 28
\barNumberCheck #29 des'2:8 des'2:8 | % m. 29; MIDI bar 29
\barNumberCheck #30 c'8\pp a8 a8 a8 e8(-> f16)-. r16 r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 r2 \tuplet 3/2 4 { ges'8\f ges'8 ges'8 ges'8 ges'8 ges'8 } | % m. 34; MIDI bar 34
\barNumberCheck #35 \tuplet 3/2 4 { f'8\f des'8 des'8 aes8 aes8 aes8 } \tuplet 3/2 4 { c'8 c'8 c'8 c'8 c'8 c'8 } | % m. 35; MIDI bar 35
\barNumberCheck #36 \tuplet 6/4 { aes2.:8 } \tuplet 6/4 { aes2.:8 } | % m. 36; MIDI bar 36
\barNumberCheck #37 \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { des'2.:8 } | % m. 37; MIDI bar 37
\barNumberCheck #38 \tuplet 3/2 4 { c'8 c'8 c'8 g8 g8 g8 } ees4 r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 \tuplet 6/4 { aes'2.:8\f } \tuplet 6/4 { bes'2.:8 } | % m. 39; MIDI bar 39
\barNumberCheck #40 aes'1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 \tuplet 6/4 { c'2.:8\fp } \tuplet 6/4 { c'2.:8 } | % m. 41; MIDI bar 41
\barNumberCheck #42 \tuplet 6/4 { c'2.:8\f } \tuplet 6/4 { c'2.:8 } | % m. 42; MIDI bar 42
\barNumberCheck #43 \tuplet 6/4 { a2.:8\ff } \tuplet 6/4 { ees'2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 \tuplet 6/4 { ees'2.:8\pp } \tuplet 6/4 { ees'2.:8 } | % m. 44; MIDI bar 44
\barNumberCheck #45 \tuplet 6/4 { d'2.:8\f } \tuplet 6/4 { f'2.:8 } | % m. 45; MIDI bar 45
\barNumberCheck #46 \override TupletNumber.avoid-slur = #'ignore \override TupletNumber.extra-offset = #'(0 . 1.2) \tuplet 6/4 { d'2.:8\ff } \tuplet 3/2 4 { d'8 d'8 d'8 d'8( e'8 f'8) } \revert TupletNumber.avoid-slur \revert TupletNumber.extra-offset | % m. 46; MIDI bar 46
\barNumberCheck #47 fis'2.\pp fis'4 | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 6/4 { d'2.:8\ff } d'2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c'1\pp | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 a2(\pp cis'2 | % m. 52; MIDI bar 52
\barNumberCheck #53 a2 a2) | % m. 53; MIDI bar 53
\barNumberCheck #54 bes1 | % m. 54; MIDI bar 54
\barNumberCheck #55 a4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 <a c'>1(\pp^\markup \italic "Soli" | % m. 56; MIDI bar 56
\barNumberCheck #57 <bes d'>2)-> r2 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
celloII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 f'2\p c'2 | % m. 11; MIDI bar 11
\barNumberCheck #12 f1( | % m. 12; MIDI bar 12
\barNumberCheck #13 c2 f2) | % m. 13; MIDI bar 13
\barNumberCheck #14 g8 r8 g8 r8 c4 r4 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 c1~ | % m. 16; MIDI bar 16
\barNumberCheck #17 c1 | % m. 17; MIDI bar 17
\barNumberCheck #18 f1 | % m. 18; MIDI bar 18
\barNumberCheck #19 bes,2 c2 | % m. 19; MIDI bar 19
\barNumberCheck #20 f,2. r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 r4 f'8.\f( g'32 f'32 e'8 d'8 c'8 b8) | % m. 22; MIDI bar 22
\barNumberCheck #23 a8\f\< g8 g8 g8 a8 b8 c'8 d'8 | % m. 23; MIDI bar 23
\barNumberCheck #24 g,2(\!-> c,4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 f'2(\ff-> ees'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 a2:8\pp bes2:8 | % m. 27; MIDI bar 27
\barNumberCheck #28 c'2:8 des'2:8 | % m. 28; MIDI bar 28
\barNumberCheck #29 des'2:8 des'2:8 | % m. 29; MIDI bar 29
\barNumberCheck #30 c'8-.( c'8-.) r4 e,8(-> f,16)-. r16 r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 r2 \tuplet 3/2 4 { aes,8\f aes,8 aes,8 aes,8 aes,8 aes,8 } | % m. 34; MIDI bar 34
\barNumberCheck #35  des2(\f aes,2 | % m. 35; MIDI bar 35
\barNumberCheck #36 des,1 | % m. 36; MIDI bar 36
\barNumberCheck #37 aes,2 des4 des,4 | % m. 37; MIDI bar 37
\barNumberCheck #38 ees,2 aes,4) r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 des2\f g,2 | % m. 39; MIDI bar 39
\barNumberCheck #40 aes,1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 aes,1\fp | % m. 41; MIDI bar 41
\barNumberCheck #42 \tuplet 6/4 { g,2.:8\f } \tuplet 6/4 { g,2.:8 } | % m. 42; MIDI bar 42
\barNumberCheck #43 \tuplet 6/4 { fis,2.:8\ff } \tuplet 6/4 { fis,2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 \tuplet 3/2 4 { g,8\p bes,8 ees8 g8 bes8 ees'8 } g'2-> | % m. 44; MIDI bar 44
\barNumberCheck #45 f'4\f f4~ \tuplet 3/2 { f8 f8( ees8 } \tuplet 3/2 { d8 c8 b,8) } | % m. 45; MIDI bar 45
\barNumberCheck #46 bes,4\ff bes,2-> bes,4 | % m. 46; MIDI bar 46
\barNumberCheck #47 a,1\pp | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 6/4 { b,2.:8\ff } b,2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c1\pp | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 f2(\pp e2 | % m. 52; MIDI bar 52
\barNumberCheck #53 \after 4*480/480 \< d2 c2) | % m. 53; MIDI bar 53
\barNumberCheck #54 bes,2(\! c4) c,4-. | % m. 54; MIDI bar 54
\barNumberCheck #55 f,4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
bassII = {
\barNumberCheck #1 \key f \major R1 | % m. 1; MIDI bar 1
\barNumberCheck #2 R1 | % m. 2; MIDI bar 2
\barNumberCheck #3 R1 | % m. 3; MIDI bar 3
\barNumberCheck #4 R1 | % m. 4; MIDI bar 4
\barNumberCheck #5 R1 | % m. 5; MIDI bar 5
\barNumberCheck #6 R1 | % m. 6; MIDI bar 6
\barNumberCheck #7 R1 | % m. 7; MIDI bar 7
\barNumberCheck #8 R1 | % m. 8; MIDI bar 8
\barNumberCheck #9 R1 | % m. 9; MIDI bar 9
\barNumberCheck #10 R1 | % m. 10; MIDI bar 10
\barNumberCheck #11 R1 | % m. 11; MIDI bar 11
\barNumberCheck #12 R1 | % m. 12; MIDI bar 12
\barNumberCheck #13 R1 | % m. 13; MIDI bar 13
\barNumberCheck #14 R1 | % m. 14; MIDI bar 14
\barNumberCheck #15 R1 | % m. 15; MIDI bar 15
\barNumberCheck #16 R1 | % m. 16; MIDI bar 16
\barNumberCheck #17 R1 | % m. 17; MIDI bar 17
\barNumberCheck #18 R1 | % m. 18; MIDI bar 18
\barNumberCheck #19 R1 | % m. 19; MIDI bar 19
\barNumberCheck #20 R1 | % m. 20; MIDI bar 20
\barNumberCheck #21 R1 | % m. 21; MIDI bar 21
\barNumberCheck #22 f,4\f-> f2 f4 | % m. 22; MIDI bar 22
\barNumberCheck #23 g,8\f\< g,8 g8 g8 a8 b8 c'8 d'8 | % m. 23; MIDI bar 23
\barNumberCheck #24 g,2(\!-> c,4) r4 | % m. 24; MIDI bar 24
\barNumberCheck #25 R1 | % m. 25; MIDI bar 25
\barNumberCheck #26 f'2(\ff-> ees'8) r8 r4 | % m. 26; MIDI bar 26
\barNumberCheck #27 R1 | % m. 27; MIDI bar 27
\barNumberCheck #28 R1 | % m. 28; MIDI bar 28
\barNumberCheck #29 R1 | % m. 29; MIDI bar 29
\barNumberCheck #30 r2 e,8\pp(-> f,16)-. r16 r4 | % m. 30; MIDI bar 30
\barNumberCheck #31 R1\fermata | % m. 31; MIDI bar 31
\barNumberCheck #32 R1 | % m. 32; MIDI bar 32
\barNumberCheck #33 R1 | % m. 33; MIDI bar 33
\barNumberCheck #34 r2 \tuplet 3/2 4 { aes,8\f aes,8 aes,8 aes,8 aes,8 aes,8 } | % m. 34; MIDI bar 34
\barNumberCheck #35  des2(\f aes,2 | % m. 35; MIDI bar 35
\barNumberCheck #36 des,1 | % m. 36; MIDI bar 36
\barNumberCheck #37 aes,2 des4 des,4 | % m. 37; MIDI bar 37
\barNumberCheck #38 ees,2 aes,4) r4 | % m. 38; MIDI bar 38
\barNumberCheck #39 des2\f g,2 | % m. 39; MIDI bar 39
\barNumberCheck #40 aes,1\fp | % m. 40; MIDI bar 40
\barNumberCheck #41 aes,1\fp | % m. 41; MIDI bar 41
\barNumberCheck #42 \tuplet 6/4 { g,2.:8\f } \tuplet 6/4 { g,2.:8 } | % m. 42; MIDI bar 42
\barNumberCheck #43 \tuplet 6/4 { fis,2.:8\ff } \tuplet 6/4 { fis,2.:8 } | % m. 43; MIDI bar 43
\barNumberCheck #44 g,4\p r4 r2 | % m. 44; MIDI bar 44
\barNumberCheck #45 r4 f4\f~ \tuplet 3/2 { f8 f8( ees8 } \tuplet 3/2 { d8 c8 b,8) } | % m. 45; MIDI bar 45
\barNumberCheck #46 bes,4\ff bes,2-> bes,4 | % m. 46; MIDI bar 46
\barNumberCheck #47 a,1\pp | % m. 47; MIDI bar 47
\barNumberCheck #48 \tuplet 6/4 { b,2.:8\ff } b,2-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c1\pp | % m. 49; MIDI bar 49
\barNumberCheck #50 R1 | % m. 50; MIDI bar 50
\barNumberCheck #51 R1 | % m. 51; MIDI bar 51
\barNumberCheck #52 f2(\pp e2 | % m. 52; MIDI bar 52
\barNumberCheck #53 \after 4*480/480 \< d2 c2) | % m. 53; MIDI bar 53
\barNumberCheck #54 bes,2(\! c4) c,4-. | % m. 54; MIDI bar 54
\barNumberCheck #55 f,4 r4 r2 | % m. 55; MIDI bar 55
\barNumberCheck #56 R1 | % m. 56; MIDI bar 56
\barNumberCheck #57 R1 | % m. 57; MIDI bar 57
\barNumberCheck #58 R1 | % m. 58; MIDI bar 58
\barNumberCheck #59 R1\fermata | % m. 59; MIDI bar 59
\barNumberCheck #60
}
fluteIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 c'''2\ff-> c'''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c'''2-> c'''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 bes''2-> a''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 g''4-. g'4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes''2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 g''2. | % m. 10; MIDI bar 18
\barNumberCheck #11 f''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 f''2 d''4 | % m. 12; MIDI bar 20
\barNumberCheck #13 c''4 c'''2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 c'''2-> c'''4 | % m. 14; MIDI bar 22
\barNumberCheck #15 c'''2-> b''4 | % m. 15; MIDI bar 23
\barNumberCheck #16 c'''4-. c''4-. r4  | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 R2. | % m. 33; MIDI bar 59
\barNumberCheck #34 R2. | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
oboeOneIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 g''2\ff-> g''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 aes''2-> a''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 bes''2-> a''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 g''4-. g'4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes''2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 g''2. | % m. 10; MIDI bar 18
\barNumberCheck #11 f''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 f''2 d''4 | % m. 12; MIDI bar 20
\barNumberCheck #13 c''4 g''2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 aes''2-> a''4 | % m. 14; MIDI bar 22
\barNumberCheck #15 g''4( fis''4) g''4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 g''4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major g'4(-\tweak stencil #weber-p-dolce -\tweak self-alignment-X #weber-p-dolce-alignment \p^\markup \italic "Solo" e''4 b'4 | % m. 17; MIDI bar 33
\barNumberCheck #18 c''2.) | % m. 18; MIDI bar 34
\barNumberCheck #19 f''4( cis''4 d''4 | % m. 19; MIDI bar 35
\barNumberCheck #20 ais'4-> b'4 g'4)~ | % m. 20; MIDI bar 36
\barNumberCheck #21 g'4 c''4-. e''4-. | % m. 21; MIDI bar 37
\barNumberCheck #22 g''2.->~ | % m. 22; MIDI bar 38
\barNumberCheck #23 g''4( fis''4 f''4 | % m. 23; MIDI bar 39
\barNumberCheck #24 d''4)-. e''4(-> c''4) | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 g'4(\mf^\markup \italic "Solo" c''4 e''4) | % m. 31; MIDI bar 57
\barNumberCheck #32 g''2.~ | % m. 32; MIDI bar 58
\barNumberCheck #33 g''4( fis''4 f''4 | % m. 33; MIDI bar 59
\barNumberCheck #34 d''4-.) e''4->( c''4) | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
oboeTwoIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 g'2\ff-> g'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 aes'2-> ees''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g''2-> fis''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 g''4-. g'4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 aes'2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 ees'2. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes'2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 aes'2 aes'4 | % m. 12; MIDI bar 20
\barNumberCheck #13 g'4 g'2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 aes'2-> a'4 | % m. 14; MIDI bar 22
\barNumberCheck #15 g'4( fis'4) g'4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 ees'4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major R2. | % m. 17; MIDI bar 33
\barNumberCheck #18  R2. | % m. 18; MIDI bar 34
\barNumberCheck #19  R2. | % m. 19; MIDI bar 35
\barNumberCheck #20  R2. | % m. 20; MIDI bar 36
\barNumberCheck #21  R2. | % m. 21; MIDI bar 37
\barNumberCheck #22  R2. | % m. 22; MIDI bar 38
\barNumberCheck #23  R2. | % m. 23; MIDI bar 39
\barNumberCheck #24  R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31  R2. | % m. 31; MIDI bar 57
\barNumberCheck #32  R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 b'2.\p-> | % m. 33; MIDI bar 59
\barNumberCheck #34 b'4 g'2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
bassoonOneIII = {
\barNumberCheck #1 \key c \minor c'2.(\pp^\markup \italic "Soli" | % m. 1; MIDI bar 1
\barNumberCheck #2 f'2.\< | % m. 2; MIDI bar 2
\barNumberCheck #3 ees'4 d'4 c'4) | % m. 3; MIDI bar 3
\barNumberCheck #4 b4-.\! b4-. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 ees4-.\ff-> e4-. | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 f4-.-> fis4-. | % m. 6; MIDI bar 6
\barNumberCheck #7 g4-. bes4-. d'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g4-. g,4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes,4-.\ff c4-. d4-. | % m. 9; MIDI bar 17
\barNumberCheck #10 ees4-. f4-. g4-. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes4-. bes4-. c'4-. | % m. 11; MIDI bar 19
\barNumberCheck #12 d'4-. ees'4-. f'4-. | % m. 12; MIDI bar 20
\barNumberCheck #13 ees'4-. ees4-.-> e4-. | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 f4-.-> fis4-. | % m. 14; MIDI bar 22
\barNumberCheck #15 g4(-> aes4) g4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 ees4-. c4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 f'2.\p-> | % m. 33; MIDI bar 59
\barNumberCheck #34 f'4-. e'4->( g'4) | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
bassoonTwoIII = {
\barNumberCheck #1 \key c \minor c2.(\pp^\markup \italic "Soli" | % m. 1; MIDI bar 1
\barNumberCheck #2 f2.\< | % m. 2; MIDI bar 2
\barNumberCheck #3 fis2.) | % m. 3; MIDI bar 3
\barNumberCheck #4 g4-.\! g,4-. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 ees,4-.\ff-> e,4-. | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 f,4->-. fis,4-. | % m. 6; MIDI bar 6
\barNumberCheck #7 g,4-. bes,4-. d4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g,4-. g,4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes,,4-.\ff c,4-. d,4-. | % m. 9; MIDI bar 17
\barNumberCheck #10 ees,4-. f,4-. g,4-. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes,4-. bes,4-. c4-. | % m. 11; MIDI bar 19
\barNumberCheck #12 d4-. ees4-. f4-. | % m. 12; MIDI bar 20
\barNumberCheck #13 ees4-. ees,4-.-> e,4-. | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 f,4-.-> fis,4-. | % m. 14; MIDI bar 22
\barNumberCheck #15 g,4( aes,4) g,4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c4-. c,4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 b2.\p-> | % m. 33; MIDI bar 59
\barNumberCheck #34 b4-. c'2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
hornOneIII = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 c''4\ff r4 | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 c''4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 r4 d''4-. d''4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g''4-. g'4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 f''2.\ff | % m. 9; MIDI bar 17
\barNumberCheck #10 g''2. | % m. 10; MIDI bar 18
\barNumberCheck #11 f''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 f''2 d''4 | % m. 12; MIDI bar 20
\barNumberCheck #13 r4 c''4 r4 | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 c''4 r4 | % m. 14; MIDI bar 22
\barNumberCheck #15 r4 d''4-. d''4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c''4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 g''4(\mf^\markup \italic "Soli" e''4 c''4) | % m. 31; MIDI bar 57
\barNumberCheck #32 g'2.~ | % m. 32; MIDI bar 58
\barNumberCheck #33 g'2. | % m. 33; MIDI bar 59
\barNumberCheck #34 d''4-. e''4->( c''4) | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
hornTwoIII = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 c'4\ff r4 | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 c'4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 r4 d''4-. d''4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g'4-. g4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes'2.\ff~ | % m. 9; MIDI bar 17
\barNumberCheck #10 bes'2.~ | % m. 10; MIDI bar 18
\barNumberCheck #11 bes'2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 bes'2 r4 | % m. 12; MIDI bar 20
\barNumberCheck #13 r4 c'4 r4 | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 c'4 r4 | % m. 14; MIDI bar 22
\barNumberCheck #15 r4 d''4-. d''4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c''4-. c4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 g'4(\mf^\markup \italic "Soli" e'4 c'4) | % m. 31; MIDI bar 57
\barNumberCheck #32 g2.~ | % m. 32; MIDI bar 58
\barNumberCheck #33 g2. | % m. 33; MIDI bar 59
\barNumberCheck #34 g4-. c2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
trumpetOneIII = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 c''4\ff r4 | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 c''4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 r4 g'4-. d''4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 d''4-. g'4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 d''2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 g''2. | % m. 10; MIDI bar 18
\barNumberCheck #11 d''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 d''2. | % m. 12; MIDI bar 20
\barNumberCheck #13 r4 c''4 r4 | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 c''4 r4 | % m. 14; MIDI bar 22
\barNumberCheck #15 r4 d''4-. d''4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c''4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 d''2.\p | % m. 33; MIDI bar 59
\barNumberCheck #34 g'4-. c''2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
trumpetTwoIII = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 c'4\ff r4 | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 c'4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 r4 g4-. d''4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g'4-. g4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 d''2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 g'2. | % m. 10; MIDI bar 18
\barNumberCheck #11 d''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 d''2. | % m. 12; MIDI bar 20
\barNumberCheck #13 r4 c'4 r4 | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 c'4 r4 | % m. 14; MIDI bar 22
\barNumberCheck #15 r4 d''4-. g'4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c'4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 g2.\p | % m. 33; MIDI bar 59
\barNumberCheck #34 g4-. c'2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
timpaniIII = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 c4\ff r4 | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 c4 r4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g,2:32 c4 | % m. 7; MIDI bar 7
\barNumberCheck #8 g,4 g,4 r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 R2. | % m. 9; MIDI bar 17
\barNumberCheck #10 g,2.:32\ff | % m. 10; MIDI bar 18
\barNumberCheck #11 R2. | % m. 11; MIDI bar 19
\barNumberCheck #12 R2. | % m. 12; MIDI bar 20
\barNumberCheck #13 r4 c4\ff r4 | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 c4 r4 | % m. 14; MIDI bar 22
\barNumberCheck #15 r4 c4 g,4 | % m. 15; MIDI bar 23
\barNumberCheck #16 c4 c4 r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 R2. | % m. 27; MIDI bar 53
\barNumberCheck #28 R2. | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 g,4\pp r4 r4 | % m. 33; MIDI bar 59
\barNumberCheck #34 g,4 c2 | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
violinOneIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 c'''2\ff-> c'''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c'''2-> c'''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 bes''2-> <c'' a''>4 | % m. 7; MIDI bar 7
\barNumberCheck #8 <bes' g''>4-. g4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes''2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 g''2. | % m. 10; MIDI bar 18
\barNumberCheck #11 f''2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 f''2 d''4 | % m. 12; MIDI bar 20
\barNumberCheck #13 c''4 c'''2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 c'''2-> c'''4 | % m. 14; MIDI bar 22
\barNumberCheck #15 c'''2-> b''4 | % m. 15; MIDI bar 23
\barNumberCheck #16 c'''4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major r4 <g e'>4\pp <g e'>4 | % m. 17; MIDI bar 33
\barNumberCheck #18 r4 <g e'>4 <g e'>4 | % m. 18; MIDI bar 34
\barNumberCheck #19 r4 <g f'>4 <g f'>4 | % m. 19; MIDI bar 35
\barNumberCheck #20 r4 <g f'>4 <g f'>4 | % m. 20; MIDI bar 36
\barNumberCheck #21 r4 <g e'>4 <g e'>4 | % m. 21; MIDI bar 37
\barNumberCheck #22 r4 <g e'>4 <g e'>4 | % m. 22; MIDI bar 38
\barNumberCheck #23 r4 <g f'>4 <g f'>4 | % m. 23; MIDI bar 39
\barNumberCheck #24 <g f'>4 <g e'>2-> | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 aes'4(\pp g'4 f'4 | % m. 27; MIDI bar 53
\barNumberCheck #28 ees'4 d'4 c'4 | % m. 28; MIDI bar 54
\barNumberCheck #29 b4 c'4 d'4) | % m. 29; MIDI bar 55
\barNumberCheck #30 ees'2->( d'4) | % m. 30; MIDI bar 56
\barNumberCheck #31 g4( c'4 e'4 | % m. 31; MIDI bar 57
\barNumberCheck #32 g'2.)~ | % m. 32; MIDI bar 58
\barNumberCheck #33 g'2. | % m. 33; MIDI bar 59
\barNumberCheck #34 f'4-. e'2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
violinTwoIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 <c'' g''>2\ff-> <c'' g''>4 | % m. 5; MIDI bar 5
\barNumberCheck #6 <c'' aes''>2-> a''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g''4-. d''4-. <a' fis''>4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 <bes' g''>4-. g4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 <aes' d''>2.\ff-> | % m. 9; MIDI bar 17
\barNumberCheck #10 <g' ees''>2. | % m. 10; MIDI bar 18
\barNumberCheck #11 <aes' d''>2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 <aes' d''>2 b'4 | % m. 12; MIDI bar 20
\barNumberCheck #13 c''4 <c'' g''>2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 <c'' aes''>2-> a''4 | % m. 14; MIDI bar 22
\barNumberCheck #15 g''4(-> fis''4) g''4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 ees''4-. c'4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major r4 c'4\pp c'4 | % m. 17; MIDI bar 33
\barNumberCheck #18 r4 c'4 c'4 | % m. 18; MIDI bar 34
\barNumberCheck #19 r4 b4 b4 | % m. 19; MIDI bar 35
\barNumberCheck #20 r4 b4 b4 | % m. 20; MIDI bar 36
\barNumberCheck #21 r4 c'4 c'4 | % m. 21; MIDI bar 37
\barNumberCheck #22 r4 c'4 c'4 | % m. 22; MIDI bar 38
\barNumberCheck #23 r4 b4 b4 | % m. 23; MIDI bar 39
\barNumberCheck #24 b4 c'2-> | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 b2.(\pp | % m. 27; MIDI bar 53
\barNumberCheck #28 c'4 aes4 g4 | % m. 28; MIDI bar 54
\barNumberCheck #29 aes4) g4 aes4~ | % m. 29; MIDI bar 55
\barNumberCheck #30 aes4 a4->( b4) | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 b2.~ | % m. 33; MIDI bar 59
\barNumberCheck #34 b4 g2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
violaIII = {
\barNumberCheck #1 \key c \minor << { es'2.(\p^\markup \italic "Soli" } \\ { g2.( } >> | % m. 1; MIDI bar 1
\barNumberCheck #2 << { d'2._\markup \italic "cresc." } \\ { aes2. } >> | % m. 2; MIDI bar 2
\barNumberCheck #3 << { c'4 d'4 es'4) } \\ { a2.) } >> | % m. 3; MIDI bar 3
\barNumberCheck #4 <g d'>4-.\! g4-. r4 | % m. 4; MIDI bar 4
\barNumberCheck #5 c'2\ff-> c'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c'2-> ees'4 | % m. 6; MIDI bar 6
\barNumberCheck #7 d'2-> d'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 d'4-. g4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 f'2.\ff | % m. 9; MIDI bar 17
\barNumberCheck #10 <bes g'>2. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes'2.~ | % m. 11; MIDI bar 19
\barNumberCheck #12 aes'2 aes'4 | % m. 12; MIDI bar 20
\barNumberCheck #13 g'4 c'2-> | % m. 13; MIDI bar 21
\barNumberCheck #14 c'2-> ees'4 | % m. 14; MIDI bar 22
\barNumberCheck #15 d'2-> d'4 | % m. 15; MIDI bar 23
\barNumberCheck #16 c'4-. c4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major g2.\pp~ | % m. 17; MIDI bar 33
\barNumberCheck #18 g2.~ | % m. 18; MIDI bar 34
\barNumberCheck #19 g2.~ | % m. 19; MIDI bar 35
\barNumberCheck #20 g2.~ | % m. 20; MIDI bar 36
\barNumberCheck #21 g2.~ | % m. 21; MIDI bar 37
\barNumberCheck #22 g2.~ | % m. 22; MIDI bar 38
\barNumberCheck #23 g2.~ | % m. 23; MIDI bar 39
\barNumberCheck #24 g4 c2-> | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 d'2.\pp | % m. 27; MIDI bar 53
\barNumberCheck #28 g4( b4 c'4) | % m. 28; MIDI bar 54
\barNumberCheck #29 R2. | % m. 29; MIDI bar 55
\barNumberCheck #30 R2. | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 f'2. | % m. 33; MIDI bar 59
\barNumberCheck #34 d'4-. c'2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
celloIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 ees4-.\ff-> e4-. | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 f4-.-> fis4-. | % m. 6; MIDI bar 6
\barNumberCheck #7 g4-. bes4-. d'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g4-. g,4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes,4-.\ff c4-. d4-. | % m. 9; MIDI bar 17
\barNumberCheck #10 ees4-. f4-. g4-. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes4-. bes4-. c'4-. | % m. 11; MIDI bar 19
\barNumberCheck #12 d'4-. ees'4-. f'4-. | % m. 12; MIDI bar 20
\barNumberCheck #13 ees'4-. ees4-.-> e4-. | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 f4-.-> fis4-. | % m. 14; MIDI bar 22
\barNumberCheck #15 g4(-> aes4) g4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c4-. c,4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major c4\pp^\markup \italic "pizz." r4 r4 | % m. 17; MIDI bar 33
\barNumberCheck #18 c4 r4 r4 | % m. 18; MIDI bar 34
\barNumberCheck #19 g4 r4 r4 | % m. 19; MIDI bar 35
\barNumberCheck #20 g,4 r4 r4 | % m. 20; MIDI bar 36
\barNumberCheck #21 c4 r4 r4 | % m. 21; MIDI bar 37
\barNumberCheck #22 c4 r4 r4 | % m. 22; MIDI bar 38
\barNumberCheck #23 g,4 r4 r4 | % m. 23; MIDI bar 39
\barNumberCheck #24 g,4^\markup \italic "arco" c,2-> | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 f4(\pp g4 aes4 | % m. 27; MIDI bar 53
\barNumberCheck #28 g4 f4 ees4) | % m. 28; MIDI bar 54
\barNumberCheck #29 d4( ees4 f4) | % m. 29; MIDI bar 55
\barNumberCheck #30 fis2->( g4) | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 g,2.~ | % m. 33; MIDI bar 59
\barNumberCheck #34 g,4 c,2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
bassIII = {
\barNumberCheck #1 \key c \minor R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2. | % m. 3; MIDI bar 3
\barNumberCheck #4 R2. | % m. 4; MIDI bar 4
\barNumberCheck #5 r4 ees4-.\ff-> e4-. | % m. 5; MIDI bar 5
\barNumberCheck #6 r4 f4-.-> fis4-. | % m. 6; MIDI bar 6
\barNumberCheck #7 g4-. bes4-. d'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 g4-. g,4-. r4 | % m. 8; MIDI bar 8
\barNumberCheck #9 bes,4-.\ff c4-. d4-. | % m. 9; MIDI bar 17
\barNumberCheck #10 ees4-. f4-. g4-. | % m. 10; MIDI bar 18
\barNumberCheck #11 aes4-. bes4-. c'4-. | % m. 11; MIDI bar 19
\barNumberCheck #12 d'4-. ees'4-. f'4-. | % m. 12; MIDI bar 20
\barNumberCheck #13 ees'4-. ees4-.-> e4-. | % m. 13; MIDI bar 21
\barNumberCheck #14 r4 f4-.-> fis4-. | % m. 14; MIDI bar 22
\barNumberCheck #15 g4(-> aes4) g4-. | % m. 15; MIDI bar 23
\barNumberCheck #16 c4-. c,4-. r4 | % m. 16; MIDI bar 24
\barNumberCheck #17 \key c \major R2. | % m. 17; MIDI bar 33
\barNumberCheck #18 R2. | % m. 18; MIDI bar 34
\barNumberCheck #19 R2. | % m. 19; MIDI bar 35
\barNumberCheck #20 R2. | % m. 20; MIDI bar 36
\barNumberCheck #21 R2. | % m. 21; MIDI bar 37
\barNumberCheck #22 R2. | % m. 22; MIDI bar 38
\barNumberCheck #23 R2. | % m. 23; MIDI bar 39
\barNumberCheck #24 R2. | % m. 24; MIDI bar 40
\barNumberCheck #25 R2. | % m. 25; MIDI bar 41
\barNumberCheck #26 R2. | % m. 26; MIDI bar 42
\barNumberCheck #27 f4(\pp g4 aes4 | % m. 27; MIDI bar 53
\barNumberCheck #28 g4 f4 ees4) | % m. 28; MIDI bar 54
\barNumberCheck #29 d4( ees4 f4) | % m. 29; MIDI bar 55
\barNumberCheck #30 fis2->( g4) | % m. 30; MIDI bar 56
\barNumberCheck #31 R2. | % m. 31; MIDI bar 57
\barNumberCheck #32 R2. | % m. 32; MIDI bar 58
\barNumberCheck #33 g,2.~ | % m. 33; MIDI bar 59
\barNumberCheck #34 g,4 c,2-> | % m. 34; MIDI bar 60
\barNumberCheck #35 R2. | % m. 35; MIDI bar 61
\barNumberCheck #36 R2. | % m. 36; MIDI bar 62
\barNumberCheck #37
}
fluteIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 e''2\ff-> d''4 | % m. 4; MIDI bar 4
\barNumberCheck #5 f''2-> e''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 a''2-> g''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 f''2-> e''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 cis''8(-> d''8 e''8 fis''8 g''4-.) | % m. 8; MIDI bar 8
\barNumberCheck #9 e''8(-> fis''8 gis''8 a''8 b''4-.) | % m. 9; MIDI bar 9
\barNumberCheck #10 c'''2-> b''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 a''2-> g''4 | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 e''8(\pp fis''8 gis''8 a''8 b''4-.) | % m. 17; MIDI bar 17
\barNumberCheck #18 c'''2-> b''4 | % m. 18; MIDI bar 18
\barNumberCheck #19 a''2-> g''4 | % m. 19; MIDI bar 19
\barNumberCheck #20 g'''2->\ff f'''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 e'''2-> e'''4 | % m. 21; MIDI bar 21
\barNumberCheck #22 dis'''2.-> | % m. 22; MIDI bar 22
\barNumberCheck #23 e'''2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f''8(\ff g''8 a''8 b''8  c'''4-.) | % m. 28; MIDI bar 28
\barNumberCheck #29 d''8( e''8 f''8 g''8  a''4-.) | % m. 29; MIDI bar 29
\barNumberCheck #30 f'''2-> e'''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 d'''2-> c'''4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g'''2->\ff f'''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 e'''2-> e'''4 | % m. 35; MIDI bar 35
\barNumberCheck #36 dis'''2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e'''2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f''8(\ff g''8 a''8 b''8  c'''4-.) | % m. 42; MIDI bar 42
\barNumberCheck #43 d''8( e''8 f''8 g''8  a''4-.) | % m. 43; MIDI bar 43
\barNumberCheck #44 f'''2-> e'''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 d'''2-> c'''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 fis''8( g''8 a''8 b''8  c'''4-.) | % m. 46; MIDI bar 46
\barNumberCheck #47 R2. | % m. 47; MIDI bar 47
\barNumberCheck #48 g'''2.\sf->( | % m. 48; MIDI bar 48
\barNumberCheck #49 e'''4) r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 g''8(\p d''8 b''8 a''8 g''8 fis''8 | % m. 68; MIDI bar 68
\barNumberCheck #69 e''8 d''8 c''8 b'8 a'8 g'8) | % m. 69; MIDI bar 69
\barNumberCheck #70 fis'2.~ | % m. 70; MIDI bar 70
\barNumberCheck #71 fis'2. | % m. 71; MIDI bar 71
\barNumberCheck #72 g'4 r4 r4 | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 g''4( fis''4 e''4) | % m. 77; MIDI bar 77
\barNumberCheck #78 dis''2 r4 | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 c''4(\f b'4 a'4) | % m. 82; MIDI bar 82
\barNumberCheck #83 \grace { a'8 } c'''2(-> dis''4-.) | % m. 83; MIDI bar 83
\barNumberCheck #84 e''4-.\ff e''4-. fis''4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis''4-. a''4-. b''4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'''4-. b''4-. a''4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a''4 b''4-. c'''4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b''4-. e''4-. e'''4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'''4-. c'''4-. b''4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a''4-. b''4-. c'''4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'''4 a''4-. dis''4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e''4-. e'''4-. d'''4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 c'''4-. b''4-. a''4-. | % m. 93; MIDI bar 93
\barNumberCheck #94 gis''4-. e'''4-. d'''4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 c'''4-. b''4-. a''4-. | % m. 95; MIDI bar 95
\barNumberCheck #96 gis''4-. e'''4-. e'''4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 e'''4-. e'''4-. e'''4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 e'''4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 b''8(\pp c'''8 d'''8 e'''8 f'''4) | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 g''8(\p^\markup \italic "Solo" a''8 b''8 c'''8 d'''4) | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 g'8\<( a'8 b'8 c''8 d''8 e''8) | % m. 140; MIDI bar 140
\barNumberCheck #141 f''8( g''8 a''8 b''8 c'''8 d'''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 e'''2\ff-> d'''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 f'''2-> e'''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 a'''2-> g'''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 f'''2-> e'''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 cis'''8( d'''8 e'''8 fis'''8  g'''4-.) | % m. 146; MIDI bar 146
\barNumberCheck #147 e''8( fis''8 gis''8 a''8  b''4-.) | % m. 147; MIDI bar 147
\barNumberCheck #148 c'''2-> b''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 a''2-> g''4 | % m. 149; MIDI bar 149
\barNumberCheck #150 e''2(\pp->^\markup \italic "Solo" d''4 | % m. 150; MIDI bar 150
\barNumberCheck #151 f''2-> e''4 | % m. 151; MIDI bar 151
\barNumberCheck #152 a''2-> g''4 | % m. 152; MIDI bar 152
\barNumberCheck #153 f''2-> e''4) | % m. 153; MIDI bar 153
\barNumberCheck #154 cis''8( d''8 e''8 fis''8  g''4-.) | % m. 154; MIDI bar 154
\barNumberCheck #155 e''8( fis''8 gis''8 a''8  b''4-.) | % m. 155; MIDI bar 155
\barNumberCheck #156 c'''2-> b''4 | % m. 156; MIDI bar 156
\barNumberCheck #157 a''2-> g''4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g'''2\ff-> f'''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 e'''2-> e'''4 | % m. 159; MIDI bar 159
\barNumberCheck #160 dis'''2.-> | % m. 160; MIDI bar 160
\barNumberCheck #161 e'''4-. e''4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f''8(\f g''8 a''8 b''8  c'''4) | % m. 166; MIDI bar 166
\barNumberCheck #167 d''8( e''8 f''8 g''8  a''4) | % m. 167; MIDI bar 167
\barNumberCheck #168 f'''2-> e'''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 d'''2-> c'''4 | % m. 169; MIDI bar 169
\barNumberCheck #170 d''8. g''16 fis''8. g''16 a''8. g''16 | % m. 170; MIDI bar 170
\barNumberCheck #171 e''8. g''16 fis''8. g''16 a''8. g''16 | % m. 171; MIDI bar 171
\barNumberCheck #172 d''8. g''16 fis''8. g''16 a''8. g''16 | % m. 172; MIDI bar 172
\barNumberCheck #173 e''8. g''16 fis''8. g''16 a''8. g''16 | % m. 173; MIDI bar 173
\barNumberCheck #174 a''4 a''4-.-> g''4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 f''4 r4 r4 | % m. 175; MIDI bar 175
\barNumberCheck #176 r4 a''4-.-> g''4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 f''4 r4 r4 | % m. 177; MIDI bar 177
\barNumberCheck #178 a''8( bes''8 c'''8 d'''8  ees'''4-.) | % m. 178; MIDI bar 178
\barNumberCheck #179 fis''8( g''8 a''8 bes''8  c'''4-.) | % m. 179; MIDI bar 179
\barNumberCheck #180 c'''2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 \once \override Tie.minimum-length = #5 \once \override Tie.direction = #UP \once \override Tie.whiteout = ##f c'''2.~ | % m. 181; MIDI bar 181
\barNumberCheck #182 \once \override RepeatTie.direction = #UP c'''4\repeatTie c'''4-. d'''4-. | % m. 182; MIDI bar 182
\barNumberCheck #183 ees'''4 r4 r4 | % m. 183; MIDI bar 183
\barNumberCheck #184 r4 c'''4-. d'''4-. | % m. 184; MIDI bar 184
\barNumberCheck #185 ees'''4 r4 r4 | % m. 185; MIDI bar 185
\barNumberCheck #186 r4 c'''4-. d'''4-. | % m. 186; MIDI bar 186
\barNumberCheck #187 ees'''4-. c'''4-. d'''4-. | % m. 187; MIDI bar 187
\barNumberCheck #188 ees'''4-. c'''4( d'''4 | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'''4\< f'''4 fis'''4) | % m. 189; MIDI bar 189
\barNumberCheck #190 g'''8(\ff g''8 a''8 b''8 c'''4) | % m. 190; MIDI bar 190
\barNumberCheck #191 dis''8( e''8 f''8 fis''8 g''4) | % m. 191; MIDI bar 191
\barNumberCheck #192 b''8( c'''8 d'''8 dis'''8 e'''4) | % m. 192; MIDI bar 192
\barNumberCheck #193 fis''8( g''8 a''8 b''8 c'''4) | % m. 193; MIDI bar 193
\barNumberCheck #194 g''2.~ | % m. 194; MIDI bar 194
\barNumberCheck #195 g''2. | % m. 195; MIDI bar 195
\barNumberCheck #196 fis''8( g''8 a''8 b''8 c'''4) | % m. 196; MIDI bar 196
\barNumberCheck #197 d'''2-> c'''4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g'''2.\sf->( | % m. 198; MIDI bar 198
\barNumberCheck #199 e'''4) r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
oboeOneIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c'8(\f d'8 e'8 f'8 g'4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 e''2\ff-> d''4 | % m. 4; MIDI bar 4
\barNumberCheck #5 f''2-> e''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 a''2-> g''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 f''2-> e''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 cis''8(-> d''8 e''8 fis''8 g''4-.) | % m. 8; MIDI bar 8
\barNumberCheck #9 e''8(-> fis''8 gis''8 a''8 b''4-.) | % m. 9; MIDI bar 9
\barNumberCheck #10 c'''2-> b''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 a''2-> g''4 | % m. 11; MIDI bar 11
\barNumberCheck #12 e''2->\pp d''4 | % m. 12; MIDI bar 12
\barNumberCheck #13 f''2-> e''4 | % m. 13; MIDI bar 13
\barNumberCheck #14 a''2-> g''4 | % m. 14; MIDI bar 14
\barNumberCheck #15 f''2-> e''4 | % m. 15; MIDI bar 15
\barNumberCheck #16 cis''8( d''8 e''8 fis''8 g''4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 e''8( fis''8 gis''8 a''8 b''4-.) | % m. 17; MIDI bar 17
\barNumberCheck #18 c'''2-> b''4 | % m. 18; MIDI bar 18
\barNumberCheck #19 a''2-> g''4 | % m. 19; MIDI bar 19
\barNumberCheck #20 g''2->\ff f''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 e''2-> e''4 | % m. 21; MIDI bar 21
\barNumberCheck #22 dis''2.-> | % m. 22; MIDI bar 22
\barNumberCheck #23 e''2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 e''2->\p d''4 | % m. 24; MIDI bar 24
\barNumberCheck #25 f''2-> e''4 | % m. 25; MIDI bar 25
\barNumberCheck #26 a''2-> g''4 | % m. 26; MIDI bar 26
\barNumberCheck #27 f''2-> e''4 | % m. 27; MIDI bar 27
\barNumberCheck #28 a''2->\ff g''4 | % m. 28; MIDI bar 28
\barNumberCheck #29 f''2-> e''4 | % m. 29; MIDI bar 29
\barNumberCheck #30 f''2-> e''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 d''2-> c''4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g''2->\ff f''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 e''2-> e''4 | % m. 35; MIDI bar 35
\barNumberCheck #36 dis''2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e''2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 e''2->\p d''4 | % m. 38; MIDI bar 38
\barNumberCheck #39 f''2-> e''4 | % m. 39; MIDI bar 39
\barNumberCheck #40 a''2-> g''4 | % m. 40; MIDI bar 40
\barNumberCheck #41 f''2-> e''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 a''2->\ff g''4 | % m. 42; MIDI bar 42
\barNumberCheck #43 f''2-> e''4 | % m. 43; MIDI bar 43
\barNumberCheck #44 f''2-> e''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 d''2-> c''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 fis''8( g''8 a''8 b''8  c'''4-.) | % m. 46; MIDI bar 46
\barNumberCheck #47 f''2-> e''4 | % m. 47; MIDI bar 47
\barNumberCheck #48 g''2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 e''4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c''2.\p^\markup \italic "Solo" | % m. 50; MIDI bar 50
\barNumberCheck #51 e''2. | % m. 51; MIDI bar 51
\barNumberCheck #52 g''16 a''16 g''8 fis''4-. g''4-. | % m. 52; MIDI bar 52
\barNumberCheck #53 c'''2 b''4 | % m. 53; MIDI bar 53
\barNumberCheck #54 \grace { g''16( a''16 b''16 } a''2) gis''4 | % m. 54; MIDI bar 54
\barNumberCheck #55 a''4-. b''4-. c'''4-. | % m. 55; MIDI bar 55
\barNumberCheck #56 fis''2 g''4 | % m. 56; MIDI bar 56
\barNumberCheck #57 e''4 r4 e''4 | % m. 57; MIDI bar 57
\barNumberCheck #58 g''4 f''4 d''4 | % m. 58; MIDI bar 58
\barNumberCheck #59 b'4 \grace { c''8( } b'8) a'8 b'4 | % m. 59; MIDI bar 59
\barNumberCheck #60 c''4 g'4 e''4 | % m. 60; MIDI bar 60
\barNumberCheck #61 fis''8( g''8 a''8 g''8 e''4) | % m. 61; MIDI bar 61
\barNumberCheck #62 g''4 f''4 d''4 | % m. 62; MIDI bar 62
\barNumberCheck #63 b'4 \grace { c''8( } b'8) a'8 b'4 | % m. 63; MIDI bar 63
\barNumberCheck #64 c''4 g'4 e''4 | % m. 64; MIDI bar 64
\barNumberCheck #65 fis''8( g''8 a''8 g''8 e''4) | % m. 65; MIDI bar 65
\barNumberCheck #66 e''4( d''4) d''4 | % m. 66; MIDI bar 66
\barNumberCheck #67 \grace { e''8( } d''4 cis''4) d''4 | % m. 67; MIDI bar 67
\barNumberCheck #68 d''2-> b'4 | % m. 68; MIDI bar 68
\barNumberCheck #69 g''4( d''4 b'4) | % m. 69; MIDI bar 69
\barNumberCheck #70 d'4 c''4 b'4 | % m. 70; MIDI bar 70
\barNumberCheck #71 \grace { d''8( } c''4) a'4 fis'4 | % m. 71; MIDI bar 71
\barNumberCheck #72 g'4 d'4 b'4 | % m. 72; MIDI bar 72
\barNumberCheck #73 cis''8( d''8 e''8 d''8 b'4) | % m. 73; MIDI bar 73
\barNumberCheck #74 c''2.->~ | % m. 74; MIDI bar 74
\barNumberCheck #75 c''4( b'4 a'4) | % m. 75; MIDI bar 75
\barNumberCheck #76 \grace { g'16( a'16 b'16 } a'2) g'4 | % m. 76; MIDI bar 76
\barNumberCheck #77 g''4( fis''4 e''4 | % m. 77; MIDI bar 77
\barNumberCheck #78 dis''2) c''4 | % m. 78; MIDI bar 78
\barNumberCheck #79 \grace { d''8( } c''4) b'4 c''4 | % m. 79; MIDI bar 79
\barNumberCheck #80 c''2.-> | % m. 80; MIDI bar 80
\barNumberCheck #81 a'2.-> | % m. 81; MIDI bar 81
\barNumberCheck #82 c''4(\f b'4 a'4) | % m. 82; MIDI bar 82
\barNumberCheck #83 \grace { a'8( } c'''2)-> dis''4-. | % m. 83; MIDI bar 83
\barNumberCheck #84 e''4-.\ff e''4-. fis''4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis''4-. a''4-. b''4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'''4-. b''4-. a''4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a''4 b''4-. c'''4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b''4-. e''4-. e'''4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'''4-. c'''4-. b''4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a''4-. b''4-. c'''4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'''4 a''4-. dis''4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e''4-. e'''4-. d'''4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 c'''4-. b''4-. a''4-. | % m. 93; MIDI bar 93
\barNumberCheck #94 gis''4-. e'''4-. d'''4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 c'''4-. b''4-. a''4-. | % m. 95; MIDI bar 95
\barNumberCheck #96 gis''4-. gis''4-. gis''4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 gis''4-. gis''4-. gis''4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 gis''4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 b'8(\pp^\markup \italic "Solo" c''8 d''8 e''8 f''4) | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 g'8(^\markup \italic "Solo" a'8 b'8 c''8 d''4) | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136  R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 g'8_\<( a'8 b'8 c''8 d''8 e''8) | % m. 140; MIDI bar 140
\barNumberCheck #141 f''8( g''8 a''8 b''8 c'''8 d'''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 e'''4(\ff e''4) d''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 f''2-> e''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 a''2-> g''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 f''2-> e''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 cis''8( d''8 e''8 fis''8  g''4-.) | % m. 146; MIDI bar 146
\barNumberCheck #147 e''8( fis''8 gis''8 a''8  b''4-.) | % m. 147; MIDI bar 147
\barNumberCheck #148 c'''2-> b''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 a''2-> g''4 | % m. 149; MIDI bar 149
\barNumberCheck #150 c''2(\pp^\markup \italic "Solo"-> b'4 | % m. 150; MIDI bar 150
\barNumberCheck #151 d''2-> c''4 | % m. 151; MIDI bar 151
\barNumberCheck #152 f''2-> e''4 | % m. 152; MIDI bar 152
\barNumberCheck #153 b'2-> c''4) | % m. 153; MIDI bar 153
\barNumberCheck #154 a'2( g'4 | % m. 154; MIDI bar 154
\barNumberCheck #155 a'4 c''4 e''4) | % m. 155; MIDI bar 155
\barNumberCheck #156 e''2-> e''4 | % m. 156; MIDI bar 156
\barNumberCheck #157 c''2-> b'4 | % m. 157; MIDI bar 157
\barNumberCheck #158 g''2\ff-> f''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 e''2-> e''4 | % m. 159; MIDI bar 159
\barNumberCheck #160 dis''2.-> | % m. 160; MIDI bar 160
\barNumberCheck #161 e''2 r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f''8(\f g''8 a''8 b''8  c'''4) | % m. 166; MIDI bar 166
\barNumberCheck #167 d''8( e''8 f''8 g''8  a''4) | % m. 167; MIDI bar 167
\barNumberCheck #168 f''2-> e''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 d''2-> c''4 | % m. 169; MIDI bar 169
\barNumberCheck #170 f''4 f''4 f''4 | % m. 170; MIDI bar 170
\barNumberCheck #171 e''4 e''4 e''4 | % m. 171; MIDI bar 171
\barNumberCheck #172 f''4 f''4 f''4 | % m. 172; MIDI bar 172
\barNumberCheck #173 e''4 e''4 e''4 | % m. 173; MIDI bar 173
\barNumberCheck #174 f''4 a''4-.-> g''4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 f''4 f''4-.-> e''4-. | % m. 175; MIDI bar 175
\barNumberCheck #176 d''4 a''4-.-> g''4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 f''4 e''4-. f''4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 fis''2. | % m. 178; MIDI bar 178
\barNumberCheck #179 fis''8( g''8 a''8 bes''8  c'''4-.) | % m. 179; MIDI bar 179
\barNumberCheck #180 fis''2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 fis''2. | % m. 181; MIDI bar 181
\barNumberCheck #182 fis''2.~ | % m. 182; MIDI bar 182
\barNumberCheck #183 fis''2. | % m. 183; MIDI bar 183
\barNumberCheck #184 fis''2.~ | % m. 184; MIDI bar 184
\barNumberCheck #185 fis''2. | % m. 185; MIDI bar 185
\barNumberCheck #186 fis''2.~ | % m. 186; MIDI bar 186
\barNumberCheck #187 fis''2.~ | % m. 187; MIDI bar 187
\barNumberCheck #188 fis''4 c''4( d''4 | % m. 188; MIDI bar 188
\barNumberCheck #189 ees''4\< f''4 fis''4) | % m. 189; MIDI bar 189
\barNumberCheck #190 fis''8(\ff g''8 a''8 b''8  c'''4-.) | % m. 190; MIDI bar 190
\barNumberCheck #191 dis''8( e''8 f''8 fis''8  g''4-.) | % m. 191; MIDI bar 191
\barNumberCheck #192 b'8( c''8 d''8 dis''8  e''4-.) | % m. 192; MIDI bar 192
\barNumberCheck #193 fis''8( g''8 a''8 b''8  c'''4-.) | % m. 193; MIDI bar 193
\barNumberCheck #194 f''2.~ | % m. 194; MIDI bar 194
\barNumberCheck #195 f''2. | % m. 195; MIDI bar 195
\barNumberCheck #196 fis''8( g''8 a''8 b''8  c'''4-.) | % m. 196; MIDI bar 196
\barNumberCheck #197 f''2-> e''4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g''2.\sf( | % m. 198; MIDI bar 198
\barNumberCheck #199 e''4) r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
oboeTwoIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2  R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c''2\ff-> b'4 | % m. 4; MIDI bar 4
\barNumberCheck #5 d''2-> c''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 f''2-> e''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 b'2-> c''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 a'2-> b'4 | % m. 8; MIDI bar 8
\barNumberCheck #9 a'2-> gis'4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a'2-> g'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 fis'2-> g'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 c''2->\pp b'4 | % m. 12; MIDI bar 12
\barNumberCheck #13 d''2-> c''4 | % m. 13; MIDI bar 13
\barNumberCheck #14 f''2-> e''4 | % m. 14; MIDI bar 14
\barNumberCheck #15 b'2-> c''4 | % m. 15; MIDI bar 15
\barNumberCheck #16 a'2-> b'4 | % m. 16; MIDI bar 16
\barNumberCheck #17 a'2-> gis'4 | % m. 17; MIDI bar 17
\barNumberCheck #18 a'2-> g'4 | % m. 18; MIDI bar 18
\barNumberCheck #19 fis'2-> g'4 | % m. 19; MIDI bar 19
\barNumberCheck #20 bes'2->\ff a'4 | % m. 20; MIDI bar 20
\barNumberCheck #21 a'2-> g'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 c''4( b'4 a'4) | % m. 22; MIDI bar 22
\barNumberCheck #23 gis'2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 c''2->\p b'4 | % m. 24; MIDI bar 24
\barNumberCheck #25 d''2-> c''4 | % m. 25; MIDI bar 25
\barNumberCheck #26 f''2-> e''4 | % m. 26; MIDI bar 26
\barNumberCheck #27 b'2-> c''4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c''2->\ff c''4 | % m. 28; MIDI bar 28
\barNumberCheck #29 a'2-> a'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 a'2-> a'4 | % m. 30; MIDI bar 30
\barNumberCheck #31 f'2-> e'4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 bes'2->\ff a'4 | % m. 34; MIDI bar 34
\barNumberCheck #35 a'2-> g'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 c''4( b'4 a'4) | % m. 36; MIDI bar 36
\barNumberCheck #37 gis'2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 c''2->\p b'4 | % m. 38; MIDI bar 38
\barNumberCheck #39 d''2-> c''4 | % m. 39; MIDI bar 39
\barNumberCheck #40 f''2-> e''4-> | % m. 40; MIDI bar 40
\barNumberCheck #41 b'2-> c''4 | % m. 41; MIDI bar 41
\barNumberCheck #42 c''2->\ff c''4 | % m. 42; MIDI bar 42
\barNumberCheck #43 a'2-> a'4 | % m. 43; MIDI bar 43
\barNumberCheck #44 a'2-> a'4 | % m. 44; MIDI bar 44
\barNumberCheck #45 f'2-> e'4 | % m. 45; MIDI bar 45
\barNumberCheck #46 fis'8( g'8 a'8 b'8  c''4-.) | % m. 46; MIDI bar 46
\barNumberCheck #47 d''2-> c''4 | % m. 47; MIDI bar 47
\barNumberCheck #48 b'2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c''4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c''2.\p | % m. 50; MIDI bar 50
\barNumberCheck #51 c''2. | % m. 51; MIDI bar 51
\barNumberCheck #52 e''16 f''16 e''8 dis''4-. e''4-. | % m. 52; MIDI bar 52
\barNumberCheck #53 e''2 g''4 | % m. 53; MIDI bar 53
\barNumberCheck #54 \grace { e''16( f''16 g''16 } f''2) e''4 | % m. 54; MIDI bar 54
\barNumberCheck #55 f''4-. g''4-. a''4-. | % m. 55; MIDI bar 55
\barNumberCheck #56 dis''2 e''4 | % m. 56; MIDI bar 56
\barNumberCheck #57 c''4 r4 c''4 | % m. 57; MIDI bar 57
\barNumberCheck #58 b'2. | % m. 58; MIDI bar 58
\barNumberCheck #59 g'2.~ | % m. 59; MIDI bar 59
\barNumberCheck #60 g'2. | % m. 60; MIDI bar 60
\barNumberCheck #61 e'4 r4 g'4 | % m. 61; MIDI bar 61
\barNumberCheck #62 b'2. | % m. 62; MIDI bar 62
\barNumberCheck #63 g'2.~ | % m. 63; MIDI bar 63
\barNumberCheck #64 g'2. | % m. 64; MIDI bar 64
\barNumberCheck #65 e'4 r4 g'4 | % m. 65; MIDI bar 65
\barNumberCheck #66  R2. | % m. 66; MIDI bar 66
\barNumberCheck #67  R2. | % m. 67; MIDI bar 67
\barNumberCheck #68  R2. | % m. 68; MIDI bar 68
\barNumberCheck #69  R2. | % m. 69; MIDI bar 69
\barNumberCheck #70  R2. | % m. 70; MIDI bar 70
\barNumberCheck #71  R2. | % m. 71; MIDI bar 71
\barNumberCheck #72  R2. | % m. 72; MIDI bar 72
\barNumberCheck #73  R2. | % m. 73; MIDI bar 73
\barNumberCheck #74  R2. | % m. 74; MIDI bar 74
\barNumberCheck #75  R2. | % m. 75; MIDI bar 75
\barNumberCheck #76  R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 b'4( a'4 g'4 | % m. 77; MIDI bar 77
\barNumberCheck #78 a'2) r4 | % m. 78; MIDI bar 78
\barNumberCheck #79  R2. | % m. 79; MIDI bar 79
\barNumberCheck #80  R2. | % m. 80; MIDI bar 80
\barNumberCheck #81  R2. | % m. 81; MIDI bar 81
\barNumberCheck #82  R2. | % m. 82; MIDI bar 82
\barNumberCheck #83  R2. | % m. 83; MIDI bar 83
\barNumberCheck #84 r4 e'4\ff-. fis'4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis'4-. a'4-. b'4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c''4-. b'4-. a'4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a'4 b'4-. c''4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b'4-. e'4-. e''4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d''4-. c''4-. b'4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a'4-. b'4-. c''4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c''4 a'4-. dis'4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e'4-. e''4-. d''4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 c''4-. b'4-. a'4-. | % m. 93; MIDI bar 93
\barNumberCheck #94 gis'4-. e''4-. d''4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 c''4-. b'4-. a'4-. | % m. 95; MIDI bar 95
\barNumberCheck #96 gis'4-. b'4-. b'4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 b'4-. b'4-. b'4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 b'4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126  R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134  R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 g'8(\p^\markup \italic "Solo" a'8 b'8 c''8 d''4) | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140  R2. | % m. 140; MIDI bar 140
\barNumberCheck #141  f'8(\< g'8 a'8 b'8 c''8 d''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 c''2\ff-> b'4 | % m. 142; MIDI bar 142
\barNumberCheck #143 d''2-> c''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 f''2-> e''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 b'2-> c''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 a'2-> b'4 | % m. 146; MIDI bar 146
\barNumberCheck #147 a'2-> gis'4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a'2-> g'4 | % m. 148; MIDI bar 148
\barNumberCheck #149 fis'2-> g'4 | % m. 149; MIDI bar 149
\barNumberCheck #150  R2. | % m. 150; MIDI bar 150
\barNumberCheck #151  R2. | % m. 151; MIDI bar 151
\barNumberCheck #152  R2. | % m. 152; MIDI bar 152
\barNumberCheck #153  R2. | % m. 153; MIDI bar 153
\barNumberCheck #154  R2. | % m. 154; MIDI bar 154
\barNumberCheck #155  R2. | % m. 155; MIDI bar 155
\barNumberCheck #156  R2. | % m. 156; MIDI bar 156
\barNumberCheck #157  R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 bes'2\ff-> a'4 | % m. 158; MIDI bar 158
\barNumberCheck #159 a'2-> g'4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''4(-> b'4 a'4) | % m. 160; MIDI bar 160
\barNumberCheck #161 gis'2 r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 a'2\f-> g'4 | % m. 166; MIDI bar 166
\barNumberCheck #167 f'2-> e'4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d'2-> c''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 f'2-> e'4 | % m. 169; MIDI bar 169
\barNumberCheck #170 b'4 b'4 b'4 | % m. 170; MIDI bar 170
\barNumberCheck #171 c''4 c''4 c''4 | % m. 171; MIDI bar 171
\barNumberCheck #172 b'4 b'4 b'4 | % m. 172; MIDI bar 172
\barNumberCheck #173 c''4 c''4 c''4 | % m. 173; MIDI bar 173
\barNumberCheck #174 c''4 c''4-.-> c''4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c''4 c''4-.-> c''4-. | % m. 175; MIDI bar 175
\barNumberCheck #176 c''4 c''4-.-> c''4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 c''4 c''4-. c''4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a'8( bes'8 c''8 d''8  ees''4-.) | % m. 178; MIDI bar 178
\barNumberCheck #179 fis'8( g'8 a'8 bes'8  c''4-.) | % m. 179; MIDI bar 179
\barNumberCheck #180 ees''2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 ees''2. | % m. 181; MIDI bar 181
\barNumberCheck #182 ees''2.~ | % m. 182; MIDI bar 182
\barNumberCheck #183 ees''4 c''4-. d''4-. | % m. 183; MIDI bar 183
\barNumberCheck #184 ees''2.~ | % m. 184; MIDI bar 184
\barNumberCheck #185 ees''4 c''4-. d''4-. | % m. 185; MIDI bar 185
\barNumberCheck #186 ees''4-. c'4-. d'4-. | % m. 186; MIDI bar 186
\barNumberCheck #187 ees'4-. c''4-. d''4-. | % m. 187; MIDI bar 187
\barNumberCheck #188 ees''4-. c'4 d'4 | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'4\< f'4 fis'4 | % m. 189; MIDI bar 189
\barNumberCheck #190 fis'8(\ff g'8 a'8 b'8  c''4-.) | % m. 190; MIDI bar 190
\barNumberCheck #191 dis'8( e'8 f'8 fis'8  g'4-.) | % m. 191; MIDI bar 191
\barNumberCheck #192 b'8( c''8 d''8 dis''8  e''4-.) | % m. 192; MIDI bar 192
\barNumberCheck #193 fis'8( g'8 a'8 b'8  c''4-.) | % m. 193; MIDI bar 193
\barNumberCheck #194 b'2.~ | % m. 194; MIDI bar 194
\barNumberCheck #195 b'2. | % m. 195; MIDI bar 195
\barNumberCheck #196 fis'8( g'8 a'8 b'8  c''4-.) | % m. 196; MIDI bar 196
\barNumberCheck #197 b'2-> c''4 | % m. 197; MIDI bar 197
\barNumberCheck #198 b'2.\sf( | % m. 198; MIDI bar 198
\barNumberCheck #199 c''4) r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
bassoonOneIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c8(\f d8 e8 f8 g4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c8(\ff d8 e8 f8 g4->~) | % m. 4; MIDI bar 4
\barNumberCheck #5 g8( a8 bes8 b8 c'4-.) | % m. 5; MIDI bar 5
\barNumberCheck #6 f8( g8 a8 b8 c'4-.) | % m. 6; MIDI bar 6
\barNumberCheck #7 d'4-. g4-. c'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 c'2-> b4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c'2-> b4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a8( b8 c'8 d'8 e'4-.) | % m. 10; MIDI bar 10
\barNumberCheck #11 fis'4-. d'4-. g'4-. | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 R2. | % m. 17; MIDI bar 17
\barNumberCheck #18 a8(\p b8 c'8 d'8  e'4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 fis'4-. d'4-. g'4-. | % m. 19; MIDI bar 19
\barNumberCheck #20 g8(\ff a8 bes8 c'8  d'4-.) | % m. 20; MIDI bar 20
\barNumberCheck #21 a8( b8 c'8 d'8  e'4-.) | % m. 21; MIDI bar 21
\barNumberCheck #22 f8( g8 a8 b8  c'4-.) | % m. 22; MIDI bar 22
\barNumberCheck #23 b4-. e4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 c8(\pp d8 e8 f8 g4->~) | % m. 24; MIDI bar 24
\barNumberCheck #25 g8( a8 bes8 b8 c'4-.) | % m. 25; MIDI bar 25
\barNumberCheck #26 f8( g8 a8 b8  c'4-.) | % m. 26; MIDI bar 26
\barNumberCheck #27 d'4-. g4-. c'4-. | % m. 27; MIDI bar 27
\barNumberCheck #28 f2->\ff e4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d2-> cis4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d8( e8 f8 g8  a4-.) | % m. 30; MIDI bar 30
\barNumberCheck #31 b4-. g4-. c'4-. | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g8(\ff a8 bes8 c'8  d'4-.) | % m. 34; MIDI bar 34
\barNumberCheck #35 a8( b8 c'8 d'8  e'4-.) | % m. 35; MIDI bar 35
\barNumberCheck #36 f8( g8 a8 b8  c'4-.) | % m. 36; MIDI bar 36
\barNumberCheck #37 b4-. e4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 c8(\p d8 e8 f8 g4->~) | % m. 38; MIDI bar 38
\barNumberCheck #39 g8( a8 bes8 b8 c'4-.) | % m. 39; MIDI bar 39
\barNumberCheck #40 f8( g8 a8 b8  c'4-.) | % m. 40; MIDI bar 40
\barNumberCheck #41 d'4-. g4-. c'4-. | % m. 41; MIDI bar 41
\barNumberCheck #42 f2->\ff e4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2-> cis4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d8( e8 f8 g8  a4-.) | % m. 44; MIDI bar 44
\barNumberCheck #45 b4-. g4-. c'4-. | % m. 45; MIDI bar 45
\barNumberCheck #46 fis8( g8 a8 b8  c'4-.) | % m. 46; MIDI bar 46
\barNumberCheck #47 f'2-> e'4 | % m. 47; MIDI bar 47
\barNumberCheck #48 f'2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 e'4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 g4(\p^\markup \italic "Solo" b4 d'4) | % m. 58; MIDI bar 58
\barNumberCheck #59 f'2.-> | % m. 59; MIDI bar 59
\barNumberCheck #60 e'2 c'4 | % m. 60; MIDI bar 60
\barNumberCheck #61 dis'8( e'8 f'8 e'8 c'4) | % m. 61; MIDI bar 61
\barNumberCheck #62 g4 b4 d'4 | % m. 62; MIDI bar 62
\barNumberCheck #63 f'2.-> | % m. 63; MIDI bar 63
\barNumberCheck #64 e'2 c'4 | % m. 64; MIDI bar 64
\barNumberCheck #65 dis'8( e'8 f'8 e'8 c'4) | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 d,8(^\markup \italic "Solo" e,8 fis,8 g,8 a,8 b,8 | % m. 70; MIDI bar 70
\barNumberCheck #71 c8 d8 e8 fis8 g8 a8 | % m. 71; MIDI bar 71
\barNumberCheck #72 b2) r4 | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 dis'2.\pp~ | % m. 74; MIDI bar 74
\barNumberCheck #75 dis'2. | % m. 75; MIDI bar 75
\barNumberCheck #76 e'2. | % m. 76; MIDI bar 76
\barNumberCheck #77 g4( a4 b4 | % m. 77; MIDI bar 77
\barNumberCheck #78 c'2) r4 | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 f2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 f2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e4-.\ff e4-. fis4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis4-. a4-. b4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'4-. b4-. a4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a4 b4-. c'4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b4-. e4-. e'4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'4-. c'4-. b4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a4-. b4-. c'4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'4 a4-. dis4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e4-. e4-. gis4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 a4-. b4-. c'8-. d'8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4-. e4-. gis4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 a4-. b4-. c'8-. d'8-. | % m. 95; MIDI bar 95
\barNumberCheck #96 e'4-. gis4-. gis4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 gis4-. gis4-. gis4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 gis4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 b8(\pp^\markup \italic "Solo" c'8 d'8 e'8 f'4) | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 g,8(\p\< a,8 b,8 c8 d8 e8) | % m. 140; MIDI bar 140
\barNumberCheck #141 f8( g8 a8 b8 c'8 d'8) | % m. 141; MIDI bar 141
\barNumberCheck #142 e'4\ff e8( f8 g4->)~ | % m. 142; MIDI bar 142
\barNumberCheck #143 g8( a8 bes8 b8  c'4-.) | % m. 143; MIDI bar 143
\barNumberCheck #144 f8( g8 a8 b8  c'4-.) | % m. 144; MIDI bar 144
\barNumberCheck #145 d'4-. g4-. c'4-. | % m. 145; MIDI bar 145
\barNumberCheck #146 c'2-> b4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c'2-> b4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a8( b8 c'8 d'8  e'4-.) | % m. 148; MIDI bar 148
\barNumberCheck #149 fis'4-. d'4-. g'4-. | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g8(\ff a8 bes8 c'8  d'4-.) | % m. 158; MIDI bar 158
\barNumberCheck #159 a8( b8 c'8 d'8  e'4-.) | % m. 159; MIDI bar 159
\barNumberCheck #160 f8( g8 a8 b8  c'4-.) | % m. 160; MIDI bar 160
\barNumberCheck #161 b4-. e4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 c8(\pp^\markup \italic "Solo" d8 e8 f8 g4->~) | % m. 162; MIDI bar 162
\barNumberCheck #163 g8( a8 bes8 b8 c'4-.) | % m. 163; MIDI bar 163
\barNumberCheck #164 f8( g8 a8 b8  c'4-.) | % m. 164; MIDI bar 164
\barNumberCheck #165 d'4-. g4-. c'4-. | % m. 165; MIDI bar 165
\barNumberCheck #166 f2\f-> e4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d2-> cis4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d8(-> e8 f8 g8  a4-.) | % m. 168; MIDI bar 168
\barNumberCheck #169 b4-.-> g4-. c'4-. | % m. 169; MIDI bar 169
\barNumberCheck #170 g,8(\ff a,8 b,8 c8  d4-.) | % m. 170; MIDI bar 170
\barNumberCheck #171 c8( d8 e8 f8  g4-.) | % m. 171; MIDI bar 171
\barNumberCheck #172 g8( a8 b8 c'8  d'4-.) | % m. 172; MIDI bar 172
\barNumberCheck #173 c'8( d'8 e'8 f'8  g'4-.) | % m. 173; MIDI bar 173
\barNumberCheck #174 f'4-. f4-.-> g4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 a4 r4 r4 | % m. 175; MIDI bar 175
\barNumberCheck #176 r4 f4-.-> g4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 a4-. g4-. a4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a8( bes8 c'8 d'8  ees'4-.) | % m. 178; MIDI bar 178
\barNumberCheck #179 fis8( g8 a8 bes8  c'4-.) | % m. 179; MIDI bar 179
\barNumberCheck #180 a2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 a2. | % m. 181; MIDI bar 181
\barNumberCheck #182 aes2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 aes2.~ | % m. 183; MIDI bar 183
\barNumberCheck #184 aes2.~ | % m. 184; MIDI bar 184
\barNumberCheck #185 aes2.~ | % m. 185; MIDI bar 185
\barNumberCheck #186 aes2.~ | % m. 186; MIDI bar 186
\barNumberCheck #187 aes2.~ | % m. 187; MIDI bar 187
\barNumberCheck #188 aes4 c'4( d'4 | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'4\< f'4 fis'4) | % m. 189; MIDI bar 189
\barNumberCheck #190 g'8(\ff g8 a8 b8  c'4-.) | % m. 190; MIDI bar 190
\barNumberCheck #191 dis'8( e'8 f'8 fis'8  g'4-.) | % m. 191; MIDI bar 191
\barNumberCheck #192 b8( c'8 d'8 dis'8  e'4-.) | % m. 192; MIDI bar 192
\barNumberCheck #193 fis8( g8 a8 b8  c'4-.) | % m. 193; MIDI bar 193
\barNumberCheck #194 f'2.~ | % m. 194; MIDI bar 194
\barNumberCheck #195 f'2. | % m. 195; MIDI bar 195
\barNumberCheck #196 fis8(-> g8 a8 b8  c'4-.) | % m. 196; MIDI bar 196
\barNumberCheck #197 b2 c'4 | % m. 197; MIDI bar 197
\barNumberCheck #198 f'2.\sf( | % m. 198; MIDI bar 198
\barNumberCheck #199 e'4) r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 fis,8(\pp g,8 a,8 b,8 c4-.) | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
bassoonTwoIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c8(\f d8 e8 f8 g4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c8(\ff d8 e8 f8 g4->~) | % m. 4; MIDI bar 4
\barNumberCheck #5 g8( a8 bes8 b8 c'4-.) | % m. 5; MIDI bar 5
\barNumberCheck #6 f8( g8 a8 b8 c'4-.) | % m. 6; MIDI bar 6
\barNumberCheck #7 d'4-. g4-. c'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 c'2-> b4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c'2-> b4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a8( b8 c'8 d'8 e'4-.) | % m. 10; MIDI bar 10
\barNumberCheck #11 fis'4-. d'4-. g'4-. | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 R2. | % m. 17; MIDI bar 17
\barNumberCheck #18  R2. | % m. 18; MIDI bar 18
\barNumberCheck #19  R2. | % m. 19; MIDI bar 19
\barNumberCheck #20 g,8(\ff a,8 bes,8 c8  d4-.) | % m. 20; MIDI bar 20
\barNumberCheck #21 a,8( b,8 c8 d8  e4-.) | % m. 21; MIDI bar 21
\barNumberCheck #22 f,8( g,8 a,8 b,8  c4-.) | % m. 22; MIDI bar 22
\barNumberCheck #23 b,4-. e,4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24  R2. | % m. 24; MIDI bar 24
\barNumberCheck #25  R2. | % m. 25; MIDI bar 25
\barNumberCheck #26  R2. | % m. 26; MIDI bar 26
\barNumberCheck #27  R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f,2->\ff e,4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d,2-> cis4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d8( e8 f8 g8  a4-.) | % m. 30; MIDI bar 30
\barNumberCheck #31 b4-. g4-. c'4-. | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g,8(\ff a,8 bes,8 c8  d4-.) | % m. 34; MIDI bar 34
\barNumberCheck #35 a,8( b,8 c8 d8  e4-.) | % m. 35; MIDI bar 35
\barNumberCheck #36 f,8( g,8 a,8 b,8  c4-.) | % m. 36; MIDI bar 36
\barNumberCheck #37 b,4-. e,4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38  R2. | % m. 38; MIDI bar 38
\barNumberCheck #39  R2. | % m. 39; MIDI bar 39
\barNumberCheck #40  R2. | % m. 40; MIDI bar 40
\barNumberCheck #41  R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f,2->\ff e,4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d,2-> cis4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d8( e8 f8 g8  a4-.) | % m. 44; MIDI bar 44
\barNumberCheck #45 b4-. g4-. c'4-. | % m. 45; MIDI bar 45
\barNumberCheck #46 fis8( g8 a8 b8  c'4-.) | % m. 46; MIDI bar 46
\barNumberCheck #47 b2-> c'4 | % m. 47; MIDI bar 47
\barNumberCheck #48 b2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 c'4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58  R2. | % m. 58; MIDI bar 58
\barNumberCheck #59  R2. | % m. 59; MIDI bar 59
\barNumberCheck #60  R2. | % m. 60; MIDI bar 60
\barNumberCheck #61  R2. | % m. 61; MIDI bar 61
\barNumberCheck #62  R2. | % m. 62; MIDI bar 62
\barNumberCheck #63  R2. | % m. 63; MIDI bar 63
\barNumberCheck #64  R2. | % m. 64; MIDI bar 64
\barNumberCheck #65  R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70  R2. | % m. 70; MIDI bar 70
\barNumberCheck #71  R2. | % m. 71; MIDI bar 71
\barNumberCheck #72  R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 fis2.\pp~ | % m. 74; MIDI bar 74
\barNumberCheck #75 fis2. | % m. 75; MIDI bar 75
\barNumberCheck #76 g2. | % m. 76; MIDI bar 76
\barNumberCheck #77 e4( fis4 g4 | % m. 77; MIDI bar 77
\barNumberCheck #78 fis2) r4 | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 f,2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 f,2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e,4-.\ff e,4-. fis,4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis,4-. a,4-. b,4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c4-. b,4-. a,4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a,4 b,4-. c4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b,4-. e,4-. e4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d4-. c4-. b,4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a,4-. b,4-. c4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c4 a,4-. dis,4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e,4-. e,4-. gis,4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 a,4-. b,4-. c8-. d8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e4-. e,4-. gis,4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 a,4-. b,4-. c8-. d8-. | % m. 95; MIDI bar 95
\barNumberCheck #96 e4-. e,4-. e,4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 e,4-. e,4-. e,4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 e,4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124  R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140  R2. | % m. 140; MIDI bar 140
\barNumberCheck #141  R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 c,8(\ff d,8 e,8 f,8 g,4->~) | % m. 142; MIDI bar 142
\barNumberCheck #143 g,8( a,8 bes,8 b,8  c4-.) | % m. 143; MIDI bar 143
\barNumberCheck #144 f,8( g,8 a,8 b,8  c4-.) | % m. 144; MIDI bar 144
\barNumberCheck #145 d4-. g,4-. c4-. | % m. 145; MIDI bar 145
\barNumberCheck #146 c2-> b,4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c2-> b,4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a,8( b,8 c8 d8  e4-.) | % m. 148; MIDI bar 148
\barNumberCheck #149 fis4-. d4-. g4-. | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g,8(\ff a,8 bes,8 c8  d4-.) | % m. 158; MIDI bar 158
\barNumberCheck #159 a,8( b,8 c8 d8  e4-.) | % m. 159; MIDI bar 159
\barNumberCheck #160 f,8( g,8 a,8 b,8  c4-.) | % m. 160; MIDI bar 160
\barNumberCheck #161 b,4-. e,4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162  R2. | % m. 162; MIDI bar 162
\barNumberCheck #163  R2. | % m. 163; MIDI bar 163
\barNumberCheck #164  R2. | % m. 164; MIDI bar 164
\barNumberCheck #165  R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f,2\f-> e,4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d,2-> cis4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d8(-> e8 f8 g8  a4-.) | % m. 168; MIDI bar 168
\barNumberCheck #169 b4-.-> g4-. c'4-. | % m. 169; MIDI bar 169
\barNumberCheck #170 g,8(\ff a,8 b,8 c8  d4-.) | % m. 170; MIDI bar 170
\barNumberCheck #171 c,8( d,8 e,8 f,8  g,4-.) | % m. 171; MIDI bar 171
\barNumberCheck #172 g,8( a,8 b,8 c8  d4-.) | % m. 172; MIDI bar 172
\barNumberCheck #173 c8( d8 e8 f8  g4-.) | % m. 173; MIDI bar 173
\barNumberCheck #174 f4 f,4-.-> g,4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 a,4-. r4 r4 | % m. 175; MIDI bar 175
\barNumberCheck #176 r4 f,4-.-> g,4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 a,4-. g,4-. a,4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a,2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 a,2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a,8( bes,8 c8 d8  ees4-.) | % m. 180; MIDI bar 180
\barNumberCheck #181 fis,8( g,8 a,8 bes,8  c4-.) | % m. 181; MIDI bar 181
\barNumberCheck #182 aes,2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 aes,2.~ | % m. 183; MIDI bar 183
\barNumberCheck #184 aes,2.~ | % m. 184; MIDI bar 184
\barNumberCheck #185 aes,2.~ | % m. 185; MIDI bar 185
\barNumberCheck #186 aes,2.~ | % m. 186; MIDI bar 186
\barNumberCheck #187 aes,2.~ | % m. 187; MIDI bar 187
\barNumberCheck #188 aes,2.~ | % m. 188; MIDI bar 188
\barNumberCheck #189 aes,2.\< | % m. 189; MIDI bar 189
\barNumberCheck #190 fis8(\ff g8 a8 b8  c'4-.) | % m. 190; MIDI bar 190
\barNumberCheck #191 dis8( e8 f8 fis8  g4-.) | % m. 191; MIDI bar 191
\barNumberCheck #192 b,8( c8 d8 dis8  e4-.) | % m. 192; MIDI bar 192
\barNumberCheck #193 fis,8( g,8 a,8 b,8  c4-.) | % m. 193; MIDI bar 193
\barNumberCheck #194 b2.~ | % m. 194; MIDI bar 194
\barNumberCheck #195 b2. | % m. 195; MIDI bar 195
\barNumberCheck #196 fis8( g8 a8 b8  c'4-.) | % m. 196; MIDI bar 196
\barNumberCheck #197 g2 g4 | % m. 197; MIDI bar 197
\barNumberCheck #198 b2.\sf | % m. 198; MIDI bar 198
\barNumberCheck #199 c'4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 fis,8(\pp g,8 a,8 b,8  c4-.) | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
hornOneIV = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 g'2\f-> g'4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'2-> g'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c''2-> c''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g'2-> c''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 d''2-> d''4 | % m. 8; MIDI bar 8
\barNumberCheck #9 e''2-> e''4 | % m. 9; MIDI bar 9
\barNumberCheck #10 e''2-> e''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 d''2-> d''4 | % m. 11; MIDI bar 11
\barNumberCheck #12 g'2\pp g'4 | % m. 12; MIDI bar 12
\barNumberCheck #13 g'2 g'4 | % m. 13; MIDI bar 13
\barNumberCheck #14 c''2 c''4 | % m. 14; MIDI bar 14
\barNumberCheck #15 g'2 c''4 | % m. 15; MIDI bar 15
\barNumberCheck #16 d''2 d''4 | % m. 16; MIDI bar 16
\barNumberCheck #17 e''2 e''4 | % m. 17; MIDI bar 17
\barNumberCheck #18 e''2 e''4 | % m. 18; MIDI bar 18
\barNumberCheck #19 d''2 d''4 | % m. 19; MIDI bar 19
\barNumberCheck #20 d''2->\ff d''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c''2-> b'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 R2. | % m. 22; MIDI bar 22
\barNumberCheck #23 e''2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 c''2->\ff c''4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d''2-> e''4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d''2-> c''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 d''2-> e''4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 d''2->\ff d''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 c''2-> b'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 R2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e''2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 c''2->\ff c''4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d''2-> e''4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d''2-> c''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 d''2-> e''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 g'2-> c''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 d''2-> c''4 | % m. 47; MIDI bar 47
\barNumberCheck #48 g'2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c''4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c'4\pp c'4 c'4->~ | % m. 50; MIDI bar 50
\barNumberCheck #51 c'4 c'4 c'4->~ | % m. 51; MIDI bar 51
\barNumberCheck #52 c'4 c'4 c'4->~ | % m. 52; MIDI bar 52
\barNumberCheck #53 c'4 c'4 c'4->~ | % m. 53; MIDI bar 53
\barNumberCheck #54 c'4 c'4 c'4->~ | % m. 54; MIDI bar 54
\barNumberCheck #55 c'4 c'4 c'4->~ | % m. 55; MIDI bar 55
\barNumberCheck #56 c'4 c'4 c'4->~ | % m. 56; MIDI bar 56
\barNumberCheck #57 c'4 c'4 c'4-> | % m. 57; MIDI bar 57
\barNumberCheck #58 g'2.~ | % m. 58; MIDI bar 58
\barNumberCheck #59 g'2 g'4 | % m. 59; MIDI bar 59
\barNumberCheck #60 c''2 c''4 | % m. 60; MIDI bar 60
\barNumberCheck #61 c''4 r4 c''4 | % m. 61; MIDI bar 61
\barNumberCheck #62 g'2.~ | % m. 62; MIDI bar 62
\barNumberCheck #63 g'2 g'4 | % m. 63; MIDI bar 63
\barNumberCheck #64 c''2 c''4 | % m. 64; MIDI bar 64
\barNumberCheck #65 c''4 r4 c''4 | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 R2. | % m. 70; MIDI bar 70
\barNumberCheck #71 R2. | % m. 71; MIDI bar 71
\barNumberCheck #72 R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 R2. | % m. 77; MIDI bar 77
\barNumberCheck #78 R2. | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 c''2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 c''2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e''4\ff e''8 e''8 e''4 | % m. 84; MIDI bar 84
\barNumberCheck #85 e''4 e''8 e''8 e''4 | % m. 85; MIDI bar 85
\barNumberCheck #86 e''4 e''8 e''8 e''4 | % m. 86; MIDI bar 86
\barNumberCheck #87 e''4 e''8 e''8 e''4 | % m. 87; MIDI bar 87
\barNumberCheck #88 e''4 e''8 e''8 e''4 | % m. 88; MIDI bar 88
\barNumberCheck #89 e''4 e''8 e''8 e''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 e''4 e''8 e''8 e''4 | % m. 90; MIDI bar 90
\barNumberCheck #91 e''4 e''8 e''8 e''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 e''4 e''8 e''8 e''4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e''4 e''8 e''8 e''4 | % m. 93; MIDI bar 93
\barNumberCheck #94 e''4 e''8 e''8 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 e''4 e''8 e''8 e''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 e''4 e''8 e''8 e''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 e''4 e''8 e''8 e''4 | % m. 97; MIDI bar 97
\barNumberCheck #98 e''2.\>~ | % m. 98; MIDI bar 98
\barNumberCheck #99 e''2.~ | % m. 99; MIDI bar 99
\barNumberCheck #100 e''2.\p\<~^\markup \italic "Solo" | % m. 100; MIDI bar 100
\barNumberCheck #101 e''4\> dis''4( e''4) | % m. 101; MIDI bar 101
\barNumberCheck #102 f''2\!-> e''4 | % m. 102; MIDI bar 102
\barNumberCheck #103 b'2. | % m. 103; MIDI bar 103
\barNumberCheck #104 c''2.~ | % m. 104; MIDI bar 104
\barNumberCheck #105 c''4( b'4 a'4 | % m. 105; MIDI bar 105
\barNumberCheck #106 b'2.) | % m. 106; MIDI bar 106
\barNumberCheck #107 e'2. | % m. 107; MIDI bar 107
\barNumberCheck #108 e''2.~ | % m. 108; MIDI bar 108
\barNumberCheck #109 e''4( d''4 e''4) | % m. 109; MIDI bar 109
\barNumberCheck #110 f''2.( | % m. 110; MIDI bar 110
\barNumberCheck #111 e''2.) | % m. 111; MIDI bar 111
\barNumberCheck #112 e''2. | % m. 112; MIDI bar 112
\barNumberCheck #113 \grace { e''8( } dis''4 cis''4 dis''4) | % m. 113; MIDI bar 113
\barNumberCheck #114 e''2.~ | % m. 114; MIDI bar 114
\barNumberCheck #115 e''2.~ | % m. 115; MIDI bar 115
\barNumberCheck #116 e''2. | % m. 116; MIDI bar 116
\barNumberCheck #117 \grace { f''8( } e''4 dis''4 e''4) | % m. 117; MIDI bar 117
\barNumberCheck #118 f''2 e''4 | % m. 118; MIDI bar 118
\barNumberCheck #119 b'2. | % m. 119; MIDI bar 119
\barNumberCheck #120 c''2.~ | % m. 120; MIDI bar 120
\barNumberCheck #121 c''4( b'4 a'4) | % m. 121; MIDI bar 121
\barNumberCheck #122 f''2.(-> | % m. 122; MIDI bar 122
\barNumberCheck #123 b'2) r4 | % m. 123; MIDI bar 123
\barNumberCheck #124 f''2(_\markup \italic "perdendosi" b'8-.) r8 | % m. 124; MIDI bar 124
\barNumberCheck #125 f''2( b'8-.) r8 | % m. 125; MIDI bar 125
\barNumberCheck #126 f''2.~ | % m. 126; MIDI bar 126
\barNumberCheck #127 f''2. | % m. 127; MIDI bar 127
\barNumberCheck #128 b'2.~ | % m. 128; MIDI bar 128
\barNumberCheck #129 b'2 r4\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 g'4-.\p d''4-. g'4-. | % m. 130; MIDI bar 130
\barNumberCheck #131 d''4-.-\tweak layer #3 _\markup \whiteout \pad-markup #0.2 \italic "cresc. poco a poco" g'4-. d''4-. | % m. 131; MIDI bar 131
\barNumberCheck #132 g'4-. d''4-. g'4-. | % m. 132; MIDI bar 132
\barNumberCheck #133 d''4-. g'4-. d''4-. | % m. 133; MIDI bar 133
\barNumberCheck #134 g'4-. d''4-. g'4-. | % m. 134; MIDI bar 134
\barNumberCheck #135 d''4-. g'4-. d''4-. | % m. 135; MIDI bar 135
\barNumberCheck #136 g'4-. d''4-. g'4-. | % m. 136; MIDI bar 136
\barNumberCheck #137 d''4-. g'4-. d''4-. | % m. 137; MIDI bar 137
\barNumberCheck #138 g'4-._\markup \italic "cresc." d''4-. g'4-. | % m. 138; MIDI bar 138
\barNumberCheck #139 d''4-.\f g'4-. d''4-. | % m. 139; MIDI bar 139
\barNumberCheck #140 g'4\<-. d''4-. g'4-. | % m. 140; MIDI bar 140
\barNumberCheck #141 d''4-. g'4-. d''4-. <>\! | % m. 141; MIDI bar 141
\barNumberCheck #142 r4 e''4\ff d''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 r4 g'4 c''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 r4 c'4 c''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 d''4 g'4 c''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 d''2-> d''4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c''2-> e''4 | % m. 147; MIDI bar 147
\barNumberCheck #148 c''2-> e''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 d''2-> d''4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 r4 g'4\ff d''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 r4 c''4 e''4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''2. | % m. 160; MIDI bar 160
\barNumberCheck #161 e''4-. e'4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 e''2(\p->^\markup \italic "Soli" d''4) | % m. 162; MIDI bar 162
\barNumberCheck #163 f''2(-> e''4) | % m. 163; MIDI bar 163
\barNumberCheck #164 a''2(-> g''4) | % m. 164; MIDI bar 164
\barNumberCheck #165 f''2(-> e''4) | % m. 165; MIDI bar 165
\barNumberCheck #166 r4 c''4\f c'4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 d''4 e''4 | % m. 167; MIDI bar 167
\barNumberCheck #168 r4 d''4 c''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 r4 g'4 c''4 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 f''4 f''4 | % m. 170; MIDI bar 170
\barNumberCheck #171 r4 e''4 e''4 | % m. 171; MIDI bar 171
\barNumberCheck #172 r4 f''4 f''4 | % m. 172; MIDI bar 172
\barNumberCheck #173 r4 e''4 e''4 | % m. 173; MIDI bar 173
\barNumberCheck #174 c''4 r4 r4 | % m. 174; MIDI bar 174
\barNumberCheck #175 R2. | % m. 175; MIDI bar 175
\barNumberCheck #176 R2. | % m. 176; MIDI bar 176
\barNumberCheck #177 R2. | % m. 177; MIDI bar 177
\barNumberCheck #178 R2. | % m. 178; MIDI bar 178
\barNumberCheck #179 R2. | % m. 179; MIDI bar 179
\barNumberCheck #180 c''2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 c''2. | % m. 181; MIDI bar 181
\barNumberCheck #182 c''2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 c''4 c''4-. d''4-. | % m. 183; MIDI bar 183
\barNumberCheck #184 ees''2.~ | % m. 184; MIDI bar 184
\barNumberCheck #185 ees''4 c''4-. d''4-. | % m. 185; MIDI bar 185
\barNumberCheck #186 ees''4 c''4 d''4 | % m. 186; MIDI bar 186
\barNumberCheck #187 ees''4 c''4 d''4 | % m. 187; MIDI bar 187
\barNumberCheck #188 ees''4 c''4 d''4 | % m. 188; MIDI bar 188
\barNumberCheck #189 ees''4\< f''4 fis''4 | % m. 189; MIDI bar 189
\barNumberCheck #190 g''4\ff-> c'4 e'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 e'2-> g'4 | % m. 191; MIDI bar 191
\barNumberCheck #192 g'2-> c''4 | % m. 192; MIDI bar 192
\barNumberCheck #193 c''2-> e''4 | % m. 193; MIDI bar 193
\barNumberCheck #194 d''2. | % m. 194; MIDI bar 194
\barNumberCheck #195 d''4 d''4 d''4 | % m. 195; MIDI bar 195
\barNumberCheck #196 d''2-> e''4 | % m. 196; MIDI bar 196
\barNumberCheck #197 d''2-> c''4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g'2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 c''4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
hornTwoIV = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c'2\f-> g4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g2-> c'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c'2-> c'4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g2-> c'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 d''2-> d''4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c''2-> e''4 | % m. 9; MIDI bar 9
\barNumberCheck #10 c''2-> g'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 c''2-> g'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 g'2\pp g'4 | % m. 12; MIDI bar 12
\barNumberCheck #13 g'2 g'4 | % m. 13; MIDI bar 13
\barNumberCheck #14 c'2 c'4 | % m. 14; MIDI bar 14
\barNumberCheck #15 g2 c'4 | % m. 15; MIDI bar 15
\barNumberCheck #16  R2. | % m. 16; MIDI bar 16
\barNumberCheck #17  R2. | % m. 17; MIDI bar 17
\barNumberCheck #18 r2 e'4 | % m. 18; MIDI bar 18
\barNumberCheck #19 c''2 b'4 | % m. 19; MIDI bar 19
\barNumberCheck #20 d''2->\ff d''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c''2-> b'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 R2. | % m. 22; MIDI bar 22
\barNumberCheck #23 e'2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 c'2->\ff c'4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d''2-> e''4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d''2-> c''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 g2-> c'4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 d''2->\ff d''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 c''2-> b'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 R2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e'2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 c'2->\ff c'4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d''2-> e''4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d''2-> c''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 g2-> c'4 | % m. 45; MIDI bar 45
\barNumberCheck #46 g2-> c'4 | % m. 46; MIDI bar 46
\barNumberCheck #47 g'2-> e'4 | % m. 47; MIDI bar 47
\barNumberCheck #48 g2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c'4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c4\pp c4 c4->~ | % m. 50; MIDI bar 50
\barNumberCheck #51 c4 c4 c4->~ | % m. 51; MIDI bar 51
\barNumberCheck #52 c4 c4 c4->~ | % m. 52; MIDI bar 52
\barNumberCheck #53 c4 c4 c4->~ | % m. 53; MIDI bar 53
\barNumberCheck #54 c4 c4 c4->~ | % m. 54; MIDI bar 54
\barNumberCheck #55 c4 c4 c4->~ | % m. 55; MIDI bar 55
\barNumberCheck #56 c4 c4 c4->~ | % m. 56; MIDI bar 56
\barNumberCheck #57 c4 c4 c4-> | % m. 57; MIDI bar 57
\barNumberCheck #58 g2.~ | % m. 58; MIDI bar 58
\barNumberCheck #59 g2 g4 | % m. 59; MIDI bar 59
\barNumberCheck #60 c'2 c'4 | % m. 60; MIDI bar 60
\barNumberCheck #61 c'4 r4 c'4 | % m. 61; MIDI bar 61
\barNumberCheck #62 g2.~ | % m. 62; MIDI bar 62
\barNumberCheck #63 g2 g4 | % m. 63; MIDI bar 63
\barNumberCheck #64 c'2 c'4 | % m. 64; MIDI bar 64
\barNumberCheck #65 c'4 r4 c'4 | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 R2. | % m. 70; MIDI bar 70
\barNumberCheck #71 R2. | % m. 71; MIDI bar 71
\barNumberCheck #72 R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 R2. | % m. 77; MIDI bar 77
\barNumberCheck #78 R2. | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 c'2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 c'2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e'4\ff e'8 e'8 e'4 | % m. 84; MIDI bar 84
\barNumberCheck #85 e'4 e'8 e'8 e'4 | % m. 85; MIDI bar 85
\barNumberCheck #86 e'4 e'8 e'8 e'4 | % m. 86; MIDI bar 86
\barNumberCheck #87 e'4 e'8 e'8 e'4 | % m. 87; MIDI bar 87
\barNumberCheck #88 e'4 e'8 e'8 e'4 | % m. 88; MIDI bar 88
\barNumberCheck #89 e'4 e'8 e'8 e'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 e'4 e'8 e'8 e'4 | % m. 90; MIDI bar 90
\barNumberCheck #91 e'4 e'8 e'8 e'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 e'4 e'8 e'8 e'4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e'4 e'8 e'8 e'4 | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4 e'8 e'8 e'4 | % m. 94; MIDI bar 94
\barNumberCheck #95 e'4 e'8 e'8 e'4 | % m. 95; MIDI bar 95
\barNumberCheck #96 e'4 e'8 e'8 e'4 | % m. 96; MIDI bar 96
\barNumberCheck #97 e'4 e'8 e'8 e'4 | % m. 97; MIDI bar 97
\barNumberCheck #98 e'4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99  R2. | % m. 99; MIDI bar 99
\barNumberCheck #100  R2. | % m. 100; MIDI bar 100
\barNumberCheck #101  R2. | % m. 101; MIDI bar 101
\barNumberCheck #102  R2. | % m. 102; MIDI bar 102
\barNumberCheck #103  R2. | % m. 103; MIDI bar 103
\barNumberCheck #104  R2. | % m. 104; MIDI bar 104
\barNumberCheck #105  R2. | % m. 105; MIDI bar 105
\barNumberCheck #106  R2. | % m. 106; MIDI bar 106
\barNumberCheck #107  R2. | % m. 107; MIDI bar 107
\barNumberCheck #108  R2. | % m. 108; MIDI bar 108
\barNumberCheck #109  R2. | % m. 109; MIDI bar 109
\barNumberCheck #110  R2. | % m. 110; MIDI bar 110
\barNumberCheck #111  R2. | % m. 111; MIDI bar 111
\barNumberCheck #112  R2. | % m. 112; MIDI bar 112
\barNumberCheck #113  R2. | % m. 113; MIDI bar 113
\barNumberCheck #114  R2. | % m. 114; MIDI bar 114
\barNumberCheck #115  R2. | % m. 115; MIDI bar 115
\barNumberCheck #116  R2. | % m. 116; MIDI bar 116
\barNumberCheck #117  R2. | % m. 117; MIDI bar 117
\barNumberCheck #118  R2. | % m. 118; MIDI bar 118
\barNumberCheck #119  R2. | % m. 119; MIDI bar 119
\barNumberCheck #120  R2. | % m. 120; MIDI bar 120
\barNumberCheck #121  R2. | % m. 121; MIDI bar 121
\barNumberCheck #122  R2. | % m. 122; MIDI bar 122
\barNumberCheck #123  R2. | % m. 123; MIDI bar 123
\barNumberCheck #124  R2. | % m. 124; MIDI bar 124
\barNumberCheck #125  R2. | % m. 125; MIDI bar 125
\barNumberCheck #126  R2. | % m. 126; MIDI bar 126
\barNumberCheck #127  R2. | % m. 127; MIDI bar 127
\barNumberCheck #128  R2. | % m. 128; MIDI bar 128
\barNumberCheck #129  R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130  R2. | % m. 130; MIDI bar 130
\barNumberCheck #131  R2. | % m. 131; MIDI bar 131
\barNumberCheck #132  R2. | % m. 132; MIDI bar 132
\barNumberCheck #133  R2. | % m. 133; MIDI bar 133
\barNumberCheck #134  R2. | % m. 134; MIDI bar 134
\barNumberCheck #135  R2. | % m. 135; MIDI bar 135
\barNumberCheck #136  R2. | % m. 136; MIDI bar 136
\barNumberCheck #137  R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 g'4-.\p d''4-. g'4-. | % m. 138; MIDI bar 138
\barNumberCheck #139 d''4-.\f g'4-. d''4-. | % m. 139; MIDI bar 139
\barNumberCheck #140 g'4\<-. d''4-. g'4-. | % m. 140; MIDI bar 140
\barNumberCheck #141 d''4-. g'4-. d''4-. <>\! | % m. 141; MIDI bar 141
\barNumberCheck #142 r4 c'4\ff g4 | % m. 142; MIDI bar 142
\barNumberCheck #143 r4 g4 c'4 | % m. 143; MIDI bar 143
\barNumberCheck #144 r4 c4 c'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 g'4 g4 c'4 | % m. 145; MIDI bar 145
\barNumberCheck #146 c''2-> g'4 | % m. 146; MIDI bar 146
\barNumberCheck #147 e'2-> e'4 | % m. 147; MIDI bar 147
\barNumberCheck #148 e'2-> e'4 | % m. 148; MIDI bar 148
\barNumberCheck #149 c''2-> g4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 r4 g4\ff d''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 r4 c'4 e'4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''2. | % m. 160; MIDI bar 160
\barNumberCheck #161 e''4-. e'4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 c''2(\p->^\markup \italic "Soli" b'4) | % m. 162; MIDI bar 162
\barNumberCheck #163 d''2(-> c''4) | % m. 163; MIDI bar 163
\barNumberCheck #164 f''2(-> e''4) | % m. 164; MIDI bar 164
\barNumberCheck #165 b'2(-> c''4) | % m. 165; MIDI bar 165
\barNumberCheck #166 r4 c'4\f c4 | % m. 166; MIDI bar 166
\barNumberCheck #167 r4 d''4 e'4 | % m. 167; MIDI bar 167
\barNumberCheck #168 r4 d''4 e'4 | % m. 168; MIDI bar 168
\barNumberCheck #169 r4 g4 c'4 | % m. 169; MIDI bar 169
\barNumberCheck #170 g4 g'4 g'4 | % m. 170; MIDI bar 170
\barNumberCheck #171 g4 g'4 g'4 | % m. 171; MIDI bar 171
\barNumberCheck #172 g4 g'4 g'4 | % m. 172; MIDI bar 172
\barNumberCheck #173 g4 g'4 g'4 | % m. 173; MIDI bar 173
\barNumberCheck #174 c'4 r4 r4 | % m. 174; MIDI bar 174
\barNumberCheck #175 R2. | % m. 175; MIDI bar 175
\barNumberCheck #176 R2. | % m. 176; MIDI bar 176
\barNumberCheck #177 R2. | % m. 177; MIDI bar 177
\barNumberCheck #178 R2. | % m. 178; MIDI bar 178
\barNumberCheck #179 R2. | % m. 179; MIDI bar 179
\barNumberCheck #180  R2. | % m. 180; MIDI bar 180
\barNumberCheck #181  R2. | % m. 181; MIDI bar 181
\barNumberCheck #182 c'2.\f | % m. 182; MIDI bar 182
\barNumberCheck #183 c'2. | % m. 183; MIDI bar 183
\barNumberCheck #184 c'2. | % m. 184; MIDI bar 184
\barNumberCheck #185 c'2. | % m. 185; MIDI bar 185
\barNumberCheck #186 c'2. | % m. 186; MIDI bar 186
\barNumberCheck #187 c'2. | % m. 187; MIDI bar 187
\barNumberCheck #188 c'2. | % m. 188; MIDI bar 188
\barNumberCheck #189 c'4\< c'4 c'4 | % m. 189; MIDI bar 189
\barNumberCheck #190 g2\ff-> c'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 c'2-> e'4 | % m. 191; MIDI bar 191
\barNumberCheck #192 e'2-> g'4 | % m. 192; MIDI bar 192
\barNumberCheck #193 g'2-> c''4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g2. | % m. 194; MIDI bar 194
\barNumberCheck #195 g4 g4 g4 | % m. 195; MIDI bar 195
\barNumberCheck #196 g2-> c'4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g'2-> e'4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g2.\sf | % m. 198; MIDI bar 198
\barNumberCheck #199 c'4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
trumpetOneIV = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c''2\f-> g'4 | % m. 4; MIDI bar 4
\barNumberCheck #5 d''2-> c''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c''2-> c''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 d''4-> g'4 c''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 d''2-> d''4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c''2-> e''4 | % m. 9; MIDI bar 9
\barNumberCheck #10 e''2-> e''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 d''2-> g'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 R2. | % m. 17; MIDI bar 17
\barNumberCheck #18 R2. | % m. 18; MIDI bar 18
\barNumberCheck #19 R2. | % m. 19; MIDI bar 19
\barNumberCheck #20 g'2->\ff d''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c''2-> e''4 | % m. 21; MIDI bar 21
\barNumberCheck #22 R2. | % m. 22; MIDI bar 22
\barNumberCheck #23 e'4-. e'4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 g'2.\pp~ | % m. 24; MIDI bar 24
\barNumberCheck #25 g'2. | % m. 25; MIDI bar 25
\barNumberCheck #26 c''2. | % m. 26; MIDI bar 26
\barNumberCheck #27 g'2 g'4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c''2->\ff c''4 | % m. 28; MIDI bar 28
\barNumberCheck #29 R2. | % m. 29; MIDI bar 29
\barNumberCheck #30 d''2-> c''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 r4 g'4 c''4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g'2->\ff d''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 c''2-> e''4 | % m. 35; MIDI bar 35
\barNumberCheck #36 R2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e'4-. e'4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 g'2.\pp~ | % m. 38; MIDI bar 38
\barNumberCheck #39 g'2. | % m. 39; MIDI bar 39
\barNumberCheck #40 c''2. | % m. 40; MIDI bar 40
\barNumberCheck #41 g'2 g'4 | % m. 41; MIDI bar 41
\barNumberCheck #42 c''2->\ff c''4 | % m. 42; MIDI bar 42
\barNumberCheck #43 R2. | % m. 43; MIDI bar 43
\barNumberCheck #44 d''2-> c''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 g'2-> c''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 d''2-> e''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 g'2-> c''4 | % m. 47; MIDI bar 47
\barNumberCheck #48 d''2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 e''4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c'2.\pp~ | % m. 50; MIDI bar 50
\barNumberCheck #51 c'2.~ | % m. 51; MIDI bar 51
\barNumberCheck #52 c'2.~ | % m. 52; MIDI bar 52
\barNumberCheck #53 c'2.~ | % m. 53; MIDI bar 53
\barNumberCheck #54 c'2.~ | % m. 54; MIDI bar 54
\barNumberCheck #55 c'2.~ | % m. 55; MIDI bar 55
\barNumberCheck #56 c'2.~ | % m. 56; MIDI bar 56
\barNumberCheck #57 c'2 r4 | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 R2. | % m. 70; MIDI bar 70
\barNumberCheck #71 R2. | % m. 71; MIDI bar 71
\barNumberCheck #72 R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 R2. | % m. 77; MIDI bar 77
\barNumberCheck #78 R2. | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 R2. | % m. 82; MIDI bar 82
\barNumberCheck #83 R2. | % m. 83; MIDI bar 83
\barNumberCheck #84 r4 e''8\ff e''8 e''4 | % m. 84; MIDI bar 84
\barNumberCheck #85 e''4 e''8 e''8 e''4 | % m. 85; MIDI bar 85
\barNumberCheck #86 e''4 e''8 e''8 e''4 | % m. 86; MIDI bar 86
\barNumberCheck #87 e''4 e''8 e''8 e''4 | % m. 87; MIDI bar 87
\barNumberCheck #88 e''4 e''8 e''8 e''4 | % m. 88; MIDI bar 88
\barNumberCheck #89 e''4 e''8 e''8 e''4 | % m. 89; MIDI bar 89
\barNumberCheck #90 e''4 e''8 e''8 e''4 | % m. 90; MIDI bar 90
\barNumberCheck #91 e''4 e''8 e''8 e''4 | % m. 91; MIDI bar 91
\barNumberCheck #92 e''4 e''8 e''8 e''4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e''4 e''8 e''8 e''4 | % m. 93; MIDI bar 93
\barNumberCheck #94 e''4 e''8 e''8 e''4 | % m. 94; MIDI bar 94
\barNumberCheck #95 e''4 e''8 e''8 e''4 | % m. 95; MIDI bar 95
\barNumberCheck #96 e''4 e''8 e''8 e''4 | % m. 96; MIDI bar 96
\barNumberCheck #97 e''4 e''8 e''8 e''4 | % m. 97; MIDI bar 97
\barNumberCheck #98 e''4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 e''2\ff-> d''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 d''2-> e''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 c''2-> c''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 g'4 d''4 c''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 d''2-> d''4 | % m. 146; MIDI bar 146
\barNumberCheck #147 e''2-> e''4 | % m. 147; MIDI bar 147
\barNumberCheck #148 e''2-> e''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 d''2-> g'4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 d''2\ff-> d''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 c''2-> e''4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''4 r4 r4 | % m. 160; MIDI bar 160
\barNumberCheck #161 e'4-. e'4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 c''2\f-> c''4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d''2-> e''4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d''2-> c''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 d''2-> c''4 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 d''4 d''4 | % m. 170; MIDI bar 170
\barNumberCheck #171 r4 e''4 c''4 | % m. 171; MIDI bar 171
\barNumberCheck #172 r4 d''4 d''4 | % m. 172; MIDI bar 172
\barNumberCheck #173 r4 c''4 e''4 | % m. 173; MIDI bar 173
\barNumberCheck #174 R2. | % m. 174; MIDI bar 174
\barNumberCheck #175 R2. | % m. 175; MIDI bar 175
\barNumberCheck #176 R2. | % m. 176; MIDI bar 176
\barNumberCheck #177 R2. | % m. 177; MIDI bar 177
\barNumberCheck #178 R2. | % m. 178; MIDI bar 178
\barNumberCheck #179 R2. | % m. 179; MIDI bar 179
\barNumberCheck #180 R2. | % m. 180; MIDI bar 180
\barNumberCheck #181 R2. | % m. 181; MIDI bar 181
\barNumberCheck #182 c'2.~ | % m. 182; MIDI bar 182
\barNumberCheck #183 c'4 r4 r4 | % m. 183; MIDI bar 183
\barNumberCheck #184 R2. | % m. 184; MIDI bar 184
\barNumberCheck #185 R2. | % m. 185; MIDI bar 185
\barNumberCheck #186 c'2.~ | % m. 186; MIDI bar 186
\barNumberCheck #187 c'2. | % m. 187; MIDI bar 187
\barNumberCheck #188 c'4 c'4 c'4 | % m. 188; MIDI bar 188
\barNumberCheck #189 c'4\< c'4 c'4 | % m. 189; MIDI bar 189
\barNumberCheck #190 e''2\ff-> c''4 | % m. 190; MIDI bar 190
\barNumberCheck #191 c''2-> g'4 | % m. 191; MIDI bar 191
\barNumberCheck #192 g'2-> e'4 | % m. 192; MIDI bar 192
\barNumberCheck #193 e'2-> c'4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g'2.-> | % m. 194; MIDI bar 194
\barNumberCheck #195 g'4 g'4 g'4 | % m. 195; MIDI bar 195
\barNumberCheck #196 g'2-> c''4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g'2-> c''4 | % m. 197; MIDI bar 197
\barNumberCheck #198 d''2.\sf | % m. 198; MIDI bar 198
\barNumberCheck #199 c''4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
trumpetTwoIV = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c'2\f-> g4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'2-> e'4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c'2-> c'4 | % m. 6; MIDI bar 6
\barNumberCheck #7 g2-> c'4 | % m. 7; MIDI bar 7
\barNumberCheck #8 d''2-> g'4 | % m. 8; MIDI bar 8
\barNumberCheck #9 e'2-> e'4 | % m. 9; MIDI bar 9
\barNumberCheck #10 e'2-> e'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 d''2-> g'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 R2. | % m. 17; MIDI bar 17
\barNumberCheck #18 R2. | % m. 18; MIDI bar 18
\barNumberCheck #19 R2. | % m. 19; MIDI bar 19
\barNumberCheck #20 g2->\ff d''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 e'2-> e'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 R2. | % m. 22; MIDI bar 22
\barNumberCheck #23 e'4-. e'4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 g2.\pp~ | % m. 24; MIDI bar 24
\barNumberCheck #25 g2. | % m. 25; MIDI bar 25
\barNumberCheck #26 c'2. | % m. 26; MIDI bar 26
\barNumberCheck #27 g2 c'4 | % m. 27; MIDI bar 27
\barNumberCheck #28 c'2->\ff c'4 | % m. 28; MIDI bar 28
\barNumberCheck #29 R2. | % m. 29; MIDI bar 29
\barNumberCheck #30 d''2-> e'4 | % m. 30; MIDI bar 30
\barNumberCheck #31 r4 g4 c'4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g2->\ff d''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 e'2-> e'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 R2. | % m. 36; MIDI bar 36
\barNumberCheck #37 e'4-. e'4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 g2.\pp~ | % m. 38; MIDI bar 38
\barNumberCheck #39 g2. | % m. 39; MIDI bar 39
\barNumberCheck #40 c'2. | % m. 40; MIDI bar 40
\barNumberCheck #41 g2 c'4 | % m. 41; MIDI bar 41
\barNumberCheck #42 c'2->\ff c'4 | % m. 42; MIDI bar 42
\barNumberCheck #43 R2. | % m. 43; MIDI bar 43
\barNumberCheck #44 d''2-> e'4 | % m. 44; MIDI bar 44
\barNumberCheck #45 g2-> c'4 | % m. 45; MIDI bar 45
\barNumberCheck #46 g'2-> g'4 | % m. 46; MIDI bar 46
\barNumberCheck #47 g2-> c'4 | % m. 47; MIDI bar 47
\barNumberCheck #48 g'2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c'4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c'2.\pp~ | % m. 50; MIDI bar 50
\barNumberCheck #51 c'2.~ | % m. 51; MIDI bar 51
\barNumberCheck #52 c'2.~ | % m. 52; MIDI bar 52
\barNumberCheck #53 c'2.~ | % m. 53; MIDI bar 53
\barNumberCheck #54 c'2.~ | % m. 54; MIDI bar 54
\barNumberCheck #55 c'2.~ | % m. 55; MIDI bar 55
\barNumberCheck #56 c'2.~ | % m. 56; MIDI bar 56
\barNumberCheck #57 c'2 r4 | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 R2. | % m. 70; MIDI bar 70
\barNumberCheck #71 R2. | % m. 71; MIDI bar 71
\barNumberCheck #72 R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 R2. | % m. 77; MIDI bar 77
\barNumberCheck #78 R2. | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 R2. | % m. 82; MIDI bar 82
\barNumberCheck #83 R2. | % m. 83; MIDI bar 83
\barNumberCheck #84 r4 e'8\ff e'8 e'4 | % m. 84; MIDI bar 84
\barNumberCheck #85 e'4 e'8 e'8 e'4 | % m. 85; MIDI bar 85
\barNumberCheck #86 e'4 e'8 e'8 e'4 | % m. 86; MIDI bar 86
\barNumberCheck #87 e'4 e'8 e'8 e'4 | % m. 87; MIDI bar 87
\barNumberCheck #88 e'4 e'8 e'8 e'4 | % m. 88; MIDI bar 88
\barNumberCheck #89 e'4 e'8 e'8 e'4 | % m. 89; MIDI bar 89
\barNumberCheck #90 e'4 e'8 e'8 e'4 | % m. 90; MIDI bar 90
\barNumberCheck #91 e'4 e'8 e'8 e'4 | % m. 91; MIDI bar 91
\barNumberCheck #92 e'4 e'8 e'8 e'4 | % m. 92; MIDI bar 92
\barNumberCheck #93 e'4 e'8 e'8 e'4 | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4 e'8 e'8 e'4 | % m. 94; MIDI bar 94
\barNumberCheck #95 e'4 e'8 e'8 e'4 | % m. 95; MIDI bar 95
\barNumberCheck #96 e'4 e'8 e'8 e'4 | % m. 96; MIDI bar 96
\barNumberCheck #97 e'4 e'8 e'8 e'4 | % m. 97; MIDI bar 97
\barNumberCheck #98 e'4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 g'2\ff-> g'4 | % m. 142; MIDI bar 142
\barNumberCheck #143 g'2-> g'4 | % m. 143; MIDI bar 143
\barNumberCheck #144 c'2-> c'4 | % m. 144; MIDI bar 144
\barNumberCheck #145 g4 g'4 g'4 | % m. 145; MIDI bar 145
\barNumberCheck #146 d''2-> d''4 | % m. 146; MIDI bar 146
\barNumberCheck #147 e''2-> e'4 | % m. 147; MIDI bar 147
\barNumberCheck #148 e'2-> g'4 | % m. 148; MIDI bar 148
\barNumberCheck #149 d''2-> g'4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g'2\ff-> d''4 | % m. 158; MIDI bar 158
\barNumberCheck #159 e'2-> e'4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''4 r4 r4 | % m. 160; MIDI bar 160
\barNumberCheck #161 e'4-. e'4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 c'2\f-> c'4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d''2-> e''4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d''2-> c''4 | % m. 168; MIDI bar 168
\barNumberCheck #169 g'2-> e'4 | % m. 169; MIDI bar 169
\barNumberCheck #170 r4 g'4 g'4 | % m. 170; MIDI bar 170
\barNumberCheck #171 r4 g'4 e'4 | % m. 171; MIDI bar 171
\barNumberCheck #172 r4 g'4 g'4 | % m. 172; MIDI bar 172
\barNumberCheck #173 r4 e'4 c'4 | % m. 173; MIDI bar 173
\barNumberCheck #174 R2. | % m. 174; MIDI bar 174
\barNumberCheck #175 R2. | % m. 175; MIDI bar 175
\barNumberCheck #176 R2. | % m. 176; MIDI bar 176
\barNumberCheck #177 R2. | % m. 177; MIDI bar 177
\barNumberCheck #178 R2. | % m. 178; MIDI bar 178
\barNumberCheck #179 R2. | % m. 179; MIDI bar 179
\barNumberCheck #180 R2. | % m. 180; MIDI bar 180
\barNumberCheck #181 R2. | % m. 181; MIDI bar 181
\barNumberCheck #182 c'2.~ | % m. 182; MIDI bar 182
\barNumberCheck #183 c'4 r4 r4 | % m. 183; MIDI bar 183
\barNumberCheck #184 R2. | % m. 184; MIDI bar 184
\barNumberCheck #185 R2. | % m. 185; MIDI bar 185
\barNumberCheck #186 R2. | % m. 186; MIDI bar 186
\barNumberCheck #187 R2. | % m. 187; MIDI bar 187
\barNumberCheck #188 c'4 c'4 c'4 | % m. 188; MIDI bar 188
\barNumberCheck #189 c'4\< c'4 c'4 | % m. 189; MIDI bar 189
\barNumberCheck #190 c''2\ff-> g'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g'2-> e'4 | % m. 191; MIDI bar 191
\barNumberCheck #192 e'2-> c'4 | % m. 192; MIDI bar 192
\barNumberCheck #193 c'2-> g4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g2.-> | % m. 194; MIDI bar 194
\barNumberCheck #195 g4 g4 g4 | % m. 195; MIDI bar 195
\barNumberCheck #196 g2-> e'4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g2-> c'4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g'2.\sf | % m. 198; MIDI bar 198
\barNumberCheck #199 e'4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
timpaniIV = {
\barNumberCheck #1 R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 R2. | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c4\ff r4 g,4 | % m. 4; MIDI bar 4
\barNumberCheck #5 g,4 r4 c4 | % m. 5; MIDI bar 5
\barNumberCheck #6 c2.:32 | % m. 6; MIDI bar 6
\barNumberCheck #7 g,4 g,4 c4 | % m. 7; MIDI bar 7
\barNumberCheck #8 R2. | % m. 8; MIDI bar 8
\barNumberCheck #9 R2. | % m. 9; MIDI bar 9
\barNumberCheck #10 R2. | % m. 10; MIDI bar 10
\barNumberCheck #11 R2. | % m. 11; MIDI bar 11
\barNumberCheck #12 R2. | % m. 12; MIDI bar 12
\barNumberCheck #13 R2. | % m. 13; MIDI bar 13
\barNumberCheck #14 R2. | % m. 14; MIDI bar 14
\barNumberCheck #15 R2. | % m. 15; MIDI bar 15
\barNumberCheck #16 R2. | % m. 16; MIDI bar 16
\barNumberCheck #17 R2. | % m. 17; MIDI bar 17
\barNumberCheck #18 R2. | % m. 18; MIDI bar 18
\barNumberCheck #19 R2. | % m. 19; MIDI bar 19
\barNumberCheck #20 g,2:32\ff r4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c2:32 r4 | % m. 21; MIDI bar 21
\barNumberCheck #22 R2. | % m. 22; MIDI bar 22
\barNumberCheck #23 r4 r4 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 c2:32\ff c4 | % m. 28; MIDI bar 28
\barNumberCheck #29 R2. | % m. 29; MIDI bar 29
\barNumberCheck #30 R2. | % m. 30; MIDI bar 30
\barNumberCheck #31 r4 g,4 c4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g,2:32\ff r4 | % m. 34; MIDI bar 34
\barNumberCheck #35 c2:32 r4 | % m. 35; MIDI bar 35
\barNumberCheck #36 R2. | % m. 36; MIDI bar 36
\barNumberCheck #37 r4 r4 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 r4 c4\pp g,4 | % m. 38; MIDI bar 38
\barNumberCheck #39 r4 g,4 c4 | % m. 39; MIDI bar 39
\barNumberCheck #40 r4 c4 c4 | % m. 40; MIDI bar 40
\barNumberCheck #41 r4 g,4 c4 | % m. 41; MIDI bar 41
\barNumberCheck #42 c2:32\ff c4 | % m. 42; MIDI bar 42
\barNumberCheck #43 R2. | % m. 43; MIDI bar 43
\barNumberCheck #44 R2. | % m. 44; MIDI bar 44
\barNumberCheck #45 g,2:32 c4 | % m. 45; MIDI bar 45
\barNumberCheck #46 g,4 r4 c4 | % m. 46; MIDI bar 46
\barNumberCheck #47 g,2 c4 | % m. 47; MIDI bar 47
\barNumberCheck #48 g,2.:32\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 c4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 R2. | % m. 66; MIDI bar 66
\barNumberCheck #67 R2. | % m. 67; MIDI bar 67
\barNumberCheck #68 R2. | % m. 68; MIDI bar 68
\barNumberCheck #69 R2. | % m. 69; MIDI bar 69
\barNumberCheck #70 R2. | % m. 70; MIDI bar 70
\barNumberCheck #71 R2. | % m. 71; MIDI bar 71
\barNumberCheck #72 R2. | % m. 72; MIDI bar 72
\barNumberCheck #73 R2. | % m. 73; MIDI bar 73
\barNumberCheck #74 R2. | % m. 74; MIDI bar 74
\barNumberCheck #75 R2. | % m. 75; MIDI bar 75
\barNumberCheck #76 R2. | % m. 76; MIDI bar 76
\barNumberCheck #77 R2. | % m. 77; MIDI bar 77
\barNumberCheck #78 R2. | % m. 78; MIDI bar 78
\barNumberCheck #79 R2. | % m. 79; MIDI bar 79
\barNumberCheck #80 R2. | % m. 80; MIDI bar 80
\barNumberCheck #81 R2. | % m. 81; MIDI bar 81
\barNumberCheck #82 R2. | % m. 82; MIDI bar 82
\barNumberCheck #83 R2. | % m. 83; MIDI bar 83
\barNumberCheck #84 R2. | % m. 84; MIDI bar 84
\barNumberCheck #85 R2. | % m. 85; MIDI bar 85
\barNumberCheck #86 R2. | % m. 86; MIDI bar 86
\barNumberCheck #87 R2. | % m. 87; MIDI bar 87
\barNumberCheck #88 R2. | % m. 88; MIDI bar 88
\barNumberCheck #89 R2. | % m. 89; MIDI bar 89
\barNumberCheck #90 R2. | % m. 90; MIDI bar 90
\barNumberCheck #91 R2. | % m. 91; MIDI bar 91
\barNumberCheck #92 R2. | % m. 92; MIDI bar 92
\barNumberCheck #93 R2. | % m. 93; MIDI bar 93
\barNumberCheck #94 R2. | % m. 94; MIDI bar 94
\barNumberCheck #95 R2. | % m. 95; MIDI bar 95
\barNumberCheck #96 R2. | % m. 96; MIDI bar 96
\barNumberCheck #97 R2. | % m. 97; MIDI bar 97
\barNumberCheck #98 R2. | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 c2:32\ff g,4 | % m. 142; MIDI bar 142
\barNumberCheck #143 g,2:32 c4 | % m. 143; MIDI bar 143
\barNumberCheck #144 c2.:32 | % m. 144; MIDI bar 144
\barNumberCheck #145 g,2:32 c4 | % m. 145; MIDI bar 145
\barNumberCheck #146 c2:32 g,4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c2:32 r4 | % m. 147; MIDI bar 147
\barNumberCheck #148 c2:32 g,4 | % m. 148; MIDI bar 148
\barNumberCheck #149 c2:32 g,4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g,2:32\ff r4 | % m. 158; MIDI bar 158
\barNumberCheck #159 c2:32 r4 | % m. 159; MIDI bar 159
\barNumberCheck #160 R2. | % m. 160; MIDI bar 160
\barNumberCheck #161 R2.\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 c2:32\ff c4 | % m. 166; MIDI bar 166
\barNumberCheck #167 R2. | % m. 167; MIDI bar 167
\barNumberCheck #168 r4 r4 c4 | % m. 168; MIDI bar 168
\barNumberCheck #169 g,2:32 c4 | % m. 169; MIDI bar 169
\barNumberCheck #170 g,2.:32 | % m. 170; MIDI bar 170
\barNumberCheck #171 g,2.:32 | % m. 171; MIDI bar 171
\barNumberCheck #172 g,2.:32 | % m. 172; MIDI bar 172
\barNumberCheck #173 g,2.:32 | % m. 173; MIDI bar 173
\barNumberCheck #174 c4 r4 r4 | % m. 174; MIDI bar 174
\barNumberCheck #175 R2. | % m. 175; MIDI bar 175
\barNumberCheck #176 R2. | % m. 176; MIDI bar 176
\barNumberCheck #177 R2. | % m. 177; MIDI bar 177
\barNumberCheck #178 R2. | % m. 178; MIDI bar 178
\barNumberCheck #179 R2. | % m. 179; MIDI bar 179
\barNumberCheck #180 R2. | % m. 180; MIDI bar 180
\barNumberCheck #181 R2. | % m. 181; MIDI bar 181
\barNumberCheck #182 c4 r4 r4 | % m. 182; MIDI bar 182
\barNumberCheck #183 R2. | % m. 183; MIDI bar 183
\barNumberCheck #184 c4 r4 r4 | % m. 184; MIDI bar 184
\barNumberCheck #185 R2. | % m. 185; MIDI bar 185
\barNumberCheck #186 R2. | % m. 186; MIDI bar 186
\barNumberCheck #187 R2. | % m. 187; MIDI bar 187
\barNumberCheck #188 R2. | % m. 188; MIDI bar 188
\barNumberCheck #189 R2. | % m. 189; MIDI bar 189
\barNumberCheck #190 g,2.:32->\ff | % m. 190; MIDI bar 190
\barNumberCheck #191 g,2.:32 | % m. 191; MIDI bar 191
\barNumberCheck #192 g,2.:32 | % m. 192; MIDI bar 192
\barNumberCheck #193 g,2.:32 | % m. 193; MIDI bar 193
\barNumberCheck #194 g,2.:32 | % m. 194; MIDI bar 194
\barNumberCheck #195 g,2.:32 | % m. 195; MIDI bar 195
\barNumberCheck #196 g,2:32 c4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g,2:32-> c4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g,2.:32\sf | % m. 198; MIDI bar 198
\barNumberCheck #199 c4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
violinOneIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c'8(\f d'8 e'8 f'8 g'4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 e''2\ff-> d''4 | % m. 4; MIDI bar 4
\barNumberCheck #5 f''2-> e''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 a''2-> g''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 f''2-> e''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 cis''8(-> d''8 e''8 fis''8 g''4-.) | % m. 8; MIDI bar 8
\barNumberCheck #9 e''8(-> fis''8 gis''8 a''8 b''4-.) | % m. 9; MIDI bar 9
\barNumberCheck #10 c'''2-> b''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 a''2-> g''4 | % m. 11; MIDI bar 11
\barNumberCheck #12 e''2->\pp d''4 | % m. 12; MIDI bar 12
\barNumberCheck #13 f''2-> e''4 | % m. 13; MIDI bar 13
\barNumberCheck #14 a''2-> g''4 | % m. 14; MIDI bar 14
\barNumberCheck #15 f''2-> e''4 | % m. 15; MIDI bar 15
\barNumberCheck #16 cis''8( d''8 e''8 fis''8 g''4-.) | % m. 16; MIDI bar 16
\barNumberCheck #17 e''8( fis''8 gis''8 a''8 b''4-.) | % m. 17; MIDI bar 17
\barNumberCheck #18 c'''2-> b''4 | % m. 18; MIDI bar 18
\barNumberCheck #19 a''2-> g''4 | % m. 19; MIDI bar 19
\barNumberCheck #20 <bes' g''>2->\ff <a' f''>4 | % m. 20; MIDI bar 20
\barNumberCheck #21 <a' e''>2-> e''4 | % m. 21; MIDI bar 21
\barNumberCheck #22 dis''2.-> | % m. 22; MIDI bar 22
\barNumberCheck #23 e''2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f''8(\ff g''8 a''8 b''8  c'''4-.) | % m. 28; MIDI bar 28
\barNumberCheck #29 d''8( e''8 f''8 g''8  a''4-.) | % m. 29; MIDI bar 29
\barNumberCheck #30 f''2-> e''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 d''2-> c''4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 <bes' g''>2->\ff <a' f''>4 | % m. 34; MIDI bar 34
\barNumberCheck #35 <a' e''>2-> e''4 | % m. 35; MIDI bar 35
\barNumberCheck #36 dis''2.-> | % m. 36; MIDI bar 36
\barNumberCheck #37 e''2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f''8(\ff g''8 a''8 b''8  c'''4-.) | % m. 42; MIDI bar 42
\barNumberCheck #43 d''8( e''8 f''8 g''8  a''4-.) | % m. 43; MIDI bar 43
\barNumberCheck #44 f''2-> e''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 d''2-> c''4 | % m. 45; MIDI bar 45
\barNumberCheck #46 f''2-> e''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 fis'8( g'8 a'8 b'8  c''4-.) | % m. 47; MIDI bar 47
\barNumberCheck #48 <b' g''>2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 <c'' e''>4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 c'2.\pp | % m. 50; MIDI bar 50
\barNumberCheck #51 e'2. | % m. 51; MIDI bar 51
\barNumberCheck #52 g'16 a'16 g'8 fis'4-. g'4-. | % m. 52; MIDI bar 52
\barNumberCheck #53 c''2 b'4 | % m. 53; MIDI bar 53
\barNumberCheck #54 \grace { g'16( a'16 b'16 } a'2) gis'4 | % m. 54; MIDI bar 54
\barNumberCheck #55 a'4-. b'4-. c''4-. | % m. 55; MIDI bar 55
\barNumberCheck #56 fis'2 g'4 | % m. 56; MIDI bar 56
\barNumberCheck #57 e'4 r4 r4 | % m. 57; MIDI bar 57
\barNumberCheck #58 d'2.~ | % m. 58; MIDI bar 58
\barNumberCheck #59 d'2. | % m. 59; MIDI bar 59
\barNumberCheck #60 g2. | % m. 60; MIDI bar 60
\barNumberCheck #61 c'4 r4 g4 | % m. 61; MIDI bar 61
\barNumberCheck #62 d'2.~ | % m. 62; MIDI bar 62
\barNumberCheck #63 d'2. | % m. 63; MIDI bar 63
\barNumberCheck #64 g2. | % m. 64; MIDI bar 64
\barNumberCheck #65 c'4 r4 g4 | % m. 65; MIDI bar 65
\barNumberCheck #66 fis'2\p fis'4 | % m. 66; MIDI bar 66
\barNumberCheck #67 fis'2 fis'4 | % m. 67; MIDI bar 67
\barNumberCheck #68 g'2 g'4 | % m. 68; MIDI bar 68
\barNumberCheck #69 g'2 g'4 | % m. 69; MIDI bar 69
\barNumberCheck #70 fis'2 fis'4 | % m. 70; MIDI bar 70
\barNumberCheck #71 fis'2 fis'4 | % m. 71; MIDI bar 71
\barNumberCheck #72 d'4( g'4) g'4 | % m. 72; MIDI bar 72
\barNumberCheck #73 g'2 d'4 | % m. 73; MIDI bar 73
\barNumberCheck #74 dis'2.~ | % m. 74; MIDI bar 74
\barNumberCheck #75 dis'2. | % m. 75; MIDI bar 75
\barNumberCheck #76 e'2. | % m. 76; MIDI bar 76
\barNumberCheck #77 b'4( a'4 g'4) | % m. 77; MIDI bar 77
\barNumberCheck #78 a'2 dis'4 | % m. 78; MIDI bar 78
\barNumberCheck #79 dis'2. | % m. 79; MIDI bar 79
\barNumberCheck #80 dis'2.~ | % m. 80; MIDI bar 80
\barNumberCheck #81 dis'2. | % m. 81; MIDI bar 81
\barNumberCheck #82 dis'2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 dis'2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e'4-.\ff e''4-. fis''4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis''4-. a''4-. b''4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'''4-. b''4-. a''4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a''4 b''4-. c'''4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b''4-. e''4-. e'''4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'''4-. c'''4-. b''4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a''4-. b''4-. c'''4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'''4 a''4-. dis''4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e''4-. e'''4-. d'''4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 c'''4-. b''4-. a''4-. | % m. 93; MIDI bar 93
\barNumberCheck #94 gis''4-. e'''4-. d'''4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 c'''4-. b''4-. a''4-. | % m. 95; MIDI bar 95
\barNumberCheck #96 gis''4-. e'''4-. e'''4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 e'''4-. e'''4-. e'''4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 e'''4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 g'8\<(\p a'8 b'8 c''8 d''8 e''8) | % m. 140; MIDI bar 140
\barNumberCheck #141 f''8( g''8 a''8 b''8 c'''8 d'''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 e'''2\ff-> d'''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 f'''2-> e'''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 a'''2-> g'''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 f'''2-> e'''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 cis''8( d''8 e''8 fis''8  g''4-.) | % m. 146; MIDI bar 146
\barNumberCheck #147 e''8( fis''8 gis''8 a''8  b''4-.) | % m. 147; MIDI bar 147
\barNumberCheck #148 c'''2-> b''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 a''2-> g''4 | % m. 149; MIDI bar 149
\barNumberCheck #150 c'8(\pp d'8 e'8 f'8 g'4~) | % m. 150; MIDI bar 150
\barNumberCheck #151 g'8( a'8 bes'8 b'8 c''4-.) | % m. 151; MIDI bar 151
\barNumberCheck #152 f'8( g'8 a'8 b'8  c''4-.) | % m. 152; MIDI bar 152
\barNumberCheck #153 d''4-. g'4-. c''4-. | % m. 153; MIDI bar 153
\barNumberCheck #154 fis'2 d'4( | % m. 154; MIDI bar 154
\barNumberCheck #155 e'2 gis'4) | % m. 155; MIDI bar 155
\barNumberCheck #156 a'2-> a'4 | % m. 156; MIDI bar 156
\barNumberCheck #157 a'2-> b'4 | % m. 157; MIDI bar 157
\barNumberCheck #158 <bes' g''>2\ff-> <a' f''>4 | % m. 158; MIDI bar 158
\barNumberCheck #159 <a' e''>2-> e''4 | % m. 159; MIDI bar 159
\barNumberCheck #160 dis''2.-> | % m. 160; MIDI bar 160
\barNumberCheck #161 e''2 r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f''8(\f g''8 a''8 b''8  c'''4) | % m. 166; MIDI bar 166
\barNumberCheck #167 d''8( e''8 f''8 g''8  a''4) | % m. 167; MIDI bar 167
\barNumberCheck #168 <a' f''>2-> <g' e''>4-> | % m. 168; MIDI bar 168
\barNumberCheck #169 <f' d''>2-> <e' c''>4 | % m. 169; MIDI bar 169
\barNumberCheck #170 d''8. g''16 fis''8. g''16 a''8. g''16 | % m. 170; MIDI bar 170
\barNumberCheck #171 e''8. g''16 fis''8. g''16 a''8. g''16 | % m. 171; MIDI bar 171
\barNumberCheck #172 d''8. g''16 fis''8. g''16 a''8. g''16 | % m. 172; MIDI bar 172
\barNumberCheck #173 e''8. g''16 fis''8. g''16 a''8. g''16 | % m. 173; MIDI bar 173
\barNumberCheck #174 a''4 a''4-.-> g''4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 f''4 f''4-.-> e''4-. | % m. 175; MIDI bar 175
\barNumberCheck #176 d''4 a''4-.-> g''4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 f''4 e''4-. f''4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 fis''2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 fis''2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a'8( bes'8 c''8 d''8  ees''4-.) | % m. 180; MIDI bar 180
\barNumberCheck #181 fis'8( g'8 a'8 bes'8  c''4-.) | % m. 181; MIDI bar 181
\barNumberCheck #182 c''4\f c''4-. d''4-. | % m. 182; MIDI bar 182
\barNumberCheck #183 ees''2.~ | % m. 183; MIDI bar 183
\barNumberCheck #184 ees''4 c'''4-. d'''4-. | % m. 184; MIDI bar 184
\barNumberCheck #185 ees'''2.~ | % m. 185; MIDI bar 185
\barNumberCheck #186 ees'''4-. c'''4-. d'''4-. | % m. 186; MIDI bar 186
\barNumberCheck #187 ees'''4-. c'''4-. d'''4-. | % m. 187; MIDI bar 187
\barNumberCheck #188 ees'''4-. c'''4-. d'''4-. | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'''4-.\< f'''4-. fis'''4-. | % m. 189; MIDI bar 189
\barNumberCheck #190 g'''2\ff-> e'''4 | % m. 190; MIDI bar 190
\barNumberCheck #191 e'''2-> c'''4 | % m. 191; MIDI bar 191
\barNumberCheck #192 c'''2-> g''4 | % m. 192; MIDI bar 192
\barNumberCheck #193 g''2-> e''4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g'8( a'8 b'8 c''8 d''8 c''8 | % m. 194; MIDI bar 194
\barNumberCheck #195 b'8 a'8 g'8 f'8 e'8 d'8 | % m. 195; MIDI bar 195
\barNumberCheck #196 c'8 b8 a8 g8) c'4 | % m. 196; MIDI bar 196
\barNumberCheck #197 fis''8( g''8 a''8 b''8  c'''4-.) | % m. 197; MIDI bar 197
\barNumberCheck #198 <b' g''>2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 <c'' e''>4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
violinTwoIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c'8(\f d'8 e'8 f'8 g'4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c''2\ff-> b'4 | % m. 4; MIDI bar 4
\barNumberCheck #5 d''2-> c''4 | % m. 5; MIDI bar 5
\barNumberCheck #6 f''2-> e''4 | % m. 6; MIDI bar 6
\barNumberCheck #7 b'2-> c''4 | % m. 7; MIDI bar 7
\barNumberCheck #8 a'2-> b'4 | % m. 8; MIDI bar 8
\barNumberCheck #9 a'2-> gis'4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a''2-> g''4 | % m. 10; MIDI bar 10
\barNumberCheck #11 c''2-> b'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 c''2->\pp b'4 | % m. 12; MIDI bar 12
\barNumberCheck #13 d''2-> c''4 | % m. 13; MIDI bar 13
\barNumberCheck #14 f''2-> e''4 | % m. 14; MIDI bar 14
\barNumberCheck #15 b'2-> c''4 | % m. 15; MIDI bar 15
\barNumberCheck #16 a'2-> b'4 | % m. 16; MIDI bar 16
\barNumberCheck #17 a'2-> gis'4 | % m. 17; MIDI bar 17
\barNumberCheck #18 <a' a''>2-> g''4 | % m. 18; MIDI bar 18
\barNumberCheck #19 c''2-> b'4 | % m. 19; MIDI bar 19
\barNumberCheck #20 d''2->\ff d''4 | % m. 20; MIDI bar 20
\barNumberCheck #21 c''2-> b'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 c''4(-> b'4 a'4) | % m. 22; MIDI bar 22
\barNumberCheck #23 gis'2 r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 a'2->\ff g'4 | % m. 28; MIDI bar 28
\barNumberCheck #29 f'2-> e'4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d''2-> c''4 | % m. 30; MIDI bar 30
\barNumberCheck #31 f'2-> e'4 | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 d''2->\ff d''4 | % m. 34; MIDI bar 34
\barNumberCheck #35 c''2-> b'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 c''4(-> b'4 a'4) | % m. 36; MIDI bar 36
\barNumberCheck #37 gis'2 r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 a'2->\ff g'4 | % m. 42; MIDI bar 42
\barNumberCheck #43 f'2-> e'4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d''2-> c''4 | % m. 44; MIDI bar 44
\barNumberCheck #45 f'2-> e'4 | % m. 45; MIDI bar 45
\barNumberCheck #46 d''2-> c''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 fis'8( g'8 a'8 b'8  c''4-.) | % m. 47; MIDI bar 47
\barNumberCheck #48 <f' d''>2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 <e' c''>4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 c'2.\pp | % m. 51; MIDI bar 51
\barNumberCheck #52 e'16 f'16 e'8 dis'4-. e'4-. | % m. 52; MIDI bar 52
\barNumberCheck #53 e'2 g'4 | % m. 53; MIDI bar 53
\barNumberCheck #54 \grace { e'16( f'16 g'16 } f'2) e'4 | % m. 54; MIDI bar 54
\barNumberCheck #55 f'4-. g'4-. a'4-. | % m. 55; MIDI bar 55
\barNumberCheck #56 dis'2 e'4 | % m. 56; MIDI bar 56
\barNumberCheck #57 c'4 r4 r4 | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 c'2\p c'4 | % m. 66; MIDI bar 66
\barNumberCheck #67 c'2 c'4 | % m. 67; MIDI bar 67
\barNumberCheck #68 b2 b4 | % m. 68; MIDI bar 68
\barNumberCheck #69 b2 b4 | % m. 69; MIDI bar 69
\barNumberCheck #70 c'2 c'4 | % m. 70; MIDI bar 70
\barNumberCheck #71 c'2 c'4 | % m. 71; MIDI bar 71
\barNumberCheck #72 b8( c'8 d'8 e'8 fis'8 g'8) | % m. 72; MIDI bar 72
\barNumberCheck #73 ais'8( b'8 c''8 b'8 g'4) | % m. 73; MIDI bar 73
\barNumberCheck #74 a2.~ | % m. 74; MIDI bar 74
\barNumberCheck #75 a2. | % m. 75; MIDI bar 75
\barNumberCheck #76 b2.~ | % m. 76; MIDI bar 76
\barNumberCheck #77 b2. | % m. 77; MIDI bar 77
\barNumberCheck #78 c'2 c'4 | % m. 78; MIDI bar 78
\barNumberCheck #79 c'2. | % m. 79; MIDI bar 79
\barNumberCheck #80 c'2.~ | % m. 80; MIDI bar 80
\barNumberCheck #81 c'2. | % m. 81; MIDI bar 81
\barNumberCheck #82 c'2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 c'2 a4 | % m. 83; MIDI bar 83
\barNumberCheck #84 gis4-.\ff e'4-. fis'4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis'4-. a'4-. b'4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c''4-. b'4-. a'4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a'4 b'4-. c''4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b'4-. e'4-. e''4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d''4-. c''4-. b'4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a'4-. b'4-. c''4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c''4 a'4-. dis'4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e'4-. e''4-. d''4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 c''4-. b'4-. a'4-. | % m. 93; MIDI bar 93
\barNumberCheck #94 gis'4-. e''4-. d''4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 c''4-. b'4-. a'4-. | % m. 95; MIDI bar 95
\barNumberCheck #96 gis'4-. <b' gis''>4-. <b' gis''>4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 <b' gis''>4-. <b' gis''>4-. <b' gis''>4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 <b' gis''>4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 b2.\pp~ | % m. 106; MIDI bar 106
\barNumberCheck #107 b2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 b2.~ | % m. 114; MIDI bar 114
\barNumberCheck #115 b2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 e'2.~ | % m. 117; MIDI bar 117
\barNumberCheck #118 e'2. | % m. 118; MIDI bar 118
\barNumberCheck #119 b2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 d'2.\pp~ | % m. 122; MIDI bar 122
\barNumberCheck #123 d'2.~ | % m. 123; MIDI bar 123
\barNumberCheck #124 d'2.~ | % m. 124; MIDI bar 124
\barNumberCheck #125 d'2.~ | % m. 125; MIDI bar 125
\barNumberCheck #126 d'2.~ | % m. 126; MIDI bar 126
\barNumberCheck #127 d'2.~ | % m. 127; MIDI bar 127
\barNumberCheck #128 d'2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 g8(\p\< a8 b8 c'8 d'8 e'8) | % m. 140; MIDI bar 140
\barNumberCheck #141 f'8( g'8 a'8 b'8 c''8 d''8) | % m. 141; MIDI bar 141
\barNumberCheck #142 e''4(\ff c'''4) b''4 | % m. 142; MIDI bar 142
\barNumberCheck #143 d'''2-> c'''4 | % m. 143; MIDI bar 143
\barNumberCheck #144 f'''2-> e'''4 | % m. 144; MIDI bar 144
\barNumberCheck #145 b''2-> c'''4 | % m. 145; MIDI bar 145
\barNumberCheck #146 a'2-> g'4 | % m. 146; MIDI bar 146
\barNumberCheck #147 a'2-> gis''4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a''2-> g''4 | % m. 148; MIDI bar 148
\barNumberCheck #149 c''2-> b'4 | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 c'2\p-> b4 | % m. 154; MIDI bar 154
\barNumberCheck #155 c'2-> b4 | % m. 155; MIDI bar 155
\barNumberCheck #156 a8( b8 c'8 d'8  e'4-.) | % m. 156; MIDI bar 156
\barNumberCheck #157 fis'4-. d'4-. g'4-. | % m. 157; MIDI bar 157
\barNumberCheck #158 <d' bes'>2\ff-> <d' a'>4 | % m. 158; MIDI bar 158
\barNumberCheck #159 a'2-> g'4 | % m. 159; MIDI bar 159
\barNumberCheck #160 c''4(-> b'4 a'4) | % m. 160; MIDI bar 160
\barNumberCheck #161 gis'2 r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 a'2\f-> g'4 | % m. 166; MIDI bar 166
\barNumberCheck #167 f'2-> e'4 | % m. 167; MIDI bar 167
\barNumberCheck #168 <f' d''>2-> <e' c''>4 | % m. 168; MIDI bar 168
\barNumberCheck #169 <d' b'>2-> <e' c''>4 | % m. 169; MIDI bar 169
\barNumberCheck #170 <d' b'>4 <d' b'>4 <d' b'>4 | % m. 170; MIDI bar 170
\barNumberCheck #171 <e' c''>4 <e' c''>4 <e' c''>4 | % m. 171; MIDI bar 171
\barNumberCheck #172 <d' b'>4 <d' b'>4 <d' b'>4 | % m. 172; MIDI bar 172
\barNumberCheck #173 <e' c''>4 <e' c''>4 <e' c''>4 | % m. 173; MIDI bar 173
\barNumberCheck #174 c''4 c''4-.-> c''4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 c''4 c''4-.-> c''4-. | % m. 175; MIDI bar 175
\barNumberCheck #176 c''4 c''4-.-> c''4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 c''4 c''4-. c''4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 <ees' c''>2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 <ees' c''>2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a'8( bes'8 c''8 d''8  ees''4-.) | % m. 180; MIDI bar 180
\barNumberCheck #181 fis'8( g'8 a'8 bes'8  c''4-.) | % m. 181; MIDI bar 181
\barNumberCheck #182 fis'2.\f->~ | % m. 182; MIDI bar 182
\barNumberCheck #183 fis'2. | % m. 183; MIDI bar 183
\barNumberCheck #184 fis'2. | % m. 184; MIDI bar 184
\barNumberCheck #185 fis'2. | % m. 185; MIDI bar 185
\barNumberCheck #186 fis'2. | % m. 186; MIDI bar 186
\barNumberCheck #187 fis'2. | % m. 187; MIDI bar 187
\barNumberCheck #188 fis'2. | % m. 188; MIDI bar 188
\barNumberCheck #189 ees''4-.\< f''4-. fis''4-. | % m. 189; MIDI bar 189
\barNumberCheck #190 g''4\ff-> e'''4 c'''4 | % m. 190; MIDI bar 190
\barNumberCheck #191 c'''2-> g''4 | % m. 191; MIDI bar 191
\barNumberCheck #192 g''2-> e''4 | % m. 192; MIDI bar 192
\barNumberCheck #193 e''2-> c''4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g'8( a'8 b'8 c''8 d''8 c''8 | % m. 194; MIDI bar 194
\barNumberCheck #195 b'8 a'8 g'8 f'8 e'8 d'8 | % m. 195; MIDI bar 195
\barNumberCheck #196 c'8 b8 a8 g8) c'4 | % m. 196; MIDI bar 196
\barNumberCheck #197 fis'8( g'8 a'8 b'8  c''4-.) | % m. 197; MIDI bar 197
\barNumberCheck #198 <f' d''>2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 <e' c''>4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 R2. | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
violaIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c8(\f d8 e8 f8 g4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c8(\ff d8 e8 f8 g4~) | % m. 4; MIDI bar 4
\barNumberCheck #5 g8( a8 bes8 b8 c'4-.) | % m. 5; MIDI bar 5
\barNumberCheck #6 f8(-> g8 a8 b8 c'4-.) | % m. 6; MIDI bar 6
\barNumberCheck #7 d'4-.-> g4-. c'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 fis'2-> d'4 | % m. 8; MIDI bar 8
\barNumberCheck #9 e'2-> e'4 | % m. 9; MIDI bar 9
\barNumberCheck #10 e'2-> e'4 | % m. 10; MIDI bar 10
\barNumberCheck #11 d'2-> d'4 | % m. 11; MIDI bar 11
\barNumberCheck #12 c8(->\pp d8 e8 f8 g4~) | % m. 12; MIDI bar 12
\barNumberCheck #13 g8(-> a8 bes8 b8 c'4-.) | % m. 13; MIDI bar 13
\barNumberCheck #14 f8(-> g8 a8 b8 c'4-.) | % m. 14; MIDI bar 14
\barNumberCheck #15 d'4-.-> g4-. c'4-. | % m. 15; MIDI bar 15
\barNumberCheck #16 fis'2-> d'4 | % m. 16; MIDI bar 16
\barNumberCheck #17 e'2-> e'4 | % m. 17; MIDI bar 17
\barNumberCheck #18 e'2-> e'4 | % m. 18; MIDI bar 18
\barNumberCheck #19 d'2-> d'4 | % m. 19; MIDI bar 19
\barNumberCheck #20 bes'2->\ff a'4 | % m. 20; MIDI bar 20
\barNumberCheck #21 a'2-> g'4 | % m. 21; MIDI bar 21
\barNumberCheck #22 f8( g8 a8 b8  c'4-.) | % m. 22; MIDI bar 22
\barNumberCheck #23 b4-. e4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f2->\ff e4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d2-> cis4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d8( e8 f8 g8  a4-.) | % m. 30; MIDI bar 30
\barNumberCheck #31 b4-. g4-. c'4-. | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 bes'2->\ff a'4 | % m. 34; MIDI bar 34
\barNumberCheck #35 a'2-> g'4 | % m. 35; MIDI bar 35
\barNumberCheck #36 f8( g8 a8 b8  c'4-.) | % m. 36; MIDI bar 36
\barNumberCheck #37 b4-. e4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f2->\ff e4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2-> cis4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d8( e8 f8 g8  a4-.) | % m. 44; MIDI bar 44
\barNumberCheck #45 b4-. g4-. c'4-. | % m. 45; MIDI bar 45
\barNumberCheck #46 b'2-> c''4 | % m. 46; MIDI bar 46
\barNumberCheck #47 fis'8( g'8 a'8 b'8 c''4-.) | % m. 47; MIDI bar 47
\barNumberCheck #48 <g d'>2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 <c c'>4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 d'2\p d'4 | % m. 66; MIDI bar 66
\barNumberCheck #67 d'2 d'4 | % m. 67; MIDI bar 67
\barNumberCheck #68 d'2 d'4 | % m. 68; MIDI bar 68
\barNumberCheck #69 d'2 d'4 | % m. 69; MIDI bar 69
\barNumberCheck #70 a2 a4 | % m. 70; MIDI bar 70
\barNumberCheck #71 a2 a4 | % m. 71; MIDI bar 71
\barNumberCheck #72 g2 b4 | % m. 72; MIDI bar 72
\barNumberCheck #73 g2 g4 | % m. 73; MIDI bar 73
\barNumberCheck #74 fis2.~ | % m. 74; MIDI bar 74
\barNumberCheck #75 fis2. | % m. 75; MIDI bar 75
\barNumberCheck #76 g2.~ | % m. 76; MIDI bar 76
\barNumberCheck #77 g4 a4 b4 | % m. 77; MIDI bar 77
\barNumberCheck #78 a2 a4 | % m. 78; MIDI bar 78
\barNumberCheck #79 a2. | % m. 79; MIDI bar 79
\barNumberCheck #80 a2.~ | % m. 80; MIDI bar 80
\barNumberCheck #81 a2. | % m. 81; MIDI bar 81
\barNumberCheck #82 a2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 a2. | % m. 83; MIDI bar 83
\barNumberCheck #84 b4-.\ff <e e'>4-.^\markup \upright "div." <fis fis'>4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 <gis gis'>4-. <a a'>4-. <b b'>4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 <c' c''>4-. <b b'>4-. <a a'>4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 <a a'>4 <b b'>4-. <c' c''>4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 <b b'>4-. <e e'>4-. <e' e''>4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 <d' d''>4-. <c' c''>4-. <b b'>4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 <a a'>4-. <b b'>4-. <c' c''>4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 <c' c''>4 <a a'>4-. <dis dis'>4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 <e e'>4-. <e e'>4-. <gis gis'>4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 <a a'>4-. <b b'>4-. <c' c''>8-. <d' d''>8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 <e' e''>4-. <e e'>4-. <gis gis'>4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 <a a'>4-. <b b'>4-. <c' c''>8-. <d' d''>8-. | % m. 95; MIDI bar 95
\barNumberCheck #96 <e' e''>4-. <e e'>4-. <e e'>4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 <e e'>4-. <e e'>4-. <e e'>4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 <e e'>4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 << { e'2.\pp\upbow^\markup \italic \concat { "Soli " \whiteout "(sezione)" }~ } \\ { c'2.~ } >> \oneVoice | % m. 100; MIDI bar 100
\barNumberCheck #101 << { e'2.~ } \\ { c'2.( } >> \oneVoice | % m. 101; MIDI bar 101
\barNumberCheck #102 << { e'2.~ } \\ { d'2.)~ } >> \oneVoice | % m. 102; MIDI bar 102
\barNumberCheck #103 << { e'2.~ } \\ { d'2. } >> \oneVoice | % m. 103; MIDI bar 103
\barNumberCheck #104 << { e'2.~ } \\ { c'2.~ } >> \oneVoice | % m. 104; MIDI bar 104
\barNumberCheck #105 << { e'2.~ } \\ { c'2. } >> \oneVoice | % m. 105; MIDI bar 105
\barNumberCheck #106 << { e'2.~ } \\ { gis2.~ } >> \oneVoice | % m. 106; MIDI bar 106
\barNumberCheck #107 << { e'2.~ } \\ { gis2. } >> \oneVoice | % m. 107; MIDI bar 107
\barNumberCheck #108 << { e'2.~ } \\ { c'2.~ } >> \oneVoice | % m. 108; MIDI bar 108
\barNumberCheck #109 << { e'2. } \\ { c'2. } >> \oneVoice | % m. 109; MIDI bar 109
\barNumberCheck #110 << { f'2.( } \\ { a2.( } >> \oneVoice | % m. 110; MIDI bar 110
\barNumberCheck #111 << { e'2.) } \\ { c'2.) } >> \oneVoice | % m. 111; MIDI bar 111
\barNumberCheck #112 <b g'>2.( | % m. 112; MIDI bar 112
\barNumberCheck #113 <a fis'>2. | % m. 113; MIDI bar 113
\barNumberCheck #114 <g e'>2. | % m. 114; MIDI bar 114
\barNumberCheck #115 <gis d'>2.-> | % m. 115; MIDI bar 115
\barNumberCheck #116 <a c'>2.)~ | % m. 116; MIDI bar 116
\barNumberCheck #117 <a c'>2. | % m. 117; MIDI bar 117
\barNumberCheck #118 <b d'>2.( | % m. 118; MIDI bar 118
\barNumberCheck #119 <d' e'>2.) | % m. 119; MIDI bar 119
\barNumberCheck #120 <c' e'>2.~ | % m. 120; MIDI bar 120
\barNumberCheck #121 <c' e'>2. | % m. 121; MIDI bar 121
\barNumberCheck #122 <b f'>2.~ | % m. 122; MIDI bar 122
\barNumberCheck #123 <b f'>2.~ | % m. 123; MIDI bar 123
\barNumberCheck #124 <b f'>2.~ | % m. 124; MIDI bar 124
\barNumberCheck #125 <b f'>2.~ | % m. 125; MIDI bar 125
\barNumberCheck #126 <b f'>2.~ | % m. 126; MIDI bar 126
\barNumberCheck #127 <b f'>2.~ | % m. 127; MIDI bar 127
\barNumberCheck #128 <b f'>2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 c8(\ff^\markup \italic "Tutti" d8 e8 f8 g4~) | % m. 142; MIDI bar 142
\barNumberCheck #143 g8( a8 bes8 b8  c'4-.) | % m. 143; MIDI bar 143
\barNumberCheck #144 f8( g8 a8 b8  c'4-.) | % m. 144; MIDI bar 144
\barNumberCheck #145 d'4-. g4-. c'4-. | % m. 145; MIDI bar 145
\barNumberCheck #146 fis'2-> d'4 | % m. 146; MIDI bar 146
\barNumberCheck #147 e'2-> e'4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a8( b8 c'8 d'8  e'4-.) | % m. 148; MIDI bar 148
\barNumberCheck #149 fis'4-. d'4-. g'4-. | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 d'2\ff-> d'4 | % m. 158; MIDI bar 158
\barNumberCheck #159 c'2-> b4 | % m. 159; MIDI bar 159
\barNumberCheck #160 a4(-> b4 c'4) | % m. 160; MIDI bar 160
\barNumberCheck #161 b2 r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f'2\f-> e'4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d'2-> cis'4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d'8(-> e'8 f'8 g'8  a'4-.) | % m. 168; MIDI bar 168
\barNumberCheck #169 b'4-.-> g'4-. c''4-. | % m. 169; MIDI bar 169
\barNumberCheck #170 g8( a8 b8 c'8  d'4-.) | % m. 170; MIDI bar 170
\barNumberCheck #171 c8( d8 e8 f8  g4-.) | % m. 171; MIDI bar 171
\barNumberCheck #172 g8( a8 b8 c'8  d'4-.) | % m. 172; MIDI bar 172
\barNumberCheck #173 c'8( d'8 e'8 f'8  g'4-.) | % m. 173; MIDI bar 173
\barNumberCheck #174 f'4-. f'4-.-> g'4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 a'4 a'4-.-> g'4-. | % m. 175; MIDI bar 175
\barNumberCheck #176 f'4 f'4-.-> g'4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 a'4 g'4-. a'4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a'2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 a'2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a8( bes8 c'8 d'8  ees'4-.) | % m. 180; MIDI bar 180
\barNumberCheck #181 fis8( g8 a8 bes8  c'4-.) | % m. 181; MIDI bar 181
\barNumberCheck #182 aes2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 aes2.~ | % m. 183; MIDI bar 183
\barNumberCheck #184 aes4 c'4-. d'4-. | % m. 184; MIDI bar 184
\barNumberCheck #185 ees'4 c'4-. d'4-. | % m. 185; MIDI bar 185
\barNumberCheck #186 ees'4-. c'4-. d'4-. | % m. 186; MIDI bar 186
\barNumberCheck #187 ees'4-. c'4-. d'4-. | % m. 187; MIDI bar 187
\barNumberCheck #188 ees'4-. c'4-. d'4-. | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'4-.\< f'4-. fis'4-. | % m. 189; MIDI bar 189
\barNumberCheck #190 c''2\ff-> g'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g'2-> e'4 | % m. 191; MIDI bar 191
\barNumberCheck #192 e'2-> c'4 | % m. 192; MIDI bar 192
\barNumberCheck #193 c'2-> g4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g'8( a'8 b'8 c''8 d''8 c''8 | % m. 194; MIDI bar 194
\barNumberCheck #195 b'8 a'8 g'8 f'8 e'8 d'8 | % m. 195; MIDI bar 195
\barNumberCheck #196 c'8 b8 a8 g8) c'4 | % m. 196; MIDI bar 196
\barNumberCheck #197 fis8( g8 a8 b8  c'4-.) | % m. 197; MIDI bar 197
\barNumberCheck #198 <g d'>2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 <c c'>4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 fis8(\pp g8 a8 b8  c'4-.) | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
celloIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c8(\f d8 e8 f8 g4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c8(\ff d8 e8 f8 g4~) | % m. 4; MIDI bar 4
\barNumberCheck #5 g8( a8 bes8 b8 c'4-.) | % m. 5; MIDI bar 5
\barNumberCheck #6 f8( g8 a8 b8 c'4-.) | % m. 6; MIDI bar 6
\barNumberCheck #7 d'4-. g4-. c'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 c'2-> b4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c'2-> b4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a8( b8 c'8 d'8 e'4-.) | % m. 10; MIDI bar 10
\barNumberCheck #11 fis'4-. d'4-. g'4-. | % m. 11; MIDI bar 11
\barNumberCheck #12 c8(\pp d8 e8 f8 g4~) | % m. 12; MIDI bar 12
\barNumberCheck #13 g8( a8 bes8 b8 c'4-.) | % m. 13; MIDI bar 13
\barNumberCheck #14 f8( g8 a8 b8 c'4-.) | % m. 14; MIDI bar 14
\barNumberCheck #15 d'4-. g4-. c'4-. | % m. 15; MIDI bar 15
\barNumberCheck #16 c'2-> b4 | % m. 16; MIDI bar 16
\barNumberCheck #17 c'2-> b4 | % m. 17; MIDI bar 17
\barNumberCheck #18 a8( b8 c'8 d'8  e'4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 fis'4-. d'4-. g'4-. | % m. 19; MIDI bar 19
\barNumberCheck #20 g8(\ff a8 bes8 c'8  d'4-.) | % m. 20; MIDI bar 20
\barNumberCheck #21 a8( b8 c'8 d'8  e'4-.) | % m. 21; MIDI bar 21
\barNumberCheck #22 f8( g8 a8 b8  c'4-.) | % m. 22; MIDI bar 22
\barNumberCheck #23 b4-. e4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f2->\ff e4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d2-> cis4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d8( e8 f8 g8  a4-.) | % m. 30; MIDI bar 30
\barNumberCheck #31 b4-. g4-. c'4-. | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g8(\ff a8 bes8 c'8  d'4-.) | % m. 34; MIDI bar 34
\barNumberCheck #35 a8( b8 c'8 d'8  e'4-.) | % m. 35; MIDI bar 35
\barNumberCheck #36 f8( g8 a8 b8  c'4-.) | % m. 36; MIDI bar 36
\barNumberCheck #37 b4-. e4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f2->\ff e4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2-> cis4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d8( e8 f8 g8  a4-.) | % m. 44; MIDI bar 44
\barNumberCheck #45 b4-. g4-. c'4-. | % m. 45; MIDI bar 45
\barNumberCheck #46 g2-> c'4 | % m. 46; MIDI bar 46
\barNumberCheck #47 fis8( g8 a8 b8  c'4-.) | % m. 47; MIDI bar 47
\barNumberCheck #48 g,2.\sf-> | % m. 48; MIDI bar 48
\barNumberCheck #49 c4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 a2\p a4 | % m. 66; MIDI bar 66
\barNumberCheck #67 a2 a4 | % m. 67; MIDI bar 67
\barNumberCheck #68 g2 g4 | % m. 68; MIDI bar 68
\barNumberCheck #69 g2 g4 | % m. 69; MIDI bar 69
\barNumberCheck #70 a2 d4 | % m. 70; MIDI bar 70
\barNumberCheck #71 d2 d4 | % m. 71; MIDI bar 71
\barNumberCheck #72 g2 g4 | % m. 72; MIDI bar 72
\barNumberCheck #73 g2 g4 | % m. 73; MIDI bar 73
\barNumberCheck #74 fis2.~ | % m. 74; MIDI bar 74
\barNumberCheck #75 fis2. | % m. 75; MIDI bar 75
\barNumberCheck #76 g2. | % m. 76; MIDI bar 76
\barNumberCheck #77 e4( fis4 g4) | % m. 77; MIDI bar 77
\barNumberCheck #78 fis2 fis4 | % m. 78; MIDI bar 78
\barNumberCheck #79 fis2. | % m. 79; MIDI bar 79
\barNumberCheck #80 fis2.~ | % m. 80; MIDI bar 80
\barNumberCheck #81 fis2. | % m. 81; MIDI bar 81
\barNumberCheck #82 f2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 f2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e4-.\ff e4-. fis4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis4-. a4-. b4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'4-. b4-. a4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a4 b4-. c'4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b4-. e4-. e'4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'4-. c'4-. b4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a4-. b4-. c'4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'4 a4-. dis4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e4-. e4-. gis4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 a4-. b4-. c'8-. d'8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4-. e4-. gis4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 a4-. b4-. c'8-. d'8-. | % m. 95; MIDI bar 95
\barNumberCheck #96 e'4-. e4-. e4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 e4-. e4-. e4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 e4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 a2.\pp\upbow^\markup \italic \concat { "Soli " \whiteout "(sezione)" }~ | % m. 100; MIDI bar 100
\barNumberCheck #101 a2. | % m. 101; MIDI bar 101
\barNumberCheck #102 gis2.~ | % m. 102; MIDI bar 102
\barNumberCheck #103 gis2. | % m. 103; MIDI bar 103
\barNumberCheck #104 a2.~ | % m. 104; MIDI bar 104
\barNumberCheck #105 a2. | % m. 105; MIDI bar 105
\barNumberCheck #106 e2.~ | % m. 106; MIDI bar 106
\barNumberCheck #107 e2. | % m. 107; MIDI bar 107
\barNumberCheck #108 a,2.~ | % m. 108; MIDI bar 108
\barNumberCheck #109 a,2. | % m. 109; MIDI bar 109
\barNumberCheck #110 d,2.( | % m. 110; MIDI bar 110
\barNumberCheck #111 a,2.) | % m. 111; MIDI bar 111
\barNumberCheck #112 b,2.~ | % m. 112; MIDI bar 112
\barNumberCheck #113 b,2. | % m. 113; MIDI bar 113
\barNumberCheck #114 e,2.~ | % m. 114; MIDI bar 114
\barNumberCheck #115 e,2. | % m. 115; MIDI bar 115
\barNumberCheck #116 a,2. | % m. 116; MIDI bar 116
\barNumberCheck #117 a2. | % m. 117; MIDI bar 117
\barNumberCheck #118 gis2.~ | % m. 118; MIDI bar 118
\barNumberCheck #119 gis2. | % m. 119; MIDI bar 119
\barNumberCheck #120 a2.~ | % m. 120; MIDI bar 120
\barNumberCheck #121 a2. | % m. 121; MIDI bar 121
\barNumberCheck #122 gis2.~ | % m. 122; MIDI bar 122
\barNumberCheck #123 gis2.~ | % m. 123; MIDI bar 123
\barNumberCheck #124 gis2.~ | % m. 124; MIDI bar 124
\barNumberCheck #125 gis2.~ | % m. 125; MIDI bar 125
\barNumberCheck #126 gis2.~ | % m. 126; MIDI bar 126
\barNumberCheck #127 gis2.~ | % m. 127; MIDI bar 127
\barNumberCheck #128 gis2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 c8(\ff^\markup \italic "Tutti" d8 e8 f8 g4~) | % m. 142; MIDI bar 142
\barNumberCheck #143 g8( a8 bes8 b8  c'4-.) | % m. 143; MIDI bar 143
\barNumberCheck #144 f8( g8 a8 b8  c'4-.) | % m. 144; MIDI bar 144
\barNumberCheck #145 d'4-. g4-. c'4-. | % m. 145; MIDI bar 145
\barNumberCheck #146 c'2-> b4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c'2-> b4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a8( b8 c'8 d'8  e'4-.) | % m. 148; MIDI bar 148
\barNumberCheck #149 fis'4-. d'4-. g'4-. | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g8(\ff a8 bes8 c'8  d'4-.) | % m. 158; MIDI bar 158
\barNumberCheck #159 a8( b8 c'8 d'8  e'4-.) | % m. 159; MIDI bar 159
\barNumberCheck #160 f8( g8 a8 b8  c'4-.) | % m. 160; MIDI bar 160
\barNumberCheck #161 b4-. e4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f2\f-> e4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d2-> cis4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d8(-> e8 f8 g8  a4-.) | % m. 168; MIDI bar 168
\barNumberCheck #169 b4-.-> g4-. c'4-. | % m. 169; MIDI bar 169
\barNumberCheck #170 g,8( a,8 b,8 c8  d4-.) | % m. 170; MIDI bar 170
\barNumberCheck #171 c8( d8 e8 f8  g4-.) | % m. 171; MIDI bar 171
\barNumberCheck #172 g8( a8 b8 c'8  d'4-.) | % m. 172; MIDI bar 172
\barNumberCheck #173 c'8( d'8 e'8 f'8  g'4-.) | % m. 173; MIDI bar 173
\barNumberCheck #174 f'4 f4-.-> g4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 a4 a'4-> g'4 | % m. 175; MIDI bar 175
\barNumberCheck #176 f'4 f4-.-> g4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 a4 g4-. a4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 a2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a8( bes8 c'8 d'8  ees'4-.) | % m. 180; MIDI bar 180
\barNumberCheck #181 fis8( g8 a8 bes8  c'4-.) | % m. 181; MIDI bar 181
\barNumberCheck #182 aes,2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 aes,2. | % m. 183; MIDI bar 183
\barNumberCheck #184 aes,2. | % m. 184; MIDI bar 184
\barNumberCheck #185 aes,2. | % m. 185; MIDI bar 185
\barNumberCheck #186 r4 c'4-. d'4-. | % m. 186; MIDI bar 186
\barNumberCheck #187 ees'4-. c'4-. d'4-. | % m. 187; MIDI bar 187
\barNumberCheck #188 ees'4-. c'4-. d'4-. | % m. 188; MIDI bar 188
\barNumberCheck #189 ees'4-.\< f'4-. fis'4-. | % m. 189; MIDI bar 189
\barNumberCheck #190 g'2\ff-> g'4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g,2-> g,4 | % m. 191; MIDI bar 191
\barNumberCheck #192 g,2-> g,4 | % m. 192; MIDI bar 192
\barNumberCheck #193 g,2-> g,4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g8( a8 b8 c'8 d'8 c'8 | % m. 194; MIDI bar 194
\barNumberCheck #195 b8 a8 g8 f8 e8 d8 | % m. 195; MIDI bar 195
\barNumberCheck #196 c8 b,8 a,8 g,8) c4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g2-> c4 | % m. 197; MIDI bar 197
\barNumberCheck #198 <g, g>2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 <c, c>4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 fis,8(\pp g,8 a,8 b,8  c4-.) | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
bassIV = {
\barNumberCheck #1 \key c \major R2. | % m. 1; MIDI bar 1
\barNumberCheck #2 c8(\f d8 e8 f8 g4-.) | % m. 2; MIDI bar 2
\barNumberCheck #3 R2.\fermata | % m. 3; MIDI bar 3
\barNumberCheck #4 c8(\ff d8 e8 f8 g4~) | % m. 4; MIDI bar 4
\barNumberCheck #5 g8( a8 bes8 b8 c'4-.) | % m. 5; MIDI bar 5
\barNumberCheck #6 f8( g8 a8 b8 c'4-.) | % m. 6; MIDI bar 6
\barNumberCheck #7 d'4-. g4-. c'4-. | % m. 7; MIDI bar 7
\barNumberCheck #8 c'2-> b4 | % m. 8; MIDI bar 8
\barNumberCheck #9 c'2-> b4 | % m. 9; MIDI bar 9
\barNumberCheck #10 a8( b8 c'8 d'8 e'4-.) | % m. 10; MIDI bar 10
\barNumberCheck #11 fis'4-. d'4-. g'4-. | % m. 11; MIDI bar 11
\barNumberCheck #12 c8(\pp d8 e8 f8 g4~) | % m. 12; MIDI bar 12
\barNumberCheck #13 g8( a8 bes8 b8 c'4-.) | % m. 13; MIDI bar 13
\barNumberCheck #14 f8( g8 a8 b8 c'4-.) | % m. 14; MIDI bar 14
\barNumberCheck #15 d'4-. g4-. c'4-. | % m. 15; MIDI bar 15
\barNumberCheck #16 c'2-> b4 | % m. 16; MIDI bar 16
\barNumberCheck #17 c'2-> b4 | % m. 17; MIDI bar 17
\barNumberCheck #18 a8( b8 c'8 d'8  e'4-.) | % m. 18; MIDI bar 18
\barNumberCheck #19 fis'4-. d'4-. g'4-. | % m. 19; MIDI bar 19
\barNumberCheck #20 g8(\ff a8 bes8 c'8  d'4-.) | % m. 20; MIDI bar 20
\barNumberCheck #21 a8( b8 c'8 d'8  e'4-.) | % m. 21; MIDI bar 21
\barNumberCheck #22 f8( g8 a8 b8  c'4-.) | % m. 22; MIDI bar 22
\barNumberCheck #23 b4-. e4-. r4\fermata | % m. 23; MIDI bar 23
\barNumberCheck #24 R2. | % m. 24; MIDI bar 24
\barNumberCheck #25 R2. | % m. 25; MIDI bar 25
\barNumberCheck #26 R2. | % m. 26; MIDI bar 26
\barNumberCheck #27 R2. | % m. 27; MIDI bar 27
\barNumberCheck #28 f2->\ff e4 | % m. 28; MIDI bar 28
\barNumberCheck #29 d2-> cis4 | % m. 29; MIDI bar 29
\barNumberCheck #30 d8( e8 f8 g8  a4-.) | % m. 30; MIDI bar 30
\barNumberCheck #31 b4-. g4-. c'4-. | % m. 31; MIDI bar 31
\barNumberCheck #32 R2. | % m. 32; MIDI bar 32
\barNumberCheck #33 R2. | % m. 33; MIDI bar 33
\barNumberCheck #34 g8(\ff a8 bes8 c'8  d'4-.) | % m. 34; MIDI bar 34
\barNumberCheck #35 a8( b8 c'8 d'8  e'4-.) | % m. 35; MIDI bar 35
\barNumberCheck #36 f8( g8 a8 b8  c'4-.) | % m. 36; MIDI bar 36
\barNumberCheck #37 b4-. e4-. r4\fermata | % m. 37; MIDI bar 37
\barNumberCheck #38 R2. | % m. 38; MIDI bar 38
\barNumberCheck #39 R2. | % m. 39; MIDI bar 39
\barNumberCheck #40 R2. | % m. 40; MIDI bar 40
\barNumberCheck #41 R2. | % m. 41; MIDI bar 41
\barNumberCheck #42 f2->\ff e4 | % m. 42; MIDI bar 42
\barNumberCheck #43 d2-> cis4 | % m. 43; MIDI bar 43
\barNumberCheck #44 d8( e8 f8 g8  a4-.) | % m. 44; MIDI bar 44
\barNumberCheck #45 b4-. g4-. c'4-. | % m. 45; MIDI bar 45
\barNumberCheck #46 g2-> c'4 | % m. 46; MIDI bar 46
\barNumberCheck #47 fis8( g8 a8 b8  c'4-.) | % m. 47; MIDI bar 47
\barNumberCheck #48 g,2.\sf | % m. 48; MIDI bar 48
\barNumberCheck #49 c4 r4 r4 | % m. 49; MIDI bar 49
\barNumberCheck #50 R2. | % m. 50; MIDI bar 50
\barNumberCheck #51 R2. | % m. 51; MIDI bar 51
\barNumberCheck #52 R2. | % m. 52; MIDI bar 52
\barNumberCheck #53 R2. | % m. 53; MIDI bar 53
\barNumberCheck #54 R2. | % m. 54; MIDI bar 54
\barNumberCheck #55 R2. | % m. 55; MIDI bar 55
\barNumberCheck #56 R2. | % m. 56; MIDI bar 56
\barNumberCheck #57 R2. | % m. 57; MIDI bar 57
\barNumberCheck #58 R2. | % m. 58; MIDI bar 58
\barNumberCheck #59 R2. | % m. 59; MIDI bar 59
\barNumberCheck #60 R2. | % m. 60; MIDI bar 60
\barNumberCheck #61 R2. | % m. 61; MIDI bar 61
\barNumberCheck #62 R2. | % m. 62; MIDI bar 62
\barNumberCheck #63 R2. | % m. 63; MIDI bar 63
\barNumberCheck #64 R2. | % m. 64; MIDI bar 64
\barNumberCheck #65 R2. | % m. 65; MIDI bar 65
\barNumberCheck #66 a2\p a4 | % m. 66; MIDI bar 66
\barNumberCheck #67 a2 a4 | % m. 67; MIDI bar 67
\barNumberCheck #68 g2 g4 | % m. 68; MIDI bar 68
\barNumberCheck #69 g2 g4 | % m. 69; MIDI bar 69
\barNumberCheck #70 a2 d4 | % m. 70; MIDI bar 70
\barNumberCheck #71 d2 d4 | % m. 71; MIDI bar 71
\barNumberCheck #72 g2 g4 | % m. 72; MIDI bar 72
\barNumberCheck #73 g2 g4 | % m. 73; MIDI bar 73
\barNumberCheck #74 fis2.~ | % m. 74; MIDI bar 74
\barNumberCheck #75 fis2. | % m. 75; MIDI bar 75
\barNumberCheck #76 g2. | % m. 76; MIDI bar 76
\barNumberCheck #77 e4( fis4 g4) | % m. 77; MIDI bar 77
\barNumberCheck #78 fis2 fis4 | % m. 78; MIDI bar 78
\barNumberCheck #79 fis2. | % m. 79; MIDI bar 79
\barNumberCheck #80 fis2.~ | % m. 80; MIDI bar 80
\barNumberCheck #81 fis2. | % m. 81; MIDI bar 81
\barNumberCheck #82 f2.\ff->~ | % m. 82; MIDI bar 82
\barNumberCheck #83 f2. | % m. 83; MIDI bar 83
\barNumberCheck #84 e4-.\ff e4-. fis4-. | % m. 84; MIDI bar 84
\barNumberCheck #85 gis4-. a4-. b4-. | % m. 85; MIDI bar 85
\barNumberCheck #86 c'4-. b4-. a4->~ | % m. 86; MIDI bar 86
\barNumberCheck #87 a4 b4-. c'4-. | % m. 87; MIDI bar 87
\barNumberCheck #88 b4-. e4-. e'4-. | % m. 88; MIDI bar 88
\barNumberCheck #89 d'4-. c'4-. b4-. | % m. 89; MIDI bar 89
\barNumberCheck #90 a4-. b4-. c'4->~ | % m. 90; MIDI bar 90
\barNumberCheck #91 c'4 a4-. dis4-. | % m. 91; MIDI bar 91
\barNumberCheck #92 e4-. e4-. gis4-. | % m. 92; MIDI bar 92
\barNumberCheck #93 a4-. b4-. c'8-. d'8-. | % m. 93; MIDI bar 93
\barNumberCheck #94 e'4-. e4-. gis4-. | % m. 94; MIDI bar 94
\barNumberCheck #95 a4-. b4-. c'8-. d'8-. | % m. 95; MIDI bar 95
\barNumberCheck #96 e'4-. e4-. e4-. | % m. 96; MIDI bar 96
\barNumberCheck #97 e4-. e4-. e4-. | % m. 97; MIDI bar 97
\barNumberCheck #98 e4 r4 r4 | % m. 98; MIDI bar 98
\barNumberCheck #99 R2. | % m. 99; MIDI bar 99
\barNumberCheck #100 R2. | % m. 100; MIDI bar 100
\barNumberCheck #101 R2. | % m. 101; MIDI bar 101
\barNumberCheck #102 R2. | % m. 102; MIDI bar 102
\barNumberCheck #103 R2. | % m. 103; MIDI bar 103
\barNumberCheck #104 R2. | % m. 104; MIDI bar 104
\barNumberCheck #105 R2. | % m. 105; MIDI bar 105
\barNumberCheck #106 R2. | % m. 106; MIDI bar 106
\barNumberCheck #107 R2. | % m. 107; MIDI bar 107
\barNumberCheck #108 R2. | % m. 108; MIDI bar 108
\barNumberCheck #109 R2. | % m. 109; MIDI bar 109
\barNumberCheck #110 R2. | % m. 110; MIDI bar 110
\barNumberCheck #111 R2. | % m. 111; MIDI bar 111
\barNumberCheck #112 R2. | % m. 112; MIDI bar 112
\barNumberCheck #113 R2. | % m. 113; MIDI bar 113
\barNumberCheck #114 R2. | % m. 114; MIDI bar 114
\barNumberCheck #115 R2. | % m. 115; MIDI bar 115
\barNumberCheck #116 R2. | % m. 116; MIDI bar 116
\barNumberCheck #117 R2. | % m. 117; MIDI bar 117
\barNumberCheck #118 R2. | % m. 118; MIDI bar 118
\barNumberCheck #119 R2. | % m. 119; MIDI bar 119
\barNumberCheck #120 R2. | % m. 120; MIDI bar 120
\barNumberCheck #121 R2. | % m. 121; MIDI bar 121
\barNumberCheck #122 R2. | % m. 122; MIDI bar 122
\barNumberCheck #123 R2. | % m. 123; MIDI bar 123
\barNumberCheck #124 R2. | % m. 124; MIDI bar 124
\barNumberCheck #125 R2. | % m. 125; MIDI bar 125
\barNumberCheck #126 R2. | % m. 126; MIDI bar 126
\barNumberCheck #127 R2. | % m. 127; MIDI bar 127
\barNumberCheck #128 R2. | % m. 128; MIDI bar 128
\barNumberCheck #129 R2.\fermata | % m. 129; MIDI bar 129
\barNumberCheck #130 R2. | % m. 130; MIDI bar 130
\barNumberCheck #131 R2. | % m. 131; MIDI bar 131
\barNumberCheck #132 R2. | % m. 132; MIDI bar 132
\barNumberCheck #133 R2. | % m. 133; MIDI bar 133
\barNumberCheck #134 R2. | % m. 134; MIDI bar 134
\barNumberCheck #135 R2. | % m. 135; MIDI bar 135
\barNumberCheck #136 R2. | % m. 136; MIDI bar 136
\barNumberCheck #137 R2. | % m. 137; MIDI bar 137
\barNumberCheck #138 R2. | % m. 138; MIDI bar 138
\barNumberCheck #139 R2. | % m. 139; MIDI bar 139
\barNumberCheck #140 R2. | % m. 140; MIDI bar 140
\barNumberCheck #141 R2. | % m. 141; MIDI bar 141
\barNumberCheck #142 c8(\ff d8 e8 f8 g4~) | % m. 142; MIDI bar 142
\barNumberCheck #143 g8( a8 bes8 b8  c'4-.) | % m. 143; MIDI bar 143
\barNumberCheck #144 f8( g8 a8 b8  c'4-.) | % m. 144; MIDI bar 144
\barNumberCheck #145 d'4-. g4-. c'4-. | % m. 145; MIDI bar 145
\barNumberCheck #146 c'2-> b4 | % m. 146; MIDI bar 146
\barNumberCheck #147 c'2-> b4 | % m. 147; MIDI bar 147
\barNumberCheck #148 a8( b8 c'8 d'8  e'4-.) | % m. 148; MIDI bar 148
\barNumberCheck #149 fis'4-. d'4-. g'4-. | % m. 149; MIDI bar 149
\barNumberCheck #150 R2. | % m. 150; MIDI bar 150
\barNumberCheck #151 R2. | % m. 151; MIDI bar 151
\barNumberCheck #152 R2. | % m. 152; MIDI bar 152
\barNumberCheck #153 R2. | % m. 153; MIDI bar 153
\barNumberCheck #154 R2. | % m. 154; MIDI bar 154
\barNumberCheck #155 R2. | % m. 155; MIDI bar 155
\barNumberCheck #156 R2. | % m. 156; MIDI bar 156
\barNumberCheck #157 R2. | % m. 157; MIDI bar 157
\barNumberCheck #158 g8(\ff a8 bes8 c'8  d'4-.) | % m. 158; MIDI bar 158
\barNumberCheck #159 a8( b8 c'8 d'8  e'4-.) | % m. 159; MIDI bar 159
\barNumberCheck #160 f8( g8 a8 b8  c'4-.) | % m. 160; MIDI bar 160
\barNumberCheck #161 b4-. e4-. r4\fermata | % m. 161; MIDI bar 161
\barNumberCheck #162 R2. | % m. 162; MIDI bar 162
\barNumberCheck #163 R2. | % m. 163; MIDI bar 163
\barNumberCheck #164 R2. | % m. 164; MIDI bar 164
\barNumberCheck #165 R2. | % m. 165; MIDI bar 165
\barNumberCheck #166 f2\f-> e4 | % m. 166; MIDI bar 166
\barNumberCheck #167 d2-> cis4 | % m. 167; MIDI bar 167
\barNumberCheck #168 d8(-> e8 f8 g8  a4-.) | % m. 168; MIDI bar 168
\barNumberCheck #169 b4-.-> g4-. c'4-. | % m. 169; MIDI bar 169
\barNumberCheck #170 g,8( a,8 b,8 c8  d4-.) | % m. 170; MIDI bar 170
\barNumberCheck #171 c8( d8 e8 f8  g4-.) | % m. 171; MIDI bar 171
\barNumberCheck #172 g8( a8 b8 c'8  d'4-.) | % m. 172; MIDI bar 172
\barNumberCheck #173 c8( d8 e8 f8  g4-.) | % m. 173; MIDI bar 173
\barNumberCheck #174 f4 f4-.-> g4-. | % m. 174; MIDI bar 174
\barNumberCheck #175 a4 r4 r4 | % m. 175; MIDI bar 175
\barNumberCheck #176 r4 f4-.-> g4-. | % m. 176; MIDI bar 176
\barNumberCheck #177 a4 g4-. a4-. | % m. 177; MIDI bar 177
\barNumberCheck #178 a2.->~ | % m. 178; MIDI bar 178
\barNumberCheck #179 a2. | % m. 179; MIDI bar 179
\barNumberCheck #180 a,2.~ | % m. 180; MIDI bar 180
\barNumberCheck #181 a,2. | % m. 181; MIDI bar 181
\barNumberCheck #182 aes,2.\f~ | % m. 182; MIDI bar 182
\barNumberCheck #183 aes,2. | % m. 183; MIDI bar 183
\barNumberCheck #184 aes,2. | % m. 184; MIDI bar 184
\barNumberCheck #185 aes,2. | % m. 185; MIDI bar 185
\barNumberCheck #186 aes,2. | % m. 186; MIDI bar 186
\barNumberCheck #187 aes,2. | % m. 187; MIDI bar 187
\barNumberCheck #188 aes,2. | % m. 188; MIDI bar 188
\barNumberCheck #189 aes,4\< aes,4 aes,4 | % m. 189; MIDI bar 189
\barNumberCheck #190 g,2\ff-> g,4 | % m. 190; MIDI bar 190
\barNumberCheck #191 g,2-> g,4 | % m. 191; MIDI bar 191
\barNumberCheck #192 g,2-> g,4 | % m. 192; MIDI bar 192
\barNumberCheck #193 g,2-> g,4 | % m. 193; MIDI bar 193
\barNumberCheck #194 g,2. | % m. 194; MIDI bar 194
\barNumberCheck #195 g,4 g,4 g,4 | % m. 195; MIDI bar 195
\barNumberCheck #196 g,2 c4 | % m. 196; MIDI bar 196
\barNumberCheck #197 g,2 c,4 | % m. 197; MIDI bar 197
\barNumberCheck #198 g,2.\sf-> | % m. 198; MIDI bar 198
\barNumberCheck #199 c,4 r4 r4 | % m. 199; MIDI bar 199
\barNumberCheck #200 R2. | % m. 200; MIDI bar 200
\barNumberCheck #201 R2. | % m. 201; MIDI bar 201
\barNumberCheck #202 fis,8(\pp g,8 a,8 b,8  c4-.) | % m. 202; MIDI bar 202
\barNumberCheck #203 R2.\fermata | % m. 203; MIDI bar 203
\barNumberCheck #204
}
violaSoloII = {
\barNumberCheck #1 \key f \major s1 | % m. 1; MIDI bar 1
\barNumberCheck #2 r4. c'8(\pp^\markup \italic "Solo" d'8 e'8 f'8 g'8 | % m. 2; MIDI bar 2
\barNumberCheck #3 a'2) \grace { f'16( g'16 a'16 } g'8.[) fis'16 g'8. a'16] | % m. 3; MIDI bar 3
\barNumberCheck #4 f'8.( g'32 f'32) e'16-. f'16-. g'16-. a'16-. c'8. d'16 ees'16 e'16 f'16 fis'16 | % m. 4; MIDI bar 4
\barNumberCheck #5 g'4.\< gis'8 a'8.( bes'32 a'32) g'8 f'8 | % m. 5; MIDI bar 5
\barNumberCheck #6 e'8(\!-> g'16) r16 d'8(-> g'16) r16 c'4 \tuplet 6/4 { d'16-.( e'16-. f'16-. fis'16-. g'16-. gis'16-.) } | % m. 6; MIDI bar 6
\barNumberCheck #7 a'2\< a'8.[ gis'16 a'8. a'16] | % m. 7; MIDI bar 7
\barNumberCheck #8 b'4\f e''4 d''2 | % m. 8; MIDI bar 8
\barNumberCheck #9 c''4. a'8 \grace { a'8( } g'8.[) fis'16 g'8. c''16] | % m. 9; MIDI bar 9
\barNumberCheck #10 c''2-> f'4 r4 | % m. 10; MIDI bar 10
\barNumberCheck #11 s1 | % m. 11; MIDI bar 11
\barNumberCheck #12 s1 | % m. 12; MIDI bar 12
\barNumberCheck #13 s1 | % m. 13; MIDI bar 13
\barNumberCheck #14 s1 | % m. 14; MIDI bar 14
\barNumberCheck #15 s1 | % m. 15; MIDI bar 15
\barNumberCheck #16 s1 | % m. 16; MIDI bar 16
\barNumberCheck #17 s1 | % m. 17; MIDI bar 17
\barNumberCheck #18 s1 | % m. 18; MIDI bar 18
\barNumberCheck #19 s1 | % m. 19; MIDI bar 19
\barNumberCheck #20 s1 | % m. 20; MIDI bar 20
\barNumberCheck #21 s1 | % m. 21; MIDI bar 21
\barNumberCheck #22 s1 | % m. 22; MIDI bar 22
\barNumberCheck #23 s1 | % m. 23; MIDI bar 23
\barNumberCheck #24 s1 | % m. 24; MIDI bar 24
\barNumberCheck #25 s1 | % m. 25; MIDI bar 25
\barNumberCheck #26 s1 | % m. 26; MIDI bar 26
\barNumberCheck #27 s1 | % m. 27; MIDI bar 27
\barNumberCheck #28 s1 | % m. 28; MIDI bar 28
\barNumberCheck #29 s1 | % m. 29; MIDI bar 29
\barNumberCheck #30 s1 | % m. 30; MIDI bar 30
\barNumberCheck #31 s1 | % m. 31; MIDI bar 31
\barNumberCheck #32 s1 | % m. 32; MIDI bar 32
\barNumberCheck #33 s1 | % m. 33; MIDI bar 33
\barNumberCheck #34 s1 | % m. 34; MIDI bar 34
\barNumberCheck #35 s1 | % m. 35; MIDI bar 35
\barNumberCheck #36 s1 | % m. 36; MIDI bar 36
\barNumberCheck #37 s1 | % m. 37; MIDI bar 37
\barNumberCheck #38 s1 | % m. 38; MIDI bar 38
\barNumberCheck #39 s1 | % m. 39; MIDI bar 39
\barNumberCheck #40 s1 | % m. 40; MIDI bar 40
\barNumberCheck #41 s1 | % m. 41; MIDI bar 41
\barNumberCheck #42 s1 | % m. 42; MIDI bar 42
\barNumberCheck #43 s1 | % m. 43; MIDI bar 43
\barNumberCheck #44 s1 | % m. 44; MIDI bar 44
\barNumberCheck #45 s1 | % m. 45; MIDI bar 45
\barNumberCheck #46 s1 | % m. 46; MIDI bar 46
\barNumberCheck #47 s1 | % m. 47; MIDI bar 47
\barNumberCheck #48 s1 | % m. 48; MIDI bar 48
\barNumberCheck #49 s1 | % m. 49; MIDI bar 49
\barNumberCheck #50 s1 | % m. 50; MIDI bar 50
\barNumberCheck #51 s1 | % m. 51; MIDI bar 51
\barNumberCheck #52 s1 | % m. 52; MIDI bar 52
\barNumberCheck #53 s1 | % m. 53; MIDI bar 53
\barNumberCheck #54 s1 | % m. 54; MIDI bar 54
\barNumberCheck #55 s1 | % m. 55; MIDI bar 55
\barNumberCheck #56 s1 | % m. 56; MIDI bar 56
\barNumberCheck #57 s1 | % m. 57; MIDI bar 57
\barNumberCheck #58 s1 | % m. 58; MIDI bar 58
\barNumberCheck #59 s1 | % m. 59; MIDI bar 59
\barNumberCheck #60
}

% END embedded music and cue donor library

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
  first-page-number = #1
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
\addQuote "fluteI" { \transposition c' \fluteI }
\addQuote "fluteII" { \transposition c' \fluteII }
\addQuote "fluteIV" { \transposition c' \fluteIV }
\addQuote "oboeOneIV" { \transposition c' \oboeOneIV }
\book {
\bookpart {
  \paper {
    first-page-number = #1
    page-count = #1
    print-page-number = ##f
    oddHeaderMarkup = ##f evenHeaderMarkup = ##f
    oddFooterMarkup = ##f evenFooterMarkup = ##f
    ragged-bottom = ##t ragged-last-bottom = ##t
    top-margin = 26\mm
  }
  \header { title = ##f subtitle = ##f composer = ##f tagline = ##f }
  \markup \column {
    \vspace #5
    \fill-line { \abs-fontsize #16 "CARL MARIA VON WEBER" }
    \vspace #2
    \fill-line { \abs-fontsize #27 \bold "SYMPHONY No. 2" }
    \vspace #0.7
    \fill-line { \abs-fontsize #15 "in C major · J. 51" }
    \vspace #3.5
    \fill-line { \abs-fontsize #24 \bold "Viola" }
    \vspace #0.8
    \fill-line { \abs-fontsize #13 "PERFORMANCE PART" }
    \vspace #3
    \fill-line { \abs-fontsize #12 "I. Allegro" \abs-fontsize #12 "2" }
    \vspace #0.65
    \fill-line { \abs-fontsize #12 "II. Adagio ma non troppo" \abs-fontsize #12 "6" }
    \vspace #0.65
    \fill-line { \abs-fontsize #12 "III. Menuetto — Allegro" \abs-fontsize #12 "7" }
    \vspace #0.65
    \fill-line { \abs-fontsize #12 "IV. Finale — Scherzo, presto" \abs-fontsize #12 "8" }
    \vspace #0.65
    \vspace #1.8
    \override #'(baseline-skip . 2.7) \abs-fontsize #11 \column {
      \override #'(line-width . 100) \wordwrap-string #"Small notes are cues."
      \vspace #0.8
      \override #'(line-width . 100) \wordwrap-string #"Keep this cover when printing double-sided; music begins on page 2."
      \vspace #0.8
      \override #'(line-width . 100) \wordwrap-string #"In Adagio bars 2-10, the upper staff is the solo viola and the lower staff the accompanying viola line."
      \vspace #0.8
      \override #'(line-width . 100) \wordwrap { "In" "the" "Finale," \italic { "Soli" "(sezione)" } "means" "the" "exposed" "full" "section;" "retain" "normal" "divisi." \italic { "Tutti" } "marks" "the" "orchestral" "return." }
      \vspace #0.8
    }
    \vspace #2.0
    \fill-line { \abs-fontsize #12 \bold "Augmented Fifth" }
    \fill-line { \abs-fontsize #10 \italic "the intersection between classical music & AI" }
    \fill-line { \abs-fontsize #10 "http://aug5th.substack.com" }
    \fill-line { \abs-fontsize #10 "September 2026" }
  }
}
\bookpart {
  \paper { first-page-number = #2 }

\header { instrument = "Viola" tagline = ##f }
\score {
\new Staff { \clef "alto" \transposition c' \transpose c c {
\barNumberCheck #1 \time 4/4 \tempo \markup { \bold \fontsize #1 "Allegro" } \key c \major g'4..\ff g'16 a'4.. a'16  | % PART I 1-1
\barNumberCheck #2  a'4-. c''4-. r2  | % PART I 2-2
\barNumberCheck #3  R1*2  | % PART I 3-4
\barNumberCheck #5  d'4..\ff d'16 d'4.. d'16  | % PART I 5-5
\barNumberCheck #6  g'4-. b'4-. r2  | % PART I 6-6
\barNumberCheck #7  R1  | % PART I 7-7
\barNumberCheck #8  r8 c'8\pp c'8 c'8 c'4 r4  | % PART I 8-8
\barNumberCheck #9  r8 c'8 c'8 c'8 c'4 r4  | % PART I 9-9
\barNumberCheck #10  r4 c'4( g4 e'4)  | % PART I 10-10
\barNumberCheck #11  d'1~  | % PART I 11-11
\barNumberCheck #12  d'8 d'8 d'8 d'8 d'4 r4  | % PART I 12-12
\barNumberCheck #13  r8 d'8 d'8 d'8 d'4 r4  | % PART I 13-13
\barNumberCheck #14  r4 f'4( d'4 b4)  | % PART I 14-14
\barNumberCheck #15  c'4.( d'8) e'4 r4  | % PART I 15-15
\barNumberCheck #16 \mark \markup \override #'(box-padding . 0.4) \box \bold "A" R1*9  | % PART I 16-24
\barNumberCheck #25  \set Staff.weberCueId = "fluteI:25" \set Staff.weberCueLabel = "Fl." \cueDuringWithClef "fluteI" #UP "treble" { \voiceTwo \override MultiMeasureRest.staff-position = #-4  R1  \noBreak |  R1  | \revert MultiMeasureRest.staff-position } \oneVoice  | % PART I 25-26
\barNumberCheck #27 \mark \markup \override #'(box-padding . 0.4) \box \bold "B" c8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16)  | % PART I 27-27
\barNumberCheck #28  c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16)  | % PART I 28-28
\barNumberCheck #29  c8 r8 c16 e16 g16 e16 d16_\markup \italic "cresc." f16 g16 f16 e16 g16 c'16 g16  | % PART I 29-29
\barNumberCheck #30  f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g16 cis'16 e'16 cis'16  | % PART I 30-30
\barNumberCheck #31  g1:16  | % PART I 31-31
\barNumberCheck #32  g1:16\<  | % PART I 32-32
\barNumberCheck #33  <g e'>1:16\ff  | % PART I 33-33
\barNumberCheck #34  <g e'>1:16  | % PART I 34-34
\barNumberCheck #35  b8:16 d'8:16 f'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16  | % PART I 35-35
\barNumberCheck #36  g8:16 d'8:16 b'8:16 g'8:16 d'8:16 b8:16 d'8:16 g8:16  | % PART I 36-36
\barNumberCheck #37  a'8:16 c''8:16 e''8:16 c''8:16 a'8:16 e'8:16 c''8:16 a'8:16  | % PART I 37-37
\barNumberCheck #38  e'8:16 c'8:16 a'8:16 e'8:16 c'8:16 a8:16 e'8:16 a8:16  | % PART I 38-38
\barNumberCheck #39  e'8:16 g'8:16 b'8:16 g'8:16 e'8:16 b8:16 g'8:16 e'8:16  | % PART I 39-39
\barNumberCheck #40  b8:16 g8:16 b8:16 e'8:16 g'8:16 b'8:16 g'8:16 e'8:16  | % PART I 40-40
\barNumberCheck #41  <g e'>1:16  | % PART I 41-41
\barNumberCheck #42  <g d'>1:16  | % PART I 42-42
\barNumberCheck #43  d2~ d8 ees8:16 d8:16 ees8:16  | % PART I 43-43
\barNumberCheck #44  d2~ d8 ees8:16 d8:16 ees8:16  | % PART I 44-44
\barNumberCheck #45  d8:16 ees8:16 d8:16 cis8:16 d8:16 fis8:16 a4:16  | % PART I 45-45
\barNumberCheck #46  d'8:16 ees'8:16 d'8:16 cis'8:16 d'8:16 fis'8:16 a'8:16 a8:16  | % PART I 46-46
\barNumberCheck #47  d'4 d4 d4 d4  | % PART I 47-47
\barNumberCheck #48  d8_\markup \italic "cresc." <d' fis'>8:16\<^\markup \upright "div." <e' g'>8:16 <f' gis'>8:16 <fis' a'>4:16 <g' bes'>8:16 <gis' b'>8:16  | % PART I 48-48
\barNumberCheck #49  <a' c''>16( <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16 <a' c''>16 <gis' b'>16)  | % PART I 49-49
\barNumberCheck #50  <a' c''>4\!-. d4-. r2\fermata  \pageBreak | % PART I 50-50
\barNumberCheck #51 \mark \markup \override #'(box-padding . 0.4) \box \bold "C" R1*2  | % PART I 51-52
\barNumberCheck #53  c'4\pp^\markup \upright "unis." c'8. c'16 c'4 c'4  | % PART I 53-53
\barNumberCheck #54  b2. r4  | % PART I 54-54
\barNumberCheck #55  g1  | % PART I 55-55
\barNumberCheck #56  fis1  | % PART I 56-56
\barNumberCheck #57  g4 g8. g16 g4 g4  | % PART I 57-57
\barNumberCheck #58  aes1\f->  | % PART I 58-58
\barNumberCheck #59  a1(\pp  | % PART I 59-59
\barNumberCheck #60  b1)  | % PART I 60-60
\barNumberCheck #61  cis'1(  | % PART I 61-61
\barNumberCheck #62  d'4) r4 r2  | % PART I 62-62
\barNumberCheck #63  g8(\pp b8 d'8 b8 g8 b8 d'8 b8)  | % PART I 63-63
\barNumberCheck #64  g8( c'8 e'8 c'8 g8 c'8 e'8 c'8)  | % PART I 64-64
\barNumberCheck #65  c'4\p c'8. c'16 c'4 c'4  | % PART I 65-65
\barNumberCheck #66  b2. r4  | % PART I 66-66
\barNumberCheck #67  g8( b8 d'8 b8 g8 b8 d'8 b8)  | % PART I 67-67
\barNumberCheck #68  fis8( a8 c'8 a8 fis8 a8 c'8 a8)  | % PART I 68-68
\barNumberCheck #69 \mark \markup \override #'(box-padding . 0.4) \box \bold "D" a8( c'8 ees'8 c'8) f8( a8 c'8 a8  | % PART I 69-69
\barNumberCheck #70  f8 bes8 f'8 bes8 g8 c'8 ees'8 c'8  | % PART I 70-70
\barNumberCheck #71  f8 bes8 d'8 bes8 f8 a8 c'8 a8)  | % PART I 71-71
\barNumberCheck #72  b4 <b d'>8. <b d'>16 <b d'>4 <b d'>4  | % PART I 72-72
\barNumberCheck #73  <b d'>2.-> r4  | % PART I 73-73
\barNumberCheck #74  g4 g8. g16 g4 g4  | % PART I 74-74
\barNumberCheck #75  g1~  | % PART I 75-75
\barNumberCheck #76  g8-. r8 r4 r2  | % PART I 76-76
\barNumberCheck #77  r8 b8-. c'8-. cis'8-. d'8-. cis'8-. d'8-. cis'8-.  | % PART I 77-77
\barNumberCheck #78  d'8 r8 e'8\f r8 c'8 r8 d'8 r8  | % PART I 78-78
\barNumberCheck #79  R1  | % PART I 79-79
\barNumberCheck #80  r2 r8 b8-.\p c'8-. cis'8-.  | % PART I 80-80
\barNumberCheck #81  d'8-. r8 r8 cis8-. d8-. cis8-. d8-. cis8-.  | % PART I 81-81
\barNumberCheck #82  d8 r8 e'8\f r8 c'8 r8 <g d'>8 r8  | % PART I 82-82
\barNumberCheck #83 \mark \markup \override #'(box-padding . 0.4) \box \bold "E" g4:16\ff aes8:16 g8:16 a8:16 g8:16 bes8:16 g8:16  | % PART I 83-83
\barNumberCheck #84  b8:16 g8:16 c'8:16 g8:16 cis'8:16 g8:16 d'8:16 g8:16  | % PART I 84-84
\barNumberCheck #85  ees'8:16 c'8:16 a8:16 fis8:16 c''8:16 a'8:16 fis'8:16 ees'8:16  | % PART I 85-85
\barNumberCheck #86  a'8:16 fis'8:16 ees'8:16 c'8:16 fis'8:16 ees'8:16 c'8:16 a8:16  | % PART I 86-86
\barNumberCheck #87  ees'8:16 c'8:16 a8:16 fis8:16 ees8:16 fis8:16 a8:16 c'8:16  | % PART I 87-87
\barNumberCheck #88  ees'8:16 c'8:16 a8:16 c'8:16 ees'8:16 fis'8:16 a'8:16 c''8:16  | % PART I 88-88
\barNumberCheck #89  ees''4 a'8. a'16 a'4 a'4  | % PART I 89-89
\barNumberCheck #90  a'2(-> b'4-.) r4  | % PART I 90-90
\barNumberCheck #91  fis'4 fis'8. fis'16 fis'4 fis'4  | % PART I 91-91
\barNumberCheck #92  fis'2->~ fis'8 dis'16 dis'16 dis'8 dis'8  | % PART I 92-92
\barNumberCheck #93  e'8:16 dis'8:16 e'8:16 d'8:16 c'8:16 d'8:16 c'8:16 b8:16  | % PART I 93-93
\barNumberCheck #94  c'4:16 d''2:16 a'4:16  | % PART I 94-94
\barNumberCheck #95  g'16 d16 e16 fis16 g16 a16 b16 c'16 d'16 g16 a16 b16 c'16 d'16 e'16 fis'16  | % PART I 95-95
\barNumberCheck #96  g'16 d'16 e'16 fis'16 g'16 a'16 b'16 c''16 d''16 g16 a16 b16 c'16 d'16 e'16 fis'16  | % PART I 96-96
\barNumberCheck #97  g'16( fis'16 e'16 d'16 cis'16 d'16 e'16 fis'16 g'16 fis'16 g'16 a'16 b'16 a'16 b'16 c''16)  | % PART I 97-97
\barNumberCheck #98  d''4 <g e' c''>4 <g d' b'>4 <d' a'>4  | % PART I 98-98
\barNumberCheck #99  g'8:16 b'8:16 d''8:16 b'8:16 g'8:16 d'8:16 b'8:16 g'8:16  | % PART I 99-99
\barNumberCheck #100  d'8:16 b8:16 g'8:16 d'8:16 b8:16 g8:16 d'8:16 b8:16  | % PART I 100-100
\barNumberCheck #101  <g d'>4.. <g d'>16 <g d'>4.. <g d'>16  | % PART I 101-101
\barNumberCheck #102  <g d'>4 <g d'>4 r2  \pageBreak | % PART I 102-102
\barNumberCheck #103 \bar ":|."  \mark \markup \override #'(box-padding . 0.4) \box \bold "F" R1  | % PART I 103-103
\barNumberCheck #104  r2 r2\fermata  | % PART I 104-104
\barNumberCheck #105  R1  | % PART I 105-105
\barNumberCheck #106  r2 r2\fermata  | % PART I 106-106
\barNumberCheck #107  r8 e'8\pp e'8 e'8 e'4 r4  | % PART I 107-107
\barNumberCheck #108  r8 e'8 e'8 e'8 e'4 r4  | % PART I 108-108
\barNumberCheck #109  r4 e'4 b4 b4  | % PART I 109-109
\barNumberCheck #110  e2~ e8 e8 e8 e8  | % PART I 110-110
\barNumberCheck #111  dis8 r8 r4 r2  | % PART I 111-111
\barNumberCheck #112  r8 dis'8-. dis'8-. dis'8-. dis'4 r4  | % PART I 112-112
\barNumberCheck #113  r4 fis'4( fis'4 fis'4)  | % PART I 113-113
\barNumberCheck #114  a'2(-> g'8) r8 r4  | % PART I 114-114
\barNumberCheck #115  b4-.(\pp\< b4-. b4-. b4-.)  | % PART I 115-115
\barNumberCheck #116  b2->\!\>~ b8\! r8 r4  | % PART I 116-116
\barNumberCheck #117  e'4-.(\< e'4-. e'4-. e'4-.)  | % PART I 117-117
\barNumberCheck #118  fis'2(\!-> e'4) r4  | % PART I 118-118
\barNumberCheck #119  r8 g8 g8 g8 r8 g8 g8 g8  | % PART I 119-119
\barNumberCheck #120  r8 fis8 fis8 fis8 fis2~  | % PART I 120-120
\barNumberCheck #121  fis2 ais4( fis4)  | % PART I 121-121
\barNumberCheck #122 \mark \markup \override #'(box-padding . 0.4) \box \bold "G" b1:16\ff  | % PART I 122-122
\barNumberCheck #123  b1:16  | % PART I 123-123
\barNumberCheck #124  fis1:16  | % PART I 124-124
\barNumberCheck #125  fis1:16  | % PART I 125-125
\barNumberCheck #126  b1:16  | % PART I 126-126
\barNumberCheck #127  b1:16  | % PART I 127-127
\barNumberCheck #128  a1:16  | % PART I 128-128
\barNumberCheck #129  a1:16  | % PART I 129-129
\barNumberCheck #130  f1:16  | % PART I 130-130
\barNumberCheck #131  f8 c'8( bes8 a8 g8 f8 e8 f8)  | % PART I 131-131
\barNumberCheck #132  f1:16  | % PART I 132-132
\barNumberCheck #133  f1:16  | % PART I 133-133
\barNumberCheck #134  bes1:16\f  | % PART I 134-134
\barNumberCheck #135  bes1:16  | % PART I 135-135
\barNumberCheck #136  <ees bes>1:16  | % PART I 136-136
\barNumberCheck #137  <ees bes>1:16  | % PART I 137-137
\barNumberCheck #138  <g g'>1:16  | % PART I 138-138
\barNumberCheck #139  <g d'>1:16  | % PART I 139-139
\barNumberCheck #140  <g ees'>1:16  | % PART I 140-140
\barNumberCheck #141  <g ees'>1:16  | % PART I 141-141
\barNumberCheck #142  <g d'>4 r4 r8 aes16 aes16 g16-. g16-. aes16-. aes16-.  | % PART I 142-142
\barNumberCheck #143  g2~ g8 aes8:16 g8:16 aes8:16  | % PART I 143-143
\barNumberCheck #144 \mark \markup \override #'(box-padding . 0.4) \box \bold "H" aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16)  | % PART I 144-144
\barNumberCheck #145  aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16) aes16( g16 aes16 g16)  | % PART I 145-145
\barNumberCheck #146  aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b8:16 d'8:16 f'8:16  | % PART I 146-146
\barNumberCheck #147  aes'8:16 f'8:16 d'8:16 b8:16 aes8:16 f8:16 d8:16 b8:16  | % PART I 147-147
\barNumberCheck #148  aes1\pp~  | % PART I 148-148
\barNumberCheck #149  aes1~  | % PART I 149-149
\barNumberCheck #150  aes1~  | % PART I 150-150
\barNumberCheck #151  aes1  | % PART I 151-151
\barNumberCheck #152 \tempo "ritardando" g1~  | % PART I 152-152
\barNumberCheck #153  g2~ g8 r8 r4\fermata  | % PART I 153-153
\barNumberCheck #154 \tempo "Tempo I"  \mark \markup \override #'(box-padding . 0.4) \box \bold "J" g'4..\ff g'16 a'4.. a'16  | % PART I 154-154
\barNumberCheck #155  a'4-. c''4-. r2  | % PART I 155-155
\barNumberCheck #156  R1*2  | % PART I 156-157
\barNumberCheck #158  <g d'>4..\ff <g d'>16 <g d'>4.. <g d'>16  | % PART I 158-158
\barNumberCheck #159  <g g'>4-. b'4-. r2  | % PART I 159-159
\barNumberCheck #160  R1  | % PART I 160-160
\barNumberCheck #161  r8 c'8\pp c'8 c'8 c'4 r4  | % PART I 161-161
\barNumberCheck #162  r8 c'8 c'8 c'8 c'4 r4  | % PART I 162-162
\barNumberCheck #163  r4 c'4( g4 e'4)  | % PART I 163-163
\barNumberCheck #164  d'1  | % PART I 164-164
\barNumberCheck #165  R1*3  | % PART I 165-167
\barNumberCheck #168  c'8 \once \override TupletBracket.direction = #DOWN \tuplet 3/2 { d'16( c'16 b16) } c'8-. d'8-. e'4 r4  \pageBreak | % PART I 168-168
\barNumberCheck #169  r4 g'4(\< aes'4 g'4  | % PART I 169-169
\barNumberCheck #170  a'!4) c''4.\!\sf-> c''8-.\p c''8-. g'8-.  | % PART I 170-170
\barNumberCheck #171  g'8 r8 c'8 r8 c'8 r8 b8 r8  | % PART I 171-171
\barNumberCheck #172  d'2(-> g8-.) r8 r4  | % PART I 172-172
\barNumberCheck #173  \after 4*480/480 \< r2 r4 cis''4(  | % PART I 173-173
\barNumberCheck #174  d''4) c''4.\!\sf-> c''8-.\p c''8-. g'8-.  | % PART I 174-174
\barNumberCheck #175  g'8 r8 c'8 r8 c'8 r8 d'8 r8  | % PART I 175-175
\barNumberCheck #176  <c g>8\ff c''16 c''16 c''8 c''8 c''16(-> b'16 a'16 g'16) g'16(-> f'16 e'16 d'16)  | % PART I 176-176
\barNumberCheck #177  c'8 c'16 c'16 c'8 c'8 c'16(-> b16 a16 g16) g16(-> f16 e16 d16)  | % PART I 177-177
\barNumberCheck #178  c8 r8 c16 e16 g16 e16 d16 f16 g16 f16 e16 g16 c'16 g16  | % PART I 178-178
\barNumberCheck #179  f16 a16 d'16 a16 fis16 a16 d'16 a16 g16 b16 d'16 b16 g16 cis'16 e'16 cis'16  | % PART I 179-179
\barNumberCheck #180  g2:8 g2:8  | % PART I 180-180
\barNumberCheck #181  r8\<^\markup \upright "div." <g b>8:16 <a c'>8:16 <ais cis'>8:16 <b d'>4:16 <c' ees'>8:16 <cis' e'>8:16  | % PART I 181-181
\barNumberCheck #182  <d' f'>16(\ff <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16 <d' f'>16 <cis' e'>16)  | % PART I 182-182
\barNumberCheck #183  <d' f'>4-. <d' b'>4-. r2\fermata  | % PART I 183-183
\barNumberCheck #184 \mark \markup \override #'(box-padding . 0.4) \box \bold "K" e8^\markup \upright "unis."(\pp g8 c'8 e'8 g'8 e'8 c'8 g8)  | % PART I 184-184
\barNumberCheck #185  f8( a8 d'8 f'8 a'8 f'8 d'8 a8)  | % PART I 185-185
\barNumberCheck #186  f4 f'8. f'16 f'4 f'4  | % PART I 186-186
\barNumberCheck #187  e'2. r4  | % PART I 187-187
\barNumberCheck #188  e8( g8 c'8 e'8 g'8 e'8 c'8 g8)  | % PART I 188-188
\barNumberCheck #189  b8( d'8 f'8 g'8 aes'8 f'8 d'8 f'8)  | % PART I 189-189
\barNumberCheck #190  ges'4 ges'8. ges'16 ges'4 ges'4  | % PART I 190-190
\barNumberCheck #191  g'1\f->  | % PART I 191-191
\barNumberCheck #192  g'1(\p  | % PART I 192-192
\barNumberCheck #193  e'2 c'2)  | % PART I 193-193
\barNumberCheck #194  c'1(  | % PART I 194-194
\barNumberCheck #195  b8) r8 r4 r2  | % PART I 195-195
\barNumberCheck #196  e2( g2  | % PART I 196-196
\barNumberCheck #197  a2 c'2)  | % PART I 197-197
\barNumberCheck #198  b4 f'8. f'16 f'4 f'4  | % PART I 198-198
\barNumberCheck #199  e'2. r4  | % PART I 199-199
\barNumberCheck #200 \mark \markup \override #'(box-padding . 0.4) \box \bold "L" e2( g2  | % PART I 200-200
\barNumberCheck #201  f2 aes2)  | % PART I 201-201
\barNumberCheck #202  d'1  | % PART I 202-202
\barNumberCheck #203  ees'2( c'2  | % PART I 203-203
\barNumberCheck #204  bes2 d'2)  | % PART I 204-204
\barNumberCheck #205  bes4 bes8. bes16 bes4 bes4  | % PART I 205-205
\barNumberCheck #206  e'2. r4  | % PART I 206-206
\barNumberCheck #207  f2~ f8 g8( aes8 bes8  | % PART I 207-207
\barNumberCheck #208  c'4) \grace { d'16( c'16 b16 } c'8.) d'16 ees'2  | % PART I 208-208
\barNumberCheck #209  e'8\sf r8 r4 r2  | % PART I 209-209
\barNumberCheck #210  r8 e8-.\p f8-. fis8-. g8-. fis8-. g8-. fis8-.  | % PART I 210-210
\barNumberCheck #211  g4 a'8\f r8 a'8 r8 <g g'>8 r8  | % PART I 211-211
\barNumberCheck #212  R1*2  \pageBreak | % PART I 212-213
\barNumberCheck #214  r8 e8-.\p f8-. fis8-. g8-. fis8-. g8-. fis8-.  | % PART I 214-214
\barNumberCheck #215  g4 a'8\f r8 a'8 r8 <g g'>8 r8  | % PART I 215-215
\barNumberCheck #216 \mark \markup \override #'(box-padding . 0.4) \box \bold "M" <c c'>8\ff^\markup \upright "div." <c c'>8:16 <des des'>8:16 <c c'>8:16 <d d'>8:16 <c c'>8:16 <ees ees'>8:16 <c c'>8:16  | % PART I 216-216
\barNumberCheck #217  <e e'>8:16 <c c'>8:16 <f f'>8:16 <c c'>8:16 <fis fis'>8:16 <c c'>8:16 <g g'>8:16 <c c'>8:16  | % PART I 217-217
\barNumberCheck #218  aes'8:16^\markup \upright "unis." f'8:16 d'8:16 b8:16 f'8:16 d'8:16 b8:16 aes8:16  | % PART I 218-218
\barNumberCheck #219  f8:16 aes8:16 b8:16 d'8:16 f'8:16 aes'8:16 b'8:16 d''8:16  | % PART I 219-219
\barNumberCheck #220  b'8:16 aes'8:16 f'8:16 d'8:16 aes'8:16 f'8:16 d'8:16 b8:16  | % PART I 220-220
\barNumberCheck #221  aes8:16 f8:16 d8:16 f8:16 aes8:16 b8:16 d'8:16 f'8:16  | % PART I 221-221
\barNumberCheck #222  aes'4 d'8. d'16 d'4 d'4  | % PART I 222-222
\barNumberCheck #223  d'2(-> e'8) r8 r4  | % PART I 223-223
\barNumberCheck #224  gis4 gis8. gis16 gis4 gis4  | % PART I 224-224
\barNumberCheck #225  gis2->~ gis8 gis16 gis16 gis8 gis8  | % PART I 225-225
\barNumberCheck #226  a8:16 gis8:16 a8:16 g8:16 f8:16 g8:16 f8:16 e8:16  | % PART I 226-226
\barNumberCheck #227  f2:16 e4:16 fis4:16  | % PART I 227-227
\barNumberCheck #228  g8 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16  | % PART I 228-228
\barNumberCheck #229  c''16 g16 a16 b16 c'16 d'16 e'16 f'16 g'16 c'16 d'16 e'16 f'16 g'16 a'16 b'16  | % PART I 229-229
\barNumberCheck #230  c''16 b'16 a'16 g'16 fis'16 g'16 a'16 b'16 c''16 b16 c'16 d'16 e'16 d'16 e'16 f'16  | % PART I 230-230
\barNumberCheck #231  g'4 c''4 c''4 <g d' b'>4  | % PART I 231-231
\barNumberCheck #232 \mark \markup \override #'(box-padding . 0.4) \box \bold "N" c'8:16\ff e'8:16 g'8:16 e'8:16 c'8:16 g'8:16 e''8:16 c''8:16  | % PART I 232-232
\barNumberCheck #233  g'8:16 e'8:16 c''8:16 g'8:16 e'8:16 c'8:16 g'8:16 e'8:16  | % PART I 233-233
\barNumberCheck #234  c'8:16 g'8:16 e'8:16 c'8:16 g8:16 e'8:16 c'8:16 g8:16  | % PART I 234-234
\barNumberCheck #235  c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16 c'8:16 g8:16  | % PART I 235-235
\barNumberCheck #236  c'4 r4 <c g e' c''>4 r4  | % PART I 236-236
\barNumberCheck #237  c1\fermata \bar "|." | % PART I 237-237
\barNumberCheck #238
} }
\header { title = "SYMPHONY No. 2" subtitle = ##f composer = "Carl Maria von Weber (1786–1826)" piece = "I. Allegro" }

} 
\score {
\new StaffGroup << \new Staff \with { instrumentName = \markup \italic "Solo" \RemoveAllEmptyStaves \remove Page_turn_engraver \remove Mark_engraver \remove Metronome_mark_engraver \remove Measure_spanner_engraver } { \clef "alto" \transposition c' \transpose c c {
\barNumberCheck #1  \key f \major s1*1  | % PART II 1-1
\barNumberCheck #2  r4. c'8(\pp^\markup \italic "Solo" d'8 e'8 f'8 g'8  | % PART II 2-2
\barNumberCheck #3  a'2) \grace { f'16( g'16 a'16 } g'8.[) fis'16 g'8. a'16]  | % PART II 3-3
\barNumberCheck #4  f'8.( g'32 f'32) e'16-. f'16-. g'16-. a'16-. c'8. d'16 ees'16 e'16 f'16 fis'16  | % PART II 4-4
\barNumberCheck #5  g'4.\< gis'8 a'8.( bes'32 a'32) g'8 f'8  | % PART II 5-5
\barNumberCheck #6  e'8(\!-> g'16) r16 d'8(-> g'16) r16 c'4 \tuplet 6/4 { d'16-.( e'16-. f'16-. fis'16-. g'16-. gis'16-.) }  | % PART II 6-6
\barNumberCheck #7  a'2\< a'8.[ gis'16 a'8. a'16]  | % PART II 7-7
\barNumberCheck #8  b'4\f e''4 d''2  | % PART II 8-8
\barNumberCheck #9  c''4. a'8 \grace { a'8( } g'8.[) fis'16 g'8. c''16]  | % PART II 9-9
\barNumberCheck #10  c''2-> f'4 r4  | % PART II 10-10
\barNumberCheck #11  s1*49  | % PART II 11-59
\barNumberCheck #60
} } \new Staff \with { instrumentName = "Vla." } { \clef "alto" \transposition c' \transpose c c {
\barNumberCheck #1 \time 4/4 \tempo \markup { \bold \fontsize #1 "Adagio, ma non troppo" } \key f \major R1*2  | % PART II 1-2
\barNumberCheck #3  c'2(\pp bes2  | % PART II 3-3
\barNumberCheck #4  a2.) r4  | % PART II 4-4
\barNumberCheck #5  bes2( a4 c'4)  | % PART II 5-5
\barNumberCheck #6  c'8( g16) r16 b8( g16) r16 g4 r4  | % PART II 6-6
\barNumberCheck #7  c'1  | % PART II 7-7
\barNumberCheck #8  b2. d'4->  | % PART II 8-8
\barNumberCheck #9  f'4 r4 r2  | % PART II 9-9
\barNumberCheck #10  g'2-> f'4 r4  \pageBreak | % PART II 10-10
\barNumberCheck #11 \mark \markup \override #'(box-padding . 0.4) \box \bold "A" \oneVoice R1  | % PART II 11-11
\barNumberCheck #12  R1*7  | % PART II 12-18
\barNumberCheck #19  \set Staff.weberCueId = "fluteII:19" \set Staff.weberCueLabel = "Fl." \cueDuringWithClef "fluteII" #UP "treble" { \voiceTwo \override MultiMeasureRest.staff-position = #-6  R1  \noBreak |  R1  | \revert MultiMeasureRest.staff-position } \oneVoice  | % PART II 19-20
\barNumberCheck #21  c'2:8\pp c'2:8  | % PART II 21-21
\barNumberCheck #22  c'2:8 c'2:8  | % PART II 22-22
\barNumberCheck #23 \mark \markup \override #'(box-padding . 0.4) \box \bold "B" f'8\f\< f'8 d'8 d'8 d'8 d'8 e'8 f'8  | % PART II 23-23
\barNumberCheck #24  f'2(\!-> e'4) \after 4*240/480 \p r8. c'16  | % PART II 24-24
\barNumberCheck #25  a'2->( g'8) r8 r8. c'16  | % PART II 25-25
\barNumberCheck #26  d'2(\ff-> ees'8) r8 r4  | % PART II 26-26
\barNumberCheck #27  c'2:8\pp bes2:8  | % PART II 27-27
\barNumberCheck #28  ees'2:8 des'2:8  | % PART II 28-28
\barNumberCheck #29  des'2:8 des'2:8  | % PART II 29-29
\barNumberCheck #30  c'8\pp a8 a8 a8 e8(-> f16)-. r16 r4  | % PART II 30-30
\barNumberCheck #31  R1\fermata  | % PART II 31-31
\barNumberCheck #32 \mark \markup \override #'(box-padding . 0.4) \box \bold "C" R1*2  | % PART II 32-33
\barNumberCheck #34  r2 \tuplet 3/2 4 { ges'8\f ges'8 ges'8 ges'8 ges'8 ges'8 }  | % PART II 34-34
\barNumberCheck #35 \mark \markup \override #'(box-padding . 0.4) \box \bold "D" \tuplet 3/2 4 { f'8\f des'8 des'8 aes8 aes8 aes8 } \tuplet 3/2 4 { c'8 c'8 c'8 c'8 c'8 c'8 }  | % PART II 35-35
\barNumberCheck #36  \tuplet 6/4 { aes2.:8 } \tuplet 6/4 { aes2.:8 }  | % PART II 36-36
\barNumberCheck #37  \tuplet 6/4 { c'2.:8 } \tuplet 6/4 { des'2.:8 }  | % PART II 37-37
\barNumberCheck #38  \tuplet 3/2 4 { c'8 c'8 c'8 g8 g8 g8 } ees4 r4  | % PART II 38-38
\barNumberCheck #39  \tuplet 6/4 { aes'2.:8\f } \tuplet 6/4 { bes'2.:8 }  | % PART II 39-39
\barNumberCheck #40  aes'1\fp  | % PART II 40-40
\barNumberCheck #41  \tuplet 6/4 { c'2.:8\fp } \tuplet 6/4 { c'2.:8 }  | % PART II 41-41
\barNumberCheck #42  \tuplet 6/4 { c'2.:8\f } \tuplet 6/4 { c'2.:8 }  | % PART II 42-42
\barNumberCheck #43  \tuplet 6/4 { a2.:8\ff } \tuplet 6/4 { ees'2.:8 }  | % PART II 43-43
\barNumberCheck #44 \mark \markup \override #'(box-padding . 0.4) \box \bold "E" \tuplet 6/4 { ees'2.:8\pp } \tuplet 6/4 { ees'2.:8 }  | % PART II 44-44
\barNumberCheck #45  \tuplet 6/4 { d'2.:8\f } \tuplet 6/4 { f'2.:8 }  | % PART II 45-45
\barNumberCheck #46  \override TupletNumber.avoid-slur = #'ignore \override TupletNumber.extra-offset = #'(0 . 1.2) \tuplet 6/4 { d'2.:8\ff } \tuplet 3/2 4 { d'8 d'8 d'8 d'8( e'8 f'8) } \revert TupletNumber.avoid-slur \revert TupletNumber.extra-offset  | % PART II 46-46
\barNumberCheck #47  fis'2.\pp fis'4  | % PART II 47-47
\barNumberCheck #48  \tuplet 6/4 { d'2.:8\ff } d'2->  | % PART II 48-48
\barNumberCheck #49  c'1\pp  | % PART II 49-49
\barNumberCheck #50  R1*2  | % PART II 50-51
\barNumberCheck #52 \mark \markup \override #'(box-padding . 0.4) \box \bold "F" a2(\pp cis'2  | % PART II 52-52
\barNumberCheck #53  a2 a2)  | % PART II 53-53
\barNumberCheck #54  bes1  | % PART II 54-54
\barNumberCheck #55  a4 r4 r2  | % PART II 55-55
\barNumberCheck #56  <a c'>1(\pp^\markup \italic "Soli"  | % PART II 56-56
\barNumberCheck #57  <bes d'>2)-> r2  | % PART II 57-57
\barNumberCheck #58 \tempo "ritardando" R1  | % PART II 58-58
\barNumberCheck #59  R1\fermata \bar "|." | % PART II 59-59
\barNumberCheck #60
} } >>
\header { piece = "II. Adagio ma non troppo" title = ##f subtitle = ##f composer = ##f opus = ##f }
\layout {
              indent = 10\mm
              \context { \Score \consists Mark_engraver \consists Metronome_mark_engraver
                \override RehearsalMark.self-alignment-X = #LEFT
                \override RehearsalMark.staff-padding = #2
                \override MetronomeMark.staff-padding = #2 }
              \context { \Staff \remove Mark_engraver \remove Metronome_mark_engraver }
            }
} 
\score {
\new Staff \with { \remove Page_turn_engraver } { \clef "alto" \transposition c' \transpose c c {
\barNumberCheck #1 \time 3/4 \tempo \markup { \bold \fontsize #1 "Allegro" } \bar ".|:" \key c \minor << { es'2.(\p^\markup \italic "Soli" } \\ { g2.( } >>  \noPageBreak | % PART III 1-1
\barNumberCheck #2  << { d'2._\markup \italic "cresc." } \\ { aes2. } >>  \noPageBreak | % PART III 2-2
\barNumberCheck #3  << { c'4 d'4 es'4) } \\ { a2.) } >>  \noPageBreak | % PART III 3-3
\barNumberCheck #4  <g d'>4-.\! g4-. r4  \noPageBreak | % PART III 4-4
\barNumberCheck #5  c'2\ff-> c'4  \noPageBreak | % PART III 5-5
\barNumberCheck #6  c'2-> ees'4  \noPageBreak | % PART III 6-6
\barNumberCheck #7  d'2-> d'4  \noPageBreak | % PART III 7-7
\barNumberCheck #8  d'4-. g4-. r4 \bar ":|.|:" \noPageBreak | % PART III 8-8
\barNumberCheck #9 \mark \markup \override #'(box-padding . 0.4) \box \bold "A" f'2.\ff  \noPageBreak | % PART III 9-9
\barNumberCheck #10  <bes g'>2.  \noPageBreak | % PART III 10-10
\barNumberCheck #11  aes'2.~  \noPageBreak | % PART III 11-11
\barNumberCheck #12  aes'2 aes'4  \noPageBreak | % PART III 12-12
\barNumberCheck #13  g'4 c'2->  \noPageBreak | % PART III 13-13
\barNumberCheck #14  c'2-> ees'4  \noPageBreak | % PART III 14-14
\barNumberCheck #15  d'2-> d'4  \noPageBreak | % PART III 15-15
\barNumberCheck #16  c'4-. c4-. r4 \bar ":|." \once \override Score.TextMark.direction = #DOWN \textEndMark \markup \italic "Fine" \noPageBreak | % PART III 16-16
\barNumberCheck #17
} }
\header { piece = "III. Menuetto — Allegro" title = ##f subtitle = ##f composer = ##f opus = ##f }

} \noPageBreak
\score {
\new Staff \with { \remove Page_turn_engraver } { \clef "alto" \transposition c' \time 3/4 \set Score.currentBarNumber = #17 \bar ".|:" \key c \major \transpose c c {
\barNumberCheck #17 \key c \major    \mark \markup \line { \override #'(box-padding . 0.4) \box \bold "B" \hspace #0.6 \fontsize #-1.5 \bold "Trio" } \key c \major g2.\pp~  \noPageBreak | % PART III 17-17
\barNumberCheck #18  g2.~  \noPageBreak | % PART III 18-18
\barNumberCheck #19  g2.~  \noPageBreak | % PART III 19-19
\barNumberCheck #20  g2.~  \noPageBreak | % PART III 20-20
\barNumberCheck #21  g2.~  \noPageBreak | % PART III 21-21
\barNumberCheck #22  g2.~  \noPageBreak | % PART III 22-22
\barNumberCheck #23  g2.~  \noPageBreak | % PART III 23-23
\barNumberCheck #24  g4 c2->  \noPageBreak | % PART III 24-24
\barNumberCheck #25 \startMeasureSpanner R2.*2 \stopMeasureSpanner \bar ":|.|:" \noPageBreak | % PART III 25-26
\barNumberCheck #27 \mark \markup \override #'(box-padding . 0.4) \box \bold "C" d'2.\pp  \noPageBreak | % PART III 27-27
\barNumberCheck #28  g4( b4 c'4)  \noPageBreak | % PART III 28-28
\barNumberCheck #29  R2.*4  \noPageBreak | % PART III 29-32
\barNumberCheck #33  f'2.  \noPageBreak | % PART III 33-33
\barNumberCheck #34  d'4-. c'2->  \noPageBreak | % PART III 34-34
\barNumberCheck #35 \startMeasureSpanner R2.*2 \stopMeasureSpanner \bar ":|." \once \override Score.TextMark.direction = #DOWN \once \override Score.TextMark.staff-padding = #8 \once \override Score.TextMark.outside-staff-priority = #10000 \textEndMark \markup \italic "Menuetto da capo" \pageBreak | % PART III 35-36
\barNumberCheck #37
} }
\header { piece = ##f title = ##f subtitle = ##f composer = ##f opus = ##f }
\layout { indent = 0\mm }
} 
\score {
\new Staff { \clef "alto" \transposition c' \transpose c c {
\barNumberCheck #1 \time 3/4 \tempo \markup { \bold \fontsize #1 "Scherzo Presto" } \key c \major R2.  | % PART IV 1-1
\barNumberCheck #2  c8(\f d8 e8 f8 g4-.)  | % PART IV 2-2
\barNumberCheck #3  R2.\fermata  | % PART IV 3-3
\barNumberCheck #4  c8(\ff d8 e8 f8 g4~)  | % PART IV 4-4
\barNumberCheck #5  g8( a8 bes8 b8 c'4-.)  | % PART IV 5-5
\barNumberCheck #6  f8(-> g8 a8 b8 c'4-.)  | % PART IV 6-6
\barNumberCheck #7  d'4-.-> g4-. c'4-.  | % PART IV 7-7
\barNumberCheck #8  fis'2-> d'4  | % PART IV 8-8
\barNumberCheck #9  e'2-> e'4  | % PART IV 9-9
\barNumberCheck #10  e'2-> e'4  | % PART IV 10-10
\barNumberCheck #11  d'2-> d'4  | % PART IV 11-11
\barNumberCheck #12  c8(->\pp d8 e8 f8 g4~)  | % PART IV 12-12
\barNumberCheck #13  g8(-> a8 bes8 b8 c'4-.)  | % PART IV 13-13
\barNumberCheck #14  f8(-> g8 a8 b8 c'4-.)  | % PART IV 14-14
\barNumberCheck #15  d'4-.-> g4-. c'4-.  | % PART IV 15-15
\barNumberCheck #16  fis'2-> d'4  | % PART IV 16-16
\barNumberCheck #17  e'2-> e'4  | % PART IV 17-17
\barNumberCheck #18  e'2-> e'4  | % PART IV 18-18
\barNumberCheck #19  d'2-> d'4  | % PART IV 19-19
\barNumberCheck #20 \mark \markup \override #'(box-padding . 0.4) \box \bold "A" bes'2->\ff a'4  | % PART IV 20-20
\barNumberCheck #21  a'2-> g'4  | % PART IV 21-21
\barNumberCheck #22  f8( g8 a8 b8  c'4-.)  | % PART IV 22-22
\barNumberCheck #23  b4-. e4-. r4\fermata  | % PART IV 23-23
\barNumberCheck #24  R2.*4  | % PART IV 24-27
\barNumberCheck #28  f2->\ff e4  | % PART IV 28-28
\barNumberCheck #29  d2-> cis4  | % PART IV 29-29
\barNumberCheck #30  d8( e8 f8 g8  a4-.)  | % PART IV 30-30
\barNumberCheck #31  b4-. g4-. c'4-.  | % PART IV 31-31
\barNumberCheck #32 \startMeasureSpanner R2.*2 \stopMeasureSpanner | % PART IV 32-33
\barNumberCheck #34 \mark \markup \override #'(box-padding . 0.4) \box \bold "B" bes'2->\ff a'4  | % PART IV 34-34
\barNumberCheck #35  a'2-> g'4  | % PART IV 35-35
\barNumberCheck #36  f8( g8 a8 b8  c'4-.)  | % PART IV 36-36
\barNumberCheck #37  b4-. e4-. r4\fermata  | % PART IV 37-37
\barNumberCheck #38  R2.*4  | % PART IV 38-41
\barNumberCheck #42  f2->\ff e4  | % PART IV 42-42
\barNumberCheck #43  d2-> cis4  | % PART IV 43-43
\barNumberCheck #44  d8( e8 f8 g8  a4-.)  | % PART IV 44-44
\barNumberCheck #45  b4-. g4-. c'4-.  | % PART IV 45-45
\barNumberCheck #46  b'2-> c''4  | % PART IV 46-46
\barNumberCheck #47  fis'8( g'8 a'8 b'8 c''4-.)  | % PART IV 47-47
\barNumberCheck #48  <g d'>2.\sf  | % PART IV 48-48
\barNumberCheck #49  <c c'>4 r4 r4  | % PART IV 49-49
\barNumberCheck #50 \mark \markup \override #'(box-padding . 0.4) \box \bold "C" R2.*14  | % PART IV 50-63
\barNumberCheck #64  \set Staff.weberCueId = "oboeOneIV:64" \set Staff.weberCueLabel = "Ob. I" \cueDuringWithClef "oboeOneIV" #UP "treble" { \voiceTwo \override MultiMeasureRest.staff-position = #-6  R2.  \noBreak |  R2.  | \revert MultiMeasureRest.staff-position } \oneVoice  | % PART IV 64-65
\barNumberCheck #66 \mark \markup \override #'(box-padding . 0.4) \box \bold "D" d'2\p d'4  | % PART IV 66-66
\barNumberCheck #67  d'2 d'4  | % PART IV 67-67
\barNumberCheck #68  d'2 d'4  | % PART IV 68-68
\barNumberCheck #69  d'2 d'4  | % PART IV 69-69
\barNumberCheck #70  a2 a4  | % PART IV 70-70
\barNumberCheck #71  a2 a4  | % PART IV 71-71
\barNumberCheck #72  g2 b4  | % PART IV 72-72
\barNumberCheck #73  g2 g4  | % PART IV 73-73
\barNumberCheck #74  fis2.~  | % PART IV 74-74
\barNumberCheck #75  fis2.  | % PART IV 75-75
\barNumberCheck #76  g2.~  | % PART IV 76-76
\barNumberCheck #77  g4 a4 b4  | % PART IV 77-77
\barNumberCheck #78  a2 a4  | % PART IV 78-78
\barNumberCheck #79  a2.  | % PART IV 79-79
\barNumberCheck #80  a2.~  | % PART IV 80-80
\barNumberCheck #81  a2.  | % PART IV 81-81
\barNumberCheck #82  a2.\ff->~  | % PART IV 82-82
\barNumberCheck #83  a2.  | % PART IV 83-83
\barNumberCheck #84 \mark \markup \override #'(box-padding . 0.4) \box \bold "E" b4-.\ff <e e'>4-.^\markup \upright "div." <fis fis'>4-.  | % PART IV 84-84
\barNumberCheck #85  <gis gis'>4-. <a a'>4-. <b b'>4-.  | % PART IV 85-85
\barNumberCheck #86  <c' c''>4-. <b b'>4-. <a a'>4->~  | % PART IV 86-86
\barNumberCheck #87  <a a'>4 <b b'>4-. <c' c''>4-.  | % PART IV 87-87
\barNumberCheck #88  <b b'>4-. <e e'>4-. <e' e''>4-.  | % PART IV 88-88
\barNumberCheck #89  <d' d''>4-. <c' c''>4-. <b b'>4-.  | % PART IV 89-89
\barNumberCheck #90  <a a'>4-. <b b'>4-. <c' c''>4->~  | % PART IV 90-90
\barNumberCheck #91  <c' c''>4 <a a'>4-. <dis dis'>4-.  | % PART IV 91-91
\barNumberCheck #92  <e e'>4-. <e e'>4-. <gis gis'>4-.  | % PART IV 92-92
\barNumberCheck #93  <a a'>4-. <b b'>4-. <c' c''>8-. <d' d''>8-.  | % PART IV 93-93
\barNumberCheck #94  <e' e''>4-. <e e'>4-. <gis gis'>4-.  | % PART IV 94-94
\barNumberCheck #95  <a a'>4-. <b b'>4-. <c' c''>8-. <d' d''>8-.  | % PART IV 95-95
\barNumberCheck #96  <e' e''>4-. <e e'>4-. <e e'>4-.  | % PART IV 96-96
\barNumberCheck #97  <e e'>4-. <e e'>4-. <e e'>4-.  | % PART IV 97-97
\barNumberCheck #98  <e e'>4 r4 r4  | % PART IV 98-98
\barNumberCheck #99  R2.  | % PART IV 99-99
\barNumberCheck #100 \mark \markup \override #'(box-padding . 0.4) \box \bold "F" << { e'2.\pp\upbow^\markup \italic \concat { "Soli " \whiteout "(sezione)" }~ } \\ { c'2.~ } >> \oneVoice  | % PART IV 100-100
\barNumberCheck #101  << { e'2.~ } \\ { c'2.( } >> \oneVoice  | % PART IV 101-101
\barNumberCheck #102  << { e'2.~ } \\ { d'2.)~ } >> \oneVoice  | % PART IV 102-102
\barNumberCheck #103  << { e'2.~ } \\ { d'2. } >> \oneVoice  | % PART IV 103-103
\barNumberCheck #104  << { e'2.~ } \\ { c'2.~ } >> \oneVoice  | % PART IV 104-104
\barNumberCheck #105  << { e'2.~ } \\ { c'2. } >> \oneVoice  | % PART IV 105-105
\barNumberCheck #106  << { e'2.~ } \\ { gis2.~ } >> \oneVoice  | % PART IV 106-106
\barNumberCheck #107  << { e'2.~ } \\ { gis2. } >> \oneVoice  | % PART IV 107-107
\barNumberCheck #108  << { e'2.~ } \\ { c'2.~ } >> \oneVoice  | % PART IV 108-108
\barNumberCheck #109  << { e'2. } \\ { c'2. } >> \oneVoice  | % PART IV 109-109
\barNumberCheck #110  << { f'2.( } \\ { a2.( } >> \oneVoice  | % PART IV 110-110
\barNumberCheck #111  << { e'2.) } \\ { c'2.) } >> \oneVoice  | % PART IV 111-111
\barNumberCheck #112  <b g'>2.(  | % PART IV 112-112
\barNumberCheck #113  <a fis'>2.  | % PART IV 113-113
\barNumberCheck #114  <g e'>2.  | % PART IV 114-114
\barNumberCheck #115  <gis d'>2.->  \pageBreak | % PART IV 115-115
\barNumberCheck #116  <a c'>2.)~  | % PART IV 116-116
\barNumberCheck #117  <a c'>2.  | % PART IV 117-117
\barNumberCheck #118  <b d'>2.(  | % PART IV 118-118
\barNumberCheck #119  <d' e'>2.)  | % PART IV 119-119
\barNumberCheck #120  <c' e'>2.~  | % PART IV 120-120
\barNumberCheck #121  <c' e'>2.  | % PART IV 121-121
\barNumberCheck #122  <b f'>2.~  | % PART IV 122-122
\barNumberCheck #123  <b f'>2.~  | % PART IV 123-123
\barNumberCheck #124  <b f'>2.~  | % PART IV 124-124
\barNumberCheck #125  <b f'>2.~  | % PART IV 125-125
\barNumberCheck #126  <b f'>2.~  | % PART IV 126-126
\barNumberCheck #127  <b f'>2.~  | % PART IV 127-127
\barNumberCheck #128  <b f'>2.  | % PART IV 128-128
\barNumberCheck #129  R2.\fermata  | % PART IV 129-129
\barNumberCheck #130 \mark \markup \override #'(box-padding . 0.4) \box \bold "G" R2.*10  | % PART IV 130-139
\barNumberCheck #140  \set Staff.weberCueId = "fluteIV:140" \set Staff.weberCueLabel = "Fl." \cueDuringWithClef "fluteIV" #UP "treble" { \voiceTwo \override MultiMeasureRest.staff-position = #-6  R2.  \noBreak |  R2.  | \revert MultiMeasureRest.staff-position } \oneVoice  | % PART IV 140-141
\barNumberCheck #142 \mark \markup \override #'(box-padding . 0.4) \box \bold "H" c8(\ff^\markup \italic "Tutti" d8 e8 f8 g4~)  | % PART IV 142-142
\barNumberCheck #143  g8( a8 bes8 b8  c'4-.)  | % PART IV 143-143
\barNumberCheck #144  f8( g8 a8 b8  c'4-.)  | % PART IV 144-144
\barNumberCheck #145  d'4-. g4-. c'4-.  | % PART IV 145-145
\barNumberCheck #146  fis'2-> d'4  | % PART IV 146-146
\barNumberCheck #147  e'2-> e'4  | % PART IV 147-147
\barNumberCheck #148  a8( b8 c'8 d'8  e'4-.)  | % PART IV 148-148
\barNumberCheck #149  fis'4-. d'4-. g'4-.  | % PART IV 149-149
\barNumberCheck #150  R2.*6  | % PART IV 150-155
\barNumberCheck #156  \set Staff.weberCueId = "fluteIV:156" \set Staff.weberCueLabel = "Fl." \cueDuringWithClef "fluteIV" #UP "treble" { \voiceTwo \override MultiMeasureRest.staff-position = #-4  R2.  \noBreak |  R2.  | \revert MultiMeasureRest.staff-position } \oneVoice  | % PART IV 156-157
\barNumberCheck #158  d'2\ff-> d'4  | % PART IV 158-158
\barNumberCheck #159  c'2-> b4  | % PART IV 159-159
\barNumberCheck #160  a4(-> b4 c'4)  | % PART IV 160-160
\barNumberCheck #161  b2 r4\fermata  | % PART IV 161-161
\barNumberCheck #162 \mark \markup \override #'(box-padding . 0.4) \box \bold "J" R2.*4  | % PART IV 162-165
\barNumberCheck #166  f'2\f-> e'4  | % PART IV 166-166
\barNumberCheck #167  d'2-> cis'4  | % PART IV 167-167
\barNumberCheck #168  d'8(-> e'8 f'8 g'8  a'4-.)  | % PART IV 168-168
\barNumberCheck #169  b'4-.-> g'4-. c''4-.  | % PART IV 169-169
\barNumberCheck #170  g8( a8 b8 c'8  d'4-.)  | % PART IV 170-170
\barNumberCheck #171  c8( d8 e8 f8  g4-.)  | % PART IV 171-171
\barNumberCheck #172  g8( a8 b8 c'8  d'4-.)  | % PART IV 172-172
\barNumberCheck #173  c'8( d'8 e'8 f'8  g'4-.)  | % PART IV 173-173
\barNumberCheck #174  f'4-. f'4-.-> g'4-.  | % PART IV 174-174
\barNumberCheck #175  a'4 a'4-.-> g'4-.  | % PART IV 175-175
\barNumberCheck #176  f'4 f'4-.-> g'4-.  | % PART IV 176-176
\barNumberCheck #177  a'4 g'4-. a'4-.  | % PART IV 177-177
\barNumberCheck #178  a'2.->~  | % PART IV 178-178
\barNumberCheck #179  a'2.  | % PART IV 179-179
\barNumberCheck #180  a8( bes8 c'8 d'8  ees'4-.)  | % PART IV 180-180
\barNumberCheck #181  fis8( g8 a8 bes8  c'4-.)  | % PART IV 181-181
\barNumberCheck #182 \mark \markup \override #'(box-padding . 0.4) \box \bold "K" aes2.\f~  | % PART IV 182-182
\barNumberCheck #183  aes2.~  | % PART IV 183-183
\barNumberCheck #184  aes4 c'4-. d'4-.  | % PART IV 184-184
\barNumberCheck #185  ees'4 c'4-. d'4-.  | % PART IV 185-185
\barNumberCheck #186  ees'4-. c'4-. d'4-.  | % PART IV 186-186
\barNumberCheck #187  ees'4-. c'4-. d'4-.  | % PART IV 187-187
\barNumberCheck #188  ees'4-. c'4-. d'4-.  | % PART IV 188-188
\barNumberCheck #189  ees'4-.\< f'4-. fis'4-.  | % PART IV 189-189
\barNumberCheck #190 \mark \markup \override #'(box-padding . 0.4) \box \bold "L" c''2\ff-> g'4  | % PART IV 190-190
\barNumberCheck #191  g'2-> e'4  | % PART IV 191-191
\barNumberCheck #192  e'2-> c'4  | % PART IV 192-192
\barNumberCheck #193  c'2-> g4  | % PART IV 193-193
\barNumberCheck #194  g'8( a'8 b'8 c''8 d''8 c''8  | % PART IV 194-194
\barNumberCheck #195  b'8 a'8 g'8 f'8 e'8 d'8  | % PART IV 195-195
\barNumberCheck #196  c'8 b8 a8 g8) c'4  | % PART IV 196-196
\barNumberCheck #197  fis8( g8 a8 b8  c'4-.)  | % PART IV 197-197
\barNumberCheck #198  <g d'>2.\sf->  | % PART IV 198-198
\barNumberCheck #199  <c c'>4 r4 r4  | % PART IV 199-199
\barNumberCheck #200 \startMeasureSpanner R2.*2 \stopMeasureSpanner | % PART IV 200-201
\barNumberCheck #202  fis8(\pp g8 a8 b8  c'4-.)  | % PART IV 202-202
\barNumberCheck #203  R2.\fermata \bar "|." | % PART IV 203-203
\barNumberCheck #204
} }
\header { piece = "IV. Finale — Scherzo, presto" title = ##f subtitle = ##f composer = ##f opus = ##f }

} 

}

\bookpart {
  \paper { print-page-number = ##f oddHeaderMarkup = ##f evenHeaderMarkup = ##f oddFooterMarkup = ##f evenFooterMarkup = ##f page-count = #1 }
  \header { title = ##f subtitle = ##f composer = ##f tagline = ##f }
  \markup \null
}
}
