object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 372
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLoading: TPanel
    Left = 0
    Top = 0
    Width = 779
    Height = 372
    Align = alClient
    Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080'...'
    TabOrder = 1
  end
  object cxpgcntrlMain: TcxPageControl
    Left = 0
    Top = 0
    Width = 779
    Height = 372
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = cxtbshtMain
    Properties.CloseButtonMode = cbmEveryTab
    Properties.CustomButtons.Buttons = <>
    OnCanClose = cxpgcntrlMainCanClose
    OnCanCloseEx = cxpgcntrlMainCanCloseEx
    OnChange = cxpgcntrlMainChange
    ClientRectBottom = 368
    ClientRectLeft = 4
    ClientRectRight = 775
    ClientRectTop = 24
    object cxtbshtMain: TcxTabSheet
      AllowCloseButton = False
      Caption = #1057#1087#1080#1089#1086#1082
      ImageIndex = 0
      object splMain: TSplitter
        Left = 329
        Top = 41
        Height = 303
        ExplicitLeft = 8
        ExplicitTop = 160
        ExplicitHeight = 100
      end
      object pnlSearch: TPanel
        Left = 0
        Top = 0
        Width = 771
        Height = 41
        Align = alTop
        TabOrder = 0
        DesignSize = (
          771
          41)
        object lblFirstNameSearch: TLabel
          Left = 200
          Top = 14
          Width = 23
          Height = 13
          Caption = #1048#1084#1103':'
        end
        object lblSurnameSearch: TLabel
          Left = 8
          Top = 14
          Width = 48
          Height = 13
          Caption = #1060#1072#1084#1080#1083#1080#1103':'
        end
        object lblPatronymic: TLabel
          Left = 381
          Top = 14
          Width = 53
          Height = 13
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
        end
        object btnSearch: TButton
          Left = 688
          Top = 11
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #1055#1086#1080#1089#1082
          TabOrder = 0
          OnClick = btnSearchClick
        end
        object edtFirstNameSearch: TEdit
          Left = 245
          Top = 11
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtSurnameSearch: TEdit
          Left = 62
          Top = 12
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edtPatronymic: TEdit
          Left = 443
          Top = 12
          Width = 121
          Height = 21
          TabOrder = 3
        end
      end
      object lvMedCarts: TListView
        Left = 0
        Top = 41
        Width = 329
        Height = 303
        Align = alLeft
        Columns = <
          item
            Caption = #1060#1072#1084#1080#1083#1080#1103
            Width = 90
          end
          item
            Caption = #1048#1084#1103
            Width = 80
          end
          item
            Caption = #1054#1090#1095#1077#1089#1090#1074#1086
            Width = 95
          end>
        Items.ItemData = {
          054C0000000100000000000000FFFFFFFFFFFFFFFF02000000FFFFFFFF000000
          00061804320430043D043E043204041804320430043D0408E4BD480818043204
          30043D043E04320438044704E8DDBD48FFFFFFFF}
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
      object pnlMainButtons: TPanel
        Left = 332
        Top = 41
        Width = 439
        Height = 303
        Align = alClient
        TabOrder = 2
        ExplicitLeft = 292
        ExplicitWidth = 479
        object btnAddMedCart: TButton
          Left = 64
          Top = 56
          Width = 97
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btnAddMedCartClick
        end
        object btnEditMedCart: TButton
          Left = 64
          Top = 140
          Width = 97
          Height = 25
          Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 1
          OnClick = btnEditMedCartClick
        end
        object btnRemoveMedCart: TButton
          Left = 64
          Top = 228
          Width = 97
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnRemoveMedCartClick
        end
      end
    end
  end
end
