heappnt:.ADDRSS heap ; initialement pointe à heap
heap:    .BLOCK 255  ; espace heap; dépend du systéme
         .BLOCK 255  ; espace heap; dépend du systéme
      ......
         .BLOCK 255  ; espace heap; dépend du systéme
heaplmt:.BYTE    0   ;


; Le sous-programme new alloue la taille demandée et place l'adresse
; de la zone dans le pointeur dont l'adresse est passée en paramètre.
NvieuxX: .EQUATE 0     ; sauvegarde X
NvieuxA: .EQUATE 2     ; sauvegarde A
NadRet: .EQUATE 4      ; adresse retour
Npoint: .EQUATE 6      ; adresse pointeur à remplir
Ntaille: .EQUATE 8     ; taille requise
;                            ;void new(int taille, int *&pointeur) {
new:     SUBSP    4,i        ; espace local
         STA      NvieuxA,s ; sauvegarder A
         STX      NvieuxX,s ; sauvegarder X
         LDA      heappnt,d ;
         STA      Npoint,sf ; adresse retournée
         LDA      Ntaille,s ; taille du noeud
         ADDA     1,i        ; arrondir à pair
         ANDA     0xFFFE,i   ;
         ADDA     heappnt,d ; nouvelle valeur
         CPA      heaplmt,i ;
         BRGT     new0       ; si pas dépassé la limite du heap
         STA      heappnt,d ;     mettre à jour heappnt
         BR       new1       ;    et terminer
new0:    LDA      0,i        ; sinon
         STA      Npoint,sf ;     mettre pointeur à NULL
new1:    LDA      NadRet,s   ; déplacer adresse retour
         STA      Ntaille,s ;
	 LDA   NvieuxA,s ; restaurer A
	 LDX   NvieuxX,s ; restaurer X
	 ADDSP 8,i       ; nettoyer pile
	 RET0            ; return; }



