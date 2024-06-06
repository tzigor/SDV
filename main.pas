unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls, Menus,
  ColorBox, TAGraph, TAIntervalSources, TATools, TAChartExtentLink, TASeries,
  StrUtils, DateTimePicker, channelsform, ChartUtils, LineSerieUtils, Types,
  TADrawUtils, TAChartUtils, TADataTools, TAChartCombos, TANavigation,
  ParamOptions, DateUtils, JSONParser, JSONScanner, fpJSON, FileUtil, Math,
  LCLIntf, Clipbrd, Calendar, EditBtn, TAChartAxisUtils, TALegend,
  TALegendPanel, TATransformations, TAStyles, CheckBoxThemed, ExtendedNotebook,
  laz.VirtualTrees, LimitsForm, HorLineOptions, LCLTranslator;

type

  { TApp }

  TApp = class(TForm)
    CutBtn: TButton;
    AllocateArea: TDataPointDistanceTool;
    CutZoneOff: TImage;
    CutZoneOn: TImage;
    ChartUp: TMenuItem;
    ChartDown: TMenuItem;
    DateTimeFormat: TEdit;
    GroupBox5: TGroupBox;
    MoveToTop: TMenuItem;
    catUser: TChartAxisTransformations;

    catUserUserDefinedAxisTransform1: TUserDefinedAxisTransform;
    ChartToolset1DataPointDragTool1: TDataPointDragTool;
    ChartToolset2: TChartToolset;
    ChartToolset2ZoomMouseWheelTool1: TZoomMouseWheelTool;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    LinkToolCurves: TCheckBox;
    CropBtn: TButton;
    Chart1: TChart;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    Chart5: TChart;
    Chart6: TChart;
    Chart7: TChart;
    Chart8: TChart;
    ColorsSync: TCheckBox;
    GChartBGColor: TColorBox;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DeleteVertLine: TMenuItem;
    DelAllVertLines: TMenuItem;
    CropChartMenuItem: TMenuItem;
    AddHorizontalLine: TMenuItem;
    DelHorizontalLine: TMenuItem;
    DelAllHorLines: TMenuItem;
    LimitsItem: TMenuItem;
    RemoveLabelsBtn: TImage;
    ShowMagnifier: TMenuItem;
    ShowBackInTime: TCheckBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Splitter7: TSplitter;
    Splitter8: TSplitter;
    TimeHead: TLabel;
    VertLineColor: TColorBox;
    GLineStyleBox: TChartComboBox;
    HorLineColor: TColorBox;
    LabelColor: TColorBox;
    VertLineStyle: TChartComboBox;
    GLineWidthBox: TChartComboBox;
    HorLineStyle: TChartComboBox;
    VertLineWidth: TChartComboBox;
    GPointerStyleBox: TChartComboBox;
    GPointSizeBox: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    KeepDistance: TCheckBox;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem6: TMenuItem;
    AddVerticalLine: TMenuItem;
    StartChartsFrom: TDateTimePicker;
    ChartExtentLink1: TChartExtentLink;
    ChartScrollBox: TScrollBox;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1DataPointClickTool2: TDataPointClickTool;
    ChartToolset1DataPointClickTool3: TDataPointClickTool;
    ChartToolset1DataPointClickTool4: TDataPointClickTool;
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
    Label1: TLabel;
    MenuItem5: TMenuItem;
    ScreenShotFlash: TImage;
    ScreenShot: TImage;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    PanOff: TImage;
    PanOn: TImage;
    OptionsPage: TTabSheet;
    RTCBugs: TCheckBox;
    EndPoint: TDateTimePicker;
    Timer: TTimer;
    HorLineWidth: TChartComboBox;
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
    procedure AddHorizontalLineClick(Sender: TObject);
    procedure AddVerticalLineClick(Sender: TObject);
    procedure AllocateAreaAfterMouseUp(ATool: TChartTool; APoint: TPoint);
    procedure AllocateAreaMeasure(ASender: TDataPointDistanceTool);
    procedure catUserUserDefinedAxisTransform1AxisToGraph(AX: Double; out
      AT: Double);
    procedure Chart1AxisList0GetMarkText(Sender: TObject; var AText: String;
      AMark: Double);
    procedure Chart1BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect; var ADoDefaultDrawing: Boolean);
    procedure Chart1Click(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ChartDownClick(Sender: TObject);
    procedure ChartLinkChange(Sender: TObject);
    procedure ChartPointsChange(Sender: TObject);
    procedure ChartStyles1AddStyleToLegend(AStyle: TChartStyle;
      ASeries: TObject; var AddToLegend: Boolean);
    procedure ChartToolset1DataPointClickTool1AfterKeyDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool2AfterKeyDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool2PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool3AfterKeyDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool3PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool4AfterKeyDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointClickTool4PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1AfterKeyDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1DataPointHintTool1Hint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
    procedure ChartToolset1PanDragTool1AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1PanDragTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartToolset1ZoomMouseWheelTool3AfterMouseMove(ATool: TChartTool;
      APoint: TPoint);
    procedure ChartUpClick(Sender: TObject);
    procedure CloseAppClick(Sender: TObject);
    procedure CloseChartsClick(Sender: TObject);
    procedure ColorsSyncChange(Sender: TObject);
    procedure CropBtnClick(Sender: TObject);
    procedure CropChartMenuItemClick(Sender: TObject);
    procedure CutBtnClick(Sender: TObject);
    procedure CutZoneOffClick(Sender: TObject);
    procedure DateTimeLineExtentChanged(ASender: TChart);
    procedure DelAllHorLinesClick(Sender: TObject);
    procedure DelAllVertLinesClick(Sender: TObject);
    procedure DeleteVertLineClick(Sender: TObject);
    procedure DelHorizontalLineClick(Sender: TObject);
    procedure DistanceToolGetDistanceText(ASender: TDataPointDistanceTool;
      var AText: String);
    procedure DistanceXOffClick(Sender: TObject);
    procedure DistanceYOffClick(Sender: TObject);
    procedure DistanceYOnClick(Sender: TObject);
    procedure EndPointChange(Sender: TObject);
    procedure FitXClick(Sender: TObject);
    procedure FitXYClick(Sender: TObject);
    procedure FitYClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GChartBGColorChange(Sender: TObject);
    procedure GLineStyleBoxChange(Sender: TObject);
    procedure GLineWidthBoxChange(Sender: TObject);
    procedure GPointerStyleBoxChange(Sender: TObject);
    procedure GPointSizeBoxChange(Sender: TObject);
    procedure HideLabelClick(Sender: TObject);
    procedure KeepDistanceChange(Sender: TObject);
    procedure LimitsItemClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MoveToTopClick(Sender: TObject);
    procedure PanOffClick(Sender: TObject);
    procedure RemoveLabelsBtnClick(Sender: TObject);
    procedure ScreenShotClick(Sender: TObject);
    procedure ScreenShotFlashClick(Sender: TObject);
    procedure ShowLabelClick(Sender: TObject);
    procedure OpenFileClick(Sender: TObject);
    procedure ShowMagnifierClick(Sender: TObject);
    procedure StartChartsFromChange(Sender: TObject);
    procedure TimerStopTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ZoomOffClick(Sender: TObject);
  private

  public

  end;

var
  App: TApp;

  CommandPromptProcessed : Boolean = False;

  wCurveStyle        : TCurveStyle; { temporary serie line & pointer style }

  ErrorCode          : Byte;
  CurrentOpenedFile  : String;
  Bytes              : TBytes;   { Raw data source }
  DataOffset         : LongWord;
  CurrentFileSize    : LongWord;
  CurrentTFFVersion  : Byte;
  EndOfFile          : Boolean;
  TffStructure       : TTffStructure;
  DataSources        : TDataSources; { Data source for charts }
  SourceCount        : Byte = 0;
  ChartsCount        : Byte = 0;
  VertLineCount      : Byte = 0;
  HorLineCount       : Byte = 0;
  CurrentChart       : Byte = 0;
  CurrentSource      : Byte = 0;
  CurrentSerie       : Byte = 1;
  ParametersUnits    : Array[1..MAX_CHART_NUMBER, 1..MAX_SERIE_NUMBER] of String;
  StartDateTime      : TDateTime = 0;
  EndDateTime        : TDateTime = 0;
  SelectedChart      : Byte = 0;  { Number of chart left button clicked on }
  ChartPointIndex    : LongInt;
  LabelSticked       : Boolean;
  MousePosition      : TPoint;
  MouseOnLeftMarks   : Boolean;
  NewFileOpened      : Boolean = False;
  ChartsCurrentExtent: TDoubleRect;

  DrawCutAreaBG      : Boolean = False;
  StartCutPoint,
  EndCutPoint        : TDoublePoint;
  StartCutArea,
  EndCutArea         : TPoint;

  ParamSet           : TParamSet;
  ParamSetFile       : File of TParamSet;

  { Variables are initialized if OnHint event occur  }
  OnHintLineType     : Byte;
  isOnHint           : Boolean = False;
  OnHintSerie        : TLineSeries;
  OnHintHorLine      : TConstantLine;
  OnHintSerieIndex   : Integer;
  OnHintPointIndex   : LongWord;
  OnHintXPoint       : Double;
  OnHintYPoint       : Double;
  SavedPointValue    : Double;
  SavedOnHintSerie   : TLineSeries;
  NewSerieDrawed     : Boolean = False;
  SIBRParamListActive: Boolean = False;

  { SIB-R special variables }
  IsSIBR             : Boolean;
  ResParamPosition   : Integer;

  NavigationMode     : Byte;
  SavedDateTimePoint : TDateTime;  { Date/Time point for time synchronization }
  FastModeDivider    : Byte = 1;

  ConfiguredTools    : TStringList;

  procedure OpenChannelForm();
  procedure PrepareChannelForm();
  procedure FillChannelList();

implementation

{$R *.lfm}

{ TApp }

procedure TApp.FormCreate(Sender: TObject);
var i, j     : Byte;
    Chart    : TChart;
    Splitter : TSplitter;
begin
  DecimalSeparator:= '.';
  SetDefaultLang('en');
  GetLocaleFormatSettings($409, DefaultFormatSettings);
  App.ChartScrollBox.Left:= 0;
  SetLength(DataSources, 0);
  ChartsVisible(False);
  ResetChartsZoom;

  for i:= 1 to MAX_CHART_NUMBER do
    for j:= 1 to 8 do begin
        AddLineSerie(GetChart(i), 'Serie' + IntToStr(j));
    end;

  for i:= 1 to MAX_CHART_NUMBER do begin
     Chart:= GetChart(i);
     Chart.Frame.Color:= RGBToColor(100, 100, 100);
     Chart.BackColor:= GChartBGColor.Selected;
     Chart.Margins.Top:= 10;
     Chart.Margins.Bottom:= 10;
     Chart.Margins.Left:= 10;
     Chart.Margins.Right:= 10;
     Chart.MarginsExternal.Bottom:= 1;
     Chart.MarginsExternal.Top:= 0;
     Chart.BorderSpacing.Top:= 4;
     Chart.Legend.Visible:= True;
     Chart.Legend.Frame.Color:= clSilver;
     Chart.Legend.UseSidebar:= False;
     Chart.AxisList[1].Marks.Visible:= False;
     Chart.Foot.Visible:= False;
     Splitter:= GetSplitter(i);
     Splitter.ResizeStyle:= rsLine;
     Splitter.Height:= 4;
     //Splitter.Visible:= False;
  end;
  DateTimeIntervalChartSource1.DateTimeFormat:='hh:mm:ss'+#13#10+'DD.MM.YY';

  for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Marks.Style:= smsLabel;

  if ChartPoints.Checked then PointersVisible(True)
  else PointersVisible(False);

  if ChartLink.Checked then ChartExtentLink1.Enabled:= True
  else ChartExtentLink1.Enabled:= False;

  App.DateTimeLine.Visible:= False;

  DistanceTool.Options:= DistanceTool.Options + [dpdoRotateLabel, dpdoLabelAbove];

  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);

  EndPoint.DateTime:= IncDay(Now, 1);

  if KeepDistance.Checked then DistanceTool.Options:= [dpdoPermanent]
  else DistanceTool.Options:= [];

  AllowDropFiles:= True;
