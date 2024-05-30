unit SIBRParam;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uComplex, Math;

function NameToInt(name: String): Integer;
function angle(q: Complex): Double;
function GetSonde(SelectedSource: Word; Param: String; n: Integer): Double;
function GetCompSonde(SelectedSource: Word; Param: String; n: Integer): Double;

var
  VT0R1F1, VT0R2F1, VT0R1F2, VT0R2F2, VT1R1F1, VT1R2F1, VT2R1F1, VT2R2F1, VT3R1F1, VT3R2F1, VT1R1F2, VT1R2F2, VT2R1F2, VT2R2F2, VT3R1F2, VT3R2F2: complex;
  VR1C0F1, VR2C0F1, VR1C0F2, VR2C0F2, VR1C1F1, VR2C1F1, VR1C2F1, VR2C2F1, VR1C3F1, VR2C3F1, VR1C1F2, VR2C1F2, VR1C2F2, VR2C2F2, VR1C3F2, VR2C3F2: complex;
  T0F1_UNC, T1F1_UNC, T2F1_UNC, T3F1_UNC, T0F2_UNC, T1F2_UNC, T2F2_UNC, T3F2_UNC: complex;

implementation
uses Utils, ChartUtils, Main, UserTypes;

var SondeError: Boolean;

function angle(q: Complex): Double;
begin
  Result:= ArcTan2(q.im, q.re);
end;

function NameToInt(name: String): Integer;
begin
   if name[4] = 'C' then NameToInt:= StrToInt(name[5])*4 + (StrToInt(name[7])-1)*2 + StrToInt(name[3])-1 + 1000
   else NameToInt:= StrToInt(name[5])*4 + (StrToInt(name[7])-1)*2 + StrToInt(name[3])-1;
end;

function ComplexAmplitude(SelectedSource, nParam, n, shift: Integer): complex;
var StartParamPos, Step: Integer;
begin
  StartParamPos:= ResParamPosition + shift;
  if (nParam mod 2) = 0 then Step:= (nParam div 2) * 8
  else Step:= ((nParam div 2) * 8) + 2;

  GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                         DataSources[SelectedSource].FrameRecords[n],
                         StartParamPos + Step,
                         ComplexAmplitude.re);
  GetChannelValue(DataSources[SelectedSource].TFFDataChannels,
                         DataSources[SelectedSource].FrameRecords[n],
                         StartParamPos + Step + 1,
                         ComplexAmplitude.im);
end;

