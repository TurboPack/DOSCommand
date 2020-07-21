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
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  DosCommand1.CommandLine := 'cmd /c "dir"';
  DosCommand1.CurrentDir := 'c:\windows';
  DosCommand1.OutputLines := Memo1.Lines;
  DosCommand1.Execute;
end;

end.
