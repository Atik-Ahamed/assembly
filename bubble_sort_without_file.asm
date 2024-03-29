                                            .MODEL SMALL
.STACK 100H
.DATA  
INPUT_PROMPT DB 0AH,'ENTER HOW MANY ELEMENTS:',0AH,0DH,'$' 

NUM DB ? 


INPUT_PROMPT1 DB 0AH,'ENTER THE ELEMENTS:',0AH,0DH,'$'  
OUTPUT_PROMPT DB 0AH,'THE ELEMENTS ARE:',0AH,0DH,'$' 
OUTPUT_PROMPT1 DB 0AH,'THE SORTED ELEMENTS ARE:',0AH,0DH,'$'

CUR_NUM DW ?

 N DW ?  
 I DW ?
 J DW ? 
 TEMP1 DW ?
 TEMP2 DW ? 
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX 
    
    ;PROMPT THE USER FOR INPUT;;;;;;;;;;;
    MOV AH,9
    LEA DX,INPUT_PROMPT
    INT 21H
    ;END PROMT THE USER FOR INPUT;;;;;;;;
    
    
     XOR CX,CX
    ;MOVE NUMBER OF ELEMENTS IN CX;;;;;;;
    CALL INPUT_DEC
    MOV N,AX
    
    MOV CX,N  
    CALL END_LINE 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    
    
    XOR SI,SI;CLEAR SI    
    
    
     ;PROMPT THE USER FOR N ELEMENTS ;;;;;;;;;;;
    MOV AH,9
    LEA DX,INPUT_PROMPT1
    INT 21H
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    ;INPUT N ELEMENTS FROM THE USER
    ;AND PUTTING THEM TO NUM ARRAY;;;;;;;;
     XOR SI,SI
    INPUT_ONE_CHAR_DEC:
    
      CALL END_LINE    
      CALL INPUT_DEC 
      MOV WORD PTR NUM[SI],AX 
      INC SI
            
    LOOP INPUT_ONE_CHAR_DEC
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    
    MOV AH,9
    LEA DX,OUTPUT_PROMPT
    INT 21H
    
    XOR SI,SI
    XOR CX,CX
    MOV CX,WORD PTR N   
    
    
    OUTPUT_DEC: 
        XOR AX,AX
        MOV AL,NUM[SI]
        CALL OUTDEC
        INC SI  
        CALL END_LINE
    LOOP OUTPUT_DEC
                                 
                                 
                                 
    XOR SI,SI
    XOR CX,CX
    MOV CX,WORD PTR N 
    DEC CX  
    CALL BUBBLE_SORT    
    MOV AH,9
    LEA DX,OUTPUT_PROMPT1
    INT 21H
    XOR SI,SI  
     
    MOV CX,WORD PTR N   
     
      OUTPUT__DEC: 
        XOR AX,AX
        MOV AL,NUM[SI]
        CALL OUTDEC
        INC SI  
        CALL END_LINE
    LOOP OUTPUT__DEC

   ;EXIT:         ;exiting the code
   
   MOV AH, 4CH   ;does exit function
   INT 21H       ;exit to dos
    
MAIN ENDP 
;;;FILE CONTAINS DOS EXIT FUNCTION;;;;;;;;
;INCLUDE DOS_EXIT.asm    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   
                       

                                          
;;;;;;;;FUNCTION TO PRINT A NEW LINE;;;;;;                                          
END_LINE PROC
MOV AH,2
MOV DL,0AH
INT 21H
MOV DL,0DH
INT 21H       
RET
END_LINE ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    



;;;;;;;BUBBLE SORT;;;;;;;;;;;;;;;;;;;;;;;
BUBBLE_SORT PROC  
    
MOV BX,-1

OUTER_LOOP: 
        INC BX
        CMP BX,CX
        JGE END_FUNC_BUBBLE_SORT
        ;INC BX
        XOR SI,SI
        MOV SI,BX
        INC SI
        INNER_LOOP:    
           XOR AX,AX
           XOR DX,DX 

           MOV AL,NUM[BX]   ;NUM[I]
           MOV DL,NUM[SI]   ;NUM[J]
           CMP AL,DL
           JG EXCHANGE 
           ADDITIONAL:
           INC SI
           CMP SI,CX
           JG OUTER_LOOP
           JMP INNER_LOOP
            
    CMP BX,CX
    JNE OUTER_LOOP

EXCHANGE:
    XCHG AL,DL
    MOV NUM[BX],AL
    MOV NUM[SI],DL
    JMP ADDITIONAL        
END_FUNC_BUBBLE_SORT:        
 RET
BUBBLE_SORT ENDP   


OUTDEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    CMP AL,0
    JG VALID ; IF AX>=0
    PUSH AX
    MOV DL,'-'
    MOV AH,2
    INT 21H
    POP AX
    NEG AX
    XOR AH,AH
    VALID:
    XOR CX,CX
    MOV BX,10D ; BX IS DIVISOR
    DIVIDE:
    XOR DX,DX ; DX IS REMAINDER
    DIV BX ; DIVIDE AX BY BX, AX =QUOTIENT, DX=REMAINDER
    PUSH DX ; PUSH REMAINDER
    INC CX
    OR AX,AX ; UNTILL AX IS NOT ZERO
    JNE DIVIDE
    MOV AH,2
    PRINT:
    POP DX
    OR DL,30H ;PRINT DIGITS
    INT 21H
    LOOP PRINT
    POP DX
    POP CX
    POP BX
    POP AX
    RET
OUTDEC ENDP



INPUT_DEC  PROC
    PUSH BX
    PUSH CX
    PUSH DX
            
    BEGIN:
    
    XOR BX,BX 
    XOR CX,CX
    
    MOV AH,1
    INT 21H
    
    
    CMP AL,'-'
    JE MINUS
    
    CMP AL,'+'
    JE PLUS
    JMP REPEAT2   
    
    MINUS:
    MOV CX,1
    
    PLUS:
     INT 21H
    
    REPEAT2:
    CMP AL,'0'
    JNGE NOT_DIGIT
    CMP AL,'9'
    JNLE NOT_DIGIT
    
    
    AND AX,000FH;CONVERT CHAR TO DIGIT
    PUSH AX
    MOV AX,10
    MUL BX
    
    
    CMP DX,0
    JNE NOT_DIGIT
    
    POP BX
    ADD BX,AX
    
    JC NOT_DIGIT
    
    MOV AH,1
    INT 21H
    
    CMP AL,0DH
    JNE REPEAT2
    
    
    MOV AX,BX
    OR CX,CX 
    
    JE EXIT    
    NEG AX
    EXIT:
    POP DX
    POP CX
    POP BX
    RET
    NOT_DIGIT:
    MOV AH,2
    MOV DL,0DH
    INT 21H
    JMP BEGIN
    
    
    
    
    RET
INPUT_DEC ENDP
        

END MAIN