end;

procedure TApp.FormActivate(Sender: TObject);
begin
  if paramcount=1 then begin
    CurrentOpenedFile:= paramstr(1);
    if ExtractFileExt(CurrentOpenedFile) = '.bin_db' then
       if LoadSourceByteArray(paramstr(1), 100) And Not CommandPromptProcessed then begin
         LoadFile(BIN_DB_TYPE);
       end;
    if (ExtractFileExt(CurrentOpenedFile) = '.csv') And Not CommandPromptProcessed then LoadFile(CSV_TYPE);
  end;
  CommandPromptProcessed:= True
end;

procedure TApp.FormDropFiles(Sender: TObject; const FileNames: array of string);
var  n: Integer;
begin
  for n := Low(FileNames) to High(FileNames) do
  begin
    CurrentOpenedFile:= FileNames[n];
    if ExtractFileExt(FileNames[n]) = '.bin_db' then
       if LoadSourceByteArray(FileNames[n], 100) then LoadFile(BIN_DB_TYPE);
    if ExtractFileExt(FileNames[n]) = '.csv' then LoadFile(CSV_TYPE);
  end;
end;

procedure TApp.FormResize(Sender: TObject);
begin
  if ChartsCount > 0 then begin
     ChartsPosition;
  end;
end;

procedure TApp.FormShow(Sender: TObject);
begin
  if ShowChannelForm.DockedToMain.Checked then begin
    ShowChannelForm.Show;
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
     for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Marks.Style:= smsLabel
