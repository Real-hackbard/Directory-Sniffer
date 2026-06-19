object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Disks Information'
  ClientHeight = 440
  ClientWidth = 620
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
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 620
    Height = 421
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitWidth = 616
    ExplicitHeight = 420
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 421
    Width = 620
    Height = 19
    Panels = <
      item
        Text = 'Disk :'
        Width = 40
      end
      item
        Width = 80
      end
      item
        Text = 'Status :'
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 420
    ExplicitWidth = 616
  end
end
