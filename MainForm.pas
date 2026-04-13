unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.Clipbrd,
  TMSFNCMemo, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser,
  VCL.TMSFNCCustomWEBControl;

type
  TFieldKind = (fkDouble, fkInteger, fkBoolean, fkString, fkUnknown);

  TParsedField = record
    FieldName: string;
    FieldType: string;
    Kind: TFieldKind;
  end;

  TfrmCSDataGen = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    pnlCenter: TPanel;
    splMain: TSplitter;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    lblInput: TLabel;
    lblOutput: TLabel;
    memoInput: TTMSFNCMemo;
    memoOutput: TTMSFNCMemo;
    pnlButtons: TPanel;
    btnGenerate: TButton;
    btnCopy: TButton;
    lblSigFigs: TLabel;
    spnSigFigs: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    function ParseRecordFields(const AText: string): TArray<TParsedField>;
    function ExtractRecordName(const AText: string): string;
    function ClassifyType(const ATypeName: string): TFieldKind;
    function GenerateUnit(const ARecordName: string;
      const AFields: TArray<TParsedField>; ASigFigs: Integer): string;
  end;

var
  frmCSDataGen: TfrmCSDataGen;

implementation

{$R *.dfm}

procedure TfrmCSDataGen.FormCreate(Sender: TObject);
begin
  spnSigFigs.Value := 6;
  spnSigFigs.MinValue := 1;
  spnSigFigs.MaxValue := 15;

//  memoInput.SyntaxCompletion.Active := True;
//  memoOutput.SyntaxCompletion.Active := True;
end;

procedure TfrmCSDataGen.btnGenerateClick(Sender: TObject);
var
  RecordName: string;
  Fields: TArray<TParsedField>;
  Output: string;
begin
  RecordName := ExtractRecordName(memoInput.Lines.Text);
  if RecordName = '' then
  begin
    ShowMessage('Could not find a record declaration. Expected format:' + sLineBreak +
      '  TMyRecord = record' + sLineBreak +
      '    FieldName: FieldType;' + sLineBreak +
      '  end;');
    Exit;
  end;

  Fields := ParseRecordFields(memoInput.Lines.Text);
  if Length(Fields) = 0 then
  begin
    ShowMessage('No fields found in the record declaration.');
    Exit;
  end;

  Output := GenerateUnit(RecordName, Fields, spnSigFigs.Value);
  memoOutput.Lines.Text := Output;
end;

procedure TfrmCSDataGen.btnCopyClick(Sender: TObject);
begin
  Clipboard.AsText := memoOutput.Lines.Text;
  ShowMessage('Copied to clipboard.');
end;

function TfrmCSDataGen.ExtractRecordName(const AText: string): string;
var
  Lines: TStringList;
  Line, Trimmed, Upper: string;
  EqPos: Integer;
begin
  Result := '';
  Lines := TStringList.Create;
  try
    Lines.Text := AText;
    for Line in Lines do
    begin
      Trimmed := Trim(Line);
      Upper := UpperCase(Trimmed);

      // Look for pattern: TSomething = record
      EqPos := Pos('=', Trimmed);
      if (EqPos > 0) and (Pos('RECORD', Upper) > EqPos) then
      begin
        Result := Trim(Copy(Trimmed, 1, EqPos - 1));
        // Strip leading 'T' check is optional - keep the full type name
        Exit;
      end;
    end;
  finally
    Lines.Free;
  end;
end;

function TfrmCSDataGen.ClassifyType(const ATypeName: string): TFieldKind;
var
  Upper: string;
begin
  Upper := UpperCase(Trim(ATypeName));

  if (Upper = 'DOUBLE') or (Upper = 'SINGLE') or (Upper = 'EXTENDED') or
     (Upper = 'REAL') or (Upper = 'CURRENCY') or (Upper = 'COMP') then
    Result := fkDouble
  else if (Upper = 'INTEGER') or (Upper = 'INT64') or (Upper = 'CARDINAL') or
          (Upper = 'WORD') or (Upper = 'BYTE') or (Upper = 'SHORTINT') or
          (Upper = 'SMALLINT') or (Upper = 'LONGINT') or (Upper = 'LONGWORD') or
          (Upper = 'NATIVEINT') or (Upper = 'NATIVEUINT') or (Upper = 'UINT64') then
    Result := fkInteger
  else if (Upper = 'BOOLEAN') then
    Result := fkBoolean
  else if (Upper = 'STRING') or (Upper = 'ANSISTRING') or (Upper = 'WIDESTRING') or
          (Upper = 'UNICODESTRING') or (Upper = 'SHORTSTRING') then
    Result := fkString
  else
    Result := fkUnknown;
