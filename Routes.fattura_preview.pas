unit Routes.fattura_preview;

interface

uses
  Classes, SysUtils, UITypes, FMX.Dialogs, FMX.ListView.Appearances, FMX.Types
;

procedure fattura_preview_definition();

implementation


uses
  FMXER.Navigator, FMXER.ScaffoldForm, FMXER.WebViewFrame, FMXER.RowForm
, FMXER.IconFontsData, FMXER.IconFontsGlyphFrame
, Data.Remote, Utils.UI
, OSItalia.FE.Classes
;

procedure fattura_preview_definition();
begin
  Navigator.DefineRoute<TScaffoldForm>(
    'fattura_preview'
  , procedure(AForm: TScaffoldForm)
    begin
      AForm.Title := 'Anteprima HTML fattura';

      AForm.SetContentAsFrame<TWebViewFrame>(
        procedure (AWebView: TWebViewFrame)
        begin
          try
            AWebView.URL := RemoteData.GetFatturaPreviewURL();
          except on E:Exception do
            AForm.ShowSnackBar(E.ToString, 3000);
          end;
        end
      );

      AForm.SetTitleDetailContentAsForm<TRowForm>(
        procedure(AForm: TRowForm)
        begin
          AForm.ElementAlign := TAlignLayout.Right;

          AForm.AddFrame<TIconFontsGlyphFrame>(64
          , procedure(AGlyphFrame: TIconFontsGlyphFrame)
            begin
              AGlyphFrame.ImageIndex := UIUtils.BackImageIndex;
              AGlyphFrame.OnClickProc :=
                procedure
                begin
                  Navigator.CloseRoute('fattura_preview');
                end;
            end
          );

        end
      );
    end
  );
end;

end.
