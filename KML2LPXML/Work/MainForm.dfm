object MainF: TMainF
  Left = 227
  Top = 103
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'GoogleEarth KML Route -> LibrePilot XML Path Plan'
  ClientHeight = 293
  ClientWidth = 668
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    000001000200202002000000000030010000260000002020100000000000E802
    0000560100002800000020000000400000000100010000000000000100000000
    000000000000000000000000000000000000FFFFFF0000000000000000000000
    00000000000000000000000000000000000000000000040000000C0000001E00
    00001E0000003F0000003F0000003F0000001E0000000C000020000000300000
    007800000078000000FC000100FC0001007800038030000380000007C0000007
    C0000007C0000007C00000010000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000088888888888888888800000
    0000000087777777777777777770000008000000888888888888888888700000
    0800000088888888888888888870000087000000888888888888888888700000
    7700000088888888888888888870000078700000888888888888888888700007
    8F700000087777777777777777800088FF87000000000000000000000000007F
    FFF7800000000000000000000000088FFFF870000000000000000000000007FF
    FFFF78000000000000000088000007FFFFFF88000000000000000077000007FF
    FFFF880000000000000000770000088FFFF87000000000000000088780000088
    FF87000000000000000007F8700000088880000000000000000088FF78000000
    000000000007000000007FFFF7000000000000000007800000088FFFF8700000
    00000000000770000007FFFFFF70000000000000007F70000007FFFFFF700000
    00000000008F870000088FFFF88000000000000007FFF700000078FF87000000
    0000000088FFF8700000088780000000000000007FFFFF780000000000000000
    000000008FFFFF870000000000000000000000008FFFFF880000000000000000
    000000007FFFFF70000000000000000000000000078F87800000000000000000
    000000000088800000000000000000000000000000000000000000000000FFFF
    FFFFFFF80001FFF00001FBF00001FBF00001F3F00001F3F00001F1F00001E1F8
    0001C0FFFFFFC07FFFFF807FFFFF803FFFCF803FFFCF803FFFCF807FFF87C0FF
    FF87E1FFFF03FFFEFF03FFFE7E01FFFE7E01FFFC7E01FFFC3E01FFF83F03FFF0
    1F87FFF00FFFFFF00FFFFFF00FFFFFF01FFFFFF81FFFFFFC7FFFFFFFFFFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 74
    Width = 333
    Height = 25
    Shape = bsFrame
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 360
    Top = 80
    Width = 100
    Height = 13
    Caption = 'Geoid separation (m):'
  end
  object Label2: TLabel
    Left = 540
    Top = 80
    Width = 67
    Height = 13
    Caption = 'Velocity (m/s):'
  end
  object Label3: TLabel
    Left = 8
    Top = 184
    Width = 545
    Height = 13
    Caption = 
      'GoogleEarth saves altitudes as orthometric height (height above ' +
      'EGM96 geoid which approximates mean sea level).'
  end
  object Label4: TLabel
    Left = 8
    Top = 200
    Width = 228
    Height = 13
    Caption = 'LibrePilot uses GPS ellipsoidal heights (WGS84).'
  end
  object Label5: TLabel
    Left = 8
    Top = 216
    Width = 642
    Height = 13
    Caption = 
      'This tool applies the Geoid separation value for the area of int' +
      'erest to the GoogleEarth heights to convert them to GPS (WGS84) ' +
      'heights.'
  end
  object Label6: TLabel
    Left = 8
    Top = 236
    Width = 170
    Height = 13
    Caption = 'Online Geoid separation calculators:'
  end
  object Label7: TLabel
    Left = 8
    Top = 268
    Width = 488
    Height = 13
    Caption = 
      'https://www.unavco.org/software/geodetic-utilities/geoid-height-' +
      'calculator/geoid-height-calculator.html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label7Click
  end
  object Label8: TLabel
    Left = 8
    Top = 252
    Width = 259
    Height = 13
    Caption = 'https://geographiclib.sourceforge.io/cgi-bin/GeoidEval'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label8Click
  end
  object Label9: TLabel
    Left = 16
    Top = 80
    Width = 271
    Height = 13
    Caption = '3. Fill the desired values for Geoid separation and velocity'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 668
    Height = 145
    Align = alTop
    Shape = bsBottomLine
  end
  object Label10: TLabel
    Left = 8
    Top = 160
    Width = 392
    Height = 13
    Caption = 
      'Velocity is of no importance when the path plan is intended for ' +
      'Plane / Fixed Wing .'
  end
  object BitBtn1: TBitBtn
    Left = 7
    Top = 108
    Width = 206
    Height = 25
    Caption = '4. Export to LibrePilot Path Plan .xml file'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object Edit1: TEdit
    Left = 464
    Top = 76
    Width = 53
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 608
    Top = 76
    Width = 53
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
    OnChange = Edit2Change
  end
  object BitBtn2: TBitBtn
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = '1. Load .kml file'
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object StaticText1: TStaticText
    Left = 116
    Top = 12
    Width = 545
    Height = 17
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StaticText1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object BitBtn3: TBitBtn
    Left = 8
    Top = 40
    Width = 333
    Height = 25
    Caption = 
      '2. Get online the EGM96 geoid height for the first waypoint loca' +
      'tion'
    TabOrder = 5
    OnClick = BitBtn3Click
  end
  object StaticText2: TStaticText
    Left = 360
    Top = 44
    Width = 301
    Height = 17
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StaticText2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object StaticText3: TStaticText
    Left = 232
    Top = 112
    Width = 429
    Height = 17
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StaticText3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'KML'
    Filter = 'GoogleEarth KML Files|*.kml|All Files|*.*'
    FilterIndex = 0
    Left = 584
    Top = 5
  end
end
