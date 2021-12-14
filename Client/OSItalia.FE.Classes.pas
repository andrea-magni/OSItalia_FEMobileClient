unit OSItalia.FE.Classes;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.JSon,
  System.NetEncoding;

type

{ TJSonHelper }

  TJSonHelper = class helper for TJSonValue
  public
    function AsDateTime(const AName: String): TDateTime;
  end;

{ TEnumerator<T> }

  TEnumerator<T> = class
  strict private
    FList: TList<T>;
    FIndex: Integer;

    function GetCurrent: T;
  public
    constructor Create(const AList: TList<T>);

    function MoveNext: Boolean;

    property Current: T read GetCurrent;
  end;

{ TJWToken }

  TJWToken = record
  strict private
    FToken: String;
    FFullname: String;
    FUsername: String;
    FAnagraficaID: Integer;
    FAnagrafica: String;
    FUtenteID: Integer;
    FGruppoIva: Boolean;
    FCodiceISO: String;
    FPartitaIva: String;
    FCodiceFiscale: String;
    FCodiceIPA: String;
    FExpireTime: Int64;

    function GetIsEmpty: Boolean;
    procedure LoadFromToken;
  public
    constructor Create(const AToken: String);

    class operator Initialize(out AJWToken: TJWToken);

    property Token: String read FToken;
    property Fullname: String read FFullname;
    property Username: String read FUsername;
    property AnagraficaID: Integer read FAnagraficaID;
    property Anagrafica: String read FAnagrafica;
    property UtenteID: Integer read FUtenteID;
    property GruppoIva: Boolean read FGruppoIva;
    property CodiceISO: String read FCodiceISO;
    property PartitaIva: String read FPartitaIva;
    property CodiceFiscale: String read FCodiceFiscale;
    property CodiceIPA: String read FCodiceIPA;
    property ExpireTime: Int64 read FExpireTime;

    property IsEmpty: Boolean read GetIsEmpty;
  end;

{ TLogonRequest }

  TLogonRequest = class
  strict private
    FUsername: String;
    FPassword: String;
    FStream: TStream;

    function GetStream: TStream;
  public
    constructor Create(const AUsername: String; const APassword: String);
    destructor Destroy; override;

    property Stream: TStream read GetStream;
  end;

{ TRenewTokenRequest }

  TRenewTokenRequest = class
  strict private
    FToken: String;
    FStream: TStream;

    function GetStream: TStream;
  public
    constructor Create(const AToken: String);
    destructor Destroy; override;

    property Stream: TStream read GetStream;
  end;

{ TTokenResponse }

  TTokenResponse = class
  strict private
    FToken: String;
  public
    constructor Create(const AJSon: String);

    property Token: String read FToken;
  end;

{ TChangePasswordRequest }

  TChangePasswordRequest = class
  strict private
    FOldPassword: String;
    FNewPassword: String;
    FStream: TStream;

    function GetStream: TStream;
  public
    constructor Create(const AOldPassword: String; const ANewPassword: String);
    destructor Destroy; override;

    property Stream: TStream read GetStream;
  end;

{ TFattureFilter }

  TFattureFilter = class
  strict private
    FRagioneSociale: String;
    FPartitaIVA: String;
    FCodiceFiscale: String;
    FNumeroDocumento: String;
    FDaData: TDateTime;
    FAData: TDateTime;
    FDaDataRicezione: TDateTime;
    FADataRicezione: TDateTime;
    FTipoNotificaID: String;
    FTipoDocumentoID: String;
    FStream: TStream;

    function GetStream: TStream;
  public
    constructor Create;
    destructor Destroy; override;

    property RagioneSociale: String read FRagioneSociale write FRagioneSociale;
    property PartitaIVA: String read FPartitaIVA write FPartitaIVA;
    property CodiceFiscale: String read FCodiceFiscale write FCodiceFiscale;
    property NumeroDocumento: String
      read FNumeroDocumento write FNumeroDocumento;
    property DaData: TDateTime read FDaData write FDaData;
    property AData: TDateTime read FAData write FAData;
    property DaDataRicezione: TDateTime
      read FDaDataRicezione write FDaDataRicezione;
    property ADataRicezione: TDateTime
      read FADataRicezione write FADataRicezione;
    property TipoNotificaID: String read FTipoNotificaID write FTipoNotificaID;
    property TipoDocumentoID: String
      read FTipoDocumentoID write FTipoDocumentoID;
    property Stream: TStream read GetStream;
  end;

