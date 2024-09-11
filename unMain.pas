unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxPC, Vcl.StdCtrls, unRepository, Vcl.ExtCtrls, unMedCart,
  System.Generics.Collections, Vcl.ComCtrls, cxContainer, cxEdit, cxListView,
  unFrameMedCart;

type
  TcxTabSheetCustom = class(TcxTabSheet)
    private
      FFrameMedCart: TFrameMedCart;
      function GetEditedMedCart: TMedCart;
    public
      property FrameMedCart: TFrameMedCart read FFrameMedCart write FFrameMedCart;
      property EditedMedCart: TMedCart read GetEditedMedCart;
  end;

  TFormMain = class(TForm)
    cxpgcntrlMain: TcxPageControl;
    cxtbshtMain: TcxTabSheet;
    pnlLoading: TPanel;
    pnlSearch: TPanel;
    btnSearch: TButton;
    lblFirstNameSearch: TLabel;
    edtFirstNameSearch: TEdit;
    lblSurnameSearch: TLabel;
    edtSurnameSearch: TEdit;
    lvMedCarts: TListView;
    lblPatronymic: TLabel;
    edtPatronymic: TEdit;
    btnAddMedCart: TButton;
    btnRemoveMedCart: TButton;
    btnEditMedCart: TButton;
    pnlMainButtons: TPanel;
    splMain: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnAddMedCartClick(Sender: TObject);
    procedure cxpgcntrlMainChange(Sender: TObject);
    procedure cxpgcntrlMainCanClose(Sender: TObject; var ACanClose: Boolean);
    procedure cxpgcntrlMainCanCloseEx(Sender: TObject; ATabIndex: Integer;
      var ACanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnEditMedCartClick(Sender: TObject);
    procedure btnRemoveMedCartClick(Sender: TObject);
  private
    { Private declarations }
    FRepo: TRepositoryAbstract;
    FIndexTab: Integer;
    FCurrentTab: TcxTabSheetCustom;
    procedure NotifyEventList(aSuccess: Boolean; aMessage: string;
      aListMedCart: TList<TMedCart>);
    procedure NotifyEventSimple(aSuccess: Boolean; aMessage: string;
      aMedCart: TMedCart; aAction: TActionSimpleEvent);
    procedure ShowLoading(aMessage: string);
    procedure HideLoading;
    procedure SaveMedCart(aMedCart: TMedCart);
    /// <summary>
    /// Очистка списка
    /// </summary>
    procedure ClearListView;
    procedure OpenTabSheet(aMedCart: TMedCart);

    /// <summary>
    /// Обновление данных в списке
    /// </summary>
    procedure UpdateListView(aMedCart: TMedCart);
    procedure DeleteListView(aMedCart: TMedCart);
    procedure AddMedCartListView(aMedCart: TMedCart);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.AddMedCartListView(aMedCart: TMedCart);
begin
  with lvMedCarts.Items.Add do begin
    Caption := aMedCart.Surname;
    SubItems.Add(aMedCart.FirstName);
    SubItems.Add(aMedCart.Patronymic);
    Data := aMedCart;
  end;
end;

procedure TFormMain.btnAddMedCartClick(Sender: TObject);
begin
  OpenTabSheet(nil);
end;

procedure TFormMain.btnEditMedCartClick(Sender: TObject);
begin
  if lvMedCarts.Selected = nil then
    Exit;

  OpenTabSheet(lvMedCarts.Selected.Data);
end;

procedure TFormMain.btnRemoveMedCartClick(Sender: TObject);
begin
  if lvMedCarts.Selected = nil then
    Exit;

  FRepo.DeleteMedCart(lvMedCarts.Selected.Data);
  ShowLoading('Удаление мед. карты');
end;

procedure TFormMain.btnSearchClick(Sender: TObject);
var
  filterSearch: TFilterSearch;
begin
  filterSearch.Surname := Trim(edtSurnameSearch.Text);
  filterSearch.FirstName := Trim(edtFirstNameSearch.Text);
  filterSearch.Patronymic := Trim(edtPatronymic.Text);
  FRepo.Load(filterSearch);
  ShowLoading('Загрузка мед/карт...');
end;

procedure TFormMain.ClearListView;
begin
  lvMedCarts.Clear;
end;

procedure TFormMain.cxpgcntrlMainCanClose(Sender: TObject;
  var ACanClose: Boolean);
begin
//
end;

procedure TFormMain.cxpgcntrlMainCanCloseEx(Sender: TObject; ATabIndex: Integer;
  var ACanClose: Boolean);
begin
   //
end;

procedure TFormMain.cxpgcntrlMainChange(Sender: TObject);
var
  activePage: TcxTabSheet;
begin
  activePage := TcxPageControl(Sender).ActivePage;

  if activePage is TcxTabSheetCustom then
    FCurrentTab := TcxTabSheetCustom(activePage)
  else
    FCurrentTab := nil;
end;

procedure TFormMain.DeleteListView(aMedCart: TMedCart);
var
  lItem: TListItem;
  medCart: TMedCart;
  i: Integer;
  tab: TcxTabSheet;
  tabCustom: TcxTabSheetCustom;
begin
  medCart := nil;

  for i := 0 to lvMedCarts.Items.Count - 1 do begin
    lItem := lvMedCarts.Items[i];
    medCart := lItem.Data;

    if medCart.Id = aMedCart.Id then begin
      lvMedCarts.Items.Delete(i);
      Break;
    end;
  end;


  if medCart <> nil then
    for i := 0 to cxpgcntrlMain.PageCount - 1 do begin
      tab := cxpgcntrlMain.Pages[i];
      if tab is TcxTabSheetCustom then begin
        tabCustom := TcxTabSheetCustom(tab);
        if tabCustom.EditedMedCart.Id = medCart.Id then begin
          FreeAndNil(tab);
          Break;
        end;
      end;
    end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FRepo := TRepositoryJSON.Create;
  FRepo.NotifyEventList := NotifyEventList;
  FRepo.NotifyEventSimple := NotifyEventSimple;

  Caption := 'Мед. карты';
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FRepo.Free;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FRepo.Load;
  ShowLoading('Загрузка мед/карт...');
end;

procedure TFormMain.HideLoading;
begin
  pnlLoading.Hide;
  cxpgcntrlMain.Show;
end;

procedure TFormMain.NotifyEventList(aSuccess: Boolean; aMessage: string;
  aListMedCart: TList<TMedCart>);
var
  medCart: TMedCart;
begin
  ClearListView;
  if aSuccess then
    for medCart in aListMedCart do begin
      AddMedCartListView(medCart);
    end;

  HideLoading;
end;

procedure TFormMain.NotifyEventSimple(aSuccess: Boolean; aMessage: string;
  aMedCart: TMedCart; aAction: TActionSimpleEvent);
begin
  HideLoading;

  if aSuccess then begin
    case aAction of
      actAdd: begin
        AddMedCartListView(aMedCart);
        FreeAndNil(FCurrentTab);
      end;
      actUpd: begin
        UpdateListView(aMedCart);
        FreeAndNil(FCurrentTab);
      end;
      actDel: begin
        DeleteListView(aMedCart);
      end;
    end;
  end;
end;

procedure TFormMain.OpenTabSheet(aMedCart: TMedCart);
var
  tab: TcxTabSheetCustom;
  frame: TFrameMedCart;
begin
  tab := TcxTabSheetCustom.Create(cxpgcntrlMain);
  tab.name := Format('TcxTabSheet_%d', [FIndexTab]);
  tab.AllowCloseButton := True;
  tab.Parent := cxpgcntrlMain;
  if aMedCart = nil then
    tab.Caption := 'Новый пациент'
  else
    tab.Caption := aMedCart.SurnameAndInitials;

  cxpgcntrlMain.ActivePage := tab;

  frame := TFrameMedCart.Create(tab);
  frame.Name := Format('TFrameMedCart_%d', [FIndexTab]);
  frame.Parent := tab;
  frame.Align := alClient;

  frame.MedCart := aMedCart;
  frame.OnSavedEvent := SaveMedCart;

  //Пример назначения обработчика через анонимную процедуру
  frame.OnCloseEvent := procedure(aMedCart: TMedCart)
  begin
    FreeAndNil(tab);
  end;

  tab.FrameMedCart := frame;

  Inc(FIndexTab);
end;

procedure TFormMain.SaveMedCart(aMedCart: TMedCart);
begin
  if aMedCart.Id = 0 then begin
    FRepo.AddMedCart(aMedCart);
    ShowLoading('Добавление мед. карты');
  end
  else begin
    FRepo.UpdateMedCart(aMedCart);
    ShowLoading('Обновление мед. карты');
  end;
end;

procedure TFormMain.ShowLoading(aMessage: string);
begin
  pnlLoading.Caption := aMessage;
  pnlLoading.Show;
  cxpgcntrlMain.Hide;
end;

procedure TFormMain.UpdateListView(aMedCart: TMedCart);
var
  lItem: TListItem;
  medCart: TMedCart;
  find: Boolean;
begin
  find := False;

  for lItem in lvMedCarts.Items do begin
    medCart := TMedCart(lItem.Data);
    if medCart.Id = aMedCart.Id then begin
      lItem.Caption := aMedCart.Surname;
      lItem.SubItems[0] := aMedCart.FirstName;
      lItem.SubItems[1] := aMedCart.Patronymic;
      find := True;
      Break;
    end;
  end;

  if not find then begin
    AddMedCartListView(aMedCart);
  end;

end;

{ TcxTabSheetCustom }

function TcxTabSheetCustom.GetEditedMedCart: TMedCart;
begin
  Result := FFrameMedCart.EditedMedCart;
end;

end.
