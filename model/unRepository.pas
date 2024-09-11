unit unRepository;

interface

uses
    unMedCart, System.Generics.Collections, System.JSON, System.Classes,
    System.SyncObjs, System.IOUtils, System.SysUtils, System.Math, unGlobalConst;

type
    TActionSimpleEvent = (actAdd, actUpd, actDel);
    
    TNotifyEventSimple = reference to procedure(aSuccess: Boolean; aMessage: string; aMedCart: TMedCart;
    aAction: TActionSimpleEvent);
    TNotifyEventList = reference to procedure(aSuccess: Boolean; aMessage: string; aListMedCart: TList<TMedCart>);

    TFilterSearch = record
      Surname: string;
      FirstName: string;
      Patronymic: string;

      function Contains(aMedCart: TMedCart): Boolean;
    end;

    TRepositoryAbstract = class
      private
        FNotifyEventSimple: TNotifyEventSimple;
        FNotifyEventList: TNotifyEventList;
      public
        property NotifyEventSimple: TNotifyEventSimple read FNotifyEventSimple write FNotifyEventSimple;
        property NotifyEventList: TNotifyEventList read FNotifyEventList write FNotifyEventList;

        //CRUD
        procedure AddMedCart(aMedCart: TMedCart); virtual; abstract;
        procedure Load(aFilter: TFilterSearch); overload; virtual; abstract;
        procedure Load; overload;
        procedure UpdateMedCart(aMedCart: TMedCart); virtual; abstract;
        procedure DeleteMedCart(aMedCart: TMedCart); virtual; abstract;
    end;

    TWorkerThread = class(TThread)
      private
        //Для доступа к списку выполняемых процедур из другого потока
        FEvent: TEvent;
        //Для потокобезопастности списка процедур
        FCriticalSection: TCriticalSection;
        FListProcedure: TList<TThreadProcedure>;
      protected
        procedure Execute; override;
      public
        constructor Create; reintroduce;
        destructor Destroy; override;

        procedure AddProcedure(aProc: TThreadProcedure);
        procedure Stop;
    end;

    TRepositoryJSON = class(TRepositoryAbstract)
      private
        FWorkerThread: TWorkerThread;
        FFilterSearch: TFilterSearch;
        FJSONArrayCarts: TJSONArray;
        FListMedCarts: TList<TMedCart>;
        //Последний id мед.карты
        FLastIdMedCart: Integer;
        procedure LoadInternal;
        procedure SendResultList(aSuccess: Boolean; aMessage: string; 
          aListMedCart: TList<TMedCart>);
        procedure SendResultSimple(aSuccess: Boolean; aMessage: string; 
          aMedCart: TMedCart; aAction: TActionSimpleEvent);
        /// <summary>
        /// Сохранение в файл
        /// </summary>
        procedure SaveToFile;
      public
        constructor Create;
        destructor Destroy; override;
        
        //CRUD
        procedure AddMedCart(aMedCart: TMedCart); override;
        procedure Load(aFilter: TFilterSearch); override;
        procedure UpdateMedCart(aMedCart: TMedCart); override;
        procedure DeleteMedCart(aMedCart: TMedCart); override;
    end;

  const
    EMPTY_FILTER: TFilterSearch = (
      Surname: '';
      FirstName: '';
      Patronymic: ''
    );

implementation

const
  FILE_REPO_JSON = 'repo.json';

{ TRepositoryJSON }

procedure TRepositoryJSON.AddMedCart(aMedCart: TMedCart);
begin

  FWorkerThread.AddProcedure(
    procedure
    begin
      try
        Sleep(GLOBAL_DELAY);

        Inc(FLastIdMedCart);

        aMedCart.SetId(FLastIdMedCart);

        FListMedCarts.Add(aMedCart);

        SaveToFile;

        SendResultSimple(True, '', aMedCart, actAdd);
      except
        on E: Exception do begin
          SendResultSimple(False, E.Message, nil, actAdd);
        end;
      end;
    end
  );

