	STRO msgInv,d; afficher msgInv
	DECI mois,d; saisir le mois
	DECI annee,d; saisir annee
	DECI jour,d; ect.
;-------Associer la valeur mois au tableau de Strings-------------------	
finPris:LDX mois,d; laoder mois dans X ou dans d (je ne suis pas certain)
	SUBX 1,i	;Je soustrait 1 de mois
	ASLX; (mois - 1)*2
	STX temp2,d	;(mois - 1)*2 pour le tableau de nombre.
	ASLX		;((mois - 1)*2)*2
	STX temp,d	;Mettre (mois - 1) * 4 dans temp
	ASLX		;((mois - 1)*2)*2)*2
	ADDX temp,d	;additionner *8 au *4 dans temp

	ADDX jan,i	;additionner l'adresse de jan a temp
	STX adMot,d	;mettre dans adMot l'adresse du mois.
 
;-------Associer la valeur mois au tableau de nombres-------------------	
	LDX temp2,d	;loader temp2 (mois-1)*4
	ADDX jMjan,i	;additionner l'adresse de jMjan a temp
	STX jMax,d	;mettre l'adresse dans jMax
	
	LDX jour,d	;loader jour 
	DECO jour,d	;afficher jour 
	CPX jMax,i	;compare avec jMax (ne fonctionne pas)
	BRGT erreur	;envoyer à erreur si le test greate then
			;fonctionne (ça non plus ça ne marche pas)
	
	STRO adMot,n	;afficher le string du mois en passant par l'adresse 
			; ,n = lien indirecte.	
	DECO jMax,n	;afficher jMax
	STOP

erreur:	STRO msgErr,d	;dans le cas où l'erreur est appelée (ça ne marche pas
	STRO msgInv,d
	DECI mois,d
	DECI annee,d
	DECI jour,d
	BR finPris ; retour à finPris 

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
