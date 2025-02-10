unit SaveQueryName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Clipbrd;

type

  { TSaveQueryForm }

  TSaveQueryForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private

  public

  end;

var
  SaveQueryForm: TSaveQueryForm;

implementation

{$R *.lfm}

{ TSaveQueryForm }







procedure TSaveQueryForm.Button1Click(Sender: TObject);
begin

end;

procedure TSaveQueryForm.FormCreate(Sender: TObject);
begin

end;

procedure TSaveQueryForm.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  Self.SetFocus;
end;

end.

