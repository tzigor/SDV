unit UserTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, TASeries, TATypes, LCLType, TAGraph;

Const
  NewLine = #13#10;
  Tab = #09;
  MIN_FILE_LENGTH = 100;
  DATA_MAX_SIZE = 4294967295;
  MAX_CHART_NUMBER = 8;
  MAX_SERIE_NUMBER = 8;

  { Error codes }
  NO_ERROR                = 0;
  FILE_NOT_FOUND          = 1;
  WRONG_FILE_FORMAT       = 2;
  UNEXPECTED_END_OF_FILE  = 3;
  TERMINATED              = 4;
  OUT_OF_BOUNDS           = 5;

  { Navigation modes }
  NAVIGATION_OFF          = 0;
  ZOOM_MODE               = 1;
  PAN_MODE                = 2;
  DISTANCE_MODE_X         = 3;
  DISTANCE_MODE_Y         = 4;

  TFF_V20 = 2;
  TFF_V30 = 3;
  TFF_V40 = 4;
  TFF_V40_F8 = 40;

  F4_RESULT_ERROR = -999.25;
  F8_RESULT_ERROR = -999.25;
  I1_RESULT_ERROR = 127;
  U1_RESULT_ERROR = 255;
  I2_RESULT_ERROR = 32767;
  U2_RESULT_ERROR = 65535;
  U4_RESULT_ERROR = 4294967295;
  I4_RESULT_ERROR = 2147483647;

Type
  String4 = String[4];
  String2 = String[2];

  TMinMax = record
    Min : Double;
    Max : Double;
  end;

  TTFFDataChannel = record
    DLIS        : String;
    Units       : String4;
    RepCode     : String2;
    Samples     : String;
    AbsentValue : String;
    Offset      : Word;
  end;

  TTFFDataChannels = array of TTFFDataChannel;

  TFrameRecord = record
    DateTime: TDateTime;
    Data: TBytes;
  end;

  TFrameRecords = array of TFrameRecord;

  TCurveStyle = record
    Parameter        : ShortString;
    LineColor        : TColor;
    LineWidth        : Byte;
    LineStyle        : TPenStyle;
    PointBrushColor  : TColor;
    PointPenColor    : TColor;
    PointStyle       : TSeriesPointerStyle; { Brash color = ChartBGColor for transparent pointer }
    PointSize        : Byte;
    TransperentPoint : Boolean;
  end;

var
   ChartColors     : array of TColor = (clRed, clBlue, clGreen, clPurple, TColor($C80000), TColor($00C800), clFuchsia, clMaroon);

implementation

end.

