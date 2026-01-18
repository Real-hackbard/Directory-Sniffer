unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.FileCtrl, IniFiles, Vcl.ComCtrls, ActiveX, ComObj;

const
  IoCtl_Storage_Get_Device_Number = $2D1080;

type
  _Storage_Device_Number = record
     DeviceType      : DWord;
     DeviceNumber    : DWord;
     PartitionNumber : DWord;
  end;

type
  TLaufwerkstyp = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    Button4: TButton;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit1: TEdit;
    Button3: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    Button5: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox3DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox4DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox5DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox6DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox7DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox8DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button5Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure WriteOptions;
    procedure ReadOptions;
  end;

var
  Form2: TForm2;
  TIF : TIniFile;

const
  COLOR_NUM = 15;

  ColorConst: array [0..COLOR_NUM] of TColor = (clBlack,
    clMaroon, clGreen, clOlive, clNavy,
    clPurple, clTeal, clGray, clSilver, clRed,
    clLime, clYellow, clBlue, clFuchsia,
    clAqua, clWhite);

  ColorNames: array [0..COLOR_NUM] of string = ('Black',
    'Maroon', 'Green', 'Olive', 'Navy',
    'Purple', 'Teal', 'Gray', 'Silver', 'Red',
    'Lime', 'Yellow', 'Blue', 'Fuchsia',
    'Aqua', 'White');

implementation

{$R *.dfm}

uses Unit1;

function MainDir : string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TForm2.WriteOptions;    // ################### Options Write
var
  OPT :string;
