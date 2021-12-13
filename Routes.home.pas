unit Routes.home;

interface

uses
  Classes, SysUtils
;

procedure home_definition();


implementation

uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame
, Utils.UI;

procedure home_definition();
begin
  Navigator.DefineRoute<TScaffoldForm>(
    'home'
  , procedure(AHome: TScaffoldForm)
    begin
      AHome.Title := 'FE Mobile Client';

      AHome.SetContentAsFrame<TListViewFrame>(
        procedure (AListFrame: TListViewFrame)
        begin
          AListFrame.AddItem('Fatture inviate', UIUtils.FatturaInviataImageIndex
          , procedure
            begin
              Navigator.RouteTo('fatture_inviate');
            end
          );

          AListFrame.AddItem('Fatture ricevute', UIUtils.FatturaRicevutaImageIndex
          , procedure
            begin
              Navigator.RouteTo('fatture_ricevute');
            end
          );
        end
      );
    end
  );
end;

end.
