   ;BR main

 TAILLE: .EQUATE 8
 GAUCHE: .EQUATE 0
 DROITE: .EQUATE 2
 ADMOT:  .EQUATE 4
 OCC:    .EQUATE 6
 

 T_MAX:  .EQUATE 128
  
 RACINE: .EQUATE 0
 TMP:    .EQUATE 2
 nb:  .EQUATE 4

 
 
 main:   NOP0
     STRO   msgInv,d ;
     LDX   0,i
     LDA   texte,i
     STA   -4,s
     LDA   T_MAX,i 
     STA   -2,s
     SUBSP  4,i
     CALL   LirChain
     LDA   0,s
     STA   nblet,d  ; Nombre de lettre de la chaîne
     ADDSP  2,i
  
 Lecture:NOP0

  LDA   ASCII,i
  STA   -12,s
  LDA   texte,i
  STA   -10,s
  LDA  ptrMot,i
  STA     -8,s
  LDA  indText,d
  STA  -6,s
  SUBSP   12,i
  CALL    lecMot
  LDA  0,s
  STA  debMot,d
  LDA  2,s
  STA  indText,d
  ADDSP  4,i
 
  LDA  racine,d
  BRNE  debIns
  LDA racine,i
  STA -4,s
  LDA 8,i
  STA -2,s
  SUBSP 4,i
  CALL  new
  LDA debMot,d
  STA racine,n
  DECO racine,d
  BR finIns
  

;  CHARO  ' ',i
;  DECO  debMot,d ; adresse debut mot
;  CHARO  ' ',i
;  DECO  ptrMot,d ; adresse fin mot
;  CHARO  ' ',i
;  DECO  indText,d ; indice pour textebl
;  CHARO  ' ',i

debIns:  NOP0
   LDA debMot,d
   STA -4,s
   LDA racine,d
   STA -2,s
   SUBSP 4,i
   CALL Inser
   ;SUBSP 8,i
  
finIns:  LDA   ptrMot,d
  SUBA  1,i
  STA  temp1,d
  LDA  0,i
  LDBYTEA temp1,n 
  CPA  0x0A,i  
  BREQ  fin
   BR  Lecture

 
 
encore: CHARO  ' ',i
 DECO  debMot,d
 CHARO  ' ',i
 DECO  ptrMot,d
 CHARO  ' ',i
 DECO  indText,d
  ;ADDX  1,i
  ;BRNE   encore

compTxt: NOP0
     LDA  texte,i
     STA  -6,s
     LDA  texte2,i
     STA  -4,s
     SUBSP  6,i
         CALL  compare
     LDA  0,s 
     ADDSP  2,i
     STA  comp,d
     DECO  comp,d
   
;premierN:NOP0
;  SUBSP 8,i
;  LDA 0,i
;  STA  
;  PREMIER,s
;  CALL new

fin:  STOP
  





;--------- Inserer

 InsRegA: .EQUATE 0
 InsRegX: .EQUATE 2
 InsTemp: .EQUATE 4
 
 InsARet: .EQUATE 6
 
 InsMot:  .EQUATE 8 ; Mot à insérer
 InsRac:  .EQUATE 10 ; Racine de l'arbre


 Inser: SUBSP 6,I
  STA InsRegA,s
  STX InsRegX,s
  LDA 0,i
  LDX 0,i

  LDA InsRac,s ; On verifie si la racine est null
  BRNE InsCmp

 InsCrN: NOP0   ; On cree un nouveau noeud
  LDA InsTemp,s
  STA -6,s
  LDA InsMot,s
  STA -4,s
  SUBSP 6,i
  CALL new
  ADDSP 2,i
  LDA InsMot,s ; Le noeud est situé à InsTemp
  STA InsTemp,sf
  BR InsFin

 InsCmp: LDA InsMot,s
  STA -6,s
  LDA InsRac,sf
  STA -4,s
  SUBSP 6,i
  CALL compare  ; On compare le mot à la racine
  LDA 0,s
  ADDSP 2,i
  BREQ InsInc
  BRGT InsGT
  BRLT InsLT

 InsInc: LDX 2,i  ; On incrémente le nb d'occurences
  LDA InsRac,sxf
  ADDA 1,i
  STA InsRac,sxf
  BR InsFin

 InsLT: LDA InsMot,s ; Si le mot est plus petit, on vérifie avec le mot
  STA -6,s  ; à la gauche de la racine
  LDX 4,i
  LDA InsRac,sxf
  STA -4,s
  SUBSP 6,i
  CALL Inser
  ADDSP 2,i
  BR InsFin
 
 InsGT: LDA InsMot,s ; Si le mot est plus grand, on vérifie avec le mot
  STA -4,s  ; à la droite de la racine
  LDX 6,i
  LDA InsRac,sxf
  STA -2,s
  SUBSP 4,i
  CALL Inser
  ADDSP 2,i
    
 InsFin: LDA InsRegA,s
  LDX InsRegX,s
  ADDSP 8,i
  RET0 


