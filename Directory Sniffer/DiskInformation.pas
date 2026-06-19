unit DiskInformation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, WinApi.ActiveX, System.Win.ComObj;

type
  TForm4 = class(TForm)
    RichEdit1: TRichEdit;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}
procedure HightLight_Syntax(ARE : TRichEdit);
//{$REGION 'Sub-functions'}
// Sub-function visible only within HighLight_Syntax and having access to ARE.
procedure HighLight_Others(AStart, AEnd : String; AColor : TColor);
var
  iNext, iPos, iPos_End : Integer;
begin
  iNext := 0;
  iPos := ARE.FindText(AStart, iNext, Length(ARE.Text), [stMatchCase]);
  // FindText returns -1 if it does not find AStart in the RichEdit.
  while iPos <> -1 do
  begin
    // We narrow down the text to be scanned so as not to get
    // stuck in a loop on the same word.
    iNext := iPos + Length(AStart);
    // The starting position of the RichEdit is initialized.
    ARE.SelStart := iPos;
    // We are looking for the position of the second character that
    // should stop the coloring.
    iPos_End := ARE.FindText(AEnd, iNext, Length(ARE.Text), [stMatchCase]);
    if iPos_End = -1 then
      if AStart = '''' then
        // When it involves the start of a string ('), the coloring continues
        // to the end of the line.
        iPos_End := ARE.FindText(#13, iNext, Length(ARE.Text), [stMatchCase])
      else
        // By default, if the closing character is missing, coloring ends
        // at the end of the text.
        iPos_End := Length(ARE.Text);
    // You define the extent to which the text should be colored.
    ARE.SelLength := (iPos_End  - iPos) + Length(AEnd);
    // And we add color.
    ARE.SelAttributes.Color := AColor;
    if AStart = '''' then
      // When dealing with the opening of a chain, the position of the next
      // chain must begin after the closing of the last chain.
      iPos := ARE.FindText('''', iNext + iPos_End, Length(ARE.Text), [stMatchCase])
    else
      iPos := ARE.FindText(AStart, iNext, Length(ARE.Text), [stMatchCase]);
  end;
end;
//{$ENDREGION}

var
  SL_Key_Word : TStringList;
  i, iPos, iNext, iPos_Symb_Start, iPos_Symb_End, iTest : Integer;
  C_Path : string;
begin
  // keywords path
  C_Path := ExtractFilePath(Application.ExeName) + 'Data\Disk\Disk.txt';
  ARE.SelectAll;
  ARE.SelAttributes.Color := clBlack;
  SL_Key_Word := TStringList.Create;
  try
    SL_Key_Word.LoadFromFile(C_Path);
    i := 0;
    while i < SL_Key_Word.Count do
    begin
      iNext := 0;
      // Only WHOLE words matching a keyword are sought.
      iPos := ARE.FindText(SL_Key_Word[i], iNext, Length(ARE.Text), [stWholeWord]);
      while iPos <> -1 do
      begin
        // // To prevent words preceded by "_" from being colored as well
        // (FindText doesn't handle that)
        iPos_Symb_Start := ARE.FindText('_', iPos - 1, 1, [stMatchCase]);
        // If the position is 0, it means there is necessarily no "_" before
        // it. This prevents iPos - iPos_Symb_Start from equaling 1.
        if iPos = 0 then
          iTest := 0
        else
          iTest := iPos - iPos_Symb_Start;

        // To prevent words followed by "_" from being colored as well
        iPos_Symb_End := ARE.FindText('_', iPos, Length(SL_Key_Word[i]) + 1, [stMatchCase]);
        // If the word is not surrounded by "_"
        if (iTest <> 1) and (((Length(SL_Key_Word[i]) + iPos) - iPos_Symb_End) + 1 <> 1) then
        begin
          // The next search starts from the end of the last keyword found.
          iNext := iPos + Length(SL_Key_Word[i]);
          ARE.SelStart := iPos;
          ARE.SelLength := Length(SL_Key_Word[i]);
          ARE.SelAttributes.Color := clNavy;
        end
        else
          // Here, it is not a keyword.
          iNext := iPos + Length(SL_Key_Word[i]) - 1;

        // Searching for the next keyword
        iPos := ARE.FindText(SL_Key_Word[i], iNext, Length(ARE.Text), [stWholeWord]);
      end;
      inc(i);
    end;

    // highlighted standard keywords
    HighLight_Others('SSD', ' ', clTeal);
    HighLight_Others('HDD', ' ', clTeal);
    HighLight_Others('HardDisk', ' ', clTeal);
    HighLight_Others('Integrated', ' ', $003773a3);
    HighLight_Others('Bus', ' ', $003773a3);
    HighLight_Others('Device', ' ', $003773a3);
    HighLight_Others('Adapter', ' ', $003773a3);
    HighLight_Others('Function', ' ', $003773a3);
    HighLight_Others('Port', ' ', $003773a3);
    HighLight_Others('\\', #13, clMaroon); // #13 represents the line break
    HighLight_Others('{', '}', clGreen);
    HighLight_Others('False', ' ', clRed);
    HighLight_Others('True', ' ', clGreen);
  finally
    SL_Key_Word.Free;
  end;
end;

 // Unlike StrToInt, the program does not crash with an
 // EConvertError exception when encountering an invalid string.
function VarToInt(const AVariant: Variant): INT64;
begin
    Result := StrToIntDef(Trim(VarToStr(AVariant)), 0);
end;


procedure TForm4.FormCreate(Sender: TObject);
const
  ScrollBarA: array[0..3] of TScrollStyle = (
    ssBoth,ssHorizontal,ssNone,ssVertical);
begin
  // create the ScrollBars to RiochEdit
  RichEdit1.ScrollBars := ScrollBarA[0];
  RichEdit1.WordWrap := False;
end;

procedure TForm4.FormShow(Sender: TObject);
const
  WbemUser ='';
  WbemPassword ='';
  WbemComputer ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  // OleVariant variable representing a single instance of a
  // WMI (Windows Management Instrumentation) object. It typically wraps
  // an underlying ISWbemObject COM interface reference.
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;  // WMI instance variable
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i             : integer;
begin
  StatusBar1.Panels[3].Text := 'scanning local disks..';
  i := 0;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer,
                   'root\Microsoft\Windows\Storage', WbemUser, WbemPassword);
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM MSFT_PhysicalDisk',
                   'WQL',wbemFlagForwardOnly);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    try
    i := i + 1;
    RichEdit1.Lines.Add('                   Disk : ' + IntToStr(i) + ' ->');
    RichEdit1.Lines.Add(Format('          AllocatedSize : %d',[VarToInt(FWbemObject.AllocatedSize)]));
    RichEdit1.Lines.Add(Format('                BusType : %d',[VarToInt(FWbemObject.BusType)]));
    //RichEdit1.Lines.Add(Format('CannotPoolReason   %d',[VarToInt(FWbemObject.CannotPoolReason)]));
    RichEdit1.Lines.Add(Format('                CanPool : %s',[VarToStr(FWbemObject.CanPool)]));
    RichEdit1.Lines.Add(Format('            Description : %s',[VarToStr(FWbemObject.Description)]));
    RichEdit1.Lines.Add(Format('               DeviceID : %s',[VarToStr(FWbemObject.DeviceId)]));
    RichEdit1.Lines.Add(Format('        EnclosureNumber : %d',[VarToInt(FWbemObject.EnclosureNumber)]));
    RichEdit1.Lines.Add(Format('        FirmwareVersion : %s',[VarToStr(FWbemObject.FirmwareVersion)]));
    RichEdit1.Lines.Add(Format('           FriendlyName : %s',[VarToStr(FWbemObject.FriendlyName)]));
    RichEdit1.Lines.Add(Format('           HealthStatus : %d',[VarToInt(FWbemObject.HealthStatus)]));
    RichEdit1.Lines.Add(Format('    IsIndicationEnabled : %s',[VarToStr(FWbemObject.IsIndicationEnabled)]));
    RichEdit1.Lines.Add(Format('              IsPartial : %s',[VarToStr(FWbemObject.IsPartial)]));
    RichEdit1.Lines.Add(Format('      LogicalSectorSize : %d',[VarToInt(FWbemObject.LogicalSectorSize)]));
    RichEdit1.Lines.Add(Format('           Manufacturer : %s',[VarToStr(FWbemObject.Manufacturer)]));
    RichEdit1.Lines.Add(Format('              MediaType : %d',[VarToInt(FWbemObject.MediaType)]));
    RichEdit1.Lines.Add(Format('                  Model : %s',[VarToStr(FWbemObject.Model)]));
    RichEdit1.Lines.Add(Format('               ObjectId : %s',[VarToStr(FWbemObject.ObjectId)]));
    //Memo1.Lines.Add(Format('OperationalStatus   %d',[VarToInt(FWbemObject.OperationalStatus)]));
    RichEdit1.Lines.Add(Format('  PoolReasonDescription : %s',[VarToStr(FWbemObject.OtherCannotPoolReasonDescription)]));
    RichEdit1.Lines.Add(Format('             PartNumber : %s',[VarToStr(FWbemObject.PartNumber)]));
    RichEdit1.Lines.Add(Format('       PassThroughClass : %s',[VarToStr(FWbemObject.PassThroughClass)]));
    RichEdit1.Lines.Add(Format('         PassThroughIds : %s',[VarToStr(FWbemObject.PassThroughIds)]));
    RichEdit1.Lines.Add(Format('   PassThroughNamespace : %s',[VarToStr(FWbemObject.PassThroughNamespace)]));
    RichEdit1.Lines.Add(Format('      PassThroughServer : %s',[VarToStr(FWbemObject.PassThroughServer)]));
    RichEdit1.Lines.Add(Format('       PhysicalLocation : %s',[VarToStr(FWbemObject.PhysicalLocation)]));
    RichEdit1.Lines.Add(Format('     PhysicalSectorSize : %d',[VarToInt(FWbemObject.PhysicalSectorSize)]));
    RichEdit1.Lines.Add(Format('           SerialNumber : %s',[VarToStr(FWbemObject.SerialNumber)]));
    RichEdit1.Lines.Add(Format('                   Size : %d',[VarToInt(FWbemObject.Size)]));
    RichEdit1.Lines.Add(Format('             SlotNumber : %d',[VarToInt(FWbemObject.SlotNumber)]));
    RichEdit1.Lines.Add(Format('        SoftwareVersion : %s',[VarToStr(FWbemObject.SoftwareVersion)]));
    RichEdit1.Lines.Add(Format('           SpindleSpeed : %d',[VarToInt(FWbemObject.SpindleSpeed)]));
    //Label32.Caption := (Format('SupportedUsages       %d',[VarToInt(FWbemObject.SupportedUsages)]));
    RichEdit1.Lines.Add(Format('               UniqueId : %s',[VarToStr(FWbemObject.UniqueId)]));
    RichEdit1.Lines.Add(Format('                  Usage : %d',[VarToInt(FWbemObject.Usage)]));
    RichEdit1.Lines.Add('               End Disk : ' + IntToStr(i) + ' ------>');
    RichEdit1.Lines.Add('');
    RichEdit1.Lines.Add('_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________');
    RichEdit1.Lines.Add('');
    FWbemObject:=Unassigned;
    except
    end;
  end;

  HightLight_Syntax(RichEdit1);
  StatusBar1.Panels[1].Text := IntToStr(i);
  StatusBar1.Panels[3].Text := 'finish';
end;



end.
