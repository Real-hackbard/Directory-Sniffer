unit DiskProperties;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls, HSObjectList,
  System.Math;

type
  TDriveType = (dtFloppy, dtFixed, dtCDROM, dtNetwork, dtRemovable, dtRamDisk,
    dtError);

  TDriveInfo = class
  private
    FDriveType: TDriveType;
    FDriveName: string;
    FFileSystemName: string;
    FVolumeName: string;
    FFileSystemFlags: DWORD;
    FInformationValid: Boolean;
    FFreeBytes: TLargeInteger;
    FTotalBytes: TLargeInteger;
    FTotalFree: TLargeInteger;
    FSerialNumber: DWORD;
    function GetDisplayName: string;
    function GetDefaultVolumeName: string;
    function GetPercentUsed: Integer;
  public
    { Public-Deklarationen}
    procedure FillInformation;
    property DisplayName: string read GetDisplayName;
    property PercentUsed: Integer read GetPercentUsed;
    property DriveType: TDriveType read FDriveType write FDriveType;
    property DriveName: string read FDriveName write FDriveName;
    property FileSystemName: string read FFileSystemName;
    property FileSystemFlags: DWORD read FFileSystemFlags;
    property InformationValid: Boolean read FInformationValid;
    property VolumeName: string read FVolumeName;
    property TotalBytes: TLargeInteger read FTotalBytes;
    property FreeBytes: TLargeInteger read FFreeBytes;
    property TotalFree: TLargeInteger read FTotalFree;
    property SerialNumber: DWORD read FSerialNumber;
  end;

  TDriveInfoList = class(THSObjectList)
  private
    { Private-Deklarationen}
    function GetItems(I: Integer): TDriveInfo;
  public
    { Public-Deklarationen}
    property Items[I: Integer]: TDriveInfo read GetItems; default;
  end;

type
  TForm3 = class(TForm)
    Splitter1: TSplitter;
    ListBox1: TListBox;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Shape2: TShape;
    Shape1: TShape;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    DriveImageList1: TImageList;
    SmallDrivesImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Splitter1Moved(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ListBox3DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    FColorKey: TCOLOR;
    FDriveInfoList: TDriveInfoList;
    FOldListBoxWndProc: TWndMethod;
    FOldFlagsListBoxWndProc: TWndMethod;
    procedure ListBoxWndProc (var Message: TMessage);
    procedure FlagsListBoxWndProc (var Message: TMessage);
    procedure RebuildDriveList;
    procedure DisplayDriveInfo (DriveInfo: TDriveInfo);
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;

const
  LWA_COLORKEY = 1;
  LWA_ALPHA     = 2;
  WS_EX_LAYERED = $80000;

implementation

uses
  HSLUtils;

const
  TopSpacing = 8;
  MiddleSpacing = 7;
  BottomSpacing = 8;
  LeftSpacing = 13;

type
  TSimpleGaugeKind = (sgkBar, sgkPie);

  TSimpleGauge = class
  private
    FColors: array[0..3] of TColor;
    FPercent: Integer;
    FCanvas: TCanvas;
    FBoundsRect: TRect;
    FKind: TSimpleGaugeKind;
    function GetColor(const Index: Integer): TColor;
    procedure SetColor(const Index: Integer; const Value: TColor);
    procedure PaintBar;
    procedure PaintPie;
  public
    constructor Create (ABoundsRect: TRect);
    procedure Paint (ACanvas: TCanvas);
    property BoundsRect: TRect read FBoundsRect;
    property Canvas: TCanvas read FCanvas;
    property Kind: TSimpleGaugeKind read FKind write FKind default sgkBar;
    property Percent: Integer read FPercent write FPercent;
    property UsedColor: TColor index 0 read GetColor write SetColor
      default clRed;
    property FreeColor: TColor index 1 read GetColor write SetColor
      default clLime;
    property TextColor: TColor index 2 read GetColor write SetColor
      default clWhite;
    property FrameColor: TColor index 3 read GetColor write SetColor
      default clBlack;
  end;

{$R *.dfm}
function MakeWindowTransparent(Wnd: HWND; nAlpha: Integer = 10): Boolean;
type
  TSetLayeredWindowAttributes = function(hwnd: HWND; crKey: COLORREF; bAlpha: Byte;
    dwFlags: Longint): Longint;
  stdcall;
var
  hUser32: HMODULE;
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
begin
  Result := False;
  hUser32 := GetModuleHandle('USER32.DLL');
  if hUser32 <> 0 then
  begin @SetLayeredWindowAttributes := GetProcAddress(hUser32, 'SetLayeredWindowAttributes');
    if @SetLayeredWindowAttributes <> nil then
    begin
      SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_LAYERED);
      SetLayeredWindowAttributes(Wnd, 0, Trunc((255 / 100) * (100 - nAlpha)), LWA_ALPHA);
      Result := True;
    end;
  end;
