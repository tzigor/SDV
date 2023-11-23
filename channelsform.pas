unit channelsform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LineSerieUtils, ChartUtils, TASeries, LCLType, TAGraph, DateUtils,
  ToolsConfig;

type

  { TShowChannelForm }

  TShowChannelForm = class(TForm)
    MultiColumns: TCheckBox;
    RemoveFileBtn: TButton;
    DrawBtn: TBitBtn;
    CloseList: TBitBtn;
    ChannelList: TListBox;
    FileList: TListBox;
    procedure ChannelListDblClick(Sender: TObject);
    procedure CloseListClick(Sender: TObject);
    procedure DrawBtnClick(Sender: TObject);
    procedure FileListSelectionChange(Sender: TObject; User: boolean);
    procedure MultiColumnsChange(Sender: TObject);
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

procedure TShowChannelForm.MultiColumnsChange(Sender: TObject);
begin
  if MultiColumns.Checked then ChannelList.Columns:= 3
  else ChannelList.Columns:= 0;
end;

procedure TShowChannelForm.RemoveFileBtnClick(Sender: TObject);
begin
  Delete(DataSources, FileList.ItemIndex, 1);
  Dec(SourceCount);
  if SourceCount > 0 then PrepareChannelForm(SourceCount)
  else ShowChannelForm.Close;
end;

end.

