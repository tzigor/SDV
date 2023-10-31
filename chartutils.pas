unit ChartUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, UserTypes, TASeries, LineSerieUtils, TAGraph, Controls;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
procedure ChartsVisible(visible: Boolean);
procedure ChartsEnabled(visible: Boolean);
procedure ResetChartsZoom;
function GetFreeChart: Byte;
function GetLastChart: Byte;
procedure ChartsHeight();
procedure ChartsPosition();
function GetChartCount: Byte;

implementation
uses Main;

function GetChannelValue(DataChannels: TTFFDataChannels; Frame: TFrameRecord; Channel: Word; var Value: Double): Boolean;
var Offset : Word;
    I1     : ShortInt;
    U1     : Byte;
    I2     : SmallInt;
    U2     : Word;
    I4     : LongInt;
    U4     : LongWord;
    U8     : QWord;
    F4     : Single;
    F8     : Double;

begin
  Result:= True;
  Offset:= DataChannels[Channel].Offset;
  case DataChannels[Channel].RepCode of
  'F4': begin
          Move(Frame.Data[Offset], F4, 4);
          if (F4 = -999.25) then Result:= False
          else Value:= F4;
        end;
  'F8': begin
          Move(Bytes[DataOffset], F8, 8);
          if (F4 = -999.25) then Result:= False
          else Value:= F8;
        end;
  'I1': begin
          Move(Frame.Data[Offset], I1, 1);
          if (I1 = 127) then Result:= False
          else Value:= I1;
        end;
  'U1': begin
          Move(Frame.Data[Offset], U1, 1);
          if (I1 = 255) then Result:= False
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

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
var
  FramesCount, i : LongWord;
  Value          : Double;
begin
  LineSerie.Clear;
  LineSerie.Title:= Name;
  SetLineSerieColor(LineSerie, GetColorBySerieName(LineSerie.Name));
  LineSerie.Legend.Visible:= True;
  FramesCount:= Length(DataSources[SelectedSource].FrameRecords);
  for i:=0 to FramesCount - 1 do begin
    GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                    DataSources[SelectedSource].FrameRecords[i],
                    SelectedParam,
                    Value);
    LineSerie.AddXY(DataSources[SelectedSource].FrameRecords[i].DateTime, Value, '');
  end;
end;

function GetChartCount: Byte;
var i, n: Byte;
begin
  n:= 0;
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible then Inc(n);
  end;
  Result:= n;
end;

function GetLastChart: Byte;
var i: Byte;
    MaxTop: Integer;
begin
  MaxTop:= 0;
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible AND (TChart(App.FindComponent('Chart' + IntToStr(i))).Top >= MaxTop) then begin
        MaxTop:= TChart(App.FindComponent('Chart' + IntToStr(i))).Top;
        Result:= i;
     end;
  end;
end;

function GetFirstChart: Byte;
var i: Byte;
    MinTop: Integer;
begin
  MinTop:= App.ChartScrollBox.Height;
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible AND (TChart(App.FindComponent('Chart' + IntToStr(i))).Top <= MinTop) then begin
        MinTop:= TChart(App.FindComponent('Chart' + IntToStr(i))).Top;
        Result:= i;
     end;
  end;
end;

function GetFreeChart: Byte;
var i: Byte;
begin
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible = false then begin
        Result:= i;
        Break;
     end;
  end;
end;

procedure ChartsVisible(visible: Boolean);
var i: byte;
begin
  for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).Visible:= visible;
end;

procedure ChartsHeight();
var i : byte;
begin
  for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).Height:= App.ChartScrollBox.Height Div GetChartCount;
end;

procedure ChartsPosition();
const FooterSize = 40;
var i                : Byte;
    Chart, PrevChart : TChart;
    LastChart        : Byte;
begin;
   PrevChart:= TChart(App.FindComponent('Chart' + IntToStr(1)));
   for i:=1 to ChartsCount do begin
      Chart:= TChart(App.FindComponent('Chart' + IntToStr(i)));
      if ChartsCount > 1 then Chart.Height:= (App.ChartScrollBox.Height - FooterSize - 4) Div ChartsCount
      else Chart.Height:= App.ChartScrollBox.Height;
      Chart.Top:= 0;

      if i > 1 then begin
         Chart.Top:= (App.ChartScrollBox.Height Div ChartsCount) * (i - 1);
         Chart.AnchorToNeighbour(akTop, 0, PrevChart);
      end;

      Chart.AxisList[1].Marks.Visible:= False;
      PrevChart:= Chart;
   end;
   LastChart:= GetLastChart;
   if ChartsCount > 1 then
       TChart(App.FindComponent('Chart' + IntToStr(LastChart))).Height:= TChart(App.FindComponent('Chart' + IntToStr(LastChart))).Height + FooterSize;
   TChart(App.FindComponent('Chart' + IntToStr(LastChart))).AxisList[1].Marks.Visible:= True;
end;

procedure ChartsEnabled(visible: Boolean);
var i: byte;
begin
  for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).Visible:= visible;
end;

procedure ResetChartsZoom;
var i: byte;
begin
  for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).ZoomFull();
end;

end.

