PerlLib is a library for accessing Perl functions and modules 
from PowerBuilder

Author: Anatoly Moskovsky <avm@sqlbatch.com>
License: PUBLIC DOMAIN


INSTALLATION

There are two configurations. Those depend on whether Perl's been installed
on your PC or not.
0. The common steps of the installation.
- unpack "perllib.dll" to your PB project dir or to a dir in the PATH. 
- import "n_perl.sru" into one of your PBLs.

1. If you have installed Active Perl 5.8.x (builds 8XX) or 
compiled Perl 5.8.x from CPAN with BUILD_FLAVOR=ActivePerl, then you
don't need any other steps.

2. If you don't have Perl installed, just copy "perl58.dll" from the archive 
to your PB project dir or to a dir in the PATH. Then extract perllib-unicode-deps.zip
to the directory where "perl58.dll" is in. 
In this case you won't be able to "use" standard modules (except unicode related). 
In other words, you'll have a naked Perl interpreter with the built-in functions available only. 
However, this still gives you the power of Perl's regex'es and string 
processing primitives and you can "use" your own modules, just put them into
a dir. from @INC.

The supplied version of Perl is Active Perl build 811 (5.8.6)

Note 1. Supported both Unicode and ANSI versions of PowerBuilder

Note 2. Under Unicode PB (PB10 and higher) strings being passed to Perl are
converted from UTF16 to UTF8 which is used internally by Perl for Unicode.

EXAMPLES

There is a sample application in the archive ("pbperl.sra").
Import it into a PBL or just copy the application's open script 
from "pbperl.sra".







