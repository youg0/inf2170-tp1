
		LDA 	mot,i
		STA 	-4,s	; Empiler l'adresse de mot
		LDA 	20,i
		STA 	-2,s	; Empiler le nombre 20 (taille)
		SUBSP 	4,i
		STRO 	msgSai,d
		CALL 	LirChain
		LDA 	0,s		; Désempiler la taille de la chaine entrée
		STA 	nblet,d
		ADDSP	2,i	; Nettoyer pile

		
		LDA 	nblet,d
		STA 	-8,s	; Empiler taille
		LDA 	ASCII,i
		STA 	-6,s	; Empiler addresse des caracteres accentués
		LDA 	mot,i
		STA 	-4,s	; Empiler addresse de début de chainer a traiter
		LDA 	motConv,i
		STA 	-2,s	; Empiler addresse où retourner chaine traitée
		SUBSP 	8,i	
		CALL	 MinusAcc

		LDA 	nblet,d
		STA 	-10,s	; Empiler taille
		LDA	nbletN,i
		STA	-8,S	;
		LDA 	invalid,i
		STA 	-6,s	; Empiler addresse des caracteres accentués
		LDA 	motConv,i
		STA 	-4,s	; Empiler addresse de début de chainer a traiter
		LDA 	motClea,i
		STA 	-2,s	; Empiler addresse où retourner chaine traitée
		SUBSP 	10,i	
		CALL	DelInv
		ADDSP	10,i

;--------- TESTS ---	---------
		CHARO	'\n',i
		LDX 	0,i
	bou1:	CPX 	nblet,d		
		BRGE	finBou1
		CHARO	mot,x
		ADDX	1,i
		BR 	bou1
	finBou1:CHARO	'\n',i

		LDX 	0,i
	bou2:	CPX 	nblet,d		
		BRGE	finBou2
		CHARO	motConv,x
		ADDX	1,i
		BR 	bou2
	finBou2:CHARO	'\n',i
		
		LDX 	0,i
	bou3:	CPX 	nbletN,d		
		BRGE 	finBou3
		CHARO 	motClea,x
		ADDX 	1,i
		BR 	bou3
	finBou3:CHARO 	'\n',i
		DECO	nbletN,d