end;

function SetLayeredWindowAttributes(Wnd: hwnd; crKey: ColorRef; Alpha: Byte;
  dwFlags: DWORD): Boolean; stdcall; external 'user32.dll';

procedure DrawCheckBoxMark (Canvas: TCanvas; const Rect: TRect; Color: TColor);
begin
  with Canvas do
  begin
    FillRect(Rect);
    Pen.Color := Color;
    PenPos := Point(Rect.Left+2, Rect.Top+4);
    LineTo(Rect.Left+6, Rect.Top+8);
    PenPos := Point(Rect.Left+2, Rect.Top+5);
    LineTo(Rect.Left+5, Rect.Top+8);
    PenPos := Point(Rect.Left+2, Rect.Top+6);
    LineTo(Rect.Left+5, Rect.Top+9);
    PenPos := Point(Rect.Left+8, Rect.Top+2);
    LineTo(Rect.Left+4, Rect.Top+6);
    PenPos := Point(Rect.Left+8, Rect.Top+3);
    LineTo(Rect.Left+4, Rect.Top+7);
    PenPos := Point(Rect.Left+8, Rect.Top+4);
    LineTo(Rect.Left+5, Rect.Top+7);
  end;
end;

function HSGetDriveInfo (const DriveName: char): TDriveInfo;
var
  DrivePath: string;
  Buffer: array[0..Pred(MAX_PATH)] of char;
begin
  Result := TDriveInfo.Create;
  Result.DriveName := DriveName;
  try
    DrivePath := DriveName + ':\';
    case GetDriveType(PChar(DrivePath)) of
    DRIVE_FIXED:
      Result.DriveType := dtFixed;
    DRIVE_REMOTE:
      Result.DriveType := dtNetwork;
    DRIVE_CDROM:
      Result.DriveType := dtCDROM;
    DRIVE_RAMDISK:
      Result.DriveType := dtRamDisk;
    DRIVE_REMOVABLE:
      begin
        System.Delete (DrivePath, 3, 1);
        if QueryDosDevice (PChar(DrivePath), Buffer, SizeOf(Buffer)) = 0 then
          Result.DriveType := dtError
        else if (SameText(Buffer, '\Device\Floppy0')) then
          Result.DriveType := dtFloppy
        else
          Result.DriveType := dtRemovable;
      end;
    else
      Result.DriveType := dtError;
    end;
    Result.FillInformation;
  except
    Result.Free;
    raise;
  end;
end;

procedure TForm3.RebuildDriveList;
var
  Drive: Char;
  DriveInfo: TDriveInfo;
begin
  FDriveInfoList.Clear;
  ListBox1.Clear;
  ListBox3.Clear;
  for Drive:='A' to 'Z' do
  begin
    DriveInfo := HSGetDriveInfo(Drive);
    if DriveInfo.DriveType <> dtError then
    begin
      FDriveInfoList.Add(DriveInfo);
      ListBox1.Items.AddObject(DriveInfo.DisplayName, DriveInfo);
      ListBox3.Items.AddObject(DriveInfo.DisplayName, DriveInfo);
    end else
      DriveInfo.Free;
  end;
  if ListBox1.Items.Count <> 0 then
    ListBox1.ItemIndex := 0;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDriveInfoList.Free;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  ACanvas: TControlCanvas;
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Handle, ColorToRGB(FColorKey), 210, LWA_ALPHA);

  FOldListBoxWndProc := ListBox1.WindowProc;
  ListBox1.WindowProc := ListBoxWndProc;
  FOldFlagsListBoxWndProc := ListBox2.WindowProc;
  ListBox2.WindowProc := FlagsListBoxWndProc;
  FDriveInfoList := TDriveInfoList.Create;
  ACanvas := TControlCanvas.Create;
  try
    ACanvas.Control := ListBox1;
    ListBox1.ItemHeight := ACanvas.TextHeight('A') + DriveImageList1.Height +
      TopSpacing + MiddleSpacing + BottomSpacing;
  finally
    ACanvas.Free;
  end;
  RebuildDriveList;
