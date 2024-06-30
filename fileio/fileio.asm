;
; Open a file and output its contents to the terminal
;
; Interrupt routines overview: https://stanislavs.org/helppc/idx_interrupt.html
;

    org 100h

    ; open file using handle (file handle stored in ax)
    ; (see: https://stanislavs.org/helppc/int_21-3d.html)
    mov ah,3dh                  ; interrupt 21,3d
    mov al,00h                  ; read only
    lea dx,filename             ; filename
    int 21h                     ; call interrupt
    jc error                    ; stop on error (when CF set)
    mov [filehandle],ax         ; store filehandle

    ; read data from file
    ; (see: https://stanislavs.org/helppc/int_21-3f.html)
    mov ah,3fh
    mov bx,[filehandle]         ; load file handle
    mov cx,128                  ; set (maximum) number of bytes
    lea dx,buffer               ; set pointer to read buffer
    int 21h                     ; run it
    jc error                    ; stop on error
    mov [bytesread],ax          ; store number of bytes read
    mov cx,ax
    mov dx,bytesreadstring      ; set pointer to string
    mov ah,09h                  ; print error string to screen
    int 21h                     ; run it
    mov ax, cx
    call printhex               ; print number of bytes read (stored in AX)
    call newline                ; print newline
    
    ; print filehandle position to screen
    mov dx,filehandlerstring    ; set pointer to string
    mov ah,09h                  ; print error string to screen
    int 21h                     ; run it
    mov al,[filehandle]
    call printhex
    mov al,[filehandle+1]
    mov dl,' '
    mov ah,02h
    int 21h
    call printhex
    call newline

    ; write terminating character
    mov ax,[bytesread]          ; load number of bytes read
    add ax,buffer               ; increment AX with memory address of buffer
    mov si,ax                   ; put address in source index register
    mov al,'$'                  ; put terminating character in AL register
    mov [si],al                 ; write '$' to memory

    ; close file
    ; (see: https://stanislavs.org/helppc/int_21-3e.html)
    mov bx,[filehandle]
    mov ah,3eh
    int 21h
    jc error

    ; output character to STDOUT
    lea dx,buffer
    mov ah,09h
    int 21h

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

;
; input al: byte to print
;
printhex:
    mov dh,al
    mov dl,'0'
    mov ah,02h
    int 21h
    mov dl,'x'
    int 21h
    mov dl,dh
    sar dl,4
    and dl,0fh
    call printnibble
    mov dl,dh
    and dl,0fh
    call printnibble
    ret

printnibble:
    cmp dl,0x0A
    jc .printzero
    add dl,'A'-10
    jmp .print
.printzero:
    add dl,'0'
.print:
    mov ah,02h
    int 21h
    ret

; print newline
newline:
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    int 21h
    ret

;-------------------- SECTION DATA --------------------------------------------- 
section .data 

bytesreadstring:
   db "Number of bytes read: $"

filehandlerstring:
    db "File handler value: $"

errorstring:
    db "An error was encountered.$"

filename: 
    db 'TEST.TXT',0

;-------------------- SECTION BSS ----------------------------------------------
section .bss       

; number of bytes read
bytesread:
    resb 2

; two-byte filehandle
filehandle:
    resb 2

; 256 byte buffer
buffer:
    resb 256