program TesteLogica;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uTesteLogica in 'uTesteLogica.pas',
  uITesteLogica in 'uITesteLogica.pas';

var
  oNetWork: INetwork;
begin
  try
    oNetWork := TNetwork.New(8);

    oNetWork
      .Connect(1,2)
      .Connect(6,2)
      .Connect(2,4)
      .Connect(5,8);


    if oNetWork.Query(7,4) then
      Writeln('There is a connection between the elements!')
    else
      Writeln('There is no connection between the elements!');

    Writeln('Press ENTER to exit');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;


end.
