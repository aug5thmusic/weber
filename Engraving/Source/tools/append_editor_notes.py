"""Typeset Engraving Notes and append them to a freshly compiled score.

Usage: python append_editor_notes.py SCORE.pdf --content publication-notes.json
Run only on a score without an existing notes appendix, after finish_pdf.py.
"""
from pathlib import Path
import argparse,json,os,re
from xml.sax.saxutils import escape
from reportlab.platypus import BaseDocTemplate,PageTemplate,Frame,Paragraph,Spacer,KeepTogether
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from pypdf import PdfReader,PdfWriter
from pypdf.annotations import Link
from pypdf.constants import PageLabelStyle

def styled_entry_text(item, html=False):
 """Style explicitly listed terms; keep canonical JSON text free of markup."""
 text=item['text'];terms=item.get('italic_terms',[])
 if not terms:return escape(text) if html else text
 if len(set(terms))!=len(terms) or any(not isinstance(t,str) or not t for t in terms):
  raise ValueError('italic_terms must contain unique non-empty strings')
 pattern=re.compile(r'(?<!\w)(?:'+'|'.join(re.escape(t) for t in sorted(terms,key=len,reverse=True))+r')(?!\w)')
 output=[];cursor=0;seen=set()
 for match in pattern.finditer(text):
  token=match.group();seen.add(token)
  output.append(escape(text[cursor:match.start()]) if html else text[cursor:match.start()])
  output.append('<i>'+escape(token)+'</i>' if html else '*'+token+'*')
  cursor=match.end()
 # A longer explicitly styled phrase can contain another styled term.
 if any(term not in seen and not any(term in phrase for phrase in seen) for term in terms):
  raise ValueError('An italic term is absent from entry '+item['location'])
 output.append(escape(text[cursor:]) if html else text[cursor:])
 return ''.join(output)