end;

procedure TApp.KeepDistanceChange(Sender: TObject);
begin
  if KeepDistance.Checked then DistanceTool.Options:= [dpdoPermanent]
  else DistanceTool.Options:= []
end;

procedure TApp.LimitsItemClick(Sender: TObject);
begin
  LimitForm.Parameter.Caption:= OnHintSerie.Title;
  LimitForm.Minimum.Value:= OnHintSerie.GetYMin;
  LimitForm.Maximum.Value:= OnHintSerie.GetYMax;
  LimitForm.Show;
end;

procedure TApp.ShowLabelClick(Sender: TObject);
var i, j: Byte;
begin
   ShowLabel.Visible:= False;
   HideLabel.Visible:= True;
   for i:= 1 to MAX_CHART_NUMBER do
     for j:= 1 to MAX_SERIE_NUMBER do GetLineSerie(i, j).Marks.Style:= smsNone
end;

procedure TApp.MenuItem1Click(Sender: TObject);
begin
  if OnHintSerie <> Nil then begin
    OnHintSerie.Legend.Visible:= False;
    OnHintSerie.Clear;
  end;
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
  DeleteChart(Chart);
  //ChartsPosition();
  MenuItem4.Enabled:= False;
  App.ChartScrollBox.Visible:= True;
  if ChartsCount = 0 then OpenChannelForm();
end;

procedure TApp.MenuItem3Click(Sender: TObject);
begin
  SavedOnHintSerie:= OnHintSerie;
  SavedDateTimePoint:= OnHintXPoint;
  SavedPointValue:= OnHintYPoint;
  Clipboard.AsText:= FloatToStr(SavedPointValue);
  MenuItem4.Enabled:= True;
end;

procedure TApp.MenuItem4Click(Sender: TObject);
var wDT, n : LongInt;
    XVal   : Double;
    i, j   : Byte;
    Source : Byte;
    Serie  : TLineSeries;
begin
  if Not (SavedOnHintSerie = OnHintSerie) then begin
    wDT:= SecondsBetween(SavedDateTimePoint, OnHintXPoint);
    if CompareDateTime(SavedDateTimePoint, OnHintXPoint) < 0 then wDT:= -wDT;

    if LinkToolCurves.Checked then begin
        Source:= GetSerieSource(OnHintSerie.Title);
        for i:= 1 to MAX_CHART_NUMBER do
         for j:= 1 to MAX_SERIE_NUMBER do begin
            Serie:= GetLineSerie(i, j);
            if GetSerieSource(Serie.Title) = Source then
              for n:=0 to Serie.Count - 1 do begin
                XVal:= Serie.GetXValue(n);
                XVal:= IncSecond(XVal, wDT);
                Serie.SetXValue(n, XVal);
              end;
         end;
     end
     else
       for n:=0 to OnHintSerie.Count - 1 do begin
          XVal:= OnHintSerie.GetXValue(n);
          XVal:= IncSecond(XVal, wDT);
          OnHintSerie.SetXValue(n, XVal);
       end;

    FindTimeRange;
  end;
