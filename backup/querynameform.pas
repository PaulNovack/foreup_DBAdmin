unit QueryNameForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,LCLType;

type

  { TQueryNameFrm }

  TQueryNameFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    QueryNameEdit: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QueryNameEditKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  QueryNameFrm: TQueryNameFrm;

implementation

{$R *.lfm}

{ TQueryNameFrm }

procedure TQueryNameFrm.FormCreate(Sender: TObject);
begin

end;

procedure TQueryNameFrm.FormShow(Sender: TObject);
begin
  QueryNameEdit.Text := '';
end;

procedure TQueryNameFrm.QueryNameEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #0 then Exit;
end;

end.

