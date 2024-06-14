unit ChartUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, UserTypes, TASeries, TAGraph, Controls, TATypes, LCLType,
  TAChartUtils, DateUtils, StrUtils, Forms, Dialogs, Utils, SIBRParam, uComplex,
  Math, ExtCtrls, Graphics;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
procedure ChartsVisible(visible: Boolean);
procedure ChartsEnabled(visible: Boolean);
procedure ResetChartsZoom;
procedure RepaintAll;
function GetChartNumberStr(Chart: String): String;
function GetFreeChart: Byte;
function GetLastChart: Byte;
procedure ChartsHeight();
procedure ChartsPosition();
function GetChartCount: Byte;
function GetChartNumber(ChartName: String): Byte;
procedure ZoomChartCurrentExtent(Chart: TChart);
procedure ZoomFullAll();
function GetChart(ChartNubmber: Byte): TChart;
function GetSplitter(SplitterNubmber: Byte): TSplitter;
procedure DateTimeLineSerieInit;
procedure FindTimeRange;
procedure ChartsNavigation(Value: Boolean);
procedure SetChartsBGColor;
procedure DeleteVerticalLine(Chart: TChart; n: Byte);
procedure DeleteHorizontalLine(Chart: TChart; n: Byte);
procedure DeleteVertLines(Chart: TChart);
procedure DeleteHorLines(Chart: TChart);
procedure CutChart(Chart: TChart);
procedure CropChart(Chart: TChart);
procedure RemoveEmptyCharts();
procedure DeleteChart(Chart: TChart);
procedure ChartStartDateLimit(Chart: TChart);
procedure ChartEndDateLimit(Chart: TChart);
function GetFirstVisibleChart: Byte;
function GetChannelValue(DataChannels: TTFFDataChannels; Frame: TFrameRecord; Channel: Word; var Value: Double): Boolean;
procedure SetHorizontalExtent(Chart: TChart);
procedure RemoveAllLabels();

implementation
uses Main, LineSerieUtils, channelsform;

function GetChannelValue(DataChannels: TTFFDataChannels; Frame: TFrameRecord; Channel: Word; var Value: Double): Boolean;
var Offset : Word;
    I1     : ShortInt;
    U1     : Byte;
    I2     : SmallInt;
    U2     : Word;
    I4     : LongInt;
    U4     : LongWord;
    F4     : Single;
    F8     : Double;

begin
  Result:= True;
  Value:= 0;
  Offset:= DataChannels[Channel].Offset;
  if Channel = 0 then Value:= Frame.DateTime
  else
    case DataChannels[Channel].RepCode of
    'F4': begin
            Move(Frame.Data[Offset], F4, 4);
            if (F4 = -999.25) then Result:= False
            else Value:= F4;
          end;
    'F8': begin
            Move(Bytes[DataOffset], F8, 8);
            if (F8 = -999.25) then Result:= False
            else Value:= F8;
          end;
    'I1': begin
            Move(Frame.Data[Offset], I1, 1);
            if (I1 = 127) then Result:= False
            else Value:= I1;
          end;
    'U1': begin
            Move(Frame.Data[Offset], U1, 1);
            if (U1 = 255) then Result:= False
            else Value:= U1;
          end;
    'I2': begin
             Move(Frame.Data[Offset], I2, 2);
             if (I2 = 32767) then Result:= False
             else Value:= I2;
          end;
    'U2': begin
             Move(Frame.Data[Offset], U2, 2);
             if (U2 = 65535) then Result:= False
             else Value:= U2;
          end;
    'U4': begin
             Move(Frame.Data[Offset], U4, 4);
             if (U4 = 4294967295) then Result:= False
             else Value:= U4;
          end;
    'I4': begin
            Move(Frame.Data[Offset], I4, 4);
            if (I4 = 2147483647) then Result:= False
            else Value:= I4;
          end;
    end;
end;

procedure DateTimeLineSerieInit;
var LastChart: TChart;
begin
  App.DateTimeLine.Visible:= False;
  if (ChartsCount > 0) And App.ByTymeCh.Checked then begin
    App.DateTimeLineLineSerie.Clear;
    App.DateTimeLineLineSerie.AddXY(StartDateTime, 0);
    App.DateTimeLineLineSerie.AddXY(EndDateTime, 0);
    App.DateTimeLine.Visible:= True;
    //Application.ProcessMessages;
    //App.DateTimeLine.ZoomFull();
  end;
