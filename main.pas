unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls, Menus,
  ColorBox, TAGraph, TAIntervalSources, TATools, TAChartExtentLink, TASeries,
  StrUtils, DateTimePicker, channelsform, ChartUtils, LineSerieUtils, Types,
  TADrawUtils, TAChartUtils, TADataTools, TAChartCombos, ParamOptions,
  DateUtils;

type

  { TApp }

  TApp = class(TForm)
    Chart1: TChart;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    Chart5: TChart;
    Chart6: TChart;
    Chart7: TChart;
    Chart8: TChart;
    GChartBGColor: TColorBox;
    ChartExtentLink1: TChartExtentLink;
    ChartScrollBox: TScrollBox;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1DataPointClickTool2: TDataPointClickTool;
    ChartToolset1DataPointClickTool3: TDataPointClickTool;
    ChartToolset1DataPointClickTool4: TDataPointClickTool;
    ColorsSync: TCheckBox;
    DateTimeLine: TChart;
    DateTimeLineLineSerie: TLineSeries;
    ExtHint: TCheckBox;
    DistanceTool: TDataPointDistanceTool;
    ChartToolset1DataPointHintTool1: TDataPointHintTool;
    ChartToolset1PanDragTool1: TPanDragTool;
    ChartToolset1UserDefinedTool1: TUserDefinedTool;
    ChartToolset1ZoomDragTool1: TZoomDragTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool2: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool3: TZoomMouseWheelTool;
    ChartPoints: TCheckBox;
    ChartLink: TCheckBox;
    DateTimeIntervalChartSource1: TDateTimeIntervalChartSource;
    FastLabel: TLabel;
    FastMode: TCheckBox;
    HideLabel: TImage;
    AddChart: TImage;
    DistanceXOff: TImage;
    DistanceXOn: TImage;
    DistanceYOff: TImage;
    DistanceYOn: TImage;
    FitY: TImage;
    FitX: TImage;
    FitXY: TImage;
    CloseCharts: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GLineStyleBox: TChartComboBox;
    GLineWidthBox: TChartComboBox;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    PanOff: TImage;
    PanOn: TImage;
    OptionsPage: TTabSheet;
    GPointerStyleBox: TChartComboBox;
    GPointSizeBox: TComboBox;
    RecordCount: TLabel;
    RecordsNumber: TTrackBar;
    SlowLabel: TLabel;
    ZoomOff: TImage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenFile: TImage;
    PopupMenu1: TPopupMenu;
    ShowLabel: TImage;
    ProcessLabel: TLabel;
    CloseApp: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    ChartPage: TTabSheet;
    ProcessProgress: TProgressBar;
    ZoomOn: TImage;
    procedure AddChartClick(Sender: TObject);
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ChartLinkChange(Sender: TObject);
    procedure ChartPointsChange(Sender: TObject);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool2AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool2PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool3PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool4PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1Hint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
    procedure ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure CloseAppClick(Sender: TObject);
    procedure CloseChartsClick(Sender: TObject);
    procedure ColorsSyncChange(Sender: TObject);
    procedure DistanceToolGetDistanceText(ASender: TDataPointDistanceTool;
      var AText: String);
    procedure DistanceXOffClick(Sender: TObject);
    procedure DistanceYOffClick(Sender: TObject);
    procedure FastModeChange(Sender: TObject);
    procedure FitXClick(Sender: TObject);
    procedure FitXYClick(Sender: TObject);
    procedure FitYClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GChartBGColorChange(Sender: TObject);
    procedure GLineStyleBoxChange(Sender: TObject);
    procedure GLineWidthBoxChange(Sender: TObject);
    procedure GPointerStyleBoxChange(Sender: TObject);
    procedure GPointSizeBoxChange(Sender: TObject);
    procedure HideLabelClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure PanOffClick(Sender: TObject);
    procedure RecordsNumberChange(Sender: TObject);
    procedure ShowLabelClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure ZoomOffClick(Sender: TObject);
  private

  public

  end;

  TDataSource = record
      SourceName       : String;
      TFFDataChannels  : TTFFDataChannels;
      FrameRecords     : TFrameRecords;
  end;

  TDataSources = array of TDataSource;

