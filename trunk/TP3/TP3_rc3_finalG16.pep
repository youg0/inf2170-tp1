; ********************************************************************************
; * I N F 2 1 7 0 (TP3 partie 2)
; *
; * Ce programme prend un texte saisie par l'utilisateur et la place en ordre
; * alphabétique dans un arbre binaire. Ensuite, il affiche chaque mot (en ordre
; * alphabétique) ainsi que son nombre d'occurences.
; *
; * Les sous programmes suivants sont utilisés:
; * 
; * New:    Alloue une taille dans la zone de memoire demande. Sera utilise
; *    afin de creer des noeuds contenant les informations sur les mots
; *    ainsi que leur emplacement dans l'arbre binaire.
; *    Sous-programme fourni par Philippe Gabrini.
; *  
; * LecMot:   Lit les mots de la chaine entrée, converti les caractères alphabétiques
; *    en minuscule et s'occupe ensuite de les insérer dans un tampon divisisés
; *    par des octets nuls. Il retourne l'adresse du dernier mot saisi.
; *
; * Compare:  Compare deux mots entrés en paramètre, il retournera une valeur
; *    selon la comparaison lexicographique des deux mots.
; *
; * Inserer;  Insere le mot passé en paramètre dans l'arbre selon la position
; *    qu'il devrait y prendre. Il ajoutera automatiquement une occurence
; *    au mot en question s'il existe déjà dans l'arbre.
; * 
; * Affiche:  Affiche le contenu de l'arbre passé en paramètre en ordre croissant.
; *    (Alphabétique si l'arbre contient des caractères)
; * 
; * 
; * Groupe 16 >>
; *
; * Pierre-Alexandre Latour Leblanc
; * P_A_L_A@hotmail.com (LATP13098706)
; *
; *
; * Martin Valiquette (VALM13037400)
; * martin_valiquette@videotron.ca
; *
; *  
; * Olivier Viera   (VIEP12058605)
; * viera.olivier@videotron.ca
; *
; *  
; * 
; * @version 02/06/2009
; *
; ********************************************************************************


 MOT:    .EQUATE 0
 NB_OCC: .EQUATE 2
 GAUCHE: .EQUATE 4
 DROITE: .EQUATE 6
 TAILLE: .EQUATE 8

 T_MAX:  .EQUATE 20000
  
 RACINE: .EQUATE 0
 TMP:    .EQUATE 2
 nb:     .EQUATE 4

 ENDL:   .EQUATE 0X0A 		 ; Caractere fin de fichier
 CAR_FIN:.EQUATE 0X0B  		 ; Caractere fin de fichier artificiellement ajouté par lecMot.
  
 main:   NOP0
         STRO    msgInv,d   	 ; cout "Entrez chaine:"
         LDA     ASCII,i   	 ; Appel de la méthode lecMot pour fabriquer la racine.
  	 STA     -8,s    	 ;  
   	 LDA     ptrMot,d  	 ;
   	 STA     -6,s    	 ;
  	 SUBSP   8,i    	 ;
 	 CALL    lecMot   	 ;
  	 LDA     0,s    	 ; Load ladresse du debut du mot
  	 STA     debMot,d  	 ; Enregistrement de l'adresse du début du mot lu.
  	 CPA   	 -1,i
  	 BREQ    Fintamp
         LDA     2,s   		 ; Load ladresse de la fin du mot
  	 STA     ptrMot,d 	 ; Store dans ptrMot
  	 ADDSP   4,i  		 ;
 
         SUBA    1,i    		; 
         STA     temp1,d   	 ; Enregistrement de la position de ptrMot,d -1
         LDA     0,i    	 ;

         LDBYTEA temp1,n   	 ; Compare "ptrMot,d - 1" et 0X0B 
    	 CPA     0X0B,i  	 ; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
   	 BREQ    Fin  	 	 ; si 0B alors cela veut dire qu'il n'y a plus de mot 

   	 LDA     racine,i   	 ; Insersion du noeud racine avec GAUCHE et DROITE à nul.
   	 STA     -8,s    	 ;
   	 LDA     debMot,d  	 ;
   	 STA     -6,s    	 ;
   	 LDA     ptrMot,i  	 ;
   	 STA     -4,s    	 ;
   	 LDA     heappnt,d  	 ;
   	 STA     -2,s    	 ;
   	 SUBSP   8,i    	 ;
    	 CALL    Inserer 	 ;

  	 LDBYTEA temp1,n   	 ; Compare "ptrMot,d - 1" et 0X0B 
    	 CPA     0X0A,i  	 ; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
   	 BREQ    Affiche 	 ; break 
  

Lecture: NOP0    	       	 ; Boucle principale
         LDA     ASCII,i   	 ; Appel de la méthode lecMot pour fabriquer la racine.
	 STA     -8,s    	 ;   
	 LDA     ptrMot,d  	 ;
	 STA     -6,s    	 ;    
	 SUBSP   8,i    	 ;   
	 CALL    lecMot     	 ;
	 LDA     0,s    	 ;
	 CPA     -1,i		 ;
	 BREQ    Fintamp	 ;
	 STA     debMot,d  	 ; Enregistrement de l'adresse du début du mot lu.
         LDA     2,s   		 ;
	 ADDSP   4,i  		 ;
	 STA     ptrMot,d 	 ;
	 SUBA    1,i    	 ; 
	 STA     temp1,d   	 ;
	 LDA     0,i    	 ;
	 LDBYTEA temp1,n   	 ;
	 CPA     0x0B,i  	 ; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
	 BREQ    Affiche  	 ; Fin de ligne cas 2:
	 LDA     heappnt,d  	 ;
	 CPA 	 heapfin,i  	 ;
	 BRGT 	 FinHeap
Insere:  LDA     racine,d   	 ;
   	 STA     -8,s    	 ;
  	 LDA     debMot,d  	 ;
  	 STA     -6,s   	 ;
  	 LDA     ptrMot,i  	 ;
  	 STA     -4,s     	 ;
  	 LDA     heappnt,d   	 ;
  	 STA   	 -2,s     	 ;
  	 SUBSP   8,i    	 ;
  	 CALL    Inserer   	 ;

 	 LDBYTEA temp1,n    	 ; Compare "ptrMot,d - 1" et 0X0B 
   	 CPA     0X0A,i  	 ; 0X0B est insere artificiellement dans lecMot pour signifier une fin de ligne.
  	 BREQ    Affiche 	 ; break 

  	 BR    	 Lecture   	 ;

Affiche:LDA   	 racine,d  	 ;
  	 STA   	 -2,s    	 ;
    	 SUBSP   2,i   	 	 ;
  	 CALL    Afficher 	 ;

Fin:    CHARO 	 0x0A,i  	 ; Saut de ligne
  	STRO  	 msgFin,d	 ;
 	STOP       	 	 ;
Fintamp:CHARO 	 0x0A,i  	 ; Saut de ligne
 	STRO  	 msgtamp,d 	 ;
 	BR  	 STOP
FinHeap:CHARO 	 0x0A,i		 ;
 	STRO 	 msgHeap,d	 ;
STOP:   STOP       		 ;


;---------New ( Noeud )
; Le sous-programme new alloue la taille demande et place l'adresse
; de la zone dans le pointeur dont l'adresse est passe en paramtre.
; @param Taille du noeud à créer => Ntaille
; @param Adresse où sauvegarder l'adresse du nouveau pointeur => Npoint

NvieuxX: .EQUATE 0        ; sauvegarde X
NvieuxA: .EQUATE 2        ; sauvegarde A
NadRet:  .EQUATE 4        ; adresse retour
Npoint:  .EQUATE 6        ; adresse pointeur  remplir
Ntaille: .EQUATE 8        ; taille requise

new:  	 SUBSP   4,i         	  ; espace local
  	 STA     NvieuxA,s    	  ; sauvegarder A
  	 STX     NvieuxX,s    	  ; sauvegarder X
  	 LDA     heappnt,d    	  ;
  	 STA     Npoint,sf    	  ; adresse retourne
   	 LDA     Ntaille,s    	  ; taille du noeud
  	 ADDA    1,i              ; arrondir  pair
  	 ANDA    0xFFFE,i         ;
  	 ADDA    heappnt,d        ; nouvelle valeur
  	 CPA     heaplmt,i        ;
  	 BRGT    new0             ; si pas dpass la limite du heap
  	 STA     heappnt,d        ; mettre  jour heappnt
  	 BR      new1             ; et terminer
	
new0:  	 LDA     0,i        	  ; sinon
  	 STA     Npoint,sf        ; mettre pointeur  NULL

new1:  	 LDA     NadRet,s    	  ; dplacer adresse retour
  	 STA     Ntaille,s     	  ;  
  	 LDA     NvieuxA,s   	  ; restaurer A
  	 LDX     NvieuxX,s    	  ; restaurer X
  	 ADDSP   8,i         	  ; nettoyer pile
  	 RET0            	  ; return; }
   
 

