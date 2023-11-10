unit LineSerieUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, UserTypes, TASeries, TAGraph, LCLType,
  TAChartAxis, TATypes, TALegend, TAChartUtils, StrUtils, ChartUtils, Forms,
  Controls, Dialogs;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
procedure SetLineSerieColor(LineSerie: TLineSeries; AColor: TColor);
function GetColorIndex(n: Byte): Byte;
function GetColorBySerieName(LineSerieName: String): TColor;
function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;
procedure PointersVisible(Visible: Boolean);
procedure ZoomCurrentExtent(Chart1LineSeries: TLineSeries);
function GetFreeLineSerie(ChartNum: Byte): Byte;
procedure SerieReset(LineSerie: TLineSeries);
function GetMinMaxForCurrentExtent(Chart1LineSeries: TLineSeries): TMinMax;
procedure AddLineMarker(AChart: TChart);
function GetLineMarker(Chart: TChart): TConstantLine;

implementation
uses Main;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
begin
  Result := TLineSeries.Create(AChart);
  with TLineSeries(Result) do
  begin
    Name:= AChart.Name + AName;
    Pointer.Style := psCircle;
    Pointer.VertSize:= 2;
    Pointer.HorizSize:= 2;

    LinePen.Width:= 2;
    ShowLines := true;
    LinePen.Style := psSolid;
    Legend.Visible:= False;
    Marks.Style:= smsLabel;
    Marks.LinkPen.Color:= clGray;
  end;
  AChart.AddSeries(Result);
end;

procedure AddLineMarker(AChart: TChart);
var
  line: TConstantLine;
begin
  line := TConstantLine.Create(AChart);
  //line.Position := StartDateTime;
  line.AxisIndex:= 1;
  line.LineStyle := lsVertical;
  line.Pen.Color := clGray;
  line.Name:= AChart.Name + 'LineMarker';
  AChart.AddSeries(line);
end;

procedure PointersVisible(Visible: Boolean);
var i, j : Byte;
begin
  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to MAX_SERIE_NUMBER do begin
        GetLineSerie(i, j).Pointer.Visible:= Visible;
        GetLineSerie(i, j).Pointer.Style := psCircle;
        GetLineSerie(i, j).Pointer.VertSize:= 2;
        GetLineSerie(i, j).Pointer.HorizSize:= 2;
        //GetLineSerie(i, j).Pointer.Brush.Color:= clWhite;
        GetLineSerie(i, j).Pointer.Brush.Style:= bsSolid;
        GetLineSerie(i, j).LinePen.Width:= 1;
    end;
end;

function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;
begin
   Result:= TLineSeries(TChart(App.FindComponent('Chart' + IntToStr(ChartNumber))).Series[LineSerieNumber - 1]);
end;

function GetLineMarker(Chart: TChart): TConstantLine;
begin
   Result:= TConstantLine(Chart.Series[8]);
end;

procedure SetLineSerieColor(LineSerie: TLineSeries; AColor: TColor);
begin
  LineSerie.SeriesColor := AColor;
  LineSerie.Pointer.Brush.Color := AColor;
  LineSerie.Pointer.Pen.Color := AColor;
end;

function GetMinMaxForCurrentExtent(Chart1LineSeries: TLineSeries): TMinMax;
var i, start, count: Longint;
    dr: TDoubleRect;
    Max, Min: Double;
begin
 if Chart1LineSeries.Count > 0 then begin
   Min:= 1.7E308;
   Max:= 5.0E-324;
   count:= Chart1LineSeries.Count - 1;
   dr:= Chart1LineSeries.ParentChart.CurrentExtent;
   start:= 0;
   repeat
     Inc(start);
   until (start = count) Or (Chart1LineSeries.ListSource.Item[start]^.X >= dr.a.X);
   repeat
     Dec(count);
   until (count = 0) Or (Chart1LineSeries.ListSource.Item[count]^.X <= dr.b.X);
   for i:=start to count do begin
     if Chart1LineSeries.ListSource.Item[i]^.Y < Min then Min:= Chart1LineSeries.ListSource.Item[i]^.Y;
     if Chart1LineSeries.ListSource.Item[i]^.Y > Max then Max:= Chart1LineSeries.ListSource.Item[i]^.Y;
   end;
   Result.Min:= Min;
   Result.Max:= Max;
 end;
end;

procedure ZoomCurrentExtent(Chart1LineSeries: TLineSeries);
var MinMax : TMinMax;
    dr     : TDoubleRect;
begin
  if Chart1LineSeries.Count > 0 then begin
     dr:= Chart1LineSeries.ParentChart.LogicalExtent;
     MinMax:= GetMinMaxForCurrentExtent(Chart1LineSeries);
     dr.a.Y:= MinMax.Min;
     dr.b.Y:= MinMax.Max;
     Chart1LineSeries.ParentChart.LogicalExtent:= dr;
     dr:= Chart1LineSeries.ParentChart.LogicalExtent;
  end;
end;

function GetColorIndex(n: Byte): Byte;
begin
  Result:= n - (n Div 8) * 8;
end;

function GetColorBySerieName(LineSerieName: String): TColor;
var Serie, Chart: Byte;
begin
  Chart:= GetChartNumber(LineSerieName) - 1;
  Serie:= StrToInt(MidStr(LineSerieName, 12, 1)) - 1;
  Result:= ChartColors[GetColorIndex(Serie + Chart)];
end;

function GetFreeLineSerie(ChartNum: Byte): Byte;
var i: Byte;
begin
  Result:= 0;
  for i:=1 to MAX_SERIE_NUMBER do
     if GetLineSerie(ChartNum, i).Count = 0 then begin
        Result:= i;
        Exit;
     end;
end;

procedure SerieReset(LineSerie: TLineSeries);
begin
  LineSerie.Clear;
  LineSerie.Title:= '';
  LineSerie.Legend.Visible:= False;
end;

end.

