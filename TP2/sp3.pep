;----------- ENTREE DE CARACTERES -----------
; IL FAUT SETTER nblet POUR LE NOMBRE DE CARACTERES (DEFAUT: 5)
		LDX	0,i
	while4:	CPX	nblet,d
		BRGE	fin4
		CHARI	mot,x
		ADDX	1,i
		BR	while4
	fin4:	NOP0	
;----------- FIN ENTREE ---------------------

		LDA 	nblet,d
		STA 	-10,s	; Empiler taille
		LDA	nbletN,i
		STA	-8,S	;
		LDA 	invalid,i
		STA 	-6,s	; Empiler addresse des caracteres accentués
		LDA 	mot,i
		STA 	-4,s	; Empiler addresse de début de chainer a traiter
		LDA 	motConv,i
		STA 	-2,s	; Empiler addresse où retourner chaine traitée
		SUBSP 	10,i	
		CALL	DelInv
		ADDSP	10,i
		
;----------- SORTIE DE LA CHAINE APRES TRAITEMENT -----------
		CHARO 	'\n',i		
		LDX	0,i
	while5:	CPX	nbletN,d
		BRGE	fin5
		CHARO	motConv,x
		ADDX	1,i
		BR	while5
	fin5:	NOP0	
		CHARO	'\n',i
		DECO	nbletN,d
;----------- FIN DE LA SORTIE APRES TRAITEMENT ---------------

		STOP

	mot:	.BLOCK	20
	motConv:.BLOCK	20
	nblet:	.WORD	5
	nbletN:	.WORD	0
	invalid:.BYTE	32	;\s
		.BYTE	33	;'!'
		.BYTE	34	;'"'
		.BYTE	39	;'''
		.BYTE	44	;','
		.BYTE	46	;'.'
		.BYTE	58	;':'
		.BYTE	59	;';'
		.BYTE	63	;'?'

; Sous-programme qui enleve les espaces et signes de ponctuation d'une chaine 
; entree en parametre. Il retournera la chaine a une adresse qui aura ete
; entree en parametre aussi.
; Parametres:		Longueur de chaine
;			Adresse de chaine a traiter
;			Adresse de retour de chaine traitee
;			Adresse de retour de la taille de la chaine traitee
;			Adresse des caracteres consideres invalides
;
;	TODO:	-RÉGLER LE BUG QUI FAIT QUE LORSQU'IL Y A PLUS D'UNE LETTRE
;		 IL NE RETOURNE PAS BIEN ChainB
;		-IMPLÉMENTER LA VARIABLE TaillB
;		-AJOUTER AU PROGRAMME PRINCIPAL

	Temp:	.EQUATE 0	; Variable Temporaire (usage a boucle3)
	IndexI:	.EQUATE 2	; Index de la table d'invalides
	VieuxX:	.EQUATE	4	; Vieux contenu du registre X
	VieuxA:	.EQUATE	6	; Vieux contenu du registre A
	Accum:	.EQUATE 8	; Accumulateur de la premiere boucle
	Carac:	.EQUATE	10	; Caractere a analyser

	AddRet:	.EQUATE 12	; Adresse de retour

	Taille:	.EQUATE	14	; Taille de la chaine a traiter
	TaillB:	.EQUATE	16	; Taille de la chaine apres traitement
	Inval:	.EQUATE	18	; Adresse du debut du tab. de caracteres invalides
	ChainA:	.EQUATE	20	; Adresse de la chaine a traiter
	ChainB:	.EQUATE	22	; Adresse ou retourner la chaine apres traitement

	DelInv:	SUBSP	12,i	
		STA	VieuxA,d
		STX	VieuxX,d
		LDA	8,i
		STA	Temp,s	; On utilisera cette variable comme var temporaire
		LDX	0,i
		STX	Accum,s
		STX	IndexI,s
		
	while1:	LDX	Accum,s
		CPX	Taille,s
		BRGE	fin1
		LDBYTEA	ChainA,sxf	
		STA	Carac,s		; Carac = chaine[x] 
		ADDX	1,i
		STX	Accum,s		; Accum nous sert a garder notre indice
		LDX	0,i
	while2:	CPX	8,i		; Il y a 9 caracteres invalides, ind[0-8]
		BRGE	fin2		; Le caractere n'est PAS Invalide
		LDBYTEA	Inval,sxf	; a = Inval[x]
		ADDX	1,i	
		CPA	Carac,s		; if(Carac == Inval[x])
		BREQ	while1		; on retourne a 1ere boucle
		BR	while2		; sinon on compare avec un autre char inval

	fin2:	LDA	Carac,s		; Le char n'est PAS Invalide
		LDX	0,i
	bouc3:	CPX	Temp,s	; boucle pour bouger de 1 octet vers la gauche
		BRGE	fin3		; if (x < 8)
		ADDX	1,i
		ASLA
		BR bouc3
	fin3:	NOP0
		LDX	TaillB,sf	; Taille chaine += 1
		ADDX	1,i			
		STX	TaillB,sf

		LDX	IndexI,s	; On l'ajoute donc a chainB
		STA	ChainB,sxf
		ADDX	1,i
		STX	IndexI,s
		BR	while1

	fin1:	NOP0
		LDX	VieuxX,s
		LDA	VieuxA,s		
		ADDSP 	12,i
		RET0
		.END		