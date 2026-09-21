"""Render the two-page preface and insert it after a freshly compiled title.

Run before finish_pdf.py and append_editor_notes.py. LilyPond prints the
contents folio as iv; this step supplies the intervening pages ii and iii.
"""
from pathlib import Path
from io import BytesIO
import argparse, json, os
from xml.sax.saxutils import escape
from reportlab.platypus import BaseDocTemplate, PageTemplate, Frame, Paragraph, LayoutError
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from pypdf import PdfReader, PdfWriter
from pypdf.annotations import Link

def register_fonts():
    fonts=Path(os.environ.get('WEBER_FONT_DIR', 'C:/Windows/Fonts'))
    files=['times.ttf','timesbd.ttf','timesi.ttf']
    if not all((fonts/f).exists() for f in files):
        fonts=Path('/usr/share/fonts/truetype/liberation2')
        files=['LiberationSerif-Regular.ttf','LiberationSerif-Bold.ttf','LiberationSerif-Italic.ttf']
    for name,file in zip(['PrefaceText','PrefaceBold','PrefaceItalic'],files):
        pdfmetrics.registerFont(TTFont(name,str(fonts/file)))

def typeset_preface(content, width, height, font_size):
    """Flow all paragraphs through two pages, retaining the original text area."""
    stream=BytesIO()
    body=ParagraphStyle('Preface',fontName='PrefaceText',fontSize=font_size,
                        leading=font_size*1.25,firstLineIndent=font_size,
                        spaceBefore=0,spaceAfter=0,allowWidows=0,allowOrphans=0)
    opening=ParagraphStyle('opening',parent=body,firstLineIndent=0)
    text_width=630
    left=(width-text_width)/2
    def frame(top):
        return Frame(left,83,text_width,top-83,leftPadding=0,rightPadding=0,topPadding=0,bottomPadding=0)
    def draw_page(canvas,doc):
        if doc.page>2:
            raise LayoutError('Preface needs a third page at this font size')
        canvas.setFont('PrefaceBold',25 if doc.page==1 else 14)
        canvas.drawCentredString(width/2,height-(78 if doc.page==1 else 66),'PREFACE')
        if doc.page==1:
            canvas.setFont('PrefaceItalic',13)
            canvas.drawCentredString(width/2,height-105,'By '+content['author'])
        canvas.setFont('PrefaceText',11)
        canvas.drawCentredString(width/2,49,['ii','iii'][doc.page-1])
    doc=BaseDocTemplate(stream,pagesize=(width,height),title='Weber Symphony No. 2 - Preface',author=content['author'])
    doc.addPageTemplates([
        PageTemplate(id='first',frames=[frame(height-135)],onPage=draw_page,autoNextPageTemplate='continuation'),
        PageTemplate(id='continuation',frames=[frame(height-98)],onPage=draw_page)
    ])
    story=[]
    paragraphs=[paragraph for group in content['pages'] for paragraph in group]
    for index,paragraph in enumerate(paragraphs):
        story.append(Paragraph(escape(paragraph),opening if index==0 else body))
    signature=ParagraphStyle('signature',parent=body,fontName='PrefaceItalic',fontSize=12.5,leading=18,firstLineIndent=0,spaceBefore=8,alignment=2)
    story.append(Paragraph(escape(content['author'])+'<br/>'+escape(content['date']),signature))
    doc.build(story)
    return stream.getvalue()

def fit_preface(content,width,height):
    """Select the largest size in 0.1-point steps with 1.25 line spacing."""
    def fits(tenths):
        try:
            data=typeset_preface(content,width,height,tenths/10)
            return len(PdfReader(BytesIO(data)).pages)<=2
        except LayoutError:
            return False
    low,high=145,290
    if not fits(low):
        raise ValueError('Preface no longer fits at the original 14.5-point size')
    while fits(high):
        high*=2
    while high-low>1:
        middle=(low+high)//2
        if fits(middle):low=middle
        else:high=middle
    size=low/10
    data=typeset_preface(content,width,height,size)
    assert len(PdfReader(BytesIO(data)).pages)==2
    assert not fits(low+1), 'The next font size must overflow'
    return data,size

def add_preface(score, content_path, proof_path=None, markdown_path=None):
    score=Path(score)
    content=json.loads(Path(content_path).read_text(encoding='utf-8'))
    reader=PdfReader(score)
    assert not any('PREFACE' in p.extract_text() for p in reader.pages)
    assert 'CONTENTS' in reader.pages[1].extract_text()
    assert not reader.outline, 'Insert into a freshly compiled, unlabelled score'
    width,height=map(float,(reader.pages[0].mediabox.width, reader.pages[0].mediabox.height))
    register_fonts()
    proof_path=Path(proof_path or score.with_name('preface.tmp.pdf'))
    data,size=fit_preface(content,width,height)
    proof_path.write_bytes(data)
    preface=PdfReader(proof_path)
    assert len(preface.pages)==2, 'Preface overflowed its two reserved pages'
    writer=PdfWriter();writer.clone_document_from_reader(reader)
    for index,page in enumerate(preface.pages):writer.insert_page(page,index+1)
    import pdfplumber
    with pdfplumber.open(score) as pdf:
        words=pdf.pages[1].extract_words()
        hits=[w for w in words if w['text']=='Preface']
        assert len(hits)==1, 'Add Preface ii to the LilyPond contents'
        word=hits[0]
        assert any(w['text']=='ii' and abs(w['top']-word['top'])<3 for w in words)
        writer.add_annotation(3,Link(rect=(word['x0'],height-word['bottom']-4,width-80,height-word['top']+4),target_page_index=1))
        writer.pages[3]['/Annots'][-1].get_object()['/Dest'][0]=writer.pages[1].indirect_reference
    temporary=score.with_name(score.stem+'.preface-tmp.pdf')
    with temporary.open('wb') as stream:writer.write(stream)
    check=PdfReader(temporary)
    for index,page in enumerate(reader.pages):
        target=check.pages[index if index==0 else index+2]
        assert page.get_contents().get_data()==target.get_contents().get_data()
    reader.close();check.close();temporary.replace(score)
    if markdown_path:
        lines=['# '+content['title'],'','*By '+content['author']+'*','']
        for paragraphs in content['pages']:
            for paragraph in paragraphs:lines.extend([paragraph,''])
        lines.extend(['*'+content['author']+'*','',content['date'],''])
        Path(markdown_path).write_text('\n'.join(lines),encoding='utf-8')
    print(f'Inserted preface, ii-iii: {size:.1f} pt on {size*1.25:g} pt leading, '
          f'{size:.1f} pt paragraph indents; no paragraph gaps. '
          f'{size+0.1:.1f} pt requires a third page.')

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('score');parser.add_argument('--content',required=True)
    parser.add_argument('--proof');parser.add_argument('--markdown')
    args=parser.parse_args()
    add_preface(args.score,args.content,args.proof,args.markdown)
