unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,fpjson, jsonparser;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    EditServerName: TEdit;
    EditUserName: TEdit;
    EditPassword: TEdit;
    EditDatabase: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }



procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);

  var
  JSONObject: TJSONObject;
  JSONString: TStringList;
  begin
  JSONObject := TJSONObject.Create;
  try
    // Gather values from the edit controls
    JSONObject.Add('ServerName', EditServerName.Text);
    JSONObject.Add('UserName',   EditUserName.Text);
    JSONObject.Add('Password',   EditPassword.Text);
    JSONObject.Add('Database',   EditDatabase.Text);

    // Convert JSON object to a string and save to file
    JSONString := TStringList.Create;
    try
      JSONString.Text := JSONObject.FormatJSON();  // Nicely formatted JSON
      JSONString.SaveToFile('dev.json');
    finally
      JSONString.Free;
    end;
  finally
    JSONObject.Free;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

procedure TForm2.FormShow(Sender: TObject);

  var
  JSONData: TJSONData;
  JSONObject: TJSONObject;
  JSONParser: TJSONParser;
  FileStream: TFileStream;
begin
  if not FileExists('dev.json') then
  begin
    ShowMessage('dev.json not found! Enter your credentials and close form to save.');
    Exit;
  end;

  // Create a file stream and parser
  FileStream := TFileStream.Create('dev.json', fmOpenRead or fmShareDenyNone);
  try
    JSONParser := TJSONParser.Create(FileStream);
    try
      // Parse the file into a TJSONData object
      JSONData := JSONParser.Parse;
      try
        // Cast to TJSONObject
        JSONObject := JSONData as TJSONObject;

        // Retrieve values from the JSON object
        EditServerName.Text := JSONObject.Get('ServerName', '');
        EditUserName.Text := JSONObject.Get('UserName', '');
        EditPassword.Text := JSONObject.Get('Password', '');
        EditDatabase.Text := JSONObject.Get('Database', '');
      finally
        JSONData.Free;
      end;
    finally
      JSONParser.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

end.

