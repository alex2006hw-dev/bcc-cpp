@echo off
set DEV86=10
if "%SED%"=="" set SED=sed

if not exist dev86*.tgz ren dev86s*.gz dev86src.tgz
if not exist dev86src.tgz goto end
c:\c\djgpp\bin\djtar -x -a -o dev86-0.16.%DEV86%/unproto dev86src.tgz >nul

for %%a in (dev86-0.16.%DEV86%\unproto) do if exist %%a\unproto.c cd %%a
for %%a in (dev86-0.16-\unproto) do if exist %%a\unproto.c cd %%a

for %%a in (tok_clas.c) do if not exist %%a copy tok_cl*.c %%a
ren unproto.c *.c~
%SED% -e "/stat\.h/s/.*/\/* & *\//" unproto.c~ >unproto.c
bcc -DREOPEN -c unproto.c -o a.o
bcc -DREOPEN -c tok_io.c -o b.o
bcc -DREOPEN -c tok_clas.c -o c.o
bcc -DREOPEN -c tok_pool.c -o d.o
bcc -DREOPEN -c vstring.c -o e.o
bcc -DREOPEN -c symbol.c -o f.o
bcc -DREOPEN -c error.c -o g.o
bcc -DREOPEN -c hash.c -o h.o
bcc -DREOPEN -c strsave.c -o i.o
echo gettimeofday() { return 0; } >j.c
bcc -c j.c
bcc -DREOPEN -o unproto.exe a.o b.o c.o d.o e.o f.o g.o h.o i.o j.o

:end
if "%SED%"=="sed" set SED=
set DEV86=
