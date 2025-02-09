unit DataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DataSource1: TDataSource;
    DS1: TDataSource;
    MySQL80Connection1: TMySQL80Connection;
    MySQL80Connection2: TMySQL80Connection;
    SchemaConn: TMySQL80Connection;
    SQ1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SchemaQ: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    SchemaTran: TSQLTransaction;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

{ TDataModule1 }

procedure TDataModule1.DataSource1DataChange(Sender: TObject; Field: TField);
begin

end;

end.

