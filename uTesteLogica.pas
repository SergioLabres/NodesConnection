unit uTesteLogica;

interface

uses uITesteLogica, Classes;

type
  TNetwork = class(TInterfacedObject, INetwork)
  private
    FElements: Integer;
    FGroupList: IGroupList;

    function Connect(AFirstElement, ASecondElement: Integer): INetwork;
    function Query(AFirstElement, ASecondElement: Integer): Boolean;
  public
    constructor Create(AElements: Integer);
    destructor Destroy; override;

    class function New(AElements: Integer): INetwork;
  end;

  TGroupList = class(TInterfacedObject, IGroupList)
  private
    FGroups: TInterfaceList;
    function Add(AGroup: IGroup): IGroupList;
    function Remove(AGroup: IGroup): IGroupList;
    function Count: Integer;
    function GetItem(AIndex: Integer): IGroup;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IGroupList;
  end;

  TGroup = class(TInterfacedObject, IGroup)
  private
    FPairList: IPairList;
    function Pairs: IPairList;
    function HasAny(APair: IPair): Boolean;
    function HasPair(APair: IPair): Boolean;
  public
    constructor Create(APair: IPair);
    destructor Destroy; override;

    class function New(APair: IPair): IGroup;
  end;

  TPairList = class(TInterfacedObject, IPairList)
  private
    FPairs: TInterfaceList;
    function Add(APair: IPair): IPairList;
    function Count: Integer;
    function GetItem(AIndex: Integer): IPair;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IPairList;
  end;

  TPair = class(TInterfacedObject, IPair)
  private
    FFirstElement: Integer;
    FSecondElement: Integer;
    function GetFirstElement: Integer;
    function GetSecondElement: Integer;
  public
    constructor Create(AFirstElement, ASecondElement: Integer);
    destructor Destroy; override;

    class function New(AFirstElement, ASecondElement: Integer): IPair;
  end;

  TGroupCreator = class(TInterfacedObject, IGroupCreator)
  private
    FGroupList: IGroupList;
    function CheckPair(APair: IPair): Boolean;
    procedure MovingPairs(AGroup, ASavedGroup: IGroup);
  public
    constructor Create(AGroupList: IGroupList);
    destructor Destroy; override;

    class function New(AGroupList: IGroupList): IGroupCreator;
  end;

  TVerifier = class(TInterfacedObject, IVerifier)
  private
    FMaxElements: Integer;
    FFirstElement: Integer;
    FSecondElement: Integer;
    procedure Verify;
  public
    constructor Create(AMaxElements, AFirstElement, ASecondElement: Integer);
    destructor Destroy; override;

    class function New(AMaxElements, AFirstElement, ASecondElement: Integer): IVerifier;
  end;


implementation

uses SysUtils;

{ TNetwork }

function TNetwork.Connect(AFirstElement, ASecondElement: Integer): INetwork;
begin
  TVerifier.New(FElements, AFirstElement, ASecondElement).Verify;
  
  TGroupCreator
    .New(FGroupList)
    .CheckPair(TPair.New(AFirstElement, ASecondElement));

  Result := Self;
end;

constructor TNetwork.Create(AElements: Integer);
begin
  if AElements <= 0 then
    raise Exception.Create('Invalid value!');
    
  FElements   := AElements;
  FGroupList  := TGroupList.Create;
end;

destructor TNetwork.Destroy;
begin
  inherited;
end;

class function TNetwork.New(AElements: Integer): INetwork;
begin
  Result := TNetwork.Create(AElements);
end;

function TNetwork.Query(AFirstElement, ASecondElement: Integer): Boolean;
var
  i: Integer;
begin
  TVerifier.New(FElements, AFirstElement, ASecondElement).Verify;

  for i := 0 to FGroupList.Count -1 do
  begin
    Result := FGroupList.GetItem(i).HasPair(TPair.New(AFirstElement, ASecondElement));
    if Result then
      Break;
  end;  
