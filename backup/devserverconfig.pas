unit DevServerConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,fpjson
  , jsonparser,DataModule,System.UITypes;

type

  { TDevelopmentServerConfigForm }

  TDevelopmentServerConfigForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
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
  DevelopmentServerConfigForm: TDevelopmentServerConfigForm;

implementation


{$R *.lfm}

uses
  MainForm;

{ TDevelopmentServerConfigForm }



procedure TDevelopmentServerConfigForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);

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
      JSONString.SaveToFile(MainApplicationForm.exeDir + 'configs/dev.json');
    finally
      JSONString.Free;
    end;
  finally
    JSONObject.Free;
  end;

end;

procedure TDevelopmentServerConfigForm.Button1Click(Sender: TObject);
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
    MainApplicationForm.DBConnectionText.Caption := 'Connected To Development';
    MyColor := clLime;
    MainApplicationForm.ConnectionIndicator.Brush.Color := MyColor;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
  DevelopmentServerConfigForm.Close;
end;

procedure TDevelopmentServerConfigForm.FormCreate(Sender: TObject);
begin

end;

procedure TDevelopmentServerConfigForm.FormShow(Sender: TObject);

  var
  JSONData: TJSONData;
  JSONObject: TJSONObject;
  JSONParser: TJSONParser;
  FileStream: TFileStream;
begin
  if not FileExists(MainApplicationForm.exeDir + 'configs/dev.json') then
  begin
    ShowMessage('dev.json not found! Enter your credentials and close form to save.');
    Exit;
  end;
  FileStream := TFileStream.Create(MainApplicationForm.exeDir + 'configs/dev.json', fmOpenRead or fmShareDenyNone);
  try
    JSONParser := TJSONParser.Create(FileStream);
    try
      JSONData := JSONParser.Parse;
      try
        JSONObject := JSONData as TJSONObject;
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

