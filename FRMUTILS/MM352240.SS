; /// FRAME PLAYER - KOSS 1999 ///
; Start to create an empty file called TEST.DAT on drive F, this with DEVPAC
; Start MAKMOVIE
; Press a key when it stop, it'll write the data on the disk

; 352*240 > 176*120

	comment	HEAD=7
	
	SECTION	TEXT

	movea.l	(4,SP),A6	; Adresse de la BASEPAGE
	move.l	($C,A6),D0	; Taille du SEGMENT TEXT
	add.l	($14,A6),D0	; Additionne la taille du SEGMENT DATA … D0
	add.l	($1C,A6),D0	; Additionne la taille du SEGMENT BSS … D0
	addi.l	#$100,D0	; Additionne la taille de la BASEPAGE … D0
	addi.l	#$400,D0	; Additionne la taille de la future PILE (Ici, 256 positions longues (1024 OCTETS))
	move.l	D0,D1	; Copie D0 dans D1 (Taille … r‚server)
	move.l	D0,D7
	add.l	A6,D1	; Additionne l'adresse du d‚but du programme avec D1 (La taille … r‚server)
	andi.l	#-2,D1	; Rend D1 pair (Au cas o— il ne l'‚tait pas)
	subq.l	#8,D1	; Garde de la place pour l'adresse de la BASEPAGE
	move.l	(4,SP),D2	; Sauvegarde l'adresse de la BASEPAGE
	movea.l	D1,SP	; Installe l'adresse de fin du programme+place nouvelle PILE dans la PILE
	move.l	D2,(4,SP)	; R‚installe l'adresse de la BASEPAGE
	move.l	D0,-(SP)	; EmPILE la taille … r‚server
	move.l	A6,-(SP)	; EmPILE l'adresse du programme
	clr.w	-(SP)	; R‚serv‚
	move.w	#$4A,-(SP)	; - M_SHRINK -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	clr.w	-(SP)
	pea	FrameMask
	move.w	#$4E,-(SP)	; - F_SFIRST -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	cmpi.w	#$FFCF,D0
	BEQ	Exit

	moveq.w	#1,D7
	
FileSearchLoop	move.w	#$4F,-(SP)	; - F_SNEXT -
	trap	#1	; *** GEMDOS ***
	addq.l	#2,SP
	
	cmpi.w	#$FFCF,D0
	BEQ	MemoNext
	
	addq.w	#1,D7
	
	BRA	FileSearchLoop
	
MemoNext	clr.w	-(SP)	; ST-Ram
	move.l	#-1,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	clr.l	D1
	divu.l	#42240,D1:D0
	cmp.w	D0,D7
	BMI	SelectLenght
	move.w	D0,D7
SelectLenght	move.w	D7,MovieLenght
	mulu.l	#42240,D7
	
	clr.w	-(SP)	; ST-Ram
	move.l	D7,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP

	move.l	D0,MovieStart
	
	move.w	#2,-(SP)	; - PHYSBASE -
	trap	#14	; *** XBIOS ***
	addq.l	#2,SP
	
	move.l	D0,ScreenStart

	move.w	MovieLenght,D7
	subq.w	#1,D7	; MovieLenght
	move.l	MovieStart,A5

LoadLoop	clr.w	-(SP)
	pea	FramePath
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	tst.l	D0
	BMI	ErrorLoad
	
	move.w	D0,D6
	
	pea	FrameBuffer
	move.l	#253458,-(SP)
	move.w	D0,-(SP)
	move.w	#$3F,-(SP)	; - F_READ -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	move.w	D6,-(SP)
	move.w	#$3E,-(SP)	; - F_CLOSE -
	trap	#1	; *** GEMDOS ***
	addq.l	#4,SP
	
	pea	FramePrint
	move.w	#9,-(SP)	; - C_CONWS -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP
	
	lea	FrameBuffer+18,A0
	move.w	#119,D6

ScanYLoop	move.w	#175,D5
ScanXLoop	clr.w	D0
	clr.w	D1
	clr.w	D2
	clr.w	D3

	move.b	(A0),D3
	move.b	(A0+1),D2
	move.b	(A0+2),D1
	
	move.b	(A0+3),D0
	add.w	D0,D3
	move.b	(A0+4),D0
	add.w	D0,D2
	move.b	(A0+5),D0
	add.w	D0,D1

	move.b	(A0+1056),D0
	add.w	D0,D3
	move.b	(A0+1+1056),D0
	add.w	D0,D2
	move.b	(A0+2+1056),D0
	add.w	D0,D1
	
	move.b	(A0+3+1056),D0
	add.w	D0,D3
	move.b	(A0+4+1056),D0
	add.w	D0,D2
	move.b	(A0+5+1056),D0
	add.w	D0,D1
	
	lsr.w	#5,D1	; Red
	lsr.w	#4,D2	; Green
	lsr.w	#5,D3	; Blue
	
	lsl.w	#6,D1
	or.w	D2,D1
	lsl.w	#5,D1
	or.w	D3,D1
	
	move.w	D1,(A5)+
	
	adda.l	#6,A0
	
	DBF	D5,ScanXLoop
	
	adda.l	#1056,A0
	
	DBF	D6,ScanYLoop
	
	BRA	NextLoad

ErrorLoad	addq.w	#1,D7
	
NextLoad	clr.l	D0
	clr.l	D1
	move.w	FrameCounter,D0
	addq.w	#1,D0
	move.w	D0,FrameCounter
	
	lea	FrameExt,A0

	divu.l	#10,D1:D0
	move.b	D1,-(A0)
	clr.l	D1

	divu.l	#10,D1:D0
	move.b	D1,-(A0)
	clr.l	D1

	divu.l	#10,D1:D0
	move.b	D1,-(A0)
	clr.l	D1

	divu.l	#10,D1:D0
	move.b	D1,-(A0)
	clr.l	D1

	divu.l	#10,D1:D0
	move.b	D1,-(A0)
	clr.l	D1
	
	add.l	#$30303030,FrameNumb
	add.b	#$30,FrameNumb+4

	DBF	D7,LoadLoop
	
	move.w	#7,-(SP)	; - C_RAWCIN -
	trap	#1	; *** GEMDOS ***
	addq.l	#2,SP
	
	move.w	#1,-(SP)
	pea	MovieName
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.w	D0,D7
	
	move.w	#2,-(SP)
	move.w	D0,-(SP)
	clr.l	-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP

	clr.l	D0
	move.w	MovieLenght,D0
	mulu.l	#42240,D0
	
	move.l	MovieStart,-(SP)
	move.l	D0,-(SP)
	move.w	D7,-(SP)
	move.w	#$40,-(SP)	; - F_WRITE -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	move.w	D7,-(SP)
	move.w	#$3E,-(SP)	; - F_CLOSE -
	trap	#1	; *** GEMDOS ***
	addq.l	#4,SP
			
Exit	move.w	D0,-(SP)
	move.w	#$4C,-(SP)	; - P_TERM -
	trap	#1	; *** GEMDOS ***
	
	SECTION	DATA
	

FramePrint	dc.b	27,"Y  "
FramePath	dc.b	"D:\MOV\"
FrameHead	dc.b	"FRM"
FrameNumb	dc.b	"00000"
FrameExt	dc.b	".TGA",0

FrameMask	dc.b	"D:\MOV\FRM*.TGA",0

MovieName	dc.b	"K:\TEST.FRM",0

	SECTION	BSS

VSyncWait	ds.w	1
ScreenStart	ds.l	1
MovieStart	ds.l	1
MovieLenght	ds.w	1
FrameCounter	ds.w	1
FrameBuffer	ds.b	253458	; 352*240
