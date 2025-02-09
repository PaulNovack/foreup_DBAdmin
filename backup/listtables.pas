unit listtables;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ExtCtrls, DB;

type

  { TListTablesForm }

  TListTablesForm = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: char);
  private
    FSearchText: string;   // Stores the typed search text
    FSearchTimer: TTimer;  // Timer used to clear the search text after inactivity
    procedure SearchTimerTimer(Sender: TObject);
  public
    { Public declarations }
  end;

var
  ListTablesForm: TListTablesForm;

implementation

{$R *.lfm}

{ TListTablesForm }

// FormCreate: initialize search text and timer
procedure TListTablesForm.FormCreate(Sender: TObject);
begin
  FSearchText := '';
  FSearchTimer := TTimer.Create(Self);
  FSearchTimer.Interval := 1000;  // 1 second delay for type-ahead reset
  FSearchTimer.OnTimer := @SearchTimerTimer;
  FSearchTimer.Enabled := False;
end;

// FormDestroy: free the timer
procedure TListTablesForm.FormDestroy(Sender: TObject);
begin
  FSearchTimer.Free;
end;

// SearchTimerTimer: clears the accumulated search text when no key is pressed for 1 second
procedure TListTablesForm.SearchTimerTimer(Sender: TObject);
begin
  FSearchText := '';
  FSearchTimer.Enabled := False;
end;

// DBGrid1KeyPress: handles key presses on the grid to perform an incremental search
procedure TListTablesForm.DBGrid1KeyPress(Sender: TObject; var Key: char);
begin
  // If ESC is pressed, clear the search text
  if Key = #27 then
  begin
    FSearchText := '';
    Exit;
  end;

  // Append the pressed key to the search text
  FSearchText := FSearchText + Key;

  // Reset and re-enable the timer (so the search text is cleared after inactivity)
  FSearchTimer.Enabled := False;
  FSearchTimer.Enabled := True;

  // Check that the DBGrid is linked to a dataset
  if (DBGrid1.DataSource <> nil) and (DBGrid1.DataSource.DataSet <> nil) then
  begin
    // Use the Locate method to jump to the record where the "TableName" field starts with the search text.
    // The loPartialKey option allows matching only the beginning of the field.
    DBGrid1.DataSource.DataSet.Locate('TableName', FSearchText, [loPartialKey]);
  end;
end;

end.

