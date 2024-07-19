[org 0x0100]

call clearscreen
    mov ax, 25
    push ax
    mov ax, 6
    push ax
    mov ax, 0x03
    push ax
    mov ax, startingmessage
    push ax
    push word[startingmessagelength]
    call printscore
    mov ah, 0
    int 16h
    cmp al, 0
    jmp start

gameovermessage : db 'game over'
gameovermessagelength : dw 9
startingmessage : db 'press any key to continue'
startingmessagelength: dw 25
seconds: dw 0,0,0,0,0,0,0
ticks: dw 0,0,0,0,0,0,0
oldisr: dd 0 
scoremessage: db 'score : '
livesmessage: db 'misses : '
scoremessagelength: dw 8
livesmessagelength: dw 8
score: dw 0
lives: dw 0
rand: dw 0
randnum: dw 0
location: dw 0,0,0,0,0,0,0
alphas: dw 0,0,0,0,0,0,0
speed: dw 0,0,0,0,0,0,0
sir: dw 40 ; Variable for right movement


clearscreen:
    push es 
    push ax 
    push di
    mov ax, 0xb800 
    mov es, ax 
    mov di, 0 
nextloc:
    mov word [es:di], 0x0720   
    add di, 2  
    cmp di, 4000    
    jne nextloc     
    pop di 
    pop ax 
    pop es 
    ret 

printscore:

    push bp 
    mov bp, sp 
    push es 
    push ax 
    push cx 
    push si 
    push di 
    mov ax, 0xb800 
    mov es, ax 
    mov al, 80 
    mul byte [bp+10] 
    add ax, [bp+12] 
    shl ax, 1  
    mov di,ax 
    mov si, [bp+6] 
    mov cx, [bp+4] 
    mov ah, [bp+8] 
nextchar:
    mov al, [si] 
    mov [es:di], ax 
    add di, 2
    add si, 1 
    loop nextchar  
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 10

printscorenumber:

printnum: 
    push bp 
    mov bp, sp 
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ax, [bp+4] ; load number in ax 
    mov bx, 10 ; use base 10 for division 
    mov cx, 0 ; initialize count of digits 
nextdigit:
    mov dx, 0 ; zero upper half of dividend 
    div bx ; divide by 10 
    add dl, 0x30 ; convert digit into ascii value 
    push dx ; save ascii value on stack 
    inc cx ; increment count of values 
    cmp ax, 0 ; is the quotient zero 
    jnz nextdigit ; if no divide it again 
    mov di, 140 ; point di to 70th column 
    nextpos:
    pop dx ; remove a digit from the stack 
    mov dh, 0x07 ; use normal attribute 
    mov [es:di], dx ; print char on screen 
    add di, 2 ; move to next screen location 
    loop nextpos ; repeat for all digits on stack 
    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax
    pop es 
    pop bp 
    ret 2 

printlivesnumber:

printnum1: 
    push bp 
    mov bp, sp 
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ax, [bp+4] ; load number in ax 
    mov bx, 10 ; use base 10 for division 
    mov cx, 0 ; initialize count of digits 
nextdigit1:
    mov dx, 0 ; zero upper half of dividend 
    div bx ; divide by 10 
    add dl, 0x30 ; convert digit into ascii value 
    push dx ; save ascii value on stack 
    inc cx ; increment count of values 
    cmp ax, 0 ; is the quotient zero 
    jnz nextdigit1 ; if no divide it again 
    mov di, 36 ; point di to 70th column 
    nextpos1:
    pop dx ; remove a digit from the stack 
    mov dh, 0x07 ; use normal attribute 
    mov [es:di], dx ; print char on screen 
    add di, 2 ; move to next screen location 
    loop nextpos1 ; repeat for all digits on stack 
    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax
    pop es 
    pop bp 
    ret 2 



    printbox:

    push bp 
    mov bp, sp 
    push es 
    push ax 
    push si 
    push di 
    mov ax, 0xb800 
    mov es, ax 
    mov al, 80 
    mul byte [bp+6] 
    add ax, [bp+8] 
    shl ax, 1  
    mov di,ax 
    mov ah, [bp+4] 
    mov al, 0xDC 
    mov [es:di], ax
    sub di, 2
    mov word[es:di], 0x0720
    pop di 
    pop si 
    pop ax 
    pop es 
    pop bp 
    ret 6

    leftprintbox:

    push bp 
    mov bp, sp 
    push es 
    push ax 
    push si 
    push di 
    mov ax, 0xb800 
    mov es, ax 
    mov al, 80 
    mul byte [bp+6] 
    add ax, [bp+8] 
    shl ax, 1  
    mov di,ax 
    mov ah, [bp+4] 
    mov al, 0xDC 
    mov [es:di], ax
    add di, 2
    mov word[es:di], 0x0720
    pop di 
    pop si 
    pop ax 
    pop es 
    pop bp 
    ret 6

