program LIFO;
uses
  Crt;

type
  TElement = record      // Запись для элемента с двумя полями
    name: string[20];   // Имя 
    age: integer;      // Возраст
  end;
  
  List = ^TList;         // Указатель на элемент стека
  TList = record        // Элемент стека
    data: TElement;    // Данные элемента (имя и возраст)
    next: List;       // Указатель на следующий элемент
  end;

var
  Stack: List = nil;          // Вершина стека. nil = пустой указатель (стек пуст)
  Sel: Integer = 1;          // Номер текущего выбранного пункта меню
  TotalItems: Integer = 0;  // Счетчик элементов в стеке
  Temp: List;              // Временный указатель для операций с памятью 
  
  { Процедура отображения главного меню программы }
procedure DisplayMenu(sel: Integer);
begin
  ClrScr;
  
  Writeln('ДЕМОНСТРАЦИЯ РАБОТЫ СТЕКА (LIFO)');
  Writeln('Элементы содержат два поля: имя и возраст');
  Writeln;
  Writeln('Используйте стрелки ВВЕРХ/ВНИЗ для навигации');
  Writeln('Нажмите ENTER для выбора пункта');
  Writeln('----------------------------------------');

  if sel = 1 then write('-> ') else write('   ');
  writeln('1. Добавить элемент в стек');
  
  if sel = 2 then write('-> ') else write('   ');
  writeln('2. Удалить элемент из стека');
  
  if sel = 3 then write('-> ') else write('   ');
  writeln('3. Показать вершину стека ');
  
  if sel = 4 then write('-> ') else write('   ');
  writeln('4. Очистить стек');
  
  if sel = 5 then write('-> ') else write('   ');
  writeln('5. Выход');

  Writeln('----------------------------------------');
  Writeln('Всего элементов в стеке: ', TotalItems);
  Writeln('----------------------------------------');
  Writeln;
end;

procedure DisplayStack;
var
  Current: List;         // Текущий обрабатываемый элемент 
  Position: Integer;    // Позиция элемента в стеке
begin
  
  if Stack = nil then // Проверка на пустой стек
  begin
    Writeln('   [ СТЕК ПУСТ ]');
    Exit; 
  end;
  
  { Начало обхода стека с вершины }
  Current := Stack;
  Position := 1;
  
  Writeln('   Вершина стека');
  Writeln('   ------------------------------------');
  
  { Цикл обхода всех элементов стека }
  while Current <> nil do // Пока не дошли до конца (nil)
  begin
    if Position = 1 then // Помечаем вершину
      Write('   -> ')
    else
      Write('      ');
      
    Writeln('Элемент ', Position, ': Имя="', Current^.data.name, 
            '", Возраст=', Current^.data.age); // ^.data означает: "возьми значение по адресу Current"
    
    { Переход к следующему элементу }
    Current := Current^.next;
    Inc(Position);
  end;
  Writeln('   ------------------------------------');
end;

{ Процедура добавления одного элемента в стек }
procedure PushElement;
var
  NewElement: List;    // Указатель на новый элемент 
begin
  ClrScr;
  Writeln('ДОБАВЛЕНИЕ ЭЛЕМЕНТА В СТЕК');
  Writeln; 
  Writeln('Текущее состояние стека:');
  DisplayStack;
  Writeln;
  Writeln('Введите данные нового элемента:');
  Writeln;
  New(NewElement); // Создание нового элемента 
  
  { Ввод данных }
  Write('Введите имя (до 20 символов): ');
  Readln(NewElement^.data.name);
  
  Write('Введите возраст: ');
  Readln(NewElement^.data.age);
  
  { Проверка корректности возраста }
  if NewElement^.data.age < 0 then
  begin
    Writeln('Ошибка: возраст не может быть отрицательным!');
    Dispose(NewElement);
    Writeln('Нажмите любую клавишу для продолжения...');
    ReadKey;
    Exit;
  end;
  
    { Добавление элемента в стек }
  NewElement^.next := Stack;  // Новый элемент указывает на текущую вершину
  Stack := NewElement;        // Новый элемент становится вершиной стека
  Inc(TotalItems);           // Увеличиваем счетчик элементов
  
  Writeln;
  Writeln('Элемент успешно добавлен в стек!');
  Writeln('Добавлено: Имя="', NewElement^.data.name, 
          '", Возраст=', NewElement^.data.age);
  Writeln;
  Writeln('Нажмите любую клавишу для продолжения :)');
  ReadKey;
