; /// >  - KOSS 2001 < ///

	OPT	p=68030/68882
	comment	HEAD=7	; FastLoad

; --- EQUATE ASSEMBLY ---

; --- EQUATE DATA ---

PROG_ED_DAY:	EQU	31	; Binary Date Format
PROG_ED_MONTH:	EQU	10	;  FEDC BA98 7654 3210
PROG_ED_YEAR:	EQU	2000	; %YYYY YYYM MMMD DDDD
PROG_ED_DATE:	EQU	((PROG_ED_YEAR-1980)<<9)|(PROG_ED_MONTH<<5)|(PROG_ED_DAY)

; --- EQUATE INDEX ---

; --- EQUATE SYSTEM ---

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	TEXT
; /////////////////////////////////////////////////////////////////////////////	
	
;	BRA	PROG_TUI_START
	
;	dc.b	"ProgHEAD"	; ProgHEADER
;	dc.w	$0100	; ProgVERSION
;	dc.w	PROG_ED_DATE	; ProgDATE
;	dc.b	"First Prog",0	; ProgNAME
;	dc.b	"Kochise",0	; ProgAUTHOR
	
; --- TEXT USER INIT ---
	
PROG_TUI_START:	movea.l	(4,SP),A6	; ADDR PROG BLOCK START (BASEPAGE)
	move.l	(12,A6),D0	; SIZE SECTION TEXT
	add.l	(20,A6),D0	; SIZE SECTION DATA +
	add.l	(28,A6),D0	; SIZE SECTION BSS  +
	addi.l	#$100,D0	; SIZE BASEPAGE     +
	addi.l	#$400,D0	; SIZE NEW STACK    +
	move.l	D0,D1	; SIZE PROG BLOCK   =
	move.l	D0,D7
	add.l	A6,D1	; ADDR PROG BLOCK END                  (NEW STACK BLOCK END)
	andi.l	#-2,D1	; ADDR PROG BLOCK END                  (EVEN ADDR)              
	subq.l	#8,D1	; ADDR NEW STACK BLOCK END - 8         (NEW STACK POINTER START)
	move.l	(4,SP),D2	; ADDR PROG BLOCK START        SAVE    (BASEPAGE)
	movea.l	D1,SP	; ADDR NEW STACK POINTER START INSTALL
	move.l	D2,(4,SP)	; ADDR PROG BLOCK START        RESTORE (BASEPAGE)
	move.l	D0,-(SP)	; SIZE PROG BLOCK              RESERVE
	move.l	A6,-(SP)	; ADDR PROG BLOCK START        RESERVE
	clr.w	-(SP)	; RESERVED
	move.w	#$4A,-(SP)	; - M_SHRINK -
	TRAP	#1	; *** GEMDOS ***
	lea	(12,SP),SP

; --- TEXT USER MAIN ---

	move.w	#7-1,D7
	lea	PROG_DAT_ROUTINES,A6
	
PROG_TUM_LOOP:	movem.l	D7/A6,-(SP)

	move.l	(A6),-(SP)
	move.w	#$26,-(SP)	; - SUPEXEC -
	trap	#14	; *** XBIOS ***
	addq.l	#6,SP
	
	move.w	#7,-(SP)	; - C_RAWCIN -
	trap	#1	; *** GEMDOS ***
	addq.l	#2,SP
	
	movem.l	(SP)+,D7/A6
	addq.l	#4,A6
	
	DBF	D7,PROG_TUM_LOOP

; --- TEXT USER EXIT ---

	clr.w	D0

PROG_TUE_PTERM:	move.w	D0,-(SP)
	move.w	#$4C,-(SP)	; - P_TERM -
	TRAP	#1	; *** GEMDOS ***

; --- TEXT USER SUB ---

; --- TEXT SUPER MAIN ---

; --- TEXT SUPER SUB ---

PROG_TSS_COLBNK0:	move.w	$FFFF8266.w,D0
	andi.w	#$FFF0,D0
	ori.w	#$0003,D0
	move.w	D0,$FFFF8266.w

	RTS

PROG_TSS_COLBNK1:	move.w	$FFFF8266.w,D0
	andi.w	#$FFF0,D0
	ori.w	#$0002,D0
	move.w	D0,$FFFF8266.w

	RTS

