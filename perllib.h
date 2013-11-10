#include <EXTERN.h>
#include <perl.h>

#include <windows.h>

#define PERLLIBAPI   __declspec( dllexport ) 

PerlInterpreter PERLLIBAPI * APIENTRY PLCreateInterpreter();
void 	PERLLIBAPI 		APIENTRY PLDestroyInterpreter(PerlInterpreter * my_perl);
SV 	PERLLIBAPI * 	APIENTRY PLSvEval(PerlInterpreter * my_perl, char * as_expr);
SV 	PERLLIBAPI * 	APIENTRY PLGetSV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create);
AV 	PERLLIBAPI * 	APIENTRY PLGetAV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create);
HV 	PERLLIBAPI * 	APIENTRY PLGetHV(PerlInterpreter * my_perl, const char * as_name, BOOL ab_create);
void 	PERLLIBAPI 		APIENTRY PLSvSetPv(PerlInterpreter * my_perl, SV * asv, const char * as_value);
I32 	PERLLIBAPI 		APIENTRY PLSvLEN(PerlInterpreter * my_perl, SV * asv);
I32 PERLLIBAPI 		APIENTRY PLAvLEN(PerlInterpreter * my_perl, AV * aav);
SV 	PERLLIBAPI * 	APIENTRY PLSvFetchAV(PerlInterpreter * my_perl, AV * aav, I32 ai_index);
void 	PERLLIBAPI 		APIENTRY PLUndefAV(PerlInterpreter * my_perl, AV * aav);
void 	PERLLIBAPI 		APIENTRY PLSvGET(PerlInterpreter * my_perl, SV * asv, char * as_ret, I32 ai_len);
void 	PERLLIBAPI 		APIENTRY PLSvDeRef(PerlInterpreter * my_perl, SV * asv);
SV 	PERLLIBAPI * 	APIENTRY PLSvEvalSv(PerlInterpreter * my_perl, SV* asv);
SV 	PERLLIBAPI * 	APIENTRY PLSvNew(PerlInterpreter * my_perl);
SV 	PERLLIBAPI * 	APIENTRY PLErrSv(PerlInterpreter * my_perl);
void 	PERLLIBAPI 		APIENTRY PLExtendAv(PerlInterpreter * my_perl, AV *aav, I32 ai_index );
void 	PERLLIBAPI 		APIENTRY PLStoreAv(PerlInterpreter * my_perl, AV *aav, I32 ai_index, SV *asv);
void PERLLIBAPI APIENTRY PLSetWideAPI(PerlInterpreter * my_perl, BOOL ab_Wide);
int PERLLIBAPI APIENTRY PLGetVersion();

char *wide2utf(const char *src);
int utf2widelen(const char *src);
void utf2wide(const char *src, char * tgt, int buflen);


 
#define DeclUTF(s) \
	char *s##_UTF; \
	if (gb_WideAPI) { \
		s##_UTF = wide2utf(s); \
	}
#define dDeclUTF(s, d) \
	char *s##_UTF; \
	if (gb_WideAPI) { \
	    dmsg("DeclUTF: '%s'", d); \
		s##_UTF = wide2utf(s); \
	}

#define FreeUTF(s) \
	if (gb_WideAPI) free(s##_UTF)

#define UTF(s) \
	( gb_WideAPI ? s##_UTF : s)

#define UTFLen(s) \
	( gb_WideAPI ? utf2widelen(s) : strlen(s))

#define UTFSVLen(sv) \
	( gb_WideAPI ? (I32)utf2widelen(SvPV_nolen(sv)) : (I32) SvLEN(sv))

#define utf8_on(sv) \
	if (gb_WideAPI) SvUTF8_on(sv)


#ifdef _DEBUG

// debugging


#define open_log(s) \
	debugOut = fopen(s, "w+t")

#define dmsg(f, p1) \
	fprintf(debugOut, f "\n", p1)
#define close_log() \
	if(debugOut) fclose(debugOut)

#else

#define open_log(s) 
#define dmsg(f, p1) 
#define close_log() 

#endif

