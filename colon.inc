%define next_item 0                      ; Указатель на список

%macro colon 2
    %ifid %2                             ; Если второй аргумент - метка
        %%next: dq next_item             ; Инициализировать указатель на следующий элемент
    %else                                ; Иначе
        %fatal "invalid label"           ; Ошибка - неверная метка
    %endif
    
    %ifstr %1                            ; Если первый аргумент - строка
        db %1, 0                         ; Выделить место под ключ
        %2:                              ; и значение
    %else                                ; Иначе
        %fatal "key type must be string" ; Ошибка - неверный тип ключа
    %endif
    
%define next_item %%next                 ; Обновить указатель на список
%endmacro
