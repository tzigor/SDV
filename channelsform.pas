unit channelsform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LineSerieUtils, ChartUtils, TASeries, LCLType, TAGraph;

type

  { TShowChannelForm }

  TShowChannelForm = class(TForm)
    DrawBtn: TBitBtn;
    CloseList: TBitBtn;
    ChannelList: TListBox;
    FileList: TListBox;
    procedure CloseListClick(Sender: TObject);
    procedure DrawBtnClick(Sender: TObject);
  private

  public

  end;

var
  ShowChannelForm: TShowChannelForm;

implementation
uses Main, Utils;

{$R *.lfm}

{ TShowChannelForm }

procedure TShowChannelForm.CloseListClick(Sender: TObject);
begin
  ShowChannelForm.Close;
end;

procedure TShowChannelForm.DrawBtnClick(Sender: TObject);
var Chart      : TChart;
begin
   if ChartsCount < 8 then begin
      CurrentChart:= GetFreeChart;
      Inc(ChartsCount);
      Chart:= TChart(App.FindComponent('Chart' + IntToStr(CurrentChart)));
      Chart.Visible:= True;
      Chart.Title.Text[0]:= Chart.Name;
      ChartsPosition();
      DrawSerie(GetLineSerie(CurrentChart, CurrentSerie), CurrentSource, ChannelList.ItemIndex, ChannelList.Items[ChannelList.ItemIndex]);
   end
   else Application.MessageBox('Too many charts','Error', MB_ICONERROR + MB_OK);
   ProgressDone;
end;

end.