end;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
var
  FramesCount, i  : LongWord;
  DotNumber       : LongWord = 0;
  Value, BHTValue : Double;
  iPrevPercent, n : Integer;
  PrevDateTime    : TDateTime = 0;
  Sticker         : String = '';
  nPoins          : LongWord = 0;
  StartParamPos,
  Step, numParam  : Integer;
  RawR, RawX      : Double;
  isAplitude      : Boolean = False;
  isPhaseShift    : Boolean = False;
  ValidValue      : Boolean;
  AddMilliSeconds : Word = 200;

begin
  //App.ChartExtentLink1.Enabled:= False;
  LineSerie.Clear;
  LineSerie.Title:= AddLidZeros(IntToStr(SelectedSource + 1), 2) + '.' + Name;
  LineSerie.Legend.Visible:= True;
  SetLineSerieColor(LineSerie, GetColorBySerieName(LineSerie.Name));
  FramesCount:= Length(DataSources[SelectedSource].FrameRecords);
  ProgressInit(100, 'Process channel');
  iPrevPercent:= 0;
  //NewSerieDrawed:= True;

  if FramesCount < 60000 then begin
     ShowChannelForm.FastMode.Checked:= False;
     SetFastMode(ShowChannelForm.FastMode.Checked);
  end;

  if FindPart('AR???F', Name) > 0 then isAplitude:= True;
  if FindPart('PR???F', Name) > 0 then isPhaseShift:= True;

  if isAplitude Or isPhaseShift then begin
      numParam:= NameToInt(Name);
      if numParam >= 1000 then begin
        StartParamPos:= GetParamPosition('VR1C0F1r');
        numParam:= numParam - 1000;
      end
      else StartParamPos:= GetParamPosition('VR1T0F1r');
      if (numParam mod 2) = 0 then Step:= (numParam div 2) * 8
      else Step:= ((numParam div 2) * 8) + 2;
  end;

  ValidValue:= True;
  for i:=0 to FramesCount - 1 do begin
    if (i Mod FastModeDivider) = 0 then

      if Name in CondChannels then Value:= GetSonde(SelectedSource, Name, i)
      else if Name in CondCompChannels then Value:= GetCompSonde(SelectedSource, Name, i)
           else begin
              if isAplitude Or isPhaseShift then begin
                  ValidValue:= GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                                 DataSources[SelectedSource].FrameRecords[i],
                                 StartParamPos + Step,
                                 RawR);
                  ValidValue:= GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                                 DataSources[SelectedSource].FrameRecords[i],
                                 StartParamPos + Step + 1,
                                 RawX) And ValidValue;

                  if isAplitude then Value:= Sqrt(Sqr(RawR)+Sqr(RawX));
                  if isPhaseShift then
                    if RawR <> 0 then Value:= Angle(cInit(RawR, RawX)) * 180/Pi;
              end
              else ValidValue:= GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                                 DataSources[SelectedSource].FrameRecords[i],
                                 SelectedParam,
                                 Value);
           end;

      if ValidValue then begin
             if App.ByTymeCh.Checked then begin
                if (DataSources[SelectedSource].FrameRecords[i].DateTime >= App.StartChartsFrom.DateTime) And
                   (DataSources[SelectedSource].FrameRecords[i].DateTime <= App.EndPoint.DateTime) then begin
                   if (DataSources[SelectedSource].FrameRecords[i].DateTime >= PrevDateTime) Or Not App.RTCBugs.Checked then begin
                      if (Value <> +infinity) And (Value <> -infinity) And (Value <> ParameterError)then begin
                         if DataSources[SelectedSource].FrameRecords[i].DateTime = PrevDateTime then begin
                            LineSerie.AddXY(IncMilliSecond(DataSources[SelectedSource].FrameRecords[i].DateTime, AddMilliSeconds), Value, Sticker);
                            Inc(AddMilliSeconds, 200)
                         end
                         else begin
                            LineSerie.AddXY(DataSources[SelectedSource].FrameRecords[i].DateTime, Value, Sticker);
                            AddMilliSeconds:= 200;
                         end;
                      end;
                      Sticker:= '';
                      Inc(nPoins);
                   end
                   else begin
                      if App.ShowBackInTime.Checked then Sticker:= 'Shift back in time';
                   end;
                   PrevDateTime:= DataSources[SelectedSource].FrameRecords[i].DateTime;
                end;
             end
             else begin
                LineSerie.AddXY(DotNumber, Value);
                Inc(DotNumber);
             end;
      end;

    n:= Trunc(i * 100 / FramesCount);
    if (n > iPrevPercent) then begin
      App.ProcessProgress.Position:= n;
      iPrevPercent:= n;
    end;

  end;
  StartDateTime:= LineSerie.MinXValue;
  EndDateTime:= LineSerie.MaxXValue;
  ChartsCurrentExtent:= App.DateTimeLine.CurrentExtent;
  FindTimeRange();
  ProgressDone();