;------- lectureMot
; Voici les trois opprations de ce sous programme:
;
; 1) Lire chaque mot d'une chaine,
; 2) les convertir les carateres alphabetique en minuscules et transformer des caractères invalides 
;    selon la table ASCII modifiee mise en parametre. 
; 3) Placer le mot lu dans le tampon ptrMot et retourner son adresse.
;
; @param Table de conversion  => ASCII
; @param Adresse tu tampon pour les mot => ptrMot
; @return Adresse du mon insere   => debMot

 
lecCode: .EQUATE 0      ; Variable temporaire
lecRegX: .EQUATE 2      ; Registre X
lecRegA: .EQUATE 4      ; Registre A

lecARet: .EQUATE 6      ; Adresse de retour

lecConv: .EQUATE 8      ; tableau de conversion
lecPtr:  .EQUATE 10     ; Adresse du tampon de mots
lecVRet: .EQUATE 12     ; Valeur de retour ( Adresse du mot )
lecVRet2:.EQUATE 14     ; Adresse du tampon de mots
lecNARet:.EQUATE 10     ; Nouvelle valeur de retour

lecMot:  SUBSP   lecARet,i    	; espace local
	 STA     lecRegA,s   	; sauvegarde A
   	 STX     lecRegX,s   	; sauvegarde X
    	 LDX     0,i     	; 
    	 LDA     0,i     	; 

    	 LDA     lecPtr,s  	; 
    	 STA     lecVRet,s  	; Met l'adresse actuelle du tampon dans la valeur deretour.
    	 LDA     0,i    	;

