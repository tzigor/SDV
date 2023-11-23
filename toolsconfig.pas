unit ToolsConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, JSONParser, JSONScanner, fpJSON, FileUtil, UserTypes,
  Dialogs;

procedure jReadConfigTools();
function jGetStatusWords(Tool: String): TStatusWords;

implementation
uses Main, channelsform;

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
    On E : Exception do
      ShowMessage('ChannelsConfig.json syntax error')
  end;
end;

function jGetStatusWords(Tool: String): TStatusWords;
var
  JsonParser                : TJSONParser;
  JsonObject, JsonNestedObj : TJSONObject;
  JsonEnum                  : TBaseJSONEnumerator;
  cJsonStr                  : TFileStream;
  i, n                      : integer;
  StatusWords               : TStatusWords;
begin
  cJsonStr:= TFileStream.Create('ChannelsConfig.json',fmOpenRead or fmShareDenyWrite);
  JsonParser := TJSONParser.Create(cJsonStr, []);
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
               //App.Memo1.Lines.Add(JsonEnum.Current.Key);
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
end;

end.

