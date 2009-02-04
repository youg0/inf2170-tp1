	STRO msgInv,d
	DECI mois,d
	DECI annee,d
	DECI jour,d
	
finPris:LDX mois,d
	SUBX 1,i
	ASLX
	STX temp2,d
	ASLX
	STX temp,d
	ASLX 
	ADDX temp,d

	ADDX jan,i
	STX adMot,d

	LDX temp2,d
	ASLX
	LDX temp2,d
	ADDX jMjan,i
	STX jMax,d
	
	LDX jour,d
	DECO jour,d
	CPX jMax,i
	BRGT erreur
	
	STRO adMot,n	
	DECO jMax,n
	STOP

erreur:	STRO msgErr,d
	STRO msgInv,d
	DECI mois,d
	DECI annee,d
	DECI jour,d
	BR finPris

	temp: 	.WORD 0
	temp2: 	.WORD 0
	jour:	.WORD 0
	annee:	.WORD 0
	mois:	.WORD 0
	jMax:	.WORD 0

	jMjan:	.WORD 31
	jMfev:	.WORD 28
	jMmar:	.WORD 31
	jMavr:	.WORD 30
	jMmai:	.WORD 31
	jMjuin:	.WORD 30
	jMjuil:	.WORD 31
	jMaou:	.WORD 31
	jMsept:	.WORD 30
	jMoct:	.WORD 31
	jMnov:	.WORD 30
	jMdec:	.WORD 31
	
	adMot:	.ASCII " "

	jan:	.ASCII	" janvier   \x00"
	fev:	.ASCII	" février   \x00"
	mar:	.ASCII	" mars      \x00"
	avr:	.ASCII	" avril     \x00"
	mai:	.ASCII	" mai       \x00"
	juin:	.ASCII	" juin      \x00"
	juil:	.ASCII	" juillet   \x00"
	aou:	.ASCII	" août      \x00"
	sept:	.ASCII	" septembre \x00"
	oct:	.ASCII	" octobre   \x00"
	nov:	.ASCII	" novembre  \x00"
	dec:	.ASCII	" décembre  \x00"

	msgInv:	.ASCII	" Entrez une date (jj Mmm aaaa): \x00"
	msgErr:	.ASCII	" Données erronées \x00"


		.END