end;

procedure TForm3.FormResize(Sender: TObject);
begin
  ListBox3.Invalidate;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  ListBox1.OnClick(sender);
  Panel1.SetFocus;
end;

procedure TForm3.ListBox1Click(Sender: TObject);
begin
  DisplayDriveInfo(TDriveInfo(ListBox1.Items.Objects[ListBox1.ItemIndex]));
end;

procedure TForm3.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Icon: TIcon;
  CaptionRect: TRect;
  Focused: Boolean;
  DriveInfo: TDriveInfo;
begin
  DriveInfo := ListBox1.Items.Objects[Index] as TDriveInfo;
  Focused := [odFocused,odSelected] * State <> [];
  if Focused then
  begin
    ListBox1.Canvas.Font.Color := ListBox1.Font.Color;
    ListBox1.Canvas.Font.Style := ListBox1.Canvas.Font.Style + [fsBold];
    ListBox1.Canvas.Pen.Color := clBtnShadow;
    ListBox1.Canvas.Brush.Color := ListBox1.Color;
    ListBox1.Canvas.RoundRect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom,
      5, 5);
  end else
    ListBox1.Canvas.FillRect(Rect);
  Icon := TIcon.Create;
  try
    DriveImageList1.GetIcon(Integer(DriveInfo.DriveType), Icon);
    ListBox1.Canvas.Draw ((Rect.Right - Rect.Left) div 2 -
      DriveImageList1.Width + LeftSpacing,
      Rect.Top+TopSpacing, Icon);
  finally
    Icon.Free;
  end;

  SetBkMode (ListBox1.Canvas.Handle, TRANSPARENT);
  CaptionRect := Rect;
  Inc(CaptionRect.Top, TopSpacing + MiddleSpacing + DriveImageList1.Height);
  Dec(CaptionRect.Bottom, BottomSpacing);
  DrawTextEx (ListBox1.Canvas.Handle, PChar(ListBox1.Items[Index]), -1,
    CaptionRect, DT_CENTER or DT_SINGLELINE or DT_END_ELLIPSIS or DT_VCENTER,
    nil);
end;

procedure TForm3.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  Checked: Boolean;
  CheckBoxRect: TRect;
begin
  ListBox := Control as TListBox;
  if [odFocused,odSelected] * State <> [] then
  begin
    ListBox.Canvas.Brush.Color := ListBox.Color;
    ListBox.Canvas.Font.Color := ListBox.Font.Color;
  end;
  ListBox.Canvas.FillRect(Rect);
  Checked := ListBox.Items.Objects[Index] <> nil;
  CheckBoxRect := Rect;
  CheckBoxRect.Right := Rect.Left + Rect.Bottom - Rect.Top;
  Inc(Rect.Left, CheckBoxRect.Right - CheckBoxRect.Left + 2);
  if Checked then
  begin
    Inc(CheckBoxRect.Left, ((CheckBoxRect.Right - CheckBoxRect.Left) - 6)
      div 2 - 2);
    Inc(CheckBoxRect.Top, ((CheckBoxRect.Bottom - CheckBoxRect.Top) - 6)
      div 2 - 2);
    DrawCheckBoxMark(ListBox.Canvas, CheckBoxRect, clMaroon);
  end;
  DrawText(ListBox.Canvas.Handle, PChar(ListBox.Items[Index]), -1, Rect,
    DT_SINGLELINE or DT_LEFT or DT_VCENTER);
end;

procedure TForm3.ListBox3DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  DriveInfo: TDriveInfo;
  ListBox: TListBox;
  Icon: TIcon;
  TextRect, GaugeRect: TRect;
  SpaceGauge: TSimpleGauge;
