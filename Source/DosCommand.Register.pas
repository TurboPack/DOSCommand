unit DosCommand.Register;

interface

procedure Register;

implementation

uses
  System.Classes, DosCommand;

procedure Register;
const
  cPage = 'DOSCommand';
begin
  RegisterComponents(cPage, [TDosCommand]);
end;

end.