end;

procedure TApp.MenuItem5Click(Sender: TObject);
begin
  MakeChartScreenShot(GetChart(SelectedChart));
end;

procedure TApp.MenuItem6Click(Sender: TObject);
begin
  OnHintSerie.Delete(OnHintPointIndex);
  App.FitYClick(Sender);
end;

procedure TApp.MoveToTopClick(Sender: TObject);
var i: Byte;
begin
  if OnHintSerie <> Nil then begin
    for i:= 1 to MAX_SERIE_NUMBER do GetLineSerie(SelectedChart, i).ZPosition:= 0;
    OnHintSerie.ZPosition:= 1;
    //GetChart(SelectedChart).Repaint;
  end;
  MoveToTop.Enabled:= False;
end;

procedure TApp.PanOffClick(Sender: TObject);
begin
  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.RemoveLabelsBtnClick(Sender: TObject);
begin
  RemoveAllLabels();
end;

procedure TApp.ScreenShotClick(Sender: TObject);
begin
  ScreenShotFlash.Visible:= True;
  Application.ProcessMessages;
  MakeScreenShot();
  ScreenShotFlash.Visible:= False;
end;

procedure TApp.ScreenShotFlashClick(Sender: TObject);
begin

end;

procedure FillChannelList();
var i : Integer;
begin
  ShowChannelForm.ChannelList.Clear;
  IsSIBR:= False;
  for i:=0 to Length(DataSources[CurrentSource].TFFDataChannels) - 1 do begin
    ShowChannelForm.ChannelList.Items.Add(DataSources[CurrentSource].TFFDataChannels[i].DLIS);
    if DataSources[CurrentSource].TFFDataChannels[i].DLIS = 'VR1C0F1r' then begin
      IsSIBR:= True;
      ResParamPosition:= i;
    end;
  end;
  if IsSIBR then begin
     ShowChannelForm.ChannelList.Width:= ShowChannelForm.Width Div 2;
     ShowChannelForm.SIBRParamList.Visible:= True;
     ShowChannelForm.SIBRParamLbl.Visible:= True;
     ShowChannelForm.Splitter1.Visible:= True;
  end
  else begin
     ShowChannelForm.ChannelList.Width:= ShowChannelForm.Width - 16;
     ShowChannelForm.SIBRParamList.Visible:= False;
     ShowChannelForm.SIBRParamLbl.Visible:= False;
     ShowChannelForm.Splitter1.Visible:= False;
  end;
end;

procedure PrepareChannelForm();
var i : Integer;
begin
  ShowChannelForm.FileList.Clear;
  CurrentSource:= SourceCount - 1;
  for i:=1 to SourceCount do begin
    ShowChannelForm.FileList.Items.Add(IntToStr(i) + '.' + ExtractFileName(DataSources[i - 1].SourceName));
  end;
  FillChannelList();
  ShowChannelForm.FileList.ItemIndex:= CurrentSource;
  //ShowChannelForm.ChannelList.ItemIndex:=0;
end;

procedure OpenChannelForm();
begin
  PrepareChannelForm();
  ShowChannelForm.Show;
end;

procedure Bin_DbToBin_Db();
begin

  App.OpenDialog.Filter:= 'bin files|*.bin_db;*.csv|all files|*.*|';
  App.OpenDialog.DefaultExt:= '.bin_db|.csv';
  if App.OpenDialog.Execute then begin
    CurrentOpenedFile:= App.OpenDialog.FileName;
    if ExtractFileExt(CurrentOpenedFile) = '.bin_db' then
       if LoadSourceByteArray(CurrentOpenedFile, 100) then LoadFile(BIN_DB_TYPE);
    if ExtractFileExt(CurrentOpenedFile) = '.csv' then LoadFile(CSV_TYPE);
  end;

  //if LoadSourceFile('bin_db', 100) then begin
  //   LoadFile(BIN_DB_TYPE);
  //end;
end;

procedure TApp.OpenFileClick(Sender: TObject);
begin
  Bin_DbToBin_Db();
end;

procedure TApp.ShowMagnifierClick(Sender: TObject);
var dr    : TDoubleRect;
    Chart : TChart;
    Delta : Double;
begin
  Chart:= GetChart(SelectedChart);
  dr:= Chart.CurrentExtent;
  Delta:= dr.b.x - dr.a.x;
  AddMagLine(Chart, dr.a.x + Delta / 2 );
  //T := TChartAxisTransformations.Create(self);
  //Chart.AxisList[1].Transformations := T;
  //transf := TAutoscaleAxisTransform.Create(T);
  //transf.Transformations := T;
  //Chart.AxisList[1].Transformations:= catUser;
  catUserUserDefinedAxisTransform1.Enabled:= True;
end;

procedure TApp.StartChartsFromChange(Sender: TObject);
var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do ChartStartDateLimit(GetChart(i));
  RemoveEmptyCharts();
  FindTimeRange();
  SetNavigation(NavigationMode);
end;

procedure TApp.TimerStopTimer(Sender: TObject);
begin
  if GetLinesCount = 1 then App.FitXYClick(Sender)
  else begin
    App.FitYClick(Sender);
    SetHorizontalExtent(App.DateTimeLine);
  end;
  //if App.ChartLink.Checked then App.ChartExtentLink1.Enabled:= True;
end;

procedure TApp.TimerTimer(Sender: TObject);
begin
  App.Timer.Enabled:= False;
