; /// Stereo Frame Creator - KOSS 1999 ///

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
	
	; Cherche premiere image
	
	clr.w	-(SP)
	pea	FrameMask
	move.w	#$4E,-(SP)	; - F_SFIRST -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	cmpi.w	#$FFCF,D0
	BEQ	Exit

	moveq.w	#1,D7

	; Cherche les images suivantes
	
FileSearchLoop	move.w	#$4F,-(SP)	; - F_SNEXT -
	trap	#1	; *** GEMDOS ***
	addq.l	#2,SP
	
	cmpi.w	#$FFCF,D0
	BEQ	MemoNext
	
	addq.w	#1,D7
	
	BRA	FileSearchLoop
	
	; Taille m‚moire disponible
	
MemoNext	clr.w	-(SP)	; ST-Ram
	move.l	#-1,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	; On coupe en images de 42240 octets
	
	clr.l	D1
	divu.l	#42240,D1:D0
	cmp.w	D0,D7
	BMI	SelectLenght
	move.w	D0,D7
SelectLenght	move.w	D7,MovieLenght
	mulu.l	#42240,D7
	
	; On reserve la plus grande taille disponible
	
	clr.w	-(SP)	; ST-Ram
	move.l	D7,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP

	move.l	D0,MovieStart
	
	; On cherche l'adresse de l'‚cran (ne sert … rien ici)
	
	move.w	#2,-(SP)	; - PHYSBASE -
	trap	#14	; *** XBIOS ***
	addq.l	#2,SP
	
	move.l	D0,ScreenStart

	; heu...

	move.w	MovieLenght,D7
	subq.w	#1,D7	; MovieLenght
	move.l	MovieStart,A5

	; On charge l'image

LoadLoop	clr.w	-(SP)
	pea	FramePathLeft
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	tst.l	D0
	BMI	ErrorLoad
	
	move.w	D0,D6
	
	pea	FrameBufferLeft
	move.l	#63378,-(SP)
	move.w	D0,-(SP)
	move.w	#$3F,-(SP)	; - F_READ -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	move.w	D6,-(SP)
	move.w	#$3E,-(SP)	; - F_CLOSE -
	trap	#1	; *** GEMDOS ***
	addq.l	#4,SP

	clr.w	-(SP)
	pea	FramePathRight
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	tst.l	D0
	BMI	ErrorLoad
	
	move.w	D0,D6
	
	pea	FrameBufferRight
	move.l	#63378,-(SP)
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
	
	lea	FrameBufferLeft+18,A0
	lea	FrameBufferRight+18,A1
	move.w	#119,D6

ScanYLoop	move.w	#175,D5

ScanXLoop	; Pixel Gauche

	clr.w	D0
	clr.w	D1
	clr.w	D2

	move.b	(A0)+,D2
	move.b	(A0)+,D1
	move.b	(A0)+,D0
	
	fmove.w	D0,FP0
	fmove.w	D1,FP1
	fmove.w	D2,FP2
	
	fmove.x	#0.299,FP3
	fmove.x	#0.5786,FP4
	fmove.x	#0.114,FP5
	fmove.x	#0,FP6	; !
	
	fmul.x	FP3,FP0
	fmul.x	FP4,FP1
	fmul.x	FP5,FP2
	
	fadd.x	FP0,FP1
	fadd.x	FP2,FP1
	fadd.x	FP6,FP1

	fmove.x	FP1,FP7

	; Pixel Droit

	move.b	(A1)+,D2
	move.b	(A1)+,D1
	move.b	(A1)+,D0
		
	fmove.w	D0,FP0
	fmove.w	D1,FP1
	fmove.w	D2,FP2
	
	fmove.x	#0.299,FP3
	fmove.x	#0.5786,FP4
	fmove.x	#0.114,FP5
	fmove.x	#0,FP6	; !
	
	fmul.x	FP3,FP0
	fmul.x	FP4,FP1
	fmul.x	FP5,FP2
	
	fadd.x	FP0,FP1
	fadd.x	FP2,FP1
	fadd.x	FP1,FP6
	
	fmove.s	RightRed,FP0
	fmove.s	RightGreen,FP1
	fmove.s	RightBlue,FP2
	
	fmul.x	FP6,FP0
	fmul.x	FP6,FP1
	fmul.x	FP6,FP2

	fmove.s	LeftRed,FP3
	fmove.s	LeftGreen,FP4
	fmove.s	LeftBlue,FP5
	
	fmul.x	FP7,FP3
	fmul.x	FP7,FP4
	fmul.x	FP7,FP5
	
	fadd.x	FP3,FP0
	fadd.x	FP4,FP1
	fadd.x	FP5,FP2
	
	fdiv.x	#2,FP0
	fdiv.x	#2,FP1
	fdiv.x	#2,FP2
	
	fmove.w	FP0,D0
	fmove.w	FP1,D1
	fmove.w	FP2,D2
	
	lsr.w	#3,D0
	ror.w	#5,D0	; Red

	lsr.w	#2,D1
	lsl.w	#5,D1	; Green
	
	lsr.w	#3,D2	; Blue
	
	or.w	D1,D0
	or.w	D2,D0
	
	move.w	D0,(A5)+

	DBF	D5,ScanXLoop

	DBF	D6,ScanYLoop
	
	BRA	NextLoad

ErrorLoad	addq.w	#1,D7
	
NextLoad	clr.l	D0
	clr.l	D1
	move.w	FrameCounter,D0
	addq.w	#1,D0
	move.w	D0,FrameCounter
	
	lea	FrameExtLeft,A0

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
	
	add.l	#$30303030,FrameNumbLeft
	add.b	#$30,FrameNumbLeft+4

	move.l	FrameNumbLeft,FrameNumbRight
	move.b	FrameNumbLeft+4,FrameNumbRight+4

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
FramePathLeft	dc.b	"E:\LEFTS.EYE\"
FrameHeadLeft	dc.b	"FRM"
FrameNumbLeft	dc.b	"00000"
FrameExtLeft	dc.b	".TGA",0

FramePathRight	dc.b	"E:\RIGHT.EYE\"
FrameHeadRight	dc.b	"FRM"
FrameNumbRight	dc.b	"00000"
FrameExtRight	dc.b	".TGA",0

FrameMask	dc.b	"E:\LEFTS.EYE\FRM*.TGA",0

MovieName	dc.b	"J:\TEST.FRM",0

LeftRed	dc.s	1
LeftGreen	dc.s	0
LeftBlue	dc.s	0

RightRed	dc.s	0
RightGreen	dc.s	0.25
RightBlue	dc.s	1


	SECTION	BSS

VSyncWait	ds.w	1
ScreenStart	ds.l	1
MovieStart	ds.l	1
MovieLenght	ds.w	1
FrameCounter	ds.w	1
FrameBufferLeft	ds.b	63378
FrameBufferRight	ds.b	63378
