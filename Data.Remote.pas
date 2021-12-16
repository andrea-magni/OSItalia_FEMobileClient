unit Data.Remote;

interface

uses
  System.SysUtils, System.Classes, System.Threading, StrUtils
, OSItalia.FE.Classes, OSItalia.FE.RestClient
;

type
  TFatturePassiveResponseProc = reference to procedure (const AResponse: TFatturePassiveResponse);
  TFattureAttiveResponseProc = reference to procedure (const AResponse: TFattureAttiveResponse);

  TRemoteData = class(TDataModule)
  private
    FRESTClient: TRestClient;
    FPassword: string;
    FUsername: string;
    FLoggedIn: Boolean;
    FLoginTime: TDateTime;
    FFattureAttiveResponse: TFattureAttiveResponse;
    FFatturePassiveResponse: TFatturePassiveResponse;
    FFatturaSelezionata: TObject;
    FNewPassword: string;
    FOldPassword: string;
    procedure SetLoggedIn(const Value: Boolean);
    function GetToken: string;
    function GetFatturaSelezionataAttiva: TFatturaAttiva;
    function GetFatturaSelezionataIsAttiva: Boolean;
    function GetFatturaSelezionataIsPassiva: Boolean;
    function GetFatturaSelezionataPassiva: TFatturaPassiva;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Login(const AOnSuccess: TProc = nil; const AOnError: TProc<string> = nil);
    procedure CambiaPassword(const AOnSuccess: TProc = nil; const AOnError: TProc<string> = nil);
    procedure GetFattureRicevute(const AFattureProc: TFatturePassiveResponseProc; const AErrorProc: TProc<string> = nil);
    procedure GetFattureInviate(const AFattureProc: TFattureAttiveResponseProc; const AErrorProc: TProc<string> = nil);
    function GetFatturaPreviewURL(): string;

    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property OldPassword: string read FOldPassword write FOldPassword;
    property NewPassword: string read FNewPassword write FNewPassword;
    property LoggedIn: Boolean read FLoggedIn write SetLoggedIn;
    property LoginTime: TDateTime read FLoginTime;
    property Token: string read GetToken;

    property FatturaSelezionata: TObject read FFatturaSelezionata write FFatturaSelezionata;
    property FatturaSelezionataIsAttiva: Boolean read GetFatturaSelezionataIsAttiva;
    property FatturaSelezionataIsPassiva: Boolean read GetFatturaSelezionataIsPassiva;
    property FatturaSelezionataAttiva: TFatturaAttiva read GetFatturaSelezionataAttiva;
    property FatturaSelezionataPassiva: TFatturaPassiva read GetFatturaSelezionataPassiva;
  end;

var
  RemoteData: TRemoteData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TRemoteData }

procedure TRemoteData.CambiaPassword(const AOnSuccess: TProc;
  const AOnError: TProc<string>);
begin
  TTask.Run(
    procedure
    begin
      try
        FRESTClient.ChangePassword(OldPassword, NewPassword); // sync
        TThread.Synchronize(nil
        , procedure
          begin
            if Assigned(AOnSuccess) then
              AOnSuccess();
          end
        );
      except on E: Exception do
        begin
          TThread.Synchronize(nil
          , procedure
            begin
              if Assigned(AOnError) then
                AOnError(E.ToString);
            end
          );
        end;
      end;
    end
  );
end;

constructor TRemoteData.Create(AOwner: TComponent);
begin
  inherited;
  FRESTClient := TRestClient.Create;
  FFattureAttiveResponse := TFattureAttiveResponse.Create;
  FFatturePassiveResponse := TFatturePassiveResponse.Create;
end;

destructor TRemoteData.Destroy;
begin
  FreeAndNil(FFatturePassiveResponse);
  FreeAndNil(FFattureAttiveResponse);
  FreeAndNil(FRESTClient);
  inherited;
end;

procedure TRemoteData.Login(const AOnSuccess: TProc; const AOnError: TProc<string>);
begin
  TTask.Run(
    procedure
    begin
      try
        FRESTClient.Logon(Username, Password); // sync
        TThread.Synchronize(nil
        , procedure
          begin
            LoggedIn := True;
            if Assigned(AOnSuccess) then
              AOnSuccess();
          end
        );
      except on E: Exception do
        begin
          TThread.Synchronize(nil
          , procedure
            begin
              LoggedIn := False;
              if Assigned(AOnError) then
                AOnError(E.ToString);
            end
          );
        end;
      end;
    end
  );

end;

procedure TRemoteData.SetLoggedIn(const Value: Boolean);
begin
  if FLoggedIn <> Value then
  begin
    FLoggedIn := Value;
    if FLoggedIn then
      FLoginTime := Now
    else
      FLoginTime := 0.0;
  end;
end;

function TRemoteData.GetFatturaPreviewURL: string;
var
  LTipo: string;
  LID: string;
begin
  if not Assigned(FatturaSelezionata) then
    raise Exception.Create('Nessuna fattura selezionata');

  if FatturaSelezionataIsAttiva then
  begin
    LTipo := 'fattureinviate';
    LID := FatturaSelezionataAttiva.ContenutoIDXml;
  end
  else if FatturaSelezionataIsPassiva then
  begin
    LTipo := 'fatturericevute';
    LID := FatturaSelezionataPassiva.ContenutoXmlID;
  end;

  Result :=
      'http://testservice.ositalia.cloud/portal/' + LTipo + '/filepreview'
    + '?' + 'Token=' + Token + '&ID=' + LID;
end;

function TRemoteData.GetFatturaSelezionataAttiva: TFatturaAttiva;
begin
  Result := FFatturaSelezionata as TFatturaAttiva;
end;

function TRemoteData.GetFatturaSelezionataIsAttiva: Boolean;
begin
  Result := FFatturaSelezionata is TFatturaAttiva;
end;

function TRemoteData.GetFatturaSelezionataIsPassiva: Boolean;
begin
  Result := FFatturaSelezionata is TFatturaPassiva;
end;

function TRemoteData.GetFatturaSelezionataPassiva: TFatturaPassiva;
begin
  Result := FFatturaSelezionata as TFatturaPassiva;
end;

procedure TRemoteData.GetFattureInviate(const AFattureProc: TFattureAttiveResponseProc; const AErrorProc: TProc<string> = nil);
begin
  TTask.Run(
    procedure
    begin
      FRESTClient.ElencoFattureAttive(nil, FFattureAttiveResponse);
      TThread.Synchronize(nil, procedure
                               begin
                                 if Assigned(AFattureProc) then
                                   AFattureProc(FFattureAttiveResponse);
                               end);
    end);
end;

procedure TRemoteData.GetFattureRicevute(const AFattureProc: TFatturePassiveResponseProc; const AErrorProc: TProc<string> = nil);
begin
  TTask.Run(
    procedure
    begin
      FRESTClient.ElencoFatturePassive(nil, FFatturePassiveResponse);
      TThread.Synchronize(nil, procedure
                               begin
                                 if Assigned(AFattureProc) then
                                   AFattureProc(FFatturePassiveResponse);
                               end);
    end);
end;

function TRemoteData.GetToken: string;
begin
  Result := '';
  if LoggedIn then
    Result := FRESTClient.Token.Token;
end;

end.