end;

procedure TApp.CloseAppClick(Sender: TObject);
begin
  App.Close;
  FreeAndNil(App);
end;

procedure TApp.CloseChartsClick(Sender: TObject);
var i, j: Byte;
begin
  ChartsVisible(False);
  App.DateTimeLine.ZoomFull();
  for i:=1 to MAX_CHART_NUMBER do begin
    for j:=1 to MAX_SERIE_NUMBER do SerieReset(GetLineSerie(i, j));
    DeleteVertLines(GetChart(i));
  end;
  VertLineCount:= 0;
  ChartsCount:= 0;
  DateTimeLineLineSerie.Clear;
  DateTimeLine.Visible:= False;
  MenuItem4.Enabled:= False;
  OpenChannelForm();
end;

procedure TApp.ColorsSyncChange(Sender: TObject);
begin
  SetAllLineSeriesColor();
end;

procedure TApp.CropBtnClick(Sender: TObject);
var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do CropChart(GetChart(i));
  RemoveEmptyCharts();
  FindTimeRange();
  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.CropChartMenuItemClick(Sender: TObject);
begin
  CropChart(GetChart(SelectedChart));
  FindTimeRange();
end;

procedure TApp.CutBtnClick(Sender: TObject);
var i: Byte;
begin
  DrawCutAreaBG:= False;
  for i:=1 to MAX_CHART_NUMBER do CutChart(GetChart(i));
  RemoveEmptyCharts();
  FindTimeRange();
  NavigationMode:= PAN_MODE;
  SetNavigation(NavigationMode);
  RepaintAll();
end;

procedure TApp.CutZoneOffClick(Sender: TObject);
begin
  NavigationMode:= ALLOCATE_AREA_MODE;
  SetNavigation(NavigationMode);
end;

procedure TApp.DateTimeLineExtentChanged(ASender: TChart);
begin
  //if NewSerieDrawed then App.DateTimeLine.ZoomFull();
  //NewSerieDrawed:= False;
end;

procedure TApp.DelAllHorLinesClick(Sender: TObject);
begin
  DeleteHorLines(GetChart(SelectedChart));
end;

procedure TApp.DelAllVertLinesClick(Sender: TObject);
var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do DeleteVertLines(GetChart(i));
  VertLineCount:= 0;
end;

procedure TApp.DeleteVertLineClick(Sender: TObject);
var i, n : Byte;
begin
  if OnHintSerie <> Nil then begin
    n:= StrToInt(RightStr(OnHintSerie.Name, 2));
    for i:=1 to MAX_CHART_NUMBER do
      DeleteVerticalLine(GetChart(i), n);
    DeleteVertLine.Enabled:= False;
  end;
end;

procedure TApp.DelHorizontalLineClick(Sender: TObject);
var n : Byte;
begin
  if OnHintSerie <> Nil then begin
      n:= StrToInt(RightStr(OnHintSerie.Name, 2));
      DeleteHorizontalLine(GetChart(SelectedChart), n);
      DelHorizontalLine.Enabled:= False;
   end;
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

procedure TApp.ChartStyles1AddStyleToLegend(AStyle: TChartStyle;
  ASeries: TObject; var AddToLegend: Boolean);
begin

end;

procedure TApp.ChartToolset1DataPointClickTool1AfterKeyDown(ATool: TChartTool;
  APoint: TPoint);
begin

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

procedure TApp.ChartToolset1DataPointClickTool2AfterKeyDown(ATool: TChartTool;
  APoint: TPoint);
begin

end;

procedure TApp.ChartToolset1DataPointClickTool2PointClick(ATool: TChartTool;
  APoint: TPoint);
var i, j  : Byte;
    Serie : TLineSeries;
    Chart : TChart;
    n     : Integer;
    Found : Boolean;
begin
 if isOnHint then begin
   for i:=1 to MAX_CHART_NUMBER do begin
     Chart:= GetChart(i);
     if Chart.Visible then begin
        for j:=1 to MAX_SERIE_NUMBER do begin
          Serie:= GetLineSerie(i, j);
          if Serie.Count > 0 then begin
             n:= 0;
             Found:= False;
             repeat
               if Serie.GetXValue(n) = OnHintXPoint then Found:= True;
               Inc(n);
             until (n - 1 >= Serie.Count - 1) Or Found;
             if Found then begin
               Serie.ListSource.Item[n]^.Text:= GetSticker(Serie, OnHintXPoint, Serie.GetYValue(n));
             end;
             LabelSticked:= True;
          end;
        end;
     end;
   end;
   isOnHint:= False;
  end;
end;

procedure TApp.ChartToolset1DataPointClickTool3AfterKeyDown(ATool: TChartTool;
  APoint: TPoint);
begin

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

procedure TApp.ChartToolset1DataPointClickTool4AfterKeyDown(ATool: TChartTool;
  APoint: TPoint);
begin

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

procedure TApp.ChartToolset1DataPointHintTool1AfterKeyDown(ATool: TChartTool;
  APoint: TPoint);
begin

end;

procedure TApp.ChartToolset1DataPointHintTool1AfterMouseMove(ATool: TChartTool;
  APoint: TPoint);
var wM : TPoint;
begin
  wM:= Mouse.CursorPos;
  if isOnHint then
     if (Abs(Abs(MousePosition.X) - Abs(wM.X)) > 5) Or
        (Abs(Abs(MousePosition.Y) - Abs(wM.Y)) > 5) then begin
        SetNavigation(NavigationMode);
        isOnHint:= False;
        OnHintSerie:= Nil;
        OnHintLineType:= 0;
        MenuItem1.Enabled:= False;
        MenuItem6.Enabled:= False;
        AddVerticalLine.Enabled:= False;
        AddHorizontalLine.Enabled:= False;
        DeleteVertLine.Enabled:= False;
        DelHorizontalLine.Enabled:= False;
        LimitsItem.Enabled:= False;
     end;
     if LabelSticked then RepaintAll();
