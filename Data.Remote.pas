unit Data.Remote;

interface

uses
  System.SysUtils, System.Classes
, Data.Model
;

type
  TFattureProc = reference to procedure (const AFatture: TFatture);

  TRemoteData = class(TDataModule)
  private
  public
    procedure GetFattureRicevute(const AFattureProc: TFattureProc; const AErrorProc: TProc<string> = nil);
    procedure GetFattureInviate(const AFattureProc: TFattureProc; const AErrorProc: TProc<string> = nil);
  end;

var
  RemoteData: TRemoteData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TRemoteData }

procedure TRemoteData.GetFattureInviate(const AFattureProc: TFattureProc;
  const AErrorProc: TProc<string>);
var
  LDummyInviata: TFattura;
begin
  if Assigned(AFattureProc) then
  begin
    LDummyInviata.Cliente := 'Andrea Magni INV';
    AFattureProc([LDummyInviata]);
  end;

end;

procedure TRemoteData.GetFattureRicevute(const AFattureProc: TFattureProc;
  const AErrorProc: TProc<string>);
var
  LDummyRicevuta: TFattura;
begin
  if Assigned(AFattureProc) then
  begin
    LDummyRicevuta.Cliente := 'Andrea Magni RIC';
    AFattureProc([LDummyRicevuta]);
  end;


end;

end.
