unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Buttons, TffObjects, Utils, UserTypes, ParseBinDb, LCLType, ExtCtrls,
  channelsform;

type

  { TApp }

  TApp = class(TForm)
    Indicator: TLabel;
    ProcessLabel: TLabel;
    LoadFile: TBitBtn;
    CloseApp: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    ChartPage: TTabSheet;
    ProcessProgress: TProgressBar;
    ScrollBox1: TScrollBox;
    procedure CloseAppClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadFileClick(Sender: TObject);
  private

  public

  end;

  TDataSource = record
      TFFDataChannels  : TTFFDataChannels;
      FrameRecords     : TFrameRecords;
  end;

  TDataSources = array of TDataSource;

var
  App: TApp;

   { Data souce current parameters }
  CurrentOpenedFile  : String;
  Bytes              : TBytes;   { Raw data source }
  CurrentFileSize    : LongWord;
  EndOfFile          : Boolean;
  DataOffset         : LongWord;
  TffStructure       : TTffStructure;
  DataSources        : TDataSources; { Data source for charts }
  SourceCount        : Byte;

  ShowIndicator      : Boolean;

implementation

{$R *.lfm}

{ TApp }

procedure Bin_DbToBin_Db();
var i : Byte;
begin
  if LoadSourceFile('bin_db', 100) then begin
     DataSources[SourceCount].FrameRecords:= BinDbParser(3);
     DataSources[SourceCount].TFFDataChannels:= TffStructure.GetTFFDataChannels;
     if ErrorCode = NO_ERROR then begin
        for i:=0 to Length(DataSources[SourceCount].TFFDataChannels) - 1 do begin
          ShowChannelForm.ChannelList.Items.Add(DataSources[SourceCount].TFFDataChannels[i].DLIS);
        end;
        ShowChannelForm.Show;
     end
     else Application.MessageBox(GetErrorMessage(ErrorCode),'Error', MB_ICONERROR + MB_OK);
  end;
end;

procedure TApp.FormCreate(Sender: TObject);
begin
  DecimalSeparator:= '.';
  SourceCount:= 0;
  SetLength(DataSources, 1);
end;

procedure TApp.LoadFileClick(Sender: TObject);
begin
  Bin_DbToBin_Db();
end;

procedure TApp.CloseAppClick(Sender: TObject);
begin
  App.Close;
end;

end.

