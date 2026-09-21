# Weber Symphony No. 2 - Web Edition, corrected September 21, 2026

`PDFs/` contains the full score and all performance parts. The fifteen numbered player PDFs include both original and modern brass versions. `Standalone/` contains one complete self-contained LilyPond/PDF score pair and nineteen part/version pairs; each `.ly` compiles independently with LilyPond 2.26.0. `Source/` contains the coordinated engraving and build tools. Musical corrections belong in its canonical `weber-symphony-2.ly`, followed by a rebuild.

To rebuild the publication PDFs, install LilyPond 2.26.0 and Python 3 with pypdf, pdfplumber and reportlab, then run from this package:

```text
python Source/tools/rebuild.py --lilypond "PATH_TO_LILYPOND"
```

The build writes to `PDFs/`. `--output PATH` selects a different output folder; `--jobs N` controls concurrent part compilation. For a standalone file, run `lilypond -dno-point-and-click "FILENAME.ly"` in its directory. A standalone edit affects only that snapshot; use the coordinated source to propagate changes across score and parts. The release rebuild does not refresh standalone snapshots.

Use Times New Roman regular, bold and italic to reproduce the delivered typography. On Windows, the scripts use C:/Windows/Fonts; WEBER_FONT_DIR can select another folder containing times.ttf, timesbd.ttf and timesi.ttf. The scripts fall back to Liberation Serif on Linux. Font substitution can change prose layout.

Print parts at actual size on 9 × 12 inch paper, double-sided, long-edge flip. Keep covers and blank versos. The score uses 297 × 360 mm paper. See PARTS-PRINT-GUIDE.md for individual version ranges and page turns. The part set is identical in both editions.

The Web Edition contains Astra’s existing two-page Preface and three-page Engraving Notes, with paragraph indents. A five-page prose-only PDF is also supplied; it preserves the full score’s original folios and typography.