kbisr: 
    push ax 
    push es 
    in al, 0x60 ; read a char from the keyboard port 
    cmp al, 0x4B ; is the key left shift 
    jne nextcmp ; no, try next comparison 

leftshift:
    cmp word [cs: sir], 0
    je set1
condition1:
    dec word [cs: sir]
set1:
    mov ax, word [cs: sir]
    push ax
    mov di, 24
    mov ax, di
    push ax
    mov ax, 0x20
    push ax
    call leftprintbox
    jmp exit ; leave the interrupt routine 

nextcmp:
    cmp word [cs: sir], 79
    je set2
condition2:
    cmp al, 0x4D ; is the key right shift 
    jne nomatch ; no, leave the interrupt routine 

rightshift:
    inc word [cs: sir]
set2:
    mov ax, word [cs: sir]
    push ax
    mov di, 24
    mov ax, di
    push ax
    mov ax, 0x20
    push ax
    call printbox
    jmp exit
nomatch: 
    pop es 
    pop ax 
    jmp far [cs:oldisr] 

exit: 
    mov al, 0x20 
    out 0x20, al ; send EOI to PIC 
    pop es 
    pop ax 
    iret

randG:
    push bp
    mov bp, sp
    pusha
    cmp word [rand], 0
    jne next

    MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
    INT     1AH
    inc word [rand]
    mov     [randnum], dx
    jmp next1

    next:
    mov     ax, 25173          ; LCG Multiplier
    mul     word  [randnum]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [randnum], ax          ; Update seed = return value

    next1:xor dx, dx
    mov ax, [randnum]
    mov cx, [bp+4]
    inc cx
    div cx

    mov [bp+6], dx
    popa
    pop bp
    ret 2


timer:
    push ax
    mov ax,0xb800
    mov es,ax

    mov ax, 60
    push ax
    mov ax, 0
    push ax
    mov ax, 0x07
    push ax
    mov ax, scoremessage
    push ax
    push word[scoremessagelength]
    call printscore
    push word[cs:score]
    call printscorenumber
    mov ax, 10
    push ax
    mov ax, 0
    push ax
    mov ax, 0x07
    push ax
    mov ax, livesmessage
    push ax
    push word[livesmessagelength]
    call printscore
    push word[cs:lives]
    call printlivesnumber


fall1:
    inc word [cs: ticks]
    mov ax,word[cs:speed]
    cmp word [cs: ticks],  ax; 18.2 ticks per second
    jne jumpfall2
    inc word [cs: seconds] 
    mov word [cs: ticks], 0
    mov si,[cs:location]
    mov ax,[cs:alphas]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location],160
    cmp word[cs:location],3838
    jb jumpfall2
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, [cs:sir]
    shl ax, 1 
    cmp word[cs:location],  ax
    jne missing1
    inc word[score]
    mov si,[cs:location]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov [cs:location],dx
    jmp random1
jumpfall2:
    jmp fall2
    missing1:
    inc word[cs:lives]
    mov si,[cs:location]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov [cs:location],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x01
    add dx,0x41
    mov [alphas],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov [speed],dx
    jmp exitTimer
random1:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x01
    add dx,0x41
    mov [alphas],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov [speed],dx
fall2:
    inc word[cs: ticks+2]
    mov ax,word[cs:speed+2]
    cmp word[cs: ticks+2],  ax; 18.2 ticks per second
    jne jumpfall3
    inc word[cs: seconds+2] 
    mov word[cs: ticks+2], 0
    mov si,word[cs:location+2]
    mov ax,word[cs:alphas+2]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+2],160
    cmp word[cs:location+2],3838
    jb jumpfall3
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+2],  ax
    jne missing2
    inc word[score]
    mov si,word[cs:location+2]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+2],dx
    jmp random2
