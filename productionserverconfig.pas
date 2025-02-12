unit ProductionServerConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,fpjson, jsonparser,DataModule;

type

  { TProductionServerConfigForm }

  TProductionServerConfigForm = class(TForm)
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
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  ProductionServerConfigForm: TProductionServerConfigForm;

implementation
uses
  MainForm;

{$R *.lfm}

{ TProductionServerConfigForm }

procedure TProductionServerConfigForm.FormShow(Sender: TObject);
  var
    JSONData: TJSONData;
    JSONObject: TJSONObject;
    JSONParser: TJSONParser;
    FileStream: TFileStream;
  begin
  if not FileExists(MainApplicationForm.exeDir + 'configs/prod.json') then
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

procedure TProductionServerConfigForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  var
    JSONObject: TJSONObject;
    JSONString: TStringList;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.Add('ServerName', EditServerName.Text);
    JSONObject.Add('UserName',   EditUserName.Text);
    JSONObject.Add('Password',   EditPassword.Text);
    JSONObject.Add('Database',   EditDatabase.Text);
    JSONString := TStringList.Create;
    try
      JSONString.Text := JSONObject.FormatJSON();
      JSONString.SaveToFile(MainApplicationForm.exeDir + 'configs/prod.json');
    finally
      JSONString.Free;
    end;
  finally
    JSONObject.Free;
  end;
end;


procedure TProductionServerConfigForm.FormCreate(Sender: TObject);
begin

end;

procedure TProductionServerConfigForm.Button1Click(Sender: TObject);
  var
    MyColor: TColor;
  begin
    DataModule.DataModule1.MainConnection.Connected := false;
    DataModule.DataModule1.MainConnection.HostName := EditServerName.Text;
    DataModule.DataModule1.MainConnection.DatabaseName := EditDatabase.Text;
    DataModule.DataModule1.MainConnection.UserName := EditUserName.Text;
    DataModule.DataModule1.MainConnection.Password := EditPassword.Text;

    try
      DataModule.DataModule1.MainConnection.Connected := true;
      MainApplicationForm.DBConnectionText.Caption := 'Connected To Production';
      MyColor := clLime;
      MainApplicationForm.ConnectionIndicator.Brush.Color := MyColor;
      MainApplicationForm.ShowTablesButton.Enabled := true;
      MainApplicationForm.ExecuteQueryButton.Enabled := true;
    except
      on E: Exception do
        ShowMessage('Error: ' + E.Message);
    end;

    ProductionServerConfigForm.Close;
end;

procedure TProductionServerConfigForm.Button2Click(Sender: TObject);
begin
    ProductionServerConfigForm.Close
end;

end.

