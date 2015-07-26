// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DosCommand.pas' rev: 29.00 (Windows)

#ifndef DoscommandHPP
#define DoscommandHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.SyncObjs.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>

//-- user supplied -----------------------------------------------------------

namespace Doscommand
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EDosCommand;
class DELPHICLASS ECreatePipeError;
class DELPHICLASS ECreateProcessError;
class DELPHICLASS EProcessTimer;
class DELPHICLASS TProcessTimer;
class DELPHICLASS TInputLines;
class DELPHICLASS TSyncString;
class DELPHICLASS TReadPipe;
class DELPHICLASS TDosThread;
class DELPHICLASS TDosCommand;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION EDosCommand : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDosCommand(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDosCommand(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDosCommand(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDosCommand(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDosCommand(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDosCommand(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDosCommand(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDosCommand(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDosCommand(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDosCommand(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDosCommand(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDosCommand(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDosCommand(void) { }
	
};


class PASCALIMPLEMENTATION ECreatePipeError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall ECreatePipeError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ECreatePipeError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall ECreatePipeError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ECreatePipeError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ECreatePipeError(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall ECreatePipeError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall ECreatePipeError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ECreatePipeError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ECreatePipeError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ECreatePipeError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ECreatePipeError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ECreatePipeError(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ECreatePipeError(void) { }
	
};


class PASCALIMPLEMENTATION ECreateProcessError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall ECreateProcessError(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ECreateProcessError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall ECreateProcessError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ECreateProcessError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ECreateProcessError(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall ECreateProcessError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall ECreateProcessError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ECreateProcessError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ECreateProcessError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ECreateProcessError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ECreateProcessError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ECreateProcessError(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ECreateProcessError(void) { }
	
};


class PASCALIMPLEMENTATION EProcessTimer : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EProcessTimer(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EProcessTimer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EProcessTimer(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EProcessTimer(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EProcessTimer(NativeUInt Ident, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EProcessTimer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EProcessTimer(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EProcessTimer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EProcessTimer(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EProcessTimer(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EProcessTimer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EProcessTimer(NativeUInt Ident, System::TVarRec const *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EProcessTimer(void) { }
	
};


enum DECLSPEC_DENUM TOutputType : unsigned char { otEntireLine, otBeginningOfLine };

enum DECLSPEC_DENUM TEndStatus : unsigned char { esStop, esProcess, esStill_Active, esNone, esError, esTime };

typedef System::UnicodeString __fastcall (__closure *TCharDecoding)(System::TObject* ASender, System::Classes::TStream* ABuf);

typedef void __fastcall (__closure *TCharEncoding)(System::TObject* ASender, const System::UnicodeString AChars, System::Classes::TStream* AOutBuf);

class PASCALIMPLEMENTATION TProcessTimer : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Syncobjs::TCriticalSection* FCriticalSection;
	bool FEnabled;
	System::Syncobjs::TEvent* FEvent;
	int FID;
	int FSinceBeginning;
	int FSinceLastOutput;
	int __fastcall get_SinceBeginning(void);
	int __fastcall get_SinceLastOutput(void);
	void __fastcall set_Enabled(const bool AValue);
	
private:
	static System::Classes::TThreadList* FTimerInstances;
	void __fastcall MyTimer(void);
	
private:
	// __classmethod void __fastcall Create@();
	
public:
	__fastcall TProcessTimer(void);
	
private:
	// __classmethod void __fastcall Destroy@();
	
public:
	__fastcall virtual ~TProcessTimer(void);
	void __fastcall Beginning(void);
	void __fastcall Ending(void);
	void __fastcall NewOutput(void);
	__property bool Enabled = {read=FEnabled, write=set_Enabled, nodefault};
	__property System::Syncobjs::TEvent* Event = {read=FEvent};
	__property int SinceBeginning = {read=get_SinceBeginning, nodefault};
	__property int SinceLastOutput = {read=get_SinceLastOutput, nodefault};
};


typedef void __fastcall (__closure *TNewLineEvent)(System::TObject* ASender, System::UnicodeString ANewLine, TOutputType AOutputType);

typedef void __fastcall (__closure *TNewCharEvent)(System::TObject* ASender, System::WideChar ANewChar);

typedef void __fastcall (__closure *TErrorEvent)(System::TObject* ASender, System::Sysutils::Exception* AE, bool &AHandled);

typedef void __fastcall (__closure *TTerminateProcessEvent)(System::TObject* ASender, bool &ACanTerminate);

class PASCALIMPLEMENTATION TInputLines : public System::Sysutils::TSimpleRWSync
{
	typedef System::Sysutils::TSimpleRWSync inherited;
	
public:
	System::UnicodeString operator[](int AIndex) { return Strings[AIndex]; }
	
private:
	System::Syncobjs::TEvent* FEvent;
	System::Classes::TStrings* FList;
	System::UnicodeString __fastcall get_Strings(int AIndex);
	void __fastcall set_Strings(int AIndex, const System::UnicodeString AValue);
	
public:
	__fastcall TInputLines(void);
	__fastcall virtual ~TInputLines(void);
	int __fastcall Add(const System::UnicodeString AValue);
	int __fastcall Count(void);
	void __fastcall Delete(int AIndex);
	System::Classes::TStrings* __fastcall LockList(void);
	void __fastcall UnlockList(void);
	__property System::Syncobjs::TEvent* Event = {read=FEvent};
	__property System::UnicodeString Strings[int AIndex] = {read=get_Strings, write=set_Strings/*, default*/};
};


class PASCALIMPLEMENTATION TSyncString : public System::Sysutils::TSimpleRWSync
{
	typedef System::Sysutils::TSimpleRWSync inherited;
	
private:
	System::UnicodeString FValue;
	System::UnicodeString __fastcall get_Value(void);
	void __fastcall set_Value(const System::UnicodeString AValue);
	
public:
	void __fastcall Add(const System::UnicodeString AValue);
	void __fastcall Delete(int APos, int ACount);
	int __fastcall Length(void);
	__property System::UnicodeString Value = {read=get_Value, write=set_Value};
public:
	/* TSimpleRWSync.Create */ inline __fastcall TSyncString(void) : System::Sysutils::TSimpleRWSync() { }
	/* TSimpleRWSync.Destroy */ inline __fastcall virtual ~TSyncString(void) { }
	
};


class PASCALIMPLEMENTATION TReadPipe : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	System::Syncobjs::TEvent* FEvent;
	TCharDecoding FOnCharDecoding;
	NativeUInt Fread_stdout;
	NativeUInt Fwrite_stdout;
	TSyncString* FSyncString;
	
protected:
	virtual void __fastcall Execute(void);
	
public:
	__fastcall TReadPipe(NativeUInt AReadStdout, NativeUInt AWriteStdout, TCharDecoding AOnCharDecoding);
	__fastcall virtual ~TReadPipe(void);
	HIDESBASE void __fastcall Terminate(void);
	__property System::Syncobjs::TEvent* Event = {read=FEvent};
	__property TSyncString* ReadString = {read=FSyncString};
};


class PASCALIMPLEMENTATION TDosThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	System::UnicodeString FCommandLine;
	System::UnicodeString FCurrentDir;
	System::Classes::TStringList* FEnvironment;
	TInputLines* FInputLines;
	bool FInputToOutput;
	System::Classes::TStringList* FLines;
	int FMaxTimeAfterBeginning;
	int FMaxTimeAfterLastOutput;
	TCharDecoding FOnCharDecoding;
	TCharEncoding FonCharEncoding;
	TNewCharEvent FOnNewChar;
	TNewLineEvent FOnNewLine;
	TTerminateProcessEvent FOnTerminateProcess;
	System::Classes::TStrings* FOutputLines;
	TDosCommand* FOwner;
	int FPriority;
	_PROCESS_INFORMATION FProcessInformation;
	System::Syncobjs::TEvent* FTerminateEvent;
	TProcessTimer* FTimer;
	System::UnicodeString __fastcall DoCharDecoding(System::TObject* ASender, System::Classes::TStream* ABuf);
	void __fastcall DoEndStatus(TEndStatus AValue);
	void __fastcall DoLinesAdd(const System::UnicodeString AStr);
	void __fastcall DoNewChar(System::WideChar AChar);
	void __fastcall DoNewLine(const System::UnicodeString AStr, TOutputType AOt);
	void __fastcall DoReadLine(TSyncString* ReadString, System::UnicodeString &Str, System::UnicodeString &last, bool &LineBeginned);
	void __fastcall DoSendLine(NativeUInt AWritePipe, System::UnicodeString &ALast, bool &ALineBeginned);
	void __fastcall DoTerminateProcess(void);
	
private:
	unsigned FExitCode;
	
protected:
	bool FcanTerminate;
	TEndStatus FSyncEndStatus;
	TOutputType FSyncOutputType;
	System::UnicodeString FSyncStr;
	virtual void __fastcall DoSyncEndStatus(void);
	virtual void __fastcall DoSyncLinesAdd(void);
	virtual void __fastcall DoSyncNewChar(void);
	virtual void __fastcall DoSyncNewLine(void);
	virtual void __fastcall DoSyncOutPutAdd(void);
	virtual void __fastcall DoSyncOutPutLastLine(void);
	virtual void __fastcall DoSyncProcessInformation(void);
	virtual void __fastcall DoSyncTerminateProcess(void);
	virtual void __fastcall Execute(void);
	
public:
	__fastcall TDosThread(TDosCommand* AOwner, System::UnicodeString ACl, System::UnicodeString ACurrDir, System::Classes::TStringList* AL, System::Classes::TStrings* AOl, TProcessTimer* ATimer, int AMtab, int AMtalo, TNewLineEvent AOnl, TNewCharEvent AOnc, System::Classes::TNotifyEvent Ot, TTerminateProcessEvent AOtp, int Ap, bool Aito, System::Classes::TStrings* AEnv, TCharDecoding AOnCharDecoding, TCharEncoding AOnCharEncoding);
	__fastcall virtual ~TDosThread(void);
	HIDESBASE void __fastcall Terminate(void);
	__property TInputLines* InputLines = {read=FInputLines};
};


class PASCALIMPLEMENTATION TDosCommand : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	System::UnicodeString FCommandLine;
	System::UnicodeString FCurrentDir;
	System::Classes::TStrings* FEnvironment;
	unsigned FExitCode;
	bool FInputToOutput;
	System::Classes::TStringList* FLines;
	int FMaxTimeAfterBeginning;
	int FMaxTimeAfterLastOutput;
	TCharDecoding FOnCharDecoding;
	TCharEncoding FonCharEncoding;
	TErrorEvent FonExecuteError;
	TNewCharEvent FOnNewChar;
	TNewLineEvent FOnNewLine;
	System::Classes::TNotifyEvent FOnTerminated;
	TTerminateProcessEvent FOnTerminateProcess;
	System::Classes::TStrings* FOutputLines;
	int FPriority;
	TDosThread* FThread;
	TProcessTimer* FTimer;
	bool __fastcall get_IsRunning(void);
	void __fastcall set_CharDecoding(const TCharDecoding AValue);
	void __fastcall set_CharEncoding(const TCharEncoding AValue);
	void __fastcall set_OutputLines(System::Classes::TStrings* AValue);
	
private:
	TEndStatus FEndStatus;
	_PROCESS_INFORMATION FProcessInformation;
	
protected:
	virtual System::UnicodeString __fastcall DoCharDecoding(System::TObject* ASender, System::Classes::TStream* ABuf);
	virtual void __fastcall DoCharEncoding(System::TObject* ASender, const System::UnicodeString AChars, System::Classes::TStream* AOutBuf);
	void __fastcall ThreadTerminated(System::TObject* ASender);
	
public:
	__fastcall virtual TDosCommand(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TDosCommand(void);
	void __fastcall Execute(void);
	void __fastcall SendLine(System::UnicodeString AValue, bool AEol);
	void __fastcall Stop(void);
	__property TEndStatus EndStatus = {read=FEndStatus, nodefault};
	__property unsigned ExitCode = {read=FExitCode, nodefault};
	__property bool IsRunning = {read=get_IsRunning, nodefault};
	__property System::Classes::TStringList* Lines = {read=FLines};
	__property System::Classes::TStrings* OutputLines = {read=FOutputLines, write=set_OutputLines};
	__property int Priority = {read=FPriority, write=FPriority, nodefault};
	__property _PROCESS_INFORMATION ProcessInformation = {read=FProcessInformation};
	
__published:
	__property System::UnicodeString CommandLine = {read=FCommandLine, write=FCommandLine};
	__property System::UnicodeString CurrentDir = {read=FCurrentDir, write=FCurrentDir};
	__property System::Classes::TStrings* Environment = {read=FEnvironment};
	__property bool InputToOutput = {read=FInputToOutput, write=FInputToOutput, nodefault};
	__property int MaxTimeAfterBeginning = {read=FMaxTimeAfterBeginning, write=FMaxTimeAfterBeginning, nodefault};
	__property int MaxTimeAfterLastOutput = {read=FMaxTimeAfterLastOutput, write=FMaxTimeAfterLastOutput, nodefault};
	__property TCharDecoding OnCharDecoding = {read=FOnCharDecoding, write=set_CharDecoding};
	__property TCharEncoding OnCharEncoding = {read=FonCharEncoding, write=set_CharEncoding};
	__property TErrorEvent OnExecuteError = {read=FonExecuteError, write=FonExecuteError};
	__property TNewCharEvent OnNewChar = {read=FOnNewChar, write=FOnNewChar};
	__property TNewLineEvent OnNewLine = {read=FOnNewLine, write=FOnNewLine};
	__property System::Classes::TNotifyEvent OnTerminated = {read=FOnTerminated, write=FOnTerminated};
	__property TTerminateProcessEvent OnTerminateProcess = {read=FOnTerminateProcess, write=FOnTerminateProcess};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Doscommand */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DOSCOMMAND)
using namespace Doscommand;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DoscommandHPP
