unit LineSerieUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, UserTypes, TASeries, TAGraph, LCLType,
  TAChartAxis, TATypes, TALegend, TAChartUtils, StrUtils, ChartUtils, Forms,
  Controls, Dialogs;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
procedure SetLineSeriesStyle();
procedure SetLineSerieColor(LineSerie: TLineSeries; AColor: TColor);
function GetColorIndex(n: Byte): Byte;
function GetColorBySerieName(LineSerieName: String): TColor;
function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;
function GetConstLineSerie(ChartNumber, LineSerieNumber: Byte): TConstantLine;
procedure PointersVisible(Visible: Boolean);
procedure ZoomCurrentExtent(Chart1LineSeries: TLineSeries);
function GetFreeLineSerie(ChartNum: Byte): Byte;
procedure SerieReset(LineSerie: TLineSeries);
function GetMinMaxForCurrentExtent(Chart1LineSeries: TLineSeries): TMinMax;
function GetLineMarker(Chart: TChart): TConstantLine;
procedure SeriesReset();
procedure SetAllLineSeriesColor();
function GetSerieSource(SerieTitle: String): Byte;
function AddConstLineSerie(AChart: TChart; AName: String; Pos: Double): TConstantLine;

implementation
uses Main;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
begin
  Result := TLineSeries.Create(AChart);
  with TLineSeries(Result) do
  begin
    Name:= AChart.Name + AName;
    Pointer.Style := App.GPointerStyleBox.PointerStyle;
    Pointer.VertSize:= App.GPointSizeBox.ItemIndex + 2;
    Pointer.HorizSize:= App.GPointSizeBox.ItemIndex + 2;

    LinePen.Width:= App.GLineWidthBox.PenWidth;
    LinePen.Style := App.GLineStyleBox.PenStyle;
    ShowLines := true;
    Legend.Visible:= False;
    Marks.Style:= smsLabel;
    Marks.LinkPen.Color:= clGray;
  end;
  AChart.AddSeries(Result);
end;

function AddConstLineSerie(AChart: TChart; AName: String; Pos: Double): TConstantLine;
begin
  Result := TConstantLine.Create(AChart);
  TConstantLine(Result).Name:= AChart.Name + AName;
  TConstantLine(Result).AxisIndex:= 1;
  TConstantLine(Result).LineStyle:= lsVertical;
  TConstantLine(Result).SeriesColor:= App.VertLineColor.Selected;
  TConstantLine(Result).Pen.Style:= App.VertLineStyle.PenStyle;
  TConstantLine(Result).Pen.Width:= App.VertLineWidth.PenWidth;
  TConstantLine(Result).Position:= Pos;
  AChart.AddSeries(Result);
end;

procedure SetLineSeriesStyle();
var i, j  : Byte;
    Serie : TLineSeries;
begin
  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to MAX_SERIE_NUMBER do begin
       Serie:= GetLineSerie(i, j);
       Serie.LinePen.Width:= App.GLineWidthBox.PenWidth;
       Serie.LinePen.Style := App.GLineStyleBox.PenStyle;
       Serie.Pointer.Style := App.GPointerStyleBox.PointerStyle;
       Serie.Pointer.VertSize:= App.GPointSizeBox.ItemIndex + 2;
       Serie.Pointer.HorizSize:= App.GPointSizeBox.ItemIndex + 2;
    end;
end;

procedure PointersVisible(Visible: Boolean);
var i, j : Byte;
begin
  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Pointer.Visible:= Visible;
end;

function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;
begin
  Result:= TLineSeries(TChart(App.FindComponent('Chart' + IntToStr(ChartNumber))).Series[LineSerieNumber - 1]);
end;

function GetConstLineSerie(ChartNumber, LineSerieNumber: Byte): TConstantLine;
begin
  Result:= TConstantLine(App.FindComponent('Chart' + IntToStr(ChartNumber) + 'VerticalLine' + IntToStr(LineSerieNumber)));
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

procedure SetAllLineSeriesColor();
var i, j  : Byte;
    Serie : TLineSeries;
begin
  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to MAX_SERIE_NUMBER do begin
       Serie:= GetLineSerie(i, j);
       SetLineSerieColor(Serie, GetColorBySerieName(Serie.Name));
    end;
end;

function GetMinMaxForCurrentExtent(Chart1LineSeries: TLineSeries): TMinMax;
var i, start, count : Longint;
    dr              : TDoubleRect;
    Max, Min        : Double;
    CurY            : Double;
begin
 if Chart1LineSeries.Count > 0 then begin
   dr:= Chart1LineSeries.ParentChart.CurrentExtent;
   Min:= 1.7E308;
   Max:= 2.0E-324;
   Chart1LineSeries.FindYRange(dr.a.X, dr.b.X, Min, Max);
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
  if App.ColorsSync.Checked then Chart:= 0
  else Chart:= GetChartNumber(LineSerieName) - 1;
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

function GetSerieSource(SerieTitle: String): Byte;
var n: LongInt;
begin
  if (SerieTitle <> '') And (TryStrToInt(LeftStr(SerieTitle, 2), n)) then
    Result:= n - 1
  else Result:= 255;
end;

procedure SerieReset(LineSerie: TLineSeries);
begin
  LineSerie.Clear;
  LineSerie.Title:= '';
  LineSerie.Legend.Visible:= False;
end;

procedure SeriesReset();
var i, j: Byte;
begin
  for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do SerieReset(GetLineSerie(i, j));
end;

end.

