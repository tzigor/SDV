unit ParseCSV;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, DateUtils,
  UserTypes, StrUtils;

function CSVParser(Tff_Ver: Byte): TFrameRecords;

implementation
uses Main, TffObjects, Utils;

function GetParamValue(ParamNum: Integer; TextLine: String): String;
var LineLength, i, Counter, ParamStart: Integer;
    SubStr: String;
begin
  if ParamNum > 0 then begin
      LineLength:= Length(TextLine);
      Counter:= 1;
      SubStr:= '';
      ParamStart:= 0;
      for i:= 1 to LineLength do begin
         if ParamNum = Counter then begin
            ParamStart:= i;
            break;
         end;
         if (TextLine[i] = ';') Or (TextLine[i] = ',') then Inc(Counter);
      end;
      if ParamStart > 0 then begin
        repeat
          SubStr:= SubStr + TextLine[ParamStart];
          Inc(ParamStart);
        until ( TextLine[ParamStart] = ';' ) Or ( TextLine[ParamStart] = ',' ) Or ( ParamStart > LineLength );
        Result:= Trim(SubStr);
      end;
  end
  else Result:= '';
end;

function CSVParser(Tff_Ver: Byte): TFrameRecords;
var
  F4                : Single;
  CSVContent        : TStringList;
  DateTime          : Double;
  TffFrames         : TTffFrames;
  LineLength, i     : LongWord;
  ParameterCount, j : Word;
  SubStr, Title     : String;
  FrameOffset       : Word;
  UnixDateTime      : LongInt;
  TimePos, nPos     : Word;
  RTCmsPos          : Word = 0;
  n, PrevPercent    : Word;
  wStr              : String;
  MSecs             : LongInt;
  SIBR              : Boolean = False;

begin
  SubStr:= '';
  ParameterCount:= 0;
  TffFrames.Init;
  EndOfFile:= False;
  ErrorCode:= NO_ERROR;
  TffStructure.Init;
  CSVContent:= TStringList.Create;
  TimePos:= 1;
  nPos:= 0;
  ProgressInit(100, 'CSV Parsing');
  PrevPercent:= 0;
  try
      CSVContent.LoadFromFile(CurrentOpenedFile);
      LineLength:= Length(CSVContent[0]);

      for i:= 1 to LineLength do begin { Searching for Time }
         if (CSVContent[0][i] = ';') Or (CSVContent[0][i] = ',') then begin
            Inc(nPos);
            if AnsiUpperCase(Trim(SubStr)) = 'RTCS' then begin
               SubStr:= 'TIME';
               TimePos:= nPos;
               SIBR:= True;
            end;
            if AnsiUpperCase(Trim(SubStr)) = 'TIME' then begin
              Title:= '100S';
              TffStructure.AddChannel(SubStr, Title, 'F4', '1', Tff_Ver);
              Inc(ParameterCount);
              Break;
            end;
            SubStr:= '';
         end
         else SubStr:= SubStr + CSVContent[0][i];
      end;

      SubStr:= '';
      nPos:= 0;
      for i:= 1 to LineLength do begin
         if (CSVContent[0][i] = ';') Or (CSVContent[0][i] = ',') then begin
            Inc(nPos);
            if nPos <> TimePos then begin
               if AnsiUpperCase(Trim(SubStr)) = 'RTCMS' then RTCmsPos:= nPos;
               TffStructure.AddChannel(SubStr, '', 'F4', '1', Tff_Ver);
               Inc(ParameterCount);
            end;
            SubStr:= '';
         end
         else SubStr:= SubStr + CSVContent[0][i];
      end;

      for i:=1 to CSVContent.Count-1 do begin
         wStr:= GetParamValue(TimePos, CSVContent[i]);
         SmartStrToDateTime(wStr, DateTime);

         if RTCmsPos > 0 then begin
            TryStrToInt(GetParamValue(RTCmsPos, CSVContent[i]), MSecs);
            DateTime:= IncMilliSecond(DateTime, MSecs);
         end;
         TffFrames.AddRecord(DateTime, TffStructure.GetDataChannelSize, TffStructure.GetTFFDataChannels);
         FrameOffset:= 0;
         for j:=1 to ParameterCount do begin
            if j <> TimePos then begin
              if TryStrToFloat(GetParamValue(j, CSVContent[i]), F4) then begin
                 TffFrames.AddData(FrameOffset, F4);
              end;
              Inc(FrameOffset, 4);
            end;
         end;

         n:= Trunc(i * 100 / CSVContent.Count);
         if (n > PrevPercent) then begin
            App.ProcessProgress.Position:= n;
            PrevPercent:= n;
         end;

      end;

      App.ProcessProgress.Position:= 100;
      App.ProcessLabel.Caption:= 'Process channel';

      if TffFrames.GetFrameRecords = Nil then ErrorCode:= WRONG_FILE_FORMAT;
      Result:= TffFrames.GetFrameRecords;
      CSVContent.Clear;
      FreeAndNil(CSVContent);
      TffFrames.Done;
  except
    on E: EInOutError do
      ShowMessage('Error: ' + E.Message);
  end;
end;

end.

