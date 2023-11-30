unit UserTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, TASeries, TATypes, LCLType, TAGraph;

Const
  NewLine = #13#10;
  Tab     = #09;

  MIN_FILE_LENGTH  = 100;
  DATA_MAX_SIZE    = 4294967295;
  MAX_CHART_NUMBER = 8;
  MAX_SERIE_NUMBER = 8;

  { Error codes }
  NO_ERROR               = 0;
  FILE_NOT_FOUND         = 1;
  WRONG_FILE_FORMAT      = 2;
  UNEXPECTED_END_OF_FILE = 3;
  TERMINATED             = 4;
  OUT_OF_BOUNDS          = 5;

  { Navigation modes }
  NAVIGATION_OFF   = 0;
  ZOOM_MODE        = 1;
  PAN_MODE         = 2;
  DISTANCE_MODE_X  = 3;
  DISTANCE_MODE_Y  = 4;

  TFF_V20    = 2;
  TFF_V30    = 3;
  TFF_V40    = 4;
  TFF_V40_F8 = 40;

  F4_RESULT_ERROR = -999.25;
  F8_RESULT_ERROR = -999.25;
  I1_RESULT_ERROR = 127;
  U1_RESULT_ERROR = 255;
  I2_RESULT_ERROR = 32767;
  U2_RESULT_ERROR = 65535;
  U4_RESULT_ERROR = 4294967295;
  I4_RESULT_ERROR = 2147483647;

  FooterSize = 40;

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
    DateTime : TDateTime;
    Data     : TBytes;
  end;

  TFrameRecords = array of TFrameRecord;

  TStatusWord = record
    Name : String;
    Bits : TStringList;
  end;

  TStatusWords = array of TStatusWord;

  TCurveStyle = record
    Parameter        : String;
    LineColor        : TColor;
    LineWidth        : Byte;
    LineStyle        : TPenStyle;
    PointBrushColor  : TColor;
    PointPenColor    : TColor;
    PointStyle       : TSeriesPointerStyle; { Brash color = ChartBGColor for transparent pointer }
    PointSize        : Byte;
    TransperentPoint : Boolean;
  end;

  Const SWLo: array of String = (
      '+24V_CTRL out of range ±30%',
      '+20V_SONDE out of range ±30%',
      '+20VP out of range ±10%',
      '+5V out of range ±10%',
      '+3.3V out of range ±10%',
      '+2.5V out of range ±10%',
      '+1.8V out of range ±10%',
      '+1.2V out of range ±10%',
      '+5V Transmitters out of range ±10%',
      'CTRL board temperature out of range',
      'RTC is out of sync (waiting for TIMESTAMPING command)',
      'CAN bus error. Data cannot be sent',
      'GOLD firmware loaded',
      'SPI-Flash error',
      'I2C0 bus error',
      'I2C0 bus multiple error');
      SWHi: array of String = (
      'SPI0 bus error',
      'SPI1 bus error',
      'NAND Flash initialisation error',
      'NAND Flash page write error',
      'NAND Flash block clear error',
      'NAND Flash page read error',
      'NAND Flash new bad block',
      'NAND-Flash is about full',
      'NAND-Flash is full',
      'Packets loss',
      'LVDS bus error',
      'ADC input overflow',
      'ADC multiple input overflow',
      'Low signal of any receivers',
      'Reserved',
      'PIPE DETECTOR. Low signal of both receivers');
      ESWLo: array of String = (
      'Data exchange error with transmitter - addr 1',
      'Data exchange error with transmitter - addr 2',
      'Data exchange error with transmitter - addr 3',
      'Data exchange error with receiver - addr 4',
      'Data exchange error with receiver - addr 5',
      'Logging started',
      'BHT & TEMP_CTRL difference > 25C ',
      'Calculation error',
      'Cabration file corrupted',
      'Reserve',
      'Reserve',
      'Reserve',
      'Active logging identifier bit 0',
      'Active logging identifier bit 1',
      'Active logging identifier bit 2',
      'Active logging identifier bit 3');

var
   ChartColors : array of TColor = (clRed, clBlue, clGreen, clPurple, TColor($C80000), TColor($00C800), clFuchsia, clMaroon);

implementation

end.

