unit ProductionServerConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,fpjson, jsonparser,DataModule;

type

  { TProductionServerConfgForm }

  TProductionServerConfgForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    EditDatabase: TEdit;
    EditPassword: TEdit;
    EditServerName: TEdit;
    EditUserName: TEdit;
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
  ProductionServerConfgForm: TProductionServerConfgForm;

implementation
uses
  MainForm

{$R *.lfm}

{ TProductionServerConfgForm }

procedure TProductionServerConfgForm.FormShow(Sender: TObject);
  var
    JSONData: TJSONData;
    JSONObject: TJSONObject;
    JSONParser: TJSONParser;
    FileStream: TFileStream;
  begin
  if not FileExists(MainApplicationForm.exeDir + 'prod.json') then
  begin
    ShowMessage('prod.json not found!  Enter your credentials and close form to create.');
    Exit;
  end;

  // Create a file stream and parser
  FileStream := TFileStream.Create(MainApplicationForm.exeDir + 'configs/prod.json', fmOpenRead or fmShareDenyNone);
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

procedure TProductionServerConfgForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
      JSONString.SaveToFile(MainApplicationForm.exeDir + 'configs/prod.json');
    finally
      JSONString.Free;
    end;
  finally
    JSONObject.Free;
  end;
  DataModule.DataModule1.MySQL80Connection1.Connected := false;
  DataModule.DataModule1.MySQL80Connection1.HostName := EditServerName.Text;
  DataModule.DataModule1.MySQL80Connection1.DatabaseName := EditDatabase.Text;
  DataModule.DataModule1.MySQL80Connection1.UserName := EditUserName.Text;
  DataModule.DataModule1.MySQL80Connection1.Password := EditPassword.Text;
  DataModule.DataModule1.MySQL80Connection1.Connected := true;
end;

procedure TProductionServerConfgForm.FormCreate(Sender: TObject);
begin

end;

procedure TProductionServerConfgForm.Button1Click(Sender: TObject);
begin
  ProductionServerConfgForm.Close;
end;

end.

