program ForeupDBApplication;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, MainForm, DevServerConfig, 
ProductionServerConfig, DataModule, listtables, loadSqlStatements;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='ForeUp Database Application';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainApplicationForm, MainApplicationForm);
  Application.CreateForm(TDevelopmentServerConfigForm, 
    DevelopmentServerConfigForm);
  Application.CreateForm(TProductionServerConfigForm, ProductionServerConfigForm
    );
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TListTablesForm, ListTablesForm);
  Application.CreateForm(TListQuerysForm, ListQuerysForm);
  Application.Run;
end.