var
  App: TApp;

  wCurveStyle        : TCurveStyle; { temporary serie line & pointer style }

  ErrorCode          : Byte;
  CurrentOpenedFile  : String;
  Bytes              : TBytes;   { Raw data source }
  CurrentFileSize    : LongWord;
  CurrentTFFVersion  : Byte;
  EndOfFile          : Boolean;
  DataOffset         : LongWord;
  TffStructure       : TTffStructure;
  DataSources        : TDataSources; { Data source for charts }
  SourceCount        : Byte = 0;
  ChartsCount        : Byte = 0;
  CurrentChart       : Byte = 0;
  CurrentSource      : Byte = 0;
  CurrentSerie       : Byte = 1;
  ParametersUnits    : Array[1..MAX_CHART_NUMBER, 1..MAX_SERIE_NUMBER] of String;
  ShowIndicator      : Boolean;
  StartDateTime      : TDateTime = 0;
  EndDateTime        : TDateTime = 0;
  SelectedChart      : Byte = 0;
  DateTimeDrawed     : Boolean;
  ChartPointIndex    : LongInt;
  LabelSticked       : Boolean;
  MousePosition      : TPoint;
  isOnHint           : Boolean = False;
  OnHintSerie        : TLineSeries;
  OnHintXPoint       : Double;
  OnHintYPoint       : Double;
  NavigationMode     : Byte;
  SavedDateTimePoint : TDateTime;
  SavedOnHintSerie   : TLineSeries;
  FastModeDivider    : Byte = 1;

  procedure OpenChannelForm(SourceNumber: Byte);

implementation

{$R *.lfm}

{ TApp }

procedure TApp.FormCreate(Sender: TObject);
var i, j  : Byte;
    Chart : TChart;
begin
  DecimalSeparator:= '.';
  SetLength(DataSources, 0);
  ChartsVisible(False);
  ResetChartsZoom;

  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to 8 do begin
        AddLineSerie(GetChart(i), 'Serie' + IntToStr(j));
    end;

  for i:= 1 to MAX_CHART_NUMBER do begin
     Chart:= GetChart(i);
     Chart.BackColor:= GChartBGColor.Selected;
     Chart.Margins.Top:= 10;
     Chart.Margins.Bottom:= 10;
     Chart.Legend.Visible:= True;
     Chart.Legend.Frame.Color:= clSilver;
     Chart.Legend.UseSidebar:= False;
     Chart.AxisList[1].Marks.Visible:= False;
     Chart.Foot.Visible:= False;
  end;
  DateTimeIntervalChartSource1.DateTimeFormat:='hh:mm:ss'+#13#10+'DD.MM.YY';

  if ChartPoints.Checked then PointersVisible(True)
  else PointersVisible(False);

  if ChartLink.Checked then ChartExtentLink1.Enabled:= True
  else ChartExtentLink1.Enabled:= False;

  App.DateTimeLine.Visible:= False;

  DistanceTool.Options:= DistanceTool.Options + [dpdoRotateLabel, dpdoLabelAbove];

  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);

  SetFastMode(FastMode.Checked);
end;

procedure TApp.FormResize(Sender: TObject);
begin
  if ChartsCount > 1 then begin
     ChartsPosition;
  end;
end;

procedure TApp.GChartBGColorChange(Sender: TObject);
begin
  SetChartsBGColor;
end;

procedure TApp.GLineStyleBoxChange(Sender: TObject);
begin
  SetLineSeriesStyle();
end;

procedure TApp.GLineWidthBoxChange(Sender: TObject);
begin
  SetLineSeriesStyle();
end;

procedure TApp.GPointerStyleBoxChange(Sender: TObject);
begin
  SetLineSeriesStyle();
end;

procedure TApp.GPointSizeBoxChange(Sender: TObject);
begin
  SetLineSeriesStyle();
end;

procedure TApp.HideLabelClick(Sender: TObject);
var i, j: Byte;
begin
   HideLabel.Visible:= False;
   ShowLabel.Visible:= True;
   for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Marks.Style:= smsNone
end;

procedure TApp.ShowLabelClick(Sender: TObject);
var i, j: Byte;
begin
   ShowLabel.Visible:= False;
   HideLabel.Visible:= True;
   for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Marks.Style:= smsLabel
