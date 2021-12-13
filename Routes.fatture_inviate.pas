unit Routes.fatture_inviate;

interface

uses
  Classes, SysUtils, UITypes
;

procedure fatture_inviate_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame
, FMXER.IconFontsData
, Data.Remote, Data.Model, Utils.UI;

procedure fatture_inviate_definition();
begin
  Navigator.DefineRoute<TScaffoldForm>(
    'fatture_inviate'
  , procedure(AForm: TScaffoldForm)
    begin
      AForm.Title := 'Fatture inviate';

      AForm.SetContentAsFrame<TListViewFrame>(
        procedure (AListFrame: TListViewFrame)
        begin
          RemoteData.GetFattureInviate(
            procedure (const AFatture: TFatture)
            begin
              for var LFattura in AFatture do
                AListFrame.AddItem(LFattura.Cliente, UIUtils.FatturaInviataImageIndex);

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