end;

procedure TApp.ChartToolset1DataPointHintTool1Hint(ATool: TDataPointHintTool;
  const APoint: TPoint; var AHint: String);
var wStr: String;
begin
   if (NPos('VerticalLine', ATool.Series.Name, 1) = 0) And
      (NPos('HorizontalLine', ATool.Series.Name, 1) = 0) And
      (NPos('MagLine', ATool.Series.Name, 1) = 0) then
   begin
     OnHintLineType:= ChartSerieLine;
     wStr:= TLineSeries(ATool.Series).Title;
     Delete(wStr, 1, 3);
     OnHintPointIndex:= ATool.PointIndex;
     OnHintXPoint:= TLineSeries(ATool.Series).GetXValue(ATool.PointIndex);
     OnHintYPoint:= TLineSeries(ATool.Series).GetYValue(ATool.PointIndex);
     if (wStr = 'STATUS.SIBR.HI') Or (wStr = 'SIBR.HI')  Or (wStr = 'STATUS.HI') then AHint:= SWHint(Round(OnHintYPoint), SWHi, OnHintXPoint)
     else if (wStr = 'STATUS.SIBR.LO') Or (wStr = 'SIBR.LO') Or (wStr = 'STATUS.LO') then AHint:= SWHint(Round(OnHintYPoint), SWLo, OnHintXPoint)
          else if (wStr = 'ESTATUS.SIBR.LO') Or (wStr = 'E.SIBR.LO') Or (wStr = 'ESTATUS.LO') then AHint:= SWHint(Round(OnHintYPoint), ESWLo, OnHintXPoint)
               else AHint:= GetSticker(TLineSeries(ATool.Series), OnHintXPoint, OnHintYPoint);
     MenuItem1.Enabled:= True;
     MenuItem6.Enabled:= True;
     AddVerticalLine.Enabled:= True;
     AddHorizontalLine.Enabled:= True;
     LimitsItem.Enabled:= True;
     MoveToTop.Enabled:= True;
     SetNavigation(NAVIGATION_OFF);
     ATool.Enabled:= True;
     ChartToolset1DataPointClickTool4.Enabled:= True;
   end
   else if NPos('HorizontalLine', ATool.Series.Name, 1) > 0 then begin
          OnHintHorLine:= TConstantLine(ATool.Series);
          OnHintLineType:= HorizontalLine;
          ATool.Chart.Cursor:= crVSplit;
          DelHorizontalLine.Enabled:= True;
          SetNavigation(NAVIGATION_OFF);
          ATool.Enabled:= True;
          ChartToolset1DataPointClickTool4.Enabled:= False;
        end
        else if NPos('MagLine', ATool.Series.Name, 1) > 0 then begin
                OnHintLineType:= MagLine;
                ATool.Chart.Cursor:= crHSplit;
                SetNavigation(NAVIGATION_OFF);
                ATool.Enabled:= True;
                ChartToolset1DataPointClickTool4.Enabled:= False;
             end;
   MousePosition:= Mouse.CursorPos;
   isOnHint:= True;
   OnHintSerie:= TLineSeries(ATool.Series);
   OnHintSerieIndex:= OnHintSerie.Index;
end;

procedure TApp.ChartToolset1PanDragTool1AfterMouseDown(ATool: TChartTool;
  APoint: TPoint);
begin
  DateTimeLine.DisableRedrawing;
end;

procedure TApp.ChartToolset1PanDragTool1AfterMouseUp(ATool: TChartTool;
  APoint: TPoint);
begin
  DateTimeLine.EnableRedrawing;
  DateTimeLine.Repaint;
end;

procedure TApp.ChartToolset1UserDefinedTool1AfterMouseDown(ATool: TChartTool;
  APoint: TPoint);
begin
  SelectedChart:= GetChartNumber(ATool.Chart.Name);
  PopupMenu1.PopUp;
end;

procedure TApp.ChartToolset1ZoomMouseWheelTool3AfterMouseMove(
  ATool: TChartTool; APoint: TPoint);
var MousePosOnChar : Integer;
begin
  MousePosOnChar:= Mouse.CursorPos.X - App.Left - 14;
  if (MousePosOnChar >= 0) And (MousePosOnChar < 54) then begin
    MouseOnLeftMarks:= True;
    ChartToolset1ZoomMouseWheelTool3.ZoomFactor:= 1;
    ChartToolset1ZoomMouseWheelTool3.ZoomRatio:= 1.1;
  end
  else begin
    MouseOnLeftMarks:= False;
    ChartToolset1ZoomMouseWheelTool3.ZoomFactor:= 1.1;
    ChartToolset1ZoomMouseWheelTool3.ZoomRatio:=1;
  end;
end;

procedure TApp.ChartUpClick(Sender: TObject);
var ChartFrom, ChartTo           : TChart;
    SplitterFrom, SplitterTo     : TSplitter;
    tmpName1, tmpName2           : String;
    tmpSplitName1, tmpSplitName2 : String;
    tmpSplitTop1, tmpSplitTop2   : Integer;
