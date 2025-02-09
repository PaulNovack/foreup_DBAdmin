unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls,DB, DBGrids, Buttons, DevServerConfig, ProductionServerConfig,
  DataModule,listtables,loadSqlStatements,SaveQueryName, fpjson, jsonparser,SQLdb;

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
    MenuItem5: TMenuItem;
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
    procedure MenuItem5Click(Sender: TObject);
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
    begin
      on E: Exception do
      begin
        // Handle the error here. For example, show a message:
        ShowMessage('SQL Error: ' + E.Message);
        // Optionally, perform additional logging or cleanup here.
      end;
      Exit;
    end;
  end;


  for i := 0 to thisQ.FieldCount - 1 do
  begin
    if thisQ.Fields[i].DataType in [ftMemo, ftWideMemo] then
    begin
      // We define a single method that all memo fields share
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
  aText := Sender.AsString;  // So that the grid shows the real text, not "(Memo)"
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
begin

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

procedure TMainApplicationForm.MenuItem5Click(Sender: TObject);
var
  userChoice: TModalResult;
  return: Boolean;
begin
    SaveQueryForm.Edit1.Text:= '';
    userChoice := SaveQueryForm.ShowModal;  // This line blocks until Form2 is closed
    case userChoice of
      mrOk:
        begin
          if SaveQueryForm.Edit1.Text <> '' then
            begin
              MainApplicationForm.AddQueryToFile('queries/queries.json',SaveQueryForm.Edit1.Text,MainApplicationForm.Memo1.Text);
            end
        end;
    end;
end;

procedure TMainApplicationForm.MenuItem6Click(Sender: TObject);
var
  userChoice: TModalResult;
begin
    userChoice := ListQuerysForm.ShowModal;  // This line blocks until Form2 is closed
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

      // Check if the line starts with "Limit"
      // (case-sensitive; if you need case-insensitive use StrUtils.StartsText)
      if Copy(CurrentLine, 1, 5) <> 'Limit' then
      begin
        TempList.Add(CurrentLine);
      end;
      // else we skip adding it (thus removing lines that start with "Limit")
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
  i: Integer;
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
        // Expect an array of objects
        if not (JSONData is TJSONArray) then
        begin
          ShowMessage('Invalid JSON format: expected an array.');
          Exit;
        end;

        JSONArray := TJSONArray(JSONData);
        SetLength(FQueries, JSONArray.Count + 1);
        i := 0;
        while  i < JSONArray.Count do
        begin
          JSONObject := JSONArray.Objects[i];
          queryName := JSONObject.Get('QueryName', '');
          if (CompareText(AQueryName, queryName) < 0) and (Inserted = false) then
          begin
            FQueries[i].QueryName := AQueryName;
            FQueries[i].SQL := ASQL;
            Inserted := true;
            i := i + 1;
          end;
          FQueries[i].QueryName := JSONObject.Get('QueryName', '');
          FQueries[i].SQL := JSONObject.Get('SQL', '');
          i := i + 1;
        end;
        // If the new query was not inserted, add it at the end
        if not Inserted then
        begin
          FQueries[i].QueryName := AQueryName;
          FQueries[i].SQL := ASQL;
        end;
      finally
        JSONData.Free;
      end;
      // Convert FQueries back to a TJSONArray
      NEWJSONArray := TJSONArray.Create;
      for i := 0 to High(FQueries) do
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.Add('QueryName', FQueries[i].QueryName);
        JSONObject.Add('SQL', FQueries[i].SQL);
        NEWJSONARRAY.Add(JSONObject);
      end;
      fs.Free;
      // Write the JSONArray back to the file
      SL := TStringList.Create;
      try
        SL.Text := NEWJSONARRAY.FormatJSON();
        SL.SaveToFile(AFileName);
        Result := True; // Success
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
  // Loop over every component in the form
  for i := 0 to Self.ComponentCount - 1 do
  begin
    // Check if the component is a TDBGrid
    if Components[i] is TDBGrid then
    begin
      ADBGrid := TDBGrid(Components[i]);

      // Iterate over each column in the grid
      for j := 0 to ADBGrid.Columns.Count - 1 do
      begin
        AField := ADBGrid.Columns[j].Field;
        if Assigned(AField) then
        begin
          // Check if the field is a date/time type
          // Typical classes: TDateTimeField, TSQLTimeStampField, TDateField, TTimeField
          if (AField is TDateTimeField) then
          begin
            // Cast and set the display format
            TDateTimeField(AField).DisplayFormat := 'yyyy-mm-dd hh:nn:ss';
            ADBGrid.Columns[j].Width := 140;
          end;
          if (AField is TLargeintField) then
          begin
            // Cast and set the display format
            ADBGrid.Columns[j].Width := 60;
          end;
          if (AField is TLongintField) then
          begin
            // Cast and set the display format
            ADBGrid.Columns[j].Width := 70;
          end;
        end;
      end;
    end;
  end;
end;


end.