end;

constructor TRepositoryJSON.Create;
begin
  FWorkerThread := TWorkerThread.Create();
  FListMedCarts := TList<TMedCart>.Create;
end;

procedure TRepositoryJSON.DeleteMedCart(aMedCart: TMedCart);
begin
  FWorkerThread.AddProcedure(
    procedure 
      var
      medCart: TMedCart;
    begin
      try
        Sleep(GLOBAL_DELAY);
        for medCart in FListMedCarts do begin 
          if medCart.Id = aMedCart.Id then begin
            FListMedCarts.Remove(medCart);
            Break;
          end;
        end;

        SaveToFile;

        SendResultSimple(True, '', aMedCart, actDel);
      except
        on E: Exception do begin
          SendResultSimple(False, E.Message, nil, actDel);
        end;
      end;
    end
  );
end;

destructor TRepositoryJSON.Destroy;
begin
  FWorkerThread.Stop;
  { TODO -oAndrey -c : позаботиться об освобождении памяти 11.09.2024 11:13:07 }
  FListMedCarts.Free;
  inherited;
end;

procedure TRepositoryJSON.Load(aFilter: TFilterSearch);
begin
  FFilterSearch := aFilter;
  FWorkerThread.AddProcedure(LoadInternal);
end;

procedure TRepositoryJSON.LoadInternal;
var
  strFull: string;
  jsonObj: TJSONObject;
  i: Integer;
  medCart: TMedCart;
begin
  TThread.Sleep(GLOBAL_DELAY);

  { TODO -oAndrey -c : позаботиться об освобождении памяти 11.09.2024 11:13:07 }
  FListMedCarts.Clear;
  FLastIdMedCart := 0;

  try
    //Создаём, если не существует
    if not TFile.Exists(FILE_REPO_JSON) then begin
      TFile.WriteAllText(FILE_REPO_JSON, TJSONArray.Create.Format());
    end;
    strFull := TFile.ReadAllText(FILE_REPO_JSON);

    FJSONArrayCarts := TJSONObject.ParseJSONValue(strFull) as TJSONArray;

    for i := 0 to FJSONArrayCarts.Count - 1 do begin
      medCart := TMedCart.Create;

      jsonObj := FJSONArrayCarts.Items[i] as TJSONObject;
                         
      FLastIdMedCart := Max(FLastIdMedCart, TJSONNumber(jsonObj.Get(FIELD_ID).JsonValue).AsInt);

      medCart
      .SetId(FLastIdMedCart)
      .SetSurname(jsonObj.Get(FIELD_SURNAME).JsonValue.Value)
      .SetFirstName(jsonObj.Get(FIELD_FIRSTNAME).JsonValue.Value)
      .SetPatronymic(jsonObj.Get(FIELD_PATRONYMIC).JsonValue.Value)
      .SetBirthday(StrToDate(jsonObj.Get(FIELD_BIRTHDAY).JsonValue.Value))
      .SetGender(TGender(TJSONNumber(jsonObj.Get(FIELD_GENDER).JsonValue).AsInt))
      .SetPhone(jsonObj.Get(FIELD_PHONE).JsonValue.Value)
      .SetPlaceWork(jsonObj.get(FIELD_PLACEWORK).JsonValue.Value);

      if FFilterSearch.Contains(medCart) then
        FListMedCarts.Add(medCart)
      else
        medCart.Free;
    end;

    SendResultList(True, '', FListMedCarts);
  except
    on E: Exception do begin
      SendResultList(False, E.Message, nil);
    end;
  end;
end;


procedure TRepositoryJSON.SaveToFile;
var
  jsonArray: TJSONArray;
  jsonObj: TJSONObject;
  i: Integer;
  fullStr: string;
