unit unMedCart;

interface

uses
  System.JSON, unGlobalConst, system.SysUtils;

type
    TGender = (gMale, gFemale);

    TMedCart = class
      private
        FId: Integer;
        FSurname: string;
        FFirstName: string;
        FPatronymic: string;
        FBirthDay: TDate;
        FGender: TGender;
        FPhone: string;
        FPlaceWork: string;
      public
        property Id: Integer read FId;
        property Surname: string read FSurname;
        property FirstName: string read FFirstName;
        property Patronymic: string read FPatronymic;
        property Birthday: TDate read FBirthDay;
        property Gender: TGender read FGender;
        property Phone: string read FPhone;
        property PlaceWork: string read FPlaceWork;

        //Установщики полей ввиде билдеров
        function SetId(aId: Integer): TMedCart;
        function SetSurname(aSurname: string): TMedCart;
        function SetFirstName(aFirstName: string): TMedCart;
        function SetPatronymic(aPatronymic: string): TMedCart;
        function SetBirthday(aBirthday: TDate): TMedCart;
        function SetGender(aGender: TGender): TMedCart;
        function SetPhone(aPhone: string): TMedCart;
        function SetPlaceWork(aPlaceWork: string): TMedCart;

        procedure Copy(aOther: TMedCart);
        function Equals(Obj: TObject): Boolean; override;
        function ToJSON: TJSONObject;
        function SurnameAndInitials: string;
        function Clone: TMedCart;
    end;

implementation

{ TMedCart }

function TMedCart.Clone: TMedCart;
begin
  Result := TMedCart.Create;
  Result.Copy(Self);
end;

procedure TMedCart.Copy(aOther: TMedCart);
begin
  SetId(aOther.Id)
  .SetSurname(aOther.Surname)
  .SetFirstName(aOther.FirstName)
  .SetPatronymic(aOther.Patronymic)
  .SetBirthday(aOther.Birthday)
  .SetGender(aOther.Gender)
  .SetPhone(aOther.Phone)
  .SetPlaceWork(aOther.PlaceWork);
end;

function TMedCart.Equals(Obj: TObject): Boolean;
var
  other: TMedCart;
begin
  if not(Obj is TMedCart) then
    Result := inherited
  else begin
    other := TMedCart(Obj);
    Result := (FId = other.Id)
              and (FSurname = other.Surname)
              and (FFirstName = other.FirstName)
              and (FPatronymic = other.Patronymic)
              and (FBirthDay = other.Birthday)
              and (FGender = other.Gender)
              and (FPhone = other.Phone)
              and (FPlaceWork = other.PlaceWork);
  end;
end;

function TMedCart.SetBirthday(aBirthday: TDate): TMedCart;
begin
  FBirthDay := aBirthday;
  Result := Self;
end;

function TMedCart.SetFirstName(aFirstName: string): TMedCart;
begin
    FFirstName := aFirstName;
    Result := Self;
end;

function TMedCart.SetGender(aGender: TGender): TMedCart;
begin
    FGender := aGender;
    Result := Self;
end;

function TMedCart.SetId(aId: Integer): TMedCart;
begin
  FId := aId;
  Result := Self;
end;

function TMedCart.SetPatronymic(aPatronymic: string): TMedCart;
begin
    FPatronymic := aPatronymic;
    Result := Self;
end;

function TMedCart.SetPhone(aPhone: string): TMedCart;
begin
    FPhone := aPhone;
    Result := Self;
end;

function TMedCart.SetPlaceWork(aPlaceWork: string): TMedCart;
begin
    FPlaceWork := aPlaceWork;
    Result := Self;
end;

function TMedCart.SetSurname(aSurname: string): TMedCart;
begin
  FSurname := aSurname;
  Result := Self;
end;

function TMedCart.SurnameAndInitials: string;
begin
  Result := Surname + ' ' + FirstName[1] + '.' + Patronymic[1] + '.';
end;

function TMedCart.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;

  Result.AddPair(FIELD_ID, TJSONNumber.Create(FId));
  Result.AddPair(FIELD_SURNAME, FSurname);
  Result.AddPair(FIELD_FIRSTNAME, FFirstName);
  Result.AddPair(FIELD_PATRONYMIC, FPatronymic);
  Result.AddPair(FIELD_BIRTHDAY, DateToStr(FBirthDay));
  Result.AddPair(FIELD_GENDER, TJSONNumber.Create((Integer(FGender))));
  Result.AddPair(FIELD_PHONE, FPhone);
  Result.AddPair(FIELD_PLACEWORK, FPlaceWork);
end;

end.
