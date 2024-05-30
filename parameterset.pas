unit ParameterSet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LineSerieUtils, TASeries, TAGraph, ChartUtils, UserTypes, LCLType;

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
    procedure LoadSetClick(Sender: TObject);
    procedure SaveSetClick(Sender: TObject);
  private

  public

  end;

var
  ParamSetFrm: TParamSetFrm;

  procedure SaveParamSet();
  procedure RestoreParamSet();
  function ParamSetEmpty(): Boolean;

implementation

uses Main;

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
var i, j : Integer;
begin
  Source:= -1;
  Channel:= -1;
  for i:= 0 to Length(DataSources)-1 do
    for j:= 0 to Length(DataSources[CurrentSource].TFFDataChannels) - 1 do begin
       if DataSources[i].TFFDataChannels[j].DLIS = name then begin
          Source:= i;
          Channel:= j;
          Exit;
       end;
    end;
end;

procedure RestoreParamSet();
var i, j, n  : Byte;
    Serie    : TLineSeries;
    NewChart : Boolean;
    Source, Channel : Integer;
    Chart    : TChart;
    Objct    : TObject;
begin
  App.CloseChartsClick(Objct);
  for i:=1 to 8 do begin
    NewChart:= True;
    n:= 1;
    for j:=1 to 8 do begin
      if ParamSet.ParamSet[i, j] <> '' then begin
         GetParamPosition(ParamSet.ParamSet[i, j], Source, Channel);
         if (Source > -1) Or (Channel > -1) then begin
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
    AssignFile(ParamSetFile, 'Paramsets.lib');
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
var i, j, n: Byte;
    LastPane, TitleUp: String;
    RecordExist: Boolean;
begin
  if PanelList.Items.Count > 0 then
    if FileExists(LibFileName) then begin
       AssignFile(ParamSetFile, 'Paramsets.lib');
       Reset(ParamSetFile);
       try
         Seek(ParamSetFile, GetSetIndex(ParamSetList.Items[ParamSetList.ItemIndex], RecordExist));
         Read(ParamSetFile, ParamSet);
         CloseFile(ParamSetFile);

         n:=0 ;
         for i:= 1 to 10 do
           for j:= 1 to 4 do
             if CurvesPanel.PaneSet.Panes[i-1].Curves[j-1].Parameter <> '' then n:= n + 1;
         LoadProgress.Max:= n;
         LoadProgress.Position:= 0;
         for i:= 1 to 10 do
           for j:= 1 to 4 do begin
             if CurvesPanel.PaneSet.Panes[i-1].Curves[j-1].Parameter <> '' then begin
                TChart(CSV.FindComponent('Pane' + IntToStr(i))).Left:= 10000;
                TChart(CSV.FindComponent('Pane' + IntToStr(i))).Visible:= true;
                DrawCurveFromPane(TLineSeries(CSV.FindComponent('Pane' + IntToStr(i) + 'Curve' + IntToStr(j))), CurvesPanel.PaneSet.Panes[i-1], i-1, j-1);
                LastPane:= 'Pane' + IntToStr(i);
             end;
             LoadProgress.Position:= LoadProgress.Position + 1;
           end;
         if CSV.ShowDateTime.Checked then TChart(CSV.FindComponent(LastPane)).AxisList[0].Marks.Visible:= True;
         CSV.PanelTitle.Caption:= PanelList.Items[PanelList.ItemIndex];
       except
         on E: EInOutError do ShowMessage('File read error: ' + E.Message);
       end;
    end
    else ShowMessage('Paramsets.lib not found');
    ParamSetFrm.Close;
end;

procedure TParamSetFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

end.

