
		LDA mot,i
		STA -4,s
		LDA 10,i
		STA -2,s
		SUBSP 4,i
		STRO msgSai,d
		CALL LirChain
		LDA 0,s
		STA nblet,d
		ADDSP 2,i
		DECO nblet,d
		STOP

	mot:	.EQUATE 10
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

	.END