jumpfall3:
    jmp fall3
    missing2:
    inc word[cs:lives]
    mov si,word[cs:location+2]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+2],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x02
    add dx,0x41
    mov word[alphas+2],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+2],dx
    jmp exitTimer
l111:
    jmp exitTimer
    random2:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x02
    add dx,0x41
    mov word[alphas+2],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+2],dx
fall3:
    inc word[cs: ticks+4]
    mov ax,word[cs:speed+4]
    cmp word[cs: ticks+4],  ax; 18.2 ticks per second
    jne jumpfall4
    inc word[cs: seconds+4] 
    mov word[cs: ticks+4], 0
    mov si,word[location+4]
    mov ax,word[alphas+4]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+4],160
    cmp word[cs:location+4],3838
    jb jumpfall4
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+4],  ax
    jne missing3
    inc word[score]
    mov si,[cs:location+4]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+4],dx
    jmp random3
jumpfall4:
    jmp fall4
    missing3:
    inc word[cs:lives]
    mov si,word[cs:location+4]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+4],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x03
    add dx,0x41
    mov word[alphas+4],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+4],dx
    jmp exitTimer
    random3:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x03
    add dx,0x41
    mov word[alphas+4],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+4],dx
fall4:
    inc word[cs: ticks+6]
    mov ax,word[cs:speed +6]
    cmp word[cs: ticks+6],  ax; 18.2 ticks per second
    jne jumpfall5
    inc word[cs: seconds+6] 
    mov word[cs: ticks+6], 0
    mov si,word[cs:location+6]
    mov ax,word[cs:alphas+6]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+6],160
    cmp word[cs:location+6],3838
    jb jumpfall5
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+6],  ax
    jne missing4
    inc word[score]
    mov si,word[cs:location+6]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+6],dx
    jmp random4
jumpfall5:
    jmp fall5
    missing4:
    inc word[cs:lives]
    mov si,word[cs:location+6]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+6],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x04
    add dx,0x41
    mov word[alphas+6],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+6],dx
    jmp exitTimer
    random4:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x04
    add dx,0x41
    mov word[alphas+6],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+6],dx

fall5:
    inc word[cs: ticks+8]
    mov ax,word[cs:speed +8]
    cmp word[cs: ticks+8],  ax; 18.2 ticks per second
    jne jumpfall6
    inc word[cs: seconds+8] 
    mov word[cs: ticks+8], 0
    mov si,word[cs:location+8]
    mov ax,word[cs:alphas+8]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+8],160
    cmp word[cs:location+8],3838
    jb jumpfall6
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+8],  ax
    jne missing5
    inc word[score]
    mov si,word[cs:location+8]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+8],dx
    jmp random5
jumpfall6:
    jmp fall6
    missing5:
    inc word[cs:lives]
    mov si,word[cs:location+8]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+8],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x05
    add dx,0x41
    mov word[alphas+8],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+8],dx
    jmp exitTimer
    random5:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x05
    add dx,0x41
    mov word[alphas+8],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+8],dx

fall6:
    inc word[cs: ticks+10]
    mov ax,word[cs:speed +10]
    cmp word[cs: ticks+10],  ax; 18.2 ticks per second
    jne jumpfall7
    inc word[cs: seconds+10] 
    mov word[cs: ticks+10], 0
    mov si,word[cs:location+10]
    mov ax,word[cs:alphas+10]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+10],160
    cmp word[cs:location+10],3838
    jb jumpfall7
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+10],  ax
    jne missing6
    inc word[score]
    mov si,word[cs:location+10]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+10],dx
    jmp random6
jumpfall7:
    jmp fall7
    missing6:
    inc word[cs:lives]
    mov si,word[cs:location+10]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+10],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x06
    add dx,0x41
    mov word[alphas+10],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+10],dx
    jmp exitTimer
    random6:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x05
    add dx,0x41
    mov word[alphas+10],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+10],dx

fall7:
    inc word [cs: ticks+12]
    mov ax,word[cs:speed +12]
    cmp word [cs: ticks+12],  ax; 18.2 ticks per second
    jne exit1
    inc word [cs: seconds+12] 
    mov word [cs: ticks+12], 0
    mov si,word[cs:location+12]
    mov ax,word[cs:alphas+12]
    mov word[es:si],ax
    sub si,160
    mov word[es:si],0x0720
    add word[cs:location+12],160
    cmp word[cs:location+12],3838
    jb exit1
    mov ax,0
    mov al, 80 
    mov bl, 24
    mul byte bl
    add ax, word[cs:sir]
    shl ax, 1 
    cmp word[cs:location+12],  ax
    jne missing7
    inc word[score]
    mov si,word[cs:location+12]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+12],dx
    jmp random7
