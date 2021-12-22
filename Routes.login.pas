unit Routes.login;

interface

uses
  Classes, SysUtils, FMX.Dialogs, FMX.ActnList, System.UITypes
;

procedure login_definition();


implementation

uses
  SubjectStand
, FMXER.Navigator
, FMXER.ScaffoldForm, FMXER.ColumnForm, FMXER.BackgroundForm
, FMXER.ListViewFrame, FMXER.LogoFrame, FMXER.EditFrame, FMXER.ButtonFrame
, Data.Remote, Utils.UI;

procedure login_definition();
begin
  Navigator.DefineRoute<TBackgroundForm>(
    'login'
   , procedure (ABckg: TBackgroundForm)
     begin
       ABckg.Fill.Color := TAlphaColorRec.Silver;
       ABckg.SetContentAsForm<TColumnForm>(
         procedure (AForm: TColumnForm)
         begin
           AForm.AddFrame<TLogoFrame>(
             100, procedure (AFrame: TLogoFrame)
                  begin
                    AFrame.LogoResource := 'LOGO_IMAGE';
                  end);

           AForm.AddFrame<TEditFrame>(
             80, procedure (AFrame: TEditFrame)
                 begin
                   AFrame.FocusOnShow := True;
                   AFrame.Caption := 'Username:';
                   AFrame.OnChangeProc :=
                     procedure (ATracking: Boolean)
                     begin
                       RemoteData.Username := AFrame.Text;
                     end;
                 end);

           AForm.AddFrame<TEditFrame>(
             80, procedure (AFrame: TEditFrame)
                 begin
                   AFrame.Caption := 'Password:';
                   AFrame.Password := True;
                   AFrame.OnChangeProc :=
                     procedure (ATracking: Boolean)
                     begin
                       RemoteData.Password := AFrame.Text;
                     end;
                 end);

           AForm.AddFrame<TButtonFrame>(
             80, procedure (AFrame: TButtonFrame)
                 begin
                   AFrame.Text := 'Login';
                   AFrame.ButtonControl.Width := 200;
                   AFrame.IsDefault := True;

                   AFrame.OnUpdateProc := procedure(AAction: TAction)
                                          begin
                                            AAction.Enabled :=
                                              not (RemoteData.Username.Trim.IsEmpty)
                                              and (not RemoteData.Password.IsEmpty);
                                          end;

                   AFrame.OnClickProc := procedure (AFrame: TButtonFrame)
                                         begin
                                           Navigator.RouteTo('bubbles', True);

                                           RemoteData.Login(
                                             procedure
                                             begin
                                               Navigator.CloseRoute('bubbles', True);

                                               Navigator.StackPop;
                                               Navigator.RouteTo('home');
                                             end
                                           , procedure(AError: string)
                                             begin
                                               Navigator.CloseRoute('bubbles', True);

                                               ShowMessage('Login failed: ' + AError);
                                             end);
                                         end;
                 end);
         end);
     end
   , nil
   , 'lightbox');
end;

end.
