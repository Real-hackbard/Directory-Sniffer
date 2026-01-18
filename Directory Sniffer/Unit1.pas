{$I Directives.inc}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Sniffer,
  {$WARNINGS OFF} Vcl.FileCtrl, Vcl.Mask, System.ImageList, Vcl.ImgList, Vcl.Menus {$WARNINGS ON}
  {$IFDEF EnableXPMan}, XPMan {$ENDIF};

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    RichEdit1: TRichEdit;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Mode1: TMenuItem;
    Sniffer1: TMenuItem;
    StayTop1: TMenuItem;
    Font1: TMenuItem;
    N1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Clear1: TMenuItem;
    Close1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    Save1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Copyall1: TMenuItem;
    N3: TMenuItem;
    Clear2: TMenuItem;
    Search1: TMenuItem;
    N4: TMenuItem;
    Colored1: TMenuItem;
    ime1: TMenuItem;
    FontDialog1: TFontDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure Mode1Click(Sender: TObject);
    procedure StayTop1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Copyall1Click(Sender: TObject);
    procedure Clear2Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FChangeThread: TDirChangeNotifier;
    procedure SthChange(Sender: TDirChangeNotifier; const FileName,
     OtherFileName: WideString; Action: TDirChangeNotification);
    procedure ThreadTerminated(Sender: TObject);
    procedure disable;
    procedure enable;
  public
    { Public-Deklarationen }
    AddFile : boolean;
    RemoveFile : boolean;
    RenameFile : boolean;
    RenameDir : boolean;
    Modification : boolean;
    LastAccess : boolean;
    LastWrite : boolean;
    CreationTime : boolean;
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

uses Unit2;

procedure TForm1.disable;
begin
  Start1.Enabled := False;
  Stop1.Enabled := True;

  Save1.Enabled := false;
  Search1.Enabled := false;
  Mode1.Enabled := false;
  Font1.Enabled := false;
  Copy1.Enabled := false;
  Copyall1.Enabled := false;
end;

procedure TForm1.enable;
begin
  Start1.Enabled := True;
  Stop1.Enabled := False;
  Save1.Enabled := true;
  Search1.Enabled := true;
  Mode1.Enabled := true;
  Font1.Enabled := true;
  Copy1.Enabled := true;
  Copyall1.Enabled := true;
end;

procedure RE_SearchForText_AndSelect(RichEdit: TRichEdit; SearchText: string);
var StartPos, Position, RemainingLength, WordCount, TextSize, SearchSize: Integer;
begin
  if SearchText = '' then Exit;

  with RichEdit do
  begin
    Lines.BeginUpdate;

    // reset colors...
    SelStart:=0;
    SelLength:=Length(RichEdit.Text) - 1;
    SelAttributes.Color:=$000000;

    WordCount:=0;
    StartPos:=0;
    TextSize:=Length(RichEdit.Text);
    SearchSize:=Length(SearchText);
    RemainingLength:=TextSize;
    Position:=FindText(SearchText, StartPos, RemainingLength, []);

    if Position <> -1 then
    repeat
      // selects the word and changes color
      SelStart:=Position;
      SelLength:=SearchSize;
      SelAttributes.Color:=$0000FF;
      inc(WordCount);

      // changes startpos to after the current word
      StartPos:=Position + SearchSize;
      // Remaining Text to search for
      RemainingLength:=TextSize - StartPos;
      // find again...
      Position:=FindText(SearchText, StartPos, RemainingLength, []);
    until Position = -1;

    SelLength:=0; // reset selection...
    Lines.EndUpdate;
  end;
  ShowMessage(SearchText + ' found ' + IntToStr(WordCount) + ' times.');
end;

procedure CopyRichEditSelection(Source,Dest: TRichEdit);
begin
  // Copy Source.Selection to Dest via ClipBoard.
  //Dest.Clear;
  if (Source.SelLength > 0) then
  begin
    Source.CopyToClipboard;
    //Dest.PasteFromClipboard;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  RichEdit1.MaxLength := $7FFFFFF0;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Buf: array[0..255] of Char;
begin
  Form2.Show;
  Form2.Close;

  try
    GetWindowsDirectory(@Buf, SizeOf(Buf));
    Form2.Edit1.Text := ExtractFileDrive(Buf);
  except
  end;
  Stop1.Enabled := false;
end;

procedure TForm1.Mode1Click(Sender: TObject);
begin
  try
    form2 := TForm2.Create(self);
    form2.ShowModal;
    finally
  end;
end;

procedure TForm1.Font1Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    RichEdit1.Font := FontDialog1.Font;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FChangeThread) then
    FChangeThread.Terminate;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  RichEdit1.Clear;
  a := 0;
  b := 0;
  c := 0;
  d := 0;
  e := 0;
  f := 0;
  g := 0;
  h := 0;
  StatusBar1.Panels[1].Text := '0';
  StatusBar1.Panels[3].Text := '0';
  StatusBar1.Panels[5].Text := '0';
  StatusBar1.Panels[7].Text := '0';
  StatusBar1.Panels[9].Text := '0';
  StatusBar1.Panels[11].Text := '0';
  StatusBar1.Panels[13].Text := '0';
  StatusBar1.Panels[15].Text := '0';
