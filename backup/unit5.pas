unit Unit5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  DBGrids,DataModule;

type

  { TForm4 }

  TForm4 = class(TForm)
    DBGrid1: TDBGrid;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBListBox1Click(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;

implementation

  uses
    Unit1;

{$R *.lfm}

{ TForm4 }

procedure TForm4.DBListBox1Click(Sender: TObject);
begin

end;

procedure TForm4.DBGrid1CellClick(Column: TColumn);
begin
  Form1.Memo1.Append(DBGrid1.SelectedField.AsString);
  Form4.Close;
end;

end.

