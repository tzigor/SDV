unit LimitsForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  LineSerieUtils, ChartUtils;

type

  { TLimitForm }

  TLimitForm = class(TForm)
    CancelBtn: TButton;
    OkBtn: TButton;
    Minimum: TFloatSpinEdit;
    Maximum: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Parameter: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private

  public

  end;

var
  LimitForm: TLimitForm;

implementation
uses Main;

{$R *.lfm}

{ TLimitForm }

procedure TLimitForm.CancelBtnClick(Sender: TObject);
begin
  LimitForm.Hide;
end;

procedure TLimitForm.OkBtnClick(Sender: TObject);
begin
  Inc(HorLineCount);
  AddHorLineSerie(GetChart(SelectedChart), GetFreeHorizontalLine(), LimitForm.Minimum.Value);
  Inc(HorLineCount);
  AddHorLineSerie(GetChart(SelectedChart), GetFreeHorizontalLine(), LimitForm.Maximum.Value);
  LimitForm.Hide;
end;

end.

