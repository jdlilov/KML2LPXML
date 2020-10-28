unit XMLExportRoutines;

interface

uses
  Classes, SysUtils, DB;

const XML_Insert_Field_Tags : boolean = true;
      XML_Field_Name_Tag    : string = 'name';
      XML_Field_Value_Tag   : string = 'value';

procedure XMLFileStart(FileName:string);
procedure XMLFileEnd;
procedure WriteSectionStart(SectionName,ID,Value:string);
procedure WriteSectionEnd(Title:string);
procedure WriteFieldData(FieldName:ShortString; AString: ShortString);
procedure WriteDatasetRows(Dataset: TDataset);



implementation

uses
  MainForm;


var
  SourceBuffer: PChar;
  Stream: TFileStream;

procedure WriteString(s: string);
begin
//  if XML_Insert_Field_Tags then
    s:= s + #10;
  StrPCopy(SourceBuffer, MainF.AnsiToUtf8(s));
  Stream.Write(SourceBuffer[0], StrLen(SourceBuffer));
end;

procedure WriteSectionStart(SectionName,ID,Value:string);
var s:string;
begin
  if SectionName  = '' then
    s:= 'ENTRY'
  else
    s:= StringReplace(SectionName,' ', '_',[rfReplaceAll, rfIgnoreCase]);

  if ID <> '' then
    s:= s + ' ' + ID + '="' + Value + '"';

  WriteString('<' + s + '>');
end;

procedure WriteSectionEnd(Title:string);
begin
  if Title  = '' then
    WriteString('</ENTRY>')
  else
    begin
      Title:= StringReplace(Title,' ', '_',[rfReplaceAll, rfIgnoreCase]);
      WriteString('</' + Title + '>');
    end;
end;

procedure WriteFieldData(FieldName:ShortString; AString: ShortString);
begin
  if not XML_Insert_Field_Tags then
    if (AString <> '') then
      WriteString('<' + FieldName + '>' + AString + '</' + FieldName + '>')
    else
      WriteString('<' + FieldName + '/>')
  else
    WriteString('<' + 'field' + ' ' + XML_Field_Name_Tag + '="' + FieldName + '"' + ' ' + XML_Field_Value_Tag + '="' + AString + '"' + '/>');
end;

function GetFieldStr(Field: TField): string;

  function GetDig(i, j: Word): string;
  begin
    Result := IntToStr(i);
    while (Length(Result) < j) do
      Result := '0' + Result;
  end;

var Hour, Min, Sec, MSec: Word;
begin
  case Field.DataType of
    ftBoolean: Result := UpperCase(Field.AsString);
    ftDate: Result := FormatDateTime('dd/mm/yy', Field.AsDateTime);
    ftTime: Result := FormatDateTime('hhmmss', Field.AsDateTime);
    ftDateTime: begin
                  Result := FormatDateTime('dd/mm/yy', Field.AsDateTime);
                  DecodeTime(Field.AsDateTime, Hour, Min, Sec, MSec);
                  if (Hour <> 0) or (Min <> 0) or (Sec <> 0) or (MSec <> 0) then
                    Result := Result + ' ' + GetDig(Hour, 2) + ':' + GetDig(Min, 2) + ':' + GetDig(Sec, 2){ + GetDig(MSec, 3)};
                end;
  else
    Result := Field.AsString;
  end;
end;

procedure WriteDatasetRows(Dataset: TDataset);
var bkmark: TBookmark;
    i: Integer;
begin
  with DataSet do
  begin
    DisableControls;
    bkmark := GetBookmark;
    First;

    while (not EOF) do
    begin
      WriteSectionStart('','','');
      for i := 0 to FieldCount-1 do
        if Assigned(Fields[i]) then
          WriteFieldData(Fields[i].FieldName, (GetFieldStr(Fields[i])));
      WriteSectionEnd('');
      Next;
    end;

    GotoBookmark(bkmark);
    EnableControls;
  end;
end;

procedure XMLFileStart(FileName:string);
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  SourceBuffer := StrAlloc(1024);
end;

procedure XMLFileEnd;
begin
  Stream.Free;
  StrDispose(SourceBuffer);
end;

procedure ContentToXML(Dataset: TDataset; FileName,TableName: string);
begin
  XMLFileStart(FileName);

  WriteSectionStart(TableName,'','');
  WriteDatasetRows(Dataset);
  WriteSectionEnd(TableName);

  XMLFileEnd;
end;


end.
