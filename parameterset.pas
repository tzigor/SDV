unit ParameterSet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LineSerieUtils, TASeries, TAGraph, ChartUtils, UserTypes, LCLType, StrUtils;

type

  { TParamSetFrm }

  TParamSetFrm = class(TForm)
    CloseBtn: TButton;
    DeleteSet: TBitBtn;
    LoadSet: TButton;
    SaveSet: TButton;
    ParamSetName: TEdit;
    Label1: TLabel;
    ParamSetList: TListBox;
    procedure CloseBtnClick(Sender: TObject);
    procedure DeleteSetClick(Sender: TObject);
    procedure LoadSetClick(Sender: TObject);
    procedure ParamSetListClick(Sender: TObject);
    procedure ParamSetListDblClick(Sender: TObject);
    procedure SaveSetClick(Sender: TObject);
  private

  public

  end;

var
  ParamSetFrm: TParamSetFrm;

  procedure SaveParamSet();
  procedure RestoreParamSet();
  function ParamSetEmpty(): Boolean;
  procedure ParamSetClear();
  procedure FillSetList();

implementation

uses Main, channelsform;

function GetSetIndex(Name: String; var RecordExist: Boolean): Integer;
var FilePos : Integer;
    Data    : TParamSet;
begin
   FilePos:= 0;
   RecordExist:= false;
   Reset(ParamSetFile);
   while not eof(ParamSetFile) do begin
      Read(ParamSetFile, Data);
      if Name = Data.Name then begin
        RecordExist:= true;
        break;
      end;
      FilePos:= FilePos + 1;
   end;
   Result:= FilePos;
end;

function GetSetIndexForWrite(): Integer;
var FilePos: Integer;
    Data: TParamSet;
begin
   FilePos:= 0;
   Reset(ParamSetFile);
   while not eof(ParamSetFile) do begin
      Read(ParamSetFile, Data);
      if Data.Name = '' then break;
      FilePos:= FilePos + 1;
   end;
   Result:= FilePos;
end;

function ParamSetEmpty(): Boolean;
var i, j : Byte;
begin
  Result:= True;
  for i:=1 to 8 do
    for j:=1 to 8 do
      if ParamSet.ParamSet[i, j] <> '' then begin
         Result:= False;
         Exit
      end;
end;

procedure ParamSetClear();
var i, j : Byte;
begin
  for i:=1 to 8 do
    for j:=1 to 8 do ParamSet.ParamSet[i, j]:= '';
end;

procedure SaveParamSet();
var i, j  : Byte;
    Serie : TLineSeries;
begin
  for i:=1 to 8 do begin
    for j:=1 to 8 do begin
      Serie:= GetLineSerie(i, j);
      if Serie.Count = 0 then ParamSet.ParamSet[i, j]:= ''
      else ParamSet.ParamSet[i, j]:= GetSerieName(Serie);
    end;
  end;
end;

procedure GetParamPosition(name: String; var Source: Integer; var Channel: Integer);
var i, j      : Integer;
    SIBRParam : Boolean = False;
begin
  Source:= -1;
  Channel:= -1;
  if (FindPart('AR???F', Name) > 0) Or (FindPart('PR???F', Name) > 0) Or (Name in CondChannels) Or (Name in CondCompChannels) then SIBRParam:= True;
  for i:= 0 to Length(DataSources)-1 do
    for j:= 0 to Length(DataSources[i].TFFDataChannels) - 1 do begin
       if DataSources[i].TFFDataChannels[j].DLIS = name then begin
          Source:= i;
          Channel:= j;
          Exit;
       end
       else if (DataSources[i].TFFDataChannels[j].DLIS = 'VR1T0F1r') And SIBRParam then begin
               Source:= i;
               Channel:= 32767;
               Exit;
            end;
    end;
end;

procedure FillSetList();
var Data: TParamSet;
begin
  if FileExists(ParamSetFileName) then begin
     ParamSetFrm.ParamSetList.Clear;
     AssignFile(ParamSetFile, ParamSetFileName);
     Reset(ParamSetFile);
     try
        while not eof(ParamSetFile) do begin
           Read(ParamSetFile, Data);
           if Data.Name <> '' then ParamSetFrm.ParamSetList.Items.Add(Data.Name);
        end;
        CloseFile(ParamSetFile);
     except
        on E: EInOutError do ShowMessage('File read error: ' + E.Message);
     end;
  end
  else begin
     AssignFile(ParamSetFile, ParamSetFileName);
     ReWrite(ParamSetFile);
     CloseFile(ParamSetFile);
  end;
  ShowChannelForm.Close;
  ParamSetFrm.Show;
