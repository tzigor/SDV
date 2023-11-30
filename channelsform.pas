unit channelsform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LineSerieUtils, ChartUtils, TASeries, LCLType, ComCtrls, TAGraph, DateUtils,
  ToolsConfig, Types;

type

  { TShowChannelForm }

  TShowChannelForm = class(TForm)
    FastLabel: TLabel;
    FastMode: TCheckBox;
    MultiColumns: TCheckBox;
    DrawBtn: TBitBtn;
    CloseList: TBitBtn;
    ChannelList: TListBox;
    FileList: TListBox;
    RecordCount: TLabel;
    RecordsNumber: TTrackBar;
    SlowLabel: TLabel;
    procedure ChannelListDblClick(Sender: TObject);
    procedure CloseListClick(Sender: TObject);
    procedure DrawBtnClick(Sender: TObject);
    procedure FastModeChange(Sender: TObject);
    procedure FileListDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure FileListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FileListSelectionChange(Sender: TObject; User: boolean);
    procedure FormCreate(Sender: TObject);
    procedure MultiColumnsChange(Sender: TObject);
    procedure RecordsNumberChange(Sender: TObject);
    procedure RemoveFileBtnClick(Sender: TObject);
  private

  public

  end;

var
  ShowChannelForm: TShowChannelForm;

implementation
uses Main, Utils, UserTypes;

{$R *.lfm}

{ TShowChannelForm }

procedure TShowChannelForm.CloseListClick(Sender: TObject);
begin
  ShowChannelForm.Close;
end;

procedure TShowChannelForm.ChannelListDblClick(Sender: TObject);
begin
  if ChannelList.ItemIndex = -1 then Exit;
  DrawBtnClick(Sender);
end;

procedure TShowChannelForm.DrawBtnClick(Sender: TObject);
var Chart      : TChart;
begin
   if ChartsCount < MAX_CHART_NUMBER then begin
      CurrentChart:= GetFreeChart;
      Chart:= GetChart(CurrentChart);
      Inc(ChartsCount);
      CurrentSerie:= GetFreeLineSerie(CurrentChart);
      Chart.Visible:= True;
      Chart.Title.Text[0]:= Chart.Name;
      ParametersUnits[CurrentChart, CurrentSerie]:= DataSources[CurrentSource].TFFDataChannels[ChannelList.ItemIndex].Units;
      DrawSerie(GetLineSerie(CurrentChart, CurrentSerie), CurrentSource, ChannelList.ItemIndex, ChannelList.Items[ChannelList.ItemIndex]);
      ChartsPosition();
   end
   else Application.MessageBox('Too many charts','Error', MB_ICONERROR + MB_OK);
   ProgressDone;
end;

procedure TShowChannelForm.FastModeChange(Sender: TObject);
begin
  SetFastMode(FastMode.Checked);
end;

procedure TShowChannelForm.FileListDrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
begin
  with FileList do begin
    if (odSelected in State) then begin
       if Focused then begin
         Canvas.Brush.Color:=clHighlight;
         Canvas.Font.Color:=clWhite;
       end
       else begin
         Canvas.Brush.Color:=clSilver;
         Canvas.Font.Color:=clBlack;
       end
    end;
    Canvas.FillRect(ARect);
    Canvas.TextOut(ARect.Left, ARect.Top, Items[Index]);
  end;
end;

procedure TShowChannelForm.FileListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 46) Or (Key = 8) then begin
    Delete(DataSources, FileList.ItemIndex, 1);
    Dec(SourceCount);
    if SourceCount > 0 then PrepareChannelForm()
    else ShowChannelForm.Close;
  end;
end;

procedure TShowChannelForm.FileListSelectionChange(Sender: TObject;
  User: boolean);
var i : Byte;
begin
  if SourceCount > 1 then begin
    CurrentSource:= FileList.ItemIndex;
    ChannelList.Clear;
    for i:=0 to Length(DataSources[CurrentSource].TFFDataChannels) - 1 do begin
      ShowChannelForm.ChannelList.Items.Add(DataSources[CurrentSource].TFFDataChannels[i].DLIS);
    end;
  end;
end;

procedure TShowChannelForm.FormCreate(Sender: TObject);
begin
  SetFastMode(ShowChannelForm.FastMode.Checked);
end;

procedure TShowChannelForm.MultiColumnsChange(Sender: TObject);
begin
  if MultiColumns.Checked then ChannelList.Columns:= 3
  else ChannelList.Columns:= 0;
end;

procedure TShowChannelForm.RecordsNumberChange(Sender: TObject);
begin
  RecordCount.Caption:= 'Divide by ' + IntToStr(RecordsNumber.Position);
  FastModeDivider:= RecordsNumber.Position;
end;

procedure TShowChannelForm.RemoveFileBtnClick(Sender: TObject);
begin

end;

end.

