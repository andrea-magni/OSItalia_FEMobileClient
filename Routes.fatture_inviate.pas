unit Routes.fatture_inviate;

interface

uses
  Classes, SysUtils, UITypes, FMX.Dialogs, FMX.ListView.Appearances
;

procedure fatture_inviate_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame, FMXER.LogoFrame
, FMXER.IconFontsData
, Data.Remote, Utils.UI
, OSItalia.FE.Classes
;

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
          AListFrame.ItemAppearance := 'ImageListItemBottomDetail';

          AListFrame.ItemBuilderProc :=
            procedure
            begin
              Navigator.RouteTo('bubbles');

              RemoteData.GetFattureInviate(
                procedure (const AFatture: TFattureAttiveResponse)
                begin
                  for var LFattura in AFatture do
                    AListFrame.AddItem(
                      LFattura.Cliente
                    , Format('[%s: %s] %.2m', [LFattura.TipoDocumento, LFattura.ID, LFattura.Importo])
                    , UIUtils.FatturaInviataImageIndex
                    , procedure (const AItem: TListViewItem)
                      begin
                        ShowMessage(AItem.Data['Fattura.ID'].ToString);
                      end
                    )
                    .Data['Fattura.ID'] := LFattura.ID;

                  Navigator.CloseRoute('bubbles');
                end
              , procedure (AError: string)
                begin
                  AListFrame.ClearItems;
                  Navigator.CloseRoute('bubbles');
                end

              );
            end;
        end
      );

      AForm.SetTitleDetailContentAsFrame<TLogoFrame>(
        procedure (AFrame: TLogoFrame)
        begin

        end
      );

      AForm.AddActionButton(IconFonts.ImageList, UIUtils.BackImageIndex
      , procedure
        begin
          Navigator.CloseRoute('fatture_inviate');
        end
      );

    end
  );
end;

end.
