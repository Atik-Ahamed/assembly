.MODEL SMALL
.STACK 100H
.DATA   
STRING1 DB 'FGHIJ'
STRING2 DB 'ABCD'
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX  
    MOV ES,AX
                    
    MOV CX,5
    
    LEA SI,STRING1
    LEA DI,STRING2+4
    CLD
    
    TOP:
        MOVSB
    LOOP TOP 
    
    MOV CX,9
    LEA SI,STRING2
    
    DISP_STRING:
    MOV AH,2
    LODSB
    MOV DL,AL
    INT 21H
    
    LOOP DISP_STRING
    
    
    MOV AH,4CH
    INT 21H
    
    MAIN ENDP
END MAIN
