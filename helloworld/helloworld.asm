;
; print hello world to the screen using interrupt routines
;

    org 100h

    mov dx,hello
    mov ah,09h
    int 21h

    mov ah,00h
    int 21h

hello: db 'Hello world!$'