;--------- FIN TESTS ------------

		STOP

	mot:	.BLOCK 	20	; Chaine d'origine
	motConv:.BLOCK 	20	; Chaine apres enlever les accents
	motClea:.BLOCK 	20	; Chaine apres enlever les espaces et ponctuation
	nblet:	.WORD 	0	; Taille de chaine d'origine
	nbletN:	.WORD	0	; Taille de la chaine apres traitement

	msgSai:	.ASCII "Veuillez entre une chaine: \x00"
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
	bouc3:	CPX	Temp,s		; boucle pour bouger de 1 octet vers la gauche
		BRGE	fin3		; if (x < 8)
		ADDX	1,i
		ASLA
		BR 	bouc3
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


	; sous-programme MinusAcc
	; transforme une chaine passee en parametre en minuscules sans accents
	; ou en minuscules avec accents; les lettres minuscules et chiffres
	; normaux ne sont pas modifies seuls les caracteres majuscules sont
	; modifies
	;     appel:  empiler adresse chaine resultat
	;             empiler adresse chaine originale
	;             empiler adresse table de conversion
	;             empiler longueur chaine a convertir
	;             CALL    MinusAcc
	;
	; Philippe Gabrini   novembre 2005
	;
	EAcode:   .EQUATE 0        ; Index table
	EAindice: .EQUATE 2        ; Index chaine
	EAVieuxX: .EQUATE 4        ;
	EAVieuxA: .EQUATE 6        ;
	EAAdRet:  .EQUATE 8        ; Adresse retour
	EAlongM:  .EQUATE 10       ; longueur chaine
	EAtable:  .EQUATE 12       ; Addresse de la table de conversion
	EAadrCh:  .EQUATE 14       ; Addresse de la chaine originale
	EAminus:  .EQUATE 16       ; Addresse de la chaine minuscule
	;                            ;void MinusAcc() {
	MinusAcc:SUBSP   8,i         ;  espace local sauvegarde
	         STA     EAVieuxA,s  ;  sauvegarde A
	         STX     EAVieuxX,s  ;  sauvegarde X
	         LDX     0,i         ;
	         STX     EAindice,s  ;  indice caractere original = 0
	         LDA     0,i         ;  nul
	EArepete:LDX     EAindice,s  ;  while(chaine[i] != NULL) {
	         LDBYTEA EAadrCh,sxf ;    car = chaine[i]
	         STA     EAcode,s    ;    utilise indice table
	         LDX     EAcode,s    ;
	         LDBYTEA EAtable,sxf ;    caractere de remplacement
	         LDX     EAindice,s  ;
	         STBYTEA EAminus,sxf ;    chaine[i] = ASCII(car);
	         ADDX    1,i         ;    caractere suivant
	         STX     EAindice,s  ;
	         CPX     EAlongM,s   ;    fin mot?
	         BRLT    EArepete    ;  }//while
	EAfin:   LDA     EAAdRet,s   ; adresse retour
	         STA     EAminus,s   ; deplacee
	         LDA     EAVieuxA,s  ; restaure A
	         LDX     EAVieuxX,s  ; restaure X
	         ADDSP   16,i        ; nettoyer pile
         RET0


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


; table de conversion des codes ASCII en lettres minuscules non accentuees

ASCII:.BYTE 0
      .BYTE 1
      .BYTE 2
      .BYTE 3
      .BYTE 4
      .BYTE 5
      .BYTE 6
      .BYTE 7
      .BYTE 8
      .BYTE 9
      .BYTE 10
      .BYTE 11
      .BYTE 12
      .BYTE 13
      .BYTE 14
      .BYTE 15
      .BYTE 16
      .BYTE 17
      .BYTE 18
      .BYTE 19
      .BYTE 20
      .BYTE 21
      .BYTE 22
      .BYTE 23
      .BYTE 24
      .BYTE 25
      .BYTE 26
      .BYTE 27
      .BYTE 28
      .BYTE 29
      .BYTE 30
      .BYTE 31
      .BYTE 32
      .BYTE 33
      .BYTE 34
      .BYTE 35
      .BYTE 36
      .BYTE 37
      .BYTE 38
      .BYTE 39
      .BYTE 40
      .BYTE 41
      .BYTE 42
      .BYTE 43
      .BYTE 44
      .BYTE 45
      .BYTE 46
      .BYTE 47
      .BYTE 48
      .BYTE 49
      .BYTE 50
      .BYTE 51
      .BYTE 52
      .BYTE 53
      .BYTE 54
      .BYTE 55
      .BYTE 56
      .BYTE 57
      .BYTE 58
      .BYTE 59
      .BYTE 60
      .BYTE 61
      .BYTE 62
      .BYTE 63
      .BYTE 64
      .BYTE 97     ; A
      .BYTE 98     ; B
      .BYTE 99     ; C
      .BYTE 100    ; D
      .BYTE 101    ; E
      .BYTE 102    ; F
      .BYTE 103    ; G
      .BYTE 104    ; H
      .BYTE 105    ; I
      .BYTE 106    ; J
      .BYTE 107    ; K
      .BYTE 108    ; L
      .BYTE 109    ; M
      .BYTE 110    ; N
      .BYTE 111    ; O
      .BYTE 112    ; P
      .BYTE 113    ; Q
      .BYTE 114    ; R
      .BYTE 115    ; S
      .BYTE 116    ; T
      .BYTE 117    ; U
      .BYTE 118    ; V
      .BYTE 119    ; W
      .BYTE 120    ; X
      .BYTE 121    ; Y
      .BYTE 122    ; Z
      .BYTE 91
      .BYTE 92
      .BYTE 93
      .BYTE 94
      .BYTE 95
      .BYTE 96
      .BYTE 97     ; a
      .BYTE 98     ; b
      .BYTE 99     ; c
      .BYTE 100    ; d
      .BYTE 101    ; e
      .BYTE 102    ; f
      .BYTE 103    ; g
      .BYTE 104    ; h
      .BYTE 105    ; i
      .BYTE 106    ; j
      .BYTE 107    ; k
      .BYTE 108    ; l
      .BYTE 109    ; m
      .BYTE 110    ; n
      .BYTE 111    ; o
      .BYTE 112    ; p
      .BYTE 113    ; q
      .BYTE 114    ; r
      .BYTE 115    ; s
      .BYTE 116    ; t
      .BYTE 117    ; u
      .BYTE 118    ; v
      .BYTE 119    ; w
      .BYTE 120    ; x
      .BYTE 121    ; y
      .BYTE 122    ; z
      .BYTE 123
      .BYTE 124
      .BYTE 125
      .BYTE 126
      .BYTE 127
      .BYTE 128
      .BYTE 129
      .BYTE 130
      .BYTE 131
      .BYTE 132
      .BYTE 133
      .BYTE 134
      .BYTE 135
      .BYTE 136
      .BYTE 137
      .BYTE 138
      .BYTE 139
      .BYTE 140
      .BYTE 141
      .BYTE 142
      .BYTE 143
      .BYTE 144
      .BYTE 145
      .BYTE 146
      .BYTE 147
      .BYTE 148
      .BYTE 149
      .BYTE 150
      .BYTE 151
      .BYTE 152
      .BYTE 153
      .BYTE 154
      .BYTE 155
      .BYTE 156
      .BYTE 157
      .BYTE 158
      .BYTE 159
      .BYTE 160
      .BYTE 161
      .BYTE 162
      .BYTE 163
      .BYTE 164
      .BYTE 165
      .BYTE 166
      .BYTE 167
      .BYTE 168
      .BYTE 169
      .BYTE 170
      .BYTE 171
      .BYTE 172
      .BYTE 173
      .BYTE 174
      .BYTE 175
      .BYTE 176
      .BYTE 177
      .BYTE 178
      .BYTE 179
      .BYTE 180
      .BYTE 181
      .BYTE 182
      .BYTE 183
      .BYTE 184
      .BYTE 185
      .BYTE 186
      .BYTE 187
      .BYTE 188
      .BYTE 189
      .BYTE 190
      .BYTE 191
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 99     ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 100    ; �
      .BYTE 110    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 215
      .BYTE 111    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 121    ; �
      .BYTE 222
      .BYTE 223
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 97     ; �
      .BYTE 99     ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 101    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 105    ; �
      .BYTE 240
      .BYTE 110    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 111    ; �
      .BYTE 247
      .BYTE 111    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 117    ; �
      .BYTE 121    ; �
      .BYTE 254
      .BYTE 121    ; �

	.END