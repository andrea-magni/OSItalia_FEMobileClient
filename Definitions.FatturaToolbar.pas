unit Definitions.FatturaToolbar;

interface

uses
  Classes, SysUtils, FMX.Types, FMX.Dialogs
, FMXER.Navigator
, FMXER.ScaffoldForm, FMXER.RowForm, FMXER.ListViewFrame
, FMXER.IconFontsData, FMXER.IconFontsGlyphFrame
, Data.Remote, Utils.UI
;

procedure AddFatturaToolbar(AForm: TScaffoldForm; AListFrame: TListViewFrame);

implementation

procedure AddFatturaToolbar(AForm: TScaffoldForm; AListFrame: TListViewFrame);
begin
  AForm.SetTitleDetailContentAsForm<TRowForm>(
    procedure(AForm: TRowForm)
    begin
      AForm.ElementAlign := TAlignLayout.Right;

      AForm.AddFrame<TIconFontsGlyphFrame>(64
      , procedure(AGlyphFrame: TIconFontsGlyphFrame)
        begin
          AGlyphFrame.ImageIndex := UIUtils.FatturaPreviewImageIndex;
          AGlyphFrame.OnClickProc :=
            procedure
            begin
              if Assigned(AListFrame.SelectedItem) then
              begin
                RemoteData.FatturaSelezionata := AListFrame.SelectedItem.TagObject;

                Navigator.RouteTo('fattura_preview');
              end;
            end;
        end
      );

    end
  );
end;

end.
