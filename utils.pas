unit Utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, DateUtils,
  UserTypes, StrUtils, Buttons, LCLType;

function GetErrorMessage(error: Byte): PChar;
procedure LoadByteArray(const AFileName: string);
procedure SaveByteArray(AByteArray: TBytes; const AFileName: string);
function LoadSourceFile(FileExt: String; MinFileSize: LongWord): Boolean;
function ReadCurrentByte(): Byte;
function isEndOfFile(): Boolean;
procedure IncDataOffset(n: LongWord);
procedure ProgressInit(n: LongWord; PLabel: String);
procedure ProgressDone();

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

end.

