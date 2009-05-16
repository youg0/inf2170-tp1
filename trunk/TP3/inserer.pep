;------- Inserer

 InsInd:  .EQUATE 0
 InsRegX: .EQUATE 2  ; Registre X
 InsRegA: .EQUATE 4  ; Registre A
 InsRet:  .EQUATE 6  ;
 Insptnd: .EQUATE 8  ; pointeur noeud
 Insptmot:.EQUATE 10 ; pointeur mot
 Instemp: .EQUATE 12 ;


Inserer:	SUBSP	6,i
        	STA     InsRegA,s  ;  sauvegarde A
        	STX     InsRegX,s  ;  sauvegarde X
        	LDX     0,i        ;  indice = 0
        	LDA     Insptnd,s  ;  
  		CPA 0x0000,i   ; 
  		BREQ novnoed    ;
		Compa:  STA   -4,s       ;
     		LDA   Insptmot,s ;
        	STA   -2,s       ;
       		SUBSP   4,i        ;
        	CALL    compare    ;
    		ADDSP   2,i        ;
  		LDA 0,i        ;
  		LDA     0,s        ;
  		CPA 0,i        ;
  		BREQ incre      ;
  		BRGT droit
  		BRLT gauche
droit:  	LDX 6,i
  		BR noeud
gauche:  	LDX 4,i
noeud:  	LDA  Insptnd,sxf
  		STA -4,s
  		LDA Insptmot,s
  		STA -2,s
  		SUBSP  4,i
  		CALL Inserer

novnoed:	LDA Instemp,s
  		STA -4,s
  		LDA     8,i
  		STA  -2,s
  		SUBSP   4,i
  		CALL new  
 

  		LDA  Insptmot,s
  		STA Instemp,sf
  		LDX 2,i
  		LDA 1,i
    		STA  Instemp,sxf
  		BR final

incre:  	LDX 2,i
  		LDA Insptnd,sxf
  		ADDA 1,i
  		STA Insptnd,sxf
  		BR final

final:  	NOP0
  		LDA     InsRegA,s     ;  restaure A
        	LDX     InsRegX,s     ;  restaure X
        	ADDSP   8,i        ;  nettoyer pile
        	RET0               ;}// LireChaine

