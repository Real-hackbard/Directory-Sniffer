{$I Directives.inc}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Sniffer,
  {$WARNINGS OFF} FileCtrl, Vcl.Mask {$WARNINGS ON}
  {$IFDEF EnableXPMan}, XPMan {$ENDIF};

type
  TForm1 = class(TForm)
    gbParams: TGroupBox;
    Edit1: TLabeledEdit;
    gbInfos: TGroupBox;
    ListBox1: TListBox;
    SB: TStatusBar;
    BtnParc: TButton;
    BtnStart: TButton;
    BtnStop: TButton;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure BtnParcClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    FChangeThread: TDirChangeNotifier;
    procedure SthChange(Sender: TDirChangeNotifier; const FileName,
     OtherFileName: WideString; Action: TDirChangeNotification);
    procedure ThreadTerminated(Sender: TObject);
  end;

var
  Form1: TForm1;
  a : integer = 0;
  b : integer = 0;
  c : integer = 0;
  d : integer = 0;
  e : integer = 0;
  f : integer = 0;
  g : integer = 0;
  h : integer = 0;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  Buf: array[0..255] of Char;
begin
  GetWindowsDirectory(@Buf, SizeOf(Buf));
  Edit1.Text := ExtractFileDrive(Buf);
end;

procedure TForm1.BtnParcClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('Files system watch:', '', Dir) then
    Edit1.Text := Dir;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FChangeThread) then
    FChangeThread.Terminate;
end;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
  FChangeThread := TDirChangeNotifier.Create(Edit1.Text, CAllNotifications);
  FChangeThread.OnChange := SthChange;
  FChangeThread.OnTerminate := ThreadTerminated;
  BtnStart.Enabled := False;
  BtnStop.Enabled := True;
  ListBox1.Items.Clear;
  SB.Panels[1].Text := '0 element';
  SB.Panels[0].Text := 'Watch on file system changes';
end;

procedure TForm1.BtnStopClick(Sender: TObject);
begin
  FChangeThread.Terminate;
end;

procedure TForm1.Button1Click(Sender: TObject);
var Dir : string;
begin
 if SelectDirectory('Select directory', '', Dir) then
 Edit1.Text := Dir;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ListBox1.Clear;
  a := 0; b := 0; c := 0;
  d := 0; e := 0; f := 0;
  g := 0; h := 0;
  Label1.Caption := ': 0'; Label2.Caption := ': 0'; Label3.Caption := ': 0';
  Label4.Caption := ': 0'; Label5.Caption := ': 0'; Label6.Caption := ': 0';
  Label7.Caption := ': 0'; Label8.Caption := ': 0';

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then begin
  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end else begin
  SetWindowPos(Handle, HWND_NOTOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TForm1.SBResize(Sender: TObject);
begin
  SB.Panels[0].Width := SB.ClientWidth - 150;
end;

procedure TForm1.SthChange(Sender: TDirChangeNotifier;
 const FileName, OtherFileName: WideString; Action: TDirChangeNotification);
var
  Fmt, Line, Time: WideString;
begin
  Time := FormatDateTime('"["hh":"nn":"ss","zzz"] "', Now);


  if CheckBox2.Checked = true then begin
  if Action = dcnFileAdd then begin
  a := a + 1; Label1.Caption := ': ' + IntToStr(a);
  Fmt := ' %s';
  Line := Time + ' | CREATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox3.Checked = true then begin
  if Action = dcnFileRemove then begin
  b := b + 1; Label2.Caption := ': ' + IntToStr(b);
  Fmt := ' %s';
  Line := Time + ' | REMOVE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox4.Checked = true then begin
  if Action = dcnRenameFile then begin
  c := c + 1; Label3.Caption := ': ' + IntToStr(c);
  Fmt := '%s RENAMED to %s';
  Line := Time + ' | RENAMED FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox5.Checked = true then begin
  if Action = dcnRenameDir then begin
  d := d + 1; Label4.Caption := ': ' + IntToStr(d);
  Fmt := '%s RENAMED to %s';
  Line := Time + ' | RENAMED DIR : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox6.Checked = true then begin
  if Action = dcnModified then begin
  e := e + 1; Label5.Caption := ': ' + IntToStr(e);
  Fmt := ' %s';
  Line := Time + ' | MODIFICATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox7.Checked = true then begin
  if Action = dcnLastAccess then begin
  f := f + 1; Label6.Caption := ': ' + IntToStr(f);
  Fmt := ' %s  MODIFIED';
  Line := Time + ' | LAST ACCESS : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox8.Checked = true then begin
  if Action = dcnLastWrite then begin
  g := g + 1; Label7.Caption := ': ' + IntToStr(g);
  Fmt := ' %s MODIFIED';
  Line := Time + ' |  LAST WRITE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if CheckBox9.Checked = true then begin
  if Action = dcnCreationTime then begin
  h := h + 1; Label8.Caption := ': ' + IntToStr(h);
  Fmt := ' %s MODIFIED';
  Line := Time + ' | CREATION TIME FILE : ' + Format(Fmt, [FileName, OtherFileName]);
  ListBox1.Items.Insert(0, Line);
  end;
  end;

  if ListBox1.Items.Count > 1 then
    SB.Panels[1].Text := Format('%d elements', [ListBox1.Items.Count])
  else
    SB.Panels[1].Text := '1 element';
end;

procedure TForm1.ThreadTerminated(Sender: TObject);
begin
  FChangeThread := nil;
  BtnStart.Enabled := True;
  BtnStop.Enabled := False;
  SB.Panels[0].Text := 'Watch stopped';
end;

end.
