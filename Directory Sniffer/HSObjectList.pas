unit HSObjectList;

interface
uses
  Classes;

type
  THSObjectList = class(TList)
  private
    function GetObjects(I: Integer): TObject;
  public
    property Objects[I: Integer]: TObject read GetObjects; 
    procedure Clear; override;

    procedure RemoveAll;
  end;


implementation

{ THSObjectList }

procedure THSObjectList.Clear;
var 
  I: Integer;
begin
  for I:=0 to Pred(Count) do
    Objects[I].Free;
  inherited;
end;

function THSObjectList.GetObjects(I: Integer): TObject;
begin
  Result := TObject(inherited Items[I]);
end;

procedure THSObjectList.RemoveAll;
var 
  I: Integer;
begin
  for I:=Pred(Count) downto 0 do
    Delete(I);
end;

end.
