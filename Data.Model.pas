unit Data.Model;

interface

uses
  Classes, SysUtils, Generics.Collections;

type
  TFattura = record
    FatturaID: string;
    DataFattura: string;
    IdentificativoSDI: string;
    Cliente: string;
  end;

  TFatture = TArray<TFattura>;

implementation

end.
