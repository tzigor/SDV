unit UserTypes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

Const
  NewLine = #13#10;
  Tab = #09;
  MIN_FILE_LENGTH = 100;
  DATA_MAX_SIZE = 4294967295;

  ChartColors: array of TColor = (clRed, clBlue, clGreen, clPurple, clHighLight, clTeal, clFuchsia, clMaroon);

  { Error codes }
  NO_ERROR                = 0;
  FILE_NOT_FOUND          = 1;
  WRONG_FILE_FORMAT       = 2;
  UNEXPECTED_END_OF_FILE  = 3;
  TERMINATED              = 4;

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

implementation

end.