; Le sous-programme new alloue la taille demande et place l'adresse
; de la zone dans le pointeur dont l'adresse est passe en paramtre.

NvieuxX: .EQUATE 0       ; sauvegarde X
NvieuxA: .EQUATE 2       ; sauvegarde A
NadRet:  .EQUATE 4       ; adresse retour
Npoint:  .EQUATE 6       ; adresse pointeur  remplir
Ntaille: .EQUATE 8       ; taille requise
;                             ; void new(int taille, int *&pointeur) {

new:     SUBSP    4,i         ; espace local
         STA      NvieuxA,s  ; sauvegarder A
         STX      NvieuxX,s  ; sauvegarder X
         LDA      heappnt,d  ;
         STA      Npoint,sf  ; adresse retourne
         LDA      Ntaille,s  ; taille du noeud
         ADDA     1,i         ; arrondir  pair
         ANDA     0xFFFE,i    ;
         ADDA     heappnt,d  ; nouvelle valeur
         CPA      heaplmt,i  ;
         BRGT     new0        ; si pas dpass la limite du heap
         STA      heappnt,d  ; mettre  jour heappnt
         BR       new1        ; et terminer
new0:    LDA      0,i         ; sinon
         STA      Npoint,sf  ; mettre pointeur  NULL
new1:    LDA      NadRet,s    ; dplacer adresse retour
         STA      Ntaille,s  ;
  LDA   NvieuxA,s  ; restaurer A
  LDX   NvieuxX,s  ; restaurer X
  ADDSP 8,i       ; nettoyer pile
  RET0            ; return; }
   
    
  

 
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
 VideBuff:CHARI   car,s      ; Continuer  lire les caractres exc
          LDBYTEA car,s      
          CPA     0x000A,i   
          BRNE    VideBuff  
          LDX     -1,i      ;Signaler l'erreur au reste du progra
          ;---------------------------------------------------- 
 FiniL:   LDA   0x0A,i
   STBYTEA addrBuf,sxf
   STX     taille,s   ;  nombre de caracteres lus
          LDA     retour,s   ;  adresse retour
          STA     addrBuf,s  ;  deplacee
          LDA     regA,s     ;  restaure A
          LDX     regX,s     ;  restaure X
          ADDSP   8,i        ;  nettoyer pile
          RET0               ;}// LireChaine

 ;------- lectureMot
 ;

 lecCode: .EQUATE 0 ; 
 lecTemp: .EQUATE 2

 lecRegX: .EQUATE 4 ; Registre X
 lecRegA: .EQUATE 6 ; Registre A

 lecARet: .EQUATE 8

 lecConv: .EQUATE 10
 lecVOri: .EQUATE 12
 lecTamp: .EQUATE 14
 lecInd:  .EQUATE 16
 lecVRet: .EQUATE 18
 lecVRet2:.EQUATE 20
 lecNARet:.EQUATE 16     ; 

