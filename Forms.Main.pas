unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SubjectStand,
  FormStand, FMX.Ani, FMX.Objects, FMX.Platform, FMX.VirtualKeyboard, StrUtils;

type
  TMainForm = class(TForm)
    MainFormStand: TFormStand;
    Stands: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    FVirtualKeyboardService : IFMXVirtualKeyboardService;
  public
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
, Routes.fattura_preview
, Routes.change_password;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Before closing the app, close all routes (to avoid memory leaks)
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
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService
    , FVirtualKeyboardService);

  Navigator(MainFormStand); // FMXER Initialization

  // Routes definitions
  bubbles_definition;
  home_definition;
  login_definition;
  change_password_definition;
  fatture_inviate_definition;
  fatture_ricevute_definition;
  fattura_preview_definition;

  // UI consts
//  TAppColors.PrimaryColor := TAppColors.MATERIAL_TEAL_400;

  // Start app
  Navigator.RouteTo('login');
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = vkHardwareBack) {$IFDEF MSWINDOWS}or (Key = vkEscape){$ENDIF} then
  begin
    if Assigned(FVirtualKeyboardService) and (TVirtualKeyboardState.Visible in FVirtualKeyboardService.VirtualKeyBoardState) then
    begin
      // Back button pressed, keyboard visible, so do nothing...
    end else
    begin
      var LPeek := Navigator.Stack.Peek;
      if (Navigator.Stack.Count > 0) and (IndexStr(LPeek, ['home', 'login']) = -1) then
        Navigator.StackPop;
      Key := 0;
    end;
  end
end;

end.
