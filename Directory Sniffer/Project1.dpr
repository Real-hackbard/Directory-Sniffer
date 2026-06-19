program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Sniffer in 'Sniffer.pas',
  Options in 'Options.pas' {Form2},
  DiskProperties in 'DiskProperties.pas' {Form3},
  DiskInformation in 'DiskInformation.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
