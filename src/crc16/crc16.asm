
;-------------------------------------------------------------------------------
; Perform CRC16 checksum on test data
;-------------------------------------------------------------------------------
CPU 8086    ; specifically compile for 8086 architecture (compatible with 8088)
;-------------------------------------------------------------------------------

    org 100h

    mov bx,0x1234
    call printhex
    call newline

    mov si,hello
    mov dx,32
    call crc16
    call printhex
    call newline

    mov ah,00h
    int 21h

;-------------------------------------------------------------------------------
; generate CRC16 checksum
; INPUT:  SI - pointer to data
;         DX - number of bytes
; OUTPUT: BX - CRC16 checksum
;-------------------------------------------------------------------------------
crc16:
    mov bx,0        ; start with a 0 checksum
    mov al,0
.crcloop:
    mov ah,[si]     ; load character from memory
    xor bx,ax       ; xor into top byte
    inc si
    mov cx,8        ; number of bits to shift
.bitloop:
    shl bx,1
    jc .crc_poly    ; if highest bit is set, xor with polynomial
    loop .bitloop
    jmp .nextbyte
.crc_poly:
    xor bx,0x1021   ; xor with the XMODEM polynomial
    loop .bitloop
.nextbyte:
    dec dx
    jnz .crcloop
    ret

;-------------------------------------------------------------------------------
; print number in BX to screen in hexadecimal notation
;-------------------------------------------------------------------------------
printhex:
    mov dl,bh
    mov cl,4
    ror dl,cl
    call print_nibble
    mov dl,bh
    call print_nibble
    mov dl,bl
    ror dl,cl
    call print_nibble
    mov dl,bl
    call print_nibble
    ret

print_nibble:
    and dl,0Fh
    add dl,'0'
    cmp dl,'9'
    jbe print_digit
    add dl,7
print_digit:
    mov ah,2
    int 21h
    ret

;-------------------------------------------------------------------------------
; print newline
;-------------------------------------------------------------------------------
newline:
    mov dx,nl
    mov ah,9
    int 21h
    ret

;-------------------- SECTION DATA --------------------------------------------- 
section .data 

hello: db '2BpVLhw7KJFlaY70tyDXx5iR33UX8xUs'

nl: db `\n\r$`

;-------------------- SECTION BSS ----------------------------------------------
section .bss