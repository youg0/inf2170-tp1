


 MOT:    .EQUATE 0
 NB_OCC: .EQUATE 2
 GAUCHE: .EQUATE 4
 DROITE: .EQUATE 6
 TAILLE: .EQUATE 8

 T_MAX:  .EQUATE 20000
  
 RACINE: .EQUATE 0
 TMP:    .EQUATE 2
 nb:     .EQUATE 4

 ENDL:   .EQUATE 0X0A 		; Carractere fin de fichier
 CAR_FIN:.EQUATE 0X0B		; Carractere fin de fichier artificiellement ajouté par lecMot.
  
 main: 	 NOP0
         STRO    msgInv,d  	; cout "Entrez chaine:"

       	 LDA     ASCII,i  	; Appel de la méthode lecMot pour fabriquer la racine.
 	 STA     -6,s  		;
 	 LDA     ptrMot,i 	;
 	 STA     -4,s  		;
 	 SUBSP   6,i  		;
 	 CALL    lecMot  	;
 	 LDA     0,s  		;
 	 STA     debMot,d 	; Enregistrement de l'adresse du début du mot lu.
	 ADDSP   2,i		;

   	 LDA     ptrMot,d 	;
     	 SUBA    1,i  		; 
       	 STA     temp1,d  	; Enregistrement de la position de ptrMot,d -1
       	 LDA     0,i  		;

       	 LDBYTEA temp1,n  	; Compare "ptrMot,d - 1" et 0X0B 
  	 CPA  	 0X0B,i		; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
 	 BREQ    Fin		; break 
   	 
 	 LDA   	 racine,i  		; Insersion du noeud racine avec GAUCHE et DROITE à nul.
 	 STA   	-8,s  		;
 	 LDA   	debMot,d 	;
 	 STA  	-6,s  		;
 	 LDA   	ptrMot,i 	;
 	 STA   	-4,s  		;
 	 LDA   	heappnt,d 	;
 	 STA   	-2,s  		;
 	 SUBSP   8,i  		;
 	 CALL   Inserer	;

Lecture:NOP0 			; Boucle principale
   	LDA     ASCII,i  	;
     	STA     -6,s  		;
     	LDA    	ptrMot,i 	;
     	STA     -4,s  		;
     	SUBSP   6,i  		; 
 	CALL    lecMot  	; Appel de "Lecture Mot"
 	LDA    	0,s  		;
	ADDSP	2,i		;
 	STA    	debMot,d 	;

 	LDA     ptrMot,d 	;
 	SUBA    1,i  		; 
 	STA     temp1,d  	;
 	LDA     0,i  		;
 	LDBYTEA temp1,n  	;
 	CPA     0x0A,i	   	; 
 	BREQ    Inseref  	; Fin de ligne cas 1: 
 	CPA     0x0B,i		; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
	BREQ  	Affiche		; Fin de ligne cas 2:
Insere: LDA   	racine,d  	;
 	STA   	-8,s  		;
 	LDA   	debMot,d 	;
 	STA  	-6,s  		;
 	LDA   	ptrMot,i 	;
 	STA   	-4,s  		;
 	LDA   	heappnt,d 	;
 	STA   	-2,s  		;
 	SUBSP   8,i  		;
 	CALL   	Inserer  	;
 	BR   	Lecture  	;

Inseref:LDA   	racine,d  	; 
 	STA   	-8,s  		;
 	LDA   	debMot,d 	;
 	STA   	-6,s  		;
 	LDA  	ptrMot,i 	;
 	STA  	-4,s  		;
 	LDA  	heappnt,d 	;
 	STA  	-2,s  		;
 	SUBSP  	8,i  		;
 	CALL  	Inserer  	;

Affiche:LDA  	racine,d  	;
 	STA  	-2,s  		;
 	SUBSP  	2,i  		;
 	CALL  	Afficher 	;

Fin:    CHARO	0x0A,i		; Saut de ligne
	STRO 	msgFin,d	;
	STOP     		;

;---------New ( Noeud )

; Le sous-programme new alloue la taille demande et place l'adresse
; de la zone dans le pointeur dont l'adresse est passe en paramtre.

