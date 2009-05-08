   ;BR main

 TAILLE:	.EQUATE 8
 GAUCHE:	.EQUATE 0
 DROITE:	.EQUATE 2
 ADMOT:		.EQUATE 4
 OCC:  		.EQUATE 6
 

 T_MAX: 	.EQUATE 128
  
 RACINE:	.EQUATE 0
 TMP:   	.EQUATE 2
 nb:		.EQUATE 4
 
 main: 	 NOP0
   	 STRO  	msgInv,d ;
   	 LDX  	0,i
   	 LDA  	texte,i
   	 STA  	-4,s
   	 LDA  	T_MAX,i 
   	 STA  	-2,s
   	 SUBSP  4,i
   	 CALL  	LirChain
   	 LDA  	0,s
   	 STA  	nblet,d
   	 ADDSP  2,i
  
   	 STRO  	msgInv,d ;
   	 LDX  	0,i
   	 LDA  	texte2,i
   	 STA  	-4,s
   	 LDA  	T_MAX,i 
   	 STA  	-2,s
   	 SUBSP  4,i
   	 CALL  	LirChain
   	 LDA  	0,s
   	 STA  	nblet,d
   	 ADDSP  	2,i

 metEnM: NOP0
	 LDA 	ASCII,i
	 STA 	-4,s
	 LDA 	texte,i
	 STA 	-2,s
	 ;LDA 	ptrMot,i
	 ;STA 	-4,s
	 ;LDA 	0,i
	 ;STA 	-2,s
	 SUBSP   4,i
	 CALL    lecMot
	 LDA	 0,s
	 STA	 debMot,d
	 ADDSP   2,i
	 
	 STRO	debMot,d
	 LDX	 0,i	 
encore:	 LDBYTEA debMot,n
	 ADDX	 1,i
	 BRNE 	 encore

	

compTxt: NOP0
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

;premierN:NOP0
;	 SUBP	8,i
;	 LDA	0,i
;	 STA 	PREMIER,s
	 
	 
	 
;	 CALL new
	 







; Le sous-programme new alloue la taille demandée et place l'adresse
; de la zone dans le pointeur dont l'adresse est passée en paramètre.

