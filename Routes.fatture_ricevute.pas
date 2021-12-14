unit Routes.fatture_ricevute;

interface

uses
  Classes, SysUtils, UITypes
;

procedure fatture_ricevute_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame
, FMXER.IconFontsData
, Utils.UI, Data.Remote
, OSItalia.FE.Classes
;

procedure fatture_ricevute_definition();
begin
  Navigator.DefineRoute<TScaffoldForm>(
    'fatture_ricevute'
  , procedure(AForm: TScaffoldForm)
    begin
      AForm.Title := 'Fatture ricevute';

      AForm.SetContentAsFrame<TListViewFrame>(
        procedure (AListFrame: TListViewFrame)
        begin
          RemoteData.GetFattureRicevute(
            procedure (const AResponse: TFatturePassiveResponse)
            begin
              for var LFattura in AResponse do
                AListFrame.AddItem(LFattura.Fornitore, UIUtils.FatturaRicevutaImageIndex);

            end
          , procedure (AError: string)
            begin
              AListFrame.ClearItems;
            end
          );
        end
      );

      AForm.AddActionButton(IconFonts.ImageList, UIUtils.BackImageIndex
      , procedure
        begin
          Navigator.StackPop;
        end
      );
    end
  );
end;

end.

