object Form1: TForm1
  Left = 217
  Top = 131
  Caption = 'Directory Sniffer'
  ClientHeight = 477
  ClientWidth = 646
  Color = clBtnFace
  Constraints.MinHeight = 318
  Constraints.MinWidth = 400
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object gbParams: TGroupBox
    Left = 0
    Top = 300
    Width = 646
    Height = 161
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    Caption = ' Parameters '
    TabOrder = 0
    ExplicitTop = 264
    DesignSize = (
      646
      161)
    object Label1: TLabel
      Left = 84
      Top = 68
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 271
      Top = 68
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 420
      Top = 68
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 567
      Top = 68
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 120
      Top = 91
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 272
      Top = 91
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 424
      Top = 91
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 592
      Top = 91
      Width = 12
      Height = 14
      Caption = ': 0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TLabeledEdit
      Left = 13
      Top = 32
      Width = 632
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = 'Path to folder:'
      TabOrder = 0
      Text = 'C:\'
      ExplicitWidth = 628
    end
    object BtnParc: TButton
      Left = 837
      Top = 42
      Width = 28
      Height = 22
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = BtnParcClick
      ExplicitLeft = 833
    end
    object BtnStart: TButton
      Left = 438
      Top = 129
      Width = 97
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akTop, akRight]
      Caption = 'Start watch'
      TabOrder = 2
      TabStop = False
      OnClick = BtnStartClick
      ExplicitLeft = 434
    end
    object BtnStop: TButton
      Left = 539
      Top = 130
      Width = 97
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akTop, akRight]
      Caption = 'Stop watch'
      Enabled = False
      TabOrder = 3
      TabStop = False
      OnClick = BtnStopClick
      ExplicitLeft = 535
    end
    object Button1: TButton
      Left = 13
      Top = 130
      Width = 75
      Height = 20
      Caption = 'Path'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 104
      Top = 130
      Width = 75
      Height = 20
      Caption = 'Clear'
      TabOrder = 5
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 355
      Top = 130
      Width = 65
      Height = 17
      Caption = 'Stay Top'
      TabOrder = 6
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 13
      Top = 66
      Width = 65
      Height = 17
      Caption = 'Add File'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object CheckBox3: TCheckBox
      Left = 180
      Top = 66
      Width = 85
      Height = 17
      Caption = 'Remove File'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object CheckBox4: TCheckBox
      Left = 323
      Top = 66
      Width = 91
      Height = 17
      Caption = 'Renamed File'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
    object CheckBox5: TCheckBox
      Left = 472
      Top = 66
      Width = 89
      Height = 17
      Caption = 'Renamed Dir'
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
    object CheckBox6: TCheckBox
      Left = 13
      Top = 89
      Width = 101
      Height = 17
      Caption = 'Modification File'
      Checked = True
      State = cbChecked
      TabOrder = 11
    end
    object CheckBox7: TCheckBox
      Left = 180
      Top = 89
      Width = 77
      Height = 17
      Caption = 'Last Access'
      Checked = True
      State = cbChecked
      TabOrder = 12
    end
    object CheckBox8: TCheckBox
      Left = 323
      Top = 89
      Width = 91
      Height = 17
      Caption = 'Last Write File'
      Checked = True
      State = cbChecked
      TabOrder = 13
    end
    object CheckBox9: TCheckBox
      Left = 472
      Top = 89
      Width = 113
      Height = 17
      Caption = 'Creation Time File'
      Checked = True
      State = cbChecked
      TabOrder = 14
    end
  end
  object gbInfos: TGroupBox
    Left = 0
    Top = 0
    Width = 646
    Height = 300
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    Caption = '  Notifications  '
    TabOrder = 1
    ExplicitWidth = 642
    ExplicitHeight = 263
    object ListBox1: TListBox
      Left = 2
      Top = 15
      Width = 642
      Height = 283
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabStop = False
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      ExplicitWidth = 638
      ExplicitHeight = 246
    end
  end
  object SB: TStatusBar
    Left = 0
    Top = 461
    Width = 646
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Panels = <
      item
        Text = 'Watch stopped'
        Width = 440
      end
      item
        Text = '0 element'
        Width = 40
      end>
    OnResize = SBResize
    ExplicitTop = 460
    ExplicitWidth = 642
  end
end
