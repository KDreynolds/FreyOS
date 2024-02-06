; bootloader.asm
[org 0x7c00]  ; Origin point, BIOS loads the bootloader here

; Set up the data segment
mov ax, 0      ; Initialize the DS register
mov ds, ax

; Print "Hello World" to the screen
mov si, helloString ; Load the address of the string into SI
call PrintString    ; Call the print string routine

jmp $ ; Infinite loop to prevent the CPU from doing anything else

; Subroutine to print a string pointed to by SI
PrintString:
    mov ah, 0x0E ; BIOS teletype output function
    .repeat:
        lodsb ; Load byte at SI into AL, and increment SI
        cmp al, 0 ; Check if the byte is 0 (end of string)
        je .done ; If it is, we're done
        int 0x10 ; Otherwise, print the character in AL
        jmp .repeat
    .done:
        ret

helloString db 'Hello World', 0 ; Define the string to print

times 510-($-$$) db 0 ; Pad the bootloader to 510 bytes
dw 0xAA55 ; Boot signature at the end