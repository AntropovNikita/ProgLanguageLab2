%include "lib.inc"

global find_word, get_value

section .text

; Поиск элемента в словаре по ключу
; @param rdi Указатель на адрес строки
; @param rsi Указатель на начало словаря
; @return rax Указатель на первое вхождение или 0
find_word:
    .loop:
        cmp rsi, 0         ; Если словарь пустой, то
        je .not_found      ; элемент не найден
        
        push rsi           ; Сохранение caller-регистров перед вызовом функции
        push rdi 
        add rsi, 8         ; Сдвиг до ключа элемента
        call string_equals ; Проверка на совпадение строк
        pop rdi            ; Восстановление caller-регистров
        pop rsi
        
        cmp rax, 1         ; Если строки совпали, то
        je .is_found       ; элемент найден
        
        mov rsi, [rsi]     ; Переход к следующему элементу
        jmp .loop
        
    .is_found:             ; Элемент найден
        mov rax, rsi       ; Сохранение адреса входа в словарь
        ret
        
    .not_found:            ; Элемент не найден
        xor rax, rax       ; Возвращение 0
        ret

; Получение значения элемента словаря
; @param rdi Указатель на вхождение в словарь
; @return rax Указатель на адрес значения или 0        
get_value:
    cmp rdi, 0         ; Если адрес равен 0, то
    je .no_element     ; вернуть 0
    
    add rdi, 8         ; Сдвиг до ключа элемента
    push rdi           ; Сохранение caller-регистров перед вызовом функции
    call string_length ; Подсчет длины ключа
    pop rdi            ; Восстановление caller-регистров
    
    add rdi, rax       ; Сдвиг до значения
    mov rax, rdi
    inc rax
    ret
    
    .no_element:       ; Возврат 0
        xor rax, rax
        ret