begin
  if SelectedChart > 1 then begin
    ChartFrom:= GetChart(SelectedChart);
    ChartTo:= GetChart(SelectedChart - 1);

    SplitterFrom:= GetSplitter(SelectedChart);
    SplitterTo:= GetSplitter(SelectedChart - 1);

    tmpName1:= ChartFrom.Name;
    tmpName2:= ChartTo.Name;

    tmpSplitName1:= SplitterFrom.Name;
    tmpSplitName2:= SplitterTo.Name;
    tmpSplitTop1:= SplitterFrom.Top;
    tmpSplitTop2:= SplitterTo.Top;

    ChartTo.Name:= 'TempName1';
    ChartFrom.Name:= 'TempName2';
    SplitterTo.Name:= 'SplitTempName1';
    SplitterFrom.Name:= 'SplitTempName2';

    ChartTo.Name:= tmpName1;
    ChartFrom.Name:= tmpName2;

    SplitterTo.Name:= tmpSplitName1;
    SplitterFrom.Name:= tmpSplitName2;
    SplitterTo.Top:= tmpSplitTop1;
    SplitterFrom.Top:= tmpSplitTop2;

    ChartsPosition();
  end;
end;

procedure TApp.ChartDownClick(Sender: TObject);
var ChartFrom, ChartTo           : TChart;
    SplitterFrom, SplitterTo     : TSplitter;
    tmpName1, tmpName2           : String;
    tmpSplitName1, tmpSplitName2 : String;
    tmpSplitTop1, tmpSplitTop2   : Integer;
begin
  if SelectedChart < ChartsCount then begin
    ChartFrom:= GetChart(SelectedChart);
    ChartTo:= GetChart(SelectedChart + 1);

    SplitterFrom:= GetSplitter(SelectedChart);
    SplitterTo:= GetSplitter(SelectedChart + 1);

    tmpName1:= ChartFrom.Name;
    tmpName2:= ChartTo.Name;

    tmpSplitName1:= SplitterFrom.Name;
    tmpSplitName2:= SplitterTo.Name;
    tmpSplitTop1:= SplitterFrom.Top;
    tmpSplitTop2:= SplitterTo.Top;

    ChartTo.Name:= 'TempName1';
    ChartFrom.Name:= 'TempName2';
    SplitterTo.Name:= 'SplitTempName1';
    SplitterFrom.Name:= 'SplitTempName2';

    ChartTo.Name:= tmpName1;
    ChartFrom.Name:= tmpName2;

    SplitterTo.Name:= tmpSplitName1;
    SplitterFrom.Name:= tmpSplitName2;
    SplitterTo.Top:= tmpSplitTop1;
    SplitterFrom.Top:= tmpSplitTop2;

    ChartsPosition();
  end;
end;

procedure TApp.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = ShowChannelForm.ChannelList then Accept:= True;
  if Source = ShowChannelForm.SIBRParamList then Accept:= True;
end;

procedure TApp.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
var Chart             : TChart;
    Serie             : Byte;
    ChartNumber       : Byte;
    SelectedParamName : String;
begin
  Chart:= TChart(Sender);
  ChartNumber:= GetChartNumber(Chart.Name);
  if (Sender is TChart) and (Source is TListBox) then
     with Source as TListBox do begin
       Serie:= GetFreeLineSerie(ChartNumber);
       if Serie > 0 then begin

         if Not SIBRParamListActive then begin
            SelectedParamName:= ShowChannelForm.ChannelList.Items[ShowChannelForm.ChannelList.ItemIndex];
            ParametersUnits[CurrentChart, CurrentSerie]:= DataSources[CurrentSource].TFFDataChannels[ShowChannelForm.ChannelList.ItemIndex].Units;
         end;
         if SIBRParamListActive then SelectedParamName:= ShowChannelForm.SIBRParamList.Items[ShowChannelForm.SIBRParamList.ItemIndex];

         DrawSerie(GetLineSerie(ChartNumber, Serie),
                   CurrentSource,
                   ShowChannelForm.ChannelList.ItemIndex,
                   SelectedParamName);

         App.FitYClick(Sender);
       end;
     end;
  ShowChannelForm.ChannelList.ClearSelection;
  ShowChannelForm.SIBRParamList.ClearSelection;
end;

procedure TApp.AddChartClick(Sender: TObject);
begin
  if SourceCount > 0 then OpenChannelForm()
  else Bin_DbToBin_Db();
end;

procedure TApp.AddHorizontalLineClick(Sender: TObject);
begin
  Inc(HorLineCount);
  AddHorLineSerie(GetChart(SelectedChart), GetFreeHorizontalLine(), OnHintYPoint)
end;

procedure TApp.AddVerticalLineClick(Sender: TObject);
var i    : Byte;
    nStr : String;
begin
  Inc(VertLineCount);
  nStr:= GetFreeVerticalLine();
  for i:=1 to MAX_CHART_NUMBER do begin
    if GetChart(i).Visible then AddConstLineSerie(GetChart(i), nStr, OnHintXPoint)
  end;
end;

procedure TApp.AllocateAreaAfterMouseUp(ATool: TChartTool; APoint: TPoint);
begin
  RepaintAll();
end;

procedure TApp.AllocateAreaMeasure(ASender: TDataPointDistanceTool);
begin
  StartCutPoint:= ASender.PointStart.AxisPos();
  EndCutPoint:= ASender.PointEnd.AxisPos();
  DrawCutAreaBG:= True;
end;

procedure TApp.catUserUserDefinedAxisTransform1AxisToGraph(AX: Double; out
  AT: Double);
const
  R1 = 1000.0;
  C = 5;
  R2 = R1 / C;
var
  zx: Double;
