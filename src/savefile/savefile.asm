;
; Open a file and output its contents to the terminal
;
; Interrupt routines overview: https://stanislavs.org/helppc/idx_interrupt.html
;
;-------------------------------------------------------------------------------
CPU 8086    ; specifically compile for 8086 architecture (compatible with 8088)
;-------------------------------------------------------------------------------
    org 100h

    ; create the new file
    mov ah,3ch
    mov cx,0
    mov dx,filename
    int 21h
    jc error
    mov [filehandle],ax         ; store filehandle

    ; write data to file handle
    ; (see: https://stanislavs.org/helppc/int_21-40.html)
    mov ah,40h
    mov bx,[filehandle]
    mov cx,27
    mov dx,texttowrite
    int 21h
    jc error

    ; close file
    ; (see: https://stanislavs.org/helppc/int_21-3e.html)
    mov bx,[filehandle]
    mov ah,3eh
    int 21h
    jc error

    ; terminate program
    mov ah,00h
    int 21h

; print error and terminate program
error:
    mov dx,errorstring          ; set pointer to error string
    mov ah,09h                  ; print error string to screen
    int 21h                     ; run it
    
    mov ah,00h                  ; terminate program
    int 21h                     ; run it

;-------------------- SECTION DATA --------------------------------------------- 
section .data 

errorstring:
    db "An error was encountered.$"

texttowrite: 
    db 'Eager beavers with leavers!'

filename:
    db "TEST.TXT",0

;-------------------- SECTION BSS ----------------------------------------------
section .bss       

; two-byte filehandle
filehandle:
    resb 2