begin
   OPT := 'Options';

   if not DirectoryExists(MainDir + 'Data\Options\')
   then ForceDirectories(MainDir + 'Data\Options\');

   TIF := TIniFile.Create(MainDir + 'Data\Options\Options.ini');
   with TIF do
   begin
    WriteBool(OPT,'Add',CheckBox1.Checked);
    WriteBool(OPT,'Remove',CheckBox2.Checked);
    WriteBool(OPT,'Renamed',CheckBox3.Checked);
    WriteBool(OPT,'RenamedDir',CheckBox4.Checked);
    WriteBool(OPT,'Modi',CheckBox5.Checked);
    WriteBool(OPT,'LastAccess',CheckBox6.Checked);
    WriteBool(OPT,'LastWrite',CheckBox7.Checked);
    WriteBool(OPT,'CreationTime',CheckBox8.Checked);
    WriteString(OPT,'Disk',Edit1.Text);
    WriteInteger(OPT,'ColorAdd',ComboBox1.ItemIndex);
    WriteInteger(OPT,'ColorRemove',ComboBox2.ItemIndex);
    WriteInteger(OPT,'ColorRenamedFile',ComboBox3.ItemIndex);
    WriteInteger(OPT,'ColorRenamedDir',ComboBox4.ItemIndex);
    WriteInteger(OPT,'ColorModificationFile',ComboBox5.ItemIndex);
    WriteInteger(OPT,'ColorLastAccess',ComboBox6.ItemIndex);
    WriteInteger(OPT,'ColorLastWrite',ComboBox7.ItemIndex);
    WriteInteger(OPT,'ColorTime',ComboBox8.ItemIndex);

   //WriteBool(OPT,'SaveOptions',CheckBox1.Checked);
   //WriteInteger(OPT,'Compress',Combobox1.ItemIndex);
   //WriteInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
   Free;
   end;
end;

procedure TForm2.ReadOptions;    // ################### Options Read
var
  OPT:string;
begin
  OPT := 'Options';
  if FileExists(MainDir + 'Data\Options\Options.ini') then
  begin
  TIF:=TIniFile.Create(MainDir + 'Data\Options\Options.ini');
  with TIF do
  begin
    CheckBox1.Checked:=ReadBool(OPT,'Add',CheckBox1.Checked);
    CheckBox2.Checked:=ReadBool(OPT,'Remove',CheckBox2.Checked);
    CheckBox3.Checked:=ReadBool(OPT,'Renamed',CheckBox3.Checked);
    CheckBox4.Checked:=ReadBool(OPT,'RenamedDir',CheckBox4.Checked);
    CheckBox5.Checked:=ReadBool(OPT,'Modi',CheckBox5.Checked);
    CheckBox6.Checked:=ReadBool(OPT,'LastAccess',CheckBox6.Checked);
    CheckBox7.Checked:=ReadBool(OPT,'LastWrite',CheckBox7.Checked);
    CheckBox8.Checked:=ReadBool(OPT,'CreationTime',CheckBox8.Checked);
    Edit1.Text:=ReadString(OPT,'Disk',Edit1.Text);
    Combobox1.ItemIndex:=ReadInteger(OPT,'ColorAdd',ComboBox1.ItemIndex);
    Combobox2.ItemIndex:=ReadInteger(OPT,'ColorRemove',ComboBox2.ItemIndex);
    Combobox3.ItemIndex:=ReadInteger(OPT,'ColorRenamedFile',ComboBox3.ItemIndex);
    Combobox4.ItemIndex:=ReadInteger(OPT,'ColorRenamedDir',ComboBox4.ItemIndex);
    Combobox5.ItemIndex:=ReadInteger(OPT,'ColorModificationFile',ComboBox5.ItemIndex);
    Combobox6.ItemIndex:=ReadInteger(OPT,'ColorLastAccess',ComboBox6.ItemIndex);
    Combobox7.ItemIndex:=ReadInteger(OPT,'ColorLastWrite',ComboBox7.ItemIndex);
    Combobox8.ItemIndex:=ReadInteger(OPT,'ColorTime',ComboBox8.ItemIndex);

  //CheckBox1.Checked:=ReadBool(OPT,'SaveOptions',CheckBox1.Checked);
  //Combobox1.ItemIndex:=ReadInteger(OPT,'Compress',combobox1.ItemIndex);
  //RadioGroup1.ItemIndex:=ReadInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
  Free;
  end;
  end;
end;

function VarToInt(const AVariant: Variant): INT64;
begin
    Result := StrToIntDef(Trim(VarToStr(AVariant)), 0);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  WriteOptions;
  Sleep(50);
  Button2.Enabled := false;
  Screen.Cursor := crDefault;
  StatusBar1.Panels[0].Text := 'Sniffer Mode Saved..';
end;

procedure TForm2.Button3Click(Sender: TObject);
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;

var
  Dir : string;
  s : String;
  Temp          : TLaufwerkstyp;
  TempStr       : string;
  DevIoHandle   : THandle;
  StoDevNum     : _Storage_Device_Number;
  Ergebnis      : boolean;
  Gelesen       : DWord;
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin
  if SelectDirectory('Select directory', '', Dir) then
  Edit1.Text := Dir;
  Screen.Cursor := crHourGlass;
  s:= Edit1.Text;
  //caption:= LeftStr(s, Length(s)- 2);
  TempStr := Copy(Edit1.Text, 0, 2);

  // Für andere Laufwerksbuchstaben nur TempStr abändern.

  //TempStr := Caption;
  //Label1.Caption := 'Laufwerk: ' + TempStr;

  // Abfrage nur sinnvoll bei virtuellen / physikalischen Laufwerken

  Temp := TLaufwerkstyp(GetDriveType(PChar(TempStr)));

  if Temp <> dtFixed then
    ShowMessage('Keine virtuelle / physikalische Festplatte!')
  else
    begin
      // Mit DeviceIoControl zu einem Laufwerksbuchstaben die Nummer (n) für
      // PHYSICALDRIVEn und die Nummer der Partition auf dem jeweiligen
      // Laufwerk ermitteln.

      TempStr := '\\.\' + TempStr;
      DevIoHandle := CreateFile(PChar(TempStr),
                                Generic_Read,
                                File_Share_Read or File_Share_Write,
                                nil,
                                Open_Existing,
                                0,
                                0);

      if DevIoHandle = Invalid_Handle_Value then
        ShowMessage('Fehler bei CreateFile!')
      else
        begin
          Ergebnis := DeviceIoControl(DevIoHandle,
                                      IoCtl_Storage_Get_Device_Number,
                                      nil,
                                      0,
                                      @StoDevNum,
                                      SizeOf(StoDevNum),
                                      Gelesen,
                                      nil);
          CloseHandle(DevIoHandle);
        end;

      if not Ergebnis then
        ShowMessage('Fehler bei DeviceIoControl!')
      else
        begin
          // Abfrage der Fabrikationsseriennummer

          //Label2.Caption := 'DeviceNumber: ' + IntToStr(StoDevNum.DeviceNumber);
          //Label2.Caption := 'PartitionNumber: ' + IntToStr(StoDevNum.PartitionNumber);

          CoInitialize(nil);
          FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
          FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
          FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive', 'WQL', wbemFlagForwardOnly);
          oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

          TempStr := '\\.\PHYSICALDRIVE' + IntToStr(StoDevNum.DeviceNumber);

          while oEnum.Next(1, FWbemObject, iValue) = 0 do
            begin
              if FWbemObject.DeviceID = TempStr then
                begin
                  Label3.Caption :=  FWbemObject.Model;
                  Label4.Caption :=  FWbemObject.Manufacturer;
                  Label7.Caption :=  FWbemObject.Description;
                  Label10.Caption := FWbemObject.SerialNumber;
                  Label12.Caption := FWbemObject.MediaType;

                  // Bei virtuellen Laufwerken gibt es keine Fabrikationsseriennummer!

                  //if not VarIsNull(FWbemObject.SerialNumber) then
                    //Label5.Caption := 'Seriennummer: ' + Trim(FWbemObject.SerialNumber)
                  //else
                  //  Label5.Caption := 'Keine Seriennummer, da virtuelles Laufwerk!';
                end;
              FWbemObject := Unassigned;
            end;
          CoUninitialize;
        end;
    end;
    Screen.Cursor := crDefault;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  ComboBox1.ItemIndex := 2;
  ComboBox1.ItemIndex := 1;
  ComboBox1.ItemIndex := 5;
  ComboBox1.ItemIndex := 11;
  ComboBox1.ItemIndex := 7;
  ComboBox1.ItemIndex := 6;
  ComboBox1.ItemIndex := 3;
  ComboBox1.ItemIndex := 12;
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
  begin
    Form1.AddFile := true;
    ComboBox1.Enabled := true;
  end else begin
    Form1.AddFile := false;
    ComboBox1.Enabled := false;
  end;
  Button2.Enabled := true;
end;

procedure TForm2.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked = true then
  begin
    Form1.RemoveFile := true;
    ComboBox2.Enabled := true;
  end else begin
    Form1.RemoveFile := false;
    ComboBox2.Enabled := false;
  end;
end;

procedure TForm2.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked = true then
  begin
    Form1.RenameFile := true;
    ComboBox3.Enabled := true;
  end else begin
    Form1.RenameFile := false;
    ComboBox3.Enabled := false;
  end;
end;

procedure TForm2.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked = true then
  begin
    Form1.RenameDir := true;
    ComboBox4.Enabled := true;
  end else begin
    Form1.RenameDir := false;
    ComboBox4.Enabled := false;
  end;
end;

procedure TForm2.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked = true then
  begin
    Form1.Modification := true;
    ComboBox5.Enabled := true;
  end else begin
    Form1.Modification := false;
    ComboBox5.Enabled := false;
  end;
end;

procedure TForm2.CheckBox6Click(Sender: TObject);
begin
  if CheckBox6.Checked = true then
  begin
    Form1.LastAccess := true;
    ComboBox6.Enabled := true;
  end else begin
    Form1.LastAccess := false;
    ComboBox6.Enabled := false;
  end;
end;

procedure TForm2.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.Checked = true then
  begin
    Form1.LastWrite := true;
    ComboBox7.Enabled := true;
  end else begin
    Form1.LastWrite := false;
    ComboBox7.Enabled := false;
  end;
end;

procedure TForm2.CheckBox8Click(Sender: TObject);
begin
  if CheckBox8.Checked = true then
  begin
    Form1.CreationTime := true;
    ComboBox8.Enabled := true;
  end else begin
    Form1.CreationTime := false;
    ComboBox8.Enabled := false;
  end;
end;

procedure TForm2.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox1.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox2.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox3DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox3.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox4DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox4.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox5DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox5.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox6DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox6.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox7DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox7.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.ComboBox8DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do
  begin
    FillRect(Rect);
    TextOut(30, Rect.Top, ComboBox8.Items[Index]);
    Pen.Color   := clBlack;
    Brush.Color := ColorConst[Index];
    Rectangle(Rect.Left + 2, Rect.Top + 2, 24,
      Rect.Top + 15);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(ColorNames) to High(ColorNames) do
  begin
    ComboBox1.Items.Add(ColorNames[i]);
    ComboBox2.Items.Add(ColorNames[i]);
    ComboBox3.Items.Add(ColorNames[i]);
    ComboBox4.Items.Add(ColorNames[i]);
    ComboBox5.Items.Add(ColorNames[i]);
    ComboBox6.Items.Add(ColorNames[i]);
    ComboBox7.Items.Add(ColorNames[i]);
    ComboBox8.Items.Add(ColorNames[i]);
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  ReadOptions;
end;

end.
