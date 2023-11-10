unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls, Menus,
  TAGraph, TAIntervalSources, TATools, TAChartExtentLink, TASeries, StrUtils,
  DateTimePicker, channelsform, ChartUtils, LineSerieUtils, Types, TADrawUtils,
  TAChartUtils, TADataTools, ParamOptions, DateUtils;

type

  { TApp }

  TApp = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    Chart5: TChart;
    Chart6: TChart;
    Chart7: TChart;
    Chart8: TChart;
    ChartExtentLink1: TChartExtentLink;
    ChartScrollBox: TScrollBox;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1DataPointClickTool2: TDataPointClickTool;
    ChartToolset1DataPointClickTool3: TDataPointClickTool;
    ChartToolset1DataPointClickTool4: TDataPointClickTool;
    DistanceOff: TImage;
    DistanceOn: TImage;
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
    DateTimeLine: TChart;
    DateTimeLineLineSerie: TLineSeries;
    EndTime: TLabel;
    HideLabel: TImage;
    AddChart: TImage;
    Panel1: TPanel;
    PanOff: TImage;
    PanOn: TImage;
    ZoomOff: TImage;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenFile: TImage;
    Image3: TImage;
    PopupMenu1: TPopupMenu;
    ShowLabel: TImage;
    StartTime: TLabel;
    ZoomExtent: TImage;
    Indicator: TLabel;
    ProcessLabel: TLabel;
    CloseApp: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    ChartPage: TTabSheet;
    ProcessProgress: TProgressBar;
    ZoomOn: TImage;
    procedure AddChartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
    procedure ChartToolset1DataPointDistanceTool1Measure(
      ASender: TDataPointDistanceTool);
    procedure ChartToolset1DataPointHintTool1AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1Hint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
    procedure ChartToolset1DataPointHintTool1HintLocation(
      ATool: TDataPointHintTool; AHintSize: TSize; var APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1HintPosition(
      ATool: TDataPointHintTool; var APoint: TPoint);
    procedure ChartToolset1DataPointHintTool2AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure CloseAppClick(Sender: TObject);
    procedure CursorModeClick(Sender: TObject);
    procedure DistanceOffClick(Sender: TObject);
    procedure DistanceToolGetDistanceText(ASender: TDataPointDistanceTool;
      var AText: String);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HideLabelClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure PanOffClick(Sender: TObject);
    procedure ShowLabelClick(Sender: TObject);
    procedure ZoomExtentClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure ZoomModeClick(Sender: TObject);
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

   { Data souce current parameters }
  ErrorCode          : Byte;
  CurrentOpenedFile  : String;
  Bytes              : TBytes;   { Raw data source }
  CurrentFileSize    : LongWord;
  EndOfFile          : Boolean;
  DataOffset         : LongWord;
  TffStructure       : TTffStructure;
  DataSources        : TDataSources; { Data source for charts }
  SourceCount        : Byte = 0;
  ChartsCount        : Byte = 0;
  CurrentChart       : Byte = 0;
  CurrentSource      : Byte = 0;
  CurrentSerie       : Byte = 1;
  ShowIndicator      : Boolean;
  StartDateTime      : TDateTime = 0;
  EndDateTime        : TDateTime = 0;
  SelectedChart      : Byte = 0;
  DateTimeDrawed     : Boolean;
  ChartPointIndex    : LongInt;
  LabelSticked       : Boolean;
  MousePosition      : TPoint;
  isOnHint           : Boolean = False;
  NavigationMode     : Byte;

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
     Chart.Margins.Top:= 4;
     Chart.Margins.Bottom:= 4;
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

  App.StartTime.Caption:= '';
  App.EndTime.Caption:= '';

  DistanceTool.Options:= DistanceTool.Options + [dpdoRotateLabel, dpdoLabelAbove];

  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.FormResize(Sender: TObject);
begin
  if ChartsCount > 1 then ChartsPosition;
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
  OpenChannelForm(SourceCount);
end;

procedure TApp.MenuItem2Click(Sender: TObject);
var
  Chart  : TChart;
  i      : Byte;
begin
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
end;

procedure TApp.PanOffClick(Sender: TObject);
begin
  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.ZoomExtentClick(Sender: TObject);
var i, j: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do ZoomChartCurrentExtent(GetChart(i));
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

procedure TApp.Image3Click(Sender: TObject);
begin
  App.DateTimeLine.ZoomFull();
end;

procedure TApp.ZoomModeClick(Sender: TObject);
begin

end;


procedure TApp.CloseAppClick(Sender: TObject);
begin
  App.Close;
end;

procedure TApp.CursorModeClick(Sender: TObject);
begin

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
        ListSource.Item[PointIndex]^.Text:= GetSticker(x, y, Title);
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
  App.ZoomExtentClick(ATool);
end;

procedure TApp.ChartToolset1DataPointClickTool4PointClick(ATool: TChartTool;
  APoint: TPoint);
begin
  ParamOptionsForm.Show;
end;

procedure TApp.ChartToolset1DataPointDistanceTool1Measure(
  ASender: TDataPointDistanceTool);
begin

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
  var y     : Double;
      x     : TDateTime;
begin
   x:= TLineSeries(ATool.Series).GetXValue(ATool.PointIndex);
   y:= TLineSeries(ATool.Series).GetYValue(ATool.PointIndex);
   AHint:= GetSticker(x, y, TLineSeries(ATool.Series).Title);
   MousePosition:= Mouse.CursorPos;
   isOnHint:= True;
   SetNavigation(NAVIGATION_OFF);
   App.ChartToolset1DataPointHintTool1.Enabled:= True;
   App.ChartToolset1DataPointClickTool4.Enabled:= True;
end;

procedure TApp.ChartToolset1DataPointHintTool1HintLocation(
  ATool: TDataPointHintTool; AHintSize: TSize; var APoint: TPoint);
begin

end;

procedure TApp.ChartToolset1DataPointHintTool1HintPosition(
  ATool: TDataPointHintTool; var APoint: TPoint);
begin

end;

procedure TApp.ChartToolset1DataPointHintTool2AfterMouseDown(ATool: TChartTool;
  APoint: TPoint);
begin

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
          //App.DateTimeLine.Visible:= True;
          //while Not DateTimeDrawed do Application.ProcessMessages;
          //App.DateTimeLine.ZoomFull();
       end;
     end;
end;

procedure TApp.AddChartClick(Sender: TObject);
begin
  if SourceCount > 0 then OpenChannelForm(SourceCount)
  else Bin_DbToBin_Db();
end;

procedure TApp.Button1Click(Sender: TObject);
var   f: double;
begin
   f:= sqrt((sqr(123.9) + sqr(126.3) + sqr(124.4) + sqr(126.3) + sqr(124.8) + sqr(124))/6);
   ShowMessage(FloatToStr(f));
end;

procedure TApp.ZoomOffClick(Sender: TObject);
begin
  NavigationMode:= ZOOM_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.DistanceOffClick(Sender: TObject);
begin
  NavigationMode:= DISTANCE_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.DistanceToolGetDistanceText(ASender: TDataPointDistanceTool;
  var AText: String);
var Days, Hrs, Mins, Secs : Word;
    DTime                 : Double;
begin
  DTime:= ASender.Distance(cuAxis);
  Days:= DaysBetween(0, DTime);
  AText:= 'Distance: Days-' + IntToStr(Days) + #13#10 + 'Time-' + TimeToStr(TimeOf(DTime));
end;

procedure TApp.FormClick(Sender: TObject);
begin

end;

end.

