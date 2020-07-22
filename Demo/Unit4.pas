unit Unit4;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  DosCommand
  ;

type
  TForm4 = class(TForm)
    Memo1: TMemo;
    DosCommand1: TDosCommand;
    Button1: TButton;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure DosCommand1Terminated(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses System.IOUtils;

procedure TForm4.Button1Click(Sender: TObject);
begin
  DosCommand1.CommandLine := 'cmd /c "dir"';
  DosCommand1.CurrentDir := 'c:\windows';
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  DosCommand1.OutputLines := Memo1.Lines;

  Button1.Enabled := False;
  DosCommand1.Execute;
  Memo1.Lines := DosCommand1.Lines;
end;

procedure TForm4.DosCommand1NewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  if AOutputType = otEntireLine then
  begin
    Memo2.Lines.Add(ANewLine);
  end;
end;

procedure TForm4.DosCommand1Terminated(Sender: TObject);
begin
  Button1.Enabled := True;
end;

end.
