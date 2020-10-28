program KML2LPXML;

uses
  Forms,
  MainForm in 'MainForm.pas' {MainF},
  XMLExportRoutines in 'XMLExportRoutines.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'KML2LPXML';
  Application.CreateForm(TMainF, MainF);
  Application.Run;
end.