end;

procedure TApp.MenuItem1Click(Sender: TObject);
begin
  OnHintSerie.Clear;
  MenuItem4.Enabled:= False;
end;

procedure TApp.MenuItem2Click(Sender: TObject);
var
  Chart  : TChart;
  i      : Byte;
begin
  App.ChartScrollBox.Visible:= False;
  Chart:= GetChart(SelectedChart);
  for i:=1 to MAX_SERIE_NUMBER do SerieReset(GetLineSerie(SelectedChart, i));
  Chart.Visible:= False;
  Dec(ChartsCount);
  FindTimeRange;
  if ChartsCount > 0 then ChartsPosition()
  else begin
     DateTimeLineLineSerie.Clear;
     DateTimeLine.Visible:= False;
  end;
  MenuItem4.Enabled:= False;
  App.ChartScrollBox.Visible:= True;
end;

procedure TApp.MenuItem3Click(Sender: TObject);
begin
  SavedOnHintSerie:= OnHintSerie;
  SavedDateTimePoint:= OnHintXPoint;
  MenuItem4.Enabled:= True;
end;

procedure TApp.MenuItem4Click(Sender: TObject);
var wDT, i : LongInt;
    XVal   : Double;
begin
  if Not (SavedOnHintSerie = OnHintSerie) then begin
    wDT:= SecondsBetween(SavedDateTimePoint, OnHintXPoint);
    if CompareDateTime(SavedDateTimePoint, OnHintXPoint) < 0 then wDT:= -wDT;
    for i:=0 to OnHintSerie.Count - 1 do begin
       XVal:= OnHintSerie.GetXValue(i);
       XVal:= IncSecond(XVal, wDT);
       OnHintSerie.SetXValue(i, XVal);
    end;
    FindTimeRange;
  end;
end;

procedure TApp.PanOffClick(Sender: TObject);
begin
  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.RecordsNumberChange(Sender: TObject);
begin
  RecordCount.Caption:= 'Divide by ' + IntToStr(RecordsNumber.Position);
end;

procedure OpenChannelForm(SourceNumber: Byte);
var i : Byte;
begin
  ShowChannelForm.ChannelList.Clear;
  ShowChannelForm.FileList.Clear;
  for i:=1 to SourceCount do begin
    ShowChannelForm.FileList.Items.Add(ExtractFileName(DataSources[i - 1].SourceName));
  end;
  for i:=0 to Length(DataSources[SourceNumber - 1].TFFDataChannels) - 1 do begin
    ShowChannelForm.ChannelList.Items.Add(DataSources[SourceNumber - 1].TFFDataChannels[i].DLIS);
  end;
  ShowChannelForm.FileList.ItemIndex:= SourceNumber - 1;
  ShowChannelForm.Show;
end;

procedure Bin_DbToBin_Db();
var DataSource     : TDataSource;
begin
  if LoadSourceFile('bin_db', 100) then begin
     SetNavigation(NAVIGATION_OFF);
     DataSource.SourceName:= CurrentOpenedFile;
     DataSource.FrameRecords:= BinDbParser(3);
     DataSource.TFFDataChannels:= TffStructure.GetTFFDataChannels;
     if ErrorCode = NO_ERROR then begin
        Insert(DataSource, DataSources, DATA_MAX_SIZE);
        Inc(SourceCount);
        CurrentSource:= SourceCount - 1;
        OpenChannelForm(SourceCount);
     end
     else Application.MessageBox(GetErrorMessage(ErrorCode),'Error', MB_ICONERROR + MB_OK);
     Application.ProcessMessages;
     SetNavigation(NavigationMode);
  end;
end;

procedure TApp.OpenFileClick(Sender: TObject);
begin
  Bin_DbToBin_Db();
end;

procedure TApp.CloseAppClick(Sender: TObject);
begin
  App.Close;
end;

procedure TApp.CloseChartsClick(Sender: TObject);
var i, j: Byte;
begin
  ChartsVisible(False);
  for i:=1 to MAX_CHART_NUMBER do
    for j:=1 to MAX_SERIE_NUMBER do SerieReset(GetLineSerie(i, j));
  ChartsCount:= 0;
  DateTimeLineLineSerie.Clear;
  DateTimeLine.Visible:= False;
  MenuItem4.Enabled:= False;