PROG_TSS_COLBNK2:	move.w	$FFFF8266.w,D0
	andi.w	#$FFF0,D0
	ori.w	#$0001,D0
	move.w	D0,$FFFF8266.w

	RTS

PROG_TSS_COLBNK3:	move.w	$FFFF8266.w,D0
	andi.w	#$FFF0,D0
	ori.w	#$0000,D0
	move.w	D0,$FFFF8266.w

	RTS

PROG_TSS_HOFFST0:	move.w	$FFFF82C0,D0
	andi.w	#%1111111011111111,D0
	ori.w	#%0000000000000000,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_HOFFST1:	move.w	$FFFF82C0,D0
	andi.w	#%1111111011111111,D0
	ori.w	#%0000000100000000,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_RCOMTT0:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111111100,D0
	ori.w	#%0000000000000011,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_RCOMTT1:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111111100,D0
	ori.w	#%0000000000000010,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_RCOMTT2:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111111100,D0
	ori.w	#%0000000000000001,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_RCOMTT3:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111111100,D0
	ori.w	#%0000000000000000,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_INTERL0:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111110111,D0
	ori.w	#%0000000000000000,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_INTERL1:	move.w	$FFFF82C0,D0
	andi.w	#%1111111111110111,D0
	ori.w	#%0000000000001000,D0
	move.w	D0,$FFFF82C0.w

	RTS

PROG_TSS_FREQ060:	move.w	$FFFF820A,D0
	andi.w	#%11110101,D0
	ori.w	#%00000000,D0
	move.w	D0,$FFFF820A.w

	RTS

PROG_TSS_FREQ050:	move.w	$FFFF820A,D0
	andi.w	#%11110101,D0
	ori.w	#%00000010,D0
	move.w	D0,$FFFF820A.w

	RTS

PROG_TSS_STMODE0:	move.w	$FFFF8260,D0
	andi.w	#%11110100,D0
	ori.w	#%00000011,D0
	move.w	D0,$FFFF8260.w

	RTS

PROG_TSS_STMODE1:	move.w	$FFFF8260,D0
	andi.w	#%11110100,D0
	ori.w	#%00000010,D0
	move.w	D0,$FFFF8260.w

	RTS

PROG_TSS_STMODE2:	move.w	$FFFF8260,D0
	andi.w	#%11110100,D0
	ori.w	#%00000001,D0
	move.w	D0,$FFFF8260.w

	RTS

PROG_TSS_STMODE3:	move.w	$FFFF8260,D0
	andi.w	#%11110100,D0
	ori.w	#%00000000,D0
	move.w	D0,$FFFF8260.w

	RTS

; /////////////////////////////////////////////////////////////////////////////	
	SECTION	DATA
; /////////////////////////////////////////////////////////////////////////////	
	
; --- DATA ADDRESS TABLE ---
	
PROG_DAT_ROUTINES:	dc.l	PROG_TSS_COLBNK0
	dc.l	PROG_TSS_COLBNK1
	dc.l	PROG_TSS_COLBNK2
	dc.l	PROG_TSS_COLBNK3
	dc.l	PROG_TSS_HOFFST0
	dc.l	PROG_TSS_HOFFST1
	;dc.l	PROG_TSS_RCOMTT0
	;dc.l	PROG_TSS_RCOMTT1
	;dc.l	PROG_TSS_RCOMTT2
	;dc.l	PROG_TSS_RCOMTT3
	;dc.l	PROG_TSS_INTERL0
	;dc.l	PROG_TSS_INTERL1
	;dc.l	PROG_TSS_FREQ060
	;dc.l	PROG_TSS_FREQ050
	;dc.l	PROG_TSS_STMODE0
	dc.l	PROG_TSS_STMODE1
	;dc.l	PROG_TSS_STMODE2
	;dc.l	PROG_TSS_STMODE3
	
; --- DATA DEFINED ARRAY ---
	
; /////////////////////////////////////////////////////////////////////////////	
	SECTION	BSS
; /////////////////////////////////////////////////////////////////////////////	

; --- BSS DATA BUFFER ---

; --- BSS FLAG BUFFER ---