begin
  jsonArray := TJSONArray.Create;

  for i := 0 to FListMedCarts.Count - 1 do begin
    jsonObj := FListMedCarts[i].ToJSON;
    jsonArray.Add(jsonObj);
  end;

  fullStr := jsonArray.Format();

  TFile.WriteAllText(FILE_REPO_JSON, fullStr, TEncoding.UTF8);

  jsonArray.Free;
end;

procedure TRepositoryJSON.SendResultList(aSuccess: Boolean; aMessage: string;
  aListMedCart: TList<TMedCart>);
begin
  if Assigned(FNotifyEventList) then
    FWorkerThread.Synchronize(procedure
      begin
        FNotifyEventList(aSuccess, aMessage, aListMedCart);
      end
    );
end;

procedure TRepositoryJSON.SendResultSimple(aSuccess: Boolean; aMessage: string;
  aMedCart: TMedCart; aAction: TActionSimpleEvent);
begin
  if Assigned(FNotifyEventSimple) then
    FWorkerThread.Synchronize(procedure
    begin
      FNotifyEventSimple(aSuccess, aMessage, aMedCart, aAction);
    end);
end;

procedure TRepositoryJSON.UpdateMedCart(aMedCart: TMedCart);
begin
  FWorkerThread.AddProcedure(procedure
    var
      medCart: TMedCart;
    begin
      try
        Sleep(GLOBAL_DELAY);
        for medCart in FListMedCarts do begin
          if medCart.Id = aMedCart.Id then begin
            medCart.Copy(aMedCart);
            Break;
          end;
        end;
        SaveToFile;

        SendResultSimple(True, '', aMedCart, actUpd);
      except
        on E: Exception do begin
          SendResultSimple(False, E.Message, nil, actUpd);
        end;
      end;
    end
  );
end;

{ TWorkerThread }

procedure TWorkerThread.AddProcedure(aProc: TThreadProcedure);
begin
  try
    FCriticalSection.Enter;
    FListProcedure.Add(aProc);
  finally
    FCriticalSection.Leave;
  end;
  FEvent.SetEvent;
end;

constructor TWorkerThread.Create;
begin
  FEvent := TEvent.Create(nil, True, False, '', False);
  FCriticalSection := TCriticalSection.Create;
  FListProcedure := TList<TThreadProcedure>.Create;
  inherited Create;
end;

destructor TWorkerThread.Destroy;
begin
  FEvent.Free;
  FCriticalSection.Free;
  FListProcedure.Free;

  inherited;
end;

procedure TWorkerThread.Execute;
var
  proc: TThreadProcedure;
  notEmpty: Boolean;
begin
  notEmpty := False;
  while not Terminated do begin
    if notEmpty or (FEvent.WaitFor() = wrSignaled) then begin
      try
        FCriticalSection.Enter;
        if FListProcedure.Count > 0 then begin
          proc := FListProcedure.Items[0];
          FListProcedure.Delete(0);
        end
            else begin
              proc := nil;
            end;
        notEmpty := FListProcedure.Count > 0;
        FEvent.ResetEvent;
      finally
        FCriticalSection.Leave;
        if Assigned(proc) then
          proc();
      end;
    end;
  end;
end;

procedure TWorkerThread.Stop;
begin
  Terminate;
  FEvent.SetEvent;
  WaitFor;
end;

{ TRepositoryAbstract }

procedure TRepositoryAbstract.Load;
begin
  Load(EMPTY_FILTER);
end;

{ TFilterSearch }

function TFilterSearch.Contains(aMedCart: TMedCart): Boolean;
begin
  Result := True;

  if not FirstName.IsEmpty then
    Result := aMedCart.FirstName.ToUpper.Contains(FirstName.ToUpper);
  if not Result then
    Exit;

  if not Surname.IsEmpty then
    Result := aMedCart.Surname.ToUpper.Contains(Surname.ToUpper);
  if not Result then
    Exit;

  if not Patronymic.IsEmpty then
    Result := aMedCart.Patronymic.ToUpper.Contains(Patronymic.ToUpper);
end;

end.
