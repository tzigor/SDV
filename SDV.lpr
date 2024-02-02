program SDV;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, tachartaggpas, datetimectrls, Main, UserTypes,
  Utils, TffObjects, ParseBinDb, ChannelsForm, LineSerieUtils, ParamOptions,
  ToolsConfig, ToolConfiguration, LimitsForm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TApp, App);
  Application.CreateForm(TShowChannelForm, ShowChannelForm);
  Application.CreateForm(TParamOptionsForm, ParamOptionsForm);
  Application.CreateForm(TToolConfigForm, ToolConfigForm);
  Application.CreateForm(TLimitForm, LimitForm);
  Application.Run;
end.