{ TFatturaAttiva }

  TFatturaAttiva = class
  strict private
    FID: String;
    FDataUpload: TDateTime;
    FOrigineID: Integer;
    FOrigine: String;
    FNomeFile: String;
    FFirmata: Boolean;
    FIdentificativoSDI: String;
    FDataOraRicezioneSDI: TDateTime;
    FConservata: Boolean;
    FNumeroFattura: String;
    FDataFattura: TDateTime;
    FTipoDocumentoID: String;
    FTipoDocumento: String;
    FCliente: String;
    FPartitaIVA: String;
    FCodiceFiscale: String;
    FImporto: Double;
    FContenutoIDXml: String;
    FContenutoIDP7m: String;
    FStato: String;
    FInEvidenza: Boolean;
    FAllegati: Integer;
  public
    constructor Create(const AJSon: TJSonObject);

    property ID: String read FID;
    property DataUpload: TDateTime read FDataUpload;
    property OrigineID: Integer read FOrigineID;
    property Origine: String read FOrigine;
    property NomeFile: String read FNomeFile;
    property Firmata: Boolean read FFirmata;
    property IdentificativoSDI: String read FIdentificativoSDI;
    property DataOraRicezioneSDI: TDateTime read FDataOraRicezioneSDI;
    property Conservata: Boolean read FConservata;
    property NumeroFattura: String read FNumeroFattura;
    property DataFattura: TDateTime read FDataFattura;
    property TipoDocumentoID: String read FTipoDocumentoID;
    property TipoDocumento: String read FTipoDocumento;
    property Cliente: String read FCliente;
    property PartitaIVA: String read FPartitaIVA;
    property CodiceFiscale: String read FCodiceFiscale;
    property Importo: Double read FImporto;
    property ContenutoIDXml: String read FContenutoIDXml;
    property ContenutoIDP7m: String read FContenutoIDP7m;
    property Stato: String read FStato;
    property InEvidenza: Boolean read FInEvidenza;
    property Allegati: Integer read FAllegati;
  end;

{ TFattureAttiveResponse }

  TFattureAttiveResponse = class
  strict private
    FFatture: TObjectList<TFatturaAttiva>;

    function GetCount: Integer;
    function GetFattura(const AIndex: Integer): TFatturaAttiva;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromJSon(const AJSon: String);

    function GetEnumerator: TEnumerator<TFatturaAttiva>;

    property Count: Integer read GetCount;
    property Fattura[const AIndex: Integer]: TFatturaAttiva
      read GetFattura; default;
  end;

{ TNotificheRequest }

  TNotificheRequest = class
  strict private
    FFatturaID: String;
    FStream: TStream;

    function GetStream: TStream;
  public
    constructor Create(const AFatturaID: String);
    destructor Destroy; override;

    property Stream: TStream read GetStream;
  end;

{ TNotifica }

  TNotifica = class
  strict private
    FID: String;
    FTipoNotificaID: String;
    FTipoNotifica: String;
    FIdentificativoSDI: String;
    FDataRicezione: String;
    FContenutoID: String;
    FNomeFile: String;
  public
    constructor Create(const AJSon: TJSonObject);

    property ID: String read FID;
    property TipoNotificaID: String read FTipoNotificaID;
    property TipoNotifica: String read FTipoNotifica;
    property IdentificativoSDI: String read FIdentificativoSDI;
    property DataRicezione: String read FDataRicezione;
    property ContenutoID: String read FContenutoID;
    property NomeFile: String read FNomeFile;
  end;