end;

{ TGroupList }

function TGroupList.Add(AGroup: IGroup): IGroupList;
begin
  if Assigned(AGroup) then
    FGroups.Add(AGroup);
end;

function TGroupList.Count: Integer;
begin
  Result := FGroups.Count;
end;

constructor TGroupList.Create;
begin
  FGroups := TInterfaceList.Create;
end;

destructor TGroupList.Destroy;
begin
  if Assigned(FGroups) then
    FreeAndNil(FGroups);
  inherited;
end;

function TGroupList.GetItem(AIndex: Integer): IGroup;
begin
  Result := FGroups.Items[AIndex] as IGroup;
end;

class function TGroupList.New: IGroupList;
begin
  Result := TGroupList.Create;
end;

function TGroupList.Remove(AGroup: IGroup): IGroupList;
begin
  if Assigned(AGroup) then
    FGroups.Remove(AGroup);
end;

{ TGroup }

constructor TGroup.Create(APair: IPair);
begin
  FPairList := TPairList.Create;
  FPairList.Add(APair);
end;

destructor TGroup.Destroy;
begin
  inherited;
end;

function TGroup.HasAny(APair: IPair): Boolean;
var
  i: Integer;
begin
  for i := 0 to FPairList.Count -1 do
  begin
    Result := ((APair.GetFirstElement = FPairList.GetItem(i).GetFirstElement) or 
                (APair.GetFirstElement = FPairList.GetItem(i).GetSecondElement)) or
              ((APair.GetSecondElement = FPairList.GetItem(i).GetFirstElement) or
                (APair.GetSecondElement = FPairList.GetItem(i).GetSecondElement));
    if Result then
      Break;
  end;
end;

function TGroup.HasPair(APair: IPair): Boolean;
var
  i: Integer;
  hasFirstElement, hasSecondElement: Boolean;
begin
  for i := 0 to FPairList.Count -1 do
  begin
    Result := ((APair.GetFirstElement = FPairList.GetItem(i).GetFirstElement) or 
                (APair.GetFirstElement = FPairList.GetItem(i).GetSecondElement)) or
              ((APair.GetSecondElement = FPairList.GetItem(i).GetFirstElement) or
                (APair.GetSecondElement = FPairList.GetItem(i).GetSecondElement));

    if not hasFirstElement then
      hasFirstElement := ((APair.GetFirstElement = FPairList.GetItem(i).GetFirstElement) or
                          (APair.GetFirstElement = FPairList.GetItem(i).GetSecondElement)); 

    if not hasSecondElement then
      hasSecondElement := ((APair.GetSecondElement = FPairList.GetItem(i).GetFirstElement) or
                           (APair.GetSecondElement = FPairList.GetItem(i).GetSecondElement));

    if (hasFirstElement and hasSecondElement) then
      Break;
  end;
  Result := (hasFirstElement and hasSecondElement);
end;

class function TGroup.New(APair: IPair): IGroup;
begin
  Result := TGroup.Create(APair);
end;

function TGroup.Pairs: IPairList;
begin
  Result := FPairList;
end;

{ TPairList }

function TPairList.Add(APair: IPair): IPairList;
begin
  if Assigned(APair) then
    FPairs.Add(APair);
end;

function TPairList.Count: Integer;
begin
  Result := FPairs.Count;
end;

constructor TPairList.Create;
begin
  FPairs := TInterfaceList.Create;
end;

destructor TPairList.Destroy;
begin
  if Assigned(FPairs) then
    FreeAndNil(FPairs);
  inherited;
end;

function TPairList.GetItem(AIndex: Integer): IPair;
begin
  Result := FPairs.Items[AIndex] as IPair;
end;

class function TPairList.New: IPairList;
begin
  Result := TPairList.Create;
end;

{ TPair }

constructor TPair.Create(AFirstElement, ASecondElement: Integer);
begin
  FFirstElement   := AFirstElement;
  FSecondElement  := ASecondElement;
