unit listtables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  DBGrids,DataModule;

type

  { TListTablesForm }

  TListTablesForm = class(TForm)
    DBGrid1: TDBGrid;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBListBox1Click(Sender: TObject);
  private

  public

  end;

var
  ListTablesForm: TListTablesForm;

implementation

  uses
    MainForm;

{$R *.lfm}

{ TListTablesForm }

procedure TListTablesForm.DBListBox1Click(Sender: TObject);
begin

end;

procedure TListTablesForm.DBGrid1CellClick(Column: TColumn);
begin
  //MainApplicationForm.Memo1.Append(DBGrid1.SelectedField.AsString);
  ListTablesForm.Close;
end;

end.

