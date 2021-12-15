unit Routes.fatture_ricevute;

interface

uses
  Classes, SysUtils, UITypes, FMX.Dialogs, FMX.ListView.Appearances
;

procedure fatture_ricevute_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.ListViewFrame, FMXER.LogoFrame
, FMXER.IconFontsData
, Definitions.FatturaToolbar
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
        procedure (AFrame: TListViewFrame)
        begin
          AddFatturaToolbar(AForm, AFrame);
          RemoteData.FatturaPreviewTipo := 'fatturericevute';

          AFrame.ItemAppearance := 'ImageListItemBottomDetail';
          AFrame.ListView.ItemAppearanceObjects.ItemObjects.Accessory.Visible := False;

          AFrame.ItemBuilderProc :=
            procedure
            begin
              Navigator.RouteTo('bubbles');

              RemoteData.GetFattureRicevute(
                procedure (const AResponse: TFatturePassiveResponse)
                begin
                  AForm.Title := Format('%d fatture ricevute', [AResponse.Count]);

                  for var LFattura in AResponse do
                  begin
                    var LItem := AFrame.AddItem(LFattura.Fornitore
                    , Format('[%s: %s] %.2m', [LFattura.TipoDocumento, LFattura.ID, LFattura.Importo])
                    , UIUtils.FatturaRicevutaImageIndex
                    , procedure (const AItem: TListViewItem)
                      begin
//                        ShowMessage(AItem.Data['Fattura.ID'].ToString);
                      end);
                    LItem.Data['Fattura.ID'] := LFattura.ID;
                    LItem.Data['Fattura.ContenutoIDXml'] := LFattura.ContenutoXmlID;
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
          Navigator.CloseRoute('fatture_ricevute');
        end);
    end);
end;

end.