begin
  zx := GetMagLine(GetChart(SelectedChart)).Position;
  if Abs(AX - zx) > R1 then
  AT := AX
  else if AX < zx - R2 then
  AT := zx - R1
  else if AX > zx + R2 then
  AT := zx + R1
  else AT := (AX - zx + R2) * C + zx - R1;
end;


//procedure TApp.Button1Click(Sender: TObject);
//var
//  JsonParser: TJSONParser;
//  JsonObject, JsonNestedObj: TJSONObject;
//  JsonEnum: TBaseJSONEnumerator;
//  cJsonStr: TFileStream;
//  i: integer;
//begin
//  cJsonStr:= TFileStream.Create('ChannelsConfig.json',fmOpenRead or fmShareDenyWrite);
//  JsonParser := TJSONParser.Create(cJsonStr, []);
//  try
//    JsonObject := JsonParser.Parse as TJSONObject;
//    JsonObject:=JsonObject.FindPath('SIB-R.channels.statusWords') as TJSONObject;
//    try
//      JsonEnum := JsonObject.GetEnumerator;
//      try
//        while JsonEnum.MoveNext do
//          Memo1.Lines.Add(JsonEnum.Current.Key);
//            if JsonObject.Types[JsonEnum.Current.Key] = jtArray then
//                 for i:=0 to Pred(TJSONArray(JsonEnum.Current.Value).Count) do
//                   Memo1.Lines.Add(TJSONArray(JsonEnum.Current.Value).Items[i].AsString);
//      finally
//        FreeAndNil(JsonEnum)
//      end;
//    finally
//      FreeAndNil(JsonObject);
//    end;
//  finally
//    FreeAndNil(JsonParser);
//  end;
//end;

procedure TApp.Chart1AxisList0GetMarkText(Sender: TObject; var AText: String;
  AMark: Double);
var AfterDot: Byte;
begin
   if Abs(AMark) > 1000000 then AText:= FloatToStrF(AMark, ffExponent, 0, 0)
   else begin
     if Abs(AMark) < 1 then AfterDot:= 5
     else if Abs(AMark) < 100 then AfterDot:= 3
          else if Abs(AMark) < 1000 then AfterDot:= 2
               else if Abs(AMark) < 10000 then AfterDot:= 1
                    else AfterDot:= 0;

     AText:= FloatToStrF(AMark, ffFixed, 12, AfterDot);
   end;
   if AMark = 0 then AText:= '0';
end;

procedure TApp.Chart1BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect; var ADoDefaultDrawing: Boolean);
var Rect: TRect;
begin
  if DrawCutAreaBG then begin
    Rect:= ARect;
    StartCutArea:= ASender.GraphToImage(StartCutPoint);
    EndCutArea:= ASender.GraphToImage(EndCutPoint);
    Rect.Left:= StartCutArea.X;
    Rect.Right:= EndCutArea.X;
    ACanvas.Brush.Color:= RGBToColor(255, 210, 210);
    ACanvas.FillRect(Rect);
    ADoDefaultDrawing:= false;
  end
  else ADoDefaultDrawing:= True;
end;

procedure TApp.Chart1Click(Sender: TObject);
begin
  if DrawCutAreaBG then begin
    DrawCutAreaBG:= False;
    RepaintAll();
  end;
end;

procedure TApp.Chart1DblClick(Sender: TObject);
begin
    if OnHintLineType = HorizontalLine then begin
    wCurveStyle.LineColor:= OnHintHorLine.SeriesColor;
    wCurveStyle.LineStyle:= OnHintHorLine.Pen.Style;
    wCurveStyle.LineWidth:= OnHintHorLine.Pen.Width;

    HorLineForm.SerieColorBox.Selected:= wCurveStyle.LineColor;
    HorLineForm.LineStyleBox.PenStyle:= wCurveStyle.LineStyle;
    HorLineForm.LineWidthBox.PenWidth:= wCurveStyle.LineWidth;

    ChartToolset1DataPointHintTool1.Enabled:= False;
    HorLineForm.Show;
  end;
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

procedure TApp.DistanceYOnClick(Sender: TObject);
begin

end;

procedure TApp.EndPointChange(Sender: TObject);
  var i: Byte;
begin
  for i:=1 to MAX_CHART_NUMBER do ChartEndDateLimit(GetChart(i));
  RemoveEmptyCharts();
  FindTimeRange();
  SetNavigation(NavigationMode);
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

procedure TApp.FormChangeBounds(Sender: TObject);
begin
  if ShowChannelForm.Showing And ShowChannelForm.DockedToMain.Checked then begin
    ShowChannelForm.Left:= App.Left + 2;
    ShowChannelForm.Top:= App.Top + 89;
    ShowChannelForm.Height:= App.ChartScrollBox.Height - 32;
  end;
end;

procedure TApp.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeAndNil(App);
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
var Days, y, mon, d, h, m, s, ms : Word;
    DTime          : Double;
    AfterDot       : Byte;
begin
  if NavigationMode = DISTANCE_MODE_X then begin
     DTime:= ASender.Distance(cuAxis);
     Days:= DaysBetween(0, DTime);
     DecodeDateTime(DTime, y, mon, d, h, m, s, ms);
     AText:= IntToStr(Days) + ' days' + #13#10 + IntToStr(h) + 'h, ' + IntToStr(m) + 'm, ' + IntToStr(s) + 's';
  end
  else begin
     DTime:= ASender.Distance(cuAxis);
     if DTime > 10000 then AfterDot:= 0
     else AfterDot:= 3;
     AText:= FloatToStrF(DTime, ffFixed, 12, AfterDot);
  end;
end;


end.

