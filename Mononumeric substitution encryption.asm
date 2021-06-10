.DATA    
msg2 DB  'Enter Message:-->$'  
msg3 DB  10,13,'$'
msg4 DB  'Encrypted Message:--> $'
msg5 DB  'Decrypted Message-->$'
string  DB  100,?,100   DUP(?)        ;005B
table1  DB  ' ABCDEFGHIJKLMNOPQRSTUVWXYZ'   
table2  DB  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26



.CODE
MAIN PROC  
                       
START:  
;-------------------------------------------------------------------------
        MOV     AX,@DATA        
        MOV     DS,AX           ;ADDRESS FOR THE DATA  
  
 

        
        
        LEA     DX,msg2        ;CANGE DX TO msg2
        MOV     AH,09H        
        INT     21H
        
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
                                                        
;-------------------------------------------------------------------------
         
;------------INPUT STRING  CHAR BY CHAR STORED IN VAR STRING--------------      
        
        MOV     AH,0AH
        MOV     DX,OFFSET   string
        INT     21H
        
        
        
        
        
                                  
;-------------------------------------------------------------------------     

;----------GET NUMBER OF CHARS--------------------------------------------
        MOV     CX,0
        LEA     DI,string
        ADD     DI,2     
LOO:    CMP     [DI],13        
        JZ      FINISH
        INC     CX    
        INC     DI
        JMP     LOO
FINISH:
        


        

;------------------------------------------------------------------------- 

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
        LEA     BX,table2                               
       
;-------------------------------------------------------------------------                                    
        
        
         MOV     SI,2          ;ITERATOR
          
;------------------ENCRYPT THE STRING USING THE TABLE--------------------

  
          
J2:     LEA     DI,table1         
        MOV     AL,string[SI]
            

L:      CMP     AL,[DI]
        JZ      GOTIT  
        INC     DI
        JMP     L           
GOTIT:  
        LEA     AX,table1
        SUB     DI,AX
        MOV     AX,DI
                
        XLAT
        MOV     string[SI],AL
                  
        INC     SI
        DEC     CL 
        JCXZ    DONE2
        JMP     J2  
        
DONE2:  POP     CX  



;------------------------------------------------------------------------ 


;-------------------PRINT THE CIPHER CHAR BY CHAR------------------------

        PUSH    CX
        MOV     SI,2  
            
J3:     MOV     AL,string[SI]  
        CMP     AL,0
        JZ      SKIP    
        MOV     AH,0
        MOV     DL,10          ;ADJUST THE INT TO ASCII
        DIV     DL
        
        
        MOV     DL,AL
        ADD     DL,48          ;CONVERT THE INTS TO THEIR ASCII VALUE
        MOV     DH,AH  
        
        
        CMP     DL,'0'
        JZ      SKIP1
        MOV     AH,2
        INT     21H
SKIP1:
        XCHG    DL,DH
        ADD     DL,48     
        MOV     AH,2
        INT     21H             
                   
        MOV     DL,' '
        MOV     AH,2           
        INT     21H 
SKIP:
        INC     SI
        DEC     CX
        JCXZ    DONE3
        JMP     J3

DONE3:  POP     CX
;-------------------------------------------------------------------------


    
;-------------------------------------------------------------------------                           
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        LEA     DX,msg5        ;CANGE DX TO msg5
        MOV     AH,09H        
        INT     21H
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
        
        
        MOV     SI,2 
        PUSH    CX      
        LEA     BX,table1 
;-------------------------------------------------------------------------
        
        
      
;--------------------DECRYPT THE STRING USING THE TABLE-------------------        
J4:     LEA     DI,table2         
        MOV     AL,string[SI]
        
L1:     CMP     AL,[DI]
        JZ      GOTIT1  
        INC     DI
        JMP     L1
        
GOTIT1: 
        LEA     AX,table2
        SUB     DI,AX
        MOV     AX,DI
                
        XLAT
        MOV     string[SI],AL
        
        INC     SI
        DEC     CL
        JCXZ    DONE4
        JMP     J4 
        
DONE4:  POP     CX 
;-------------------------------------------------------------------------  
       
     
        
;--------------------PRINT STRING CHAR BY CHAR----------------------------                
        MOV     SI,2
        
J5:     MOV     DL,string[SI]     ;PRINT THE STRING CHAR BY CHAR       
        MOV     AH,2
        INT     21H

        INC     SI
        DEC     CX
        JCXZ    DONE5
        JMP     J5
DONE5:       
;-------------------------------------------------------------------------                              
        
        LEA     DX,msg3        ;CHANGE DX TO msg3 WHICH IS AN EMPTY LINE
        MOV     AH,09H     
        INT     21H
                      
                     
                                                           
        JMP     START
        
        
MAIN ENDP 
END MAIN 