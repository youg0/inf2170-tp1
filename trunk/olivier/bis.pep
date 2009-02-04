FINLIGNE:.EQUATE 0x000a	
	STRO	msgInv,d
	DECI	divid,d		;entrer une année dans divid	
	DECO 	divid,d	
	CHARO	FINLIGNE,i
	LDA	divid,d	
	CPA	quCent,d
	BRLT	debC		;divid < 400
debQc:	SUBA	quCent,d	
	CPA	quCent,d	
	BREQ	fin		;divid == 400
	BRGT	debQc		;400 > divid
debC:	CPA	cent,d
	BRLT	debH		;divid < 100
	SUBA	cent,d		
	CPA	cent,d		
	BREQ	fin1		;divid == 100
	BRGT	debC		;100 > divid
debH:	CPA	huit,d
	BRLT	debQ		;divid < 8
	SUBA	huit,d
	CPA	huit,d
	BREQ	fin2		;divid == 8
	BRGT	debH		;8 > divid
debQ:	CPA	quatre,d
	BRGT	fin3		;divid < 4
	SUBA	quatre,d
	CPA	quatre,d
	BREQ	fin2		;divid == 4
	BRGT	debQ		;4 > divid
	BR	fin3		;else

	
	
fin:	STRO	msg,d
	STOP	
	
fin1:	STRO	msg1,d
	STOP		

fin2:	STRO	msg2,d
	STOP	

fin3:	STRO	msg3,d
	STOP		












	msgInv:	.ASCII	"Entrez une année: \x00"
	msg:	.ASCII	"OUI: div. par quatre cents.\x00"
	msg1:	.ASCII	"NON: div. par cent. \x00"
	msg2:	.ASCII	"OUI: div. par quatre. \x00"
	msg3:	.ASCII	"NON: tout court. \x00"
	cent:	.WORD	100
	quatre:	.WORD	4
	quCent:	.WORD	400
	huit:	.WORD	8
	divid:	.WORD	0
	divis:	.WORD	0
	temp:	.WORD 	0

		.END
	