end;

procedure TApp.ColorsSyncChange(Sender: TObject);
begin
  SetAllLineSeriesColor();
end;

procedure TApp.ChartLinkChange(Sender: TObject);
begin
  if ChartLink.Checked then ChartExtentLink1.Enabled:= True
  else ChartExtentLink1.Enabled:= False;
end;

procedure TApp.ChartPointsChange(Sender: TObject);
begin
  if ChartPoints.Checked then PointersVisible(True)
  else PointersVisible(False);
end;

procedure TApp.ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
  APoint: TPoint);
var y: Double;
    x: TDateTime;
begin
  with ATool as TDatapointClickTool do begin
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        ChartPointIndex:= PointIndex;
        LabelSticked:= True;
        x:= GetXValue(PointIndex);
        y:= GetYValue(PointIndex);
        ListSource.Item[PointIndex]^.Text:= GetSticker(TLineSeries(Series), x, y);
        ParentChart.Repaint;
      end;
  end;
end;

procedure TApp.ChartToolset1DataPointClickTool2PointClick(ATool: TChartTool;
  APoint: TPoint);
begin
  App.ChartToolset1DataPointClickTool1PointClick(ATool, APoint);
end;

procedure TApp.ChartToolset1DataPointClickTool3PointClick(ATool: TChartTool;
  APoint: TPoint);
begin
  with ATool as TDatapointClickTool do begin
    if (Series is TLineSeries) then
      with TLineSeries(Series) do Delete(PointIndex);
  end;
  App.FitYClick(ATool);
end;

procedure TApp.ChartToolset1DataPointClickTool4PointClick(ATool: TChartTool;
  APoint: TPoint);
begin
  wCurveStyle.LineColor:= OnHintSerie.SeriesColor;
  wCurveStyle.LineStyle:= OnHintSerie.LinePen.Style;
  wCurveStyle.LineWidth:= OnHintSerie.LinePen.Width;
  wCurveStyle.PointStyle:= OnHintSerie.Pointer.Style;
  wCurveStyle.PointBrushColor:= OnHintSerie.Pointer.Brush.Color;
  wCurveStyle.PointPenColor:= OnHintSerie.Pointer.Pen.Color;
  wCurveStyle.PointSize:= OnHintSerie.Pointer.HorizSize;
  wCurveStyle.Parameter:= OnHintSerie.Title;

  ParamOptionsForm.ParameterName.Caption:= wCurveStyle.Parameter;
  if wCurveStyle.PointBrushColor = GChartBGColor.Selected then ParamOptionsForm.TransparentPointer.Checked:= True
  else ParamOptionsForm.TransparentPointer.Checked:= False;

  ParamOptionsForm.LineColorBox.Selected:= wCurveStyle.LineColor;
  ParamOptionsForm.LineStyleBox.PenStyle:= wCurveStyle.LineStyle;
  ParamOptionsForm.LineWidthBox.PenWidth:= wCurveStyle.LineWidth;

  ParamOptionsForm.PointSizeBox.ItemIndex:= wCurveStyle.PointSize - 2;
  ParamOptionsForm.PointerColorBox.Selected:= wCurveStyle.PointPenColor;
  ParamOptionsForm.PointerStyleBox.PenColor:= wCurveStyle.PointPenColor;
  ParamOptionsForm.PointerStyleBox.PointerStyle:= wCurveStyle.PointStyle;

  ChartToolset1DataPointHintTool1.Enabled:= False;
  ParamOptionsForm.Show;
end;

procedure TApp.ChartToolset1DataPointHintTool1AfterMouseMove(ATool: TChartTool;
  APoint: TPoint);
begin
  if isOnHint then
     if (Abs(MousePosition.X - Mouse.CursorPos.X) > 5) Or (Abs(MousePosition.Y - Mouse.CursorPos.Y) > 5) then begin
        SetNavigation(NavigationMode);
        isOnHint:= False;
     end;
end;

procedure TApp.ChartToolset1DataPointClickTool2AfterMouseUp(ATool: TChartTool;
  APoint: TPoint);
