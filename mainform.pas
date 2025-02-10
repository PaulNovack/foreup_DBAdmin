unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls,DB, DBGrids, Buttons, DevServerConfig, ProductionServerConfig,
  DataModule,ListTables,loadSqlStatements,SaveQueryName, fpjson, jsonparser,SQLdb;

type
  // A small record to hold each query's data
  TQueryInfo = record
    QueryName: string;
    SQL: string;
  end;

  { TMainApplicationForm }

  TMainApplicationForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SelectButton: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    LimitCheckBox: TCheckBox;
    LimitNumberComboBox: TComboBox;
    DBGrid1: TDBGrid;
    DBGrid10: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    DBGrid7: TDBGrid;
    DBGrid8: TDBGrid;
    DBGrid9: TDBGrid;
    CourseIdEdit: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo10: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    Memo9: TMemo;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuSaveRepeatable: TMenuItem;
    MenuItem6: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Splitter10: TSplitter;
    Splitter11: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Splitter7: TSplitter;
    Splitter8: TSplitter;
    Splitter9: TSplitter;
    TS1: TTabSheet;
    TS10: TTabSheet;
    TS2: TTabSheet;
    TS3: TTabSheet;
    TS4: TTabSheet;
    TS5: TTabSheet;
    TS6: TTabSheet;
    TS7: TTabSheet;
    TS8: TTabSheet;
    TS9: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuSaveRepeatableClick(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure RemoveLinesStartingWithLimit(AMemo: TMemo);
    procedure ApplyDateTimeDisplayFormats;
    procedure MemoFieldGetText(Sender: TField; var aText: string; DisplayText: Boolean);
    function AddQueryToFile(const AFileName, AQueryName, ASQL: string): Boolean;

  private
    FQueries: array of TQueryInfo;  // Dynamic array to hold all queries
  public

  end;

var
  MainApplicationForm: TMainApplicationForm;

implementation

{$R *.lfm}

{ TMainApplicationForm }

procedure TMainApplicationForm.Button1Click(Sender: TObject);
begin
  DevelopmentServerConfigForm.Show;
end;

procedure TMainApplicationForm.Button2Click(Sender: TObject);
begin
  ProductionServerConfgForm.Show;
end;

procedure TMainApplicationForm.Button3Click(Sender: TObject);
var
  activeTab: Integer;
  myString: String;
  dbGridColumns: Integer;
  Query: String;
  i: Integer;
  thisQ: TSQLQuery;
  thisMemo: TMemo;
  thisDBGrid: TDBGrid;
  SL: TStringList;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  thisQ := TSQLQuery(DataModule1.FindComponent('SQ' + IntToStr(activeTab)));
  thisQ.Active := false;
  thisMemo := TMemo(FindComponent('Memo' + IntToStr(activeTab)));
  thisDbGrid := TDBGrid(FindComponent('DBGrid' + IntToStr(activeTab)));
  MainApplicationForm.RemoveLinesStartingWithLimit(thisMemo);
  if LimitCheckBox.Checked then
  begin
     thisMemo.Text := thisMemo.Text + 'Limit 0,' + LimitNumberComboBox.Text;
  end;
  Query := thisMemo.Text;
  StringReplace(Query, ':courseId', CourseIdEdit.Text,
                                    [rfReplaceAll, rfIgnoreCase]);
  thisQ.SQL.Text := Query;
  try
     thisQ.Active := true;
  except
      on E: Exception do
      begin
        ShowMessage('SQL Error: ' + E.Message);
        Exit;
      end;
  end;

  for i := 0 to thisQ.FieldCount - 1 do
  begin
    if thisQ.Fields[i].DataType in [ftMemo, ftWideMemo] then
    begin
      thisQ.Fields[i].OnGetText := @MemoFieldGetText;
    end;
  end;

  for dbGridColumns := 0 to thisDbGrid.Columns.Count - 1 do
    thisDbGrid.Columns[dbGridColumns].Width := 200;
  ApplyDateTimeDisplayFormats;
  SL := TStringList.Create;
  try
    SL.Text := thisMemo.Text;  // Alternatively, use SL.Assign(Memo1.Lines);
    SL.SaveToFile('queries/Query' + IntToStr(activeTab) + '.sql');
  finally
    SL.Free;
  end;
end;

procedure TMainApplicationForm.MemoFieldGetText(Sender: TField; var aText: string; DisplayText: Boolean);
begin
  aText := Sender.AsString;
end;

procedure TMainApplicationForm.Button4Click(Sender: TObject);
var
  ChildForm : TForm;
  userChoice: TModalResult;
  activeTab: Integer;
  thisMemo: TMemo;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  DataModule.DataModule1.SchemaConn.Connected:= true;
  DataModule.DataModule1.SchemaQ.Active:= true;
  userChoice := ListTablesForm.ShowModal;
  thisMemo := TMemo(FindComponent('Memo' + IntToStr(activeTab)));
  thisMemo.Append(ListTablesForm.DBGrid1.SelectedField.AsString);
end;

procedure TMainApplicationForm.Button9Click(Sender: TObject);
begin

end;

procedure TMainApplicationForm.FormCreate(Sender: TObject);
var
  i: Integer;
  qFilename: string;
  memoControl: TMemo;
begin
  for i := 1 to 10 do
  begin
    qFilename := 'queries/Query' + IntToStr(i) + '.sql';
    if FileExists(qFilename) then
    begin
      memoControl := TMemo(FindComponent('Memo' + IntToStr(i)));
      if Assigned(memoControl) then
      begin
        memoControl.Lines.LoadFromFile(qFilename);
      end
      else
        ShowMessage('Component Memo' + IntToStr(i) + ' not found.');
    end;
  end;
end;

procedure TMainApplicationForm.PageControl1Change(Sender: TObject);
begin

end;

procedure TMainApplicationForm.Panel1Click(Sender: TObject);
begin

end;



procedure TMainApplicationForm.SelectButtonClick(Sender: TObject);
var
  selectString: String;
  activeTab: Integer;
  thisMemo: TMemo;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  selectString := 'Select * from';
  thisMemo := TMemo(FindComponent('Memo' + IntToStr(activeTab)));
  thisMemo.Append(selectString);
end;

procedure TMainApplicationForm.Button6Click(Sender: TObject);
var
  selectString: String;
  activeTab: Integer;
  thisMemo: TMemo;
  whereString: String;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  whereString := 'where course_id = ' + ':courseId';
  thisMemo := TMemo(FindComponent('Memo' + IntToStr(activeTab)));
  thisMemo.Append(whereString);
end;

procedure TMainApplicationForm.Button7Click(Sender: TObject);
var
  dbGridColumns: Integer;
  thisQ : TSQLQuery;
  activeTab: Integer;
  thisDBGrid: TDBGrid;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  thisQ := TSQLQuery(DataModule1.FindComponent('SQ' + IntToStr(activeTab)));
  thisDbGrid := TDBGrid(FindComponent('DBGrid' + IntToStr(activeTab)));
  thisQ.Edit;
  thisQ.Post;
  thisQ.ApplyUpdates(0);
  DataModule1.SQLTransaction1.Commit;
  thisQ.Active:= true;
  for dbGridColumns := 0 to thisDbGrid.Columns.Count - 1 do
    thisDbGrid.Columns[dbGridColumns].Width := 200;
  ApplyDateTimeDisplayFormats;
end;

procedure TMainApplicationForm.Button8Click(Sender: TObject);
var
  activeTab: Integer;
  thisMemo: TMemo;
begin
  activeTab := PageControl1.ActivePageIndex;
  activeTab := activeTab + 1;
  thisMemo := TMemo(FindComponent('Memo' + IntToStr(activeTab)));
  thisMemo.Text := '';
end;

procedure TMainApplicationForm.CheckBox1Change(Sender: TObject);
begin

end;

procedure TMainApplicationForm.MenuItem2Click(Sender: TObject);
begin

end;

procedure TMainApplicationForm.MenuItem3Click(Sender: TObject);
begin
  DevelopmentServerConfigForm.Show;
end;

procedure TMainApplicationForm.MenuItem4Click(Sender: TObject);
begin
  ProductionServerConfgForm.Show;
end;

procedure TMainApplicationForm.MenuSaveRepeatableClick(Sender: TObject);
var
  userChoice: TModalResult;
  return: Boolean;
begin
    SaveQueryForm.Edit1.Text:= '';
    userChoice := SaveQueryForm.ShowModal;
    case userChoice of
      mrOk:
        begin
          if SaveQueryForm.Edit1.Text <> '' then
            begin
              MainApplicationForm.AddQueryToFile('repeatable/queries.json',SaveQueryForm.Edit1.Text,MainApplicationForm.Memo1.Text);
            end
        end;
    end;
end;

procedure TMainApplicationForm.MenuItem6Click(Sender: TObject);
var
  userChoice: TModalResult;
begin
    userChoice := ListQuerysForm.ShowModal;
    case userChoice of
      mrOk:
        begin
          MainApplicationForm.Memo1.Text := ListQuerysForm.Memo1.Text;
        end;
    end;
end;

procedure TMainApplicationForm.RemoveLinesStartingWithLimit(AMemo: TMemo);
var
  i: Integer;
  TempList: TStringList;
  CurrentLine: string;
begin
  TempList := TStringList.Create;
  try
    for i := 0 to AMemo.Lines.Count - 1 do
    begin
      CurrentLine := AMemo.Lines[i];
      if Copy(CurrentLine, 1, 5) <> 'Limit' then
      begin
        TempList.Add(CurrentLine);
      end;
    end;
    AMemo.Lines.Assign(TempList);
  finally
    TempList.Free;
  end;
end;

function TMainApplicationForm.AddQueryToFile(
  const AFileName, AQueryName, ASQL: string
): Boolean;
var
  JSONData: TJSONData;
  JSONArray: TJSONArray;
  NEWJSONArray: TJSONArray;
  JSONObject: TJSONObject;
  JSONParser: TJSONParser;
  fs: TFileStream;
  fquerysIdx: Integer;
  jsonIdx: Integer;
  inserted: Boolean;
  queryName: String;
  SL: TStringList;
begin
  inserted := false;
  if not FileExists(AFileName) then
  begin
    ShowMessage('File not found: ' + AFileName);
    Exit;
  end;

  fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);

    JSONParser := TJSONParser.Create(fs);
    try
      JSONData := JSONParser.Parse;
      try
        if not (JSONData is TJSONArray) then
        begin
          ShowMessage('Invalid JSON format: expected an array.');
          Exit;
        end;

        JSONArray := TJSONArray(JSONData);
        SetLength(FQueries, JSONArray.Count + 1);
        fquerysIdx := 0;
        jsonIdx := 0;
        while  fquerysIdx < JSONArray.Count do
        begin
          JSONObject := JSONArray.Objects[jsonIdx];
          queryName := JSONObject.Get('QueryName', '');
          if (CompareText(AQueryName, queryName) < 0) and (Inserted = false) then
          begin
            FQueries[fquerysIdx].QueryName := AQueryName;
            FQueries[fquerysIdx].SQL := ASQL;
            Inserted := true;
            fquerysIdx := fquerysIdx + 1;
          end
          else
          begin
            FQueries[fquerysIdx].QueryName := JSONObject.Get('QueryName', '');
            FQueries[fquerysIdx].SQL := JSONObject.Get('SQL', '');
            fquerysIdx := fquerysIdx + 1;
            jsonIdx := jsonIdx + 1;
          end;
        end;
        if not Inserted then
        begin
          FQueries[fquerysIdx].QueryName := AQueryName;
          FQueries[fquerysIdx].SQL := ASQL;
        end;
      finally
        JSONData.Free;
      end;
      NEWJSONArray := TJSONArray.Create;
      for fquerysIdx := 0 to High(FQueries) do
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.Add('QueryName', FQueries[fquerysIdx].QueryName);
        JSONObject.Add('SQL', FQueries[fquerysIdx].SQL);
        NEWJSONARRAY.Add(JSONObject);
      end;
      fs.Free;
      SL := TStringList.Create;
      try
        SL.Text := NEWJSONARRAY.FormatJSON();
        SL.SaveToFile(AFileName);
        Result := True;
      finally
        SL.Free;
      end;
    finally
      JSONParser.Free;
      NEWJSONARRAY.Free;
    end;
end;

procedure TMainApplicationForm.ApplyDateTimeDisplayFormats;
var
  i, j: Integer;
  ADBGrid: TDBGrid;
  AField: TField;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Components[i] is TDBGrid then
    begin
      ADBGrid := TDBGrid(Components[i]);
      for j := 0 to ADBGrid.Columns.Count - 1 do
      begin
        AField := ADBGrid.Columns[j].Field;
        if Assigned(AField) then
        begin
          if (AField is TDateTimeField) then
          begin
            TDateTimeField(AField).DisplayFormat := 'yyyy-mm-dd hh:nn:ss';
            ADBGrid.Columns[j].Width := 140;
          end;
          if (AField is TLargeintField) then
          begin
            ADBGrid.Columns[j].Width := 60;
          end;
          if (AField is TLongintField) then
          begin
            ADBGrid.Columns[j].Width := 70;
          end;
        end;
      end;
    end;
  end;
end;


end.

