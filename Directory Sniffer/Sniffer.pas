{$I Directives.inc}

unit Sniffer;

interface

uses
  Windows, SysUtils, Classes;
type
  TDirChangeNotifier = class;
  TDirChangeNotification = (dcnFileAdd, dcnFileRemove, dcnRenameFile,
   dcnRenameDir, dcnModified, dcnLastWrite, dcnLastAccess,
   dcnCreationTime);
  TDirChangeNotifications = set of TDirChangeNotification;
  TDirChangeEvent = procedure (Sender: TDirChangeNotifier;
   const FileName, OtherFileName: WideString;
   Action: TDirChangeNotification) of object;
  TDirChangeNotifier = class(TThread)
  private
    FDir: WideString;
    FDirHandle: THandle;
    FNotifList: TDirChangeNotifications;
    FTermEvent: THandle;
    FOverlapped: TOverlapped;
    FOnChange: TDirChangeEvent;
    FFileName: WideString;
    FOtherFileName: WideString;
    FAction: TDirChangeNotification;
  protected
    function WhichAttrChanged(const AFileName: WideString): TDirChangeNotification;
    procedure Execute; override;
    procedure DoChange;
  public
    constructor Create(const ADirectory: WideString;
     WantedNotifications: TDirChangeNotifications);
    destructor Destroy; override;
    procedure Terminate; reintroduce;
    property OnChange: TDirChangeEvent read FOnChange write FOnChange;
  end;

const
  FILE_LIST_DIRECTORY = $0001;
  FILE_READ_ATTRIBUTES = $0080;
  CNotificationFilters: array[TDirChangeNotification] of Cardinal = (0, 0,
   FILE_NOTIFY_CHANGE_FILE_NAME,
   FILE_NOTIFY_CHANGE_DIR_NAME,
   FILE_NOTIFY_CHANGE_SIZE,
   FILE_NOTIFY_CHANGE_LAST_WRITE,
   FILE_NOTIFY_CHANGE_LAST_ACCESS,
   FILE_NOTIFY_CHANGE_CREATION);
  CAllNotifications: TDirChangeNotifications = [dcnFileAdd, dcnFileRemove,
   dcnRenameFile, dcnRenameDir, dcnModified, dcnLastWrite,
   dcnLastAccess, dcnCreationTime];

implementation

constructor TDirChangeNotifier.Create(const ADirectory: WideString;
 WantedNotifications: TDirChangeNotifications);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FDir := ExcludeTrailingPathDelimiter(ADirectory);
  FNotifList := WantedNotifications;
end;

destructor TDirChangeNotifier.Destroy;
begin
  inherited Destroy;
end;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  SysTime: TSystemTime;
  TimeZoneInfo: TTimeZoneInformation;
  Bias: Double;
begin
  FileTimeToSystemTime(FileTime, SysTime);
  GetTimeZoneInformation(TimeZoneInfo);
  Bias := TimeZoneInfo.Bias / 1440; 
  Result := SystemTimeToDateTime(SysTime) - Bias;
end;

function TDirChangeNotifier.WhichAttrChanged(const AFileName: WideString):
  TDirChangeNotification;
var
  hFile: THandle;
  FCreation, FModification, FAccess: TFileTime;
  Creation, Modification, Access: TDateTime;
begin
  hFile := CreateFileW(PWideChar(AFileName), FILE_READ_ATTRIBUTES,
    FILE_SHARE_READ or FILE_SHARE_DELETE or FILE_SHARE_WRITE, nil,
    OPEN_EXISTING, 0, 0);

  if hFile = 0 then
  begin
    Result := dcnModified;
    Exit;
  end;
  GetFileTime(hFile, @FCreation, @FAccess, @FModification);
  Creation := FileTimeToDateTime(FCreation);
  Access := FileTimeToDateTime(FAccess);
  Modification := FileTimeToDateTime(FModification);

  if Now - Access <= 20.0 then
    Result := dcnLastAccess
  else if Now - Modification <= 20.0 then
    Result := dcnLastWrite
  else if Now - Creation <= 20.0 then
    Result := dcnCreationTime
  else
    Result := dcnModified;

  CloseHandle(hFile);
end;

procedure TDirChangeNotifier.Execute;
var
  Buffer: array[0..4095] of Byte;
  BytesReturned: Cardinal;
  WaitHandles: array[0..1] of THandle;
  NotifyFilter, I, Next, Action, FileNameLength: Cardinal;
  FileName: WideString;
  FmtSettings: TFormatSettings;
  N: TDirChangeNotification;
begin
  FTermEvent := CreateEvent(nil, True, False, nil);
  FillChar(FOverlapped, SizeOf(TOverlapped), 0);
  FOverlapped.hEvent := CreateEvent(nil, True, False, nil);
  FDirHandle := CreateFileW(PWideChar(FDir), FILE_LIST_DIRECTORY,
    FILE_SHARE_READ or FILE_SHARE_DELETE or FILE_SHARE_WRITE, nil,
    OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS or FILE_FLAG_OVERLAPPED, 0);
  WaitHandles[0] := FTermEvent;
  WaitHandles[1] := FOverlapped.hEvent;
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FmtSettings);
  NotifyFilter := 0;

  for N := Low(TDirChangeNotification) to High(TDirChangeNotification) do
    if N in FNotifList then
      Inc(NotifyFilter, CNotificationFilters[N]);
  while True do
  begin
    ReadDirectoryChangesW(FDirHandle, @Buffer, SizeOf(Buffer), True,
     NotifyFilter, nil, @FOverlapped, nil);
    if WaitForMultipleObjects(2, @WaitHandles, False,
      INFINITE) = WAIT_OBJECT_0 then
      Break;
    GetOverlappedResult(FDirHandle, FOverlapped, BytesReturned, False);
    I := 0;
    repeat
      Move(Buffer[I], Next, 4);
      Move(Buffer[I + 4], Action, 4);
      case Action of
        FILE_ACTION_ADDED: FAction := dcnFileAdd;
        FILE_ACTION_REMOVED: FAction := dcnFileRemove;
        FILE_ACTION_MODIFIED: FAction := dcnModified;
        FILE_ACTION_RENAMED_OLD_NAME,
        FILE_ACTION_RENAMED_NEW_NAME: FAction := dcnRenameFile;
      end;
      Move(Buffer[I + 8], FileNameLength, 4);
      SetLength(FileName, FileNameLength div 2);
      Move(Buffer[I + 12], FileName[1], FileNameLength);
      if (FAction = dcnModified) and FileExists(FDir + '\' + FileName) then
        FAction := WhichAttrChanged(FDir + '\' + FileName);
      if Action = FILE_ACTION_RENAMED_NEW_NAME then
      begin
        FOtherFileName := FDir + '\' + FileName;
        if DirectoryExists(FOtherFileName) then
          FAction := dcnRenameDir;
      end
      else
      begin
        FFileName := FDir + '\' + FileName;
        FOtherFileName := '';
      end;
      if (Action <> FILE_ACTION_RENAMED_OLD_NAME)
      and (FAction in FNotifList) then
        Synchronize(DoChange);
      Inc(I, Next);
    until Next = 0;
  end;

  CloseHandle(FTermEvent);
  FTermEvent := 0;
  CloseHandle(FOverlapped.hEvent);
  CloseHandle(FDirHandle);
end;

procedure TDirChangeNotifier.Terminate;
begin
  if FTermEvent <> 0 then
    SetEvent(FTermEvent);
end;

procedure TDirChangeNotifier.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self, FFileName, FOtherFileName, FAction);
end;
end.