end;

function TfrmCSDataGen.ParseRecordFields(const AText: string): TArray<TParsedField>;
var
  Lines: TStringList;
  Line, Trimmed, Upper: string;
  InRecord: Boolean;
  ColonPos, SemiPos: Integer;
  FieldName, FieldType: string;
  Field: TParsedField;
  ResultList: TList<TParsedField>;
begin
  ResultList := TList<TParsedField>.Create;
  Lines := TStringList.Create;
  try
    Lines.Text := AText;
    InRecord := False;

    for Line in Lines do
    begin
      Trimmed := Trim(Line);
      Upper := UpperCase(Trimmed);

      // Detect start of record
      if not InRecord then
      begin
        if (Pos('=', Trimmed) > 0) and (Pos('RECORD', Upper) > 0) then
          InRecord := True;
        Continue;
      end;

      // Detect end of record
      if (Upper = 'END;') or (Upper = 'END') then
        Break;

      // Skip empty lines, comments, visibility specifiers
      if (Trimmed = '') or (Trimmed[1] = '/') or (Trimmed[1] = '{') or
         (Upper = 'PUBLIC') or (Upper = 'PRIVATE') or (Upper = 'PROTECTED') or
         (Upper = 'STRICT PRIVATE') or (Upper = 'STRICT PROTECTED') then
        Continue;

      // Skip lines that look like methods (function, procedure, class, constructor)
      if (Pos('FUNCTION', Upper) = 1) or (Pos('PROCEDURE', Upper) = 1) or
         (Pos('CLASS ', Upper) = 1) or (Pos('CONSTRUCTOR', Upper) = 1) or
         (Pos('DESTRUCTOR', Upper) = 1) or (Pos('PROPERTY', Upper) = 1) then
        Continue;

      // Parse field: FieldName: FieldType;
      ColonPos := Pos(':', Trimmed);
      SemiPos := Pos(';', Trimmed);
      if (ColonPos > 0) and (SemiPos > ColonPos) then
      begin
        FieldName := Trim(Copy(Trimmed, 1, ColonPos - 1));
        FieldType := Trim(Copy(Trimmed, ColonPos + 1, SemiPos - ColonPos - 1));

        Field.FieldName := FieldName;
        Field.FieldType := FieldType;
        Field.Kind := ClassifyType(FieldType);

        ResultList.Add(Field);
      end;
    end;

    Result := ResultList.ToArray;
  finally
    Lines.Free;
    ResultList.Free;
  end;
end;

function TfrmCSDataGen.GenerateUnit(const ARecordName: string;
  const AFields: TArray<TParsedField>; ASigFigs: Integer): string;
var
  SL: TStringList;
  ClassName, UnitName: string;
  Field: TParsedField;
  NeedsSigFigs: Boolean;
  i: Integer;
begin
  // Strip leading T if present for naming
  if (Length(ARecordName) > 1) and (ARecordName[1] = 'T') then
    UnitName := Copy(ARecordName, 2, MaxInt)
  else
    UnitName := ARecordName;

  ClassName := ARecordName + 'CS';
  UnitName := UnitName + 'CS';

  // Check if we need TestingHelpers
  NeedsSigFigs := False;
  for Field in AFields do
    if Field.Kind = fkDouble then
    begin
      NeedsSigFigs := True;
      Break;
    end;

  SL := TStringList.Create;
  try
    // Unit header
    SL.Add('unit ' + UnitName + ';');
    SL.Add('');
    SL.Add('interface');
    SL.Add('');
    SL.Add('uses');
    SL.Add('  System.Classes,');
    SL.Add('  System.SysUtils,');
    SL.Add('  StringUtils,');
    if NeedsSigFigs then
      SL.Add('  TestingHelpers,');
    SL.Add('  Solverware.Logging,');
    SL.Add('  Solverware.Logging.CodeSite,');
    SL.Add('  CodeSiteLogging;');
    SL.Add('');

    // Type declaration
    SL.Add('type');
    // Record declaration echoed for reference
    SL.Add('  ' + ARecordName + ' = record');
    for Field in AFields do
      SL.Add('    ' + Field.FieldName + ': ' + Field.FieldType + ';');
    SL.Add('  end;');
    SL.Add('');
    SL.Add('  ' + ClassName + ' = class(TCodeSiteInterfacedObject, ICodeSiteCustomData, ISWLogObject)');
    SL.Add('  protected');
    SL.Add('    procedure GetFormattedData(Data: TStringList);');
    SL.Add('    function InspectorType: TCodeSiteInspectorType;');
    SL.Add('    function MsgType: Integer;');
    SL.Add('    function TypeName: string;');

    //IISWLogObject
    SL.Add('    function GetCategory: string;');
    SL.Add('    function GetFields: TArray<TSWLogField>;');
    SL.Add('  public');

    // Fields
    for Field in AFields do
      SL.Add('    ' + Field.FieldName + ': ' + Field.FieldType + ';');

    // Constructor
    SL.Add('    constructor Create(rec: ' + ARecordName + ');');
    SL.Add('  end;');
    SL.Add('');
    SL.Add('');

    // Implementation
    SL.Add('implementation');
    SL.Add('');

    // Constructor body
    SL.Add('constructor ' + ClassName + '.Create(rec: ' + ARecordName + ');');
    SL.Add('begin');
    for Field in AFields do
      SL.Add('  ' + Field.FieldName + ' := rec.' + Field.FieldName + ';');
    SL.Add('end;');
    SL.Add('');

    // GetFormattedData
