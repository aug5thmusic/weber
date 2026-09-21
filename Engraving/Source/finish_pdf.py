"""Add Roman/Arabic viewer page labels and score navigation after LilyPond.

Usage: python finish_pdf.py weber-symphony-2.pdf [--front-matter N]
Requires pypdf. The printed music, links and page dimensions stay unchanged.
The title leaf is counted as i even though its printed folio is suppressed.
"""
from pathlib import Path
import argparse,re
from pypdf import PdfReader,PdfWriter
from pypdf.constants import PageLabelStyle

def finish(path,front_matter=None):
    path=Path(path).resolve();reader=PdfReader(path)
    texts=[p.extract_text() for p in reader.pages]
    if front_matter is None:
        candidates=[i for i,t in enumerate(texts) if ('I. Allegro' in t or 'SYMPHONY NO. 2' in t) and '/noteheads.' in t]
        if len(candidates)!=1:
            raise ValueError('Cannot locate the first music page uniquely; specify --front-matter N.')
        front_matter=candidates[0]
    assert 0<front_matter<len(reader.pages)
    writer=PdfWriter();writer.clone_document_from_reader(reader)
    writer.set_page_label(0,front_matter-1,style=PageLabelStyle.LOWERCASE_ROMAN,start=1)
    writer.set_page_label(front_matter,len(reader.pages)-1,style=PageLabelStyle.DECIMAL,start=1)
    if not reader.outline:
        writer.add_outline_item('Title',0)
        for i,t in enumerate(texts[:front_matter]):
            if 'PREFACE' in t and 'By ChatGPT-6 Astra' in t:writer.add_outline_item('Preface',i)
            if 'CONTENTS' in t:writer.add_outline_item('Contents',i)
        for label in ['I. Allegro','II. Adagio, ma non troppo','III. Menuetto','IV. Finale']:
            hits=[front_matter] if label=='I. Allegro' else [i for i,t in enumerate(texts) if i>=front_matter and label in t]
            assert len(hits)==1,(label,hits)
            writer.add_outline_item(label,hits[0])
    temp=path.with_name(path.stem+'.labels-tmp.pdf')
    with temp.open('wb') as stream:writer.write(stream)
    check=PdfReader(temp)
    assert check.page_labels[0]=='i'
    assert check.page_labels[front_matter:]==[str(n) for n in range(1,len(reader.pages)-front_matter+1)]
    for a,b in zip(reader.pages,check.pages):
        assert a.get_contents().get_data()==b.get_contents().get_data()
        assert a.mediabox==b.mediabox and a.extract_text()==b.extract_text()
        assert len(a.get('/Annots',[]))==len(b.get('/Annots',[]))
    reader.close();check.close();temp.replace(path)
    print(f'{path.name}: {front_matter} Roman preliminaries; music 1-{len(writer.pages)-front_matter}; content unchanged')

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('pdf',nargs='?',default='weber-symphony-2.pdf')
    parser.add_argument('--front-matter',type=int)
    args=parser.parse_args();finish(args.pdf,args.front_matter)
