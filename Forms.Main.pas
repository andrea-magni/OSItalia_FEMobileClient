unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SubjectStand,
  FormStand, FMX.Ani, FMX.Objects;

type
  TMainForm = class(TForm)
    MainFormStand: TFormStand;
    Stands: TStyleBook;
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
, Routes.login
, Routes.fatture_inviate
, Routes.fatture_ricevute
, Routes.bubbles
, Routes.fattura_preview;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Navigator.ActiveRoutes.Count > 0 then
  begin
    Action := TCloseAction.caNone;
    Navigator.OnCloseRoute :=
      procedure (ARoute: string)
      begin
        if Navigator.ActiveRoutes.Count = 0 then
          Close;
      end;
    Navigator.CloseAllRoutes();
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Navigator(MainFormStand);

  bubbles_definition;
  home_definition;
  login_definition;
  fatture_inviate_definition;
  fatture_ricevute_definition;
  fattura_preview_definition;

  Navigator.RouteTo('login');
end;

end.
