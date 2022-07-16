// Tastatur-LEDs bei einem Tuxedo-Notebbook steuern
// FÜr Tuxedo Polaris 15, Uniwill-Chipsatz
//
// Funktioniert nur zusammen mit den Systemd-Scripten
// tuxedo_keyboard.path, tuxedo_keyboard.service und dem
// Bash-Script tuxedo-keyboard.sh
//
// Das Programm verwendet BGRA-Controls
// https://wiki.freepascal.org/BGRAControls
unit untMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, XMLPropStorage, BGRAShape,INIFiles, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnApply: TButton;
    edtPath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sBlack: TBGRAShape;
    Panel1: TPanel;
    Panel2: TPanel;
    sSelColor: TBGRAShape;
    sWHITE: TBGRAShape;
    sRED: TBGRAShape;
    sGREEN: TBGRAShape;
    sBLUE: TBGRAShape;
    sYELLOW: TBGRAShape;
    sMAGENTA: TBGRAShape;
    sCYAN: TBGRAShape;
    trkBright: TTrackBar;
    XMLPropStorage1: TXMLPropStorage;
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sColorClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnApplyClick(Sender: TObject);
var
    sColor:String;
    INI:TINIFile;
begin
  //Colors BLACK RED GREEN BLUE YELLOW MAGENTA CYAN WHITE
  // ->
  case sSelColor.FillColor of
  clBlack: sColor:='BLACK';
  clRED: sColor:='RED';
  clGreen: sColor:='GREEN';
  clBlue: sColor:='BLUE';
  clYellow: sColor:='YELLOW';
  clFuchsia: sColor:='MAGENTA';
  clAqua: sColor:='CYAN';
  clWhite: sColor:='WHITE';
  end;

  if edtPath.Text='' Then
  begin
  ShowMessage('Bitte eine INI-Datei mit Pfad angeben.');
  Exit;
  end;
  INI := TINIFile.Create(Trim(edtPath.Text));
  try
  //Werte in der INI-Datei speichern
  INI.WriteString('Settings','color',sColor);
  INI.WriteInteger('Settings','brightness',trkBright.Position);
  finally
    INI.Free;
  end;
end;
procedure TForm1.FormCreate(Sender: TObject);
var
sEnvHOME:String;
sColor:String;
INI:TINIFile;
begin
sEnvHOME:=GetEnvironmentVariable('HOME');
//gespeicherten Pfad verwenden oder Standard
if edtPath.Text='' Then edtPath.Text:=sEnvHOME + '/tuxedo_keyboard.ini';
INI := TINIFile.Create(edtPath.Text);
//Werte aus INI-Datei lesen
try
sColor:=INI.ReadString('Settings','color','RED');
trkBright.Position:=INI.ReadInteger('Settings','brightness',80);
case sColor of
'BLACK':sSelColor.FillColor:=clBlack;
'RED':sSelColor.FillColor:=clRed;
'GREEN':sSelColor.FillColor:=clGreen;
'BLUE':sSelColor.FillColor:=clBlue;
'YELLOW':sSelColor.FillColor:=clYellow;
'MAGENTA':sSelColor.FillColor:=clFuchsia;
'CYAN':sSelColor.FillColor:=clAqua;
'WHITE':sSelColor.FillColor:=clWhite;
end;
finally
  INI.Free;
end;
end;

procedure TForm1.sColorClick(Sender: TObject);
begin
  sSelColor.FillColor:=(Sender as TBGRAShape).FillColor;
end;

end.

