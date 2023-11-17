unit ChartUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, UserTypes, TASeries, TAGraph, Controls, TATypes, LCLType,
  TAChartUtils, DateUtils, StrUtils, Forms, Dialogs, Utils;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
procedure ChartsVisible(visible: Boolean);
procedure ChartsEnabled(visible: Boolean);
procedure ResetChartsZoom;
procedure RepaintAll;
function GetFreeChart: Byte;
function GetLastChart: Byte;
procedure ChartsHeight();
procedure ChartsPosition();
function GetChartCount: Byte;
function GetChartNumber(ChartName: String): Byte;
procedure ZoomChartCurrentExtent(Chart: TChart);
function GetChart(ChartNubmber: Byte): TChart;
procedure DateTimeLineLineSerieInit;
procedure FindTimeRange;
procedure ChartsNavigation(Value: Boolean);
procedure SetChartsBGColor;

implementation
uses Main, LineSerieUtils;

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

procedure DateTimeLineLineSerieInit;
begin
  DateTimeDrawed:= False;
  App.DateTimeLine.Visible:= False;
  App.DateTimeLineLineSerie.Clear;
  App.DateTimeLineLineSerie.AddXY(StartDateTime, 0);
  App.DateTimeLineLineSerie.AddXY(EndDateTime, 0);
  App.DateTimeLine.Visible:= True;
  Application.ProcessMessages;
  App.DateTimeLine.ZoomFull();
end;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
var
  FramesCount, i  : LongWord;
  Value           : Double;
  iPrevPercent, n : Integer;

begin
  App.ChartScrollBox.Visible:= False;
  LineSerie.Clear;
  LineSerie.Title:= Name;
  LineSerie.Legend.Visible:= True;
  SetLineSerieColor(LineSerie, GetColorBySerieName(LineSerie.Name));
  FramesCount:= Length(DataSources[SelectedSource].FrameRecords);
  ProgressInit(100, 'Process channel');
  iPrevPercent:= 0;

  if FramesCount < 60000 then begin
     App.FastMode.Checked:= False;
     SetFastMode(App.FastMode.Checked);
  end;

  for i:=0 to FramesCount - 1 do begin
    if (i Mod FastModeDivider) = 0 then
      if GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                         DataSources[SelectedSource].FrameRecords[i],
                         SelectedParam,
                         Value) then
      begin
         LineSerie.AddXY(DataSources[SelectedSource].FrameRecords[i].DateTime, Value, '');
      end;

    n:= Trunc(i * 100 / FramesCount);
    if (n > iPrevPercent) then begin
      App.ProcessProgress.Position:= n;
      iPrevPercent:= n;
    end;

  end;
  if LineSerie.Count > 0 then begin
    if SourceCount > 1 then begin
       if CompareDateTime(LineSerie.MinXValue, StartDateTime) < 0 then StartDateTime:= LineSerie.MinXValue;
       if CompareDateTime(LineSerie.MaxXValue, EndDateTime) > 0 then EndDateTime:= LineSerie.MaxXValue;
    end
    else begin
       StartDateTime:= LineSerie.MinXValue;
       EndDateTime:= LineSerie.MaxXValue;
    end;
    DateTimeLineLineSerieInit
  end;
  App.ChartScrollBox.Visible:= True;
end;

procedure FindTimeRange;
var i, j       : Byte;
    LineSerie  : TLineSeries;
    FirstSerie : Boolean;
begin
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
   DateTimeLineLineSerieInit;
end;

function GetChart(ChartNubmber: Byte): TChart;
begin
  Result:= TChart(App.FindComponent('Chart' + IntToStr(ChartNubmber)))
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
var i: Byte;
    MaxTop: Integer;
begin
  MaxTop:= 0;
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible AND (GetChart(i).Top >= MaxTop) then begin
        MaxTop:= GetChart(i).Top;
        Result:= i;
     end;
  end;
end;

function GetFirstChart: Byte;
var i: Byte;
    MinTop, n: Integer;
    v : boolean;
begin
  MinTop:= 65536;
  for i:=1 to MAX_CHART_NUMBER do begin
     n:= GetChart(i).Top;
     v:= GetChart(i).Visible;
     if GetChart(i).Visible AND (GetChart(i).Top <= MinTop) then begin
        MinTop:= GetChart(i).Top;
        Result:= i;
     end;
  end;
end;

function GetFreeChart: Byte;
var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do begin
     if GetChart(i).Visible = false then begin
        Result:= i;
        Break;
     end;
  end;
end;

procedure ChartsVisible(visible: Boolean);
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).Visible:= visible;
end;

procedure ChartsHeight();
var i : byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).Height:= App.ChartScrollBox.Height Div GetChartCount;
end;

procedure ChartsPosition();
var i                : Byte;
    Chart, PrevChart : TChart;
    FirstChart       : Byte;
begin;
   FirstChart:= GetFirstChart;
   PrevChart:= GetChart(FirstChart);
   if ChartsCount = 1 then begin
      PrevChart.Height:= App.ChartScrollBox.Height - FooterSize - 2;
   end
   else
       for i:=1 to MAX_CHART_NUMBER do begin
          Chart:= GetChart(i);
          if Chart.Visible then begin
              Chart.Height:= (App.ChartScrollBox.Height - FooterSize - 2) Div ChartsCount;
              if i <> FirstChart then begin
                 Chart.Top:= ((App.ChartScrollBox.Height - FooterSize) Div ChartsCount) * (i - 1);
                 Chart.AnchorToCompanion(akTop, 0, PrevChart);
              end;
              Chart.AxisList[1].Marks.Visible:= False;
              PrevChart:= Chart;
              Chart.Title.Text[0]:= Chart.Title.Text[0] + ' Top: ' + IntToStr(Chart.Top) + ' F: ' + IntToStr(FirstChart);
          end;
       end;
   GetChart(FirstChart).Top:= 0;
end;

procedure ChartsEnabled(visible: Boolean);
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).Visible:= visible;
end;

procedure ResetChartsZoom;
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).ZoomFull();
end;

procedure RepaintAll;
var i: byte;
begin
  for i:=1 to MAX_CHART_NUMBER do GetChart(i).Repaint;
end;

procedure SetChartsBGColor;
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
    MinMax.Max:= 5.0E-324;
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

end.

