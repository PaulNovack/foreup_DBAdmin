unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DataSource1: TDataSource;
    MySQL80Connection1: TMySQL80Connection;
    MySQL80Connection2: TMySQL80Connection;
    SchemaConn: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SchemaQ: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    SchemaTran: TSQLTransaction;
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

end.

