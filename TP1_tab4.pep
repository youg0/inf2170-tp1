; #/pep8
; Ce programme demande a l'utilisateur d'entrer une date en format numerique
; (JJ MM AAAA), ensuite il affiche celle-ci en remplacant le numero de mois par
; son nom. Il affiche egalement la date du lendemain. Ce programme verifie
; si l'annee est bissextile, si la date entree est le dernier jour du mois
; et/ou de l'annee. Il verifie la validite des informations entrees par l'usager
; avant de faire quelque calcul que ce soit.

FINLIGNE:.EQUATE 0x000a
ESPACE:	.EQUATE 32

;// Saisie des donnees \\
saisie:	LDA 0,i
	STRO msgInv,d		; cout << msgInv;
	CHARO FINLIGNE,i	; cout << endl;
	CHARO ESPACE,i		; cout << " ";
	DECI jour,d 		; cin >> jour;
	BREQ fin			; if (jour == 0) fin;		
	CHARO ESPACE,i		; cout << " ";
	DECI mois,d 		; cin >> mois;
	CHARO ESPACE,i		; cout << endl;
	DECI annee,d 		; cin >> annee;
	LDA jour,d		;				
	BRLT erreurJ		;
	LDA mois,d		;
	CPA 12,i			; if(mois > 12)
	BRGT erreurM		;	erreurM
	LDA annee,d		;
	BRLE erreurA		;

;// Calcul et validation \\
valid:	LDA mois,d		; Trouver indice des tableaux
	SUBA 1,i
	ASLA
	STA nbJour,d		; (mois - 1) * 2, pour le tableau de jours max

	ASLA
	STA temp,d		; (mois - 1) * 4)
	ASLA
	ADDA temp,d		; (mois - 1) * 4 + (mois - 1) * 8
	ADDA jan,i		; Ajouter l'adresse du premier element du tab

	STA nomMois,d		; Adresse du mois
	
	LDA mois,d		; Verifier si c'est fevrier pour verification bissextile
	CPA 2,i
	BREQ testBis

	LDA nbJour,d
	ADDA jMjan,i		; Ajouter l'adresse du premier element du tab
	STA jMax,d		; Adresse de l'element correspondant au mois
	LDA jMax,n
	STA jMaxV,d
	BR compJm

testBis:LDA annee,d		
	CPA 400,i		
	BRLT debC 		; if (annee < 400) debc;
	BREQ bPos		; if (annee == 400) bPos;

; // Verifier si divisible par 400 \\
debQc: 	NOP0			; do {
	SUBA 400,i 		; 	annee -= 400
	CPA 400,i		
	BRGT debQc 		; } while (annee > 400)
	BREQ bPos 		; if(annee == 400) bPos;
	BR debC			; else debc;

; // Verifier si divisible par 100 \\
debC: 	NOP0			; do {
	CPA 100,i		; 
	BREQ bNeg 		; 	if(annee == 100) bNeg;
	BRLT debQ 		; 	if(annee < 100) debQ;
	SUBA 100,i 		;	annee -= 100;
	BRGT debC 		; } while (annee > 100)

; // Verifier si divisible par 4 \\
debQ: 	STA temp,d	
	ASRA
	ASRA
	ASLA
	ASLA
	CPA temp,d		; Division entiere par 4 et multiplication par 4
	BREQ bPos		; if(((annee \ 4) * 4) == annee) bPos;
	BR bNeg			; else bNeg

; // Annee non bissextile \\
bNeg:	LDX 0,i
	STX biss,d		; int biss = 0; // Variable a utilisation booleene
	LDX 28,i
	STX jMaxV,d		; int jMaxV = 28; // Variable pour le nb de jour du mois
	BR compJm		

; // Annee bissextile \\	
bPos:	LDX 1,i
	STX biss,d		; int biss = 1; // Variable a utilisation booleene
	LDX 29,i
	STX jMaxV,d		; int jMaxV = 29; // Variable pour le nb de jour du mois

; // 
compJm:	LDA jour,d
	CPA jMaxV,d
	BRGT erreurJ		; if(jour > jMax) erreurj;
	STRO msgDate,d		; cout << msgDate;
	DECO jour,d		; cout << jour;
	CHARO ESPACE,i		; cout << " ";
	STRO nomMois,n		; cout << nomMois;
	DECO annee,d		; cout << annee;
	CHARO FINLIGNE,i	; cout < endl;
	BR vJour	

