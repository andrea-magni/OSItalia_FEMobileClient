unit Data.Remote;

interface

uses
  System.SysUtils, System.Classes
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
    procedure SetLoggedIn(const Value: Boolean);
  protected

    // logon {"Username": "", "Password": ""} --> {"Token": ""} (20 min)
    // renewtoken {"Token": ""} --> {"Token": ""}
    // changepassword {"OldPassword": "", "NewPassword": ""}

    // /portal/fattureinviate (filtro) --> {"count": 123, "data": [{}, {}]}
    // /portal/fattureinviate/notifiche {"FatturaID": ""} --> [{"TipoNotificaID"}, {}]
    // /portal/fattureinviate/file ?Token=JWT&ID=&FileName=
    // /portal/fattureinviate/filepreview ?Token=JWT&ID=

    // /portal/fatturericevute

    // download massivo
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Login(const AOnSuccess: TProc = nil; const AOnError: TProc<string> = nil);
    procedure GetFattureRicevute(const AFattureProc: TFatturePassiveResponseProc; const AErrorProc: TProc<string> = nil);
    procedure GetFattureInviate(const AFattureProc: TFattureAttiveResponseProc; const AErrorProc: TProc<string> = nil);

    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property LoggedIn: Boolean read FLoggedIn write SetLoggedIn;
    property LoginTime: TDateTime read FLoginTime;
  end;

var
  RemoteData: TRemoteData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TRemoteData }

constructor TRemoteData.Create(AOwner: TComponent);
begin
  inherited;
  FRESTClient := TRestClient.Create;
end;

destructor TRemoteData.Destroy;
begin
  FreeAndNil(FRESTClient);
  inherited;
end;

procedure TRemoteData.Login(const AOnSuccess: TProc; const AOnError: TProc<string>);
begin
  try
    FRESTClient.Logon(Username, Password); // sync
    LoggedIn := True;
    if Assigned(AOnSuccess) then
      AOnSuccess();
  except on E: Exception do
    begin
      LoggedIn := False;
      if Assigned(AOnError) then
        AOnError(E.ToString);
    end;
  end;
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

procedure TRemoteData.GetFattureInviate(const AFattureProc: TFattureAttiveResponseProc; const AErrorProc: TProc<string> = nil);
begin
  var LResponse := TFattureAttiveResponse.Create;
  try
    FRESTClient.ElencoFattureAttive(nil, LResponse);
    if Assigned(AFattureProc) then
      AFattureProc(LResponse);
  finally
    LResponse.Free;
  end;
end;

procedure TRemoteData.GetFattureRicevute(const AFattureProc: TFatturePassiveResponseProc; const AErrorProc: TProc<string> = nil);
begin
  var LResponse := TFatturePassiveResponse.Create;
  try
    FRESTClient.ElencoFatturePassive(nil, LResponse);
    if Assigned(AFattureProc) then
      AFattureProc(LResponse);
  finally
    LResponse.Free;
  end;
end;

end.