procedure FillCoplexParams(SelectedSource, n: Integer; Freq: Byte);
// Freq = 0 - 400 KHz, Freq = 1 - 2 MHz
begin
  SondeError:= False;
  if Freq = 0 then begin // F1 - 400 KHz
     VT0R1F1:= ComplexAmplitude(SelectedSource, 0, n, 4);
     VT0R2F1:= ComplexAmplitude(SelectedSource, 1, n, 4);

     VT1R1F1:= ComplexAmplitude(SelectedSource, 4, n, 4);
     VT1R2F1:= ComplexAmplitude(SelectedSource, 5, n, 4);
     VT2R1F1:= ComplexAmplitude(SelectedSource, 8, n, 4);
     VT2R2F1:= ComplexAmplitude(SelectedSource, 9, n, 4);
     VT3R1F1:= ComplexAmplitude(SelectedSource, 12, n, 4);
     VT3R2F1:= ComplexAmplitude(SelectedSource, 13, n, 4);

     VR1C0F1:= ComplexAmplitude(SelectedSource, 0, n, 0);
     VR2C0F1:= ComplexAmplitude(SelectedSource, 1, n, 0);

     VR1C1F1:= ComplexAmplitude(SelectedSource, 4, n, 0);
     VR2C1F1:= ComplexAmplitude(SelectedSource, 5, n, 0);
     VR1C2F1:= ComplexAmplitude(SelectedSource, 8, n, 0);
     VR2C2F1:= ComplexAmplitude(SelectedSource, 9, n, 0);
     VR1C3F1:= ComplexAmplitude(SelectedSource, 12, n, 0);
     VR2C3F1:= ComplexAmplitude(SelectedSource, 13, n, 0);

     if (VT0R1F1<>0) and
        (VT0R2F1<>0) and
        (VT1R1F1<>0) and
        (VT1R2F1<>0) and
        (VT2R1F1<>0) and
        (VT2R2F1<>0) and
        (VT3R1F1<>0) and
        (VT3R2F1<>0) and
        (VR1C0F1<>0) and
        (VR2C0F1<>0) and
        (VR1C1F1<>0) and
        (VR2C1F1<>0) and
        (VR1C2F1<>0) and
        (VR2C2F1<>0) and
        (VR1C3F1<>0) and
        (VR2C3F1<>0) then begin
           T0F1_UNC:= VR1C0F1 / VR2C0F1;
           T1F1_UNC:= (VT1R1F1/VR1C1F1) / (VT1R2F1/VR2C1F1);
           T2F1_UNC:= (VT2R2F1/VR2C2F1) / (VT2R1F1/VR1C2F1);
           T3F1_UNC:= (VT3R1F1/VR1C3F1) / (VT3R2F1/VR2C3F1);
        end
        else SondeError:= True;
   end
   else begin // F2 - 2 MHz
     VT0R1F2:= ComplexAmplitude(SelectedSource, 2, n, 4);
     VT0R2F2:= ComplexAmplitude(SelectedSource, 3, n, 4);

     VT1R1F2:= ComplexAmplitude(SelectedSource, 6, n, 4);
     VT1R2F2:= ComplexAmplitude(SelectedSource, 7, n, 4);
     VT2R1F2:= ComplexAmplitude(SelectedSource, 10, n, 4);
     VT2R2F2:= ComplexAmplitude(SelectedSource, 11, n, 4);
     VT3R1F2:= ComplexAmplitude(SelectedSource, 14, n, 4);
     VT3R2F2:= ComplexAmplitude(SelectedSource, 15, n, 4);

     VR1C0F2:= ComplexAmplitude(SelectedSource, 2, n, 0);
     VR2C0F2:= ComplexAmplitude(SelectedSource, 3, n, 0);

     VR1C1F2:= ComplexAmplitude(SelectedSource, 6, n, 0);
     VR2C1F2:= ComplexAmplitude(SelectedSource, 7, n, 0);
     VR1C2F2:= ComplexAmplitude(SelectedSource, 10, n, 0);
     VR2C2F2:= ComplexAmplitude(SelectedSource, 11, n, 0);
     VR1C3F2:= ComplexAmplitude(SelectedSource, 14, n, 0);
     VR2C3F2:= ComplexAmplitude(SelectedSource, 15, n, 0);

     if (VT0R1F2<>0) and
        (VT0R2F2<>0) and
        (VT1R1F2<>0) and
        (VT1R2F2<>0) and
        (VT2R1F2<>0) and
        (VT2R2F2<>0) and
        (VT3R1F2<>0) and
        (VT3R2F2<>0) and
        (VR1C0F2<>0) and
        (VR2C0F2<>0) and
        (VR1C1F2<>0) and
        (VR2C1F2<>0) and
        (VR1C2F2<>0) and
        (VR2C2F2<>0) and
        (VR1C3F2<>0) and
        (VR2C3F2<>0) then begin
           T0F2_UNC:= VR1C0F2 / VR2C0F2;
           T1F2_UNC:= (VT1R1F2/VR1C1F2) / (VT1R2F2/VR2C1F2);
           T2F2_UNC:= (VT2R2F2/VR2C2F2) / (VT2R1F2/VR1C2F2);
           T3F2_UNC:= (VT3R1F2/VR1C3F2) / (VT3R2F2/VR2C3F2);
        end
        else SondeError:= True;
   end;
end;

function GetSonde(SelectedSource: Word; Param: String; n: Integer): Double;
begin
   if RightStr(Param, 5) = 'L_UNC' then FillCoplexParams(SelectedSource, n, 0) // F1 - 400 KHz
   else FillCoplexParams(SelectedSource, n, 1); // F2 - 2 MHz
   if SondeError then GetSonde:= ParameterError
   else
     case Param of
       'P0L_UNC': GetSonde:= angle(T0F1_UNC) * 180/Pi;
       'P0H_UNC': GetSonde:= angle(T0F2_UNC) * 180/Pi;
       'P16L_UNC': GetSonde:= angle(T1F1_UNC) * 180/Pi;
       'P22L_UNC': GetSonde:= angle(T2F1_UNC) * 180/Pi;
       'P34L_UNC': GetSonde:= angle(T3F1_UNC) * 180/Pi;
       'P16H_UNC': GetSonde:= angle(T1F2_UNC) * 180/Pi;
       'P22H_UNC': GetSonde:= angle(T2F2_UNC) * 180/Pi;
       'P34H_UNC': GetSonde:= angle(T3F2_UNC) * 180/Pi;
       'A0L_UNC': GetSonde:= -20*Log10(cMod(T0F1_UNC));
       'A0H_UNC': GetSonde:= -20*Log10(cMod(T0F2_UNC));
       'A16L_UNC': GetSonde:= -20*Log10(cMod(T1F1_UNC));
       'A22L_UNC': GetSonde:= -20*Log10(cMod(T2F1_UNC));
       'A34L_UNC': GetSonde:= -20*Log10(cMod(T3F1_UNC));
       'A16H_UNC': GetSonde:= -20*Log10(cMod(T1F2_UNC));
       'A22H_UNC': GetSonde:= -20*Log10(cMod(T2F2_UNC));
       'A34H_UNC': GetSonde:= -20*Log10(cMod(T3F2_UNC));
     end;
