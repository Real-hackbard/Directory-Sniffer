{$I Directives.inc}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Sniffer,
  {$WARNINGS OFF} Vcl.FileCtrl, Vcl.Mask, System.ImageList, Vcl.ImgList,
  Vcl.Menus {$WARNINGS ON}, StrUtils ;

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
    DiskInfo1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    FindDialog1: TFindDialog;
    DisksInformation1: TMenuItem;
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
    procedure DiskInfo1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure DisksInformation1Click(Sender: TObject);
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
  Img: TImage;

implementation

{$R *.dfm}

uses Options, DiskProperties, DiskInformation;

procedure DiskInfo(DestList: TStrings);
var
  Laufwerke: Cardinal;
  I: Integer;
  LaufwerkBuchstabe: Char;
  LaufwerkPfad: string;
  LaufwerkTyp: UINT;
begin
  DestList.Clear;
  // 1. Bitmask of all available drives
  Laufwerke := GetLogicalDrives;
  if Laufwerke = 0 then Exit;
  // 2. Go through the bits from A to Z (0 to 25)
  for I := 0 to 25 do
  begin
    // Check whether the bit for the drive letter is set.
    if (Laufwerke and (1 shl I)) <> 0 then
    begin
      LaufwerkBuchstabe := Chr(Ord('A') + I);
      LaufwerkPfad := LaufwerkBuchstabe + ':\';
      // 3. Determine the drive type
      LaufwerkTyp := GetDriveType(PChar(LaufwerkPfad));
      // 4. Add only hard drives (DRIVE_FIXED) to the list
      if LaufwerkTyp = DRIVE_FIXED then
      begin
        // list drives
        DestList.Add(LaufwerkPfad);
      end;
    end;
  end;
end;

procedure TimeColor(RichEdit: TRichEdit; Index: Integer; Farbe: TColor);
begin
  // Check whether the index is within the valid range.
  if (Index >= 0) and (Index < Length(RichEdit.Text)) then
  begin
    RichEdit.SelStart := Index;    // Starting position of the character (0-based)
    RichEdit.SelLength := 16;      // Set length to 1 character
    RichEdit.SelAttributes.Color := Farbe; // Set color for the selection
    // Move the cursor back to the end so that the character does not remain highlighted.
    //RichEdit.SelStart := Length(RichEdit.Text);
    RichEdit.SelLength := 0;
  end;
end;

procedure TForm1.disable;
begin
  Start1.Enabled := False;
  Stop1.Enabled := True;
  Clear1.Enabled := false;
  Save1.Enabled := false;
  Search1.Enabled := false;
  Mode1.Enabled := false;
  Font1.Enabled := false;
  Copy1.Enabled := false;
  Copyall1.Enabled := false;
  DiskInfo1.Enabled := false;
  DisksInformation1.Enabled := false;
end;

procedure TForm1.DiskInfo1Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.DisksInformation1Click(Sender: TObject);
begin
  Form4.ShowModal;
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
  Clear1.Enabled := true;
  DiskInfo1.Enabled := true;
  DisksInformation1.Enabled := true;
end;

{ This is a more precise search for strings within a RichEdit control,
  but it is much slower than the search function built into the component
  itself. }
{
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
}

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
  // Increase the text length in the RichEdit.
  RichEdit1.MaxLength := $7FFFFFF0;

  // Create an image area on the RichEdit control.
  Img := TImage.Create(RichEdit1);
  // Adjust the height and width of the image.
  Img.ClientHeight := RichEdit1.ClientHeight;
  Img.ClientWidth := RichEdit1.ClientWidth;
  // shifted the image within the RichEdit
  Img.Left := 30;
  Img.Top := 30;
  // load picture
  Img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
                           'Data\Plain Picture\plain.bmp');
  // combined the image and the RichEdit control
  Img.Parent := RichEdit1;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Buf: array[0..255] of Char;
begin
  // update options form for highlight colors
  Form2.OnShow(sender);

  // Length() measures characters, not bytes, better version
  if GetWindowsDirectory(Buf, Length(Buf)) > 0 then
    Form2.Edit1.Text := ExtractFileDrive(Buf);

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

// search strings in RichEdit
procedure TForm1.FindDialog1Find(Sender: TObject);
const
  TWordSeperators: set of Char = ['A'..'Z', 'a'..'z', 'ö', 'Ö', 'Ä', 'ä', 'ü', 'Ü', 'ß',
  '´', '`', '@', '0'..'9'];
var
  Buffer: String;
  CmpText: String;
  Position: Integer;
  Counter: Integer;
  Left, Right: Boolean;
  Hit: Boolean;
