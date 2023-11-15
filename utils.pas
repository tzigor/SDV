unit Utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, DateUtils,
  UserTypes, StrUtils, Buttons, LCLType, TASeries, TADataTools, TATools;

function GetErrorMessage(error: Byte): PChar;
procedure LoadByteArray(const AFileName: string);
procedure SaveByteArray(AByteArray: TBytes; const AFileName: string);
function LoadSourceFile(FileExt: String; MinFileSize: LongWord): Boolean;
function ReadCurrentByte(): Byte;
function isEndOfFile(): Boolean;
procedure IncDataOffset(n: LongWord);
procedure ProgressInit(n: LongWord; PLabel: String);
procedure ProgressDone();
function GetSticker(x, y: Double; Param: String): String;
procedure StickLabel(ChartLineSerie: TLineSeries);
procedure SetNavigation(NavMode: Byte);

implementation

uses Main;

function GetErrorMessage(error: Byte): PChar;
begin
  case error of
     0: Result:= 'NO_ERROR';
     1: Result:= 'FILE_NOT_FOUND';
     2: Result:= 'WRONG_FILE_FORMAT';
     3: Result:= 'UNEXPECTED_END_OF_FILE';
  end;
end;

procedure LoadByteArray(const AFileName: string);
var
  AStream: TStream;
  ADataLeft: LongWord;
begin
  AStream:= TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    try
      AStream.Position:= 0;
      ADataLeft:= AStream.Size;
      SetLength(Bytes, ADataLeft div SizeOf(Byte));
      AStream.Read(PByte(Bytes)^, ADataLeft);
    except
      on Exception : EStreamError do
         Bytes:= Null;
    end;
  finally
    AStream.Free;
  end;
end;

function LoadSourceFile(FileExt: String; MinFileSize: LongWord): Boolean; // Load bin file to the Bytes array
begin
  Result:= False;
  App.OpenDialog.Filter:= 'bin files|*.' + FileExt + '|all files|*.*|';
  App.OpenDialog.DefaultExt:= '.' + FileExt;
  if App.OpenDialog.Execute then begin
     App.Indicator.Caption:= 'Loading file';
     App.Indicator.Refresh;
     LoadByteArray(App.OpenDialog.FileName);
     if Bytes <> Nil then begin
        CurrentFileSize:= Length(Bytes);
        DataOffset:= 0;
        if CurrentFileSize >= MinFileSize then begin
           EndOfFile:= False;
           Result:= True;
           CurrentOpenedFile:= App.OpenDialog.FileName;
           App.Indicator.Caption:= 'In progress';
           App.Indicator.Refresh;
        end;
     end;
  end;
end;

procedure SaveByteArray(AByteArray: TBytes; const AFileName: string);
var
  AStream: TStream;
begin
  try
    if FileExists(AFileName) then DeleteFile(AFileName);
    AStream := TFileStream.Create(AFileName, fmCreate);
    try
       AStream.WriteBuffer(Pointer(AByteArray)^, Length(AByteArray));
       App.Indicator.Caption:= 'File converted';
       App.Indicator.Refresh;
    finally
       AStream.Free;
    end;
  except
    Application.MessageBox('Target file is being used by another process','Error', MB_ICONERROR + MB_OK);
  end;
end;

function ReadCurrentByte(): Byte;
begin
  if Not EndOfFile then begin
     Result:= Bytes[DataOffset];
     Inc(DataOffset);
     if DataOffset >= currentFileSize then begin
        EndOfFile:= True;
     end;
  end;
end;

function isEndOfFile(): Boolean;
begin
  if DataOffset >= currentFileSize then begin
     EndOfFile:= True;
     Result:= True;
  end
  else Result:= False;
end;

procedure IncDataOffset(n: LongWord);
var i: LongWord;
begin
   for i:=1 to n do ReadCurrentByte;
end;

procedure ProgressInit(n: LongWord; PLabel: String);
begin
  App.ProcessProgress.Max:= n;
  App.ProcessProgress.Position:= 0;
  App.ProcessProgress.Visible:= True;
  App.ProcessLabel.Caption:= PLabel;
  App.ProcessLabel.Refresh;
end;

procedure ProgressDone();
begin
  App.ProcessProgress.Position:= 0;
  App.ProcessProgress.Visible:= False;
  App.ProcessLabel.Caption:= '';
  App.ProcessLabel.Refresh;
end;

function GetSticker(x, y: Double; Param: String): String;
var AfterDot: Byte;
begin
  if y > 10000 then AfterDot:= 0
  else AfterDot:= 3;
  Result:= Param + '=' + FloatToStrF(y, ffFixed, 12, AfterDot) + NewLine + DateTimeToStr(x);
end;

procedure StickLabel(ChartLineSerie: TLineSeries);
var y: Double;
    x: TDateTime;
begin
  if ChartLineSerie.Count > 0 then begin
     x:= ChartLineSerie.GetXValue(ChartPointIndex);
     y:= ChartLineSerie.GetYValue(ChartPointIndex);
     ChartLineSerie.ListSource.Item[ChartPointIndex]^.Text:= GetSticker(x, y, ChartLineSerie.Title);
     ChartLineSerie.ParentChart.Repaint;
  end;
end;

procedure SetNavigation(NavMode: Byte);
begin
  App.ChartToolset1PanDragTool1.Enabled:= False;
  App.ChartToolset1ZoomDragTool1.Enabled:= False;
  App.DistanceTool.Enabled:= False;
  App.ChartToolset1DataPointClickTool4.Enabled:= False;
  App.ChartToolset1DataPointHintTool1.Enabled:= False;
  App.ZoomOff.Visible:= True;
  App.ZoomOn.Visible:= False;
  App.PanOff.Visible:= True;
  App.PanOn.Visible:= False;
  App.DistanceXOff.Visible:= True;
  App.DistanceXOn.Visible:= False;
  App.DistanceYOff.Visible:= True;
  App.DistanceYOn.Visible:= False;
  case NavMode of
     ZOOM_MODE:     begin
                       App.ChartToolset1ZoomDragTool1.Enabled:= True;
                       App.ChartToolset1DataPointClickTool4.Enabled:= True;
                       App.ChartToolset1DataPointHintTool1.Enabled:= True;
                       App.ZoomOff.Visible:= False;
                       App.ZoomOn.Visible:= True;
                    end;
     PAN_MODE:      begin
                       App.ChartToolset1PanDragTool1.Enabled:= True;
                       App.ChartToolset1DataPointClickTool4.Enabled:= True;
                       App.ChartToolset1DataPointHintTool1.Enabled:= True;
                       App.PanOff.Visible:= False;
                       App.PanOn.Visible:= True;
                    end;
     DISTANCE_MODE_X: begin
                       App.DistanceTool.Enabled:= True;
                       App.DistanceTool.MeasureMode:= cdmOnlyX;
                       App.DistanceXOff.Visible:= False;
                       App.DistanceXOn.Visible:= True;
                    end;
     DISTANCE_MODE_Y: begin
                       App.DistanceTool.Enabled:= True;
                       App.DistanceTool.MeasureMode:= cdmOnlyY;
                       App.DistanceYOff.Visible:= False;
                       App.DistanceYOn.Visible:= True;
                    end;
  end;
end;

end.

