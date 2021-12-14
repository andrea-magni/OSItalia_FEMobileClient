unit OSItalia.FE.RestClient;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.JSon,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  System.Net.URLClient,
  System.NetEncoding,

  OSItalia.FE.Classes;

type

{ ERestClientException }

  ERestClientException = class(Exception)
  public
    constructor Create(const AMessage: String); overload;
    constructor Create(
      const AStatusCode: Integer; const AJSon: String); overload;
  end;

{ TRestClient }

  TRestClient = class
  strict private
    const URL: String = 'http://testservice.ositalia.cloud';
    // const URL: String = 'https://service.ositalia.cloud';
  strict private
    FHttpClient: THttpClient;
    FToken: TJWToken;
    FLastToken: TDateTime;

    procedure CheckResponse(const AResponse: IHttpResponse);
    procedure CheckToken(const ARenew: Boolean);
    function GetHeaders: TNetHeaders;

    procedure DownloadContenuto(
      const AURI: String;
      const AID: String;
      const AFileName: String;
      const AResponse: TMemoryStream);

    procedure DownloadFatture(
      const AFilter: TFattureFilter;
      const AURI: String;
      const AResponse: TMemoryStream);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Logon(const AUsername: String; const APassword: String);

    procedure RenewToken;

    procedure ChangePassword(
      const AOldPassword: String; const ANewPassword: String);

    procedure ElencoFattureAttive(
      const AFilter: TFattureFilter; const AResponse: TFattureAttiveResponse);
    procedure DownloadFattureAttive(
      const AFilter: TFattureFilter; const AResponse: TMemoryStream);
    procedure DownloadXmlFatturaAttiva(
      const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);
    procedure DownloadP7mFatturaAttiva(
      const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);
    procedure DownloadHtmlFatturaAttiva(
      const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);

    procedure ElencoNotificheFattura(
      const AFattura: TFatturaAttiva; const AResponse: TNotificheResponse);
    procedure DownloadXmlNotifica(
      const ANotifica: TNotifica; const AResponse: TMemoryStream);

    procedure ElencoFatturePassive(
      const AFilter: TFattureFilter; const AResponse: TFatturePassiveResponse);
    procedure DownloadFatturePassive(
      const AFilter: TFattureFilter; const AResponse: TMemoryStream);
    procedure DownloadXmlFatturaPassiva(
      const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
    procedure DownloadP7mFatturaPassiva(
      const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
    procedure DownloadHtmlFatturaPassiva(
      const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
    procedure DownloadMetaDatiFatturaPassiva(
      const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);

    property Token: TJWToken read FToken;
  end;

implementation

{ ERestClientException }

constructor ERestClientException.Create(const AMessage: String);
begin
  inherited Create(AMessage);
end;

constructor ERestClientException.Create(
  const AStatusCode: Integer; const AJSon: String);
var
  LJSon: TJSonValue;
  LMessage: String;
begin
  LJSon := TJSonObject.ParseJSonValue(AJSon);
  if not Assigned(LJSon) then
    LMessage := Format('%s (%d)', [AJSon, AStatusCode])
  else
  begin
    try
      LMessage := Format('%s (ErrorCode: %d, StatusCode: %d)', [
        LJSon.GetValue<String>('ErrorMessage', ''),
        LJSon.GetValue<Integer>('ErrorCode', 0),
        AStatusCode]);
    finally
      LJSon.Free;
    end;
  end;

  inherited Create(LMessage);
end;

{ TRestClient }

constructor TRestClient.Create;
begin
  inherited Create;
  FHttpClient := THttpClient.Create;
  FToken := TJWToken.Create('');
end;

destructor TRestClient.Destroy;
begin
  FHttpClient.Free;
  inherited Destroy;
end;

procedure TRestClient.CheckResponse(
  const AResponse: IHttpResponse);
begin
  if (AResponse.StatusCode <> 200) and (AResponse.StatusCode <> 201) then
    raise ERestClientException.Create(
      AResponse.StatusCode,
      AResponse.ContentAsString());
end;

procedure TRestClient.CheckToken(const ARenew: Boolean);
begin
  if FToken.IsEmpty then
    raise ERestClientException.Create('Autenticazione non effettuata.');

  // Il Token scade dopo 30 minuti
  if ARenew and (MinutesBetween(Now, FLastToken) > 25) then
    RenewToken;
end;

function TRestClient.GetHeaders: TNetHeaders;
begin
  SetLength(result, 1);
  result[0].Create('Authorization', Format('Bearer %s', [FToken.Token]));
end;

procedure TRestClient.Logon(
  const AUsername: String; const APassword: String);
var
  LRequest: TLogonRequest;
  LResponse: IHttpResponse;
  LTokenResponse: TTokenResponse;
begin
  LRequest := TLogonRequest.Create(AUsername, APassword);
  try
    LResponse := FHttpClient.Post(Format('%s/logon', [URL]), LRequest.Stream);
    CheckResponse(LResponse);
    LTokenResponse := TTokenResponse.Create(LResponse.ContentAsString());
    try
      FToken := TJWToken.Create(LTokenResponse.Token);
      FLastToken := Now;
    finally
      LTokenResponse.Free;
    end;
  finally
    LRequest.Free;
  end;
end;

procedure TRestClient.RenewToken;
var
  LRequest: TRenewTokenRequest;
  LResponse: IHttpResponse;
  LTokenResponse: TTokenResponse;
begin
  CheckToken(False);
  LRequest := TRenewTokenRequest.Create(FToken.Token);
  try
    LResponse := FHttpClient.Post(
      Format('%s/renewtoken', [URL]), LRequest.Stream);
    CheckResponse(LResponse);
    LTokenResponse := TTokenResponse.Create(LResponse.ContentAsString());
    try
      FToken := TJWToken.Create(LTokenResponse.Token);
      FLastToken := Now;
    finally
      LTokenResponse.Free;
    end;
  finally
    LRequest.Free;
  end;
end;

procedure TRestClient.ChangePassword(
  const AOldPassword: String; const ANewPassword: String);
var
  LRequest: TChangePasswordRequest;
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  LRequest := TChangePasswordRequest.Create(AOldPassword, ANewPassword);
  try
    LResponse := FHttpClient.Post(
      Format('%s/changepassword', [URL]),
      LRequest.Stream,
      nil,
      GetHeaders());
    CheckResponse(LResponse);
  finally
    LRequest.Free;
  end;
end;

procedure TRestClient.DownloadContenuto(
  const AURI: String;
  const AID: String;
  const AFileName: String;
  const AResponse: TMemoryStream);
var
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  AResponse.Clear;
  LResponse := FHttpClient.Get(
    Format('%s/%s?Token=%s&ID=%s&FileName=%s', [
      URL, AURI, FToken.Token, AID, AFileName]),
    AResponse);
  AResponse.Position := 0;
  CheckResponse(LResponse);
end;

procedure TRestClient.DownloadFatture(
  const AFilter: TFattureFilter;
  const AURI: String;
  const AResponse: TMemoryStream);
var
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  if not Assigned(AFilter) then
    raise ERestClientException.Create('Filtro non assegnato.');

  AResponse.Clear;
  LResponse := FHttpClient.Post(
    Format('%s/%s', [URL, AURI]),
    AFilter.Stream,
    AResponse,
    GetHeaders());
  AResponse.Position := 0;
  CheckResponse(LResponse);
end;

procedure TRestClient.ElencoFattureAttive(
  const AFilter: TFattureFilter; const AResponse: TFattureAttiveResponse);
var
  LStream: TStream;
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  LStream := nil;
  if Assigned(AFilter) then
    LStream := AFilter.Stream;

  LResponse := FHttpClient.Post(
    Format('%s/portal/fattureinviate', [URL]),
    LStream,
    nil,
    GetHeaders());
  CheckResponse(LResponse);
  AResponse.LoadFromJSon(LResponse.ContentAsString());
end;

procedure TRestClient.DownloadFattureAttive(
  const AFilter: TFattureFilter; const AResponse: TMemoryStream);
begin
  DownloadFatture(AFilter, 'portal/downloadfattureinviate', AResponse);
end;

procedure TRestClient.DownloadXmlFatturaAttiva(
  const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);
var
  LNomeFile: String;
begin
  LNomeFile := AFattura.NomeFile;
  if LNomeFile.ToLower().EndsWith('.p7m') then
    LNomeFile := LNomeFile.Substring(0, LNomeFile.Length - 4);

  DownloadContenuto(
    'portal/fattureinviate/file',
    AFattura.ContenutoIDXml,
    LNomeFile,
    AResponse);
end;

procedure TRestClient.DownloadP7mFatturaAttiva(
  const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fattureinviate/file',
    AFattura.ContenutoIDP7m,
    AFattura.NomeFile,
    AResponse);
end;

procedure TRestClient.DownloadHtmlFatturaAttiva(
  const AFattura: TFatturaAttiva; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fattureinviate/filepreview',
    AFattura.ContenutoIDXml,
    '',
    AResponse);
end;

procedure TRestClient.ElencoNotificheFattura(
  const AFattura: TFatturaAttiva; const AResponse: TNotificheResponse);
var
  LRequest: TNotificheRequest;
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  LRequest := TNotificheRequest.Create(AFattura.ID);
  try
    LResponse := FHttpClient.Post(
      Format('%s/portal/fattureinviate/notifiche', [URL]),
      LRequest.Stream,
      nil,
      GetHeaders());
    CheckResponse(LResponse);
    AResponse.LoadFromJSon(LResponse.ContentAsString());
  finally
    LRequest.Free;
  end;
end;

procedure TRestClient.DownloadXmlNotifica(
  const ANotifica: TNotifica; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fattureinviate/file',
    ANotifica.ContenutoID,
    ANotifica.NomeFile,
    AResponse);
end;

procedure TRestClient.ElencoFatturePassive(
  const AFilter: TFattureFilter; const AResponse: TFatturePassiveResponse);
var
  LStream: TStream;
  LResponse: IHttpResponse;
begin
  CheckToken(True);
  LStream := nil;
  if Assigned(AFilter) then
    LStream := AFilter.Stream;

  LResponse := FHttpClient.Post(
    Format('%s/portal/fatturericevute', [URL]),
    LStream,
    nil,
    GetHeaders());
  CheckResponse(LResponse);
  AResponse.LoadFromJSon(LResponse.ContentAsString());
end;

procedure TRestClient.DownloadFatturePassive(
  const AFilter: TFattureFilter; const AResponse: TMemoryStream);
begin
  DownloadFatture(AFilter, 'portal/downloadfatturericevute', AResponse);
end;

procedure TRestClient.DownloadXmlFatturaPassiva(
  const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
var
  LNomeFile: String;
begin
  LNomeFile := AFattura.NomeFile;
  if LNomeFile.ToLower().EndsWith('.p7m') then
    LNomeFile := LNomeFile.Substring(0, LNomeFile.Length - 4);

  DownloadContenuto(
    'portal/fatturericevute/file',
    AFattura.ContenutoXmlID,
    LNomeFile,
    AResponse);
end;

procedure TRestClient.DownloadP7mFatturaPassiva(
  const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fatturericevute/file',
    AFattura.ContenutoOriginaleID,
    AFattura.NomeFile,
    AResponse);
end;

procedure TRestClient.DownloadHtmlFatturaPassiva(
  const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fatturericevute/filepreview',
    AFattura.ContenutoXmlID,
    '',
    AResponse);
end;

procedure TRestClient.DownloadMetaDatiFatturaPassiva(
  const AFattura: TFatturaPassiva; const AResponse: TMemoryStream);
begin
  DownloadContenuto(
    'portal/fatturericevute/file',
    AFattura.ContenutoMetaDatiID,
    AFattura.NomeFileMetaDati,
    AResponse);
end;

end.