{ TNotificheResponse }

  TNotificheResponse = class
  strict private
    FNotifiche: TObjectList<TNotifica>;

    function GetCount: Integer;
    function GetNotifica(const AIndex: Integer): TNotifica;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromJSon(const AJSon: String);

    function GetEnumerator: TEnumerator<TNotifica>;

    property Count: Integer read GetCount;
    property Notifica[const AIndex: Integer]: TNotifica
      read GetNotifica; default;
  end;

{ TFatturaPassiva }

  TFatturaPassiva = class
  strict private
    FID: String;
    FDataRicezione: TDateTime;
    FDataInserimento: TDateTime;
    FOrigineID: Integer;
    FOrigine: String;
    FNomeFile: String;
    FIdentificativoSDI: String;
    FContenutoOriginaleID: String;
    FContenutoXmlID: String;
    FNomeFileMetaDati: String;
    FContenutoMetaDatiID: String;
    FConservata: Boolean;
    FNumeroFattura: String;
    FDataFattura: TDateTime;
    FTipoDocumentoID: String;
    FTipoDocumento: String;
    FFornitore: String;
    FPartitaIVA: String;
    FCodiceFiscale: String;
    FImporto: Double;
    FAllegati: Integer;
  public
    constructor Create(const AJSon: TJSonObject);

    property ID: String read FID;
    property DataRicezione: TDateTime read FDataRicezione;
    property DataInserimento: TDateTime read FDataInserimento;
    property OrigineID: Integer read FOrigineID;
    property Origine: String read FOrigine;
    property NomeFile: String read FNomeFile;
    property IdentificativoSDI: String read FIdentificativoSDI;
    property ContenutoOriginaleID: String read FContenutoOriginaleID;
    property ContenutoXmlID: String read FContenutoXmlID;
    property NomeFileMetaDati: String read FNomeFileMetaDati;
    property ContenutoMetaDatiID: String read FContenutoMetaDatiID;
    property Conservata: Boolean read FConservata;
    property NumeroFattura: String read FNumeroFattura;
    property DataFattura: TDateTime read FDataFattura;
    property TipoDocumentoID: String read FTipoDocumentoID;
    property TipoDocumento: String read FTipoDocumento;
    property Fornitore: String read FFornitore;
    property PartitaIVA: String read FPartitaIVA;
    property CodiceFiscale: String read FCodiceFiscale;
    property Importo: Double read FImporto;
    property Allegati: Integer read FAllegati;
  end;

{ TFatturePassiveResponse }

  TFatturePassiveResponse = class
  strict private
    FFatture: TObjectList<TFatturaPassiva>;

    function GetCount: Integer;
    function GetFattura(const AIndex: Integer): TFatturaPassiva;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromJSon(const AJSon: String);

    function GetEnumerator: TEnumerator<TFatturaPassiva>;

    property Count: Integer read GetCount;
    property Fattura[const AIndex: Integer]: TFatturaPassiva
      read GetFattura; default;
  end;

implementation

{ TJSonHelper }

function TJSonHelper.AsDateTime(const AName: String): TDateTime;
var
  LValue: String;
  LYear, LMonth, LDay, LHours, LMinutes, LSeconds: Word;
begin
  result := 0;
  LValue := Self.GetValue<String>(AName, '');
  if (LValue.Length >= 8) and
    Word.TryParse(LValue.Substring(0, 4), LYear) and
    Word.TryParse(LValue.Substring(4, 2), LMonth) and
    Word.TryParse(LValue.Substring(6, 2), LDay) then
    result := EncodeDate(LYear, LMonth, LDay);

  if (LValue.Length >= 14) and
    Word.TryParse(LValue.Substring(8, 2), LHours) and
    Word.TryParse(LValue.Substring(10, 2), LMinutes) and
    Word.TryParse(LValue.Substring(12, 2), LSeconds) then
    result := result + EncodeTime(LHours, LMinutes, LSeconds, 0);
end;

{ TEnumerator<T> }

