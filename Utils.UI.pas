unit Utils.UI;

interface

uses
  Classes, SysUtils, UITypes, FMX.Graphics, IOUtils;

type
  TUIUtils = class
  private
    class var _Instance: TUIUtils;
  protected
    class function GetInstance: TUIUtils; static;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class property Instance: TUIUtils read GetInstance;
    class destructor ClassDestroy;
  private
    FFatturaInviataImageIndex: Integer;
    FFatturaRicevutaImageIndex: Integer;
    FBackImageIndex: Integer;
    function GetFatturaInviataImageIndex: Integer;
    function GetFatturaRicevutaImageIndex: Integer;
    function GetBackImageIndex: Integer;
  public
    property FatturaRicevutaImageIndex: Integer read GetFatturaRicevutaImageIndex;
    property FatturaInviataImageIndex: Integer read GetFatturaInviataImageIndex;
    property BackImageIndex: Integer read GetBackImageIndex;
  end;

  function UIUtils: TUIUtils;

implementation

uses
  FMXER.IconFontsData, System.Types
;


function UIUtils: TUIUtils;
begin
  Result := TUIUtils.Instance;
end;

{ TUIUtils }

class destructor TUIUtils.ClassDestroy;
begin
  if Assigned(_Instance) then
    FreeAndNil(_Instance);
end;

constructor TUIUtils.Create;
begin
  inherited Create;
  FFatturaInviataImageIndex := -1;
  FFatturaRicevutaImageIndex := -1;
  FBackImageIndex := -1;
end;

destructor TUIUtils.Destroy;
begin
  inherited;
end;

function TUIUtils.GetBackImageIndex: Integer;
begin
  if FBackImageIndex = -1 then
    FBackImageIndex := IconFonts.AddIcon(IconFonts.MD.arrow_left, TAlphaColorRec.Black);
  Result := FBackImageIndex;
end;

function TUIUtils.GetFatturaInviataImageIndex: Integer;
begin
  if FFatturaInviataImageIndex = -1 then
    FFatturaInviataImageIndex := IconFonts.AddIcon(IconFonts.MD.inbox_arrow_up, TAlphaColorRec.Green);
  Result := FFatturaInviataImageIndex;
end;

function TUIUtils.GetFatturaRicevutaImageIndex: Integer;
begin
  if FFatturaRicevutaImageIndex = -1 then
    FFatturaRicevutaImageIndex := IconFonts.AddIcon(IconFonts.MD.inbox_arrow_down, TAlphaColorRec.Red);
  Result := FFatturaRicevutaImageIndex;
end;

class function TUIUtils.GetInstance: TUIUtils;
begin
  if not Assigned(_Instance) then
    _Instance := TUIUtils.Create;
  Result := _Instance;
end;

end.