var i, j  : Byte;
    Chart : TChart;
begin
 if LabelSticked then begin
   for i:=1 to MAX_CHART_NUMBER do begin
     Chart:= GetChart(i);
     if Chart.Visible then
        for j:=1 to MAX_SERIE_NUMBER do
          StickLabel(GetLineSerie(i, j));
   end;
   LabelSticked:= False;
  end;
end;

procedure TApp.ChartToolset1DataPointHintTool1Hint(ATool: TDataPointHintTool;
  const APoint: TPoint; var AHint: String);
begin
   OnHintXPoint:= TLineSeries(ATool.Series).GetXValue(ATool.PointIndex);
   OnHintYPoint:= TLineSeries(ATool.Series).GetYValue(ATool.PointIndex);
   AHint:= GetSticker(TLineSeries(ATool.Series), OnHintXPoint, OnHintYPoint);
   MousePosition:= Mouse.CursorPos;
   isOnHint:= True;
   OnHintSerie:= TLineSeries(ATool.Series);
   SetNavigation(NAVIGATION_OFF);
   App.ChartToolset1DataPointHintTool1.Enabled:= True;
   App.ChartToolset1DataPointClickTool4.Enabled:= True;
end;

procedure TApp.ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
  APoint: TPoint);
begin
  SelectedChart:= GetChartNumber(ATool.Chart.Name);
  PopupMenu1.PopUp;
end;

procedure TApp.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = ShowChannelForm.ChannelList then Accept:=True;
end;

procedure TApp.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
var Chart       : TChart;
    Serie       : Byte;
    ChartNumber : Byte;
begin
  Chart:= TChart(Sender);
  ChartNumber:= GetChartNumber(Chart.Name);
  if (Sender is TChart) and (Source is TListBox) then
     with Source as TListBox do begin
       Serie:= GetFreeLineSerie(ChartNumber);
       if Serie > 0 then begin
          DrawSerie(GetLineSerie(ChartNumber, Serie),
                    CurrentSource,
                    ShowChannelForm.ChannelList.ItemIndex,
                    ShowChannelForm.ChannelList.Items[ShowChannelForm.ChannelList.ItemIndex]);
       end;
     end;
end;

procedure TApp.AddChartClick(Sender: TObject);
begin
  if SourceCount > 0 then OpenChannelForm(SourceCount)
  else Bin_DbToBin_Db();
end;

procedure TApp.ZoomOffClick(Sender: TObject);
begin
  NavigationMode:= ZOOM_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.DistanceXOffClick(Sender: TObject);
begin
  NavigationMode:= DISTANCE_MODE_X;
  SetNavigation(NavigationMode);
end;

procedure TApp.DistanceYOffClick(Sender: TObject);
begin
  NavigationMode:= DISTANCE_MODE_Y;
  SetNavigation(NavigationMode);
end;

procedure TApp.FastModeChange(Sender: TObject);
begin
  SetFastMode(FastMode.Checked);
end;

procedure TApp.FitXClick(Sender: TObject);
var i: Byte;
begin
  App.DateTimeLine.ZoomFull();
end;

procedure TApp.FitYClick(Sender: TObject);
var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do ZoomChartCurrentExtent(GetChart(i));
end;

procedure TApp.FitXYClick(Sender: TObject);
begin
  FitXClick(Sender);
  Application.ProcessMessages;
  FitYClick(Sender);
  Application.ProcessMessages;
end;

procedure TApp.DistanceToolGetDistanceText(ASender: TDataPointDistanceTool;
  var AText: String);
var Days     : Word;
    DTime    : Double;
    AfterDot : Byte;
begin
  if NavigationMode = DISTANCE_MODE_X then begin
     DTime:= ASender.Distance(cuAxis);
     Days:= DaysBetween(0, DTime);
     AText:= 'Distance: Days-' + IntToStr(Days) + #13#10 + 'Time-' + TimeToStr(TimeOf(DTime));
  end
  else begin
     DTime:= ASender.Distance(cuAxis);
     if DTime > 10000 then AfterDot:= 0
     else AfterDot:= 3;
     AText:= FloatToStrF(DTime, ffFixed, 12, AfterDot);
  end;
end;


end.

