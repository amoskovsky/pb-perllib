@call plver
set uver=%ver:-beta= Beta%
mkdir ver\%ver%
set arc=ver\%ver%\perllib-%ver%.zip
set dlfile=ver\%ver%\perllib-%ver%
del /q %arc%
pkzip25 -add %arc% ^
  n_perl.sru ^
  pbperl.sra ^
  perl58.dll ^
  PerlLib.dll ^
  readme.txt ^
  perllib-unicode-deps.zip

echo (                                       >  %dlfile%
echo 'file'=^>'perllib-%ver%.zip',               >> %dlfile%
echo 'name'=^>'PerlLib %uver% for Powerbuilder' >> %dlfile%
echo )                                       >> %dlfile%