constructor TEnumerator<T>.Create(const AList: TList<T>);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TEnumerator<T>.MoveNext: Boolean;
begin
  result := (FIndex < FList.Count - 1);
  if result then
    Inc(FIndex);
end;

function TEnumerator<T>.GetCurrent: T;
begin
  result := FList[FIndex];
end;

{ TJWToken }

constructor TJWToken.Create(const AToken: String);
begin
  FToken := AToken;
  if not FToken.IsEmpty then
    LoadFromToken;
end;

class operator TJWToken.Initialize(out AJWToken: TJWToken);
begin
  AJWToken.FFullname := '';
  AJWToken.FUsername := '';
  AJWToken.FAnagraficaID := 0;
  AJWToken.FAnagrafica := '';
  AJWToken.FUtenteID := 0;
  AJWToken.FGruppoIva := False;
  AJWToken.FCodiceISO := '';
  AJWToken.FPartitaIva := '';
  AJWToken.FCodiceFiscale := '';
  AJWToken.FCodiceIPA := '';
  AJWToken.FExpireTime := 0;
end;

function TJWToken.GetIsEmpty: Boolean;
begin
  result := FToken.IsEmpty;
end;

procedure TJWToken.LoadFromToken;
var
  LJSon: TJSonValue;
begin
  LJSon := TJSonObject.ParseJSonValue(
    TNetEncoding.Base64.Decode(FToken.Split(['.'])[1]));
  if Assigned(LJSon) then
    try
      FFullname := LJSon.GetValue<String>('Fullname', '');
      FUsername := LJSon.GetValue<String>('Username', '');
      FAnagraficaID := LJSon.GetValue<Integer>('AnagraficaID', 0);
      FAnagrafica := LJSon.GetValue<String>('Anagrafica', '');
      FUtenteID := LJSon.GetValue<Integer>('UtenteID', 0);
      FGruppoIva := LJSon.GetValue<Boolean>('GruppoIva', False);
      FCodiceISO := LJSon.GetValue<String>('CodiceISO', '');
      FPartitaIva := LJSon.GetValue<String>('PartitaIva', '');
      FCodiceFiscale := LJSon.GetValue<String>('CodiceFiscale', '');
      FCodiceIPA := LJSon.GetValue<String>('CodiceIPA', '');
      FExpireTime := LJSon.GetValue<Int64>('ExpireTime', 0);
    finally
      LJSon.Free;
    end;
end;

{ TLogonRequest }

constructor TLogonRequest.Create(const AUsername, APassword: String);
begin
  inherited Create;
  FUsername := AUsername;
  FPassword := APassword;
  FStream := nil;
end;

destructor TLogonRequest.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

function TLogonRequest.GetStream: TStream;
var
  LJSon: TJSonObject;
begin
  if not Assigned(FStream) then
  begin
    LJSon := TJSonObject.Create;
    try
      LJSon.AddPair('Username', FUsername);
      LJSon.AddPair('Password', FPassword);
      FStream := TStringStream.Create(LJSon.ToJSon());
    finally
      LJSon.Free;
    end;
  end;

  result := FStream;
end;

{ TRenewTokenRequest }

constructor TRenewTokenRequest.Create(const AToken: String);
begin
  inherited Create;
  FToken := AToken;
  FStream := nil;
end;

destructor TRenewTokenRequest.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

function TRenewTokenRequest.GetStream: TStream;
var
  LJSon: TJSonObject;
begin
  if not Assigned(FStream) then
  begin
    LJSon := TJSonObject.Create;
    try
      LJSon.AddPair('Token', FToken);
      FStream := TStringStream.Create(LJSon.ToJSon());
    finally
      LJSon.Free;
    end;
  end;

  result := FStream;
end;

{ TTokenResponse }

constructor TTokenResponse.Create(const AJSon: String);
var
  LJSon: TJSonValue;
begin
  FToken := '';

  LJSon := TJSonObject.ParseJSONValue(AJSon);
  if Assigned(LJSon) then
    try
      FToken := LJSon.GetValue<String>('Token', '');
    finally
      LJSon.Free;
    end;
