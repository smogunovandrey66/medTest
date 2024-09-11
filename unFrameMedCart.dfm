object FrameMedCart: TFrameMedCart
  Left = 0
  Top = 0
  Width = 508
  Height = 274
  TabOrder = 0
  object lblFirstName: TLabel
    Left = 57
    Top = 64
    Width = 23
    Height = 13
    Caption = #1048#1084#1103':'
  end
  object lblSurname: TLabel
    Left = 32
    Top = 19
    Width = 48
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103':'
  end
  object lblPatronymic: TLabel
    Left = 27
    Top = 104
    Width = 53
    Height = 13
    Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
  end
  object lblBirthday: TLabel
    Left = 243
    Top = 24
    Width = 90
    Height = 13
    Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103':'
  end
  object lblGender: TLabel
    Left = 304
    Top = 64
    Width = 29
    Height = 13
    Caption = #1055#1086#1083':'
  end
  object lblPlaceWork: TLabel
    Left = 34
    Top = 167
    Width = 42
    Height = 26
    Alignment = taCenter
    Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099':'
    WordWrap = True
  end
  object lblPhone: TLabel
    Left = 279
    Top = 104
    Width = 54
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085':'
  end
  object edtFirstName: TEdit
    Left = 96
    Top = 61
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edtFirstName'
    OnChange = edtFirstNameChange
  end
  object edtSurname: TEdit
    Left = 96
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtSurname'
    OnChange = edtSurnameChange
  end
  object edtPatronymic: TEdit
    Left = 96
    Top = 101
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edtPatronymic'
    OnChange = edtPatronymicChange
  end
  object dtpBirthday: TDateTimePicker
    Left = 339
    Top = 24
    Width = 103
    Height = 21
    Date = 45545.000000000000000000
    Time = 0.814385578705696400
    TabOrder = 3
    OnChange = dtpBirthdayChange
  end
  object cbbGender: TComboBox
    Left = 342
    Top = 61
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = #1084#1091#1078#1089#1082#1086#1081
    OnChange = cbbGenderChange
    Items.Strings = (
      #1084#1091#1078#1089#1082#1086#1081
      #1078#1077#1085#1089#1082#1080#1081)
  end
  object mmoPlaceWork: TMemo
    Left = 96
    Top = 144
    Width = 346
    Height = 65
    Lines.Strings = (
      'mmoPlaceWork')
    TabOrder = 6
    OnChange = mmoPlaceWorkChange
  end
  object btnSave: TButton
    Left = 96
    Top = 224
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 7
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 366
    Top = 224
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object edtPhone: TEdit
    Left = 339
    Top = 101
    Width = 103
    Height = 21
    TabOrder = 5
    Text = 'edtPhone'
    OnChange = edtPhoneChange
  end
end
