unit DataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    TableListDataSource: TDataSource;
    DS1: TDataSource;
    DS10: TDataSource;
    DS2: TDataSource;
    DS3: TDataSource;
    DS4: TDataSource;
    DS5: TDataSource;
    DS6: TDataSource;
    DS7: TDataSource;
    DS8: TDataSource;
    DS9: TDataSource;
    MainConnection: TMySQL80Connection;
    MySQL80Connection2: TMySQL80Connection;
    SQ1: TSQLQuery;
    SQ10: TSQLQuery;
    SQ2: TSQLQuery;
    SQ3: TSQLQuery;
    SQ4: TSQLQuery;
    SQ5: TSQLQuery;
    SQ6: TSQLQuery;
    SQ7: TSQLQuery;
    SQ8: TSQLQuery;
    SQ9: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SchemaQ: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure TableListDataSourceDataChange(Sender: TObject; Field: TField);
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

{ TDataModule1 }

procedure TDataModule1.TableListDataSourceDataChange(Sender: TObject; Field: TField);
begin

end;

end.

