program FEMobileClient;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Data.Remote in 'Data.Remote.pas' {RemoteData: TDataModule},
  Routes.fatture_inviate in 'Routes.fatture_inviate.pas',
  Routes.fatture_ricevute in 'Routes.fatture_ricevute.pas',
  Routes.home in 'Routes.home.pas',
  Utils.UI in 'Utils.UI.pas',
  OSItalia.FE.Classes in 'Client\OSItalia.FE.Classes.pas',
  OSItalia.FE.RestClient in 'Client\OSItalia.FE.RestClient.pas',
  Routes.login in 'Routes.login.pas',
  Routes.bubbles in 'Routes.bubbles.pas',
  Definitions.FatturaToolbar in 'Definitions.FatturaToolbar.pas',
  Routes.fattura_preview in 'Routes.fattura_preview.pas',
  Routes.change_password in 'Routes.change_password.pas';

{$R *.res}

begin
  Application.Initialize;
//  {$IFDEF MSWINDOWS} ReportMemoryLeaksOnShutdown := True; {$ENDIF}
  Application.CreateForm(TRemoteData, RemoteData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
