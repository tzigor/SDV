unit LineSerieUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, UserTypes, TASeries, TAGraph, LCLType,
  TAChartAxis, TATypes, TALegend, TAChartUtils, StrUtils, ChartUtils, Forms,
  Controls, Dialogs, DateUtils;

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
function GetFreeVerticalLine(): String;
function GetFreeHorizontalLine(): String;
procedure CutSerie(Serie: TLineSeries);
procedure CropSerie(Serie: TLineSeries);
function AddHorLineSerie(AChart: TChart; AName: String; Pos: Double): TConstantLine;
procedure SerieStartDateLimit(Serie: TLineSeries);
procedure SerieEndDateLimit(Serie: TLineSeries);
function AddMagLine(AChart: TChart; Pos: Double): TConstantLine;
function GetMagLine(Chart: TChart): TConstantLine;
function GetLinesCount(): Byte;

implementation
uses Main;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
begin
  Result := TLineSeries.Create(AChart);
  with TLineSeries(Result) do
  begin
    Name:= AChart.Name + AName;
    AxisIndexY:= 1;
    Pointer.Style := App.GPointerStyleBox.PointerStyle;
    Pointer.VertSize:= App.GPointSizeBox.ItemIndex + 2;
    Pointer.HorizSize:= App.GPointSizeBox.ItemIndex + 2;
    LinePen.Width:= App.GLineWidthBox.PenWidth;
    LinePen.Style := App.GLineStyleBox.PenStyle;
    ShowLines := true;
    Legend.Visible:= False;
    Marks.Style:= smsLabel;
    Marks.LinkPen.Color:= clGray;
    Marks.LabelBrush.Color:= App.LabelColor.Selected;;
  end;
  AChart.AddSeries(Result);
end;

function AddConstLineSerie(AChart: TChart; AName: String; Pos: Double): TConstantLine;
begin
  Result := TConstantLine.Create(AChart);
  TConstantLine(Result).Name:= AName;
  TConstantLine(Result).Legend.Visible:= False;
  TConstantLine(Result).AxisIndex:= 1;
  TConstantLine(Result).LineStyle:= lsVertical;
  TConstantLine(Result).SeriesColor:= App.VertLineColor.Selected;
  TConstantLine(Result).Pen.Style:= App.VertLineStyle.PenStyle;
  TConstantLine(Result).Pen.Width:= App.VertLineWidth.PenWidth;
  TConstantLine(Result).Position:= Pos;
  TConstantLine(Result).ZPosition:= 0;
  AChart.AddSeries(Result);
end;

function AddHorLineSerie(AChart: TChart; AName: String; Pos: Double): TConstantLine;
var i: Byte;
begin
  Result := TConstantLine.Create(AChart);
  TConstantLine(Result).Name:= AName;
  TConstantLine(Result).Legend.Visible:= False;
  TConstantLine(Result).AxisIndex:= 1;
  TConstantLine(Result).LineStyle:= lsHorizontal;
  TConstantLine(Result).SeriesColor:= App.HorLineColor.Selected;
  TConstantLine(Result).Pen.Style:= App.HorLineStyle.PenStyle;
  TConstantLine(Result).Pen.Width:= App.HorLineWidth.PenWidth;
  TConstantLine(Result).Position:= Pos;
  if OnHintSerie <> Nil then begin
    for i:= 1 to MAX_SERIE_NUMBER do GetLineSerie(SelectedChart, i).ZPosition:= 0;
    TConstantLine(Result).ZPosition:= 1;
  end;
  AChart.AddSeries(Result);
end;

function AddMagLine(AChart: TChart; Pos: Double): TConstantLine;
begin
  Result := TConstantLine.Create(AChart);
  TConstantLine(Result).Name:= 'MagLine';
  TConstantLine(Result).Legend.Visible:= False;
  TConstantLine(Result).AxisIndex:= 1;
  TConstantLine(Result).LineStyle:= lsVertical;
  TConstantLine(Result).SeriesColor:= App.VertLineColor.Selected;
  TConstantLine(Result).Pen.Style:= App.VertLineStyle.PenStyle;
  TConstantLine(Result).Pen.Width:= App.VertLineWidth.PenWidth;
  TConstantLine(Result).Position:= Pos;
  TConstantLine(Result).ZPosition:= 100;
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

function GetHorLineSerie(ChartNumber, LineSerieNumber: Byte): TConstantLine;
begin
  Result:= TConstantLine(App.FindComponent('Chart' + IntToStr(ChartNumber) + 'HorizontalLine' + IntToStr(LineSerieNumber)));
end;

