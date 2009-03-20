
		LDA 	mot,i
		STA 	-4,s	; Empiler l'adresse de mot
		LDA 	TA_MAX,i
		STA 	-2,s	; Empiler le nombre 20 (taille)
		SUBSP 	4,i

		STRO 	msgSai,d
		CALL 	LirChain
		LDA 	0,s	; DÃ©sempiler la taille de la chaine entrÃ©e
		STA 	nblet,d
		ADDSP	2,i	; Nettoyer pile
;===================================================================================
;Sous prog 4 dans Main

		LDA	0,i	; A = 0
		LDA	mot,i; 
		STA 	-4,s	; Empiler l'adresse de la chaine
		LDA 	nblet,d
		STA 	-2,s	; Empiler la taille de la chaine
		SUBSP 	4,i
		CALL	VerPal	; Appeler le sous-programme : "Vérifier Palindromes"
		DECO	0,s	; Valeur de retour: 1 = palin., 0 != palin.
		
;===================================================================================

		
	
;--------- TESTS ---	---------
	
		LDX 	0,i
	boucle:	CPX 	nblet,d		
		BRGE	finBouc
		CHARO	mot,x
		ADDX	1,i
		BR 	boucle
	finBouc:CHARO	'\n',i
		
		LDX 	0,i
	bouc1:	CPX 	nblet,d		
		BRGE 	finBou1
		CHARO 	motConv,x
		ADDX 	1,i
		BR 	bouc1
	finBou1:CHARO 	'\n',i

;--------- FIN TESTS ------------
	

		STOP

	
	TA_MAX:	.EQUATE	20
	mot:	.BLOCK 20
	motConv:.BLOCK 20
	nblet:	.WORD 0
	msgSai:	.ASCII "Veuillez entre une chaine: \x00"
	


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
	         STBYTEA addrBuf,sxf;    Buf[indice] = caractere; 
	         ADDX    1,i        ;    indice++;
         CPX     taille,s   ;    if(indice > taille) break;
	         BRLE    EncorL     ;  }
	FiniL:   STX     taille,s   ;  nombre de caracteres lus
	         LDA     retour,s   ;  adresse retour
	         STA     addrBuf,s  ;  deplacee
	         LDA     regA,s     ;  restaure A
	         LDX     regX,s     ;  restaure X
         ADDSP   8,i        ;  nettoyer pile
	         RET0               ;}// LireChaine




;===================================================================================
;Contenu du sus prog 4

	;------- Vérifier palindromes
	;Lit une chaine de caracteres ASCII et compare l'égalité entre le cractère n et 
	;le caratère taille - n. Si l'égalité persiste pour la motié du mot, 
	;c'est un palidrome. 
	
	;VerPal{

	VPregX:  .EQUATE 0	;Sauvegarder la valeur de X
	VPregA:  .EQUATE 2	;Sauvegarder la valeur de A
	VPIndFn: .EQUATE 4	;Index  de la fin de la chaine ( n - x++ )
	VPIndDb: .EQUATE 6	;Index qui part du début de la chaine
	VPTmpCd: .EQUATE 8	;Caractère à l'index VPIndDb
	VPTmpCf: .EQUATE 10	;Caractère à l'index VPIndFN
	VPAret:	 .EQUATE 12	;Adresse de retour
	VPCha: 	 .EQUATE 14     ;Chaine traitée
	VPLong:  .EQUATE 16     ;Longueur de la chaine 
	VPVret:  .EQUATE 18 	;Valeur de retour ( 1=oui, 0=non )
	VPNAret: .EQUATE 16 	;Nouvelle adresse de retour (lorsqu'on vide)
	                            
	VerPal:	 SUBSP   12,i		;Espace local
	         STA     VPregA,s	;Sauvegarde A
         	 STX     VPregX,s 	;Sauvegarde X
		 LDX     0,i		;Nul			
		 LDX	 VPLong,s	;
		 SUBX	 1,i		;				 
		 STX	 VPIndFn,s	;VPIndFn = VPLong - 1

		 LDX     0,i         	;Nul
	         STX     VPIndDb,s    	;Index du début  = 0
	         LDA     0,i         	;Nul
		 

					;do{ //while( VPIndDb != VPIndFn )
	VPTest:  LDX     VPIndDb,s	;	
		 LDBYTEA VPCha,sxf	;
 		 STA VPTmpCd,s		;VPTmpCd = VPCha[VPIndDb]

		 LDA	 0,i		;
		 LDX	 0,i		;	 
		 LDX	 VPIndFn,s	;
		 LDBYTEA VPCha,sxf	;
		 STA 	 VPTmpCf,s	;VPTmpCd = VPCha[VPIndDb]
		 
		 CPA	 VPTmpCd,s	;if( VPTmpCd != VPTmpCf ){
	         BRNE    FinNeg		;break

		 LDX	 0,i		;
		 LDX	 VPIndFn,s	;
		 SUBX	 1,i		;
		 STX	 VPIndFn,s	; VPIndDb--
		 CPX	 VPIndDb,s	;
		 BREQ	 FinPos		; }//end while =>( VPIndFn == VPIndDb )
		 LDX	 VPIndDb,s	;
		 ADDX	 1,i		;
		 STX	 VPIndDb,s	; VPIndDb++
		 CPX	 VPIndFn,s
		 BREQ	 FinPos		; }//end while =>( VPIndDb == VPIndFn )		 
  	         BR    	 VPTest     	; } while ( VPIndDb != VPIndFn );	

	FinPos:  LDA	 1,i		;
		 STA     VPVret,s      	; C'est un palindrome! Valeur de retour = 1
		 BR	 VPsortie	;
	FinNeg:  LDA	 0,i		;
		 STA     VPVret,s       ; Ce n'est pas un palindrome! Valeur de retour = 0

	VPsortie:LDA     VPAret,s   	;  
	         STA     VPNAret,s   	;  nouvelle adresse retour = adresse retour
	         LDA     VPregA,s     	;  restaure A
	         LDX     VPregX,s     	;  restaure X
         	 ADDSP   VPNAret,i      ;  nettoyer pile

	         RET0               ;}// VerPal
;===================================================================================	


	.END