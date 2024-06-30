;
; Print all VGA colors in a 16 x 16 grid and put the system
;

    org 100h

main:
    mov ah,0fh              ; get current video mode
    int 10h
    push ax                 ; store current video mode on the stack

    mov ax,0013h            ; set vga
    int 10h

    mov dx,0
    mov al,0
.nextrow:
    mov cx,0
.nextblock:
    call printblock
    inc al
    add cx,10
    cmp cx,160
    jnz .nextblock
    add dx,10
    cmp dx,160
    jnz .nextrow

; wait for key press
    mov ah,00
    int 16h

; change back to text mode
    pop ax                  ; retrieve old video mode from stack
    mov ah,00               ; revert back to old video mode
    int 10h

; exit program
    mov ah,00h
    int 21h

;
; al - color value
; cx - start column
; dx - start row
;
printblock:
    mov ah,0ch              ; set print pixel interrupt routine
    mov bl,10               ; set row counter
.nextrow:
    push bx                 ; put row counter back on stack
    mov bl,10               ; set column counter
.nextpix:
    int 10h                 ; print pixel
    inc cx                  ; increment column
    dec bl                  ; decrement counter
    jnz .nextpix            ; if not zero, print next pixel
    inc dx                  ; increment row
    sub cx,10               ; restore cx
    pop bx                  ; retrieve row counter from stack
    dec bl                  ; decrement row counter
    jnz .nextrow            ; if not zero, print next pixel
    sub dx,10               ; restore dx
    ret