from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from contextlib import contextmanager
import argparse,json,shutil,subprocess,sys,uuid

ROOT=Path(__file__).resolve().parent.parent
parser=argparse.ArgumentParser(description='Recompile the full score and all published part PDFs.')
parser.add_argument('--lilypond',default=shutil.which('lilypond'))
parser.add_argument('--output',type=Path,default=ROOT.parent/'PDFs')
parser.add_argument('--jobs',type=int,default=2)
args=parser.parse_args()
if not args.lilypond:parser.error('Supply --lilypond with the path to LilyPond 2.26.0.')
lily=Path(args.lilypond).resolve()
if not lily.is_file():parser.error('LilyPond executable not found.')
if args.jobs<1:parser.error('--jobs must be positive.')
output=args.output.resolve()

def run(command,cwd):
 subprocess.run([str(x) for x in command],cwd=cwd,check=True)

@contextmanager
def build_directory():
 work=ROOT.parent/('.weber-build-'+uuid.uuid4().hex)
 work.mkdir()
 try:
  yield work
 finally:
  if work.resolve().parent!=ROOT.parent.resolve() or not work.name.startswith('.weber-build-'):
   raise RuntimeError('Unexpected build directory; cleanup refused.')
  shutil.rmtree(work)

with build_directory() as work:
 shutil.copytree(ROOT,work,dirs_exist_ok=True,ignore=shutil.ignore_patterns('__pycache__','*.pyc'))
 score=work/'Weber Symphony No. 2 - Full Score.pdf'
 run([lily,'-dno-point-and-click','-o',score.with_suffix(''),work/'weber-symphony-2.ly'],work)
 run([sys.executable,work/'tools/add_preface.py',score,'--content',work/'sources/preface.json','--proof',work/'sources/preface-proof.pdf'],work)
 run([sys.executable,work/'finish_pdf.py',score],work)
 run([sys.executable,work/'tools/append_editor_notes.py',score,'--content',work/'sources/publication-notes.json','--notes',work/'sources/editor-notes-proof.pdf'],work)
 run([sys.executable,work/'tools/build_parts.py'],work)
 parts=work/'sources/parts'
 manifest=json.loads((parts/'manifest.json').read_text(encoding='utf-8'))
 def compile_part(item):run([lily,'-dno-point-and-click','-o',parts/item['id'],parts/(item['id']+'.ly')],parts)
 with ThreadPoolExecutor(max_workers=args.jobs) as pool:list(pool.map(compile_part,manifest))
 run([sys.executable,work/'tools/assemble_parts_volume.py'],work)
 output.mkdir(parents=True,exist_ok=True)
 (output/'Parts').mkdir(exist_ok=True)
 shutil.copy2(score,output/score.name)
 for pdf in (work/'Parts').glob('*.pdf'):shutil.copy2(pdf,output/'Parts'/pdf.name)
print('PDFs written to '+str(output))
