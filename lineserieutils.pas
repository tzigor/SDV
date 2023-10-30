unit LineSerieUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, UserTypes, TASeries, TAGraph, LCLType,
  TAChartAxis, TATypes, TALegend, TAChartUtils, StrUtils;

function AddLineSerie(AChart: TChart; AName: String): TLineSeries;
procedure SetLineSerieColor(LineSerie: TLineSeries; AColor: TColor);
function GetColorIndex(n: Byte): Byte;
function GetColorBySerieName(LineSerieName: String): TColor;
function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;

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
    ShowLines := true;
    LinePen.Style := psSolid;
    Legend.Visible:= False;
    Marks.Style:= smsLabel;
    Marks.LinkPen.Color:= clGray;
  end;
  AChart.AddSeries(Result);
end;

function GetLineSerie(ChartNumber, LineSerieNumber: Byte): TLineSeries;
begin
   Result:= TLineSeries(TChart(App.FindComponent('Chart' + IntToStr(ChartNumber))).Series[LineSerieNumber - 1]);
end;

procedure SetLineSerieColor(LineSerie: TLineSeries; AColor: TColor);
begin
  LineSerie.SeriesColor := AColor;
  LineSerie.Pointer.Brush.Color := AColor;
  LineSerie.Pointer.Pen.Color := AColor;
end;


function GetColorIndex(n: Byte): Byte;
begin
  Result:= n - (n Div 8) * 8;
end;

function GetColorBySerieName(LineSerieName: String): TColor;
var Serie, Chart: Byte;
begin
  Chart:= StrToInt(MidStr(LineSerieName, 6, 1)) - 1;
  Serie:= StrToInt(MidStr(LineSerieName, 12, 1)) - 1;
  Result:= ChartColors[GetColorIndex(Serie + Chart)];
end;

end.

