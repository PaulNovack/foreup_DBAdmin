unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls, DBGrids, Buttons, DevServerConfig, ProductionServerConfig,
  DataModule,listtables,loadSqlStatements,SaveQueryName, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SelectButton: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
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
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
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
    procedure Memo1Change(Sender: TObject);
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
    function AddQueryToFile(const AFileName, AQueryName, ASQL: string) : Boolean;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  activeTab: Integer;
  myString: String;
  dbGridColumns: Integer;
begin
  DataModule1.SQLQuery1.Active := false;
  activeTab := PageControl1.ActivePageIndex;
  Form1.RemoveLinesStartingWithLimit(Memo1);
  if LimitCheckBox.Checked then
  begin
     Memo1.Text := Memo1.Text + 'Limit 0,' + LimitNumberComboBox.Text;
  end;
  DataModule1.SQLQuery1.SQL.Text := Memo1.Text;
  DataModule1.SQLQuery1.Active := true;
  for dbGridColumns := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[dbGridColumns].Width := 200;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ChildForm : TForm;
begin
     DataModule.DataModule1.SchemaConn.Connected:= true;
     DataModule.DataModule1.SchemaQ.Active:= true;
     Form4.Show;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.SelectButtonClick(Sender: TObject);
var
  selectString: String;
begin
  selectString := 'Select * from';
  Memo1.Append(selectString);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  whereString: String;
begin
  whereString := 'where course_id = ' + CourseIdEdit.Text;
  Memo1.Append(whereString);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  dbGridColumns: Integer;
begin
  DataModule1.SQLQuery1.Edit;
  DataModule1.SQLQuery1.Post;
  DataModule1.SQLQuery1.ApplyUpdates(0);
  DataModule1.SQLTransaction1.Commit;
  DataModule1.SQLQuery1.Active:= true;
  for dbGridColumns := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[dbGridColumns].Width := 200;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Memo1.Text := '';
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var
  userChoice: TModalResult;
  return: Boolean;
begin
    userChoice := SaveQueryForm.ShowModal;  // This line blocks until Form2 is closed
    case userChoice of
      mrOk:
        //ShowMessage('User clicked OK. Proceed with saving...');
        ShowMessage(SaveQueryForm.Edit1.Text);
        Form1.AddQueryToFile('queries.json',SaveQueryForm.Edit1.Text,Form1.Memo1.Text);
    end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
var
  userChoice: TModalResult;
begin
    userChoice := ListQuerysForm.ShowModal;  // This line blocks until Form2 is closed
    case userChoice of
      mrOk:
        ShowMessage('User clicked OK. Proceed with saving...');
      mrCancel:
        ShowMessage('User clicked Cancel. Abort changes...');
    end;
end;

procedure TForm1.RemoveLinesStartingWithLimit(AMemo: TMemo);
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


function TForm1.AddQueryToFile(const AFileName, AQueryName, ASQL: string): Boolean;
var
  fs: TFileStream;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  JSONParser: TJSONParser;
  JSONData: TJSONData;
  SL: TStringList;
begin
  Result := False;  // default to failure

  // If the file does not exist, create a fresh JSON array
  if not FileExists(AFileName) then
  begin
    JSONArray := TJSONArray.Create;
  end
  else
  begin
    // File exists, parse it
    try
      fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
      try
        JSONParser := TJSONParser.Create(fs);
        try
          JSONData := JSONParser.Parse;
          if (JSONData is TJSONArray) then
            JSONArray := TJSONArray(JSONData.Clone)  // clone so we can free original
          else
          begin
            // If it's not an array, we consider it invalid or handle differently
            JSONArray := TJSONArray.Create;
          end;
        finally
          JSONData.Free;
          JSONParser.Free;
        end;
      finally
        fs.Free;
      end;
    except
      // If any error occurs, fall back to an empty array
      JSONArray := TJSONArray.Create;
    end;
  end;

  try
    // Create a new JSON object for the new query
    JSONObject := TJSONObject.Create;
    JSONObject.Add('QueryName', AQueryName);
    JSONObject.Add('SQL', ASQL);

    // Add it to the array
    JSONArray.Add(JSONObject);

    // Write back to file
    SL := TStringList.Create;
    try
      SL.Text := JSONArray.FormatJSON();
      SL.SaveToFile(AFileName);
      Result := True;  // success
    finally
      SL.Free;
    end;
  finally
    JSONArray.Free;
  end;
end;



end.

