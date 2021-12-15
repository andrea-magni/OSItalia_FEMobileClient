unit Routes.bubbles;

interface
uses
  Classes, SysUtils, FMX.Dialogs
;

procedure bubbles_definition();


implementation

uses
  SubjectStand
, FMXER.Navigator
, FMXER.ContainerForm, FMXER.ActivityBubblesFrame
, Utils.UI;

procedure bubbles_definition();
begin
  Navigator.DefineRoute<TContainerForm>(
    'bubbles'
  , procedure (AForm: TContainerForm)
    begin
      AForm.SetContentAsFrame<TActivityBubblesFrame>();
    end);
end;


end.
