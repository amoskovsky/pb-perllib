$PBExportHeader$n_perl.sru
forward
global type n_perl from nonvisualobject
end type
end forward

shared variables

end variables

global type n_perl from nonvisualobject autoinstantiate
end type

type prototypes

/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/



protected:
Function /*PL*/ulong CreateInterpreter() alias for "_PLCreateInterpreter@0"  Library "perllib.dll"
Subroutine DestroyInterpreter(/*PL*/ulong apo_perl)  alias for "_PLDestroyInterpreter@4" Library "perllib.dll"
Function /*SV*/ulong SVEval(/*PL*/ulong apo_perl, readonly string as_expr)  alias for "_PLSvEval@8" Library "perllib.dll"
Function /*SV*/ulong SvEvalSV(/*PL*/ulong apo_perl, /*SV*/ulong asv)  alias for "_PLSvEvalSv@8" Library "perllib.dll"
Function /*SV*/ulong ErrSv(/*PL*/ulong apo_perl)  alias for "_PLErrSv@4" Library "perllib.dll"
Function /*SV*/ulong CompErrSv(/*PL*/ulong apo_perl)  alias for "_PLCompErrSv@4" Library "perllib.dll"

Function long SvLEN(/*PL*/ulong apo_perl, /*SV*/ulong asv)  alias for "_PLSvLEN@8" Library "perllib.dll"
Subroutine SvGET(/*PL*/ulong apo_perl, /*SV*/ulong asv, ref string as_ret, long ai_len)  alias for "_PLSvGET@16" Library "perllib.dll"
Subroutine SvUndef(/*PL*/ulong apo_perl, /*SV*/ulong asv)  alias for "_PLSvDeRef@8" Library "perllib.dll"
Subroutine AvUndef(/*PL*/ulong apo_perl, /*AV*/ulong asv)  alias for "_PLUndefAV@8" Library "perllib.dll"

Function /*SV*/ulong SvNew(/*PL*/ulong apo_perl)  alias for "_PLSvNew@4" Library "perllib.dll"
Function /*SV*/ulong SVGet(/*PL*/ulong apo_perl, readonly string as_name, boolean ab_create)  alias for "_PLGetSV@12" Library "perllib.dll"
Function /*AV*/ulong AVGet(/*PL*/ulong apo_perl, readonly string as_name, boolean ab_create)  alias for "_PLGetAV@12" Library "perllib.dll"
Function /*HV*/ulong HVGet(/*PL*/ulong apo_perl, readonly string as_name, boolean ab_create)  alias for "_PLGetHV@12" Library "perllib.dll"

Subroutine SVSet(/*PL*/ulong apo_perl, /*SV*/ulong asv, readonly string as_value)  alias for "_PLSvSetPv@12" Library "perllib.dll"
Function /*AV*/ulong AVMatches(/*PL*/ulong apo_perl, readonly string as_string, readonly string as_pattern)  alias for "_PLMatches@12" Library "perllib.dll"
Function long AvLEN(/*PL*/ulong apo_perl, /*AV*/ulong aav)  alias for "_PLAvLEN@8" Library "perllib.dll"
Function /*SV*/ulong SVFetchAV(/*PL*/ulong apo_perl, /*AV*/ulong aav, long ai_index)  alias for "_PLSvFetchAV@12" Library "perllib.dll"
Subroutine StoreAV(/*PL*/ulong apo_perl, /*AV*/ulong aav, long ai_index, /*SV*/ulong asv)  alias for "_PLStoreAv@16" Library "perllib.dll"
Subroutine ExtendAV(/*PL*/ulong apo_perl, /*AV*/ulong aav, long ai_index)  alias for "_PLExtendAv@12" Library "perllib.dll"
Subroutine SetWideAPI(/*PL*/ulong apo_perl, boolean ab_wide)  alias for "_PLSetWideAPI@8" Library "perllib.dll"
Function long GetDllVersion()  alias for "_PLGetVersion@0" Library "perllib.dll"

end prototypes

type variables

/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/

Public:
Constant String PerlLibVersion = "1.2"
Constant Long PerlLibDLLVersion = 1200

Protected:
Boolean ib_AutoCreate = False // change this to autocreate in the constructor
Boolean ib_Created = False
//protected:
ULONG ipo_perl = 0
long ii_instance_count = 0

Public:
Constant Ulong NULL = 0

String ErrorText = ""
Boolean Errors = False
String M[]
Boolean RaiseError = False



end variables

forward prototypes
public function integer of_create ()
public subroutine of_destroy ()
public function boolean of_errors ()
public function string of_eval (readonly string as_expr)
public function string of_evalsaveerr (readonly string as_expr)
public function long of_getav (readonly string as_avname, ref string as_ret[])
public function string of_getsv (readonly string as_name)
protected function string of_getsv (unsignedlong asv)
public function long of_matches (readonly string as_string, readonly string as_pattern)
public function long of_matches (readonly string as_string, readonly string as_pattern, ref string as_found[])
public function long of_subst (ref string as_string, readonly string as_pattern)
end prototypes

public function integer of_create ();
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


If ib_Created Then Return 1
If ii_instance_count > 0 Then
	ii_instance_count ++
	Return 1
Else
	ipo_perl = CreateInterpreter()
End IF
If ipo_perl = 0 Then
	Return -1
End If
If PerlLibDLLVersion <> GetDLLVersion() Then
	DestroyInterpreter(ipo_perl)
	ipo_perl = 0
	Return -1
