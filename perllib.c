#include "perllib.h"

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}
 
static void xs_init (pTHX);
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
//EXTERN_C void boot_Socket (pTHX_ CV* cv);
EXTERN_C void
xs_init(pTHX)
{
	char *file = __FILE__;
	/* DynaLoader is a special case */
	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
//	newXS("Socket::bootstrap", boot_Socket, file);
}
 
static BOOL gb_WideAPI = FALSE;
static FILE *debugOut = NULL;

void PERLLIBAPI APIENTRY PLSetWideAPI(PerlInterpreter * my_perl, BOOL ab_Wide) {
	gb_WideAPI = ab_Wide;
	open_log("perllib.log");
	dmsg("init wide=%i", gb_WideAPI);
}

int PERLLIBAPI APIENTRY PLGetVersion() {
	return 1200;
}

PerlInterpreter PERLLIBAPI * APIENTRY PLCreateInterpreter()
{
    char *embedding[] = { "", /*"-C",*/ "-e", "$^H |= 0x00800000" };
	 PerlInterpreter * my_perl;

    my_perl = perl_alloc();
    if (my_perl)
    {
		perl_construct( my_perl );
    	//perl_parse(my_perl, NULL, 3, embedding, NULL);
    	perl_parse(my_perl, xs_init, 3, embedding, NULL);
    	perl_run(my_perl);
    }
    return my_perl;
}

void PERLLIBAPI APIENTRY PLDestroyInterpreter(PerlInterpreter * my_perl)
{
    if(my_perl)
    {
       perl_destruct(my_perl);
       perl_free(my_perl);
	   close_log();
    }
}


SV PERLLIBAPI * APIENTRY PLSvEval(PerlInterpreter * my_perl, char * as_expr)
{
    SV * retval;
	dDeclUTF(as_expr, "PLSvEval");
	dmsg("eval: wcslen=%i", wcslen((const wchar_t *) as_expr));
	dmsg("eval=^%s^", UTF(as_expr));
    retval = eval_pv(UTF(as_expr), FALSE);
    if (retval && !SvOK(retval))
       retval = NULL;
	FreeUTF(as_expr);
    return retval;
}
SV PERLLIBAPI * APIENTRY PLSvNew(PerlInterpreter * my_perl)
{
	return NEWSV(1099, 0); 
}

SV PERLLIBAPI * APIENTRY PLSvEvalSv(PerlInterpreter * my_perl, SV* asv)
{

     dSP;
     SV* retval = NULL;
     STRLEN n_a;
     PUSHMARK(SP);
     eval_sv(asv, G_SCALAR|G_EVAL);
     SPAGAIN;
	 if (!SvTRUE(ERRSV))
	 {
		retval = POPs;
	 }
     PUTBACK;
     //if (croak_on_error && SvTRUE(ERRSV))
     //   croak(SvPVx(ERRSV, n_a));
     if (retval)
        SvPV_force(retval, n_a);
     return retval;
}
 
SV PERLLIBAPI * APIENTRY PLErrSv(PerlInterpreter * my_perl)
{
     return ERRSV;
}

SV PERLLIBAPI * APIENTRY PLCompErrSv(PerlInterpreter * my_perl)
{
     return get_sv("!", FALSE);
}

SV PERLLIBAPI * APIENTRY PLGetSV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create)
{
	SV *retval;
	dDeclUTF(as_name, "PLGetSV");
    retval = get_sv(UTF(as_name), ab_create);
	FreeUTF(as_name);
	return retval;
}

AV PERLLIBAPI * APIENTRY PLGetAV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create)
{
	AV *retval;
	DeclUTF(as_name);
    retval = get_av(UTF(as_name), ab_create);
	FreeUTF(as_name);
	return retval;

}

HV PERLLIBAPI * APIENTRY PLGetHV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create)
{
	HV *retval;
	DeclUTF(as_name);
    retval = get_hv(UTF(as_name), ab_create);
	FreeUTF(as_name);
	return retval;
}


void PERLLIBAPI APIENTRY PLSvSetPv(PerlInterpreter * my_perl, SV * asv, const char * as_value)
{
	DeclUTF(as_value);
    if (asv) {
        sv_setpv(asv, UTF(as_value));
		utf8_on(asv);
	}
	FreeUTF(as_value);
}


