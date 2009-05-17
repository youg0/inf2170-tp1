;--------- Inserer

	InsRegA:	.EQUATE 0
	InsRegX:	.EQUATE 2
	InsTemp:	.EQUATE	4
	
	InsARet:	.EQUATE 6
	
	InsMot:		.EQUATE	8	; Mot à insérer
	InsRac:		.EQUATE	10	; Racine de l'arbre


	Inser:	SUBSP	6,I
		STA	InsRegA,s
		STX	InsRegX,s
		LDA	0,i
		LDX	0,i

		LDA	InsRac,s	; On verifie si la racine est null
		BRNE	InsCmp

	InsCrN:	NOP0			; On cree un nouveau noeud
		LDA	InsTemp,s
		STA	-4,s
		LDA	InsMot,s
		STA	-2,s
		SUBSP	4,i
		CALL	new
		LDA	InsMot,s	; Le noeud est situé à InsTemp
		STA	InsTemp,sf
		BR	InsFin

	InsCmp:	LDA	InsMot,s
		STA	-4,s
		LDA	InsRac,sf
		STA	-2,s
		CALL	Compare		; On compare le mot à la racine
		LDA	0,s
		ADDSP	2,i
		BREQ	InsInc
		BRGT	InsGT
		BRLT	InsLT

	InsInc:	LDX	2,i		; On incrémente le nb d'occurences
		LDA	InsRac,sxf
		ADDA	1,i
		STA	InsRac,sxf
		BR	InsFin

	InsLT:	LDA	InsMot,s	; Si le mot est plus petit, on vérifie avec le mot
		STA	-4,s		; à la gauche de la racine
		LDX	4,i
		LDA	InsRac,sxf
		STA	-2,s
		SUBSP	4,i
		CALL	Inser
		ADDSP	2,i
		BR	InsFin
	
	InsGT:	LDA	InsMot,s	; Si le mot est plus grand, on vérifie avec le mot
		STA	-4,s		; à la droite de la racine
		LDX	6,i
		LDA	InsRac,sxf
		STA	-2,s
		SUBSP	4,i
		CALL	Inser
		ADDSP	2,i
				
	InsFin:	LDA	InsRegA,s
		LDX	InsRegX,s
		ADDSP	8,i
		RET0	
