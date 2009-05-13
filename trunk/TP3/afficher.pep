	AffRegX:	.EQUATE	0
	AffRegA:	.EQUATE 2
	AffRet:		.EQUATE 4
	AffArb:		.EQUATE 6

Afficher:	NOP0
		STX	AffRegX,s
		STA	AffRegA,s
		LDA	AffArb,s
		CPA	0x0000,i	; if (Arbre != NULL)
		BREQ	affFinal		
	

		LDX	4,i
		LDA	AffArb,sxf
		SUBSP	2,i
		CALL 	Afficher	; Afficher(Arbre->gauche)

		LDX	2,i
		CHARO	AffArb,sf	; cout << Arbre->mot
		STRO	" utilisé ",i	
		DECO	AffArb,sxf	; cout << Arbre->compte

		LDX	6,i
		LDA	AffArb,sxf
		SUBSP	2,i
		CALL 	Afficher	; Afficher(Arbre->droite)

affFinal:	LDA	AffRegA,s
		LDX	AffRegX,s
		SUBSP 	8,i