begin
  ListBox := Control as TListBox;
  DriveInfo := ListBox.Items.Objects[Index] as TDriveInfo;

  if [odFocused,odSelected] * State <> [] then
  begin
    ListBox.Canvas.Brush.Color := ListBox.Color;
    ListBox.Canvas.Font.Color := ListBox.Font.Color;
  end;

  ListBox.Canvas.FillRect(Rect);
  Icon := TIcon.Create;
  try
    SmallDrivesImageList1.GetIcon(Integer(DriveInfo.DriveType), Icon);
    ListBox.Canvas.Draw (Rect.Left + 2, Rect.Top + 2, Icon);
  finally
    Icon.Free;
  end;
  TextRect := Rect;
  Inc(TextRect.Left, 8 + SmallDrivesImageList1.Width);
  TextRect.Right := TextRect.Left + Min(ListBox1.Width, 150);
  DrawTextEx (ListBox.Canvas.Handle, PChar(ListBox.Items[Index]), -1,
    TextRect, DT_LEFT + DT_SINGLELINE + DT_VCENTER + DT_END_ELLIPSIS, nil);

  if DriveInfo.InformationValid then
  begin
    GaugeRect := Rect;
    GaugeRect.Left := TextRect.Right + 4;
    Inc(GaugeRect.Top, 2);
    Dec(GaugeRect.Bottom, 2);
    Dec(GaugeRect.Right, 4);
    SpaceGauge := TSimpleGauge.Create(GaugeRect);
    try
      SpaceGauge.Percent := DriveInfo.PercentUsed;
      SpaceGauge.Paint (ListBox.Canvas);
    finally
      SpaceGauge.Free;
    end;
  end;
end;

procedure TForm3.Splitter1Moved(Sender: TObject);
begin
  ListBox1.Invalidate;
  ListBox3.Invalidate;
end;

type
  TListBoxAccess = class(TCustomListBox);

