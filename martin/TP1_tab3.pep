
;// Saisie des donnees \\
saisie:	STRO msgInv,d
	DECI jour,d 
	DECI mois,d
	DECI annee,d

;// Calcul et validation \\
valid:	LDX mois,d
	SUBX 1,i
	ASLX
	STX temp2,d	; (mois - 1) * 2, pour le tableau de jours max


	ASLX
	STX temp,d	; (mois - 1) * 4)
	ASLX
	ADDX temp,d	; (mois - 1) * 4 + (mois - 1) * 8
	ADDX jan,i	; Ajouter l'adresse du premier element du tab
	STX adMot,d	; Adresse du mois

	LDX temp2,d
	ADDX jMjan,i	; Ajouter l'adresse du premier element du tab
	STX jMax,d	; Adresse de l'element correspondant au mois

	LDX jour,d
	;DECO jour,d
	CPX jMax,n
	BRGT erreur
	BR cjour
	

erreur:	STRO msgErr,d	
	STRO msgInv,d
	DECI mois,d
	DECI annee,d
	DECI jour,d
	BR saisie

cjour:	LDX jour,d	; Verifier si c'est le dernier jour du mois
	ADDX 1,d;
	STX jour;;ERROR: Addressing mode expected.
	CPA jMax,n
	BRGT djour
	BR affic
djour:	LDX 1,i		; Si c'est le dernier jour du mois
	STX jour,d
	LDX adMot,d
	ADDX 12,i	; Ajouter 12 a l'adresse
	STX adMot,d
affic:	DECO jour,d
	STRO adMot,n



fin:	STOP

;// Variables \\

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
	fev:	.ASCII	" fevrier   \x00"
	mar:	.ASCII	" mars      \x00"
	avr:	.ASCII	" avril     \x00"
	mai:	.ASCII	" mai       \x00"
	juin:	.ASCII	" juin      \x00"
	juil:	.ASCII	" juillet   \x00"
	aou:	.ASCII	" aout      \x00"
	sept:	.ASCII	" septembre \x00"
	oct:	.ASCII	" octobre   \x00"
	nov:	.ASCII	" novembre  \x00"
	dec:	.ASCII	" decembre  \x00"

	msgInv:	.ASCII	" Entrez une date (jj Mmm aaaa): \x00"
	msgErr:	.ASCII	" Donnees erronees \x00"


		.END
