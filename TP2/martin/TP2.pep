
		LDA 	mot,i
		STA 	-4,s	; Empiler l'adresse de mot
		LDA 	TA_MAX,i
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
	
;--------- TESTS ---	---------
	
		LDX 	0,i
	boucle:	CPX 	nblet,d		
		BRGE	finBouc
		CHARO	mot,x
		ADDX	1,i
		BR 	boucle
	finBouc:CHARO	'\n',i
		
		LDX 	0,i
	bouc1:	CPX 	nblet,d		
		BRGE 	finBou1
		CHARO 	motConv,x
		ADDX 	1,i
		BR 	bouc1
	finBou1:CHARO 	'\n',i

;--------- FIN TESTS ------------
	

		STOP

	
	TA_MAX:	.EQUATE	20
	mot:	.BLOCK 20
	motConv:.BLOCK 20
	nblet:	.WORD 0
	msgSai:	.ASCII "Veuillez entre une chaine: \x00"
	
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