end;

destructor TPair.Destroy;
begin

  inherited;
end;

function TPair.GetFirstElement: Integer;
begin
  Result := FFirstElement;
end;

function TPair.GetSecondElement: Integer;
begin
  Result := FSecondElement;
end;

class function TPair.New(AFirstElement, ASecondElement: Integer): IPair;
begin
  Result := TPair.Create(AFirstElement, ASecondElement);
end;

{ TCheckGroup }

function TGroupCreator.CheckPair(APair: IPair): Boolean;
var
  i, j: Integer;
  oGroup, oSavedGroup: IGroup;
  oPair: IPair;

  procedure NewGroup;
  begin
    oGroup := TGroup.New(APair);
    FGroupList.Add(oGroup);
  end;
  
begin
  { Caso não tenha nem um grupo formado apenas adiciona um novo grupo com o par }
  if FGroupList.Count = 0 then
  begin
    NewGroup;
    Exit;
  end;

  { Loop  para percorrer a lista de grupos de pares }
  while (i <= FGroupList.Count-1) do
  begin
    oGroup := FGroupList.GetItem(i);
    { Verifica se encontra dentro do grupo o par }
    if (oGroup.HasAny(APair)) then
    begin
      { Se já tem um grupo salvo move os pares do grupo atual para o grupo salvo
        com isso mantém a lista de grupos sempre atualizada }
      if Assigned(oSavedGroup) then
      begin
        MovingPairs(oGroup, oSavedGroup);
        FGroupList.Remove(oGroup);
        Continue;
      end;

      { Adiciona o par dentro do grupo encontrado e salva o grupo para caso encontrar
        outro com pares iguais }
      oGroup.Pairs.Add(APair);
      oSavedGroup := oGroup;
    end
    { Adiciona o par a um novo grupo apenas se chegar no ultimo registro
      e não encontrou um grupo para alocar ele }
    else if (i = FGroupList.Count-1 ) and (not Assigned(oSavedGroup)) then
    begin
      NewGroup;
      Break;
    end;

    Inc(i);
  end;
end;

constructor TGroupCreator.Create(AGroupList: IGroupList);
begin
  FGroupList := AGroupList;
end;

destructor TGroupCreator.Destroy;
begin
  inherited;
end;

procedure TGroupCreator.MovingPairs(AGroup, ASavedGroup: IGroup);
var
  i: Integer;
begin
  for i := 0 to AGroup.Pairs.Count -1 do
    ASavedGroup.Pairs.Add(AGroup.Pairs.GetItem(i));
end;

class function TGroupCreator.New(AGroupList: IGroupList): IGroupCreator;
begin
  Result := TGroupCreator.Create(AGroupList);
end;

{ TVerifier }

constructor TVerifier.Create(AMaxElements, AFirstElement, ASecondElement: Integer);
begin
  FMaxElements    := AMaxElements;
  FFirstElement   := AFirstElement;
  FSecondElement  := ASecondElement;
end;

destructor TVerifier.Destroy;
begin
  inherited;
end;

class function TVerifier.New(AMaxElements, AFirstElement, ASecondElement: Integer): IVerifier;
begin
  Result := TVerifier.Create(AMaxElements, AFirstElement, ASecondElement);
end;

procedure TVerifier.Verify;
begin
  if (FFirstElement <= 0) then
    raise Exception.Create('First element parameter must be positive');
  if (FSecondElement <= 0) then
    raise Exception.Create('Second element parameter must be positive');
  if (FFirstElement > FMaxElements) then
    raise Exception.Create('First element must be below or equal ' + IntToStr(FMaxElements));
  if (FSecondElement > FMaxElements) then
    raise Exception.Create('Second element must be below or equal ' + IntToStr(FMaxElements));
  if (FFirstElement = FSecondElement) then
    raise Exception.Create('The parameters cannot have the same value');
end;

end.
