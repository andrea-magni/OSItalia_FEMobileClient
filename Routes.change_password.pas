unit Routes.change_password;

interface

uses
  Classes, SysUtils, FMX.Dialogs
;

procedure change_password_definition();


implementation

uses
  SubjectStand
, FMXER.Navigator
, FMXER.ScaffoldForm, FMXER.ColumnForm, FMXER.BackgroundForm
, FMXER.ListViewFrame, FMXER.LogoFrame, FMXER.EditFrame, FMXER.ButtonFrame
, Data.Remote, Utils.UI, FMX.ActnList;

procedure change_password_definition();
begin
  Navigator.DefineRoute<TBackgroundForm>(
    'change_password'
  , procedure (AForm: TBackgroundForm)
    begin
      AForm.SetContentAsForm<TColumnForm>(
        procedure (AColumn: TColumnForm)
        begin
          AColumn.AddFrame<TEditFrame>(
            80, procedure (AFrame: TEditFrame)
                begin
                  AFrame.FocusOnShow := True;
                  AFrame.Caption := 'Vecchia password:';
                  AFrame.Password := True;
                  AFrame.OnChangeProc :=
                    procedure (ATracking: Boolean)
                    begin
                      RemoteData.OldPassword := AFrame.Text;
                    end;
                end);

          AColumn.AddFrame<TEditFrame>(
            80, procedure (AFrame: TEditFrame)
                begin
                  AFrame.Caption := 'Nuova password:';
                  AFrame.Password := True;
                  AFrame.OnChangeProc :=
                    procedure (ATracking: Boolean)
                    begin
                      RemoteData.NewPassword := AFrame.Text;
                    end;
                end);

          AColumn.AddFrame<TButtonFrame>(
            80, procedure (AFrame: TButtonFrame)
                begin
                  AFrame.Text := 'Cambia';
                  AFrame.ButtonControl.Width := 200;
                  AFrame.IsDefault := True;

                  AFrame.OnUpdateProc := procedure(AAction: TAction)
                                         begin
                                           AAction.Enabled :=
                                             (not RemoteData.OldPassword.Trim.IsEmpty)
                                             and (not RemoteData.NewPassword.Trim.IsEmpty);
                                         end;

                  AFrame.OnClickProc := procedure (AFrame: TButtonFrame)
                                        begin
                                          Navigator.RouteTo('bubbles', True);

                                          RemoteData.CambiaPassword(
                                            procedure
                                            begin
                                              Navigator.CloseRoute('bubbles', True);

                                              Navigator.StackPop;
                                              Navigator.RouteTo('home');
                                            end
                                          , procedure(AError: string)
                                            begin
                                              Navigator.CloseRoute('bubbles', True);

                                              ShowMessage('Cambio password failed: ' + AError);
                                            end);
                                        end;
                end);
        end);
    end
  , nil
  , 'lightbox');
end;

end.
