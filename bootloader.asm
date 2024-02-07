; bootloader.asm
[org 0x7c00]  ; Origin point, BIOS loads the bootloader here

; Set up the data segment
mov ax, 0      ; Initialize the DS register
mov ds, ax

; Debug: Print "Loading Kernel..." message
mov si, msgLoading  ; Load the address of the debug message into SI
call PrintString    ; Call the routine to print the string

; Load the kernel from disk
mov bx, 0x7E00 ; Load segment where the kernel will be stored
mov ah, 0x02   ; AH = 0x02, function number for read sectors from drive
mov al, 1      ; AL = number of sectors to read
mov ch, 0      ; CH = cylinder number
mov cl, 2      ; CL = sector number (2, since the bootloader is sector 1)
mov dh, 0      ; DH = head number
mov dl, 0      ; DL = drive number (0 = first floppy disk)
int 0x13       ; Call interrupt to read from disk

; Jump to the kernel
; Debug: Print "Jumping to Kernel..." message (before the jump)
mov si, msgJumping
call PrintString
jmp 0x7E00     ; Jump to the kernel's starting address

; Data
msgLoading db 'Loading Kernel...', 0
msgJumping db 'Jumping to Kernel...', 0

; PrintString routine (similar to the one in kernel.asm)
PrintString:
    lodsb            ; Load byte at SI into AL, increment SI
    or al, al        ; OR AL with itself to set the zero flag if AL is 0
    jz .done         ; If zero flag is set (AL was 0), we're done
    mov ah, 0x0E     ; Function 0x0E: Teletype output
    int 0x10         ; BIOS video interrupt
    jmp PrintString  ; Loop back to print the next character
.done:
    ret

times 510-($-$$) db 0  ; Pad with zeros up to 510 bytes
dw 0xAA55               ; Boot signature