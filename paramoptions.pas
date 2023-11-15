unit ParamOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ColorBox, TAChartCombos;

type

  { TParamOptionsForm }

  TParamOptionsForm = class(TForm)
    CancelBtn: TButton;
    PointSizeBox: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LineColorBox: TColorBox;
    LineStyleBox: TChartComboBox;
    LineWidthBox: TChartComboBox;
    OkBtn: TButton;
    ColorDialog1: TColorDialog;
    PointerColorBox: TColorBox;
    PointerStyleBox: TChartComboBox;
    TransparentPointer: TCheckBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure LineColorBoxChange(Sender: TObject);
    procedure LineStyleBoxChange(Sender: TObject);
    procedure LineWidthBoxChange(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure PointerColorBoxChange(Sender: TObject);
    procedure PointerStyleBoxChange(Sender: TObject);
    procedure PointSizeBoxChange(Sender: TObject);
    procedure TransparentPointerChange(Sender: TObject);
  private

  public

  end;

var
  ParamOptionsForm: TParamOptionsForm;

implementation

uses Main;

{$R *.lfm}

{ TParamOptionsForm }

procedure SetSerieStyleParameters();
begin
  OnHintSerie.SeriesColor:= ParamOptionsForm.LineColorBox.Selected;
  OnHintSerie.LinePen.Style:= ParamOptionsForm.LineStyleBox.PenStyle;
  OnHintSerie.LinePen.Width:= ParamOptionsForm.LineWidthBox.PenWidth;
  OnHintSerie.Pointer.HorizSize:= ParamOptionsForm.PointSizeBox.ItemIndex + 2;
  OnHintSerie.Pointer.VertSize:= ParamOptionsForm.PointSizeBox.ItemIndex + 2;

  if ParamOptionsForm.TransparentPointer.Checked then OnHintSerie.Pointer.Brush.Color:= ChartBGColor
  else OnHintSerie.Pointer.Brush.Color:= ParamOptionsForm.PointerColorBox.Selected;

  OnHintSerie.Pointer.Pen.Color:= ParamOptionsForm.PointerColorBox.Selected;
  OnHintSerie.Pointer.Style:= ParamOptionsForm.PointerStyleBox.PointerStyle;
end;

procedure TParamOptionsForm.CancelBtnClick(Sender: TObject);
begin
  ParamOptionsForm.Close;
end;

procedure TParamOptionsForm.FormHide(Sender: TObject);
begin
  App.ChartToolset1DataPointHintTool1.Enabled:= True;
end;

procedure TParamOptionsForm.LineColorBoxChange(Sender: TObject);
begin
  LineStyleBox.PenColor:= LineColorBox.Selected;
  LineWidthBox.PenColor:= LineColorBox.Selected;
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.LineStyleBoxChange(Sender: TObject);
begin
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.LineWidthBoxChange(Sender: TObject);
begin
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.PointerColorBoxChange(Sender: TObject);
begin
  if TransparentPointer.Checked then PointerStyleBox.BrushColor:= ChartBGColor
  else PointerStyleBox.BrushColor:= PointerColorBox.Selected;
  ParamOptionsForm.PointerStyleBox.PenColor:= PointerColorBox.Selected;
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.PointerStyleBoxChange(Sender: TObject);
begin
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.PointSizeBoxChange(Sender: TObject);
begin
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.TransparentPointerChange(Sender: TObject);
begin
  if TransparentPointer.Checked then PointerStyleBox.BrushColor:= ChartBGColor
  else PointerStyleBox.BrushColor:= PointerColorBox.Selected;
  SetSerieStyleParameters;
end;

procedure TParamOptionsForm.OkBtnClick(Sender: TObject);
begin
  ParamOptionsForm.Close;
end;

end.

