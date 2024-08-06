{
  this component let you execute a dos program (exe, com or batch file) and catch
  the ouput in order to put it in a memo or in a listbox, ...
  you can also send inputs.
  the cool thing of this component is that you do not need to wait the end of
  the program to get back the output. it comes line by line.


  *********************************************************************
  ** maxime_collomb@yahoo.fr                                         **
  **                                                                 **
  **   for this component, iCount just translated C code             **
  ** from Community.borland.com                                      **
  ** (http://www.vmlinux.org/jakov/community.borland.com/10387.html) **
  **                                                                 **
  **   if you have a good idea of improvement, please                **
  ** let me know (maxime_collomb@yahoo.fr).                          **
  **   if you improve this component, please send me a Copy          **
  ** so iCount can put it on www.torry.net.                          **
  *********************************************************************

  History :
  ---------

  06-21-2011 : version 2.03 (by sirius in www.delphi-treff.de || www.delphipraxis.net)
  (marked sirius2)
  - added property "current directory" to set for child process
  - added possibility to add environment variables (see properties)
  - deleted possible memory leaks
  - removed class TTimer (not threadsafe) from TProcesstimer (added global var TimerInstances and stuff ->threadsafe)
  - try to prepare for unicode  !!! not tested
  - added event OnCharDecoding (for unicode console output); no need for ANSI Text in console
  - added event OnCharEncoding (for unicode console input); no need for ANSI Text in console
  - removed bug causing EInvalidpointer with unhandled FatalException in TDosThread (dont free FatalException object)
  - added MB_TASKMODAL to Error Messagebox of Thread
  - create pipehandles like in Article ID: 190351 of Microsoft knowledge base

  05-11-2009 : version 2.02 (by sirius in www.delphi-treff.de || www.delphipraxis.net)
  - added synchronisation (see later)
  - deleted FOwner in TDosCommand (not needed)
  - added TInputlines (sync of InputLines)
  - added critical section and locked functions to Processtimer
  - added TDosCommand.ThreadTerminate
  - moved FTimer.Ending to Thread.onTerminate
  - reraised Excpetion from Thread in onTerminate
  - added try-finally to whole Thread.Execute method
  - added Synchronize to FLines and FOutPutLines
  - added Synchronize to NewLine event
  - added event for every New char
  - added TReadPipe(Thread) for waiting to Pipe (blocking ReadFile)
  - added TSyncstring to Synchronize string transfer (from TReadPipe)
  - restructured FExecute -> Execute (New methods)
  - added WaitForMultipleObjects and stuff for less Processing-Time

  13-06-2003 : version 2.01
  - Added exception when executing with empty CommandLine
  - Added IsRunning property to check if a command is currently
  running
  18-05-2001 : version 2.0
  - Now, catching the beginning of a line is allowed (usefull if the
  prog ask for an entry) => the method OnNewLine is modified
  - Now can send inputs
  - Add a couple of FreeMem for sa & sd [thanks Gary H. Blaikie]
  07-05-2001 : version 1.2
  - Sleep(1) is added to give others processes a chance
  [thanks Hans-Georg Rickers]
  - the loop that catch the outputs has been re-writen by
  Hans-Georg Rickers => no more broken lines
  30-04-2001 : version 1.1
  - function IsWinNT() is changed to
  (Win32Platform = VER_PLATFORM_WIN32_NT) [thanks Marc Scheuner]
  - empty lines appear in the redirected output
  - property OutputLines is added to redirect output directly to a
  memo, richedit, listbox, ... [thanks Jean-Fabien Connault]
  - a timer is added to offer the possibility of ending the process
  after XXX sec. after the beginning or YYY sec after the last
  output [thanks Jean-Fabien Connault]
  - managing process priorities flags in the CreateProcess
  thing [thanks Jean-Fabien Connault]
  20-04-2001 : version 1.0 on www.torry.net
  *******************************************************************
  How to use it :
  ---------------
  - just put the line of command in the property 'CommandLine'
  - execute the process with the method 'Execute'
  - if you want to stop the process before it has ended, use the method 'Stop'
  - if you want the process to stop by itself after XXX sec of activity,
  use the property 'MaxTimeAfterBeginning'
  - if you want the process to stop after XXX sec without an output,
  use the property 'MaxTimeAfterLastOutput'
  - to directly redirect outputs to a memo or a richedit, ...
  use the property 'OutputLines'
  (DosCommand1.OutputLines := Memo1.Lines;)
  - you can access all the outputs of the last command with the property 'Lines'
  - you can change the priority of the process with the property 'Priority'
  value of Priority must be in [HIGH_PRIORITY_CLASS, IDLE_PRIORITY_CLASS,
  NORMAL_PRIORITY_CLASS, REALTIME_PRIORITY_CLASS]
  - you can have an event for each New line and for the end of the process
  with the events 'procedure OnNewLine(Sender: TObject; NewLine: string;
  OutputType: TOutputType);' and 'procedure OnTerminated(Sender: TObject);'
  - you can send inputs to the dos process with 'SendLine(Value: string;
  Eol: Boolean);'. Eol is here to determine if the program have to add a
  CR/LF at the end of the string.
  *******************************************************************
  How to call a dos function (win 9x/Me) :
  ----------------------------------------

  Example : Make a dir :
  ----------------------
  - if you want to get the Result of a 'c:\dir /o:gen /l c:\windows\*.txt'
  for example, you need to make a batch file
  --the batch file : c:\mydir.bat
  @echo off
  dir /o:gen /l %1
  rem eof
  --in your code
  DosCommand.CommandLine := 'c:\mydir.bat c:\windows\*.txt';
  DosCommand.Execute;

  Example : Format a disk (win 9x/Me) :
  -------------------------
  --a batch file : c:\myformat.bat
  @echo off
  format %1
  rem eof
  --in your code
  var diskname: string;
  --
  DosCommand1.CommandLine := 'c:\myformat.bat a:';
  DosCommand1.Execute; //launch format process
  DosCommand1.SendLine('', True); //equivalent to press enter key
  DiskName := 'test';
  DosCommand1.SendLine(DiskName, True); //enter the name of the volume
  ******************************************************************* }
