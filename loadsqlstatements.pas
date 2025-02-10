unit loadSqlStatements;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fpjson, jsonparser;

type
  // A small record to hold each query's data
  TQueryInfo = record
    QueryName: string;
    SQL: string;
  end;

  { TfrmQuerySelect }

  { TListQuerysForm }

  TListQuerysForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FQueries: array of TQueryInfo;
    queriesFilename: String;
    procedure LoadQueriesFromJSON(const AFileName: string);
    procedure PopulateComboBox;
  public

  end;

var
  ListQuerysForm: TListQuerysForm;

implementation

{$R *.lfm}

{ TfrmQuerySelect }

procedure TListQuerysForm.FormCreate(Sender: TObject);
begin
  queriesFilename := 'repeatable/queries.json';
  LoadQueriesFromJSON(queriesFilename);
  PopulateComboBox;
end;

procedure TListQuerysForm.FormShow(Sender: TObject);
begin
  LoadQueriesFromJSON(queriesFilename);
  PopulateComboBox;
end;

procedure TListQuerysForm.ComboBox1Change(Sender: TObject);
  var
    idx: Integer;
  begin
    idx := ComboBox1.ItemIndex;
    if (idx >= 0) and (idx < Length(FQueries)) then
      Memo1.Text := FQueries[idx].SQL
    else
      Memo1.Clear;
end;

procedure TListQuerysForm.Button1Click(Sender: TObject);
begin

end;

procedure TListQuerysForm.Button2Click(Sender: TObject);
begin

end;

procedure TListQuerysForm.Button3Click(Sender: TObject);
  var
    JSONData: TJSONData;
    JSONArray: TJSONArray;
    NEWJSONArray: TJSONArray;
    JSONObject: TJSONObject;
    JSONParser: TJSONParser;
    fs: TFileStream;
    i: Integer;
    jindex: Integer;
    selectedIndex: Integer;
    AFileName: string;
    SL: TStringList;
  begin
    AFileName := queriesFilename;
    selectedIndex := ComboBox1.ItemIndex;
    if not FileExists(AFileName) then
    begin
      ShowMessage('File not found: ' + AFileName);
      Exit;
    end;
    if ComboBox1.Items.Count = 0 then
    begin
       ShowMessage('Nothing to delete');
       Exit;
    end;

    fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
    try
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
            // Resize dynamic array to match the number of items
            SetLength(FQueries, JSONArray.Count - 1);
            i := 0;
            jindex := 0;
            while i < JSONArray.Count - 1 do
            begin
              if jindex <> selectedIndex then
              begin
                JSONObject := JSONArray.Objects[jindex];
                FQueries[i].QueryName := JSONObject.Get('QueryName', '');
                FQueries[i].SQL := JSONObject.Get('SQL', '');
                i := i + 1;
              end;
              jindex := jindex + 1;
            end;

          finally
            JSONData.Free;
          end;
      finally
        JSONParser.Free;
      end;
    finally
      fs.free;
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
    // Write the JSONArray back to the file
    SL := TStringList.Create;
    SL.Text := NEWJSONARRAY.FormatJSON();
    SL.SaveToFile(AFileName);
    LoadQueriesFromJSON(queriesFilename);
    PopulateComboBox;
end;

procedure TListQuerysForm.LoadQueriesFromJSON(const AFileName: string);
var
  JSONData: TJSONData;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  JSONParser: TJSONParser;
  fs: TFileStream;
  i: Integer;
  FileContent: TStringList;
begin
  if not FileExists(AFileName) then
  begin
    FileContent := TStringList.Create;
    try
      FileContent.Add('[]');
      FileContent.SaveToFile(queriesFilename);
    finally
      FileContent.Free;
    end;
  end;

  fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
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
        SetLength(FQueries, JSONArray.Count);

        for i := 0 to JSONArray.Count - 1 do
        begin
          JSONObject := JSONArray.Objects[i];
          FQueries[i].QueryName := JSONObject.Get('QueryName', '');
          FQueries[i].SQL := JSONObject.Get('SQL', '');
        end;
      finally
        JSONData.Free;
      end;
    finally
      JSONParser.Free;
    end;
  finally
    fs.Free;
  end;
end;

procedure TListQuerysForm.PopulateComboBox;
var
  idx: Integer;
  i: Integer;
begin
  ComboBox1.Clear;
  for i := 0 to High(FQueries) do
    ComboBox1.Items.Add(FQueries[i].QueryName);
  if ComboBox1.Items.Count > 0 then
    ComboBox1.ItemIndex := 0;
  idx := ComboBox1.ItemIndex;
  if (idx >= 0) and (idx < Length(FQueries)) then
    Memo1.Text := FQueries[idx].SQL
end;

end.

