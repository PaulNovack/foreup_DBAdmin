unit SaveQueryName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TSaveQueryForm }

  TSaveQueryForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  SaveQueryForm: TSaveQueryForm;

implementation

{$R *.lfm}

{ TSaveQueryForm }

procedure TSaveQueryForm.FormCreate(Sender: TObject);
begin

end;

end.