end;

procedure RestoreParamSet();
var i, j, n  : Byte;
    NewChart : Boolean;
    Source, Channel : Integer;
    Chart    : TChart;
begin
  App.CloseChartsClick(Nil);
  for i:=1 to 8 do begin
    NewChart:= True;
    n:= 1;
    for j:=1 to 8 do begin
      if ParamSet.ParamSet[i, j] <> '' then begin
         GetParamPosition(ParamSet.ParamSet[i, j], Source, Channel);
         if (Source > -1) And (Channel > -1) then begin
            if NewChart then begin
               CurrentChart:= GetFreeChart;
               Inc(ChartsCount);
               NewChart:= False;
            end;
            Chart:= GetChart(CurrentChart);
            DrawSerie(GetLineSerie(CurrentChart, n), Source, Channel, ParamSet.ParamSet[i, j]);
            Chart.Visible:= True;
            GetSplitter(GetChartNumber(Chart.Name)).Visible:= True;
            ChartsPosition();
            Inc(n);
         end;
      end;
    end;
  end;
end;

{$R *.lfm}

{ TParamSetFrm }

procedure TParamSetFrm.SaveSetClick(Sender: TObject);
var FilePos: Integer;
    WriteAccept, RecordExist: Boolean;
begin
  if ParamSetName.Text <> '' then begin
    AssignFile(ParamSetFile, ParamSetFileName);
    try
      WriteAccept:= true;
      Reset(ParamSetFile);
      ParamSet.Name:= ParamSetName.Text;

      FilePos:= GetSetIndex(ParamSetName.Text, RecordExist);
      if RecordExist then begin
         if Application.MessageBox('Do you really want to overwrite record?','Warning', MB_ICONQUESTION + MB_YESNO) = IDNO then WriteAccept:= false;
      end
      else FilePos:= GetSetIndexForWrite();
      if WriteAccept then begin
         Seek(ParamSetFile, FilePos);
         Write(ParamSetFile, ParamSet);
         ParamSetClear();
      end;
      CloseFile(ParamSetFile);
    except
      on E: EInOutError do ShowMessage('File write error: ' + E.ClassName + '/' + E.Message)
    end;
    Close;
  end
  else ShowMessage('Please enter a name');
end;

procedure TParamSetFrm.LoadSetClick(Sender: TObject);
var RecordExist: Boolean;
begin
  if ParamSetList.ItemIndex > -1 then
    if FileExists(ParamSetFileName) then begin
       AssignFile(ParamSetFile, ParamSetFileName);
       Reset(ParamSetFile);
       try
         Seek(ParamSetFile, GetSetIndex(ParamSetList.Items[ParamSetList.ItemIndex], RecordExist));
         Read(ParamSetFile, ParamSet);
         CloseFile(ParamSetFile);
         RestoreParamSet();
         ParamSetClear();
       except
         on E: EInOutError do ShowMessage('File read error: ' + E.Message);
       end;
    end
    else ShowMessage('Paramsets.lib not found');
    ParamSetFrm.Close;
end;

procedure TParamSetFrm.DeleteSetClick(Sender: TObject);
var FilePos: Integer;
  RecordExist: Boolean;
begin
  if ParamSetList.ItemIndex > -1 then
    if Application.MessageBox('Are you sure?','Warning', MB_ICONQUESTION + MB_YESNO) = IDYES then begin
       AssignFile(ParamSetFile, ParamSetFileName);
       try
          ParamSet.Name:= '';
          Reset(ParamSetFile);
          FilePos:= GetSetIndex(ParamSetList.Items[ParamSetList.ItemIndex], RecordExist);
          Seek(ParamSetFile, FilePos);
          Write(ParamSetFile, ParamSet);
          CloseFile(ParamSetFile);
       except
         on E: EInOutError do ShowMessage('File write error: ' + E.ClassName + '/' + E.Message)
       end;
       Close;
    end;
end;

procedure TParamSetFrm.ParamSetListClick(Sender: TObject);
begin
  ParamSetName.Text:= ParamSetList.Items[ParamSetList.ItemIndex];
end;

procedure TParamSetFrm.ParamSetListDblClick(Sender: TObject);
var Objct: TObject;
begin
  if (LibMode = 2) Or (LibMode = 3) then ParamSetFrm.LoadSetClick(Objct);
end;

procedure TParamSetFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;


end.