end;

procedure TForm1.Clear2Click(Sender: TObject);
begin
  Clear1.Click;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  RichEdit1.Perform(WM_COPY,0,0);
end;

procedure TForm1.Copyall1Click(Sender: TObject);
begin
  RichEdit1.SelectAll;
  CopyRichEditSelection(Form1.RichEdit1, RichEdit1);
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  RichEdit1.PlainText := True ;
  if SaveDialog1.Execute then
     RichEdit1.Lines.SaveToFile(SaveDialog1.FileName + '.txt');
end;

procedure TForm1.Search1Click(Sender: TObject);
var
  str : string;
begin
  if RichEdit1.Lines.Count = 0 then Exit;

  str := InputBox('Search','Type Search Text','...');
  RE_SearchForText_AndSelect(RichEdit1, str);
end;

procedure TForm1.Start1Click(Sender: TObject);
begin
  FChangeThread := TDirChangeNotifier.Create(Form2.Edit1.Text, CAllNotifications);
  FChangeThread.OnChange := SthChange;
  FChangeThread.OnTerminate := ThreadTerminated;
  disable;
  RichEdit1.Clear;
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
    case Panel.Index of
      0: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 0);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      2: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 1);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      4: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 2);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      6: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 3);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      8: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 4);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      10: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 4);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      12: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 5);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      14: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 6);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;
    end;
end;

procedure TForm1.StayTop1Click(Sender: TObject);
begin
  if StayTop1.Checked = true then begin
  SetWindowPos(Handle, HWND_TOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end else begin
  SetWindowPos(Handle, HWND_NOTOPMOST, Left,Top, Width,Height,
             SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TForm1.SthChange(Sender: TDirChangeNotifier;
 const FileName, OtherFileName: WideString; Action: TDirChangeNotification);
var
  Fmt, Line, Time: WideString;
begin
  RichEdit1.Lines.BeginUpdate;
  if ime1.Checked = true then
  begin
    Time := FormatDateTime('> "["hh":"nn":"ss","zzz"] "', Now);
  end;
  Richedit1.selstart := 0;
  RichEdit1.SelAttributes.Color := FontDialog1.Font.Color;

  if AddFile = true then begin
    if Action = dcnFileAdd then begin
      a := a + 1;
      StatusBar1.Panels[1].Text := IntToStr(a);
      Fmt := ' %s';
      Line := Time + ' | CREATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox1.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if RemoveFile = true then begin
    if Action = dcnFileRemove then begin
      b := b + 1;
      StatusBar1.Panels[3].Text := IntToStr(b);
      Fmt := ' %s';
      Line := Time + ' | REMOVE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox2.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if RenameFile = true then begin
    if Action = dcnRenameFile then begin
      c := c + 1;
      StatusBar1.Panels[5].Text := IntToStr(c);
      Fmt := '%s Renamed to %s';
      Line := Time + ' | RENAMED FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox3.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if RenameDir = true then begin
    if Action = dcnRenameDir then begin
      d := d + 1;
      StatusBar1.Panels[5].Text := IntToStr(d);
      Fmt := '%s Renamed to %s';
      Line := Time + ' | RENAMED DIR : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox4.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if Modification = true then begin
    if Action = dcnModified then begin
      e := e + 1;
      StatusBar1.Panels[7].Text := IntToStr(e);
      Fmt := ' %s';
      Line := Time + ' | MODIFICATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox5.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if LastAccess = true then begin
    if Action = dcnLastAccess then begin
      f := f + 1;
      StatusBar1.Panels[11].Text := IntToStr(f);
      Fmt := ' %s';
      Line := Time + ' | LAST ACCESS : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox6.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if LastWrite = true then begin
    if Action = dcnLastWrite then begin
      g := g + 1;
      StatusBar1.Panels[13].Text := IntToStr(g);
      Fmt := ' %s';
      Line := Time + ' |  LAST WRITE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox7.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  if CreationTime = true then begin
    if Action = dcnCreationTime then begin
      h := h + 1;
      StatusBar1.Panels[15].Text := IntToStr(h);
      Fmt := ' %s';
      Line := Time + ' | CREATION TIME FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox8.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  RichEdit1.Lines.EndUpdate;
  {
  if RichEdit1.Lines.Count > 1 then
    StatusBar1.Panels[1].Text := Format('%d elements', [RichEdit1.Lines.Count])
  else
    StatusBar1.Panels[1].Text := '1 element';
  }
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  FChangeThread.Terminate;
end;

procedure TForm1.ThreadTerminated(Sender: TObject);
begin
  FChangeThread := nil;
  enable;
end;

end.
