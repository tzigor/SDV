unit ChartUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, UserTypes, TASeries, LineSerieUtils, TAGraph;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
procedure ChartsVisible(visible: Boolean);
procedure ChartsEnabled(visible: Boolean);
procedure ResetChartsZoom;
function GetFreeChart: Byte;
function GetLastChart: Byte;

implementation
uses Main;

function GetChannelValue(DataChannels: TTFFDataChannels; Frame: TFrameRecord; Channel: Word; var Value: Double): Boolean;
var Offset : Word;
    I1     : ShortInt;
    U1     : Byte;
    I2     : SmallInt;
    U2     : Word;
    I4     : LongInt;
    U4     : LongWord;
    U8     : QWord;
    F4     : Single;
    F8     : Double;

begin
  Result:= True;
  Offset:= DataChannels[Channel].Offset;
  case DataChannels[Channel].RepCode of
  'F4': begin
          Move(Frame.Data[Offset], F4, 4);
          if (F4 = -999.25) then Result:= False
          else Value:= F4;
        end;
  'F8': begin
          Move(Bytes[DataOffset], F8, 8);
          if (F4 = -999.25) then Result:= False
          else Value:= F8;
        end;
  'I1': begin
          Move(Frame.Data[Offset], I1, 1);
          if (I1 = 127) then Result:= False
          else Value:= I1;
        end;
  'U1': begin
          Move(Frame.Data[Offset], U1, 1);
          if (I1 = 255) then Result:= False
          else Value:= U1;
        end;
  'I2': begin
           Move(Frame.Data[Offset], I2, 2);
           if (I2 = 32767) then Result:= False
           else Value:= I2;
        end;
  'U2': begin
           Move(Frame.Data[Offset], U2, 2);
           if (U2 = 65535) then Result:= False
           else Value:= U2;
        end;
  'U4': begin
           Move(Frame.Data[Offset], U4, 4);
           if (U4 = 4294967295) then Result:= False
           else Value:= U4;
        end;
  'I4': begin
          Move(Frame.Data[Offset], I4, 4);
          if (I4 = 2147483647) then Result:= False
          else Value:= I4;
        end;
  end;
end;

procedure DrawSerie(LineSerie: TLineSeries; SelectedSource, SelectedParam: Word; Name: String);
var
  FramesCount, i : LongWord;
  Value          : Double;
begin
  LineSerie.Clear;
  LineSerie.Title:= Name;
  SetLineSerieColor(LineSerie, GetColorBySerieName(LineSerie.Name));
  LineSerie.Legend.Visible:= True;
  FramesCount:= Length(DataSources[SelectedSource].FrameRecords);
  for i:=0 to FramesCount - 1 do begin
    GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                    DataSources[SelectedSource].FrameRecords[i],
                    SelectedParam,
                    Value);
    LineSerie.AddXY(DataSources[SelectedSource].FrameRecords[i].DateTime, Value, '');
  end;
end;

function GetLastChart: Byte;
var i: Byte;
    MaxTop: Integer;
begin
  MaxTop:= 0;
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible AND (TChart(App.FindComponent('Chart' + IntToStr(i))).Top >= MaxTop) then begin
        MaxTop:= TChart(App.FindComponent('Chart' + IntToStr(i))).Top;
        GetLastChart:= i;
     end;
  end;
end;

function GetFreeChart: Byte;
var i: Byte;
begin
  for i:=1 to 8 do begin
     if TChart(App.FindComponent('Chart' + IntToStr(i))).Visible = false then begin
        GetFreeChart:= i;
        Break;
     end;
  end;
end;

procedure ChartsVisible(visible: Boolean);
var i: byte;
begin
 for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).Visible:= visible;
end;

procedure ChartsEnabled(visible: Boolean);
var i: byte;
begin
 for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).Visible:= visible;
end;

procedure ResetChartsZoom;
var i: byte;
begin
 for i:=1 to 8 do TChart(App.FindComponent('Chart' + IntToStr(i))).ZoomFull();
end;

end.

