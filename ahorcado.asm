; AUTHOR: VLADIMIRO GASTON D'ACHARY?
; FECHA:    24/7/2014

; ----------------------------------------------------
; MAIN CODE
; ----------------------------------------------------

name "el_ahorcado ver. i8086"
;Brahian
org 100h
IM:mov dx, offset MSG_OCULTA
   call mostrarmsg
   mov dx, offset MSG_ADIVINE
   call mostrarmsg
   call ingresar
   call crearoculta
   mov dx, offset ADIVINO

;Carlos
CM:cmp vidas, 0
   je FMP
   call comparar
   cmp cx, 0
   je FMG
   add FILA, 2
   call setcursor
   call mostrarmsg
   call ingresarletra
   call buscar
   cmp cx, 0
   je PM            
   call reemplazar
   cmp cx, 1
   je PM
   jmp CM

;Pablo           
PM:mov columna, 11
   call setcursor
   call mostrarchar
   mov columna, 0
   call setcursor
   call quitarvida
   jmp CM          

FMG:add FILA, 2
    call setcursor
    call mostrarmsg  
    add FILA, 2
    call setcursor  
    mov dx, offset MSG_GANO
    call mostrarmsg
    jmp FM          

FMP:add FILA, 2
    call setcursor
    mov dx, offset MSG_PERDIO
    call mostrarmsg
    mov dx, offset SECRETA
    call mostrarmsg

FM: ret

; ----------------------------------------------------
; VARIABLES // CONSTANTES
; ----------------------------------------------------

;Brahian
MAX_LARGO equ 14
SECRETA db MAX_LARGO+1 dup ('$')
ADIVINO db MAX_LARGO+1 dup ('$')
MSG_PERDIO db "Lo siento, la palabra era $"
MSG_GANO db "Felicitaciones!$"
MSG_OCULTA db "Ingrese una palabra y presione Enter.", 13, 10, "$"
MSG_ADIVINE db "Adivine la palabra oculta!", 13, 10, "$"
CRLF db 13, 10, "$"
VIDAS db 5
AUX db ? ; el largo de la palabra ingresada
CHAR db ?
FILA db 0
COLUMNA db 0

; ----------------------------------------------------
; SUBRUTINAS
; ----------------------------------------------------

;Carlos
ingresar proc near
II: push cx
    push di
    mov cl, MAX_LARGO
    mov di, offset SECRETA
    mov ch, 0 ; el contador esta en cero
IC: mov ah, 07h
    int 21h
    cmp cl, ch ; si esta al limite
    je FI
    cmp al, 13
    je FI
    mov [di], al
    inc di
    inc ch  ; conto una letra
    jmp IC
FI: inc di
    mov [di], '$'
    mov aux, ch
    pop di
    pop cx
    ret
ingresar endp                  

;PABLOOOOOOO
crearoculta proc near
ICR:push di
    push cx    
    mov ch, 0
    mov cl, AUX
    mov di, offset ADIVINO
CC: cmp cx, 0
    je FC
    mov [di],'*'
    dec cx
    inc di
    jmp CC              
FC: inc di
    mov [di], '$'
    pop cx
    pop di
    ret
crearoculta endp


;BRAHIAN
ingresarletra proc near
INI:push ax
    mov ah, 07h
    int 21h  
INF:mov CHAR, al
    pop ax
ingresarletra endp

;CARLOS                     
comparar proc near
ICMP:push ax
     push di
     push si              
     mov cx, 0 ; <-- en principio ambas cadenas son iguales x_x
     mov di, offset SECRETA
     mov si, offset ADIVINO
CCMP:mov ah, [di]
     mov al, [si]        
     cmp ah, '$'
     je FCMP                                  
     cmp ah, al
     je CSIG
     jmp CPRO
CSIG:inc di
     inc si
     jmp CCMP
CPRO:mov cx, 1
FCMP:pop si
     pop di
     pop ax
     ret
comparar endp                              

;PABLO                                           
reemplazar proc near
IR: push si
    push di
    push ax
    mov cx, 0
    mov si, offset ADIVINO
    mov di, offset SECRETA
    mov al, CHAR      
CR: cmp [di], '$'
    je FR
    cmp [di], al
    je CPR
    inc di
    inc si
    jmp CR
CPR:cmp [si], '*'
    je RMP
    mov cx, 1
    jmp FR            
RMP:mov [si], al
    inc si
    inc di
    jmp CR            
FR: pop ax
    pop di
    pop si
    ret
reemplazar endp

;BRAHIAN
buscar proc near
IB:push di
    push ax    
    mov cx, 0 ; en principio no esta el caracter ingresado
    mov di, offset SECRETA; una direccion de memoria a recorrer
    mov al, CHAR
CB: cmp [di], '$'
    je FB
    cmp [di], al
    je PB
    inc di
    jmp CB            
PB: mov cx, 1      
FB: pop ax
    pop di
    ret
buscar endp

;CARLOS
quitarvida proc near
IQV:sub VIDAS, 1
    ret
quitarvida endp


;PABLO
mostrarmsg proc near
IMS:push ax
    mov ah, 09h
    int 21h
FMS:pop ax
    ret
mostrarmsg endp

;BRAHIAN                   
mostrarchar proc near
    push ax
    push dx
    mov dl, CHAR    
    mov ah, 02h
    int 21h
    pop dx
    pop ax
    ret
mostrarchar endp                  

;CARLOS              
setcursor proc near
    push dx
    push bx
    push ax
    mov dh, FILA    ; fila
    mov dl, COLUMNA ; columna
    mov bh, 0       ; nro pagina
    mov ah, 02h
    int 10h
    pop ax
    pop bx
    pop dx
    ret