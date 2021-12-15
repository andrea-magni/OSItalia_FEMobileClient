unit Routes.fatture_inviate;

interface

uses
  Classes, SysUtils, UITypes, FMX.Dialogs, FMX.ListView.Appearances
;

procedure fatture_inviate_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame, FMXER.LogoFrame
, FMXER.IconFontsData, FMXER.IconFontsGlyphFrame
, Definitions.FatturaToolbar
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
        procedure (AFrame: TListViewFrame)
        begin
          AddFatturaToolbar(AForm, AFrame);
          RemoteData.FatturaPreviewTipo := 'fattureinviate';

          AFrame.ItemAppearance := 'ImageListItemBottomDetail';
          AFrame.ListView.ItemAppearanceObjects.ItemObjects.Accessory.Visible := False;

          AFrame.ItemBuilderProc :=
            procedure
            begin
              Navigator.RouteTo('bubbles');

              RemoteData.GetFattureInviate(
                procedure (const AResponse: TFattureAttiveResponse)
                begin
                  AForm.Title := Format('%d fatture inviate', [AResponse.Count]);

                  for var LFattura in AResponse do
                  begin
                    var LItem := AFrame.AddItem(LFattura.Cliente
                    , Format('[%s: %s] %.2m', [LFattura.TipoDocumento, LFattura.ID, LFattura.Importo])
                    , UIUtils.FatturaInviataImageIndex
                    , procedure (const AItem: TListViewItem)
                      begin
//                        ShowMessage(AItem.Data['Fattura.ID'].ToString);
                      end);
                    LItem.Data['Fattura.ID'] := LFattura.ID;
                    LItem.Data['Fattura.ContenutoIDXml'] := LFattura.ContenutoIDXml;
                  end;

                  Navigator.CloseRoute('bubbles');
                end
              , procedure (AError: string)
                begin
                  AFrame.ClearItems;
                  Navigator.CloseRoute('bubbles');
                end);

            end;
        end);

      AForm.AddActionButton(IconFonts.ImageList, UIUtils.BackImageIndex
      , procedure
        begin
          Navigator.CloseRoute('fatture_inviate');
        end);
    end);
end;

end.
