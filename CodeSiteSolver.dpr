program CodeSiteSolver;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmCSDataGen};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'CodeSite Custom Data Generator';
  Application.CreateForm(TfrmCSDataGen, frmCSDataGen);
  Application.Run;
end.
