; /// FRAME PLAYER - KOSS 1999 ///
; Start to create an empty file called TEST.DAT on drive F, this with DEVPAC
; Start MAKMOVIE
; Press a key when it stop, it'll write the data on the disk

; 240*180 > 176*120

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
	
	BSR	StartEndBlack

LoadLoop	clr.w	-(SP)
	pea	FramePath
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	tst.l	D0
	BMI	ErrorLoad
	
	move.w	D0,D6
	
	pea	FrameBuffer
	move.l	#129618,-(SP)
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
	
	move.w	#120-1,D6
	
	clr.w	D4	; ..YY

ScanYLoop	move.w	#160-1,D5
	
	swap	D4
	clr.w	D4	; YYXX

ScanXLoop	clr.l	D0
	clr.l	D1
	clr.l	D2
	clr.l	D3

	cmpi.l	#$00000000,D4
	BEQ	ScanPixel0
	
	cmpi.l	#$0000FFFF,D4
	BEQ	ScanPixel1
	
	cmpi.l	#$FFFF0000,D4
	BEQ	ScanPixel2
	
	cmpi.l	#$FFFFFFFF,D4
	BEQ	ScanPixel3

	; 42
	; 21
	
ScanPixel0	move.b	(2,A0),D0	; Red0
	move.b	(1,A0),D1	; Green0
	move.b	(A0),D2	; Blue0
	
	lsl.w	#2,D0	; *4
	lsl.w	#2,D1	; *4
	lsl.w	#2,D2	; *4

	move.b	(5,A0),D3	; Red1
	add.w	D3,D0
	add.w	D3,D0

	move.b	(4,A0),D3	; Green1
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(3,A0),D3	; Blue1
	add.w	D3,D2
	add.w	D3,D2

	move.b	(2+720,A0),D3	; Red2
	add.w	D3,D0
	add.w	D3,D0

	move.b	(1+720,A0),D3	; Green2
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(720,A0),D3	; Blue2
	add.w	D3,D2
	add.w	D3,D2

	move.b	(5+720,A0),D3	; Red3
	add.w	D3,D0

	move.b	(4+720,A0),D3	; Green3
	add.w	D3,D1
	
	move.b	(3+720,A0),D3	; Blue3
	add.w	D3,D2	
	
	adda.l	#3,A0

	BRA	ScanNextPixel
	
	; 24
	; 12
	
ScanPixel1	move.b	(5,A0),D0	; Red1
	move.b	(4,A0),D1	; Green1
	move.b	(3,A0),D2	; Blue1
	
	lsl.w	#2,D0	; *4
	lsl.w	#2,D1	; *4
	lsl.w	#2,D2	; *4

	move.b	(2,A0),D3	; Red0
	add.w	D3,D0
	add.w	D3,D0

	move.b	(1,A0),D3	; Green0
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(A0),D3	; Blue0
	add.w	D3,D2
	add.w	D3,D2

	move.b	(5+720,A0),D3	; Red3
	add.w	D3,D0
	add.w	D3,D0

	move.b	(4+720,A0),D3	; Green3
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(3+720,A0),D3	; Blue3
	add.w	D3,D2
	add.w	D3,D2

	move.b	(2+720,A0),D3	; Red2
	add.w	D3,D0

	move.b	(1+720,A0),D3	; Green2
	add.w	D3,D1
	
	move.b	(720,A0),D3	; Blue2
	add.w	D3,D2	

	adda.l	#3*2,A0

	BRA	ScanNextPixel

	; 21
	; 42
	
ScanPixel2	move.b	(2+720,A0),D0	; Red2
	move.b	(1+720,A0),D1	; Green2
	move.b	(720,A0),D2	; Blue2
	
	lsl.w	#2,D0	; *4
	lsl.w	#2,D1	; *4
	lsl.w	#2,D2	; *4

	move.b	(2,A0),D3	; Red0
	add.w	D3,D0
	add.w	D3,D0

	move.b	(1,A0),D3	; Green0
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(0,A0),D3	; Blue0
	add.w	D3,D2
	add.w	D3,D2

	move.b	(5+720,A0),D3	; Red3
	add.w	D3,D0
	add.w	D3,D0

	move.b	(4+720,A0),D3	; Green3
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(3+720,A0),D3	; Blue3
	add.w	D3,D2
	add.w	D3,D2

	move.b	(5,A0),D3	; Red1
	add.w	D3,D0

	move.b	(4,A0),D3	; Green1
	add.w	D3,D1
	
	move.b	(3,A0),D3	; Blue1
	add.w	D3,D2	

	adda.l	#3,A0

	BRA	ScanNextPixel

	; 12
	; 24
	
ScanPixel3	move.b	(5+720,A0),D0	; Red3
	move.b	(4+720,A0),D1	; Green3
	move.b	(3+720,A0),D2	; Blue3
	
	lsl.w	#2,D0	; *4
	lsl.w	#2,D1	; *4
	lsl.w	#2,D2	; *4

	move.b	(5,A0),D3	; Red1
	add.w	D3,D0
	add.w	D3,D0

	move.b	(4,A0),D3	; Green1
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(3,A0),D3	; Blue1
	add.w	D3,D2
	add.w	D3,D2

	move.b	(2+720,A0),D3	; Red2
	add.w	D3,D0
	add.w	D3,D0

	move.b	(1+720,A0),D3	; Green2
	add.w	D3,D1
	add.w	D3,D1
	
	move.b	(720,A0),D3	; Blue2
	add.w	D3,D2
	add.w	D3,D2

	move.b	(2,A0),D3	; Red0
	add.w	D3,D0

	move.b	(1,A0),D3	; Green0
	add.w	D3,D1
	
	move.b	(0,A0),D3	; Blue0
	add.w	D3,D2	

	adda.l	#3*2,A0

ScanNextPixel	not.w	D4	; Next X

	divu.w	#72,D0	; Red
;	lsr.w	#5,D0	; Red

	divu.w	#36,D1	; Green
;	lsr.w	#4,D1	; Green

	divu.w	#72,D2	; Blue
;	lsr.w	#5,D2	; Blue
	
	lsl.w	#6,D0	; R.
	or.w	D1,D0	; RG
	lsl.w	#5,D0	; RG.
	or.w	D2,D0	; RGB
	
	move.w	D0,(A5)+
	
	DBF	D5,ScanXLoop
	
	BSR	EndStartLineBlack
	
	swap	D4
	
	tst.w	D4
	BEQ	ScanNextLine
	
	adda.l	#720*1,A0

ScanNextLine	not.w	D4	; Next Y

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
	
;	BSR	StartEndBlack
	
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
	
StartEndBlack	moveq.w	#7,D0

StartEndLoop	clr.w	(A5)+

	DBF	D0,StartEndLoop

	RTS
	
EndStartLineBlack	move.w	#15,D0

EndStartLineLoop	clr.w	(A5)+

	DBF	D0,EndStartLineLoop

	RTS
	
	SECTION	DATA
	

FramePrint	dc.b	27,"Y  "
FramePath	dc.b	"E:\"
FrameHead	dc.b	"FRM"
FrameNumb	dc.b	"00000"
FrameExt	dc.b	".TGA",0

FrameMask	dc.b	"E:\FRM*.TGA",0

MovieName	dc.b	"F:\TEST.DAT",0

	SECTION	BSS

VSyncWait	ds.w	1
ScreenStart	ds.l	1
MovieStart	ds.l	1
MovieLenght	ds.w	1
FrameCounter	ds.w	1
FrameBuffer	ds.b	129618	; 240*180
