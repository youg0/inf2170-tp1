   ;BR main

 SIZE:		.EQUATE 8
 GAUCHE:	.EQUATE 0
 MOT:  		.EQUATE 2
 OCC:  		.EQUATE 4
 DROITE:	.EQUATE 6

 T_MAX: 	.EQUATE 128
  
 RACINE:	.EQUATE 0
 TMP:   	.EQUATE 2
 nb:		.EQUATE 4
 ;car:   	.EQUATE 0
 
 main: 	NOP0
   	STRO  	msgInv,d ;
   	LDX  	0,i
   	LDA  	texte,i
   	STA  	-4,s
   	LDA  	T_MAX,i 
   	STA  	-2,s
   	SUBSP  	4,i
   	CALL  	LirChain
   	LDA  	0,s
   	STA  	nblet,d
   	ADDSP  	2,i
  
   	STRO  	msgInv,d ;
   	LDX  	0,i
   	LDA  	texte2,i
   	STA  	-4,s
   	LDA  	T_MAX,i 
   	STA  	-2,s
   	SUBSP  	4,i
   	CALL  	LirChain
   	LDA  	0,s
   	STA  	nblet,d
   	ADDSP  	2,i

   	;STRO   texte,d
  	;deco   nblet,d
   
   	;BREQ   fin
   	;BRLT   troLong

 metEnM: NOP0
	LDA 	texte,i
	STA 	-4,s
	SUBSP   4,i
	CALL    minusc
	ADDSP   2,i
	
	LDA 	texte2,i
	STA 	-4,s
	SUBSP   4,i
	CALL    minusc
	ADDSP   2,i
	

 compTxt:NOP0
   	LDA 	texte,i
   	STA 	-4,s
   	LDA 	texte2,i
   	STA 	-2,s
   	SUBSP 	4,i
   	CALL 	compare
   	LDA 	0,i
   	LDA 	0,s
   	ADDSP 	2,i
   	STA 	comp,d
   	DECO 	comp,d
   
   	STOP
  
  
 
   
    
  

 
 ;------- Lecture chaine
 ;Lit une chaine de caracteres ASCII jusqu'a ce qu'il  
 ;rencontre un caractere de fin de ligne. Deux parametres
 ;qui sont l'addresse du message sur la pile et la taille maximum.
 ;

 car:     .EQUATE 0
 regX:    .EQUATE 2
 regA:    .EQUATE 4
 retour:  .EQUATE 6
 addrBuf: .EQUATE 8          ; Addresse du message a lire
 taille:  .EQUATE 10         ; taille maximum
                             ;{
 LirChain:SUBSP   6,i        ;  espace local
          STA     regA,s     ;  sauvegarde A
          STX     regX,s     ;  sauvegarde X
          LDX     0,i        ;  indice = 0
          LDA     0,i        ;  caractere = 0
                             ;  while(true){
 EncorL:  CHARI   car,s      ;    cin >> caractere;
          LDBYTEA car,s      ;
          CPA     0xA,i      ;    if(caractere == fin de ligne) 
          BREQ    FiniL      ;      break;
   	  ;====================================================
   	  ;// AJOUT AU SOUS-PROGRAME ORIGINAL
   	  ;// POUR CORRIGER UN BUG AVEC LE MODE BATCH DE PEP8
   	  ;----------------------------------------------------
          CPA     0x0,i      ;    if(caractere == 0X00) 
          BREQ    FiniL      ;      break;
   	  ;====================================================
          STBYTEA addrBuf,sxf;    Buf[indice] = caractere; 
          ADDX    1,i        ;    indice++;
          CPX     taille,s   ;    if(indice > taille) break;
          BRLE    EncorL     ;  } 
          ;==================================================== 
          ;// AJOUT AU SOUS-PROGRAME ORIGINAL 
          ;// POUR TRAITER LES CHAINES TROP LONGUES 
          ;---------------------------------------------------- 
 VideBuff:CHARI   car,s      ; Continuer à lire les caractères exc
          LDBYTEA car,s      
          CPA     0x000A,i   
          BRNE    VideBuff  
          LDX     -1,i      ;Signaler l'erreur au reste du progra
          ;---------------------------------------------------- 
 FiniL:   STX     taille,s   ;  nombre de caracteres lus
          LDA     retour,s   ;  adresse retour
          STA     addrBuf,s  ;  deplacee
          LDA     regA,s     ;  restaure A
          LDX     regX,s     ;  restaure X
          ADDSP   8,i        ;  nettoyer pile
          RET0               ;}// LireChaine

 ;------- minusc
 ;Met les majuscules en minuscules

 indice:  .EQUATE 0
 minRegX: .EQUATE 2
 minRegA: .EQUATE 4
 minARet: .EQUATE 6
 minVOri: .EQUATE 8 
 minNARet:.EQUATE 6          ; taille maximum
                             ;{

 minusc:  SUBSP   6,i        ;  espace local
          STA     minRegA,s  ;  sauvegarde A
          STX     minRegX,s  ;  sauvegarde X
          LDX     0,i        ;  indice = 0
          LDA     0,i        ;  caractere = 0
                             ;  while(true){
 	  STX  	  indice,s
 bouLec:  LDX  	  indice,s 
   	  LDBYTEA minVOri,sxf
   	  CPA  	  0x0000,i;
   	  BREQ    finMin
   	  CPA     65,i
   	  BRLT    nMaj
   	  CPA  	  90,i
   	  BRLE    maj		
   	  CPA     192,i
   	  BRLT    nMaj
   	  CPA  	  221,i
   	  BRLE    maj
	  BR	  nMaj
 maj:	  NOP0
   	  ADDA    32,i
   	  STBYTEA minVOri,sxf
 nMaj:    NOP0
   	  ADDX    1,i
   	  STX     indice,s
   	  BR      bouLec
 finMin:  LDA     minARet,s 
   	  STA     minNARet,s
   	  LDA  	  minRegA,s
   	  LDX     minRegX,s
   	  ADDSP   minNARet,i
   	  RET0
     
 ;------- comparer
 ;

 comInd:   .EQUATE 0
 comRegX:  .EQUATE 2
 comRegA:  .EQUATE 4
 temp:     .EQUATE 6

 comARet:  .EQUATE 8

 comT1:    .EQUATE 10        ; Chaine 1
 comT2:    .EQUATE 12        ; Chaine 2
 comVRet:  .EQUATE 14        ; Adresse de retour
 comNARet: .EQUATE 8         ; taille maximum
                             ;{

 compare:  SUBSP   8,i        ;  espace local
           STA     minRegA,s  ;  sauvegarde A
           STX     minRegX,s  ;  sauvegarde X
           LDX     0,i        ;  indice = 0
           LDA     0,i        ;  caractere = 0
   	   STA     comVRet,s  ;
                             ;  while(true){
   	   STX     comInd,s
   	   ;STRO  
 comBLec:  LDBYTEA comT1,sxf
   	   CPA	   0,i
   	   BREQ    longDifA
   	   LDBYTEA comT2,sxf
   	   CPA     0,i
   	   BREQ    finAp
   	   LDX     comInd,s 
   	   LDBYTEA comT2,sxf
   	   STA     temp,s
   	   LDBYTEA comT1,sxf
   	   CPA	   temp,s
   	   BRLT    finAv
   	   BRGT    finAp
   	   ADDX    1,i
   	   STX     indice,s
   	   BR      comBLec

 finAv:    LDA 	   -1,i
   	   STA     comVRet,s
   	   BR      finCom
 finAp:    LDA     1,i
   	   STA     comVRet,s
    	   BR  	   finCom
 longDifA: LDBYTEA comT2,sxf
   	   BREQ    memeLong
   	   BRNE    finAv
 memeLong: LDA     0,i
           STA     comVRet,s
 finCom:   LDA     comARet,s 
   	   DECO    comVRet,s
           CHARO   0x000A,i
   	   STA	   comNARet,s
   	   LDA     comRegA,s
   	   LDX     comRegX,s
   	   ADDSP   comNARet,i
   	   RET0   
   
   




  
 	comp:   .WORD  0
 	nblet:  .WORD  0
 	msgInv: .ASCII  "Entrez un texte. \x00"
 	texte:  .BLOCK  255
 	tas:    .BLOCK  255
 	texte2: .BLOCK  255
 	ptrTas: .ADDRSS tas
   		.END
