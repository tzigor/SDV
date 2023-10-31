unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls, TAGraph,
  TAIntervalSources, TATools, TAChartExtentLink, channelsform, ChartUtils,
  LineSerieUtils;

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
    ChartExtentLink1: TChartExtentLink;
    ChartToolset1: TChartToolset;
    ChartToolset1PanDragTool1: TPanDragTool;
    ChartToolset1ZoomDragTool1: TZoomDragTool;
    ChartToolset1ZoomMouseWheelTool1: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool2: TZoomMouseWheelTool;
    ChartToolset1ZoomMouseWheelTool3: TZoomMouseWheelTool;
    ChartPoints: TCheckBox;
    ChartLink: TCheckBox;
    CursorMode: TSpeedButton;
    DateTimeIntervalChartSource1: TDateTimeIntervalChartSource;
    FitToWin: TImage;
    HideLabel: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Indicator: TLabel;
    ProcessLabel: TLabel;
    CloseApp: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    ChartPage: TTabSheet;
    ProcessProgress: TProgressBar;
    ChartScrollBox: TScrollBox;
    ZoomMode: TSpeedButton;
    procedure AddChartBtnClick(Sender: TObject);
    procedure Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ChartLinkChange(Sender: TObject);
    procedure ChartPointsChange(Sender: TObject);
    procedure CloseAppClick(Sender: TObject);
    procedure CursorModeClick(Sender: TObject);
    procedure DateTimeIntervalChartSource1DateTimeStepChange(Sender: TObject;
      ASteps: TDateTimeStep);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
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
  ChartsCount        : Byte;
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
  CurrentSource:= 0;
  ChartsCount:= 0;
  CurrentChart:= 1;
  CurrentSerie:= 1;
  SetLength(DataSources, 0);
  ChartsVisible(False);
  ResetChartsZoom;

  for i:= 1 to 8 do
    for j:= 1 to 8 do begin
        AddLineSerie(TChart(App.FindComponent('Chart' + IntToStr(i))), 'Serie' + IntToStr(j));
    end;

  for i:= 1 to 8 do begin
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.Visible:= True;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.Frame.Color:= clSilver;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Legend.UseSidebar:= False;
     TChart(App.FindComponent('Chart' + IntToStr(i))).AxisList[1].Marks.Visible:= False;
     TChart(App.FindComponent('Chart' + IntToStr(i))).Foot.Visible:= False;

     //TChart(App.FindComponent('Chart' + IntToStr(i))).Title.Visible:= true;
  end;

  DateTimeIntervalChartSource1.DateTimeFormat:='hh:mm:ss'+#13#10+'DD.MM.YY';

  if ChartPoints.Checked then PointersVisible(True)
  else PointersVisible(False);

  if ChartLink.Checked then ChartExtentLink1.Enabled:= True
  else ChartExtentLink1.Enabled:= False;
end;

procedure TApp.FormResize(Sender: TObject);
begin
  if ChartsCount > 1 then ChartsPosition;
end;

procedure OpenChannelForm(SourceNumber: Byte);
var i, j: Byte;
begin
  for i:=1 to SourceCount do begin
    ShowChannelForm.ChannelList.Clear;
    ShowChannelForm.FileList.Clear;

    ShowChannelForm.FileList.Items.Add(ExtractFileName(DataSources[SourceNumber - 1].SourceName));
    ShowChannelForm.FileList.ItemIndex:= SourceNumber - 1;

    for j:=0 to Length(DataSources[SourceNumber - 1].TFFDataChannels) - 1 do begin
      ShowChannelForm.ChannelList.Items.Add(DataSources[SourceNumber - 1].TFFDataChannels[j].DLIS);
    end;

    ShowChannelForm.Show;
  end;
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
        Inc(SourceCount);
        OpenChannelForm(SourceCount);
     end
     else Application.MessageBox(GetErrorMessage(ErrorCode),'Error', MB_ICONERROR + MB_OK);
  end;
end;

procedure TApp.Image2Click(Sender: TObject);
begin
  Bin_DbToBin_Db();
end;

procedure TApp.Image3Click(Sender: TObject);
begin
  Chart1.ZoomFull();
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

procedure TApp.Chart1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = ShowChannelForm.ChannelList then Accept:=True;
end;

procedure TApp.Chart1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Sender is TChart) and (Source is TListBox) then
     with Source as TListBox do begin
       ShowMessage(Items[ItemIndex]);
       ShowMessage(ShowChannelForm.ChannelList.Items[ItemIndex]);
     end;
end;

procedure TApp.AddChartBtnClick(Sender: TObject);
begin
  if SourceCount > 0 then OpenChannelForm(SourceCount)
  else Application.MessageBox('Open at lease one file','Warning', MB_ICONQUESTION + MB_OK)
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

