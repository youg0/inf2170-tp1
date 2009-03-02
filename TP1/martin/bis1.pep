
FINLIGNE:.EQUATE 0x000a
    STRO msgInv,d
    DECI divid,d	; Entrer une anne dans divid 
    DECO divid,d
    CHARO FINLIGNE,i

    LDA divid,d
    CPA 400,i
    BRLT debC	;divid < 400
    BREQ fin
debQc:     SUBA 400,i	; Verifier si divisible par 400
    CPA 400,i	; On ne peut mettre quCent
    BREQ fin	;divid  400
    BRGT debQc	;400 < divid
    BR debC	; Non divisible par 400, passer au test de 100
debC:     CPA 100,i    ; Verifier si divisible par 100
    BRLT debQ	;divid < 100
    SUBA 100,i
    CPA 100,i
    BREQ fin1	;divid  100
    BRGT debC	;100 > divid
debQ:     NOP0	; Boucle do while
    SUBA 4,i	; Soustraire 4
    CPA 0,i
    BRGT debQ	; divid > 0
    BRLT fin3	; divid < 0
    BR fin2	; divid == 0

    fin: STRO msg,d
    STOP
    fin1: STRO msg1,d
    STOP
    fin2: STRO msg2,d
    STOP
    fin3: STRO msg3,d
    STOP
    
    msgInv: .ASCII "Entrez une anne: \x00"
    msg: .ASCII "OUI: div. par quatre cents.\x00"
    msg1: .ASCII "NON: div. par cent. \x00"
    msg2: .ASCII "OUI: div. par quatre. \x00"
    msg3: .ASCII "NON: tout court. \x00"
    cent: .WORD 100
    quatre: .WORD 4
    quCent: .WORD 400
    huit: .WORD 8
    divid: .WORD 0
    divis: .WORD 0
    temp: .WORD 0
    
    .END