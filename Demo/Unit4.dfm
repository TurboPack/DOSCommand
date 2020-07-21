object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Stdout Test'
  ClientHeight = 299
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 665
    Height = 273
    TabOrder = 0
  end
  object Button1: TButton
    Left = 712
    Top = 32
    Width = 123
    Height = 25
    Caption = 'list Windows Directory'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DosCommand1: TDosCommand
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 0
    Left = 760
    Top = 104
  end
end
