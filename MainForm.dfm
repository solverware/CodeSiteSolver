object frmCSDataGen: TfrmCSDataGen
  Left = 0
  Top = 0
  Caption = 'CodeSite Custom Data Generator'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 12
      Width = 284
      Height = 25
      Caption = 'CodeSite Custom Data Generator'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 50
    Width = 1000
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblSigFigs: TLabel
      Left = 272
      Top = 14
      Width = 100
      Height = 15
      Caption = 'Significant Figures:'
    end
    object btnGenerate: TButton
      Left = 16
      Top = 8
      Width = 100
      Height = 30
      Caption = 'Generate'
      TabOrder = 0
      OnClick = btnGenerateClick
    end
    object btnCopy: TButton
      Left = 128
      Top = 8
      Width = 120
      Height = 30
      Caption = 'Copy to Clipboard'
      TabOrder = 1
      OnClick = btnCopyClick
    end
    object spnSigFigs: TSpinEdit
      Left = 380
      Top = 10
      Width = 50
      Height = 24
      MaxValue = 15
      MinValue = 1
      TabOrder = 2
      Value = 6
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 95
    Width = 1000
    Height = 505
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object splMain: TSplitter
      Left = 490
      Top = 0
      Width = 6
      Height = 505
      ResizeStyle = rsUpdate
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 490
      Height = 505
      Align = alLeft
      BevelOuter = bvNone
      Padding.Left = 8
      Padding.Top = 4
      Padding.Right = 4
      Padding.Bottom = 8
      TabOrder = 0
      object lblInput: TLabel
        Left = 8
        Top = 4
        Width = 478
        Height = 17
        Align = alTop
        Caption = 'Paste Record Declaration:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 158
      end
      object memoInput: TTMSFNCMemo
        Left = 8
        Top = 21
        Width = 478
        Height = 476
        Align = alClient
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        TabOrder = 0
        Options.WordWrap = wwtOff
        Options.WordWrapColumn = 80
        Options.BracketPairColorization = False
        CompletionList = <>
        CustomLanguages = <>
        CustomThemes = <>
        LanguageFileExtensionsMap = <
          item
            Language = mlBat
            Extension = '.bat'
          end
          item
            Language = mlCsharp
            Extension = '.cs'
          end
          item
            Language = mlCSS
            Extension = '.css'
          end
          item
            Language = mlHtml
            Extension = '.html'
          end
          item
            Language = mlJavascript
            Extension = '.js'
          end
          item
            Language = mlJSON
            Extension = '.json'
          end
          item
            Extension = '.pas'
          end
          item
            Extension = '.dpr'
          end
          item
            Extension = '.dfm'
          end
          item
            Extension = '.fmx'
          end
          item
            Extension = '.inc'
          end
          item
            Extension = '.dproj'
          end
          item
            Language = mlPlainText
            Extension = '.txt'
          end
          item
            Language = mlTypeScript
            Extension = '.ts'
          end
          item
            Language = mlXml
            Extension = '.xml'
          end>
        ActiveSource = -1
        Sources = <>
      end
    end
    object pnlRight: TPanel
      Left = 496
      Top = 0
      Width = 504
      Height = 505
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 4
      Padding.Top = 4
      Padding.Right = 8
      Padding.Bottom = 8
      TabOrder = 1
      object lblOutput: TLabel
        Left = 4
        Top = 4
        Width = 492
        Height = 17
        Align = alTop
        Caption = 'Generated CodeSite Unit:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 155
      end
      object memoOutput: TTMSFNCMemo
        Left = 4
        Top = 21
        Width = 492
        Height = 476
        Align = alClient
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        TabOrder = 0
        Options.WordWrap = wwtOff
        Options.WordWrapColumn = 80
        Options.BracketPairColorization = False
        CompletionList = <>
        CustomLanguages = <>
        CustomThemes = <>
        LanguageFileExtensionsMap = <
          item
            Language = mlBat
            Extension = '.bat'
          end
          item
            Language = mlCsharp
            Extension = '.cs'
          end
          item
            Language = mlCSS
            Extension = '.css'
          end
          item
            Language = mlHtml
            Extension = '.html'
          end
          item
            Language = mlJavascript
            Extension = '.js'
          end
          item
            Language = mlJSON
            Extension = '.json'
          end
          item
            Extension = '.pas'
          end
          item
            Extension = '.dpr'
          end
          item
            Extension = '.dfm'
          end
          item
            Extension = '.fmx'
          end
          item
            Extension = '.inc'
          end
          item
            Extension = '.dproj'
          end
          item
            Language = mlPlainText
            Extension = '.txt'
          end
          item
            Language = mlTypeScript
            Extension = '.ts'
          end
          item
            Language = mlXml
            Extension = '.xml'
          end>
        ActiveSource = -1
        Sources = <>
      end
    end
  end
end
