program FEMobileClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Data.Remote in 'Data.Remote.pas' {RemoteData: TDataModule},
  Routes.fatture_inviate in 'Routes.fatture_inviate.pas',
  Routes.fatture_ricevute in 'Routes.fatture_ricevute.pas',
  Routes.home in 'Routes.home.pas',
  Data.Model in 'Data.Model.pas',
  Utils.UI in 'Utils.UI.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF MSWINDOWS} ReportMemoryLeaksOnShutdown := True; {$ENDIF}
  Application.CreateForm(TRemoteData, RemoteData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