//    SL.Add('procedure ' + ClassName + '.GetFormattedData(Data: TStringList);');
//    SL.Add('begin');
//    for Field in AFields do
//    begin
//      case Field.Kind of
//        fkDouble:
//          SL.Add('  Data.Add(''' + Field.FieldName + '='' + FloatToStr(RoundToSigFigs(' +
//            Field.FieldName + ', ' + IntToStr(ASigFigs) + ')));');
//        fkInteger:
//          SL.Add('  Data.Add(''' + Field.FieldName + '='' + IntToStr(' +
//            Field.FieldName + '));');
//        fkBoolean:
//          SL.Add('  Data.Add(''' + Field.FieldName + '='' + BoolToStr(' +
//            Field.FieldName + ', True));');
//        fkString:
//          SL.Add('  Data.Add(''' + Field.FieldName + '='' + ' +
//            Field.FieldName + ');');
//      else
//        // Unknown type - use generic ToString via TValue
//        SL.Add('  Data.Add(''' + Field.FieldName + '='' + ' +
//          Field.FieldName + '.ToString);');
//      end;
//    end;
//    SL.Add('end;');
//    SL.Add('');

    // InspectorType
    SL.Add('function ' + ClassName + '.InspectorType: TCodeSiteInspectorType;');
    SL.Add('begin');
    SL.Add('  Result := itStockProperties;');
    SL.Add('end;');
    SL.Add('');

    // MsgType
    SL.Add('function ' + ClassName + '.MsgType: Integer;');
    SL.Add('begin');
    SL.Add('  Result := 0;');
    SL.Add('end;');
    SL.Add('');

    // TypeName
    SL.Add('function ' + ClassName + '.TypeName: string;');
    SL.Add('begin');
    SL.Add('  Result := ''' + ClassName + ''';');
    SL.Add('end;');
    SL.Add('');

    // GetCategory
    SL.Add('function ' + ClassName + '.GetCategory: string;');
    SL.Add('begin');
    SL.Add('  Result := ''' + ARecordName + ''';');
    SL.Add('end;');
    SL.Add('');

    // GetFields
    SL.Add('function ' + ClassName + '.GetFields: TArray<TSWLogField>;');
    SL.Add('begin');
    SL.Add('  Result := [');
    for Field in AFields do
      SL.Add(Format('%sTSWLogField.Create(''%s'', FormatSig(%s)),',
              ['    ',Field.FieldName, Field.FieldName]));
    // Remove trailing comma from last line
    if SL.Count > 0 then
      SL[SL.Count - 1] :=
        SL[SL.Count - 1].TrimRight([',']);


    SL.Add('  ];');
    SL.Add('end;');
    SL.Add('');

    // GetFormattedData
    SL.Add('procedure ' + ClassName + '.GetFormattedData(Data: TStringList);');
    SL.Add('var');
    SL.Add('  Field: TSWLogField;');
    SL.Add('begin');
    SL.Add('  for Field in GetFields do');
    SL.Add('    Data.Values[Field.Name] := Field.Value;');
    SL.Add('end;');
    SL.Add('');

    SL.Add('');
    SL.Add('end.');

    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

end.