end;

{ Процедура удаления одного элемента из стека }
procedure PopElement;
var
  TempElement: List;  // Временный указатель для удаляемого элемента
begin
  ClrScr;
  Writeln('УДАЛЕНИЕ ЭЛЕМЕНТА ИЗ СТЕКА');
  Writeln;
  
  { Проверка на пустой стек }
  if Stack = nil then
  begin
    Writeln('Стек пуст! Нечего удалять.');
    Writeln('Нажмите любую клавишу для продолжения :)');
    ReadKey;
    Exit;
  end;

  Writeln('Текущее состояние стека:');
  DisplayStack;
  Writeln;
  
  { Сохранение информации об удаляемом элементе }
  Writeln('Удаляемый элемент (вершина стека):');
  Writeln('  Имя: "', Stack^.data.name, '"');
  Writeln('  Возраст: ', Stack^.data.age);
  Writeln;
  
   { Удаление элемента }
  TempElement := Stack;          // Сохраняем указатель на удаляемый элемент
  Stack := Stack^.next;         // Перемещаем вершину стека на следующий элемент
  Dispose(TempElement);         // Освобождаем память
  Dec(TotalItems);             // Уменьшаем счетчик элементов
  
  Writeln('Элемент успешно удален из стека!');
  Writeln;
  Writeln('Нажмите любую клавишу для продолжения :)');
  ReadKey;
end;

{ Процедура просмотра вершины стека без удаления }
procedure PeekElement;
begin
  ClrScr;
  Writeln('ПРОСМОТР ВЕРШИНЫ СТЕКА');
  Writeln;
  
  if Stack = nil then
  begin
    Writeln('Стек пуст!');
  end
  else
  begin
    Writeln('Текущее состояние стека:');
    DisplayStack;
    Writeln;
    Writeln('Вершина стека:');
    Writeln('  Имя: "', Stack^.data.name, '"');
    Writeln('  Возраст: ', Stack^.data.age);
  end;
  
  Writeln;
  Writeln('Нажмите любую клавишу для продолжения :)');
  ReadKey;
end;

{ Процедура очистки всего стека }
procedure ClearStack;
var
  TempElement: List;  // Временный указатель
  Count: Integer;     // Счетчик удаленных элементов
begin
  ClrScr;
  Writeln('ОЧИСТКА СТЕКА');
  Writeln;
  
  if Stack = nil then
  begin
    Writeln('Стек уже пуст!');
  end
  else
  begin
    Count := 0;
    Writeln('Удаляемые элементы:');
    Writeln('-----------------------------------');
    
    { Удаление всех элементов }
    while Stack <> nil do
    begin
      Writeln(Count + 1, '. Имя: "', Stack^.data.name, 
              '", Возраст: ', Stack^.data.age);
      
      TempElement := Stack;
      Stack := Stack^.next;
      Dispose(TempElement);
      Inc(Count);
    end;
    
    TotalItems := 0;
    Writeln('-----------------------------------');
    Writeln;
    Writeln('Удалено элементов: ', Count);
    Writeln('Стек полностью очищен!');
  end;
  
  Writeln;
  Writeln('Нажмите любую клавишу для продолжения :)');
  ReadKey;
end;

{ Основная программа }
var
  Ch: Char;
begin
  { Главный цикл программы }
  repeat
    DisplayMenu(Sel);
    Ch := ReadKey;
    
    { Обработка нажатой клавиши }
    case Ch of
      #38: begin   // стрелка вверх
        if Sel > 1 then
          Sel := Sel - 1;
      end;

      #40: begin // стрелка вниз
        if Sel < 5 then
          Sel := Sel + 1;
      end; 
      
      #13: begin  // клавиша Enter
        case Sel of
          1: PushElement;      // Добавление одного элемента
          2: PopElement;       // Удаление одного элемента
          3: PeekElement;      // Просмотр вершины
          4: ClearStack;       // Очистка стека
          5: begin            // Выход
               ClrScr;
               Writeln('Выход из программы');
               
               { Очистка всей памяти перед выходом }
               while Stack <> nil do
               begin
                 Temp := Stack;
                 Stack := Stack^.next;
                 Dispose(Temp);
               end;
               
               Writeln('Память освобождена.');
               Writeln('Нажмите любую клавишу для завершения :)');
               ReadKey;
               Break;
             end;
        end;  
      end;  
    end;   
  until false;
end.