lecBou0: CHARI   lecCode,s  	; cin >> caractere;
  	 LDA     0,i  	     	;
     	 LDBYTEA lecCode,s   	; 
    	 STA     lecCode,s   	;
    	 LDX     lecCode,s   	; prend le code du caratere
    	 LDBYTEA lecConv,sxf 	; transpose le code dans le table de conversion
  	 CPA  	 1,i  		; compare avec 1 apres conversion : caracter associe a 0000 
  	 BREQ  	 lecFinB 	;  
  	 CPA  	 0,i  		;
  	 BRNE  	 lecEcri 	; le caractere n'est pas nul: break
  	 BR   	 lecBou0 	; tant que lecaratere lu est null apres converstion
  
lecBou:  CHARI   lecCode,s    	; On lit un caractère 
  	 LDA   	 0,i  		;
    	 LDBYTEA lecCode,s   	;
  	 CPA   	 0X0A,i  	; On vérifie si c'est un retour de chariot 
         BREQ    lecFinA  	; Si c'est le cas on quitte
    	 STA     lecCode,s   	;
    	 LDX     lecCode,s   	;
    	 LDBYTEA lecConv,sxf	;

lecEcri: STBYTEA lecPtr,sf  	; On écrit le caractere dans le tampon
  	 BREQ    lecFin  	; S'il est égal à zéro, on quitte
  	 CPA  	 1,i  		;
  	 BREQ  	 lecFinA 	; 
  	 LDA     lecPtr,s  	;
  	 ADDA    1,i    	;
  	 CPA  	 finTamp,i	; Fin tampon est un .BLOCK placé apres les blocks de tampon.
  	 BREQ    lecFinC	;
    	 STA     lecPtr,s  	;
  	 BR      lecBou   	; Tant que le caratere lu n'est pas nul et n'est pas egal a 0x0A.

lecFinB: LDA  	 0x0B,i  	;  
  	 STBYTEA lecPtr,sf  	;
  	 BR   	 lecFin  	;

lecFinA: NOP0   		;	
  	 LDA  	 0,i  		;
   	 STBYTEA lecPtr,sf   	;
  	 LDA     lecPtr,s  	;
  	 ADDA    1,i    	;
    	 STA     lecPtr,s  	;
  	 LDA  	 0x0A,i  	;
  	 STBYTEA lecPtr,sf   	;
  	 BR   	 lecFin		;

lecFinC: LDA  -1,i		; Quand le tampon est plein
  	 STA  lecVRet,s		; retourne -1