I32 PERLLIBAPI APIENTRY PLSvLEN(PerlInterpreter * my_perl, SV * asv)
{
	if (asv )
	{
		if (SvPOK(asv))
			return (I32) UTFSVLen(asv);
		else
			return (I32) UTFLen(SvPV_nolen(asv));
	}
	else
		return 0;
}

I32 PERLLIBAPI APIENTRY PLAvLEN(PerlInterpreter * my_perl, AV * aav)
{
    if (aav)
       return (U32) (av_len(aav) + 1); // av_len returns the last index
    else
    	 return 0;
}

SV PERLLIBAPI * APIENTRY PLSvFetchAV(PerlInterpreter * my_perl, AV * aav, I32 ai_index)
{
    SV **lpsv;
    lpsv = av_fetch(aav, ai_index, FALSE);
    if (!lpsv || !*lpsv)
    	return NULL;
    else
      return *lpsv;
}
void PERLLIBAPI APIENTRY PLUndefAV(PerlInterpreter * my_perl, AV * aav)
{
    if (aav)
       av_undef(aav);
}

void PERLLIBAPI APIENTRY PLSvGET(PerlInterpreter * my_perl, SV * asv, char * as_ret, I32 ai_len)
{
    if (gb_WideAPI) {
		if (!asv) {
			as_ret[0] = (char)0; 
			as_ret[1] = (char)0; 
		}
		else {
			utf2wide(SvPV_nolen(asv), as_ret, ai_len + 1);
		}
	}
	else {
		if (!asv)
			as_ret[0] = (char)0; 
  		else
			memcpy(as_ret, SvPV_nolen(asv), ai_len);
	}
}

void PERLLIBAPI APIENTRY PLSvDeRef(PerlInterpreter * my_perl, SV * asv)
{
    if (asv /*&& SvOK(asv)*/)
       SvREFCNT_dec(asv);
}


void PERLLIBAPI APIENTRY PLExtendAv(PerlInterpreter * my_perl, AV *aav, I32 ai_index )
{
   if(aav && ai_index >= 0) 	
   	av_extend(aav, ai_index);
}
 
void PERLLIBAPI APIENTRY PLStoreAv(PerlInterpreter * my_perl, AV *aav, I32 ai_index, SV *asv)
{
   if(aav && asv && ai_index >= 0) 	
   	av_store(aav, ai_index, asv);
}

char *wide2utf(const char *src) {
	//const wchar_t *s = (const wchar_t *) src;
	char *r;
	int utflen, widelen;
	widelen = wcslen((const wchar_t *) src);
	dmsg("wide2utf: wcslen=%i", widelen);
	utflen = WideCharToMultiByte(
		CP_UTF8,
		0,
		(const wchar_t *) src,
		widelen + 1, //inc Z
		NULL, // out buffer
		0,  //MB len
		NULL, // default for unmappable chars
		NULL
		);
	if (utflen <= 0) {
		r = (char*) malloc(50);
		strcpy(r, "#Wide2UTF failed");
		dmsg("Wide2UTF failed: len=%i", utflen);
	}
	else {
		r = (char*) malloc(utflen);
		utflen = WideCharToMultiByte(
			CP_UTF8,
			0,
			(const wchar_t *) src,
			widelen + 1, //inc Z
			r, // out buffer
			utflen,  //MB len
			NULL, // default for unmappable chars
			NULL
			);
	}
	return r;
}
int utf2widelen(const char *src) {
	int widelen = MultiByteToWideChar(
		CP_UTF8,
		0,
		src,
		-1, //auto calc SZ len
		NULL, // out buffer
		0  //WC len
		);
	if (widelen <= 0) {
		return 0;
	}
	else {
		return widelen - 1;  // w/o Z
	}
}

void utf2wide(const char *src, char * tgt, int buflen) {
	MultiByteToWideChar(
		CP_UTF8,
		0,
		src,
		-1, //auto calc SZ len
		(wchar_t*) tgt, // out buffer
		buflen  //WC buf len
		);
}