; // Message d'erreur si le jour depasse le nb de jour du mois \\
erreurJ:STRO msgErrJ,d		; cout << "Donnee de jour erronee";
	CHARO FINLIGNE,i	; cout << endl;
	STRO msgErrK,d		; cout << "(Entrez une valeur entre 1 et ";
	DECO jMaxV,d		; cout << jMaxV;
	CHARO 41,i		; cout << ")";
	CHARO FINLIGNE,i	; cout << endl;
	CHARO FINLIGNE,i	; cout << endl;
	BR saisie

; // Message d'erreur si le mois depasse le nombre de mois max (12) \\
erreurM:STRO msgErrM,d		; cout << "Donnee de mois erronee"
	CHARO FINLIGNE,i	; cout << endl;
	STRO msgErrN,d		; cout << "(Entrez une valeur entre 1 et 12)";
	CHARO FINLIGNE,i	; cout << endl;
	CHARO FINLIGNE,i	; cout << endl;
	BR saisie

; // Message d'erreur si l'annee entree n'est pas valide
erreurA:STRO msgErrA,d		; cout << "Donnee d'annee erronee";
	CHARO FINLIGNE,i	; cout << endl;
	STRO msgErrB,d		; cout << "(Entrez une valeur positive)";
	CHARO FINLIGNE,i	; cout << endl;
	CHARO FINLIGNE,i	; cout << endl;
	BR saisie

; // Verifier si c'est le dernier jour du mois \\
vJour:	LDA jour,d
	ADDA 1,i
	STA jour,d		; jour += 1;
	CPA jMaxV,d
	BRGT dJour		; if(jour > jMaxV) djour;
	BR affic		; 	else affic;

; // Si c'est le dernier jour du mois \\
dJour:	LDA 1,i
	STA jour,d		; jour = 1;
	LDA nomMois,d
	ADDA 12,i
	STA nomMois,d		; nomMois[indice]; indice += 1;
	LDA 144,i		
	ADDA jMjan,i		
	CPA nomMois,d
	BRLE chanAn		; if(indice => 11) chanAn;
	BR affic		; 	else affic;


; // Ajouter une annee et mettre le mois a Janvier \\
chanAn:	LDA 0,i
	LDA jan,i
	STA nomMois,d		; nomMois = jan;
	LDA annee,d		
	ADDA 1,i		
	STA annee,d		; annee += 1;

; // Afficher la date du lendemain \\
affic:	STRO msgDem,d		; cout << "Date du lendemain: ";
	LDA mois,d
	ADDA 1,i
	STA mois,d		; mois += 1;
	LDA 0,i			
	DECO jour,d		; cout << jour;
	CHARO ESPACE,i		; cout << " ";
	STRO nomMois,n		; cout << nomMois;
	DECO annee,d		; cout << annee;
	CHARO FINLIGNE,i	; cout << endl;
	CHARO FINLIGNE,i	; cout << endl;
	BR saisie		; Retourner a la saisie

fin:	CHARO FINLIGNE,i	; cout << endl;
	STRO msgFin,d		; cout << " Arret du programme";
	STOP

; // Variables \\

	temp: 	.WORD 0		; Variable temporaire
	nbJour:	.WORD 0		;
	jour:	.WORD 0		; Jour (entree par usager)
	annee:	.WORD 0		; Annee (entree par usager)
	mois:	.WORD 0		; Mois (entree par usager)
	jMax:	.WORD 0		; Nombre de jours du mois
	jMaxV:	.WORD 0		; jMax apres verification d'annee bissextile
	biss:	.WORD 0		; Annee bissextile (0 = false / 1 = true)

; // Tableau de nombres de jours pour chaque mois \\
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
; // Tableau pour le nom de chaque mois numerique \\
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

; // Messages a afficher a l'usager \\
	msgInv:	.ASCII	" Entrez une date (jj mm aaaa) ou 0 pour terminer: \x00"
	msgErrJ:.ASCII	" Donnee de jour erronee \x00"
	msgErrK:.ASCII	" (Entrez une valeur entre 1 et \x00"
	msgErrM:.ASCII	" Donnee de mois erronee \x00"
	msgErrN:.ASCII	" (Entrez une valeur entre 1 et 12) \x00"
	msgErrA:.ASCII	" Donnee d'anne erronee \x00"
	msgErrB:.ASCII	" (Entrez une valeur positive) \x00"
	msgFin:	.ASCII	" Arrt du programme \x00"
	msgDate:.ASCII	" Date: \x00"
	msgDem:	.ASCII	" Date du lendemain: \x00"



		.END
