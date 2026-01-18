object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Sniffer Mode'
  ClientHeight = 354
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 313
    Caption = ' Sniffer Mode '
    TabOrder = 0
    object CheckBox1: TCheckBox
      Left = 16
      Top = 32
      Width = 65
      Height = 17
      Caption = 'Add File'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 101
      Width = 87
      Height = 17
      Caption = 'Remove File'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 12
      Top = 173
      Width = 95
      Height = 17
      Caption = 'Renamed File'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 16
      Top = 245
      Width = 91
      Height = 17
      Caption = 'Renamed Dir'
      TabOrder = 3
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 217
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Modification File'
      TabOrder = 4
      OnClick = CheckBox5Click
    end
    object CheckBox6: TCheckBox
      Left = 217
      Top = 101
      Width = 84
      Height = 17
      Caption = 'Last Access'
      TabOrder = 5
      OnClick = CheckBox6Click
    end
    object CheckBox7: TCheckBox
      Left = 217
      Top = 173
      Width = 98
      Height = 17
      Caption = 'Last Write File'
      TabOrder = 6
      OnClick = CheckBox7Click
    end
    object CheckBox8: TCheckBox
      Left = 217
      Top = 245
      Width = 117
      Height = 17
      Caption = 'Creation Time File'
      TabOrder = 7
      OnClick = CheckBox8Click
    end
    object ComboBox1: TComboBox
      Left = 33
      Top = 55
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 8
      OnDrawItem = ComboBox1DrawItem
    end
    object ComboBox2: TComboBox
      Left = 33
      Top = 124
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 9
      OnDrawItem = ComboBox2DrawItem
    end
    object ComboBox3: TComboBox
      Left = 33
      Top = 196
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 10
      OnDrawItem = ComboBox3DrawItem
    end
    object ComboBox4: TComboBox
      Left = 33
      Top = 268
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 11
      OnDrawItem = ComboBox4DrawItem
    end
    object ComboBox5: TComboBox
      Left = 233
      Top = 55
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 12
      OnDrawItem = ComboBox5DrawItem
    end
    object ComboBox6: TComboBox
      Left = 233
      Top = 124
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 13
      OnDrawItem = ComboBox6DrawItem
    end
    object ComboBox7: TComboBox
      Left = 233
      Top = 196
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 14
      OnDrawItem = ComboBox7DrawItem
    end
    object ComboBox8: TComboBox
      Left = 233
      Top = 268
      Width = 128
      Height = 22
      Style = csOwnerDrawVariable
      TabOrder = 15
      OnDrawItem = ComboBox8DrawItem
    end
  end
  object Button1: TButton
    Left = 403
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 565
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 335
    Width = 729
    Height = 19
    Panels = <
      item
        Text = 'Sniffer mode setting'
        Width = 50
      end>
    ExplicitTop = 402
    ExplicitWidth = 330
  end
  object Button4: TButton
    Left = 646
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 4
    OnClick = Button4Click
  end
  object GroupBox2: TGroupBox
    Left = 391
    Top = 8
    Width = 330
    Height = 262
    Caption = ' Sniffer Path '
    TabOrder = 5
    object Label1: TLabel
      Left = 16
      Top = 77
      Width = 30
      Height = 15
      Caption = 'Path :'
    end
    object Label2: TLabel
      Left = 56
      Top = 58
      Width = 106
      Height = 15
      Caption = 'Select Disk or Folder'
    end
    object Label3: TLabel
      Left = 132
      Top = 127
      Width = 9
      Height = 15
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 132
      Top = 148
      Width = 9
      Height = 15
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 86
      Top = 127
      Width = 40
      Height = 15
      Caption = 'Model :'
    end
    object Label6: TLabel
      Left = 52
      Top = 148
      Width = 74
      Height = 15
      Caption = 'Manufacture :'
    end
    object Label7: TLabel
      Left = 132
      Top = 169
      Width = 9
      Height = 15
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 60
      Top = 169
      Width = 66
      Height = 15
      Caption = 'Description :'
    end
    object Label9: TLabel
      Left = 45
      Top = 190
      Width = 81
      Height = 15
      Caption = 'Serial Number :'
    end
    object Label10: TLabel
      Left = 132
      Top = 190
      Width = 9
      Height = 15
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 63
      Top = 211
      Width = 63
      Height = 15
      Caption = 'MediaType :'
    end
    object Label12: TLabel
      Left = 132
      Top = 211
      Width = 9
      Height = 15
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 50
      Top = 74
      Width = 235
      Height = 23
      TabOrder = 0
    end
    object Button3: TButton
      Left = 291
      Top = 74
      Width = 24
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object Button5: TButton
    Left = 484
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Default'
    TabOrder = 6
    OnClick = Button5Click
  end
end
