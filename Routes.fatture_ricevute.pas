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

          AFrame.ItemAppearance := 'ImageListItemBottomDetail';
          AFrame.AccessoryVisible := False;
          AFrame.SearchVisible := True;

          AFrame.ItemBuilderProc :=
            procedure
            begin
              Navigator.RouteTo('bubbles', True);

              RemoteData.GetFattureRicevute(
                procedure (const AResponse: TFatturePassiveResponse)
                begin
                  AForm.Title := Format('%d fatture ricevute', [AResponse.Count]);

                  for var LFattura in AResponse do
                  begin
                    var LItem := AFrame.AddItem(
                      LFattura.Fornitore + ', Importo: ? ' + FormatFloat('#,#0.00', LFattura.Importo)
                    , Format('[%s] ID: %s', [LFattura.IdentificativoSDI, LFattura.ID])
                    , UIUtils.FatturaRicevutaImageIndex
                    , procedure (const AItem: TListViewItem)
                      begin
//                        ShowMessage(AItem.Data['Fattura.ID'].ToString);
                      end);
                    LItem.TagObject := LFattura;
                  end;

                  Navigator.CloseRoute('bubbles', True);
                end
              , procedure (AError: string)
                begin
                  AFrame.ClearItems;
                  Navigator.CloseRoute('bubbles', True);
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