End If

Environment env
GetEnvironment(env)
If env.PBMajorRevision >= 10 Then
	SetWideAPI(ipo_perl, True)
Else
	SetWideAPI(ipo_perl, False)
End If

ii_instance_count = 1
ib_Created = True

Return 1
	
end function

public subroutine of_destroy ();
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


If Not ib_Created Then Return
If ii_instance_count > 1 Then
Else
	DestroyInterpreter(ipo_perl)
	ipo_perl = 0
End IF
ii_instance_count --
ib_Created = False
end subroutine

public function boolean of_errors ();
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/



//ErrorText = of_GetSv(CompErrSV(ipo_perl))
//ErrorText = of_GetSv(SVGet(ipo_perl, "!", False))
//If ErrorText = "" Then ErrorText = of_GetSv(ErrSV(ipo_perl))
ErrorText = of_GetSv(ErrSV(ipo_perl))
Errors =  ErrorText <> ""
If Errors And RaiseError Then
	MessageBox(this.ClassName(), ErrorText)
End IF
Return Errors

end function

public function string of_eval (readonly string as_expr);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


ULong lsv_ret
String ls_ret
//lsv_ret = SvEval(ipo_perl, "scalar eval {" + as_expr + "}") 
lsv_ret = SvEval(ipo_perl, as_expr) 
of_Errors()
ls_ret = of_GetSv(lsv_ret)
SvUndef(ipo_perl, lsv_ret)

Return ls_ret
end function

public function string of_evalsaveerr (readonly string as_expr);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


ULong  lsv_ret
String ls_ret
lsv_ret = SvEval(ipo_perl, as_expr) 
ls_ret = of_GetSv(lsv_ret)
SvUndef(ipo_perl, lsv_ret)

Return ls_ret
end function

public function long of_getav (readonly string as_avname, ref string as_ret[]);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


Ulong lav_ret, lsv_item
String ls_dummy[]
as_ret[] = ls_dummy[]
lav_ret = AvGet(ipo_perl,as_avname, False) // get AV or NULL
If lav_ret = NULL Then
	Return 0
End IF

Long li_foundn, li_i
li_foundn = AvLen(ipo_perl, lav_ret)
For li_i = 1 To li_foundn
	lsv_item = SvFetchAV (ipo_perl, lav_ret, li_i - 1)
	as_ret[li_i] = of_GetSv(lsv_item)
//	SVUndef(ipo_perl, lsv_item)
Next
Return li_foundn

end function

public function string of_getsv (readonly string as_name);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


Ulong lsv_var

lsv_var = SVGet(ipo_perl, as_name, False)
If lsv_var = NULL Then
	ErrorText = ClassName() +": No such variable ($"+as_name+")"
	Errors = True
	If RaiseError Then
		MessageBox(ClassName(), ErrorText)
	End IF
	Return ""
End IF
Return of_GetSV(lsv_var)

end function

protected function string of_getsv (unsignedlong asv);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


String ls_ret
ULong li_len
If asv = NULL Then
	ls_ret = ""
Else
	li_len = SvLEN(ipo_perl, asv)
	ls_ret = Space(li_len)
	SvGET(ipo_perl, asv, ls_ret, li_len)
End IF
Return ls_ret
end function

public function long of_matches (readonly string as_string, readonly string as_pattern);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/

Ulong lav_matches, lsv_string, lsv_ret, lsv_re
String ls_dummy[]
M = ls_dummy[]

lsv_string = SvGet (ipo_perl,"n_perl::tmp", True) //Create $n_perl::tmp
SvSet(ipo_perl, lsv_string, as_string)

of_Eval("@n_perl::tmp = ($n_perl::tmp =~~ "+ as_pattern +"); $n_perl::tmp = undef;")
If Not Errors Then
	Long li_foundn
	li_foundn = of_GetAV("n_perl::tmp", M)
	//AVUndef(ipo_perl, AVGet(ipo_perl,"n_perl::tmp", False))
	of_EvalSaveErr("@n_perl::tmp =();")
	Return li_foundn
Else
	Return 0
End IF
end function

public function long of_matches (readonly string as_string, readonly string as_pattern, ref string as_found[]);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


of_Matches(as_string, as_pattern)
as_found[] = m[]
Return UpperBound(as_found[])
end function

public function long of_subst (ref string as_string, readonly string as_pattern);
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


Ulong lsv_string
Long li_foundn
String ls_dummy[], ls_ret
M = ls_dummy[]

lsv_string = SvGet (ipo_perl,"n_perl::tmp", True) //Create $n_perl::tmp
SvSet(ipo_perl, lsv_string, as_string)

li_foundn = Long(of_Eval("$n_perl::tmp =~~ "+ as_pattern +";")) 
If Not Errors Then
	ls_ret = of_GetSv(lsv_string)
	as_string = ls_ret
	of_EvalSaveErr("$n_perl::tmp = undef; ")
Else
	of_EvalSaveErr("$n_perl::tmp = undef; ")
End If
Return li_foundn
end function

on n_perl.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_perl.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


of_Destroy()
end event

event constructor;
/******************************************************************
This module is a part of PerlLib.
Copyright (C) 2001-2006, Anatoly Moskovsky <avm@sqlbatch.com>

PerlLib is a library for access Perl functions and modules from PowerBuilder
Please, send bug reports to <perllib@sqlbatch.com>
******************************************************************/


If ib_AutoCreate Then
	of_Create()
End IF
end event

