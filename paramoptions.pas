unit ParamOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ColorBox, StdCtrls,
  TAChartCombos;

type

  { TParamOptionsForm }

  TParamOptionsForm = class(TForm)
    CancelBtn: TButton;
    OkBtn: TButton;
    ChartComboBox1: TChartComboBox;
    ChartComboBox2: TChartComboBox;
    ColorBox: TColorBox;
    ColorDialog1: TColorDialog;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private

  public

  end;

var
  ParamOptionsForm: TParamOptionsForm;

implementation

{$R *.lfm}

{ TParamOptionsForm }

procedure TParamOptionsForm.CancelBtnClick(Sender: TObject);
begin
  ParamOptionsForm.Close;
end;

procedure TParamOptionsForm.OkBtnClick(Sender: TObject);
begin
  ParamOptionsForm.Close;
end;

end.