NvieuxX: .EQUATE 0       	; sauvegarde X
NvieuxA: .EQUATE 2       	; sauvegarde A
NadRet:  .EQUATE 4       	; adresse retour
Npoint:  .EQUATE 6       	; adresse pointeur  remplir
Ntaille: .EQUATE 8       	; taille requise
                            	; void new(int taille, int *&pointeur) {

new: 	SUBSP   4,i         	; espace local
 	STA     NvieuxA,s   	; sauvegarder A
 	STX     NvieuxX,s   	; sauvegarder X
 	LDA     heappnt,d   	;
 	STA     Npoint,sf   	; adresse retourne
 	LDA     Ntaille,s   	; taille du noeud
 	ADDA    1,i          	; arrondir  pair
 	ANDA    0xFFFE,i     	;
 	ADDA    heappnt,d  	; nouvelle valeur
 	CPA     heaplmt,i   	;
 	BRGT    new0         	; si pas dpass la limite du heap
 	STA     heappnt,d   	; mettre  jour heappnt
 	BR      new1         	; et terminer

new0: 	LDA     0,i          	; sinon
 	STA     Npoint,sf   	; mettre pointeur  NULL

new1: 	LDA     NadRet,s     	; dplacer adresse retour
 	STA     Ntaille,s   	;
 	LDA     NvieuxA,s   	; restaurer A
 	LDX     NvieuxX,s   	; restaurer X
 	ADDSP   8,i        	; nettoyer pile
 	RET0            	; return; }
   
 

;------- lectureMot
 ; Voici les trois opprations de ce sous programme:
 ;
 ; 1) Lire chaque mot d'une chaine,
 ; 2) les convertir les carateres alphabetique en minuscules et transformer des caractères invalides 
 ;    selon la table ASCII modifiee mise en parametre. 
 ; 3) Placer le mot lu dans le tampon ptrMot et retourner son adresse.
 ;
 ; @param table de conversion		 => ASCII
 ; @param adresse tu tampon pour les mot => ptrMot
 ; @return adresse du mon insere	 => debMot

 
lecCode: .EQUATE 0    		; Variable temporaire
lecRegX: .EQUATE 2    		; Registre X
lecRegA: .EQUATE 4    		; Registre A

lecARet: .EQUATE 6   		; Adresse de retour

lecConv: .EQUATE 8   		; tableau de conversion
lecPtr:  .EQUATE 10   		; Adresse du tampon de mots
lecVRet: .EQUATE 12   		; Valeur de retour ( Adresse du mot )
lecNARet:.EQUATE 10   		; Nouvelle valeur de retour

lecMot:  SUBSP 	 lecARet,i   	; espace local
  	 STA  	 lecRegA,s  	; sauvegarde A
 	 STX  	 lecRegX,s  	; sauvegarde X
  	 LDX  	 0,i   		; 
  	 LDA  	 0,i   		; 

  	 LDA  	 ptrMot,d 	; 
  	 STA  	 lecVRet,s 	; Met l'adresse actuelle du tampon dans la valeur deretour.
  	 LDA  	 0,i  		;

lecBou0: CHARI   lecCode,s  	; cin >> caractere;
	 LDA 	 0,i		;
  	 LDBYTEA lecCode,s  	; 
  	 STA  	 lecCode,s  	;
  	 LDX  	 lecCode,s  	; prend le code du caratere
  	 LDBYTEA lecConv,sxf	; transpose le code dans le table de conversion
	 CPA	 0X0A,i		; compare avec le caractere fin de ligne.
	 BREQ	 lecFinB	; 	
	 CPA	 1,i		; compare avec 1 apres conversion : caracter associe a 0000 
	 BREQ	 lecFinB	;	 
	 CPA	 0,i		;
	 BRNE	 lecEcri	; le caractere n'est pas nul: break
	 BR	 lecBou0	; tant que lecaratere lu est null apres converstion
	 
lecBou:  CHARI   lecCode,s   	; 
	 LDA 	 0,i		;
  	 LDBYTEA lecCode,s   	;
	 CPA 	 0X0A,i		;
      	 BREQ    lecFinA 	;
  	 STA  	 lecCode,s  	;
  	 LDX  	 lecCode,s  	;
  	 LDBYTEA lecConv,sxf;

lecEcri: STBYTEA ptrMot,n 	;
	 BREQ	 lecFin		;
	 CPA	 1,i		;
	 BREQ	 lecFinA	;	
	 LDA  	 ptrMot,d 	;
	 ADDA  	 1,i  		;
  	 STA  	 ptrMot,d 	;
	 BR   	 lecBou  	; tant que le caratere lu n'est pas nul et n'est pas egal a 0x0A.

lecFinB: LDA	 0x0B,i		;  
	 STBYTEA ptrMot,n 	;
	 BR 	 lecFin 	;

lecFinA: NOP0			;
	 LDA	 0,i		;
	 STBYTEA ptrMot,n 	;
	 LDA  	 ptrMot,d 	;
	 ADDA  	 1,i  		;
  	 STA  	 ptrMot,d 	;
	 LDA	 0x0A,i 	;
	 STBYTEA ptrMot,n 	;