unit DosCommand;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, Winapi.Windows, Winapi.Messages;

type
  EDosCommand = class(Exception); // MK: 20030613

  ECreatePipeError = class(Exception); // exception raised when a pipe cannot be created
  ECreateProcessError = class(Exception); // exception raised when the process cannot be created
  EProcessTimer = class(Exception); // exception raised by TProcessTimer

  TOutputType = (otEntireLine, otBeginningOfLine); // to know if the newline is finished.
  TEndStatus = (esStop, // stopped via TDoscommand.Stop
    esProcess, // ended via Child-Process
    esStill_Active, // still active
    esNone, // not executed yet
    esError, // ended via Exception
    esTime); // ended because of time

  // sirius2: added events for console unicode support
  // only needed if console in child process has unicode characters (UTF-8, UTF-16,...)
  // if these events are not implemented, TDosCommand treat console input and output as ANSI
  // these events are NOT running in mainthread!!!!
  TCharDecoding = function(ASender: TObject; ABuf: TStream): string of object; // convert input buf from console to string Result
  TCharEncoding = procedure(ASender: TObject; const AChars: string; AOutBuf: TStream) of object; //convert input chars to outbuf-Stream

type
  // sirius2: replaced inherited TTimer (not threadsafe) with direct call to WinAPI
  TProcessTimer = class(TObject) // timer for stopping the process after XXX sec
  strict private
    FCriticalSection: TCriticalSection;
    FEnabled: Boolean; // sirius2
    FEvent: TEvent;
    FID: Integer; // sirius2
    FSinceBeginning: Integer;
    FSinceLastOutput: Integer;
    function get_SinceBeginning: Integer;
    function get_SinceLastOutput: Integer;
    procedure set_Enabled(const AValue: Boolean);
  private class var
    FTimerInstances: TThreadList;
  private
    procedure MyTimer;
  public
    class constructor Create;
    constructor Create; reintroduce;
    class destructor Destroy;
    destructor Destroy; override;
    procedure Beginning; // call this at the beginning of a process
    procedure Ending; // call this when the process is terminated
    procedure NewOutput; // call this when a New output is received
    property Enabled: Boolean read FEnabled write set_Enabled;
    property Event: TEvent read FEvent;
    property SinceBeginning: Integer read get_SinceBeginning;
    property SinceLastOutput: Integer read get_SinceLastOutput;
  end;

  TNewLineEvent = procedure(ASender: TObject; const ANewLine: string; AOutputType: TOutputType) of object;
  // if New line is read via pipe
  TNewCharEvent = procedure(ASender: TObject; ANewChar: Char) of object;
  // every New char from pipe
  TErrorEvent = procedure(ASender: TObject; AE: Exception; var AHandled: Boolean) of object;
  // if Exception occurs in TDosThread -> if not handled, Messagebox will be shown
  TTerminateProcessEvent = procedure(ASender: TObject; var ACanTerminate: Boolean) of object;
  // called when Dos-Process has to be terminated (via TerminateProcess); just asking if thread can terminate process

  // added by sirius (synchronizes inputlines between Mainthread and TDosThread)
  TInputLines = class(TSimpleRWSync)
  strict private
    FEvent: TEvent;
    FList: TStrings;
    function get_Strings(AIndex: Integer): string;
    procedure set_Strings(AIndex: Integer; const AValue: string);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Add(const AValue: string): Integer;
    function Count: Integer;
    procedure Delete(AIndex: Integer);
    function LockList: TStrings;
    procedure UnlockList;
    property Event: TEvent read FEvent;
    property Strings[AIndex: Integer]: string read get_Strings write set_Strings; default;
  end;

  //by sirius; syncronized string (TReadPipe<->TDosThread)
  TSyncString = class(TSimpleRWSync)
  strict private
    FValue: string;
    function get_Value: string;
    procedure set_Value(const AValue: string);
  public
    procedure Add(const AValue: string);
    procedure Delete(APos, ACount: Integer);
    function Length: Integer;
    property Value: string read get_Value write set_Value;
  end;

  TReadPipe = class(TThread) // by sirius (wait for pipe input without sleep(1))
    // writes pipe input into TSyncString --> set event  --> TDosThread can read input
  strict private
    FEvent: TEvent;
    FOnCharDecoding: TCharDecoding;
    Fread_stdout, Fwrite_stdout: THandle;
    FSyncString: TSyncString;
  strict protected
    procedure Execute; override;
  public
    constructor Create(AReadStdout, AWriteStdout: THandle; AOnCharDecoding: TCharDecoding); reintroduce;
    destructor Destroy; override;
    procedure Terminate; reintroduce;
    property Event: TEvent read FEvent;
    property ReadString: TSyncString read FSyncString;
  end;

  TDosCommand = class;

  // sirius2: added EnvironmentStrings and (En/De)coding-events
  // the thread that is waiting for outputs through the pipe
  TDosThread = class(TThread)
  strict private
    FCommandLine: string;
    FCurrentDir: string;
    FEnvironment: TStringList;
    FInputLines: TInputLines;
    FInputToOutput: Boolean;
    FLines: TStringList;
    FMaxTimeAfterBeginning: Integer;
    FMaxTimeAfterLastOutput: Integer;
    FOnCharDecoding: TCharDecoding;
    FOnCharEncoding: TCharEncoding;
    FOnNewChar: TNewCharEvent;
    FOnNewLine: TNewLineEvent;
    FOnTerminateProcess: TTerminateProcessEvent;
    FOutputLines: TStrings;
    FOwner: TDosCommand;
    FPriority: Integer;
    FProcessInformation: TProcessInformation;
    FTerminateEvent: TEvent;
    FTimer: TProcessTimer;
    function DoCharDecoding(ASender: TObject; ABuf: TStream): string;
    procedure DoEndStatus(AValue: TEndStatus);
    procedure DoLinesAdd(const AStr: string);
    procedure DoNewChar(AChar: Char);
    procedure DoNewLine(const AStr: string; AOutputType: TOutputType);
    procedure DoReadLine(AReadString: TSyncString; var AStr, ALast: string; var ALineBeginned: Boolean);
    procedure DoSendLine(AWritePipe: THandle; var ALast: string; var ALineBeginned: Boolean);
    procedure DoTerminateProcess;
  private
    FExitCode: Cardinal;
  strict protected // DoSync-Methods are in Main-Thread-Context (called via Synchronize)
    FCanTerminate: Boolean;
    procedure Execute; override;
  public
    constructor Create(AOwner: TDosCommand; ACl, ACurrDir: string; ALines: TStringList; AOl: TStrings; ATimer: TProcessTimer; AMtab, AMtalo: Integer; AOnl: TNewLineEvent; AOnc: TNewCharEvent; Ot: TNotifyEvent; AOtp: TTerminateProcessEvent; Ap: Integer; Aito: Boolean; AEnv: TStrings; AOnCharDecoding: TCharDecoding; AOnCharEncoding: TCharEncoding); reintroduce;
    destructor Destroy; override;
    procedure Terminate; reintroduce;
    property InputLines: TInputLines read FInputLines;
  end;

  TDosCommand = class(TComponent) // the component to put on a form
  strict private
    FCommandLine: string;
    FCurrentDir: string;
    FEnvironment: TStrings; // sirius2
    FExitCode: Cardinal;
    FInputToOutput: Boolean;
    FLines: TStringList;
    FMaxTimeAfterBeginning: Integer;
    FMaxTimeAfterLastOutput: Integer;
    FOnCharDecoding: TCharDecoding; // sirius2
    FOnCharEncoding: TCharEncoding; // sirius2
    FonExecuteError: TErrorEvent;
    FOnNewChar: TNewCharEvent;
    FOnNewLine: TNewLineEvent;
    FOnTerminated: TNotifyEvent;
    FOnTerminateProcess: TTerminateProcessEvent;
    FOutputLines: TStrings;
    FPriority: Integer;
    FThread: TDosThread;
    FTimer: TProcessTimer;
    function get_EndStatus: TEndStatus;
    function get_IsRunning: Boolean;
    procedure set_CharDecoding(const AValue: TCharDecoding);
    procedure set_CharEncoding(const AValue: TCharEncoding);
  private
    FEndStatus: Integer;
    FProcessInformation: TProcessInformation;
  strict protected
    function DoCharDecoding(ASender: TObject; ABuf: TStream): string; virtual;
    procedure DoCharEncoding(ASender: TObject; const AChars: string; AOutBuf: TStream); virtual;
    procedure ThreadTerminated(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute; // the user call this to execute the command
    procedure SendLine(const AValue: string; AEol: Boolean); // add a line in the input pipe
    procedure Stop; // the user can stop the process with this method, stops process and waits
    property EndStatus: TEndStatus read get_EndStatus;
    property ExitCode: Cardinal read FExitCode;
    property IsRunning: Boolean read get_IsRunning; // When true, a command is still running // MK: 20030613
    property Lines: TStringList read FLines; // if the user want to access all the outputs of a process, he can use this property, lines is deleted before execution
    property OutputLines: TStrings read FOutputLines write FOutputLines; // can be lines of a memo, a richedit, a listbox, ...
    property Priority: Integer read FPriority write FPriority; // stops process and waits, only for createprocess
    property ProcessInformation: TProcessInformation read FProcessInformation; // Processinformation from createprocess
  published
    property CommandLine: string read FCommandLine write FCommandLine; // command to execute
    property CurrentDir: string read FCurrentDir write FCurrentDir; // currentdir for childprocess (if empty -> currentdir is same like currentdir in parent process), by sirius
    property Environment: TStrings read FEnvironment; // add Environment variables for process (if empty -> environment of parent process is used)
    property InputToOutput: Boolean read FInputToOutput write FInputToOutput; // check it if you want that the inputs appear also in the outputs
    property MaxTimeAfterBeginning: Integer read FMaxTimeAfterBeginning write FMaxTimeAfterBeginning;
    property MaxTimeAfterLastOutput: Integer read FMaxTimeAfterLastOutput write FMaxTimeAfterLastOutput;
    property OnCharDecoding: TCharDecoding read FOnCharDecoding write set_CharDecoding;
    property OnCharEncoding: TCharEncoding read FOnCharEncoding write set_CharEncoding; // Events to convert buf to (Unicode-)string and reverse !!not needed if console of child uses AnsiString!! This event is not threadsafe !!!! dont change during execution
    property OnExecuteError: TErrorEvent read FonExecuteError write FonExecuteError; // event if DosCommand.execute is aborted via Exception
    property OnNewChar: TNewCharEvent read FOnNewChar write FOnNewChar; // event for each New char that is received through the pipe
    property OnNewLine: TNewLineEvent read FOnNewLine write FOnNewLine; // event for each New line that is received through the pipe
    property OnTerminated: TNotifyEvent read FOnTerminated write FOnTerminated; // event for the end of the process (normally, time out or by user (DosCommand.Stop;))
    property OnTerminateProcess: TTerminateProcessEvent read FOnTerminateProcess write FOnTerminateProcess; // event to ask for processtermination
  end;

implementation

uses
  System.Types;

resourcestring
  SStillRunning = 'DosCommand still running';
  SNotRunning = 'DosCommand not running';
  SNoCommandLine = 'No Commandline to execute';
  SProcessError = 'Error creating Process: %s - (%s)';
  SPipeError = 'Error creating Pipe: %s';
  SInstanceError = 'timer instance list not empty';
  STimerSetError = 'could not start timer';
  STimerKillError = 'could not kill timer';

type
  PTimer = ^TTimer;

  TTimer = record
    ID: Integer;
    Inst: TProcessTimer;
  end;

procedure TimerProc(AHwnd: HWND; AMsg: Integer; AEventID: Integer; ATime: Integer); stdcall;
var
  iCount: Integer;
  lTimer: PTimer;
  pInst: TProcessTimer;
  pList: TList;
begin
  // look for timerID in Timerinstances and find coresponding Instance of TProcesstimer
  pInst := nil;
  pList := TProcessTimer.FTimerInstances.LockList;
  try
    for iCount := 0 to pList.Count - 1 do
    begin
      lTimer := PTimer(pList[iCount]);
      if lTimer^.ID = AEventID then
      begin
        pInst := lTimer^.Inst;
        Break;
      end;
    end;
  finally
    TProcessTimer.FTimerInstances.UnlockList;
  end;
  if Assigned(pInst) then
    pInst.MyTimer;
end;

{ TProcessTimer }

class constructor TProcessTimer.Create;
begin
  FTimerInstances := TThreadList.Create;
end;

constructor TProcessTimer.Create;
begin
  inherited Create;
  FCriticalSection := TCriticalSection.Create;
  FEnabled := False; // timer is off
  FEvent := TEvent.Create(nil, False, False, '');
end;

class destructor TProcessTimer.Destroy;
var
  pList: TList;
begin
  pList := FTimerInstances.LockList;
  try
    Assert(pList.Count = 0); // hopefully
  finally
    FTimerInstances.UnlockList;
  end;
  FTimerInstances.Free;
end;

destructor TProcessTimer.Destroy;
begin
  Enabled := False;
  FEvent.Free;
  FCriticalSection.Free;
  inherited Destroy;
end;

procedure TProcessTimer.Beginning;
begin
  FSinceBeginning := 0; // this is the beginning
  FSinceLastOutput := 0;
  Enabled := True; // set the timer on
end;

procedure TProcessTimer.Ending;
begin
  Enabled := False; // set the timer off
end;

function TProcessTimer.get_SinceBeginning: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := FSinceBeginning;
  finally
    FCriticalSection.Leave;
  end;
end;

function TProcessTimer.get_SinceLastOutput: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := FSinceLastOutput;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TProcessTimer.MyTimer;
begin
  interlockedincrement(FSinceBeginning);
  interlockedincrement(FSinceLastOutput);
  FEvent.SetEvent;
end;

procedure TProcessTimer.NewOutput;
begin
  FCriticalSection.Enter;
  try
    FSinceLastOutput := 0; // a New output has been caught
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TProcessTimer.set_Enabled(const AValue: Boolean);
var
  timer: PTimer;
  iCount: Integer;
  pList: TList;
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;
    if FEnabled then
    begin
      // starttimer and save timer-id in TimerInstances
      FID := SetTimer(0, 0, 1000, @TimerProc);
      if FID = 0 then
      begin
        FEnabled := False;
        raise EProcessTimer.CreateRes(@STimerSetError);
      end
      else
      begin
        New(timer);
        timer^.ID := FID;
        timer^.Inst := Self;
        TProcessTimer.FTimerInstances.Add(timer);
      end;
    end
    else
      // stoptimer and delete timer-id in timerinstances
      if not KillTimer(0, FID) then
        raise EProcessTimer.CreateRes(@STimerKillError)
      else
      begin
        pList := TProcessTimer.FTimerInstances.LockList;
        try
          for iCount := 0 to pList.Count - 1 do
          begin
            timer := PTimer(pList[iCount]);
            if timer^.ID = FID then
            begin
              pList.Remove(timer);
              Dispose(timer);
              Break;
            end;
          end;
        finally
          TProcessTimer.FTimerInstances.UnlockList;
        end;
      end;
  end;
end;

{ TDosThread }

constructor TDosThread.Create(AOwner: TDosCommand; ACl, ACurrDir: string; ALines: TStringList; AOl: TStrings; ATimer: TProcessTimer; AMtab, AMtalo: Integer; AOnl: TNewLineEvent; AOnc: TNewCharEvent; Ot: TNotifyEvent; AOtp: TTerminateProcessEvent; Ap: Integer; Aito: Boolean; AEnv: TStrings; AOnCharDecoding: TCharDecoding; AOnCharEncoding: TCharEncoding);
begin
  inherited Create(False);
  FOnCharEncoding := AOnCharEncoding;
  FOnCharDecoding := AOnCharDecoding;
  FEnvironment := TStringList.Create;
  FEnvironment.AddStrings(AEnv);
  FreeOnTerminate := True;
  FOwner := AOwner;
  FOwner.FEndStatus := Ord(esStill_Active);
  FCommandLine := ACl;
  FCurrentDir := ACurrDir;
  FLines := ALines;
  FOutputLines := AOl;
  FInputLines := TInputLines.Create;
  FInputToOutput := Aito;
  FOnNewLine := AOnl;
  FOnNewChar := AOnc;
  FOnTerminateProcess := AOtp;
  Self.OnTerminate := Ot;
  FTimer := ATimer;
  FMaxTimeAfterBeginning := AMtab;
  FMaxTimeAfterLastOutput := AMtalo;
  FPriority := Ap;
  FTerminateEvent := TEvent.Create(nil, True, False, '');
end;

destructor TDosThread.Destroy;
begin
  FInputLines.Free;
  FTerminateEvent.Free;
  FEnvironment.Free;
  inherited Destroy;
end;

function TDosThread.DoCharDecoding(ASender: TObject; ABuf: TStream): string;
begin
  Result := FOnCharDecoding(Self, ABuf);
end;

procedure TDosThread.DoEndStatus(AValue: TEndStatus);
begin
  TInterlocked.Exchange(FOwner.FEndStatus, Ord(AValue));
end;

procedure TDosThread.DoLinesAdd(const AStr: string);
begin
  Queue(procedure
  begin
    FLines.Add(AStr);
	if Assigned(FOutputLines) then
      FOutputLines.Add(AStr);
  end);
end;

procedure TDosThread.DoNewChar(AChar: Char);
begin
  if Assigned(FOnNewChar) then
  begin
    Queue(procedure
    begin
      FOnNewChar(FOwner, AChar);
    end);
  end;
end;

procedure TDosThread.DoNewLine(const AStr: string; AOutputType: TOutputType);
begin
  if Assigned(FOnNewLine) then
  begin
    Queue(procedure
    begin
      FOnNewLine(FOwner, AStr, AOutputType);
    end);
  end;
end;

procedure TDosThread.DoReadLine(AReadString: TSyncString; var AStr, ALast: string; var ALineBeginned: Boolean);
var
  sReads: string;
  iCount, iLength: Integer;
begin
  // check to see if there is any data to read from stdout
  sReads := AReadString.Value;
  iLength := Length(sReads);
  AReadString.Delete(1, iLength);

  if iLength > 0 then
  begin
    AStr := ALast; // take the begin of the line (if exists)
    for iCount := 1 to iLength do
    begin
      if Terminated then
        Exit;

      DoNewChar(sReads[iCount]);

      case sReads[iCount] of
        Char(0):
          begin // nothing
          end;
        Char(10), Char(13):
          begin
            if (iCount > 1) and (sReads[iCount] = Char(10)) and (sReads[iCount - 1] = Char(13))
            then
              Continue;
            FTimer.NewOutput; // a New ouput has been caught
            DoLinesAdd(AStr); // add the line
            DoNewLine(AStr, otEntireLine);
            AStr := '';
          end;
      else
        begin
          AStr := AStr + sReads[iCount]; // add a character
        end;
      end;
    end;
    ALast := AStr; // no CRLF found in the rest, maybe in the next output
    if (ALast <> '') then
    begin
      DoNewLine(AStr, otBeginningOfLine);
      ALineBeginned := True;
    end;
  end
end;

procedure TDosThread.DoSendLine(AWritePipe: THandle; var ALast: string; var ALineBeginned: Boolean);
var
  sSends: string;
  bWrite: Cardinal;
  pBuf: TMemoryStream;
  sBuffer: string;
begin
  sSends := FInputLines[0];
  if (Copy(sSends, 1, 1) = '_') then
    sSends := sSends + Char(13) + Char(10);
  Delete(sSends, 1, 1);

  if Length(sSends) > 0 then
  begin
    pBuf := TMemoryStream.Create;
    try
      FOnCharEncoding(Self, sSends, pBuf);
      Assert(WriteFile(AWritePipe, pBuf.memory^, pBuf.Size, bWrite, nil));
      // send it to stdin
    finally
      pBuf.Free;
    end;
    if FInputToOutput then // if we have to output the inputs
    begin
      if Assigned(FOutputLines) then
      begin
        if ALineBeginned then
        begin // if we are continuing a line
          ALast := ALast + sSends;
          sBuffer := ALast;
          Queue(procedure
          begin
            FOutputLines[FOutputLines.Count - 1] := sBuffer;
          end);
          ALineBeginned := False;
        end
        else // if it's a New line
        begin
          Queue(procedure
          begin
            FOutputLines.Add(sSends);
          end);
        end;
      end;
      DoNewLine(ALast, otEntireLine);
      ALast := '';
    end;

    FInputLines.Delete(0); // delete the line that has been send

  end;
end;

procedure TDosThread.DoTerminateProcess;
begin
  FCanTerminate := True;
  if Assigned(FOnTerminateProcess) then
    Queue(procedure
    begin
      FOnTerminateProcess(FOwner, FCanTerminate);
    end);
  if FCanTerminate then
  begin
    TerminateProcess(FProcessInformation.hProcess, 0);
    CloseHandle(FProcessInformation.hProcess);
    CloseHandle(FProcessInformation.hThread);
  end;
end;

procedure TDosThread.Execute;
const
  MaxBufSize = 1024;
var
  si: TSTARTUPINFO;
  sa: PSECURITYATTRIBUTES; // security information for pipes
  sd: PSECURITY_DESCRIPTOR;
  outputread, outputreadtmp, outputwrite, myoutputwrite, errorwrite, inputRead,
    inputWrite, inputWritetmp: THandle; // pipe handles
  Str, last: string;
  LineBeginned: Boolean;
  currDir: PChar;
  envText: string;
  ReadPipeThread: TReadPipe;
  lpEnvironment: Pointer;
  WaitHandles: array [0 .. 4] of THandle;
  iCount: Integer;
  pc, pc2: PChar;
begin // Execute
  NameThreadForDebugging('TDosThread');
  try
    sa := nil;
    sd := nil;
    inputWritetmp := 0;
    try
      GetMem(sa, sizeof(SECURITY_ATTRIBUTES));
      if (Win32Platform = VER_PLATFORM_WIN32_NT) then
      begin // initialize security descriptor (Windows NT)
        GetMem(sd, sizeof(SECURITY_DESCRIPTOR));
        InitializeSecurityDescriptor(sd, SECURITY_DESCRIPTOR_REVISION);
        SetSecurityDescriptorDacl(sd, True, nil, False);
        sa.lpSecurityDescriptor := sd;
      end
      else
      begin
        sa.lpSecurityDescriptor := nil;
        sd := nil;
      end;
      sa.nLength := sizeof(SECURITY_ATTRIBUTES);
      sa.bInheritHandle := True; // allow inheritable handles

      // sirius2: Pipe creation changed to microsoft knowledge base article ID: 190351
      if not(CreatePipe(outputreadtmp, outputwrite, sa, 0)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      if not(DuplicateHandle(GetCurrentProcess, outputwrite, GetCurrentProcess,
        @errorwrite, 0, True, DUPLICATE_SAME_ACCESS)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);
      if not(DuplicateHandle(GetCurrentProcess, outputwrite, GetCurrentProcess,
        @myoutputwrite, 0, False, DUPLICATE_SAME_ACCESS)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      if not(CreatePipe(inputRead, inputWritetmp, sa, 0)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      if not(DuplicateHandle(GetCurrentProcess, outputreadtmp,
        GetCurrentProcess, @outputread, 0, False, DUPLICATE_SAME_ACCESS)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      if not(DuplicateHandle(GetCurrentProcess, inputWritetmp,
        GetCurrentProcess, @inputWrite, 0, False, DUPLICATE_SAME_ACCESS)) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      if not CloseHandle(outputreadtmp) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);
      if not CloseHandle(inputWritetmp) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      GetStartupInfo(si); // set startupinfo for the spawned process
      { The dwFlags member tells CreateProcess how to make the process.
        STARTF_USESTDHANDLES validates the hStd* members. STARTF_USESHOWWINDOW
        validates the wShowWindow member. }
      si.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      si.wShowWindow := SW_HIDE;
      si.hStdOutput := outputwrite;
      si.hStdError := errorwrite; // set the New handles for the child process
      si.hStdInput := inputRead;

      if FCurrentDir = '' then
        currDir := nil
      else
        currDir := PChar(FCurrentDir);

      // set Environment variables and add parent env
      if FEnvironment.Count = 0 then
        lpEnvironment := nil
      else
      begin
        lpEnvironment := GetEnvironmentStrings;
        pc := lpEnvironment;
        try
          // environmentstrings are devided bei #0
          envText := '';
          pc2 := pc;
          Inc(pc2);
          while (pc^ <> Char(0)) or (pc2^ <> Char(0)) do
          // two null-characters (#0) is end of strings
          begin
            envText := envText + pc^;
            Inc(pc);
            Inc(pc2);
          end;
        finally
          freeEnvironmentStrings(lpEnvironment);
        end;
        if Length(envText) > 0 then
          envText := envText + Char(0);

        for iCount := 0 to FEnvironment.Count - 1 do
          envText := envText + FEnvironment[iCount] + Char(0);
        envText := envText + Char(0);
        lpEnvironment := @envText[1];
      end;




      // spawn the child process

      if not(CreateProcess(nil, PChar(FCommandLine), nil, nil, True,
        CREATE_NEW_CONSOLE or FPriority
{$IFDEF UNICODE}
        or CREATE_UNICODE_ENVIRONMENT
{$ENDIF}
        , lpEnvironment, currDir, si, FProcessInformation)) then
      begin
        raise ECreateProcessError.CreateResFmt(@SProcessError,
          [FCommandLine, SysErrorMessage(getlasterror)]);
      end;

      Queue(procedure
      begin
        FOwner.FProcessInformation := FProcessInformation;
      end);
      // take Processinformation to mainthread

      // sirius2: close unneeded handles
      if not CloseHandle(outputwrite) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);
      if not CloseHandle(inputRead) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);
      if not CloseHandle(errorwrite) then
        raise ECreatePipeError.CreateResFmt(@SPipeError,
          [SysErrorMessage(getlasterror)]);

      ReadPipeThread := TReadPipe.Create(outputread, myoutputwrite,
        DoCharDecoding);

      last := ''; // Buffer to save last output without finished with CRLF
      LineBeginned := False;

      GetExitCodeProcess(FProcessInformation.hProcess, FExitCode);
      // init ExitCode

      try
        repeat // main program loop

          // thread is waiting to one of
          WaitHandles[0] := ReadPipeThread.Event.Handle;
          // New output from childprocess
          WaitHandles[1] := FInputLines.Event.Handle;
          // user has New line (TDosCommand.Sendline) to deliver
          WaitHandles[2] := FProcessInformation.hProcess;
          // Process-Ending (child)
          WaitHandles[3] := FTerminateEvent.Handle;
          // Termination of this thread (from mainthread)
          WaitHandles[4] := FTimer.Event.Handle; // timer elapsed (each second)

          case WaitforMultipleObjects(Length(WaitHandles), @WaitHandles, False,
            infinite) of

            Wait_Object_0 + 2:
              begin // Process terminated
                GetExitCodeProcess(FProcessInformation.hProcess, FExitCode);
              end;

            Wait_Object_0 + 1:
              begin // InputEvent
                if ((FInputLines.Count > 0) and not(Terminated)) then
                  DoSendLine(inputWrite, last, LineBeginned);
                if FInputLines.Count > 0 then
                  FInputLines.Event.SetEvent;
              end;

            Wait_Object_0 + 0:
              begin // ReadEvent
                while ReadPipeThread.ReadString.Length > 0 do
                  DoReadLine(ReadPipeThread.ReadString, Str, last, LineBeginned);
              end;

          end;

        until Terminated or ((FExitCode <> STILL_ACTIVE)
          // process terminated (normally)
          or ((FMaxTimeAfterBeginning < FTimer.SinceBeginning) and
          (FMaxTimeAfterBeginning > 0)) // or time out
          or ((FMaxTimeAfterLastOutput < FTimer.SinceLastOutput) and
          (FMaxTimeAfterLastOutput > 0))); // or time out

        if (FExitCode <> STILL_ACTIVE) then
        begin
          DoEndStatus(esProcess);
          FCanTerminate := False;
        end
        else
        begin
          FCanTerminate := True;
          if Terminated then
            DoEndStatus(esStop)
          else
            DoEndStatus(esTime);
          DoTerminateProcess; // stop Process
        end;

        if (last <> '') then
        begin // If not empty flush last output
          DoLinesAdd(last);
          DoNewLine(last, otEntireLine);
        end;
      finally
        if FCanTerminate then
          Waitforsingleobject(FProcessInformation.hProcess, 1000);
        GetExitCodeProcess(FProcessInformation.hProcess, FExitCode);
        ReadPipeThread.Terminate;
        ReadPipeThread.WaitFor;
        ReadPipeThread.Free;
      end;
    finally
      FreeMem(sd);
      FreeMem(sa);

      CloseHandle(outputread);
      CloseHandle(inputWrite);
      CloseHandle(myoutputwrite);
    end;
  except
    on E: Exception do
    begin
      OutputDebugString(PChar('EXCEPTION: TDosThread ' + E.Message));
      DoEndStatus(esError);
      raise;
    end;
  end;
end;

procedure TDosThread.Terminate;
begin
  inherited Terminate;
  FTerminateEvent.SetEvent;
end;

{ TDosCommand }

constructor TDosCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandLine := '';
  FCurrentDir := '';
  FLines := TStringList.Create;
  FTimer := nil;
  FMaxTimeAfterBeginning := 0;
  FMaxTimeAfterLastOutput := 0;
  FPriority := NORMAL_PRIORITY_CLASS;
  FEndStatus := Ord(esNone);
  FEnvironment := TStringList.Create;
end;

destructor TDosCommand.Destroy;
begin
  Stop;
  FLines.Free;
  FTimer.Free;
  FEnvironment.Free;
  inherited Destroy;
end;

function TDosCommand.DoCharDecoding(ASender: TObject; ABuf: TStream): string;
var
  pBytes: TBytes;
  iLength: Integer;
begin
  if Assigned(FOnCharDecoding) then // ask for converting ABuf to string
    Result := FOnCharDecoding(Self, ABuf)
  else
  begin // treat as ANSI
    iLength := ABuf.Size;
    if iLength > 0 then
    begin
      SetLength(pBytes, iLength);
      ABuf.Read(pBytes, iLength);
      Result := TEncoding.ANSI.GetString(pBytes);
    end
    else
      Result := '';
  end;
end;

procedure TDosCommand.DoCharEncoding(ASender: TObject; const AChars: string; AOutBuf: TStream);
var
  pBytes: TBytes;
begin
  if Assigned(FOnCharEncoding) then
    FOnCharEncoding(Self, AChars, AOutBuf)
  else if Length(AChars) > 0 then
  begin
    pBytes := TEncoding.ANSI.GetBytes(AChars);
    AOutBuf.Write(pBytes, Length(pBytes)); // console is ANSI
  end;
end;

procedure TDosCommand.Execute;
begin
  if FThread <> nil then
    raise EDosCommand.CreateRes(@SStillRunning);

  if FCommandLine = '' then // MK: 20030613
    raise EDosCommand.CreateRes(@SNoCommandLine);
  if (FTimer = nil) then // create the timer (first call to execute)
    FTimer := TProcessTimer.Create;
  FLines.Clear; // clear old outputs
  FTimer.Beginning; // turn the timer on
  FThread := TDosThread.Create(Self, FCommandLine, FCurrentDir, FLines,
    FOutputLines, FTimer, FMaxTimeAfterBeginning, FMaxTimeAfterLastOutput,
    FOnNewLine, FOnNewChar, ThreadTerminated, FOnTerminateProcess, FPriority,
    FInputToOutput, FEnvironment, DoCharDecoding, DoCharEncoding);
end;

function TDosCommand.get_EndStatus: TEndStatus;
begin
  Result := TEndStatus(FEndStatus);
end;

function TDosCommand.get_IsRunning: Boolean;
begin
  Result := Assigned(FThread); // sirius
end;

procedure TDosCommand.SendLine(const AValue: string; AEol: Boolean);
const
  EolCh: array [Boolean] of Char = (' ', '_');
begin
  if (FThread <> nil) then
    FThread.InputLines.Add(EolCh[AEol] + AValue)
  else
    raise EDosCommand.CreateRes(@SNotRunning);
end;

procedure TDosCommand.set_CharDecoding(const AValue: TCharDecoding);
begin
  if not IsRunning then
    FOnCharDecoding := AValue
  else
    raise EDosCommand.CreateRes(@SStillRunning);
end;

procedure TDosCommand.set_CharEncoding(const AValue: TCharEncoding);
begin
  if not IsRunning then
    FOnCharEncoding := AValue
  else
    raise EDosCommand.CreateRes(@SStillRunning);
end;

procedure TDosCommand.Stop;
begin
  if (FThread <> nil) then
  begin
    FThread.Terminate; // by sirius
    // FThread.WaitFor; // by sirius2
    // FreeAndNil(FThread);
  end;
end;

procedure TDosCommand.ThreadTerminated(ASender: TObject);
var
  E: Exception;
  handled: Boolean;
  procedure show(E: Exception);
  begin
    MessageBox(0, PChar(E.ClassName + sLineBreak + E.Message),
      PChar(ExtractFileName(ParamStr(0))), MB_OK or MB_ICONSTOP or
      MB_TASKMODAL);
  end;

begin
  FExitCode := (ASender as TDosThread).FExitCode;
  FTimer.Ending;
  if FThread.FreeOnTerminate then
    FThread := nil;
  if Assigned((ASender as TThread).FatalException) then
  begin
    E := TThread(ASender).FatalException as Exception;
    try
      if Assigned(FonExecuteError) then
      begin
        handled := False;
        FonExecuteError(Self, E, handled);
        if not handled then
          show(E);
      end
      else
        show(E);
    except
      on E: Exception do
        show(E);
    end;
  end;
  if Assigned(FOnTerminated) then
    FOnTerminated(Self);
end;

{ TInputLines }

constructor TInputLines.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FEvent := TEvent.Create(nil, False, False, '');
end;

destructor TInputLines.Destroy;
begin
  LockList;
  try
    FList.Free;
    FList := nil;
  finally
    UnlockList;
    FEvent.Free;
  end;
  inherited Destroy;
end;

function TInputLines.Add(const AValue: string): Integer;
var
  pList: TStrings;
begin
  pList := LockList;
  try
    Result := pList.Add(AValue);
  finally
    UnlockList;
  end;
  FEvent.SetEvent;
end;

function TInputLines.Count: Integer;
var
  pList: TStrings;
begin
  pList := LockList;
  try
    Result := pList.Count;
  finally
    UnlockList;
  end;
end;

procedure TInputLines.Delete(AIndex: Integer);
var
  pList: TStrings;
begin
  pList := LockList;
  try
    pList.Delete(AIndex);
  finally
    UnlockList;
  end;
end;

function TInputLines.get_Strings(AIndex: Integer): string;
var
  pList: TStrings;
begin
  pList := LockList;
  try
    Result := pList[AIndex];
  finally
    UnlockList;
  end;
end;

function TInputLines.LockList: TStrings;
begin
  BeginWrite;
  Result := FList;
end;

procedure TInputLines.set_Strings(AIndex: Integer; const AValue: string);
var
  pList: TStrings;
begin
  pList := LockList;
  try
    pList[AIndex] := AValue;
  finally
    UnlockList;
  end;
end;

procedure TInputLines.UnlockList;
begin
  EndWrite;
end;

{ TSyncString }

procedure TSyncString.Add(const AValue: string);
begin
  BeginWrite;
  try
    FValue := FValue + AValue;
  finally
    EndWrite;
  end;
end;

procedure TSyncString.Delete(APos, ACount: Integer);
begin
  BeginWrite;
  try
    System.Delete(FValue, APos, ACount);
  finally
    EndWrite;
  end;
end;

function TSyncString.get_Value: string;
begin
  BeginRead;
  try
    Result := FValue;
  finally
    EndRead;
  end;
end;

function TSyncString.Length: Integer;
begin
  BeginRead;
  try
    Result := System.Length(FValue);
  finally
    EndRead;
  end;
end;

procedure TSyncString.set_Value(const AValue: string);
begin
  BeginWrite;
  try
    FValue := AValue;
  finally
    EndWrite;
  end;
end;

{ TReadPipe }

constructor TReadPipe.Create(AReadStdout, AWriteStdout: THandle; AOnCharDecoding: TCharDecoding);
begin
  inherited Create(False);
  FOnCharDecoding := AOnCharDecoding;
  FEvent := TEvent.Create(nil, False, False, '');
  FSyncString := TSyncString.Create;
  Fread_stdout := AReadStdout;
  Fwrite_stdout := AWriteStdout;
  FreeOnTerminate := False;
end;

destructor TReadPipe.Destroy;
begin
  FEvent.Free;
  FSyncString.Free;
  inherited Destroy;
end;

procedure TReadPipe.Execute;
var
  lBuf: array [0 .. 1023] of Byte;
  lStream: TStream;
  lBread: Cardinal;
begin
  try
    NameThreadForDebugging('TReadPipe');
    lStream := TMemoryStream.Create;
    try
      repeat
        FillChar(lBuf, Length(lBuf), 0);
        if not ReadFile(Fread_stdout, lBuf[0], Length(lBuf), lBread, nil) then
        // wait for input
          Assert(GetLastError = Error_broken_pipe);
        if Terminated then
          Break;
        lStream.Size := 0;
        lStream.Write(lBuf[0], lBread);
        lStream.Seek(0, soFromBeginning);
        FSyncString.Add(FOnCharDecoding(Self, lStream));
        FEvent.SetEvent;
      until Terminated;
    finally
      lStream.Free;
    end;
  except
    on E: Exception do
      OutputDebugString(PChar('EXCEPTION: TReadPipe Execute ' + E.Message));
  end;
end;

procedure TReadPipe.Terminate;
const
  fin = 'fin';
var
  bwrite: Cardinal;
begin
  inherited Terminate;
  Assert(WriteFile(Fwrite_stdout, fin, Length(fin), bwrite, nil));
end;

end.