end;

procedure FindTimeRange();
var i, j       : Byte;
    LineSerie  : TLineSeries;
    FirstSerie : Boolean;
begin
  if ChartsCount > 0 then begin
    FirstSerie:= True;
    for i:=1 to MAX_CHART_NUMBER do
      if GetChart(i).Visible then
        for j:=1 to MAX_SERIE_NUMBER do begin
           LineSerie:= GetLineSerie(i, j);
           if LineSerie.Count > 0 then begin
              if FirstSerie then begin
                 StartDateTime:= LineSerie.MinXValue;
                 EndDateTime:= LineSerie.MaxXValue;
                 FirstSerie:= False;
              end
              else begin
                if CompareDateTime(LineSerie.MinXValue, StartDateTime) < 0 then StartDateTime:= LineSerie.MinXValue;
                if CompareDateTime(LineSerie.MaxXValue, EndDateTime) > 0 then EndDateTime:= LineSerie.MaxXValue;
              end;
           end;
        end;
     DateTimeLineSerieInit;
     App.Timer.Enabled:= True;
  end;
end;

function GetChart(ChartNubmber: Byte): TChart;
begin
  Result:= TChart(App.FindComponent('Chart' + IntToStr(ChartNubmber)))
end;

function GetSplitter(SplitterNubmber: Byte): TSplitter;
begin
  Result:= TSplitter(App.FindComponent('Splitter' + IntToStr(SplitterNubmber)))
end;

function GetChartNumberStr(Chart: String): String;
begin
  Result:= ReplaceText('Chart', Chart, '');
end;

function GetChartCount: Byte;
var i, n: Byte;
begin
  n:= 0;
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible then Inc(n);
  end;
  Result:= n;
end;

function GetLastChart: Byte;
var i      : Byte;
    MaxTop : Integer;
    Chart  : TChart;
begin
  MaxTop:= 0;
  Result:= 0;
  for i:=1 to MAX_CHART_NUMBER do begin
     Chart:= GetChart(i);
     if Chart.Visible AND (Chart.Top >= MaxTop) then begin
        MaxTop:= Chart.Top;
        Result:= i;
     end;
  end;
end;

function GetFirstChart: Byte;
var i      : Byte;
    MinTop : Integer;

begin
  MinTop:= 65536;
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible AND (GetChart(i).Top <= MinTop) then begin
        MinTop:= GetChart(i).Top;
        Result:= i;
     end;
  end;
end;

function GetFreeChart: Byte;
var i: Byte;
begin
  Result:= 0;
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible = false then begin
        Result:= i;
        Break;
     end;
  end;
end;

function GetFirstVisibleChart: Byte;
var i: Byte;
begin
  Result:= 0;
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible then begin
        Result:= i;
        Break;
     end;
  end;
end;

procedure ChartsVisible(visible: Boolean);
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
    GetChart(i).Visible:= visible;
    GetSplitter(i).Visible:= visible;
  end;
end;

procedure ChartsHeight();
var i : byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).Height:= App.ChartScrollBox.Height Div GetChartCount;
end;

procedure ChartsPosition();
var i, n             : Byte;
    Chart, PrevChart : TChart;
    FirstChart       : Byte;
    Splitter         : TSplitter;
    PrevSplitter     : TSplitter;
