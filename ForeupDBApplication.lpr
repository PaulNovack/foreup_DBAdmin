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
ProductionServerConfig, DataModule, listtables, loadSqlStatements,
SaveQueryName
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='ForeUp Database Application';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainApplicationForm, MainApplicationForm);
  Application.CreateForm(TDevelopmentServerConfigForm, 
    DevelopmentServerConfigForm);
  Application.CreateForm(TProductionServerConfgForm, ProductionServerConfgForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TListTablesForm, ListTablesForm);
  Application.CreateForm(TListQuerysForm, ListQuerysForm);
  Application.CreateForm(TSaveQueryForm, SaveQueryForm);
  Application.Run;
end.

