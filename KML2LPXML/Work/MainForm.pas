unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Registry, ShellAPI, ExtCtrls;

type
  UTF8String = type string;

  TMainF = class(TForm)
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    BitBtn2: TBitBtn;
    StaticText1: TStaticText;
    BitBtn3: TBitBtn;
    StaticText2: TStaticText;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    StaticText3: TStaticText;
    Label10: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    CL:AnsiString;
    FirstWP_GHQ_URL:string;
    function Utf8Encode(const WS: WideString): UTF8String;
    function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
  public
    function AnsiToUtf8(const S: string):UTF8String;
    procedure BrowseURL(const URL: string);
  end;

var
  MainF: TMainF;

implementation
uses XMLExportRoutines;
{$R *.DFM}

procedure TMainF.BrowseURL(const URL: string);
begin
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

function TMainF.UnicodeToUtf8 (Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
var i, count: Cardinal;
    c: Cardinal;
begin
  Result:= 0;
  if Source = nil then
    exit;
  count:= 0;
  i:= 0;
  if Dest <> nil then
    begin
      while (i < SourceChars) and (count < MaxDestBytes) do
        begin
          c:= Cardinal(Source[i]);
          Inc (i);
          if c <= $7F then
            begin
              Dest[count]:= Char(c);
              Inc(count);
            end
          else
            if c > $7FF then
              begin
                if (count + 3) > MaxDestBytes then
                  break;
                Dest[count]:= Char($E0 or (c shr 12));
                Dest[count+1]:= Char($80 or ((c shr 6) and $3F));
                Dest[count+2]:= Char($80 or (c and $3F));
                Inc(count, 3);
              end
            else//$7F &lt;Source [i] &lt;= $7FF
              begin
                if (count + 2) > MaxDestBytes then
                  break;
                Dest[count]:= Char ($C0 or (c shr 6));
                Dest[count+1]:= Char ($80 or (c and $3F));
                Inc(count, 2);
              end;
        end;
      if count >= MaxDestBytes then

        count:= MaxDestBytes-1;
      Dest[count]:= #0;
    end
  else
    begin
      while i < SourceChars do
        begin
          c:= Integer(Source[i]);
          Inc(i);
          if c > $7F then
            begin
              if c > $7FF then
               Inc(count);
              Inc(count);
            end;
          Inc(count);
        end;
    end;
  Result:= count+1;//convert zero based index to byte count
end;

function TMainF.Utf8Encode(const WS: WideString): UTF8String;
var L: Integer;
    Temp: UTF8String;
begin
  Result:= '';
  if WS = '' then
    exit;
  SetLength(Temp, Length(WS) * 3);//SetLength includes space for null terminator
  L:= UnicodeToUtf8 (PChar (Temp), Length (Temp) +1, PWideChar (WS), Length (WS));
  if L > 0 then
    SetLength (Temp, L-1)
  else
    Temp:= '';
  Result:= Temp;
end;

function TMainF.AnsiToUtf8(const S: string):UTF8String;
begin
  Result:= Utf8Encode(S);
end;

procedure TMainF.BitBtn1Click(Sender: TObject);
var wps,longitude,latitude,altitude:AnsiString;
    wpc,i1:longint;
    nfn:string;
    GSep:longint;
begin
  GSep:= StrToInt(Edit1.Text);

  wpc:= 0;

  nfn:= ChangeFileExt(OpenDialog1.FileName, '.xml');

  try
    if FileExists(nfn) then
      DeleteFile(nfn);

    StaticText3.Caption:= nfn;

    XMLFileStart(nfn);

    WriteSectionStart('waypoints','','');

    while length(CL) > 0 do
      begin
        i1:= pos(' ',CL);
        wps:= copy(CL,1,i1-1);
        delete(CL,1,i1);

        i1:= pos(',',wps);
        longitude:= copy(wps,1,i1-1);
        delete(wps,1,i1);

        i1:= pos(',',wps);
        latitude:= copy(wps,1,i1-1);
        delete(wps,1,i1);

        altitude:= IntToStr(round(StrToFloat(wps)+0.00000001) + GSep);

        WriteSectionStart('waypoint','number',IntToStr(wpc));
        WriteFieldData('latitude', latitude);
        WriteFieldData('longitude', longitude);
        WriteFieldData('altitude', altitude);

        WriteFieldData('velocity', Edit2.Text);
        WriteFieldData('is_relative_to_home', '0');
        WriteFieldData('errordestination', '-1');
        WriteFieldData('mode', '1');
        WriteFieldData('mode_param0', '0');
        WriteFieldData('mode_param1', '0');
        WriteFieldData('mode_param2', '0');
        WriteFieldData('mode_param3', '0');
        WriteFieldData('condition', '3');
        WriteFieldData('condition_param0', '0');
        WriteFieldData('condition_param1', '0');
        WriteFieldData('condition_param2', '0');
        WriteFieldData('condition_param3', '0');
        WriteFieldData('command', '0');
        WriteFieldData('jumpdestination', '1');
        WriteFieldData('is_locked', '0');
        WriteSectionEnd('waypoint');

        inc(wpc);
      end;

    WriteSectionEnd('waypoints');
    XMLFileEnd;

    MessageDlg('Export completed!',mtInformation,[mbOk],0);
  except
    on E:Exception do
      begin
        StaticText3.Caption:= '';
        MessageDlg('Export failed! Error: ' + E.Message,mtError,[mbOk],0);
      end;
  end;
end;

procedure TMainF.FormCreate(Sender: TObject);
begin
  FirstWP_GHQ_URL:= '';
  CL:= '';
  StaticText1.Caption:= '';
  StaticText2.Caption:= '';
  StaticText3.Caption:= '';
  BitBtn3.Enabled:= false;
  BitBtn1.Enabled:= false;

  Edit1.Text:= IntToStr(0);
  Edit2.Text:= IntToStr(15);
end;

procedure TMainF.Edit1Change(Sender: TObject);
begin
  try
    if Edit1.Text <> '-' then
      StrToInt(Edit1.Text);
  except
    Edit1.Text:= IntToStr(0);
    Edit1.SelectAll;
  end;
end;

procedure TMainF.Edit2Change(Sender: TObject);
begin
  try
    StrToInt(Edit2.Text);
  except
    Edit2.Text:= IntToStr(15);
    Edit2.SelectAll;
  end;
end;

procedure TMainF.Label7Click(Sender: TObject);
begin
  BrowseURL(Label7.Caption);
end;

procedure TMainF.Label8Click(Sender: TObject);
begin
  BrowseURL(Label8.Caption);
end;

procedure TMainF.BitBtn2Click(Sender: TObject);
var i1,i2:longint;
    f:system.text;
    SBuffer,wps,longitude,latitude,altitude:AnsiString;
begin
  if OpenDialog1.Execute then
    begin
      system.Assign(f,OpenDialog1.FileName);
      system.Reset(f);
      system.Read(f,SBuffer);
      system.Close(f);
      i1:= Pos('<coordinates>',SBuffer);
      i2:= Pos('</coordinates>',SBuffer);
      CL:= copy(SBuffer,i1+13, i2-i1-13);
      CL:= trim(CL) + ' ';
      StaticText1.Caption:= OpenDialog1.FileName;
      BitBtn3.Enabled:= true;
      BitBtn1.Enabled:= true;

      i1:= pos(' ',CL);
      wps:= copy(CL,1,i1-1);
      i1:= pos(',',wps);
      longitude:= copy(wps,1,i1-1);
      delete(wps,1,i1);
      i1:= pos(',',wps);
      latitude:= copy(wps,1,i1-1);
      delete(wps,1,i1);
      altitude:= wps;

      StaticText2.Caption:= 'Lat: ' + latitude + '  Lon: ' + longitude;
      FirstWP_GHQ_URL:= 'https://geographiclib.sourceforge.io/cgi-bin/GeoidEval?input=' + latitude + '+' + longitude + '&option=Submit';
      BitBtn3.SetFocus;
    end
  else
    begin
      CL:= '';
      StaticText1.Caption:= '';
      StaticText2.Caption:= '';
      StaticText3.Caption:= '';
      BitBtn3.Enabled:= false;
      BitBtn1.Enabled:= false;
      FirstWP_GHQ_URL:= '';
      BitBtn2.SetFocus;
    end;

end;

procedure TMainF.BitBtn3Click(Sender: TObject);
begin
  BrowseURL(FirstWP_GHQ_URL);
  Edit1.SetFocus;
  Edit1.SelectAll;
end;

procedure TMainF.FormShow(Sender: TObject);
begin
  BitBtn2.SetFocus;
end;

end.