end;

{ TChangePasswordRequest }

constructor TChangePasswordRequest.Create(
  const AOldPassword: String; const ANewPassword: String);
begin
  inherited Create;
  FOldPassword := AOldPassword;
  FNewPassword := ANewPassword;
  FStream := nil;
end;

destructor TChangePasswordRequest.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

function TChangePasswordRequest.GetStream: TStream;
var
  LJSon: TJSonObject;
begin
  if not Assigned(FStream) then
  begin
    LJSon := TJSonObject.Create;
    try
      LJSon.AddPair('OldPassword', FOldPassword);
      LJSon.AddPair('NewPassword', FNewPassword);
      FStream := TStringStream.Create(LJSon.ToJSon());
    finally
      LJSon.Free;
    end;
  end;

  result := FStream;
end;

{ TFattureFilter }

constructor TFattureFilter.Create;
begin
  inherited Create;
  FRagioneSociale := '';
  FPartitaIVA := '';
  FCodiceFiscale := '';
  FNumeroDocumento := '';
  FDaData := 0;
  FAData := 0;
  FDaDataRicezione := 0;
  FADataRicezione := 0;
  FTipoNotificaID := '';
  FTipoDocumentoID := '';
  FStream := nil;
end;

destructor TFattureFilter.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

function TFattureFilter.GetStream: TStream;
var
  LJSon: TJSonObject;
begin
  if Assigned(FStream) then
    FStream.Free;

  LJSon := TJSonObject.Create;
  try
    LJSon.AddPair('RagioneSociale', FRagioneSociale);
    LJSon.AddPair('PartitaIVA', FPartitaIVA);
    LJSon.AddPair('CodiceFiscale', FCodiceFiscale);
    LJSon.AddPair('NumeroDocumento', FNumeroDocumento);
    LJSon.AddPair('DaData', FormatDateTime('yyyy-mm-dd', FDaData));
    LJSon.AddPair('AData', FormatDateTime('yyyy-mm-dd', FAData));
    LJSon.AddPair('DaDataR', FormatDateTime('yyyy-mm-dd', FDaDataRicezione));
    LJSon.AddPair('ADataR', FormatDateTime('yyyy-mm-dd', FADataRicezione));
    LJSon.AddPair('TipoNotificaID', FTipoNotificaID);
    LJSon.AddPair('TipoDocumentoID', FTipoDocumentoID);;
    FStream := TStringStream.Create(LJSon.ToJSon());
  finally
    LJSon.Free;
  end;

  result := FStream;
end;

{ TFatturaAttiva }

constructor TFatturaAttiva.Create(const AJSon: TJSonObject);
begin
  inherited Create;
  FID := AJSon.GetValue<String>('FatturaID', '');
  FDataUpload := AJSon.AsDateTime('DataUpload');
  FOrigineID := AJSon.GetValue<Integer>('OrigineID', 0);
  FOrigine := AJSon.GetValue<String>('Origine', '');
  FNomeFile := AJSon.GetValue<String>('NomeFile', '');
  FFirmata := AJSon.GetValue<Boolean>('FlFirmata', False);
  FIdentificativoSDI := AJSon.GetValue<String>('IdentificativoSDI', '');
  FDataOraRicezioneSDI := AJSon.AsDateTime('DataOraRicezioneSDI');
  FConservata := AJSon.GetValue<Boolean>('FlConservata', False);
  FNumeroFattura := AJSon.GetValue<String>('NumeroFattura', '');
  FDataFattura := AJSon.AsDateTime('DataFattura');
  FTipoDocumentoID := AJSon.GetValue<String>('TipoDocumentoID', '');
  FTipoDocumento := AJSon.GetValue<String>('TipoDocumento', '');
  FCliente := AJSon.GetValue<String>('Cliente', '');
  FPartitaIVA := AJSon.GetValue<String>('PartitaIVA', '');
  FCodiceFiscale := AJSon.GetValue<String>('CodiceFiscale', '');
  FImporto := AJSon.GetValue<Double>('Importo', 0);
  FContenutoIDXml := AJSon.GetValue<String>('ContenutoIDXml', '');
  FContenutoIDP7m := AJSon.GetValue<String>('ContenutoIDP7m', '');
  FStato := AJSon.GetValue<String>('Stato', '');
  FInEvidenza := (AJSon.GetValue<Integer>('InEvidenza', 0) <> 0);
  FAllegati := AJSon.GetValue<Integer>('Allegati', 0);
