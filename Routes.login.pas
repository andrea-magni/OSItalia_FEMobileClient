unit Routes.login;

interface

uses
  Classes, SysUtils
;

procedure login_definition();


implementation

uses
  FMX.Dialogs
, FMXER.Navigator
, FMXER.ScaffoldForm, FMXER.ColumnForm
, FMXER.ListViewFrame, FMXER.LogoFrame, FMXER.EditFrame, FMXER.ButtonFrame
, Data.Remote, Utils.UI, FMX.ActnList;

procedure login_definition();
begin
  Navigator.DefineRoute<TColumnForm>( // route definition
     'login'
   , procedure (AForm: TColumnForm)
     begin
       AForm.AddFrame<TLogoFrame>(100);

       AForm.AddFrame<TEditFrame>(80
         , procedure (AFrame: TEditFrame)
           begin
             AFrame.Caption := 'Username:';
             AFrame.OnChangeProc :=
               procedure (ATracking: Boolean)
               begin
                 RemoteData.Username := AFrame.Text;
               end;
           end
       );
       AForm.AddFrame<TEditFrame>(80
         , procedure (AFrame: TEditFrame)
           begin
             AFrame.Caption := 'Password:';
             AFrame.Password := True;
             AFrame.OnChangeProc :=
               procedure (ATracking: Boolean)
               begin
                 RemoteData.Password := AFrame.Text;
               end;
           end
       );

       AForm.AddFrame<TButtonFrame>(80
         , procedure (AFrame: TButtonFrame)
           begin
             AFrame.Text := 'Login';
             AFrame.ButtonControl.Width := 200;
             AFrame.IsDefault := True;

             AFrame.OnUpdateProc :=
               procedure(AAction: TAction)
               begin
                 AAction.Enabled := not (RemoteData.Username.Trim.IsEmpty)
                   and (not RemoteData.Password.IsEmpty);
               end;

             AFrame.OnClickProc :=
               procedure (AFrame: TButtonFrame)
               begin
                 RemoteData.Login(
                   procedure
                   begin
                     Navigator.StackPop;
                     Navigator.RouteTo('home');
                   end
                 , procedure(AError: string)
                   begin
                     ShowMessage('Login failed: ' + AError);
                   end
                 );
               end;
           end
       );
     end
   );
end;

end.