lecFin:  LDA    lecPtr,s  	;
         ADDA    1,i    	;
    	 STA    lecVRet2,s 	;

   	 LDA    lecARet,s  	;
    	 STA    lecNARet,s  	; Stocker l'adresse de retour
    	 LDA    lecRegA,s  	; Restaure le Registre A
    	 LDX    lecRegX,s 	; Restaure le Registre X
    	 ADDSP   lecNARet,i     ;
    	 RET0   		;
     


 ;------- comparer
 ; Ce sous-programme compare deux mots de facon lexicographique
 ; et renvoit 1 si l premier mot est plus grand, -1  'il est plus
 ; petit et 0 si les deux mot sont egaux.
 ;
 ;@param   adresse du premier mot => comT1
 ;@param   adresse du deuxieme mot => comT2
 ;@return  int 0 si =, -1 si <, 1 sir >


 comInd:   .EQUATE 0  		; Indice
 comCar:   .EQUATE 2  		; Caractere ( temporaire )
 comRegX:  .EQUATE 4  		; Registe X
 comRegA:  .EQUATE 6  		; Registre A 

 comARet:  .EQUATE 8  		; variable temporaire

 comT1:    .EQUATE 10           ; mot 1
 comT2:    .EQUATE 12           ; mot 2
 comVRet:  .EQUATE 14           ; Adresse de retour
 comNARet: .EQUATE 12           ; taille maximum
                             

 compare:  SUBSP   8,i    	;  espace local
     	   STA     comRegX,s    ;  sauvegarde A
    	   STX     comRegA,s    ;  sauvegarde X
     	   LDX     0,i          ;  
     	   LDA     0,i          ;  
     	   STA     comVRet,s    ;
     	   STX     comInd,s     ;
 
 comBLec:  LDBYTEA comT1,sxf    ; On compare lettre par lettre
           CPA     0,i    	;
     	   BREQ    longDifA     ;
     	   LDBYTEA comT2,sxf    ; 
     	   CPA     0,i    	;
           BREQ    finAp    	; Si l'octet est nul, un des mots est plus courts

           LDX     comInd,s     ;
           LDBYTEA comT2,sxf    ;
           STA     comCar,s     ; 
           LDBYTEA comT1,sxf    ;
           CPA     comCar,s     ;
           BRLT    finAv    	; Lorsque les caractères sont différents, on retourne
           BRGT    finAp    	; la valeur selon la différence 
           ADDX    1,i    	;
           STX     comInd,s   	;
           BR      comBLec    	;

 finAv:    LDA     -1,i    	; -1, le premier mot est plus petit
           STA     comVRet,s    ;
           BR      finCom    	;

 finAp:    LDA     1,i    	; 1, le premier mot est plus grand
           STA     comVRet,s    ;
           BR      finCom    	;

 longDifA: LDBYTEA comT2,sxf    ; Le premier mot est plus long
           BREQ    memeLong     ;
           BRNE    finAv    	;

 memeLong: LDA     0,i    	; Les deux mots sont égaux
           STA     comVRet,s    ;

 finCom:   LDA     comARet,s    ;
           STA     comNARet,s   ; Stocker l'adresse de retour
           LDA     comRegA,s    ; Restaurer Registre A
           LDX     comRegX,s    ; Restaurer Registre X
           ADDSP   comNARet,i   ;
           RET0      		;


 ;------- Inserer
 ; Sous programme recursif qui parcour l'arbre et le cherche dans le but 
 ; d'inserer le mot a la bonne position dans l'arbre
 ;
 ; @param Adresse du noeud   => Insptnd
 ; @param Adresse du mot   => Insptmot
 ; @param Adresse de la fin du mot  => Insptfi
 ; @param Adresse de la zone mémoire réservé  => Inshpptr

 InsInd:  .EQUATE 0
 InsRegX: .EQUATE 2  ; Registre X
 InsRegA: .EQUATE 4  ; Registre A
 InsRet:  .EQUATE 6  ;
 Insptnd: .EQUATE 8  ; pointeur noeud
 Insptmot:.EQUATE 10 ; pointeur mot
 Insptfi: .EQUATE 12 ; addresse du pointeur fin mot
 Inshpptr:.EQUATE 14 ; pointeur du heap
 InsNRet: .EQUATE 14 ;


 Inserer: SUBSP   6,i
          STA     InsRegA,s   		;  sauvegarde A
          STX     InsRegX,s     	;  sauvegarde X
          LDX     0,i  ;  indice = 0	;
          LDA     Insptnd,s 		;  
   	  CPA     0x0000,i 		;
          BREQ    nNoeud 		;

 compa:   LDX     MOT,i   		; 
          LDA     Insptnd,sxf  		; 
       	  STA     -4,s         		;
          LDA     Insptmot,s   		;
          STA     -2,s       		;
          SUBSP   4,i        		;
          CALL    compare    		; On compare le mot avec la racine
          LDA     0,s       		;
          CPA     0,i        		;
          BREQ    incre     		; Si 0, le mot existe déjà
          BRLT    droit     		;
          BRGT    gauche     		;

 droit:   LDX     DROITE,i   		; Le mot est plus grand (alphabétiquement)
   	  BR	  recure 		;

 gauche:  LDX     GAUCHE,i 		; Le mot est plus petit (alphabétiquement)

 recure:  LDA     Insptnd,sxf  		; La racine est le mot choisi selon la comparaison faite
          STA     -8,s   		;
          LDA     Insptmot,s  		;
          STA     -6,s   		;
          LDA     Insptfi,s  		;
          STA     -4,s   		;
          LDA     Inshpptr,s  		;
          STA     -2,s   		;
          SUBSP   8,i    		;
          CALL    Inserer   		; On appelle insérer avec la nouvelle raicine
          LDA     Insptnd,sxf  		; 
          CPA     0x0000,i  		;
       	  BREQ    update   		;
       	  BR      final   		;


 nNoeud:  LDA     Inshpptr,s  		; Le mot n'existe pas déjà dans l'arbre
          STA     -4,s   		; On crée donc un nouveau noeud lié à la racine
          LDA     TAILLE,i  		;
          STA     -2,s   		;
          SUBSP   4,i    		; 
          CALL    new     		; 
          LDA     Insptmot,s  		;
          STA     Inshpptr,sf  		;
          LDX     2,i    		;
          LDA     1,i    		;
          STA     Inshpptr,sxf  	;
          BR      final   		;

 incre:   LDX     NB_OCC,i   		; Le mot existe déjà dans l'arbre
          LDA     Insptnd,sxf  		; 
          ADDA    1,i    		; On ne fait qu'ajouter une occurence dans le noeud
          STA     Insptnd,sxf  		;
          LDA     Insptmot,s  		;
          STA     Insptfi,sf  		;
          BR      final   		;

 update:  LDA     Inshpptr,s  		;
          STA     Insptnd,sxf  		;

 final:   LDA     InsRet,s  		;
          STA     InsNRet,s  		;
          LDA     InsRegA,s     	;  restaure A
          LDX     InsRegX,s     	;  restaure X
          ADDSP   InsNRet,i     	;  nettoyer pile
          RET0                  	;


 ;------- Affiche
 ; Sous programme recursif affichant l'arbre en ordre alphabetique 
 ; ainsi que le nombre d'occurence de chaque mot
 ; @param L'adresse de la racine de l'arbre

