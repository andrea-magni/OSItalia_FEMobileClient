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

          AFrame.ItemAppearance := 'ImageListItemBottomDetail';
          AFrame.AccessoryVisible := False;
          AFrame.SearchVisible := True;

          AFrame.ItemBuilderProc :=
            procedure
            begin
              Navigator.RouteTo('bubbles', True);

              RemoteData.GetFattureInviate(
                procedure (const AResponse: TFattureAttiveResponse)
                begin
                  AForm.Title := Format('%d fatture inviate', [AResponse.Count]);

                  for var LFattura in AResponse do
                  begin
                    var LItem := AFrame.AddItem(
                      LFattura.Cliente + ', Importo: € ' + FormatFloat('#,#0.00', LFattura.Importo)
                    , Format('[%s] Stato: %s ID: %s', [LFattura.IdentificativoSDI, LFattura.Stato, LFattura.ID])
                    , UIUtils.FatturaInviataImageIndex
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
          Navigator.CloseRoute('fatture_inviate');
        end);
    end);
end;

end.