//function GetMagLine(ChartNumber: Byte): TConstantLine;
//begin
//  Result:= TConstantLine(App.FindComponent('Chart' + IntToStr(ChartNumber) + 'MagLine'));
//end;

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
var dr              : TDoubleRect;
    Max, Min        : Double;
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

function GetFreeVerticalLine(): String;
var i, j, n   : Byte;
    nStr      : String;
    LineExist : Boolean;
    Chart     : TChart;
begin
  for j:=1 to MAX_VERTLINE_NUMBER do begin
    if j < 10 then nStr:= '0'+ IntToStr(j)
    else nStr:= IntToStr(j);
    LineExist:= False;
    for i:=1 to MAX_CHART_NUMBER do begin
      Chart:= GetChart(i);
      for n:=MAX_SERIE_NUMBER + 1 to Chart.SeriesCount do
        if NPos('VerticalLine' + nStr, Chart.Series[n - 1].Name, 1) > 0 then begin
           LineExist:= True;
           Break;
        end;
    end;
    if Not LineExist then begin
       Result:= 'VerticalLine' + nStr;
       Exit;
    end;
  end;
  Result:= '';
end;

function GetMagLine(Chart: TChart): TConstantLine;
var n   : Byte;
begin
  Result:= Nil;
  for n:=MAX_SERIE_NUMBER + 1 to Chart.SeriesCount do
    if NPos('MagLine', Chart.Series[n - 1].Name, 1) > 0 then begin
       Result:= TConstantLine(Chart.Series[n - 1]);
       Break;
    end;
end;

function GetFreeHorizontalLine(): String;
var i, j, n   : Byte;
    nStr      : String;
    LineExist : Boolean;
    Chart     : TChart;
begin
  for j:=1 to MAX_VERTLINE_NUMBER do begin
    if j < 10 then nStr:= '0'+ IntToStr(j)
    else nStr:= IntToStr(j);
    LineExist:= False;
    for i:=1 to MAX_CHART_NUMBER do begin
      Chart:= GetChart(i);
      for n:=MAX_SERIE_NUMBER + 1 to Chart.SeriesCount do
        if NPos('HorizontalLine' + nStr, Chart.Series[n - 1].Name, 1) > 0 then begin
           LineExist:= True;
           Break;
        end;
    end;
    if Not LineExist then begin
       Result:= 'HorizontalLine' + nStr;
       Exit;
    end;
  end;
  Result:= '';
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

function GetLinesCount(): Byte;
var i, j, n: Byte;
begin
  n:= 0;
  for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do
        if GetLineSerie(i, j).Count > 0 then Inc(n);
  Result:= n;
end;

procedure CropSerie(Serie: TLineSeries);
var n, FirstIndex, LastIndex, nToDel : Integer;
begin
  if Serie.Count > 0 then begin
     FirstIndex:= Serie.ExtentPointIndexFirst;
     LastIndex:= Serie.ExtentPointIndexLast;
     nToDel:= Serie.Count - 1;
     if ((FirstIndex = nToDel) And (LastIndex = nToDel)) Or ((FirstIndex = 0) And (LastIndex = 0)) then Serie.Clear
     else begin
       if LastIndex < nToDel then for n:=nToDel downto LastIndex do Serie.Delete(n);
       if FirstIndex < nToDel then for n:=0 to FirstIndex do Serie.Delete(0);
     end;
  end;
end;

procedure CutSerie(Serie: TLineSeries);
var i : Integer;
begin
  if Serie.Count > 0 then begin
    i:= 0;
    repeat
       if (Serie.XValue[i] >= StartCutPoint.X) And (Serie.XValue[i] <= EndCutPoint.X) then begin
         Serie.Delete(i);
       end
       else Inc(i);
    until i = Serie.Count;
     if Serie.Count = 0 then Serie.Clear;
  end;
end;

procedure SerieStartDateLimit(Serie: TLineSeries);
var Stop : Boolean;
begin
  if Serie.Count > 0 then begin
     Stop:= False;
     repeat
       if DateOf(Serie.GetXValue(0)) < App.StartChartsFrom.Date then Serie.Delete(0)
       else Stop:= True;
     until (Serie.Count = 0) Or Stop;
  end;
end;

procedure SerieEndDateLimit(Serie: TLineSeries);
var Stop : Boolean;
begin
  if Serie.Count > 0 then begin
    Stop:= False;
    repeat
       if DateOf(Serie.GetXValue(Serie.Count - 1)) > App.EndPoint.Date then Serie.Delete(Serie.Count - 1)
       else Stop:= True;
    until (Serie.Count = 0) Or Stop;
  end;
end;

end.