begin;
   FirstChart:= GetFirstChart;
   PrevChart:= GetChart(FirstChart);
   PrevSplitter:= GetSplitter(FirstChart);
   PrevSplitter.Top:= 0;
   n:= 1;
   if ChartsCount = 1 then begin
      PrevChart.Height:= App.ChartScrollBox.Height - FooterSize - 2;
   end
   else
       for i:=1 to MAX_CHART_NUMBER do begin
          Chart:= GetChart(i);
          Splitter:= GetSplitter(i);
          if Chart.Visible then begin
              Chart.Height:= (App.ChartScrollBox.Height - FooterSize - 2) Div ChartsCount;
              if i <> FirstChart then begin
                 Splitter.Top:= ((App.ChartScrollBox.Height - FooterSize) Div ChartsCount) * (n - 1);
                 PrevChart.AnchorToNeighbour(akBottom, 0, Splitter);
              end;
              Inc(n);
              Chart.AxisList[1].Marks.Visible:= False;
              PrevChart:= Chart;
              PrevSplitter:= Splitter;
              Chart.Title.Text[0]:= Chart.Title.Text[0] + ' Top: ' + IntToStr(Chart.Top) + ' F: ' + IntToStr(FirstChart)
          end;
       end;
   PrevChart.AnchorToNeighbour(akBottom, 0, App.DateTimeLine);
end;

procedure ChartsEnabled(visible: Boolean);
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
    GetChart(i).Visible:= visible;
    GetSplitter(i).Visible:= visible;
  end;
end;

procedure ResetChartsZoom();
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).ZoomFull();
end;

procedure RepaintAll();
var i     : byte;
    Chart : TChart;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
    Chart:= GetChart(i);
    if Chart.Visible then Chart.Repaint;
  end;
end;

procedure SetChartsBGColor();
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).BackColor:= App.GChartBGColor.Selected;
end;

procedure ChartsNavigation(Value: Boolean);
var i     : byte;
    Chart : TChart;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
    Chart:= GetChart(i);
    Chart.AllowPanning:= Value;
    Chart.AllowZoom:= Value;
  end;
end;

function GetChartNumber(ChartName: String): Byte;
begin
  Result:= StrToInt(MidStr(ChartName, 6, 1));
end;

procedure ZoomChartCurrentExtent(Chart: TChart);
var MinMax, wMinMax    : TMinMax;
    dr                 : TDoubleRect;
    i                  : Byte;
    Serie              : TLineSeries;
begin
  if Chart.Visible then begin
    MinMax.Min:= 1.7E308;
    MinMax.Max:= 2.0E-324;
    for i:=0 to MAX_SERIE_NUMBER - 1 do begin
      Serie:= TLineSeries(Chart.Series[i]);
      if Serie.Count > 0 then begin
         wMinMax:= GetMinMaxForCurrentExtent(Serie);
         if wMinMax.Min < MinMax.Min then MinMax.Min:= wMinMax.Min;
         if wMinMax.Max > MinMax.Max then MinMax.Max:= wMinMax.Max;
      end;
    end;
    dr:= Chart.LogicalExtent;
    dr.a.Y:= MinMax.Min;
    dr.b.Y:= MinMax.Max;
    Chart.LogicalExtent:= dr;
  end;
end;

procedure ZoomFullAll();
var i     : byte;
    Chart : TChart;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
    Chart:= GetChart(i);
    if Chart.Visible then Chart.ZoomFull();
  end;
end;

procedure DeleteChart(Chart: TChart);
var Splitter : TSplitter;
begin
  DeleteVertLines(Chart);
  DeleteHorLines(Chart);
  Splitter:= GetSplitter(GetChartNumber(Chart.Name));
  Chart.Visible:= False;
  Splitter.Visible:= False;
  Dec(ChartsCount);
  FindTimeRange;
  if ChartsCount > 0 then
    ChartsPosition()
  else begin
     App.DateTimeLineLineSerie.Clear;
     App.DateTimeLine.Visible:= False;
  end;
end;

procedure RemoveEmptyChart(Chart: TChart);
var i          : Byte;
    SerieExist : Boolean = False;
