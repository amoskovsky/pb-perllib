$PBExportHeader$pbperl.sra
$PBExportComments$Generated Application Object
forward
global type pbperl from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbperl from application
string appname = "pbperl"
end type
global pbperl pbperl

on pbperl.create
appname="pbperl"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbperl.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


//Examples of using PerlLib for PB

// init interpreter
n_perl perl
If perl.of_Create() <> 1 Then
	MessageBox("Error", "Could not initialize Perl interpreter.", StopSign!)
	Return
End If 
perl.RaiseError = True // a messagebox only

// In Perl:  
// $ret = eval "(12355/13) . ': test'";
// print $ret;
// In PB:
String ls_ret
ls_ret = perl.of_Eval("(12355/13) . ': testÚÂÒÚ'");
MessageBox("Example 1: expressions", ls_ret)

//Return 

// In Perl:  
// if ("a b c d c" =~ /([ac])/g) { print "$1:$2:$3";}
// In PB:
If perl.of_Matches("a b c d c", "/([ac])/g") >= 3 Then
	MessageBox("Example 2: regex match", perl.m[1] + ":" + perl.m[2] + ":" + perl.m[3])
End If

// In Perl:  
// @a = ("a b c d c" =~ /([ac])/g);
// print "$a[0]:$a[1]:$a[1]";
// In PB:
String ls_matches[]
If perl.of_Matches("a b c d c", "/([ac])/g", ls_matches[]) >= 3 Then
	MessageBox("Example 3:  regex match with result", ls_matches[1] + ":" + ls_matches[2] + ":" + ls_matches[3])
End If


 
// In Perl: 
// $a = "a b c d c";
// if ($a =~ s/([ac])/s/g) { print $a;}
// In PB:
String ls_subst = "a b c d c"
If perl.of_Subst(ls_subst, "s/([ac])/s/g") > 0 Then
	MessageBox("Example 4: regex substitution", ls_subst)
End If


// In Perl: 
// open F, "<c:/autoexec.bat";
// $a = join "", <F>;
// close F;
// print $a;
// In PB:
MessageBox("Example 5: built-in functions: join, map, grep,  split", perl.of_Eval(&
'&
$a = join "", map {"$_\n"} grep { $i++ < 10} split /;/, $ENV{PATH}; &
$a; &
'))

// In Perl:  
// $ret = eval "require ttttttt;";
// print $@;
// In PB:

perl.RaiseError = False
perl.of_Eval("require ttttttt;");
MessageBox("Example 6: error processing", perl.ErrorText)

// In Perl:  
// use Data::Dumper;
// print Dumper({AA=>22});
// In PB:

perl.RaiseError = True
MessageBox("Example 7: use module; (only for full Perl installation)", perl.of_Eval("use Data::Dumper;  Dumper({AA=>22})"))

// misc examples
perl.RaiseError = True


perl.of_Eval("$a = 'test'")
MessageBox("Example 8: get a scalar", &
		perl.of_GetSV("a"))


perl.of_Eval("@a = (1,2,3);")
String ls_av[]
perl.of_GetAV("a", ls_av)
MessageBox("Example 9: get an array", &
		ls_av[1] + ls_av[2] + ls_av[3])


MessageBox("Example 10: clear an array", perl.of_Eval("@a = ();"))


perl.of_Eval("$a = 'Cyrillic letters: ¿¡¬√ƒ‡·‚„‰'")
MessageBox("Example 11: NLS example", &
		perl.of_GetSV("a"))

end event