end;

{ TFattureAttiveResponse }

constructor TFattureAttiveResponse.Create;
begin
  inherited Create;
  FFatture := TObjectList<TFatturaAttiva>.Create(True);
end;

destructor TFattureAttiveResponse.Destroy;
begin
  FFatture.Free;
  inherited Destroy;
end;

procedure TFattureAttiveResponse.LoadFromJSon(const AJSon: String);
var
  LJSon, LFattura: TJSonValue;
  LData: TJSonArray;
begin
  FFatture.Clear;
  LJSon := TJSonObject.ParseJSonValue(AJSon);
  if Assigned(LJSon) then
    try
      LData := LJSon.GetValue<TJSonArray>('data', nil);
      if Assigned(LData) then
        for LFattura in LData do
          if LFattura is TJSonObject then
            FFatture.Add(TFatturaAttiva.Create(TJSonObject(LFattura)));
    finally
      LJSon.Free;
    end;
end;

function TFattureAttiveResponse.GetEnumerator: TEnumerator<TFatturaAttiva>;
begin
  result := TEnumerator<TFatturaAttiva>.Create(FFatture);
end;

function TFattureAttiveResponse.GetCount: Integer;
begin
  result := FFatture.Count;
end;

function TFattureAttiveResponse.GetFattura(
  const AIndex: Integer): TFatturaAttiva;
begin
  result := FFatture[AIndex];
end;

{ TNotificheRequest }

constructor TNotificheRequest.Create(const AFatturaID: String);
begin
  inherited Create;
  FFatturaID := AFatturaID;
  FStream := nil;
end;

destructor TNotificheRequest.Destroy;
begin
  if Assigned(FStream) then
    FStream.Free;
  inherited Destroy;
end;

function TNotificheRequest.GetStream: TStream;
var
  LJSon: TJSonObject;
begin
  if not Assigned(FStream) then
  begin
    LJSon := TJSonObject.Create;
    try
      LJSon.AddPair('FatturaID', FFatturaID);
      FStream := TStringStream.Create(LJSon.ToJSon());
    finally
      LJSon.Free;
    end;
  end;

  result := FStream;
end;

{ TNotifica }

constructor TNotifica.Create(const AJSon: TJSonObject);
begin
  inherited Create;
  FID := AJSon.GetValue<String>('ID', '');
  FTipoNotificaID := AJSon.GetValue<String>('TipoNotificaID', '');
  FTipoNotifica := AJSon.GetValue<String>('TipoNotifica', '');
  FIdentificativoSDI := AJSon.GetValue<String>('IdentificativoSDI', '');
  FDataRicezione := AJSon.GetValue<String>('DataRicezione', '');
  FContenutoID := AJSon.GetValue<String>('ContenutoID', '');
  FNomeFile := AJSon.GetValue<String>('NomeFile', '');
end;

{ TNotificheResponse }

constructor TNotificheResponse.Create;
begin
  inherited Create;
  FNotifiche := TObjectList<TNotifica>.Create;
end;

destructor TNotificheResponse.Destroy;
begin
  FNotifiche.Free;
  inherited Destroy;
end;

procedure TNotificheResponse.LoadFromJSon(const AJSon: String);
var
  LJSon, LNotifica: TJSonValue;