end;

function GetCompSonde(SelectedSource: Word; Param: String; n: Integer): Double;
begin
   case Param of
     'A16L': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16L_UNC' ,n)*a[1,1]+GetSonde(SelectedSource, 'A22L_UNC', n)*a[1,2]+GetSonde(SelectedSource, 'A34L_UNC', n)*a[1,3]);
     'A22L': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16L_UNC' ,n)*a[2,1]+GetSonde(SelectedSource, 'A22L_UNC', n)*a[2,2]+GetSonde(SelectedSource, 'A34L_UNC', n)*a[2,3]);
     'A34L': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16L_UNC' ,n)*a[3,1]+GetSonde(SelectedSource, 'A22L_UNC', n)*a[3,2]+GetSonde(SelectedSource, 'A34L_UNC', n)*a[3,3]);
     'A16H': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16H_UNC' ,n)*a[1,1]+GetSonde(SelectedSource, 'A22H_UNC', n)*a[1,2]+GetSonde(SelectedSource, 'A34H_UNC', n)*a[1,3]);
     'A22H': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16H_UNC' ,n)*a[2,1]+GetSonde(SelectedSource, 'A22H_UNC', n)*a[2,2]+GetSonde(SelectedSource, 'A34H_UNC', n)*a[2,3]);
     'A34H': GetCompSonde:= Abs(GetSonde(SelectedSource, 'A16H_UNC' ,n)*a[3,1]+GetSonde(SelectedSource, 'A22H_UNC', n)*a[3,2]+GetSonde(SelectedSource, 'A34H_UNC', n)*a[3,3]);

     'P16L': GetCompSonde:= (GetSonde(SelectedSource, 'P16L_UNC' ,n)*a[1,1]+GetSonde(SelectedSource, 'P22L_UNC', n)*a[1,2]+GetSonde(SelectedSource, 'P34L_UNC', n)*a[1,3])*180/Pi;
     'P22L': GetCompSonde:= (GetSonde(SelectedSource, 'P16L_UNC' ,n)*a[2,1]+GetSonde(SelectedSource, 'P22L_UNC', n)*a[2,2]+GetSonde(SelectedSource, 'P34L_UNC', n)*a[2,3])*180/Pi;
     'P34L': GetCompSonde:= (GetSonde(SelectedSource, 'P16L_UNC' ,n)*a[3,1]+GetSonde(SelectedSource, 'P22L_UNC', n)*a[3,2]+GetSonde(SelectedSource, 'P34L_UNC', n)*a[3,3])*180/Pi;
     'P16H': GetCompSonde:= (GetSonde(SelectedSource, 'P16H_UNC' ,n)*a[1,1]+GetSonde(SelectedSource, 'P22H_UNC', n)*a[1,2]+GetSonde(SelectedSource, 'P34H_UNC', n)*a[1,3])*180/Pi;
     'P22H': GetCompSonde:= (GetSonde(SelectedSource, 'P16H_UNC' ,n)*a[2,1]+GetSonde(SelectedSource, 'P22H_UNC', n)*a[2,2]+GetSonde(SelectedSource, 'P34H_UNC', n)*a[2,3])*180/Pi;
     'P34H': GetCompSonde:= (GetSonde(SelectedSource, 'P16H_UNC' ,n)*a[3,1]+GetSonde(SelectedSource, 'P22H_UNC', n)*a[1,2]+GetSonde(SelectedSource, 'P34H_UNC', n)*a[3,3])*180/Pi;
   end;
   if SondeError then GetCompSonde:= ParameterError
end;

end.

