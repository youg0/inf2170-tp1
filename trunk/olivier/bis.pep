FINLIGNE:.EQUATE 0x000a
	STRO msgInv,d
	DECI divid,d 	; Entrer une anne dans divid 
	DECO divid,d 
	CHARO FINLIGNE,i
	LDA divid,d 
	CPA quCent,d
	BRLT debC 	;divid < 400
debQc: 	SUBA quCent,d 	; Verifier si divisible par 400
	CPA quCent,d 
	BREQ fin 	;divid == 400
	BRGT debQc 	;400 < divid
	BR debC		; Non divisible par 400, passer au test de 100
debC: 	CPA cent,d	; Verifier si divisible par 100
	BRLT debQ 	;divid < 100
	SUBA cent,d 
	CPA cent,d 
	BREQ fin1 	;divid == 100
	BRGT debC 	;100 > divid
debQ: 	STA temp2,d
	ASRA
	ASRA
	ASLA
	ASLA
	CPA temp2,d
	BREQ fin
	BR fin1

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
