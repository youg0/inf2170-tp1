
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

		
		LDA	0,i
		LDA	mot,i;
		STA 	-4,s	; Empiler l'adresse de mot
		LDA 	nblet,d
		STA 	-2,s	; Empiler le nombre 20 (taille)
		SUBSP 	4,i
		CALL	VerPal
		DECO	0,s
		ADDSP	2,i

		
	
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






	;------- Vérifier palindromes
	;Lit une chaine de caracteres ASCII et compare l'égalité entre le cractère n et 
	;le caratère taille - n. Si l'égalité persiste pour la motié du mot, 
	;c'est un palidrome. 

	VPregX:  .EQUATE 0
	VPregA:  .EQUATE 2
	VPTmpFn: .EQUATE 4	;Variable temporaire pour taille-n
	VPTmpDb: .EQUATE 6	;Variable temporaire pour n
	VPTmpCa: .EQUATE 8
	VPAret:	 .EQUATE 10	;Adresse de retour
	VPCha: 	 .EQUATE 12     ;Chaine lue
	VPLong:  .EQUATE 14     ;Longueur chaine 
	VPVret:  .EQUATE 16 	;ValeurRetour
	VPNAret: .EQUATE 14 	;Nouvelle adresse de retour
	                            ;{
	VerPal:	 SUBSP   10,i        ;  espace local
	         STA     VPregA,s     ;  sauvegarde A
         	 STX     VPregX,s     ;  sauvegarde X
		 LDX     0,i 
		 LDX	 VPLong,s
		 SUBX	 1,i	 				 
		 STX	 VPTmpFn,s	;

	         LDX     0,i         ;
	         STX     VPTmpDb,s    ;  indice caractere original = 0
	         LDA     0,i         ;  nul
		 
	                            ;  while(true){
	VPTest:  LDX     VPTmpDb,s
		 LDBYTEA VPCha,sxf
		 ASLA
		 ASLA
		 ;ANDA	 0x03,i		;Cherche et store le premier byte de VPCha dans VPTmpC			
 		 STA 	 VPTmpCa,s
		 LDX	 VPTmpFn,s
		 LDBYTEA VPCha,sxf
		 ;ANDA	 0x3,i	
		 CPA	 VPTmpCa,s
	         BRNE    FinNeg
		 LDX	 0,i
		 LDX	 VPTmpFn,s
		 CPX	 VPTmpDb,s
		 BREQ	 FinPos	
		 SUBX	 1,i
		 STX	 VPTmpFn,s	 
		 LDX	 0,i	
		 LDX	 VPTmpDb,s
		 ADDX	 1,i
		 STX	 VPTmpDb,s
  	         BR    	 VPTest     ;  }
	FinPos:  LDA	 1,i
		 STA     VPVret,s      ;  nombre de caracteres lus
		 BR	 VPsortie
	FinNeg:  LDA	 0,i
		 STA     VPVret,s      ;  nombre de caracteres lus
	VPsortie:LDA     VPAret,s   ;  adresse retour
	         STA     VPNAret,s   ;  deplacee
	         LDA     VPregA,s     ;  restaure A
	         LDX     VPregX,s     ;  restaure X
         	 ADDSP   VPNAret,i        ;  nettoyer pile
	         RET0               ;}// LireChaine


	.END