lecFin:  LDA  	 ptrMot,d 	;
         ADDA  	 1,i  		;
  	 STA  	 ptrMot,d 	;

	 LDA     ptrMot,d 	;
  	 STA  	 ptrMot,d 	;
 	 LDA  	 lecARet,s 	;
  	 STA  	 lecNARet,s 	;
  	 LDA  	 lecRegA,s 	;
  	 LDX  	 lecRegX,s 	;
  	 ADDSP   lecNARet,i 	;
  	 RET0			;
     


 ;------- comparer
 ; Ce sous-programme compare deux mots de facon lexicographique
 ; et renvoit 1 si l premier mot est plus grand, -1  'il est plus
 ; petit et 0 si les deux mot sont egaux.

 ;@param   adresse du premier mot
 ;@param   adresse du deuxieme mot
 ;@return  int 0 si =, -1 si <, 1 sir >


 comInd:   .EQUATE 0		; Indice
 comCar:   .EQUATE 2		; Caractere ( temporaire )
 comRegX:  .EQUATE 4		; Registe X
 comRegA:  .EQUATE 6		; Registre A 

 comARet:  .EQUATE 8		; variable temporaire

 comT1:    .EQUATE 10           ; mot 1
 comT2:    .EQUATE 12           ; mot 2
 comVRet:  .EQUATE 14           ; Adresse de retour
 comNARet: .EQUATE 12           ; taille maximum
                             

 compare:  SUBSP   8,i  		;  espace local
 	   STA     comRegX,s   		;  sauvegarde A
	   STX     comRegA,s   		;  sauvegarde X
 	   LDX     0,i         		;  
 	   LDA     0,i         		;  
 	   STA     comVRet,s   		;
 	   STX     comInd,s  		;
 
 comBLec:  LDBYTEA comT1,sxf 		; lecture d'un caratere de comT1
 	   CPA     0,i  		;
 	   BREQ    longDifA 		;
 	   LDBYTEA comT2,sxf 		;
 	   CPA     0,i  		;
           BREQ    finAp  		;

           LDX     comInd,s  		;
           LDBYTEA comT2,sxf 		;
           STA     comCar,s  		; 
           LDBYTEA comT1,sxf 		;
           CPA     comCar,s  		;
           BRLT    finAv  		;
           BRGT    finAp  		;
           ADDX    1,i  		;
           STX     comInd,s 		;
           BR      comBLec  		;

 finAv:    LDA     -1,i  		;
           STA     comVRet,s 		;
           BR      finCom  		;

 finAp:    LDA     1,i  		;
           STA     comVRet,s 		;
           BR      finCom  		;

 longDifA: LDBYTEA comT2,sxf 		;
           BREQ    memeLong 		;
           BRNE    finAv  		;

 memeLong: LDA     0,i  		;
           STA     comVRet,s 		;

 finCom:   LDA     comARet,s  		;
           STA     comNARet,s 		;
           LDA     comRegA,s 		;
           LDX     comRegX,s 		;
           ADDSP   comNARet,i 		;
           RET0   			;


 ;------- Inserer
 ; Sous programme recursif qui parcour l'arbre et le cherche dans le but 
 ; d'inserer le mot a la bonne position dans l'arbre

 ;Compisition d'un noeud:
 
 ;MOT:    .EQUATE 0
 ;NB_OCC: .EQUATE 2
 ;GAUCHE: .EQUATE 4
 ;DROITE: .EQUATE 6

 ;TAILLE: .EQUATE 8


 InsInd:  .EQUATE 0
 InsRegX: .EQUATE 2  ; Registre X
 InsRegA: .EQUATE 4  ; Registre A
 InsRet:  .EQUATE 6  ;
 Insptnd: .EQUATE 8  ; pointeur noeud
 Insptmot:.EQUATE 10 ; pointeur mot
 Insptfi: .EQUATE 12 ; addresse du pointeur fin mot
 Inshpptr:.EQUATE 14 ; pointeur du heap
 InsNRet: .EQUATE 14 ;


 Inserer: SUBSP	6,i
          STA     InsRegA,s	;  sauvegarde A
          STX	  InsRegX,s	;  sauvegarde X
          LDX	  0,i		;  indice = 0
          LDA	  Insptnd,s	;  
	  CPA	  0x0000,i	;
          BREQ	  nNoeud	;

 compa:   LDX     MOT,i  	; 
    	  LDA     Insptnd,sxf 	; 
    	  STA     -4,s        	;
          LDA	  Insptmot,s  	;
          STA     -2,s      	;
          SUBSP   4,i       	;
          CALL    compare   	;
          LDA     0,s       	;
          CPA     0,i       	;
          BREQ    incre     	;
          BRLT    droit     	;
          BRGT    gauche    	;

 droit:   LDX     DROITE,i  	;
    	  LDA     Insptnd,sxf 	;
          STA     -8,s  	;
          LDA     Insptmot,s 	;
          STA     -6,s  	;
          LDA     Insptfi,s 	;
          STA     -4,s  	;
          LDA     Inshpptr,s 	;
          STA     -2,s  	;
          SUBSP   8,i  		;
          CALL    Inserer  	;
          LDX     6,i  		;
          LDA     Insptnd,sxf 	;
          CPA     0x0000,i 	;
    	  BREQ    update  	;
    	  BR      final  	;

 gauche:  LDX  	  GAUCHE,i	;
          LDA     Insptnd,sxf 	;
          STA  	  -8,s  	;
          LDA  	  Insptmot,s 	;
          STA  	  -6,s  	;
          LDA  	  Insptfi,s 	;
          STA  	  -4,s 	 	;
          LDA     Inshpptr,s 	;
          STA     -2,s  	;
          SUBSP   8,i  		;
          CALL    Inserer	;
          LDX     4,i  		;
          LDA     Insptnd,sxf 	;
          CPA     0x0000,i 	;
          BREQ    update  	;
          BR      final  	;

 nNoeud:  LDA	  Inshpptr,s 	;
          STA 	  -4,s  	;
          LDA     TAILLE,i 	;
          STA     -2,s 		;
          SUBSP   4,i  		; 
          CALL    new    	;
          LDA     Insptmot,s 	;
          STA     Inshpptr,sf 	;
          LDX     2,i  		;
          LDA     1,i  		;
          STA     Inshpptr,sxf 	;
          BR      final  	;

 incre:   LDX     NB_OCC,i  	;
          LDA     Insptnd,sxf 	;
          ADDA    1,i  		;
          STA  	  Insptnd,sxf 	;
          LDA 	  Insptmot,s 	;
          STA 	  Insptfi,sf 	;
          BR  	  final  	;

 update:  LDA  	  Inshpptr,s 	;
          STA  	  Insptnd,sxf 	;

 final:   LDA  	  InsRet,s 	;
          STA 	  InsNRet,s 	;
          LDA     InsRegA,s     ;  restaure A
          LDX     InsRegX,s     ;  restaure X
          ADDSP   InsNRet,i     ;  nettoyer pile
          RET0                  ;


 ;------- Affiche
 ; Sous programme recursif affichant l'arbre en ordre alphabetique 
 ; ainsi que le nombre d'occurence de chaque mot