lecMot:   SUBSP   8,i        ;  espace local
          STA     lecRegA,s  ;  sauvegarde A
          STX     lecRegX,s  ;  sauvegarde X
          LDX     0,i        ;  indice = 1
          LDA     0,i        ;  caractere = 0
                             ;  while(true){

   LDA   ptrMot,d
   STA   lecVRet,s

   LDX   lecInd,s
   
   LDA     0,i  

 lecBou0: LDBYTEA lecVOri,sxf
   STA   lecCode,s
   LDX     lecCode,s 
   LDBYTEA lecConv,sxf
          CPA   0x0000,i
   BRNE    lecBou
   LDX     lecInd,s 
   ADDX    1,i
   STX     lecInd,s 
   BR   lecBou0  

 lecBou:  LDX     lecInd,s 
    LDBYTEA lecVOri,sxf
      CPA     0x0A,i ; if ( minVOri == fin de fichier){
      BREQ    lecFCha ; 
   STA   lecCode,s
   LDX     lecCode,s 
   LDBYTEA lecConv,sxf
   CPA   0x0000,i  ; 
   BREQ   lecFin

      STBYTEA ptrMot,n 
   CHARO   ptrMot,n
   ;DECO   ptrMot,d
   STA   lecTemp,s
   LDA   ptrMot,d
   ADDA   1,i
   STA   ptrMot,d
   LDA     lecTemp,s
  
 prochain:LDX     lecInd,s 
   ADDX    1,i
      STX     lecInd,s
      BR      lecBou
 lecFCha: NOP0
   LDA    0x0A,i 
   STBYTEA ptrMot,n
   BR   vraiFin
   
 lecFin:  NOP0
   LDX     lecTemp,s
   LDA   48,i
   STBYTEA ptrMot,n 
   CHARO   ptrMot,n 

vraiFin:  LDA   ptrMot,d
   ADDA   1,i
      STA   ptrMot,d

   LDX   lecInd,s
   STX   lecVRet2,s
  
    LDA     lecARet,s 
      STA     lecNARet,s
      LDA     lecRegA,s
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
       CPA    0,i
       BREQ    longDifA
       LDBYTEA comT2,sxf
       CPA     0,i
       BREQ    finAp
       LDX     comInd,s 
       LDBYTEA comT2,sxf
       STA     temp,s
       LDBYTEA comT1,sxf
       CPA    temp,s
       BRLT    finAv
       BRGT    finAp
       ADDX    1,i
       STX     lecInd,s
       BR      comBLec

 finAv:    LDA     -1,i
       STA     comVRet,s
       BR      finCom
 finAp:    LDA     1,i
       STA     comVRet,s
        BR      finCom
 longDifA: LDBYTEA comT2,sxf
       BREQ    memeLong
       BRNE    finAv
 memeLong: LDA     0,i
           STA     comVRet,s
 finCom:   LDA     comARet,s 
       ;DECO    comVRet,s
           CHARO   0x000A,i
       STA    comNARet,s
       LDA     comRegA,s
       LDX     comRegX,s
       ADDSP   comNARet,i
       RET0   
   
  
  comp:    .WORD  0
  nblet:   .WORD  0
 temp1:  .WORD  0
 temp2:  .WORD  0
 racine:  .WORD 0
  msgInv:  .ASCII  "Entrez un texte. \x00"
  texte:  .ADDRSS texteBl
 texteBl: .BLOCK  255

  tabMot:  .BLOCK  255
  ptrMot:  .ADDRSS tabMot
 debMot:  .ADDRSS tabMot

 longMot: .WORD   0
 indText: .WORD   0

  texte2:  .BLOCK  255

 heappnt: .ADDRSS heap ; initialement pointe  heap
 heap:    .BLOCK 255  ; espace heap; dpend du systme
          ;.BLOCK 255  ; espace heap; dpend du systme
   ;.BLOCK 255  ; espace heap; dpend du systme

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
      .BYTE 45   ; -
      .BYTE 0
      .BYTE 0
      .BYTE 48   ; 0
      .BYTE 49   ; 1
      .BYTE 50   ; 2
      .BYTE 51   ; 3
      .BYTE 52   ; 4
      .BYTE 53   ; 5
      .BYTE 54   ; 6
      .BYTE 55   ; 7
      .BYTE 56   ; 8
      .BYTE 57   ; 9
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
      .BYTE 224     ; 
      .BYTE 225     ; a+,
      .BYTE 226     ; 
      .BYTE 227     ; a+~
      .BYTE 228     ; 
      .BYTE 229     ; a+
      .BYTE 230     ; ae
      .BYTE 231     ; 
      .BYTE 232     ; 
      .BYTE 233     ; 
      .BYTE 234     ; 
      .BYTE 235     ; 
      .BYTE 236     ; 
      .BYTE 237     ; i+,
      .BYTE 238     ; 
      .BYTE 239     ; 
      .BYTE 0       ; 
      .BYTE 241     ; n+~
      .BYTE 242     ; 
      .BYTE 243     ; o+,
      .BYTE 244     ; 
      .BYTE 245     ; o+~
      .BYTE 246     ; 
      .BYTE 0       ;
      .BYTE 248     ; o+/
      .BYTE 249     ; 
      .BYTE 250     ; u+,
      .BYTE 251     ; 
      .BYTE 252     ; 
      .BYTE 0       ; 
      .BYTE 0     ;
      .BYTE 255     ; 
      .BYTE 224     ; 
      .BYTE 225     ; a+,
      .BYTE 226     ; 
      .BYTE 227     ; a+~
      .BYTE 228     ; 
      .BYTE 229     ; a+
      .BYTE 230     ; ae
      .BYTE 231     ; 
      .BYTE 232     ; 
      .BYTE 233     ; 
      .BYTE 234     ; 
      .BYTE 235     ; 
      .BYTE 236     ; 
      .BYTE 237     ; i+,
      .BYTE 238     ; 
      .BYTE 239     ; 
      .BYTE 0       ; 
      .BYTE 241     ; n+~
      .BYTE 242     ; 
      .BYTE 243     ; o+,
      .BYTE 244     ; 
      .BYTE 245     ; o+~
      .BYTE 246     ; 
      .BYTE 0       ;
      .BYTE 248     ; o+/
      .BYTE 249     ; 
      .BYTE 250     ; u+,
      .BYTE 251     ; 
      .BYTE 252     ; 
      .BYTE 0       ; 
      .BYTE 0     ;
      .BYTE 255     ; 

 .END
