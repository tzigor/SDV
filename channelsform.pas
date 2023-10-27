unit channelsform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TShowChannelForm }

  TShowChannelForm = class(TForm)
    CloseList: TBitBtn;
    ChannelList: TListBox;
    procedure CloseListClick(Sender: TObject);
  private

  public

  end;

var
  ShowChannelForm: TShowChannelForm;

implementation

{$R *.lfm}

{ TShowChannelForm }

procedure TShowChannelForm.CloseListClick(Sender: TObject);
begin
  ShowChannelForm.Close;
end;

end.

