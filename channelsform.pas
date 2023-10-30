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
uses Main;

{$R *.lfm}

{ TShowChannelForm }

procedure TShowChannelForm.CloseListClick(Sender: TObject);
begin
  ShowChannelForm.Close;
end;

procedure TShowChannelForm.DrawBtnClick(Sender: TObject);
var Chart      : TChart;
begin
   if ChartCount < 8 then begin
      CurrentChart:= GetFreeChart;
      Chart:= TChart(App.FindComponent('Chart' + IntToStr(CurrentChart)));
      //Chart.Enabled:= True;
      Chart.Visible:= True;
      Chart.Top:= 0;
      Chart.Height:= App.ChartScrollBox.Height Div ChartCount;
      DrawSerie(GetLineSerie(CurrentChart, CurrentSerie), CurrentSource, ChannelList.ItemIndex, ChannelList.Items[ChannelList.ItemIndex]);
      Inc(ChartCount);
   end
   else Application.MessageBox('Too many curves for chart','Error', MB_ICONERROR + MB_OK);
end;

end.

