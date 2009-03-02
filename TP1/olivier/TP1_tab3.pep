

;// Saisie des donnees \\
saisie:	STRO msgInv,d
	DECI jour,d 
	DECI mois,d
	DECI annee,d

;// Calcul et validation \\
valid:	LDA mois,d
	SUBA 1,i
	ASLA
	STA temp2,d	; (mois - 1) * 2, pour le tableau de jours max


	ASLA
	STA temp,d	; (mois - 1) * 4)
	ASLA
	ADDA temp,d	; (mois - 1) * 4 + (mois - 1) * 8
	ADDA jan,i	; Ajouter l'adresse du premier element du tab
	STA adMot,d	; Adresse du mois
	
	LDA mois,d	; Verifier si c'est fevrier pour verification bissextile
	CPA 2,i
	BREQ bis

nonbis:	LDA temp2,d
	ADDA jMjan,i	; Ajouter l'adresse du premier element du tab
	STA jMax,d	; Adresse de l'element correspondant au mois
	LDA jMax,n
	STA jMaxV,d
	BR comp

bis:	LDA annee,d
	CPA 400,i
	BRLT debC 	; divid <= 400
	BREQ bPos

debQc: 	SUBA 400,i 	; Verifier si divisible par 400
	CPA 400,i		
	BREQ bPos 	; divid == 400
	BRGT debQc 	; 400 < divid
	BR debC		; Non divisible par 400, passer au test de 100

debC: 	CPA 100,i	; Verifier si divisible par 100
	BRLT debQ 	; divid < 100
	SUBA 100,i 
	CPA 100,i 
	BREQ bNeg 	; divid == 100
	BRGT debC 	; 100 > divid

debQ: 	STA temp2,d
	ASRA
	ASRA
	ASLA
	ASLA
	CPA temp2,d
	BREQ bPos
	BR bNeg

bNeg:	LDX 0,i
	STX biss,d
	LDX 28,i
	STX jMaxV,d
	BR comp
	
bPos:	LDX 1,i
	STX biss,d
	LDX 29,i
	STX jMaxV,d
	
comp:	LDA jour,d
	CPA jMaxV,d
	BRGT erreur
	BR cjour
	

erreur:	STRO msgErr,d	
	STRO msgInv,d
	DECI mois,d
	DECI annee,d
	DECI jour,d
	BR saisie

cjour:	LDA jour,d	; Verifier si c'est le dernier jour du mois
	ADDA 1,i
	STA jour,d
	CPA jMaxV,d
	BRGT djour
	BR affic
djour:	LDA 1,i		; Si c'est le dernier jour du mois
	STA jour,d
	LDA adMot,d
	ADDA 12,i	; Ajouter 12 a l'adresse
	STA adMot,d
	LDA 144,i	; Enregistrer l'adresse du nombre de mois max
	ADDA jMjan,i	; Ajouter l'addresse du premier mois
	CPA adMot,d
	BRLE aannee
	BR affic
aannee:	LDA jan,i	; Ajouter une annee et mets le mois a Janvier
	STA adMot,d
	LDA annee,d
	ADDA 1,i
	STA annee,d

affic:	DECO jour,d
	LDA adMot,d
	ADDA 1,i
	STA adMot,d
	STRO adMot,n
	DECO annee,d



fin:	STOP

;// Variables \\

	temp: 	.WORD 0
	temp2: 	.WORD 0
	jour:	.WORD 0
	annee:	.WORD 0
	mois:	.WORD 0
	jMax:	.WORD 0
	jMaxV:	.WORD 0		;jMax apres verification d'annee bissextile
	biss:	.WORD 0

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

	jan:	.ASCII	"  janvier   \x00"
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
