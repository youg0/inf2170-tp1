
FINLIGNE:.EQUATE 0x000a
ESPACE:	.EQUATE 32

;// Saisie des donnees \\
saisie:	LDA 0,i;;;;;;;;;;;;;;;;;;;
	STRO msgInv,d
	CHARO FINLIGNE,i;;;;;;;;;;;;;;;;;;;;;
	CHARO ESPACE,i
	DECI jour,d 
	BREQ fin
	CHARO ESPACE,i
	DECI mois,d 
	CHARO ESPACE,i
	DECI annee,d 

	;DECI jour,d 
	LDA jour,d;;;;;;;;;;;;;;;;;
	BRLT erreurJ
	;;;;;;;;;BREQ fin 

	;DECI mois,d
	LDA mois,d;;;;;;;;;;;;;;;;
	BRLE erreurM;;;;;;;;;;;;
	CPA 12,i
	BRGT erreurM

	;DECI annee,d
	LDA annee,d;;;;;;;;;;;;;;;;;;;
	BRLE erreurA;;;;;;;;;;;

;// Calcul et validation \\
valid:	LDA mois,d
	SUBA 1,i
	ASLA
	STA nbJour,d	; (mois - 1) * 2, pour le tableau de jours max

	ASLA
	STA temp,d	; (mois - 1) * 4)
	ASLA
	ADDA temp,d	; (mois - 1) * 4 + (mois - 1) * 8
	ADDA jan,i	; Ajouter l'adresse du premier element du tab
	ADDA 1,i
	STA nomMois,d	; Adresse du mois
	
	LDA mois,d	; Verifier si c'est fevrier pour verification bissextile
	CPA 2,i
	BREQ testBis

	LDA nbJour,d
	ADDA jMjan,i	; Ajouter l'adresse du premier element du tab
	STA jMax,d	; Adresse de l'element correspondant au mois
	LDA jMax,n
	STA jMaxV,d
	BR compJm

testBis:LDA annee,d
	CPA 400,i
	BRLT debC 	; divid <= 400
	BREQ bPos
debQc: 	SUBA 400,i 	; Verifier si divisible par 400
	CPA 400,i		
	BREQ bPos 	; divid == 400
	BRGT debQc 	; 400 < divid
	BR debC		; Non divisible par 400, passer au test de 100
debC: 	CPA 100,i	; Verifier si divisible par 100
	BREQ bNeg 	; divid == 100 
	BRLT debQ 	; divid < 100
	SUBA 100,i 
	BRGT debC 	; 100 > divid
debQ: 	STA nbJour,d
	ASRA
	ASRA
	ASLA
	ASLA
	CPA nbJour,d
	BREQ bPos
	BR bNeg

bNeg:	LDX 0,i
	STX biss,d
	LDX 28,i
	STX jMaxV,d
	BR compJm
	
bPos:	LDX 1,i
	STX biss,d
	LDX 29,i
	STX jMaxV,d
compJm:	LDA jour,d
	CPA jMaxV,d
	BRGT erreurJ
	;;;;;;;;;;CHARO FINLIGNE,i;;;;;;;;;;;;;
	STRO msgDate,d
	DECO jour,d
	CHARO ESPACE,i
	STRO nomMois,n
	DECO annee,d
	CHARO FINLIGNE,i
	BR vJour

erreurJ:STRO msgErrJ,d
	CHARO FINLIGNE,i;;;;;;;;;;;;;;
	STRO msgErrK,d;;;;;;;;;;;;
	DECO jMaxV,d;;;;;;;;;;;
	CHARO 41,i;;;;;;;;;;;;;
	;;;;;;;;;CHARO msgFin,d	
	CHARO FINLIGNE,i
	CHARO FINLIGNE,i
	BR saisie

erreurM:STRO msgErrM,d
	CHARO FINLIGNE,i;;;;;;;;;;;;;;
	STRO msgErrN,d;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;CHARO msgFin,d	
	CHARO FINLIGNE,i
	CHARO FINLIGNE,i
	BR saisie

erreurA:STRO msgErrA,d
	CHARO FINLIGNE,i;;;;;;;;;;;;;;
	STRO msgErrB,d;;;;;;;;;;;;
	;;;;;;;;;;;;CHARO msgFin,d	
	CHARO FINLIGNE,i
	CHARO FINLIGNE,i
	BR saisie
vJour:	LDA jour,d	; Verifier si c'est le dernier jour du mois
	ADDA 1,i
	STA jour,d
	CPA jMaxV,d
	BRGT dJour
	BR affic

dJour:	LDA 1,i		; Si c'est le dernier jour du mois
	STA jour,d
	LDA nomMois,d
	ADDA 12,i	; Ajouter 12 a l'adresse
	STA nomMois,d
	LDA 144,i	; Enregistrer l'adresse du nombre de mois max
	ADDA jMjan,i	; Ajouter l'addresse du premier mois
	CPA nomMois,d
	BRLE chanAn
	BR affic

chanAn:	LDA 0,i
	LDA jan,i	; Ajouter une annee et mets le mois a Janvier
	STA nomMois,d
	LDA annee,d
	ADDA 1,i
	STA annee,d

affic:	STRO msgDem,d
	LDA mois,d
	ADDA 1,i
	STA mois,d
	LDA 0,i
	DECO jour,d
	CHARO ESPACE,i
	STRO nomMois,n
	DECO annee,d
	CHARO FINLIGNE,i
	CHARO FINLIGNE,i
	BR saisie

;;;	CHARO ESPACE,i
;;;	DECO jour,d
fin:	CHARO FINLIGNE,i
	STRO msgFin,d
	STOP

;// Variables \\

	temp: 	.WORD 0
	nbJour:	.WORD 0
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
	
	nomMois:	.ASCII " "

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

	msgInv:	.ASCII	" Entrez une date (jj mm aaaa) ou 0 pour terminer: \x00";;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	msgErrJ:.ASCII	" Donnee de jour erronee \x00"
	msgErrK:.ASCII	" (Entrez une valeur entre 1 et \x00"
	msgErrM:.ASCII	" Donnee de mois erronee \x00"
	msgErrN:.ASCII	" (Entrez une valeur entre 1 et 12) \x00"
	msgErrA:.ASCII	" Donnee d'année erronee \x00"
	msgErrB:.ASCII	" (Entrez une valeur positive) \x00"
	msgFin:	.ASCII	" Arrêt du programme \x00";;;;;;;;;;;;;;;;;;;;;;;;;;
	msgDate:.ASCII	" Date: \x00"
	msgDem:	.ASCII	" Date du lendemain: \x00"



		.END
