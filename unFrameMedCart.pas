unit unFrameMedCart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  unMedCart;

type
  TOnEventFrameMedCart = reference to procedure(aMedCart: TMedCart);
  TFrameMedCart = class(TFrame)
    lblFirstName: TLabel;
    lblSurname: TLabel;
    lblPatronymic: TLabel;
    edtFirstName: TEdit;
    edtSurname: TEdit;
    edtPatronymic: TEdit;
    lblBirthday: TLabel;
    dtpBirthday: TDateTimePicker;
    lblGender: TLabel;
    cbbGender: TComboBox;
    mmoPlaceWork: TMemo;
    lblPlaceWork: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    lblPhone: TLabel;
    edtPhone: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure edtSurnameChange(Sender: TObject);
    procedure edtFirstNameChange(Sender: TObject);
    procedure edtPatronymicChange(Sender: TObject);
    procedure mmoPlaceWorkChange(Sender: TObject);
    procedure dtpBirthdayChange(Sender: TObject);
    procedure cbbGenderChange(Sender: TObject);
    procedure edtPhoneChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FEditedMedCart: TMedCart;
    FSavedMedCart: TMedCart;
    FOnSavedEvent: TOnEventFrameMedCart;
    FOnCloseEvent: TOnEventFrameMedCart;
    procedure SetMedCart(aMedCart: TMedCart);
    procedure SetSaveEnable;
    function checkCorrect: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    property MedCart: TMedCart write SetMedCart;
    property OnSavedEvent: TOnEventFrameMedCart write FOnSavedEvent;
    property EditedMedCart: TMedCart read FEditedMedCart;
    property OnCloseEvent: TOnEventFrameMedCart read FOnCloseEvent write FOnCloseEvent;
  end;

implementation

{$R *.dfm}

{ TFrameMedCart }

procedure TFrameMedCart.btnCancelClick(Sender: TObject);
begin
  if Assigned(FOnCloseEvent) then
    FOnCloseEvent(FEditedMedCart);
end;

procedure TFrameMedCart.btnSaveClick(Sender: TObject);
begin
  if checkCorrect and Assigned(FOnSavedEvent) then
    FOnSavedEvent(FEditedMedCart.Clone());
end;

procedure TFrameMedCart.cbbGenderChange(Sender: TObject);
begin
  FEditedMedCart.SetGender(TGender(cbbGender.ItemIndex));
  SetSaveEnable;
end;

function TFrameMedCart.checkCorrect: Boolean;
begin
  Result := False;
  if Trim(edtSurname.Text).IsEmpty then begin
    ShowMessage('Не заполнена фамилия');
    Exit;
  end;

  if Trim(edtFirstName.Text).IsEmpty then begin
    ShowMessage('Не заполнено имя');
    Exit;
  end;

  if Trim(edtPatronymic.Text).IsEmpty then begin
    ShowMessage('Не заполнена фамилия');
    Exit;
  end;

  if Trim(mmoPlaceWork.Text).IsEmpty then begin
    ShowMessage('Не заполнена работа');
    Exit;
  end;

  if Trim(edtPhone.Text).IsEmpty then begin
    ShowMessage('Не указан телефон');
    Exit;
  end;


  Result := True;
end;

constructor TFrameMedCart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditedMedCart := TMedCart.Create;
  FSavedMedCart := TMedCart.Create;
end;

destructor TFrameMedCart.Destroy;
begin
  FEditedMedCart.Free;
  FSavedMedCart.Free;
  inherited;
end;

procedure TFrameMedCart.dtpBirthdayChange(Sender: TObject);
begin
  FEditedMedCart.SetBirthday(dtpBirthday.Date);
  SetSaveEnable;
end;

procedure TFrameMedCart.edtFirstNameChange(Sender: TObject);
begin
  FEditedMedCart.SetFirstName(Trim(edtFirstName.Text));
  SetSaveEnable;
end;

procedure TFrameMedCart.edtPatronymicChange(Sender: TObject);
begin
  FEditedMedCart.SetPatronymic(Trim(edtPatronymic.Text));
  SetSaveEnable;
end;

procedure TFrameMedCart.edtPhoneChange(Sender: TObject);
begin
  FEditedMedCart.SetPhone(Trim(edtPhone.Text));
  SetSaveEnable;
end;

procedure TFrameMedCart.edtSurnameChange(Sender: TObject);
begin
  FEditedMedCart.SetSurname(Trim(edtSurname.Text));
  SetSaveEnable;
end;

procedure TFrameMedCart.mmoPlaceWorkChange(Sender: TObject);
begin
  FEditedMedCart.SetPlaceWork(Trim(mmoPlaceWork.Text));
  SetSaveEnable;
end;

procedure TFrameMedCart.SetMedCart(aMedCart: TMedCart);
begin
  if not Assigned(aMedCart) then begin
    edtSurname.Text := '';
    edtFirstName.Text := '';
    edtPatronymic.Text := '';
    dtpBirthday.Date := Now;
    cbbGender.ItemIndex := 0;
    mmoPlaceWork.Clear;
    edtPhone.Text := '';
  end
    else begin
      FSavedMedCart.Copy(aMedCart);
      edtSurname.Text := aMedCart.Surname;
      edtFirstName.Text := aMedCart.FirstName;
      edtPatronymic.Text := aMedCart.Patronymic;
      dtpBirthday.Date := aMedCart.Birthday;
      cbbGender.ItemIndex := Integer(aMedCart.Gender);
      mmoPlaceWork.Text := aMedCart.PlaceWork;
      edtPhone.Text := aMedCart.Phone;
    end;

  FSavedMedCart.SetBirthday(dtpBirthday.Date);
  FEditedMedCart.Copy(FSavedMedCart);

  SetSaveEnable;
end;

procedure TFrameMedCart.SetSaveEnable;
begin
  btnSave.Enabled := not FSavedMedCart.Equals(FEditedMedCart);
end;

end.