def create(score,content_path,notes_path=None,md_path=None):
 score=Path(score);content=json.loads(Path(content_path).read_text(encoding='utf-8'))
 reader=PdfReader(score);title=content['title'];author=content['author']
 assert not any(title.upper() in p.extract_text() for p in reader.pages),'Appendix already present'
 first=int(reader.page_labels[-1])+1;front_count=len(reader.pages)-(first-1)
 assert front_count>0,'Run finish_pdf.py before appending notes'
 W,H=map(float,[reader.pages[0].mediabox.width,reader.pages[0].mediabox.height])
 notes_path=Path(notes_path or score.with_name('engraving-notes.tmp.pdf'))
 fontdir=Path(os.environ.get('WEBER_FONT_DIR','C:/Windows/Fonts'))
 files=['times.ttf','timesbd.ttf','timesi.ttf']
 if not all((fontdir/f).exists() for f in files):
  fontdir=Path('/usr/share/fonts/truetype/liberation2');files=['LiberationSerif-Regular.ttf','LiberationSerif-Bold.ttf','LiberationSerif-Italic.ttf']
 for name,file in zip(['ENText','ENBold','ENItalic'],files):pdfmetrics.registerFont(TTFont(name,str(fontdir/file)))
 pdfmetrics.registerFontFamily('ENText',normal='ENText',bold='ENBold',italic='ENItalic',boldItalic='ENBold')
 margin=64;gutter=30;cw=(W-2*margin-gutter)/2;bottom=62
 def frames(top):
  return [Frame(margin+i*(cw+gutter),bottom,cw,top-bottom,id=str(i),leftPadding=0,rightPadding=0,topPadding=0,bottomPadding=0) for i in range(2)]
 body=ParagraphStyle('body',fontName='ENText',fontSize=14,leading=18,firstLineIndent=14,spaceBefore=0,spaceAfter=0)
 head=ParagraphStyle('head',parent=body,fontName='ENBold',fontSize=17,leading=21,spaceBefore=13,spaceAfter=10,keepWithNext=True)
 def page(c,doc):
  number=first+doc.page-1;c.setFont('ENText',10)
  if number%2:c.drawString(margin,H-37,'WEBER / SYMPHONY No. 2');c.drawRightString(W-margin,H-37,str(number))
  else:c.drawString(margin,H-37,str(number));c.drawRightString(W-margin,H-37,'WEBER / SYMPHONY No. 2')
  c.setFont('ENBold',23 if doc.page==1 else 16)
  c.drawCentredString(W/2,H-76,title.upper() if doc.page==1 else title.upper()+' - continued')
  if doc.page==1:
   c.setFont('ENItalic',12.5);c.drawCentredString(W/2,H-101,author)
 doc=BaseDocTemplate(str(notes_path),pagesize=(W,H),title='Weber Symphony No. 2 - '+title,author='ChatGPT-6 Astra')
 doc.addPageTemplates([PageTemplate(id='first',frames=frames(H-127),onPage=page,autoNextPageTemplate='continued'),PageTemplate(id='continued',frames=frames(H-102),onPage=page)])
 story=[];md=['# '+title,'','*'+author+'*','','Weber: Symphony No. 2 in C major, J. 51','']
 for txt in content['introduction']:
  story.append(Paragraph(escape(txt),body));md+=[txt,'']
 for section in content['sections']:
  pending=Paragraph(escape(section['title']),head);md+=['## '+section['title'],'']
  for item in section['entries']:
   pages=item['pages'];ranges=[]
   for n in pages:
    if ranges and n==ranges[-1][-1]+1:ranges[-1].append(n)
    else:ranges.append([n])
   page_text=', '.join(str(a[0]) if len(a)==1 else str(a[0])+'-'+str(a[-1]) for a in ranges)
   ref=('Manuscript p. ' if len(pages)==1 else 'Manuscript pp. ')+page_text+'.' if pages else ''
   txt='<b>'+escape(item['location'])+'.</b> '+styled_entry_text(item,html=True)+(' <i>'+escape(ref)+'</i>' if ref else '')
   group=([pending] if pending is not None else [])+[Paragraph(txt,body)]
   story.append(KeepTogether(group));pending=None
   md+=['**'+item['location']+'.** '+styled_entry_text(item)+(' '+ref if ref else ''),'']
 doc.build(story)
 notes=PdfReader(notes_path);writer=PdfWriter();writer.clone_document_from_reader(reader);start=len(writer.pages)
 for p in notes.pages:writer.add_page(p)
 writer.set_page_label(0,front_count-1,style=PageLabelStyle.LOWERCASE_ROMAN,start=1)
 writer.set_page_label(front_count,len(writer.pages)-1,style=PageLabelStyle.DECIMAL,start=1)
 writer.add_outline_item(title,start)
 import pdfplumber
 with pdfplumber.open(score) as pdf:
  contents_indices=[i for i,p in enumerate(reader.pages) if 'CONTENTS' in p.extract_text()]
  assert len(contents_indices)==1
  contents_index=contents_indices[0]
  words=pdf.pages[contents_index].extract_words();hits=[x for x in words if x['text']==title.split()[0]]
  assert len(hits)==1,hits
  y=hits[0];rect=(y['x0'],H-y['bottom']-4,W-80,H-y['top']+4)
  assert any(x['text']==str(first) and abs(x['top']-y['top'])<3 for x in words),'Update the notes folio in the contents before appending'
  writer.add_annotation(contents_index,Link(rect=rect,target_page_index=start))
  writer.pages[contents_index]['/Annots'][-1].get_object()['/Dest'][0]=writer.pages[start].indirect_reference
 tmp=score.with_name(score.stem+'.notes-tmp.pdf')
 with tmp.open('wb') as f:writer.write(f)
 check=PdfReader(tmp)
 assert check.page_labels[front_count:]==list(map(str,range(1,len(check.pages)-front_count+1)))
 for a,b in zip(reader.pages,check.pages):assert a.get_contents().get_data()==b.get_contents().get_data()
 reader.close();check.close();tmp.replace(score)
 if md_path:Path(md_path).write_text('\n'.join(md),encoding='utf-8')
 print('Appended',len(notes.pages),'notes pages, folios',first,'to',first+len(notes.pages)-1)
 return dict(first=first,pages=len(notes.pages),last=first+len(notes.pages)-1,total=len(writer.pages),font_size=14,title=title,author=author)

if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('score');p.add_argument('--content',required=True);p.add_argument('--notes');p.add_argument('--markdown');a=p.parse_args()
 create(a.score,a.content,a.notes,a.markdown)
