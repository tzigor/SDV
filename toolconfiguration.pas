unit ToolConfiguration;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, JSONParser, JSONScanner, fpJSON, FileUtil,
  UserTypes, Dialogs, StdCtrls;

type

  { TToolConfigForm }

  TToolConfigForm = class(TForm)
    CancelBtn: TButton;
    OkBtn: TButton;
    ToolConfigList: TListBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private

  public

  end;

var
  ToolConfigForm: TToolConfigForm;

procedure jReadConfigTools();
function jGetStatusWords(Tool: String): TStatusWords;
procedure ShowConfigForm();

implementation
uses Main;

{$R *.lfm}

procedure jReadConfigTools();
var
  JsonParser : TJSONParser;
  JsonObject : TJSONObject;
  JsonEnum   : TBaseJSONEnumerator;
  cJsonStr   : TFileStream;
begin
  if FileExists('ChannelsConfig.json') then
  try
    cJsonStr:= TFileStream.Create('ChannelsConfig.json',fmOpenRead or fmShareDenyWrite);
    JsonParser := TJSONParser.Create(cJsonStr, []);
    try
      JsonObject := JsonParser.Parse as TJSONObject;
      try
        JsonEnum := JsonObject.GetEnumerator;
        try
          while JsonEnum.MoveNext do ConfiguredTools.Add(JsonEnum.Current.Key);
        finally
          FreeAndNil(JsonEnum)
        end;
      finally
        FreeAndNil(JsonObject);
      end;
    finally
      FreeAndNil(JsonParser);
    end;
  except
    On E : Exception do ShowMessage('ChannelsConfig.json syntax error')
  end;
end;

function jGetStatusWords(Tool: String): TStatusWords;
var
  JsonParser                : TJSONParser;
  JsonObject                : TJSONObject;
  JsonEnum                  : TBaseJSONEnumerator;
  cJsonStr                  : TFileStream;
  i, n                      : integer;
  StatusWords               : TStatusWords;
begin
  cJsonStr:= TFileStream.Create('ChannelsConfig.json',fmOpenRead or fmShareDenyWrite);
  JsonParser := TJSONParser.Create(cJsonStr, []);
  try
    try
      JsonObject := JsonParser.Parse as TJSONObject;
      JsonObject:=JsonObject.FindPath(Tool + '.channels.statusWords') as TJSONObject;
      try
        JsonEnum := JsonObject.GetEnumerator;
        try
          n:= 0;
          while JsonEnum.MoveNext do
              if JsonObject.Types[JsonEnum.Current.Key] = jtArray then begin
                 Inc(n);
                 SetLength(StatusWords, n);
                 StatusWords[n - 1].Name:= JsonEnum.Current.Key;
                 StatusWords[n - 1].Bits:= TStringList.Create;
                 for i:=0 to Pred(TJSONArray(JsonEnum.Current.Value).Count) do
                    StatusWords[n - 1].Bits.Add(TJSONArray(JsonEnum.Current.Value).Items[i].AsString);
              end;
          Result:= StatusWords;
        finally
          FreeAndNil(JsonEnum);
          StatusWords:= Nil;
        end;
      finally
        FreeAndNil(JsonObject);
      end;
    finally
      FreeAndNil(JsonParser);
    end;
  except
    On E : Exception do ShowMessage('ChannelsConfig.json syntax error')
  end;
end;

procedure ShowConfigForm();
var i: Integer;
begin
  ToolConfigForm.ToolConfigList.Clear;
  for i:=0 to ConfiguredTools.Count - 1 do ToolConfigForm.ToolConfigList.Items.Add(ConfiguredTools[i]);
  ToolConfigForm.Show;
end;

procedure TToolConfigForm.CancelBtnClick(Sender: TObject);
begin
  ToolConfigForm.Close;
end;

procedure TToolConfigForm.OkBtnClick(Sender: TObject);
begin
  if ToolConfigList.ItemIndex > -1 then begin
     DataSources[CurrentSource].StatusWords:= jGetStatusWords(ToolConfigList.Items[ToolConfigList.ItemIndex]);
  end;
  ToolConfigForm.Close;
end;

end.

