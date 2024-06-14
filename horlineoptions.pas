unit HorLineOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TAChartCombos, ColorBox, Spin;

type

  { THorLineForm }

  THorLineForm = class(TForm)
    CancelBtn: TButton;
    HorLineValue: TFloatSpinEdit;
    Label4: TLabel;
    SerieColorBox: TColorBox;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LineStyleBox: TChartComboBox;
    LineWidthBox: TChartComboBox;
    OkBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HorLineValueChange(Sender: TObject);
    procedure SerieColorBoxChange(Sender: TObject);
    procedure LineStyleBoxChange(Sender: TObject);
    procedure LineWidthBoxChange(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private

  public

  end;

var
  HorLineForm: THorLineForm;

implementation

uses Main;

{$R *.lfm}

procedure SetHorLineStyleParameters();
begin
  OnHintHorLine.SeriesColor:= HorLineForm.SerieColorBox.Selected;
  OnHintHorLine.Pen.Style:= HorLineForm.LineStyleBox.PenStyle;
  OnHintHorLine.Pen.Width:= HorLineForm.LineWidthBox.PenWidth;
end;

{ THorLineForm }

procedure THorLineForm.CancelBtnClick(Sender: TObject);
begin
  OnHintHorLine.SeriesColor:= wCurveStyle.LineColor;
  OnHintHorLine.Pen.Style:= wCurveStyle.LineStyle;
  OnHintHorLine.Pen.Width:= wCurveStyle.LineWidth;
  HorLineForm.Close;
end;

procedure THorLineForm.FormHide(Sender: TObject);
begin
  App.ChartToolset1DataPointHintTool1.Enabled:= True;
end;

procedure THorLineForm.HorLineValueChange(Sender: TObject);
begin
  OnHintHorLine.Position:= HorLineValue.Value;
  SetHorLineStyleParameters();
end;

procedure THorLineForm.SerieColorBoxChange(Sender: TObject);
begin
  LineStyleBox.PenColor:= SerieColorBox.Selected;
  LineWidthBox.PenColor:= SerieColorBox.Selected;
  SetHorLineStyleParameters();
end;

procedure THorLineForm.LineStyleBoxChange(Sender: TObject);
begin
  SetHorLineStyleParameters();
end;

procedure THorLineForm.LineWidthBoxChange(Sender: TObject);
begin
  SetHorLineStyleParameters();
end;

procedure THorLineForm.OkBtnClick(Sender: TObject);
begin
  OnHintHorLine.Position:= HorLineValue.Value;
  HorLineForm.Close;
end;

end.