begin
  if Chart.Visible then begin
    for i:=1 to MAX_SERIE_NUMBER do begin
       if TLineSeries(Chart.Series[i - 1]).Count > 0 then SerieExist:= True;
    end;
    if Not SerieExist then DeleteChart(Chart);
  end;
end;

procedure RemoveEmptyCharts();
var i : Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do RemoveEmptyChart(GetChart(i))
end;

procedure DeleteVerticalLine(Chart: TChart; n: Byte);
var i   : Byte;
    nStr: String;
begin
  if VertLineCount < 10 then nStr:= '0'+ IntToStr(n)
  else nStr:= IntToStr(n);
  for i:=MAX_SERIE_NUMBER + 1 to Chart.SeriesCount do begin
    if NPos('VerticalLine' + nStr, Chart.Series[i - 1].Name, 1) > 0 then begin
       Chart.Series[i - 1].Destroy;
       Dec(VertLineCount);
       Exit;
    end;
  end;
end;

procedure DeleteHorizontalLine(Chart: TChart; n: Byte);
var i   : Byte;
    nStr: String;
begin
  if VertLineCount < 10 then nStr:= '0'+ IntToStr(n)
  else nStr:= IntToStr(n);
  for i:=MAX_SERIE_NUMBER + 1 to Chart.SeriesCount do begin
    if NPos('HorizontalLine' + nStr, Chart.Series[i - 1].Name, 1) > 0 then begin
       Chart.Series[i - 1].Destroy;
       Dec(HorLineCount);
       Exit;
    end;
  end;
end;

procedure DeleteVertLines(Chart: TChart);
var i, n: Byte;
begin
  n:= Chart.SeriesCount;
  i:= 0;
  repeat
    if NPos('VerticalLine', Chart.Series[i].Name, 1) > 0 then begin
      Chart.Series[i].Destroy;
      Dec(VertLineCount);
      Dec(n);
      Dec(i);
    end;
    Inc(i);
  until i >= n;
end;

procedure DeleteHorLines(Chart: TChart);
var i, n: Byte;
begin
  n:= Chart.SeriesCount;
  i:= 0;
  repeat
    if NPos('HorizontalLine', Chart.Series[i].Name, 1) > 0 then begin
      Chart.Series[i].Destroy;
      Dec(HorLineCount);
      Dec(n);
      Dec(i);
    end;
    Inc(i);
  until i >= n;
end;

procedure CropChart(Chart: TChart);
var i : Byte;
begin
  if Chart.Visible then begin
    for i:=0 to MAX_SERIE_NUMBER - 1 do CropSerie(TLineSeries(Chart.Series[i]));
    RemoveEmptyChart(Chart);
  end;
end;

procedure CutChart(Chart: TChart);
var i : Byte;
begin
  if Chart.Visible then begin
    for i:=0 to MAX_SERIE_NUMBER - 1 do CutSerie(TLineSeries(Chart.Series[i]));
    RemoveEmptyChart(Chart);
  end;
end;

procedure ChartStartDateLimit(Chart: TChart);
var i : Byte;
begin
  if Chart.Visible then begin
    for i:=0 to MAX_SERIE_NUMBER - 1 do SerieStartDateLimit(TLineSeries(Chart.Series[i]));
  end;
end;

procedure ChartEndDateLimit(Chart: TChart);
var i : Byte;
begin
  if Chart.Visible then begin
    for i:=0 to MAX_SERIE_NUMBER - 1 do SerieEndDateLimit(TLineSeries(Chart.Series[i]));
  end;
end;

procedure SetHorizontalExtent(Chart: TChart);
var Ext: TDoubleRect;
begin
   Ext := Chart.GetFullExtent;
   Ext.coords[1]:= ChartsCurrentExtent.coords[1];
   Ext.coords[3]:= ChartsCurrentExtent.coords[3];
   Chart.LogicalExtent:= Ext;
end;

procedure RemoveChartLabels(Chart: TChart);
var i: Integer;
begin
  if Chart.Visible then begin
    for i:=0 to MAX_SERIE_NUMBER - 1 do RemoveLineLabels(TLineSeries(Chart.Series[i]));
  end;
end;

procedure RemoveAllLabels();
var i: Integer;
begin
  for i:=1 to MAX_CHART_NUMBER do RemoveChartLabels(GetChart(i));
end;

end.