begin
  FNotifiche.Clear;

  LJSon := TJSonObject.ParseJSonValue(AJSon);
  if Assigned(LJSon) then
    try
      if LJSon is TJSonArray then
        for LNotifica in TJSonArray(LJSon) do
          if LNotifica is TJSonObject then
            FNotifiche.Add(TNotifica.Create(TJSonObject(LNotifica)));
    finally
      LJSon.Free;
    end;
end;

function TNotificheResponse.GetEnumerator: TEnumerator<TNotifica>;
begin
  result := TEnumerator<TNotifica>.Create(FNotifiche);
end;

function TNotificheResponse.GetCount: Integer;
begin
  result := FNotifiche.Count;
end;

function TNotificheResponse.GetNotifica(const AIndex: Integer): TNotifica;
begin
  result := FNotifiche[AIndex];
end;

{ TFatturaPassiva }

constructor TFatturaPassiva.Create(const AJSon: TJSonObject);
begin
  inherited Create;
  FID := AJSon.GetValue<String>('FatturaID', '');
  FDataRicezione := AJSon.AsDateTime('DataRicezione');
  FDataInserimento := AJSon.AsDateTime('DataInserimento');
  FOrigineID := AJSon.GetValue<Integer>('OrigineID', 0);
  FOrigine := AJSon.GetValue<String>('Origine', '');
  FNomeFile := AJSon.GetValue<String>('NomeFile', '');
  FIdentificativoSDI := AJSon.GetValue<String>('IdentificativoSDI', '');
  FContenutoOriginaleID := AJSon.GetValue<String>('ContenutoOriginaleID', '');
  FContenutoXmlID := AJSon.GetValue<String>('ContenutoXmlID', '');
  FNomeFileMetaDati := AJSon.GetValue<String>('NomeFileMetaDati', '');
  FContenutoMetaDatiID := AJSon.GetValue<String>('ContenutoMetaDatiID', '');
  FConservata := AJSon.GetValue<Boolean>('FlConservata', False);
  FNumeroFattura := AJSon.GetValue<String>('NumeroFattura', '');
  FDataFattura := AJSon.AsDateTime('DataFattura');
  FTipoDocumentoID := AJSon.GetValue<String>('TipoDocumentoID', '');
  FTipoDocumento := AJSon.GetValue<String>('TipoDocumento', '');
  FFornitore := AJSon.GetValue<String>('Fornitore', '');
  FPartitaIVA := AJSon.GetValue<String>('PartitaIVA', '');
  FCodiceFiscale := AJSon.GetValue<String>('CodiceFiscale', '');
  FImporto := AJSon.GetValue<Double>('Importo', 0);
  FAllegati := AJSon.GetValue<Integer>('Allegati', 0);
end;

{ TFatturePassiveResponse }

constructor TFatturePassiveResponse.Create;
begin
  inherited Create;
  FFatture := TObjectList<TFatturaPassiva>.Create;
end;

destructor TFatturePassiveResponse.Destroy;
begin
  FFatture.Free;
  inherited Destroy;
end;

procedure TFatturePassiveResponse.LoadFromJSon(const AJSon: String);
var
  LJSon, LFattura: TJSonValue;
  LData: TJSonArray;
begin
  FFatture.Clear;

  LJSon := TJSonObject.ParseJSonValue(AJSon);
  if Assigned(LJSon) then
    try
      LData := LJSon.GetValue<TJSonArray>('data', nil);
      if Assigned(LData) then
        for LFattura in LData do
          if LFattura is TJSonObject then
            FFatture.Add(TFatturaPassiva.Create(TJSonObject(LFattura)));
    finally
      LJSon.Free;
    end;
end;

function TFatturePassiveResponse.GetEnumerator: TEnumerator<TFatturaPassiva>;
begin
  result := TEnumerator<TFatturaPassiva>.Create(FFatture);
end;

function TFatturePassiveResponse.GetCount: Integer;
begin
  result := FFatture.Count;
end;

function TFatturePassiveResponse.GetFattura(
  const AIndex: Integer): TFatturaPassiva;
begin
  result := FFatture[AIndex];
end;

end.
