unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SubjectStand,
  FormStand;

type
  TMainForm = class(TForm)
    MainFormStand: TFormStand;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  FMXER.UI.Consts, FMXER.UI.Misc, FMXER.Navigator
, FMXER.ScaffoldForm, FMXER.ContainerForm
, Routes.home
, Routes.fatture_inviate
, Routes.fatture_ricevute
;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Navigator.ActiveRoutes.Count > 0 then
  begin
    Action := TCloseAction.caNone;
    Navigator.OnCloseRoute := procedure (ARoute: string) begin if ARoute = 'home' then Close; end;
    Navigator.CloseAllRoutes();
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Navigator(MainFormStand);

  home_definition;
  fatture_inviate_definition;
  fatture_ricevute_definition;

  Navigator.RouteTo('home');
end;

end.
