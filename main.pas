unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls, TAGraph,
  TAIntervalSources, TATools, channelsform, ChartUtils, LineSerieUtils;

type

  { TApp }

  TApp = class(TForm)
    AddChartBtn: TBitBtn;
    Chart1: TChart;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    Chart5: TChart;
    Chart6: TChart;
    Chart7: TChart;
    Chart8: TChart;
    ChartToolset1: TChartToolset;
    ChartToolset1PanDragTool1: TPanDragTool;
    ChartToolset1ZoomDragTool1: TZoomDragTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool2: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool3: TZoomMouseWheelTool;
    CursorMode: TSpeedButton;
    DateTimeIntervalChartSource1: TDateTimeIntervalChartSource;
    FitToWin: TImage;
    HideLabel: TImage;
    Image3: TImage;
    Image4: TImage;
    Indicator: TLabel;
    ProcessLabel: TLabel;
    LoadFile: TBitBtn;
    CloseApp: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    ChartPage: TTabSheet;
    ProcessProgress: TProgressBar;
    ChartScrollBox: TScrollBox;
    ZoomMode: TSpeedButton;
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CloseAppClick(Sender: TObject);
    procedure CursorModeClick(Sender: TObject);
    procedure DateTimeIntervalChartSource1DateTimeStepChange(Sender: TObject;
      ASteps: TDateTimeStep);
    procedure FormCreate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure LoadFileClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ZoomModeClick(Sender: TObject);
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
  CurrentOpenedFile  : String;
  Bytes              : TBytes;   { Raw data source }
  CurrentFileSize    : LongWord;
  EndOfFile          : Boolean;
  DataOffset         : LongWord;
  TffStructure       : TTffStructure;
  DataSources        : TDataSources; { Data source for charts }
  SourceCount        : Byte;
  ChartCount         : Byte;
  CurrentChart       : Byte;
  CurrentSource      : Byte;
  CurrentSerie       : Byte;
  ShowIndicator      : Boolean;

implementation

{$R *.lfm}

{ TApp }

procedure TApp.FormCreate(Sender: TObject);
var i, j : Byte;
begin
  DecimalSeparator:= '.';
  SourceCount:= 0;
  ChartCount:= 1;
  CurrentSource:= 0;
  CurrentChart:= 1;
  CurrentSerie:= 1;
  SetLength(DataSources, 0);
  ChartsVisible(False);
  //ChartsEnabled(False);
  ResetChartsZoom;

  for i:= 1 to 8 do
      for j:= 1 to 8 do begin
          AddLineSerie(TChart(App.FindComponent('Chart' + IntToStr(i))), 'Serie' + IntToStr(j));
      end;

  for i:= 1 to 8 do begin
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.Visible:= True;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.Frame.Color:= clSilver;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.UseSidebar:= False;
     TChart(App.FindComponent('Chart' + IntToStr(i))).AxisList[1].Marks.Visible:= false;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Foot.Visible:= false;
  end;

  DateTimeIntervalChartSource1.DateTimeFormat:='hh:mm:ss'+#13#10+'DD.MM.YY';
end;

procedure Bin_DbToBin_Db();
var i          : Byte;
    DataSource : TDataSource;
begin
  if LoadSourceFile('bin_db', 100) then begin
     DataSource.SourceName:= CurrentOpenedFile;
     DataSource.FrameRecords:= BinDbParser(3);
     DataSource.TFFDataChannels:= TffStructure.GetTFFDataChannels;
     if ErrorCode = NO_ERROR then begin
        Insert(DataSource, DataSources, DATA_MAX_SIZE);
        ShowChannelForm.ChannelList.Clear;
        for i:=0 to Length(DataSources[SourceCount].TFFDataChannels) - 1 do begin
          ShowChannelForm.ChannelList.Items.Add(DataSources[SourceCount].TFFDataChannels[i].DLIS);
        end;
        ShowChannelForm.FileList.Items.Add(ExtractFileName(CurrentOpenedFile));
        ShowChannelForm.FileList.ItemIndex:= 0;
        ShowChannelForm.Show;
        Inc(SourceCount);
     end
     else Application.MessageBox(GetErrorMessage(ErrorCode),'Error', MB_ICONERROR + MB_OK);
  end;
end;

procedure TApp.Image3Click(Sender: TObject);
begin
  Chart1.ZoomFull();
end;

procedure TApp.LoadFileClick(Sender: TObject);
begin
  Bin_DbToBin_Db();
end;

procedure TApp.PageControl1Change(Sender: TObject);
begin

end;

procedure TApp.ZoomModeClick(Sender: TObject);
begin
  CursorMode.Flat:= True;
  ZoomMode.Flat:= False;
  ChartToolset1ZoomDragTool1.Enabled:= True;
  ChartToolset1PanDragTool1.Enabled:= False;
end;

procedure TApp.CloseAppClick(Sender: TObject);
begin
  App.Close;
end;

procedure TApp.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = ShowChannelForm.ChannelList then Accept:=True;
end;

procedure TApp.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  with Source as TListBox do
    ShowMessage(Items[ItemIndex]);
  //ShowMessage(ShowChannelForm.ChannelList.Items[ItemIndex]);
end;

procedure TApp.CursorModeClick(Sender: TObject);
begin
  CursorMode.Flat:= False;
  ZoomMode.Flat:= True;
  ChartToolset1ZoomDragTool1.Enabled:= False;
  ChartToolset1PanDragTool1.Enabled:= True;
end;

procedure TApp.DateTimeIntervalChartSource1DateTimeStepChange(Sender: TObject;
  ASteps: TDateTimeStep);
begin

end;


end.

