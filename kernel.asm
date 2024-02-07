; kernel.asm
[org 0x7E00]

start:
    mov ah, 0x0E     ; Function 0x0E: Teletype output
    mov al, '!'      ; Character to print
    int 0x10         ; BIOS video interrupt
    jmp $            ; Infinite loop to hang after printing
    ; Debug: Print "Kernel Starting..." message
    mov si, msgStart
    call PrintString

    ; Print "Kernel Loaded" message
    mov si, msgKernelLoaded  ; Load the address of the message into SI
    call PrintString         ; Call the routine to print the string
    jmp main                 ; Jump to the main loop

; Data
msgStart db 'Kernel Starting...', 0
msgKernelLoaded db 'Kernel Loaded', 0

; Main loop
main:
    call ReadKey
    call PrintChar
    jmp main  ; Loop back to start to continuously read and print

; ReadKey: Waits for and reads a key press using BIOS interrupt
; Returns: AL = ASCII character of the key pressed
ReadKey:
    xor ah, ah       ; Function 0x00: Wait for a key press and read the character
    int 0x16         ; BIOS keyboard interrupt
    ret

; PrintChar: Prints the character in AL to the screen using BIOS interrupt
PrintChar:
    mov ah, 0x0E     ; Function 0x0E: Teletype output
    int 0x10         ; BIOS video interrupt
    ret

; PrintString: Prints a null-terminated string pointed to by SI
PrintString:
    lodsb            ; Load byte at SI into AL, increment SI
    or al, al        ; OR AL with itself to set the zero flag if AL is 0
    jz .done         ; If zero flag is set (AL was 0), we're done
    mov ah, 0x0E     ; Function 0x0E: Teletype output
    int 0x10         ; BIOS video interrupt
    jmp PrintString  ; Loop back to print the next character
.done:
    ret