procedure ListBoxCNDrawItem(Control: TListBox; var Message: TWmDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    Control.Canvas.Handle := hDC;
    Control.Canvas.Font := Control.Font;
    Control.Canvas.Brush := Control.Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      Control.Canvas.Brush.Color := clHighlight;
      Control.Canvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then
      TListBoxAccess(Control).DrawItem(itemID, rcItem, State)
    else
      Control.Canvas.FillRect(rcItem);
    Control.Canvas.Handle := 0;
  end;
end;

procedure TForm3.ListBoxWndProc(var Message: TMessage);
begin
  if Message.Msg = CN_DRAWITEM then
    ListBoxCNDrawItem(ListBox1, TWMDrawItem(Message))
  else
    FOldListBoxWndProc (Message);
end;

function FormatDiskSize (Value: TLargeInteger): string;
const
  SizeUnits: array[1..5] of string = (' Bytes', ' KB', ' MB', ' GB', 'TB');
var
  SizeUnit: Integer;
  Temp: TLargeInteger;
  Size: Integer;
  DecimalSeparator : string;
begin
  SizeUnit := 1;
  if Value < 1024 then
    Result := IntToStr(Value)
  else begin
    Temp := Value;
    while (Temp >= 1000*1024) and (SizeUnit <= 5) do
    begin
      Temp := Temp shr 10; //div 1024
      Inc(SizeUnit);
    end;
    Inc(SizeUnit);
    Size := (Temp shr 10); //div 1024
    Temp := Temp - (Size shl 10);
    if Temp > 1000 then
      Temp := 999;
    if Size > 100 then
      Result := IntToStr(Size)
    else if Size > 10 then
      Result := Format('%d%s%.1d', [Size, DecimalSeparator, Temp div 100])
    else
      Result := Format('%d%s%.2d', [Size, DecimalSeparator,
        Temp div 10])
  end;
  Result := Result + SizeUnits[SizeUnit];
end;

const
 FILE_VOLUME_QUOTAS = $00000020;
 FILE_SUPPORTS_SPARSE_FILES   = $00000040;
 FILE_SUPPORTS_REPARSE_POINTS = $00000080;
 FILE_SUPPORTS_OBJECT_IDS = $00010000;
 FILE_SUPPORTS_ENCRYPTION = $00020000;
 FS_FILE_ENCRYPTION = FILE_SUPPORTS_ENCRYPTION;
 FILE_NAMED_STREAMS = $00040000;
 FILE_READ_ONLY_VOLUME = $00080000;

procedure DrawFileSystemFlags (ListBox: TListBox; FileSystemFlags: DWORD);
begin
  ListBox.Clear;
  with ListBox.Items do begin
    AddObject('FILE_NAMED_STREAMS',
      TObject((FileSystemFlags and FILE_NAMED_STREAMS) <> 0));
    AddObject('FILE_READ_ONLY_VOLUME',
      TObject((FileSystemFlags and FILE_READ_ONLY_VOLUME) <> 0));
    AddObject('FILE_SUPPORTS_OBJECT_IDS',
      TObject((FileSystemFlags and FILE_SUPPORTS_OBJECT_IDS) <> 0));
    AddObject('FILE_SUPPORTS_REPARSE_POINTS',
      TObject((FileSystemFlags and FILE_SUPPORTS_REPARSE_POINTS) <> 0));
    AddObject('FILE_SUPPORTS_SPARSE_FILES',
      TObject((FileSystemFlags and FILE_SUPPORTS_SPARSE_FILES) <> 0));
    AddObject('FILE_VOLUME_QUOTAS',
      TObject((FileSystemFlags and FILE_VOLUME_QUOTAS) <> 0));
    AddObject('FS_CASE_IS_PRESERVED',
      TObject((FileSystemFlags and FS_CASE_IS_PRESERVED) <> 0));
    AddObject('FS_CASE_SENSITIVE',
      TObject((FileSystemFlags and FS_CASE_SENSITIVE) <> 0));
    AddObject('FS_FILE_COMPRESSION',
      TObject((FileSystemFlags and FS_FILE_COMPRESSION) <> 0));
    AddObject('FS_FILE_ENCRYPTION',
      TObject((FileSystemFlags and FS_FILE_ENCRYPTION) <> 0));
    AddObject('FS_PERSISTENT_ACLS',
      TObject((FileSystemFlags and FS_PERSISTENT_ACLS) <> 0));
    AddObject('FS_UNICODE_STORED_ON_DISK',
      TObject((FileSystemFlags and FS_UNICODE_STORED_ON_DISK) <> 0));
    AddObject('FS_VOL_IS_COMPRESSED',
      TObject((FileSystemFlags and FS_VOL_IS_COMPRESSED) <> 0));
  end;
end;

procedure TForm3.DisplayDriveInfo(DriveInfo: TDriveInfo);
var
  Bitmap: TBitmap;
  SpaceGauge: TSimpleGauge;
  SerialNo: string;
begin
  Label4.Visible := DriveInfo.InformationValid;
  Label6.Visible := DriveInfo.InformationValid;
  Label7.Visible := DriveInfo.InformationValid;
  Shape1.Visible := DriveInfo.InformationValid;
  Shape2.Visible := DriveInfo.InformationValid;
  ListBox2.Visible := DriveInfo.InformationValid;
  Label5.Visible := DriveInfo.InformationValid;

  if DriveInfo.InformationValid then
  begin
    Label3.Caption := DriveInfo.FileSystemName;
    SerialNo := Format('%.8x', [DriveInfo.SerialNumber]);
    System.Insert('-', SerialNo, 5);
    Label4.Caption := SerialNo;
    Label7.Caption := 'Free: '+FormatDiskSize (DriveInfo.FreeBytes);
    Label6.Caption := 'Used: '+FormatDiskSize (DriveInfo.TotalBytes -
      DriveInfo.FreeBytes);
    DrawFileSystemFlags (ListBox2, DriveInfo.FileSystemFlags);
    SpaceGauge := TSimpleGauge.Create(Image1.ClientRect);
    SpaceGauge.Kind := sgkPie;
    SpaceGauge.Percent := DriveInfo.PercentUsed;
    try
      Bitmap := TBitmap.Create;
      try
        with Bitmap do
        begin
          Height := Image1.Height;
          Width := Image1.Width;
          Canvas.Brush.Color := GroupBox1.Color;
          Canvas.FillRect (Rect(0, 0, Width, Height));
          SpaceGauge.Paint(Canvas);
        end;
        Image1.Picture.Assign (Bitmap);
      finally
        Bitmap.Free;
      end;
    finally
      SpaceGauge.Free;
    end;
  end else
  begin
    Image1.Picture := nil;
    Label3.Caption := 'n/a';
  end;
end;

procedure TForm3.FlagsListBoxWndProc(var Message: TMessage);
begin
  if Message.Msg = CN_DRAWITEM then
    ListBoxCNDrawItem(ListBox2, TWMDrawItem(Message))
  else
    FOldFlagsListBoxWndProc (Message);
end;

{ TDriveInfo }

procedure TDriveInfo.FillInformation;
var
  DrivePath: string;
  OldErrorMode: UINT;
  AVolumeName, AFileSystemName : array [0..Pred(MAX_PATH)] of char;
  ComponentLength: DWORD;
begin
  if DriveType = dtError then
    Exit;
  DrivePath := DriveName + ':\';
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  FVolumeName := GetDefaultVolumeName;
  try
    if GetVolumeInformation(PChar(DrivePath), AVolumeName,
        SizeOf(AVolumeName),
        @SerialNumber, ComponentLength, FFileSystemFlags,
        AFileSystemName, SizeOf(AFileSystemName)) then
        begin
          FInformationValid := true;
          if AVolumeName[0] <> #0 then
            FVolumeName := AVolumeName;
          FFileSystemName := AFileSystemName;
        end;
        if not GetDiskFreeSpaceEx(PChar(DrivePath), FFreeBytes,
            FTotalBytes, @FTotalFree) then
        begin
          FFreeBytes := 0;
          FTotalBytes := 0;
          FTotalFree := 0;
        end;
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

function TDriveInfo.GetDefaultVolumeName: string;
begin
  case FDriveType of
  dtFloppy:
    Result := 'Floppy';
  dtFixed:
    Result := 'Fixed Drive';
  dtCDROM:
    Result := 'CDROM';
  dtNetwork:
    Result := 'Network Drive';
  dtRemovable:
    Result := 'Removable Drive';
  dtRamDisk:
    Result := 'RAM Drive';
  end;
end;

function TDriveInfo.GetDisplayName: string;
begin
  Result := VolumeName + ' ('+DriveName + ':)';
end;



function TDriveInfo.GetPercentUsed: Integer;
begin
  if FInformationValid and (FTotalBytes <> 0) then
  begin
    Result := 100 - ((FFreeBytes * 100) div FTotalBytes);
  end else
    Result := 0;
end;

{ TDriveInfoList }

function TDriveInfoList.GetItems(I: Integer): TDriveInfo;
begin
  Result := TDriveInfo(inherited Items[I]);
end;

{ TSimpleGauge }

constructor TSimpleGauge.Create(ABoundsRect: TRect);
begin
  FBoundsRect := ABoundsRect;
  FKind := sgkBar;
  FColors[0] := clRed;
  FColors[1] := clLime;
  FColors[2] := clWhite;
  FColors[3] := clBlack;
end;

function TSimpleGauge.GetColor(const Index: Integer): TColor;
begin
  Result := FColors[Index];
end;

procedure TSimpleGauge.Paint(ACanvas: TCanvas);
begin
  FCanvas := ACanvas;
  if FKind = sgkBar then
    PaintBar
  else
    PaintPie;
end;

procedure TSimpleGauge.PaintBar;
var
  UsedRect, FreeRect: TRect;
begin
  UsedRect := FBoundsRect;
  FreeRect := FBoundsRect;
  UsedRect.Right := UsedRect.Left + ((FBoundsRect.Right - FBoundsRect.Left) *
    FPercent) div 100;
  FreeRect.Left := UsedRect.Right - 1;
  FCanvas.Brush.Color := UsedColor;
  FCanvas.FillRect(UsedRect);
  FCanvas.Brush.Color := FreeColor;
  FCanvas.FillRect(FreeRect);
  FCanvas.Brush.Color := FrameColor;
  FCanvas.FrameRect(UsedRect);
  FCanvas.FrameRect(FreeRect);
  FCanvas.Font.Color := TextColor;
  SetBkMode (FCanvas.Handle, TRANSPARENT);
  DrawTextEx(FCanvas.Handle, PChar(Format('%d%%', [FPercent])), -1,
    FBoundsRect, DT_CENTER + DT_SINGLELINE + DT_VCENTER, nil);
end;

function GetDarkColor (const SourceColor: TColor): TColor;
var
  H, S, L: Double;
begin
  RGBtoHSL (SourceColor, H, S, L);
  Result := HSLtoRGB(H, S, L - 0.2);
end;

procedure TSimpleGauge.PaintPie;
var
  PieRect, PieBottomRect: TRect;
  Angle, DPercent: Double;
  DarkUsedColor, DarkFreeColor: TColor;
  BottomLeftRgn, BottomRightRgn: HRGN;
  RectRgn, BottomEllipticRgn, TopEllipticRgn: HRGN;
  PieRectWidth, PieRectHeight: Integer;
  MiddleX: Integer;
begin
  DPercent := Percent;
  Angle := 2 * PI * DPercent / 100.0;
  PieRect := FBoundsRect;
  Dec(PieRect.Bottom, 25);
  BottomRightRgn := 0;
  PieRectWidth := PieRect.Right - PieRect.Left;
  PieRectHeight := PieRect.Bottom - PieRect.Top;
  MiddleX := PieRect.Left + PieRectWidth div 2
    - Trunc(PieRectWidth / 2 * cos(Angle));
  PieBottomRect := PieRect;
  OffsetRect (PieBottomRect, 0, 10);
  RectRgn := CreateRectRgnIndirect(Rect(PieRect.Left,
    PieRect.Top + PieRectHeight div 2,
    PieRect.Right, PieBottomRect.Bottom - PieRectHeight div 2));
  BottomEllipticRgn := CreateEllipticRgnIndirect(PieBottomRect);
  TopEllipticRgn := CreateEllipticRgnIndirect(PieRect);
  BottomLeftRgn := CreateRectRgn (0, 0, 0, 0);
  CombineRgn(BottomLeftRgn, RectRgn, BottomEllipticRgn, RGN_OR);
  CombineRgn(BottomLeftRgn, BottomLeftRgn, TopEllipticRgn, RGN_DIFF);
  DeleteObject(RectRgn);
  DeleteObject(BottomEllipticRgn);
  DeleteObject(TopEllipticRgn);
  if Percent > 50 then
  begin
    RectRgn := CreateRectRgn (MiddleX, FBoundsRect.Top, FBoundsRect.Right,
      FBoundsRect.Bottom);
    BottomRightRgn := CreateRectRgn (0, 0, 0, 0);
    CombineRgn (BottomRightRgn, BottomLeftRgn, RectRgn, RGN_AND);
    DeleteObject(RectRgn);
    RectRgn := CreateRectRgn (FBoundsRect.Left, FBoundsRect.Top, Succ(MiddleX),
      FBoundsRect.Bottom);
    CombineRgn (BottomLeftRgn, BottomLeftRgn, RectRgn, RGN_AND);
    DeleteObject(RectRgn);
  end;
  FCanvas.Pen.Color := FrameColor;
  DarkFreeColor := GetDarkColor (FreeColor);
  DarkUsedColor := GetDarkColor (UsedColor);
  FCanvas.Brush.Color := DarkFreeColor;
  FillRgn (FCanvas.Handle, BottomLeftRgn, FCanvas.Brush.Handle);
  FCanvas.Brush.Color := FrameColor;
  FrameRgn (FCanvas.Handle, BottomLeftRgn, FCanvas.Brush.Handle, 1, 1);
  if BottomRightRgn <> 0 then
  begin
    FCanvas.Brush.Color := DarkUsedColor;
    FillRgn (FCanvas.Handle, BottomRightRgn, FCanvas.Brush.Handle);
    FCanvas.Brush.Color := FrameColor;
    FrameRgn (FCanvas.Handle, BottomRightRgn, FCanvas.Brush.Handle, 1, 1);
  end;
  FCanvas.Brush.Color := FreeColor;
  FCanvas.Ellipse(PieRect);
  SetArcDirection (FCanvas.Handle, AD_CLOCKWISE);
  FCanvas.Brush.Color := UsedColor;
  FCanvas.Pie(PieRect.Left, PieRect.Top, PieRect.Right, PieRect.Bottom,
    PieRect.Left,
    PieRect.Top + PieRectHeight div 2,
    PieRect.Left + PieRectWidth div 2
      - Trunc(PieRectWidth / 2 * cos(Angle)),
    PieRect.Top + PieRectHeight div 2
      - Trunc((PieRectHeight / 2) * sin(Angle))
    );
  DeleteObject (BottomLeftRgn);
  if BottomRightRgn <> 0 then
    DeleteObject(BottomRightRgn);
end;

procedure TSimpleGauge.SetColor(const Index: Integer; const Value: TColor);
begin
  FColors[Index] := Value;
end;



end.