begin
  if not (frMatchCase in Finddialog1.Options) then
  begin
    CmpText:=AnsiUpperCase(Finddialog1.FindText);
    Buffer := AnsiUpperCase(Copy(RichEdit1.Text,
                                      RichEdit1.SelStart+RichEdit1.SelLength+1,
      Length(RichEdit1.Text)))
  end
  else
  begin
    CmpText := Finddialog1.FindText;
    Buffer:=Copy(RichEdit1.Text,RichEdit1.SelStart+
                                      RichEdit1.SelLength+1,Length(RichEdit1.Text));
  end;

  Position:=AnsiPos(CmpText, Buffer);

  if Position > 0 then
  begin
    if frWholeWord in FindDialog1.Options then
    begin
      Counter:=0;
      Position:=AnsiPos(CmpText, Buffer);
      Hit:=False;
      while (Position > 0) and not Hit do
      begin
        Left:=(Position = 1) or (not (Buffer[Position-1] in TWordSeperators));
        Right:=(Position+Length(Finddialog1.FindText) >= Length(Buffer)) or
          (not (Buffer[Position+Length(Finddialog1.FindText)] in TWordSeperators));
        Hit:=Left and Right;
        Inc(Counter, Position);
        Delete(Buffer, 1, Position);
        Position:=Pos(CmpText, Buffer);
      end;

      if Hit then
      begin
        RichEdit1.SelStart:= RichEdit1.SelStart+RichEdit1.SelLength+Counter-1;
        RichEdit1.SelLength:= Length(Finddialog1.FindText);
      end
      else
        FindDialog1.CloseDialog;
    end
    else
    begin
      RichEdit1.SelStart:= RichEdit1.SelStart+RichEdit1.SelLength+Position-1;
      RichEdit1.SelLength:= Length(Finddialog1.FindText);
    end;
  end
  else
    FindDialog1.CloseDialog;
  RichEdit1.SetFocus;
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

  // reload plain logo when clear report
  Img:= TImage.Create(RichEdit1);
  Img.ClientHeight := RichEdit1.ClientHeight;
  Img.ClientWidth := RichEdit1.ClientWidth;
  Img.Left := 30;
  Img.Top := 30;
  Img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
                           'Data\Plain Picture\plain.bmp');
  Img.Parent := RichEdit1;
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
begin
  FindDialog1.Execute;
end;

procedure TForm1.Start1Click(Sender: TObject);
begin
  Img.Free;
  RichEdit1.Font.Color := clBlack;
  RichEdit1.Clear;
  FChangeThread := TDirChangeNotifier.Create(Form2.Edit1.Text, CAllNotifications);
  FChangeThread.OnChange := SthChange;
  FChangeThread.OnTerminate := ThreadTerminated;
  disable;
  RichEdit1.Clear;
end;

// draw images to StatusBar
procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
    case Panel.Index of
      // add file
      0: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 0);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // remove file
      2: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 1);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // rename directory
      4: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 2);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // modification
      6: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 3);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // last access
      8: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 4);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // lasr write
      10: begin
        ImageList1.Draw(StatusBar.Canvas, Rect.Left, Rect.Top, 4);
        StatusBar.Canvas.TextOut((Rect.Left+5) + ImageList1.Width  , Rect.Top-2, Panel.Text);
      end;

      // time
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
  if StayTop1.Checked = true then
  begin
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
    // get sytssme date/time
    Time := FormatDateTime('> "["hh":"nn":"ss","zzz"] "', Now);
  end;

  Richedit1.Selstart := 0;
  RichEdit1.SelAttributes.Color := FontDialog1.Font.Color;

  // Detect file creation
  if AddFile = true then
  begin
    if Action = dcnFileAdd then
    begin
      a := a + 1;
      StatusBar1.Panels[1].Text := IntToStr(a);
      Fmt := ' %s';
      Line := Time + ' | CREATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);

      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        SendMessage(RichEdit1.Handle, WM_VSCROLL, SB_LINEUP, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox1.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Read the file deletion.
  if RemoveFile = true then
  begin
    if Action = dcnFileRemove then
    begin
      b := b + 1;
      StatusBar1.Panels[3].Text := IntToStr(b);
      Fmt := ' %s';
      Line := Time + ' | REMOVE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox2.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Read the file renaming.
  if RenameFile = true then
  begin
    if Action = dcnRenameFile then
    begin
      c := c + 1;
      StatusBar1.Panels[5].Text := IntToStr(c);
      Fmt := '%s Renamed to %s';
      Line := Time + ' | RENAMED FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox3.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Read about renaming folders.
  if RenameDir = true then
  begin
    if Action = dcnRenameDir then
    begin
      d := d + 1;
      StatusBar1.Panels[5].Text := IntToStr(d);
      Fmt := '%s Renamed to %s';
      Line := Time + ' | RENAMED DIR : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox4.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Detect file modifications
  if Modification = true then
  begin
    if Action = dcnModified then
    begin
      e := e + 1;
      StatusBar1.Panels[7].Text := IntToStr(e);
      Fmt := ' %s';
      Line := Time + ' | MODIFICATION FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox5.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Read the last access to a file
  if LastAccess = true then
  begin
    if Action = dcnLastAccess then
    begin
      f := f + 1;
      StatusBar1.Panels[11].Text := IntToStr(f);
      Fmt := ' %s';
      Line := Time + ' | LAST ACCESS : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox6.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // last overwrite of a file
  if LastWrite = true then
  begin
    if Action = dcnLastWrite then
    begin
      g := g + 1;
      StatusBar1.Panels[13].Text := IntToStr(g);
      Fmt := ' %s';
      Line := Time + ' |  LAST WRITE FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
        RichEdit1.SelAttributes.Color := StringToColor('cl' + Form2.ComboBox7.Text);
      end;
      RichEdit1.Lines.Insert(0, Line);
    end;
  end;

  // Last time & date entry for a file
  if CreationTime = true then
  begin
    if Action = dcnCreationTime then
    begin
      h := h + 1;
      StatusBar1.Panels[15].Text := IntToStr(h);
      Fmt := ' %s';
      Line := Time + ' | CREATION TIME FILE : ' + Format(Fmt, [FileName, OtherFileName]);
      if Colored1.Checked = true then
      begin
        Richedit1.selstart := 0;
        TimeColor(RichEdit1, 0, clSilver);
        RichEdit1.Perform(EM_LINESCROLL, 0, -1);
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
