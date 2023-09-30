org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A


start:
    jmp main


;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; sauvegarde les registres qu'on va utiliser en les mettant sur la pile
    push si
    push ax
    push bx

.loop:
    lodsb               ; charge le caractère dans al
    or al, al           ; verifie si le next caractère est null
    jz .done

    mov ah, 0x0E        ; appelle le bios interrupt
    mov bh, 0           ; met le page number a 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si    
    ret
    

main:
    ; setup les segments de donnée
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup la pile
    mov ss, ax
    mov sp, 0x7C00      ; la pile grand vers le bas en partant d'ou on la chargé en mémoire

    ; on print le message hello world
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt



msg_hello: db 'Hello world!', ENDL, 0


times 510-($-$$) db 0
dw 0AA55h