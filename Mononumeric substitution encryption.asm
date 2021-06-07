.DATA  
msg1 DB  'Enter Number of Chars:-->$'  
msg2 DB  'Enter Message:-->$'  
msg3 DB  10,13,'$'
msg4 DB  'Encrypted Message:--> $'
msg5 DB  'Decrypted Message-->$'
string  DB  100   DUP(?)        ;005B
table   DW  26    DUP(?)        ;00BF



.CODE
MAIN PROC                  
        MOV     AX,@DATA        
        MOV     DS,AX           ;ADDRESS FOR THE TABLE  
        MOV     CX,26
        MOV     AL,'A'
        MOV     AH,1
        LEA     BX,table        ;BX IS THE OFFSET 
        MOV     SI,0
        
J1:     MOV     [BX+SI],AH      ;STORE TABLE TO USE IT LATER
        INC     SI              ;TO GET THE WANTED VALUE
        MOV     [BX+SI],AL      ; 2*I-2
        INC     SI
        INC     AL
        INC     AH     
        DEC     CX
        JCXZ    DONE
        JMP     J1       
DONE:               
        
        LEA     DX,msg1        ;CHANGE DX TO msg1
        MOV     AH,09H        
        INT     21H
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H 
        
        
        
        MOV     AH,1           ;INPUT HOW MANY CHARS IN THE INPUT STRING           
        INT     21H  
        SUB     AL,30H   
        MOV     CX,0AH
        MUL     CX 
        MOV     CL,AL                
                        
        MOV     AH,1
        INT     21H    
        SUB     AL,30H 
        ADD     CL,AL          ;INPUT NUMBER OF CHARS IS STORED IN CL      
        
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        
        LEA     DX,msg2        ;CANGE DX TO msg2
        MOV     AH,09H        
        INT     21H
        
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        
        PUSH    CX             ;SAVE THE CX 
        LEA     BX,string      ;BX=VAR STRING ADDRESS
        MOV     SI,0000H
         
        
J2:     MOV     AH,1           ;INPUT STRING  CHAR BY CHAR STORED IN VAR STRING
        INT     21H
        MOV     [BX+SI],AL
        
        INC     SI
        DEC     CL
        JCXZ    DONE1
        JMP     J2

DONE1:  POP     CX             ;RESTORE  THE CX  

        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        LEA     DX,msg4        ;CANGE DX TO msg4
        MOV     AH,09H        
        INT     21H
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        
        PUSH    CX 
        LEA     BX,string        
        MOV     SI,0000H    
        
        CLD
          
J3:     LEA     DI,table       ;DECRYPT TH STRING USING THE TABLE  
        MOV     AL,[BX+SI]
        
L:      CMP     AL,[DI]
        JZ      GOTIT  
        INC     DI
        JMP     L
        
GOTIT:  SUB     DI,1
        MOV     DL,[DI] 
        MOV     [BX+SI],DL
        INC     SI
        DEC     CL
        JCXZ    DONE2
        JMP     J3 
        
DONE2:  POP     CX
                     
                     
        
        PUSH    CX
        MOV     SI,0    
            
J4:     MOV     AL,[BX+SI]     ;PRINT THE STRING CHAR BY CHAR 
        MOV     AH,0
        MOV     DL,10          ;ADJUST THE INT TO ASCII
        DIV     DL
        
        
        MOV     DL,AL
        ADD     DL,48          ;CONVERT THE INTS TO THEIR ASCII VALUE
        MOV     DH,AH
        
        MOV     AH,2
        INT     21H

        XCHG    DL,DH
        ADD     DL,48     
        MOV     AH,2
        INT     21H             
                   
        MOV     DL,' '
        MOV     AH,2           
        INT     21H
        INC     SI
        DEC     CX
        JCXZ    DONE3
        JMP     J4

DONE3:  POP     CX

        
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        LEA     DX,msg5        ;CANGE DX TO msg5
        MOV     AH,09H        
        INT     21H
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        
        MOV     SI,0 
        PUSH    CX        
        CLD
          
J5:     LEA     DI,table       ;DECRYPT TH STRING USING THE TABLE  
        MOV     AL,[BX+SI]
        
L1:     CMP     AL,[DI]
        JZ      GOTIT1  
        INC     DI
        JMP     L1
        
GOTIT1: ADD     DI,1
        MOV     DL,[DI] 
        MOV     [BX+SI],DL
        INC     SI
        DEC     CL
        JCXZ    DONE4
        JMP     J5 
        
DONE4:  POP     CX 
         
        
        

        MOV     SI,0
        
J6:     MOV     DL,[BX+SI]     ;PRINT THE STRING CHAR BY CHAR       
        MOV     AH,2
        INT     21H

                    
                   
        MOV     DL,' '
        MOV     AH,2           
        INT     21H
        INC     SI
        DEC     CX
        JCXZ    DONE5
        JMP     J6
DONE5:  
        
        

MAIN ENDP 
END MAIN 