temp:	 .EQUATE 0

AffRegX: .EQUATE 2 
AffRegA: .EQUATE 4

AffRet:  .EQUATE 6
AffArb:  .EQUATE 8
AffNRet:  .EQUATE 8


Afficher:NOP0   		;
      	 SUBSP   AffRet,i   	;
         STX     AffRegX,s  	; 
      	 STA 	 AffRegA,s  	;
      	 LDA     AffArb,s  	;
      	 CPA     0x0000,i   	; if (Arbre != NULL)
      	 BREQ    affFinal  	;
      	 LDX     GAUCHE,i   	;
      	 LDA     AffArb,sxf  	;
      	 STA 	 -2,s  		;
      	 SUBSP   2,i  		;
      	 CALL  	 Afficher   	; Afficher(Arbre->gauche)
      	 LDX 	 NB_OCC,i   	;
    	 LDA 	 AffArb,sf  	; 
    	 STA     temp,s  	;
      	 STRO 	 temp,sf   	; cout << Arbre->mot
         STRO    msgUti,d   	;
      	 DECO 	 AffArb,sxf     ; cout << Arbre->compte
         STRO    msgFois,d   	;
         CHARO	 0x0A,i  	; Saut de ligne
      	 LDX 	 6,i   		;
         LDA 	 AffArb,sxf  	;
    	 STA 	 -2,s  		;
      	 SUBSP   2,i  		;
      	 CALL  	 Afficher   	; Afficher(Arbre->droite)
affFinal:LDA 	 AffRet,s  ;
      	 STA 	 AffNRet,s  ;
	 LDA 	 AffRegA,s  ;
      	 LDX 	 AffRegX,s  ;
      	 ADDSP 	 AffNRet,i    ;
      	 RET0   

; ------------- variables:

 msgInv:  .ASCII  "Entrez un texte. \x0A\x00"
 msgFin:  .ASCII  "Arrêt normal du programme. \x0A\x00"
 msgUti:  .ASCII  " utilisé \x00"
 msgFois: .ASCII  " fois.\x00"
 

tabMot:  .BLOCK  255 
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
    	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255
   	 .BLOCK  255


ptrMot:  .ADDRSS tabMot
debMot:  .ADDRSS tabMot
temp1:   .WORD 0
racine:  .ADDRSS heap
heappnt: .ADDRSS heap ; initialement pointe  heap
heap:    .BLOCK  255  ; espace heap; dpend du systme
         .BLOCK  255 
       	 .BLOCK  255 
       	 .BLOCK  255
      	 .BLOCK  255
      	 .BLOCK  255
      	 .BLOCK  255
         .BLOCK  255
heaplmt: .BYTE    0   ;

ASCII:.BYTE 1
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 0
      .BYTE 10
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
