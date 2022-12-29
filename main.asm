%include "lib.inc"
%include "words.inc"

%define BUFFER_SIZE 256
%define BUFFER_SIZE_STR "256"

%define stderr 2
%define write_call 1
 
extern find_word, get_value

global _start

section .rodata
input_err: db "Invalid input. Input string length must be less than ", BUFFER_SIZE_STR, `\n`, 0
key_err: db "Invalid key. No such key", `\n`, 0
    
section .text

; Принимает указатель на нуль-терминированную строку, выводит её в stderr
; @param rdi Указатель на адрес начала буфера
print_string_stderr:
    push rdi           ; Сохранение caller-регистров
    call string_length ; Подсчет длины строки
    pop rdi            ; Восстановление caller-регистров
   
    mov rsi, rdi       ; Вывод строки в stderr
    mov rdx, rax
    mov rax, write_call
    mov rdi, stderr
    syscall
    
    ret

_start:
    sub rsp, BUFFER_SIZE         ; Выделение места для буфера в стеке
    
    mov rdi, rsp                 ; Вызов функции чтения ключа из stdin
    mov rsi, BUFFER_SIZE
    call read_word
    
    cmp rdx, 0                   ; Если длина ввода больше буфера, то
    je .print_input_error       ; вывести сообщение об ошибке ввода
    
    mov rsi, next_item           ; Вызов функции поиска по ключу
    mov rdi, rax
    call find_word
    
    cmp rax, 0                   ; Если адрес вхождения не найден, то
    je .print_key_error          ; вывести сообщение об ошибке поиска ключа
    
    mov rdi, rax                 ; Получение значения элемента
    call get_value
    
    mov rdi, rax                 ; Вывод значения по ключу
    call print_string
    call print_newline
    
    add rsp, BUFFER_SIZE         ; Очищение стека
    xor rdi, rdi                 ; Установка статуса корректной работы и выход
    call exit
    
    .print_key_error:            ; Ошибка - не найден ключ
        mov rdi, key_err         ; Вывод сообщения об ошибке в stderr
        call print_string_stderr
        mov rdi, 1               ; Установка статуса ошибки и выход
        call exit
    
    .print_input_error:          ; Ошибка - неверный ввод данных
        mov rdi, input_err       ; Вывод сообщения в stderr
        call print_string_stderr
        mov rdi, 1               ; Установка статуса ошибки и выход
        call exit