exit1:
    jmp exitTimer
    missing7:
    inc word[cs:lives]
    mov si,word[cs:location+12]
    sub si, 160
    mov word[es:si],0x0720
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[cs:location+12],dx
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x07
    add dx,0x41
    mov word[alphas+12],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+12],dx
    jmp exitTimer
    random7:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x05
    add dx,0x41
    mov word[alphas+12],dx
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+12],dx

exitTimer:
    mov al, 0x20 ; send EOI
    out 0x20, al
    pop ax
    iret


start:

    call clearscreen
    main:
    mov ax, 40
    push ax
    mov ax, 24
    push ax
    mov ax, 0x20
    push ax
    call printbox
    mov si,0

getlocation:
    sub sp, 2
    push 79
    call randG
    pop dx
    shl dx,1
    add dx, 480
    mov word[location+si],dx
    add si,2
    cmp si,14
    jnz getlocation

mov di,0
getspeed:
    sub sp,2
    push 20
    call randG
    pop dx
    mov word[speed+di],dx
    add di,2
    cmp di,14
    jnz getspeed

getLetter1:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x01
    add dx,0x41
    mov word[alphas],dx

getLetter2:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x02
    add dx,0x41
    mov word[alphas+2],dx

getLetter3:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x03
    add dx,0x41
    mov word[alphas+4],dx

getLetter4:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x04
    add dx,0x41
    mov word[alphas+6],dx

getLetter5:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x05
    add dx,0x41
    mov word[alphas+8],dx

getLetter6:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x06
    add dx,0x41
    mov word[alphas+10],dx

getLetter7:
    sub sp, 2
    push 25
    call randG
    pop dx
    mov dh,0x07
    add dx,0x41
    mov word[alphas+10],dx

    mov cx, 0
    mov si, 40

    
    xor ax, ax 
    mov es, ax ; point es to IVT base 
    mov ax, [es:9*4] 
    mov [oldisr], ax ; save offset of old routine 
    mov ax, [es:9*4+2] 
    mov [oldisr+2], ax ; save segment of old routine 

    cli
    mov word [es:9*4], kbisr ; store offset at n*4 
    mov [es:9*4+2], cs ; store segment at n*4+2 
    sti

    
    cli

    xor ax, ax 
    mov es, ax ; point es to IVT base 
    mov word [es:8*4], timer; store offset at n*4 
    mov [es:8*4+2], cs ; store segment at n*4+2 
    sti ; enable interrupts 
    loops:
    cmp word[cs:lives], 10
    jne loops
    push word[cs:lives]
    call printlivesnumber

    call clearscreen
    mov ax, 25
    push ax
    mov ax, 6
    push ax
    mov ax, 0x03
    push ax
    mov ax, gameovermessage
    push ax
    push word[gameovermessagelength]
    call printscore
    mov ax, 60
    push ax
    mov ax, 0
    push ax
    mov ax, 0x07
    push ax
    mov ax, scoremessage
    push ax
    push word[scoremessagelength]
    call printscore
    push word[cs:score]
    call printscorenumber
    mov ax, 10
    push ax
    mov ax, 0
    push ax
    mov ax, 0x07
    push ax
    mov ax, livesmessage
    push ax
    push word[livesmessagelength]
    call printscore
    push word[cs:lives]
    call printlivesnumber


    
    ; Properly restore the original ISR before terminating
    cli
    mov ax, [oldisr] ; read old offset in ax 
    mov bx, [oldisr+2] ; read old segment in bx 
    mov es, ax ; point es to IVT base 
    mov word [es:9*4], ax ; restore old offset from ax 
    mov word [es:9*4+2], bx ; restore old segment from bx 
    sti

    ; Disable the timer interrupt
    xor ax, ax 
    mov es, ax ; point es to IVT base 
    mov word [es:8*4], 0 ; clear offset at n*4 


    mov ax, 0x3100 ; terminate and remove from memory 
    int 0x21