temp:  	 .EQUATE 0

AffRegX: .EQUATE 2 
AffRegA: .EQUATE 4

AffRet:  .EQUATE 6
AffArb:  .EQUATE 8
AffNRet: .EQUATE 8


Afficher:NOP0     	       	 ;   
         SUBSP   AffRet,i   	 ;
         STX     AffRegX,s   	 ; 
         STA     AffRegA,s   	 ;
         LDA     AffArb,s  	 ;
         CPA     0x0000,i    	 ; if (Arbre != NULL)
         BREQ    affFinal   	 ;
         LDX     GAUCHE,i    	 ;
         LDA     AffArb,sxf   	 ;
         STA     -2,s    	 ;
         SUBSP   2,i    	 ;
         CALL    Afficher    	 ; Afficher(Arbre->gauche)
         LDX     NB_OCC,i    	 ;
      	 LDA     AffArb,sf       ; 
      	 STA     temp,s   	 ;
         STRO    temp,sf    	 ; cout << Arbre->mot
         STRO    msgUti,d     	 ;
         DECO    AffArb,sxf      ; cout << Arbre->compte
         STRO    msgFois,d       ;
         CHARO   0x0A,i          ; Saut de ligne
         LDX     6,i     	 ;
         LDA     AffArb,sxf      ;
      	 STA     -2,s       	 ;
         SUBSP   2,i    	 ;
         CALL    Afficher    	 ; Afficher(Arbre->droite)

affFinal:LDA   	 AffRet,s   	 ;
         STA   	 AffNRet,s   	 ;
  	 LDA   	 AffRegA,s   	 ;
         LDX     AffRegX,s  	 ;
         ADDSP   AffNRet,i     	 ;
         RET0   


; ------------- variables:

 msgInv:  .ASCII  "Entrez un texte. \x0A\x00"
 msgFin:  .ASCII  "Arrêt normal du programme. \x0A\x00"
 msgtamp: .ASCII  "Limite du tampon atteinte. \x0A\x00"
 msgUti:  .ASCII  " utilisé \x00"
 msgFois: .ASCII  " fois.\x00"
 msgHeap: .ASCII  "Limite du heap atteinte. \x0A\x00"

tabMot:  .BLOCK  255 
    	 .BLOCK  255
    	 .BLOCK  255
    	 .BLOCK  255
    	 .BLOCK  255
finTamp: .BLOCK   10

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

heapfin: .BLOCK   7
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
