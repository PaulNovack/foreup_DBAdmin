unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, ExtCtrls, DBGrids, Buttons, Unit2, Unit3,DataModule,Unit5;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    LimitCheckBox: TCheckBox;
    LimitNumberComboBox: TComboBox;
    DBGrid1: TDBGrid;
    DBGrid10: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    DBGrid7: TDBGrid;
    DBGrid8: TDBGrid;
    DBGrid9: TDBGrid;
    CourseIdEdit: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo10: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    Memo9: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Splitter10: TSplitter;
    Splitter11: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Splitter7: TSplitter;
    Splitter8: TSplitter;
    Splitter9: TSplitter;
    TS1: TTabSheet;
    TS10: TTabSheet;
    TS2: TTabSheet;
    TS3: TTabSheet;
    TS4: TTabSheet;
    TS5: TTabSheet;
    TS6: TTabSheet;
    TS7: TTabSheet;
    TS8: TTabSheet;
    TS9: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure Shape1ChangeBounds(Sender: TObject);

    procedure RemoveLinesStartingWithLimit(AMemo: TMemo);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  activeTab: Integer;
  myString: String;
  dbGridColumns: Integer;
begin
  DataModule1.SQLQuery1.Active := false;
  activeTab := PageControl1.ActivePageIndex;
  Form1.RemoveLinesStartingWithLimit(Memo1);
  if LimitCheckBox.Checked then
  begin
     Memo1.Text := Memo1.Text + 'Limit 0,' + LimitNumberComboBox.Text;
  end;
  DataModule1.SQLQuery1.SQL.Text := Memo1.Text;
  DataModule1.SQLQuery1.Active := true;
  for dbGridColumns := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[dbGridColumns].Width := 85;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ChildForm : TForm;
begin
     DataModule.DataModule1.SchemaConn.Connected:= true;
     DataModule.DataModule1.SchemaQ.Active:= true;
     Form4.Show;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  selectString: String;
begin
  selectString := 'Select * from';
  Memo1.Append(selectString);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  whereString: String;
begin
  whereString := 'where course_id = ' + CourseIdEdit.Text;
  Memo1.Append(whereString);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  dbGridColumns: Integer;
begin
  DataModule1.SQLQuery1.Edit;
  DataModule1.SQLQuery1.Post;
  DataModule1.SQLQuery1.ApplyUpdates(0);
  DataModule1.SQLTransaction1.Commit;
  DataModule1.SQLQuery1.Active:= true;
  for dbGridColumns := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[dbGridColumns].Width := 85;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.Shape1ChangeBounds(Sender: TObject);
begin

end;
procedure TForm1.RemoveLinesStartingWithLimit(AMemo: TMemo);
var
  i: Integer;
  TempList: TStringList;
  CurrentLine: string;
begin
  TempList := TStringList.Create;
  try
    for i := 0 to AMemo.Lines.Count - 1 do
    begin
      CurrentLine := AMemo.Lines[i];

      // Check if the line starts with "Limit"
      // (case-sensitive; if you need case-insensitive use StrUtils.StartsText)
      if Copy(CurrentLine, 1, 5) <> 'Limit' then
      begin
        TempList.Add(CurrentLine);
      end;
      // else we skip adding it (thus removing lines that start with "Limit")
    end;
    AMemo.Lines.Assign(TempList);
  finally
    TempList.Free;
  end;
end;


end.

