unit uITesteLogica;

interface

type
  INetwork    = interface;
  IGroupList  = interface;
  IGroup      = interface;
  IPairList   = interface;
  IPair       = interface;
  IVerifier   = interface;
  IGroupCreator = interface;

  INetwork = interface
  ['{67A5BF21-E70B-4680-A09D-3D05C69640A0}']
    function Connect(AFirstElement, ASecondElement: Integer): INetwork;
    function Query(AFirstElement, ASecondElement: Integer): Boolean;
  end;

  IGroupList = interface
  ['{12BE2457-2150-48FE-B014-1D55F758E5F1}']
    function Add(AGroup: IGroup): IGroupList;
    function Remove(AGroup: IGroup): IGroupList;
    function Count: Integer;
    function GetItem(AIndex: Integer): IGroup;
  end;

  IGroup = interface
  ['{CDBCEF9F-4C26-4232-947E-4A59C7BFACF6}']
    function Pairs: IPairList;
    function HasAny(APair: IPair): Boolean;
    function HasPair(APair: IPair): Boolean;
  end;

  IPairList = interface
  ['{945F33FE-7E99-4B76-B2A0-AF917CABBF0A}']
    function Add(APair: IPair): IPairList;
    function Count: Integer;
    function GetItem(AIndex: Integer): IPair;
  end;

  IPair = interface
  ['{FC613733-796B-478E-A614-0BC1A9AFA669}']
    function GetFirstElement: Integer;
    function GetSecondElement: Integer;
  end;

  IGroupCreator = interface
  ['{781D2C73-DCA0-49A2-B77F-FD9165CDE10A}']
    function CheckPair(APair: IPair): Boolean;
  end;

  IVerifier = interface
  ['{AB6F4DB4-228D-4D3B-A0CA-DBF8E1CEB4BB}']
    procedure Verify;
  end;

implementation

end.