NvieuxX: .EQUATE 0     		; sauvegarde X
NvieuxA: .EQUATE 2     		; sauvegarde A
NadRet:  .EQUATE 4      	; adresse retour
Npoint:  .EQUATE 6      	; adresse pointeur à remplir
Ntaille: .EQUATE 8     		; taille requise
;                            	; void new(int taille, int *&pointeur) {

new:     SUBSP    4,i        	; espace local
         STA      NvieuxA,s 	; sauvegarder A
         STX      NvieuxX,s 	; sauvegarder X
         LDA      heappnt,d 	;
         STA      Npoint,sf 	; adresse retournée
         LDA      Ntaille,s 	; taille du noeud
         ADDA     1,i        	; arrondir à pair
         ANDA     0xFFFE,i   	;
         ADDA     heappnt,d 	; nouvelle valeur
         CPA      heaplmt,i 	;
         BRGT     new0       	; si pas dépassé la limite du heap
         STA      heappnt,d 	; mettre à jour heappnt
         BR       new1       	; et terminer
new0:    LDA      0,i        	; sinon
         STA      Npoint,sf 	; mettre pointeur à NULL
new1:    LDA      NadRet,s   	; déplacer adresse retour
         STA      Ntaille,s 	;
	 LDA   NvieuxA,s 	; restaurer A
	 LDX   NvieuxX,s 	; restaurer X
	 ADDSP 8,i      	; nettoyer pile
	 RET0           	; return; }
   
    
  

 
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

 ;------- lectureMot
 ;

 lecInd:  .EQUATE 0
 lecCode: .EQUATE 2
 lecRegX: .EQUATE 4
 lecRegA: .EQUATE 6

 lecARet: .EQUATE 8

 lecConv: .EQUATE 10
 lecVOri: .EQUATE 12
 ;lecTamp: .EQUATE 12
 ;lecPtTam:.EQUATE 14
 ;lecAdCh: .EQUATE 16
 lecVRet: .EQUATE 14
 lecNARet:.EQUATE 12      ; taille maximum
                             ;{

lecMot:   SUBSP   8,i        ;  espace local
          STA     lecRegA,s  ;  sauvegarde A
          STX     lecRegX,s  ;  sauvegarde X
          LDX     0,i        ;  indice = 1
          LDA     0,i        ;  caractere = 0
                             ;  while(true){

	  LDA	  ptrMot,d
	  STA	  lecVRet,sf
	  ;LDX	  texte,d
	  ;LDX    texte,d	  
 	  ;STA	  lecAdCh,s
	  STX	  lecInd,s
	  LDA     0,i  

 lecBou0: LDBYTEA lecVOri,sxf
          CPA	  0x0000,i
	  BRNE    lecBou
	  ADDX    1,i
	  BR	  lecBou0  

 lecBou:  LDX  	  lecInd,s 
   	  LDBYTEA lecVOri,sxf
   	  CPA  	  0x0A,i	; if ( minVOri == fin de fichier){
   	  BREQ    lecFin	; 
	  STA	  lecCode,s
	  LDX  	  lecCode,s 
	  LDBYTEA lecConv,sxf
	  CPA	  0x0000,i		; if ( minVOri == '-'){
	  BREQ	  lecFin		; 
	  LDX	  lecInd,s
 ecrit:	  NOP0
   	  STBYTEA ptrMot,n 
 prochain:ADDX    1,i
   	  STX     lecInd,s
   	  BR      lecBou
 lecFin:  NOP0
	  
 	  LDA     lecARet,s 
   	  STA     lecNARet,s
   	  LDA  	  lecRegA,s
   	  LDX     lecRegX,s
   	  ADDSP   lecNARet,i
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
 comNARet: .EQUATE 12         ; taille maximum
                             ;{

 compare:  SUBSP   8,i        ;  espace local
           STA     lecRegA,s  ;  sauvegarde A
           STX     lecRegX,s  ;  sauvegarde X
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
   	   STX     lecInd,s
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
   
  
 	comp:    .WORD  0
 	nblet:   .WORD  0
 	msgInv:  .ASCII  "Entrez un texte. \x00"
 	texte:	 .ADDRSS texteBl
	texteBl: .BLOCK  255

 	tabMot:  .BLOCK  255
 	ptrMot:  .ADDRSS tabMot
	debMot:  .ADDRSS tabMot

	longMot: .WORD   0

 	texte2:  .BLOCK  255

	heappnt: .ADDRSS heap ; initialement pointe à heap
	heap:    .BLOCK 255  ; espace heap; dépend du systéme
       		 .BLOCK 255  ; espace heap; dépend du systéme
		 .BLOCK 255  ; espace heap; dépend du systéme

heaplmt:.BYTE    0   ;

ASCII:.BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 45	  ; -
      .BYTE 0
      .BYTE 0
      .BYTE 48	  ; 0
      .BYTE 49	  ; 1
      .BYTE 50	  ; 2
      .BYTE 51	  ; 3
      .BYTE 52	  ; 4
      .BYTE 53	  ; 5
      .BYTE 54	  ; 6
      .BYTE 55	  ; 7
      .BYTE 56	  ; 8
      .BYTE 57	  ; 9
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 97     ; A
      .BYTE 98     ; B
      .BYTE 99     ; C
      .BYTE 100    ; D
      .BYTE 101    ; E
      .BYTE 102    ; F
      .BYTE 103    ; G
      .BYTE 104    ; H
      .BYTE 105    ; I
      .BYTE 106    ; J
      .BYTE 107    ; K
      .BYTE 108    ; L
      .BYTE 109    ; M
      .BYTE 110    ; N
      .BYTE 111    ; O
      .BYTE 112    ; P
      .BYTE 113    ; Q
      .BYTE 114    ; R
      .BYTE 115    ; S
      .BYTE 116    ; T
      .BYTE 117    ; U
      .BYTE 118    ; V
      .BYTE 119    ; W
      .BYTE 120    ; X
      .BYTE 121    ; Y
      .BYTE 122    ; Z
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 97     ; a
      .BYTE 98     ; b
      .BYTE 99     ; c
      .BYTE 100    ; d
      .BYTE 101    ; e
      .BYTE 102    ; f
      .BYTE 103    ; g
      .BYTE 104    ; h
      .BYTE 105    ; i
      .BYTE 106    ; j
      .BYTE 107    ; k
      .BYTE 108    ; l
      .BYTE 109    ; m
      .BYTE 110    ; n
      .BYTE 111    ; o
      .BYTE 112    ; p
      .BYTE 113    ; q
      .BYTE 114    ; r
      .BYTE 115    ; s
      .BYTE 116    ; t
      .BYTE 117    ; u
      .BYTE 118    ; v
      .BYTE 119    ; w
      .BYTE 120    ; x
      .BYTE 121    ; y
      .BYTE 122    ; z
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 224     ; à
      .BYTE 225     ; a+,
      .BYTE 226     ; â
      .BYTE 227     ; a+~
      .BYTE 228     ; ä
      .BYTE 229     ; a+°
      .BYTE 230     ; ae
      .BYTE 231     ; ç
      .BYTE 232     ; è
      .BYTE 233     ; é
      .BYTE 234     ; ê
      .BYTE 235     ; ë
      .BYTE 236     ; ì
      .BYTE 237     ; i+,
      .BYTE 238     ; î
      .BYTE 239     ; ï
      .BYTE 0       ; 
      .BYTE 241     ; n+~
      .BYTE 242     ; ò
      .BYTE 243     ; o+,
      .BYTE 244     ; ô
      .BYTE 245     ; o+~
      .BYTE 246     ; ö
      .BYTE 0       ;
      .BYTE 248     ; o+/
      .BYTE 249     ; ù
      .BYTE 250     ; u+,
      .BYTE 251     ; û
      .BYTE 252     ; ü
      .BYTE 0       ; 
      .BYTE 0	    ;
      .BYTE 255	    ; ÿ
      .BYTE 224     ; à
      .BYTE 225     ; a+,
      .BYTE 226     ; â
      .BYTE 227     ; a+~
      .BYTE 228     ; ä
      .BYTE 229     ; a+°
      .BYTE 230     ; ae
      .BYTE 231     ; ç
      .BYTE 232     ; è
      .BYTE 233     ; é
      .BYTE 234     ; ê
      .BYTE 235     ; ë
      .BYTE 236     ; ì
      .BYTE 237     ; i+,
      .BYTE 238     ; î
      .BYTE 239     ; ï
      .BYTE 0       ; 
      .BYTE 241     ; n+~
      .BYTE 242     ; ò
      .BYTE 243     ; o+,
      .BYTE 244     ; ô
      .BYTE 245     ; o+~
      .BYTE 246     ; ö
      .BYTE 0       ;
      .BYTE 248     ; o+/
      .BYTE 249     ; ù
      .BYTE 250     ; u+,
      .BYTE 251     ; û
      .BYTE 252     ; ü
      .BYTE 0       ; 
      .BYTE 0	    ;
      .BYTE 255	    ; ÿ

	.END
