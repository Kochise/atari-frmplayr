;Desert	Drain	V1.52	680x0er	Disassembler	21.09.2001	18:51:34
;DATEI:	VI2.PRG	3677	Bytes
;TEXT:	2620	$00A3C
;DATA:	968	$003C8
;BSS:	20110	$004E8E
	;Fast-Load-Bit	gesetzt
	;Programm	ins	Fast-Ram	laden	(128kB)
	;malloc()	aus	dem	Fast-Ram
	SECTION	TEXT
	bra	T_610
T_4:	dc.b	$2,$0,$0,'6'
	dc.b	$0
T_9:	dc.b	$0
T_A:	dc.b	$0
T_B:	dc.b	$0
T_C:	dc.b	$1,'Ÿ'
T_E:	dc.b	$0,$0
T_10:	dc.b	$0,$0
T_12:	dc.b	$0,$0
T_14:	dc.b	$0,$0
T_16:	dc.b	$0,$0
T_18:	dc.b	$0,$0
T_1A:	dc.b	$0,$0
T_1C:	dc.b	$0,$0,$0,$0
	dc.b	$0,$0
T_22:	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
T_36:	dc.b	$0,$0,$0,$0
T_3A:	dc.b	$0,$0
T_3C:	dc.b	$0,$0
T_3E:	dc.b	$0,$0
T_40:	dc.b	$0,$0
T_42:	dc.b	$0,$0,$0,$0
T_46:	dc.b	$0,$0
T_48:	dc.b	$0,$0,$0,$0
T_4C:	dc.b	$0,$0
T_4E:	dc.b	$0,$0
T_50:	dc.b	$0,$0
T_52:	dc.b	$0,$0
T_54:	dc.b	$0,$0,$0,$0
T_58:	dc.b	$0,$0,$0,$0
T_5C:	dc.b	$0,$0,$0,$0
T_60:	dc.b	$0,$0
T_62:	dc.b	'‚‚‚„‚†‚ˆ'
	dc.b	'‚Š‚Œ‚¢‚¤'
	dc.b	'‚¦‚¨‚ª‚¬'
	dc.b	'‚',$10,'‚'
	dc.b	'Â‚À'
	dc.l	'XBRA'
	dc.l	'VI-2'
T_88:	dc.l	0
T_8C:	cmp.w	#$73,D0
	bne.s	T_A2
	movea.l	D1,A0
	movea.l	(A0),A0
	cmpi.w	#1,(A0)
	beq.s	T_C8
	cmpi.w	#2,(A0)
	beq.s	T_A8
T_A2:	jmp	([T_88,PC])
T_A8:	movem.l	D0-D2/A0-A2,-(SP)
	move.w	#-$1,-(SP)
	move.w	#$58,-(SP)
	trap	#14	;Vsetmode
	addq.l	#4,SP
	move.w	D0,T_60
	bsr	T_5CE
	movem.l	(SP)+,D0-D2/A0-A2
	bra.s	T_A2
T_C8:	cmpi.w	#11,4(A0)
	bpl.s	T_A2
	move.l	D1,T_54
	clr.w	-(SP)
	pea	T_E0(PC)
	move	sr,-(SP)
	bra.s	T_A2
T_E0:	movem.l	D0-D4/A0-A2,-(SP)
	pea	$58FFFF
	trap	#14	;Vsetmode
	addq.l	#4,SP
	move.w	T_E(PC),D1
	eor.w	D0,D1
	and.w	T_C(PC),D1
	bne	T_1CA
	move.w	T_60(PC),D1
	eor.w	D0,D1
	and.w	T_C(PC),D1
	bne.s	T_120
	move.w	D0,-(SP)
	move.w	#3,-(SP)
	pea	$FFFFFFFF.w
	pea	$FFFFFFFF.w
	move.w	#5,-(SP)
	trap	#14	;Setscreen
	adda.w	#14,SP
T_120:	dc.w	$A000	;init
	move.w	T_36(PC),D1
	move.w	T_3A(PC),D0
	cmp.w	#1,D0
	beq.s	T_142
	btst	#1,D1
	beq.s	T_152
	move.w	-$2AC(A0),D0
	asr.w	#1,D0
	move.w	D0,-$2AC(A0)
	bra.s	T_152
T_142:	btst	#3,D1
	beq.s	T_152
	move.w	-$2AE(A0),D0
	asr.w	#1,D0
	move.w	D0,-$2AE(A0)
T_152:	movem.w	T_18(PC),D0/D1
	movem.w	T_10(PC),D2/D3
	btst	#2,T_B
	beq.s	T_172
	move.w	D0,D1
	mulu.w	-$2AE(A0),D1
	divu.w	-$2AC(A0),D1
T_172:	move.w	D0,D4
	add.w	D4,D4
	cmp.w	D2,D4
	bmi.s	T_180
	move.w	D2,D0
	lsr.w	#1,D0
	subq.w	#1,D0
T_180:	move.w	D0,T_18
	move.w	D1,D4
	add.w	D4,D4
	cmp.w	D3,D4
	bmi.s	T_194
	move.w	D3,D1
	lsr.w	#1,D1
	subq.w	#1,D1
T_194:	move.w	D1,T_1A
	movea.l	([T_54,PC],12),A1
	move.w	T_14(PC),D0
	subq.w	#1,D0
	move.w	D0,(A1)
	move.w	T_16(PC),D0
	subq.w	#1,D0
	move.w	D0,2(A1)
	move.w	T_46(PC),D0
	cmpi.w	#8,D0
	bmi.s	T_1C0
	moveq.l	#8,D0
T_1C0:	moveq.l	#1,D1
	lsl.w	D0,D1
	move.w	D1,$1A(A1)
	bsr.s	T_1D0
T_1CA:	movem.l	(SP)+,D0-D4/A0-A2
	rte	
T_1D0:	bsr	T_266
	move.l	T_58(PC),D0
	move.b	D0,$FFFF820D.w	;vbaselo
	lsr.w	#8,D0
	move.l	D0,$FFFF8200.w
	bsr.s	T_1F6
	move.l	([T_48,PC]),T_4C
	clr.l	T_50
	rts	
T_1F6:	dc.w	$A000	;init
	lea	-$25A(A0),A1
	move.l	A1,T_48
	move.w	T_10(PC),D0
	lsr.w	#1,D0
	swap	D0
	move.w	T_12(PC),D0
	lsr.w	#1,D0
	move.l	D0,(A1)
	move.w	T_3E(PC),D1
	move.w	D1,2(A0)
	move.w	D1,-$2(A0)
	move.w	T_16(PC),-$4(A0)
	move.w	T_14(PC),-$C(A0)
	moveq.l	#0,D0
	move.w	D1,D0
	divu.w	T_46(PC),D0
	subq.w	#1,D0
	move.w	D0,-$2C(A0)
	move.w	-$2E(A0),D0
	mulu.w	D0,D1
	move.w	D1,-$28(A0)
	moveq.l	#0,D1
	move.w	T_16(PC),D1
	divu.w	D0,D1
	subq.w	#1,D1
	move.w	D1,-$2A(A0)
	move.w	T_14(PC),D1
	subq.w	#1,D1
	move.w	D1,-$2B4(A0)
	move.w	T_16(PC),D0
	subq.w	#1,D0
	move.w	D0,-$2B2(A0)
	rts	
T_266:	move.w	#$25,-(SP)
	trap	#14	;Vsync
	addq.l	#2,SP
	lea	T_1C(PC),A0
	lea	T_62(PC),A1
	moveq.l	#14,D0
T_278:	movea.w	(A1)+,A2
	move.w	(A0)+,(A2)
	dbra	D0,T_278
	move.w	T_3E(PC),D2
	sub.w	T_40(PC),D2
	lsr.w	#1,D2
	move.w	D2,$FFFF820E.w	;offsetnxt
	clr.b	$FFFF8265.w	;hscroll
	rts	
	dc.l	'XBRA'
	dc.l	'VI-2'
T_29C:	dc.l	0
T_2A0:	movem.l	D0-A0,-(SP)
	move.w	T_4C(PC),D0
	move.w	T_4E(PC),D1
	movem.w	([T_48,PC]),D2/D3
	cmp.w	D0,D2
	bne.s	T_2BE
	cmp.w	D1,D3
	beq	T_46E
T_2BE:	move.w	D2,T_4C
	move.w	D3,T_4E
	moveq.l	#0,D3
	move.w	T_46(PC),D4
	btst	#2,T_9
	sne	D3
	bne	T_3B0
	move.w	T_50(PC),D0
	add.w	T_18(PC),D0
	cmp.w	D0,D2
	bpl.s	T_2FC
	sub.w	T_18(PC),D2
	bpl.s	T_2F2
	moveq.l	#0,D2
T_2F2:	move.w	D2,T_50
	moveq.l	#1,D3
	bra.s	T_35E
T_2FC:	move.w	T_50(PC),D0
	cmp.w	#1,D4
	beq.s	T_33A
	cmp.w	#2,D4
	beq.s	T_34C
	add.w	T_10(PC),D0
	sub.w	T_18(PC),D0
	cmp.w	D0,D2
	bmi.s	T_35E
	add.w	T_18(PC),D2
	sub.w	T_10(PC),D2
	addq.w	#1,D2
T_322:	move.w	T_14(PC),D0
	sub.w	T_10(PC),D0
	cmp.w	D0,D2
	bmi.s	T_330
	move.w	D0,D2
T_330:	move.w	D2,T_50
	moveq.l	#1,D3
	bra.s	T_35E
T_33A:	sub.w	T_10(PC),D2
	addi.w	#$20,D2
	add.w	T_18(PC),D2
	cmp.w	D0,D2
	bmi.s	T_35E
	bra.s	T_322
T_34C:	sub.w	T_10(PC),D2
	addi.w	#$10,D2
	add.w	T_18(PC),D2
	cmp.w	D0,D2
	bmi.s	T_35E
	bra.s	T_322
T_35E:	move.w	T_4E(PC),D2
	move.w	T_52(PC),D0
	add.w	T_1A(PC),D0
	cmp.w	D0,D2
	bpl.s	T_380
	sub.w	T_1A(PC),D2
	bpl.s	T_376
	moveq.l	#0,D2
T_376:	move.w	D2,T_52
	moveq.l	#1,D3
	bra.s	T_3B0
T_380:	move.w	T_52(PC),D0
	add.w	T_12(PC),D0
	sub.w	T_1A(PC),D0
	cmp.w	D0,D2
	bmi.s	T_3B0
	add.w	T_1A(PC),D2
	sub.w	T_12(PC),D2
	addq.w	#1,D2
	move.w	T_16(PC),D0
	sub.w	T_12(PC),D0
	cmp.w	D0,D2
	bmi.s	T_3A8
	move.w	D0,D2
T_3A8:	move.w	D2,T_52
	moveq.l	#1,D3
T_3B0:	tst.w	D3
	beq	T_46E
	bclr	#2,T_9
	move.l	T_58(PC),D0
	move.w	T_3E(PC),D1
	mulu.w	T_52(PC),D1
	add.l	D1,D0
	move.w	T_40(PC),D5
	moveq.l	#0,D1
	move.w	T_50(PC),D1
	move.w	D1,D2
	move.w	T_3E(PC),D3
	sub.w	D5,D3
	lsr.w	#1,D3
	cmp.w	#$10,D4
	beq.s	T_41E
	cmp.w	#1,D4
	beq.s	T_406
	cmp.w	#2,D4
	beq.s	T_412
	andi.w	#-$10,D1
	mulu.w	D4,D1
	lsr.l	#3,D1
	add.l	D1,D0
	andi.w	#15,D2
	beq.s	T_442
	sub.w	D4,D3
	bra.s	T_442
T_406:	andi.w	#-$20,D1
	lsr.l	#3,D1
	add.l	D1,D0
	moveq.l	#0,D2
	bra.s	T_442
T_412:	andi.w	#-$10,D1
	lsr.l	#2,D1
	add.l	D1,D0
	moveq.l	#0,D2
	bra.s	T_442
T_41E:	lsr.w	#1,D5
	move.w	T_22(PC),D6
	btst	#0,D2
	beq.s	T_430
	addq.w	#2,D5
	subq.w	#2,D3
	subq.w	#1,D6
T_430:	move.w	D6,$FFFF8288.w	;hdb
	move.w	D5,$FFFF8210.w	;vwrap
	andi.w	#-$2,D1
	lsl.l	#1,D1
	add.l	D1,D0
	moveq.l	#0,D2
T_442:	cmp.l	T_5C(PC),D0
	sne	D4
	move.l	D0,T_5C
	move.w	D0,D1
	lsr.w	#8,D0
	move.b	D2,$FFFF8265.w	;hscroll
	move.w	D3,$FFFF820E.w	;offsetnxt
	tst.w	D4
	beq.s	T_46E
	move.l	D0,$FFFF8200.w
	move.b	D1,$FFFF820D.w	;vbaselo
	move.l	D0,$FFFF8204.w
	move.b	D1,$FFFF8209.w	;vcountlow
T_46E:	movem.l	(SP)+,D0-A0
	jmp	([T_29C,PC])
	dc.l	'XBRA'
	dc.l	'VI-2'
T_480:	dc.l	0
T_484:	lea	8(SP),A0
	btst	#5,(SP)
	bne.s	T_490
	move	usp,A0
T_490:	cmpi.w	#5,(A0)
	beq.s	T_4AC
	cmpi.w	#$58,(A0)
	beq	T_58A
	cmpi.w	#$5B,(A0)
	beq	T_5B8
T_4A6:	jmp	([T_480,PC])
T_4AC:	move.l	6(A0),D0
	bmi.s	T_4C0
	move.l	D0,T_58
	bset	#2,T_9
T_4C0:	move.w	10(A0),D0
	bmi.s	T_4A6
	btst	#1,T_9
	beq.s	T_500
	lea	$70.w,A1	;autov_int4
T_4D4:	movea.l	(A1),A2
	cmpi.l	#$58425241,-$C(A2)
	bne.s	T_4F0
	cmpi.l	#$56492D32,-$8(A2)
	beq.s	T_4F0
	lea	-$4(A2),A1
	bra.s	T_4D4
T_4F0:	move.l	T_29C(PC),(A1)
	clr.b	$FFFF8265.w	;hscroll
	bclr	#1,T_9
T_500:	tst.w	T_3A(PC)
	beq.s	T_51A
	cmp.w	#3,D0
	bne.s	T_4A6
	move.w	12(A0),D0
	and.w	T_C(PC),D0
	cmp.w	T_E(PC),D0
	bne.s	T_4A6
T_51A:	tst.l	2(A0)
	sle	D0
	tst.l	6(A0)
	ble.s	T_528
	moveq.l	#0,D0
T_528:	move.w	D0,-(SP)
	lea	14(A0),A0
	move.l	-(A0),-(SP)
	move.l	-(A0),-(SP)
	move.l	-(A0),-(SP)
	move.w	-(A0),-(SP)
	clr.w	-(SP)
	pea	T_542(PC)
	move	sr,-(SP)
	bra	T_4A6
T_542:	lea	14(SP),SP
	move.w	(SP)+,D0
	beq.s	T_560
	move.l	T_42(PC),-(SP)
	move.w	#$15,-(SP)
	trap	#1
	addq.l	#6,SP
	move.l	D0,$44E.w	;_v_bas_ad
	move.l	D0,T_58
T_560:	bsr	T_1D0
	btst	#0,T_B
	beq.s	T_586
	bset	#1,T_9
	move.l	$70.w,T_29C	;autov_int4
	move.l	#T_2A0,$70.w	;autov_int4
T_586:	moveq.l	#0,D0
	rte	
T_58A:	move.w	2(A0),D0
	bmi	T_4A6
	and.w	T_C(PC),D0
	cmp.w	T_E(PC),D0
	bne	T_4A6
	move.l	(A0),-(SP)
	clr.w	-(SP)
	pea	T_5AC(PC)
	move	sr,-(SP)
	bra	T_4A6
T_5AC:	addq.l	#4,SP
	move.l	D0,-(SP)
	bsr	T_266
	move.l	(SP)+,D0
	rte	
T_5B8:	move.w	2(A0),D0
	and.w	T_C(PC),D0
	cmp.w	T_E(PC),D0
	bne	T_4A6
	move.l	T_42(PC),D0
	rte	
T_5CE:	movem.l	D0/D1/A1,-(SP)
	lea	T_4(PC),A1
	move.w	T_E(PC),D0
	andi.w	#7,D0
	moveq.l	#1,D1
	lsl.w	D0,D1
	move.w	D1,$42(A1)
	moveq.l	#0,D1
	move.w	T_10(PC),D1
	lsl.l	D0,D1
	lsr.l	#3,D1
	move.w	D1,$3C(A1)
	moveq.l	#0,D1
	move.w	T_14(PC),D1
	lsl.l	D0,D1
	lsr.l	#3,D1
	move.w	D1,$3A(A1)
	mulu.w	T_16(PC),D1
	move.l	D1,$3E(A1)
	movem.l	(SP)+,D0/D1/A1
	rts	
T_610:	move.l	A0,D7
	bne.s	T_618
	movea.l	4(SP),A0
T_618:	lea	$500.w,A1
	adda.l	12(A0),A1
	adda.l	$14(A0),A1
	adda.l	$1C(A0),A1
	lea	0(A0,A1.l),SP
	tst.l	D7
	bne.s	T_63E
	moveq.l	#$4A,D0
	swap	D0
	movem.l	D0/A0/A1,-(SP)
	trap	#1
	movem.l	(SP)+,D0/A0/A1
T_63E:	move.l	D7,D0
	clr.l	-(SP)
	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	move.l	D0,-(SP)
	moveq.l	#0,D7
	movea.l	$5A0.w,A0	;_p_cookies
T_652:	tst.l	(A0)
	beq.s	T_66A
	cmpi.l	#$5F414B50,(A0)+
	beq.s	T_662
	addq.l	#4,A0
	bra.s	T_652
T_662:	move.l	(A0),D7
	lsr.w	#8,D7
	andi.w	#$FF,D7
T_66A:	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	move.w	D7,B_E08
	move.w	#$59,-(SP)
	trap	#14	;mon_type
	addq.l	#2,SP
	cmp.w	#3,D0
	bne.s	T_688
	moveq.l	#1,D0
T_688:	move.w	D0,T_3A
	clr.w	B_5C38
	moveq.l	#10,D0
	bsr	T_A06
	tst.w	B_5C38(PC)
	beq	T_6CE
	lea	D_A3C(PC),A0
	cmp.w	#2,D7
	beq.s	T_6B0
	lea	D_A89(PC),A0
T_6B0:	move.w	#1,B_5C54
	move.l	A0,B_5C82
	moveq.l	#$34,D0
	bsr	T_A06
	moveq.l	#$13,D0
	bsr	T_A06
	clr.w	-(SP)
	trap	#1	;Pterm0
T_6CE:	move.w	#-$1,-(SP)
	move.w	#11,-(SP)
	trap	#13	;Kbshift
	addq.l	#4,SP
	move.w	D0,D7
	lea	D_C39(PC),A0
	bsr	T_91C
	btst	#1,D7
	beq.s	T_73A
	lea	D_B41(PC),A0
	cmpi.w	#2,B_E08
	bne.s	T_6FC
	lea	D_B61(PC),A0
T_6FC:	bsr	T_91C
	move.w	#7,-(SP)
	trap	#1	;Crawcin
	addq.l	#2,SP
	cmp.b	#$6F,D0
	beq.s	T_73A
	cmp.b	#$4F,D0
	beq.s	T_73A
	cmp.b	#$79,D0
	beq.s	T_73A
	cmp.b	#$59,D0
	beq.s	T_73A
T_720:	lea	D_B81(PC),A0
	cmpi.w	#2,B_E08
	bne.s	T_732
	lea	D_B8F(PC),A0
T_732:	bsr	T_91C
	clr.w	-(SP)
	trap	#1	;Pterm0
T_73A:	move.w	#-$1,-(SP)
	move.w	#$58,-(SP)
	trap	#14	;Vsetmode
	addq.l	#4,SP
	move.w	D0,T_60
	clr.l	-(SP)
	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	move.l	D0,-(SP)
	movea.l	$5A0.w,A0	;_p_cookies
T_75C:	cmpi.l	#$56492D32,(A0)
	beq	T_8F6
	tst.l	(A0)
	beq.s	T_76E
	addq.l	#8,A0
	bra.s	T_75C
T_76E:	move.l	A0,B_E04
	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	move.w	#-$1,-(SP)
	move.w	#$58,-(SP)
	trap	#14	;Vsetmode
	addq.l	#4,SP
	and.w	T_C(PC),D0
	move.w	D0,T_3C
	bsr	T_972
	tst.w	D0
	beq.s	T_79C
	nop	
T_79C:	tst.w	T_E(PC)
	beq	T_888
	bsr	T_5CE
	btst	#3,T_B
	beq	T_888
	move.w	T_E(PC),D0
	moveq.l	#0,D6
	rol.w	#8,D0
	move.w	D0,D2
	andi.w	#15,D2
	move.b	T_81A(PC,D2.w),D6
	lsl.l	#8,D6
	move.b	#$20,D6
	lsl.l	#8,D6
	rol.w	#4,D0
	move.w	D0,D2
	andi.w	#15,D2
	move.b	T_81A(PC,D2.w),D6
	lsl.l	#8,D6
	rol.w	#4,D0
	andi.w	#15,D0
	move.b	T_81A(PC,D0.w),D6
	move.l	D6,B_E0A
	move.w	#2,-(SP)
	pea	D_C82(PC)
	move.w	#$3D,-(SP)
	trap	#1	;Fopen
	addq.l	#8,SP
	move.w	D0,D7
	bpl.s	T_82A
	lea	D_AFA(PC),A0
	cmpi.w	#2,B_E08
	bne.s	T_812
	lea	D_ACF(PC),A0
T_812:	bsr	T_91C
	bra	T_720
T_81A:	dc.b	'01234567'
	dc.b	'89ABCDEF'
T_82A:	movea.l	#B_E0E,A6
	move.l	A6,-(SP)
	move.l	#$10000,-(SP)
	move.w	D7,-(SP)
	move.w	#$3F,-(SP)
	trap	#1	;Fread
	lea	12(SP),SP
	move.l	A6,D5
T_846:	cmpi.b	#$23,(A6)+
	bne.s	T_846
	cmpi.b	#$45,(A6)+
	bne.s	T_846
	lea	14(A6),A6
	suba.l	D5,A6
	clr.w	-(SP)
	move.w	D7,-(SP)
	move.l	A6,-(SP)
	move.w	#$42,-(SP)
	trap	#1	;Fseek
	lea	10(SP),SP
	pea	B_E0A(PC)
	move.l	#4,-(SP)
	move.w	D7,-(SP)
	move.w	#$40,-(SP)
	trap	#1	;Fwrite
	lea	12(SP),SP
	move.w	D7,-(SP)
	move.w	#$3E,-(SP)
	trap	#1	;Fclose
	addq.l	#4,SP
T_888:	clr.l	-(SP)
	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	move.l	D0,-(SP)
	movea.l	B_E04(PC),A0
	move.l	(A0),8(A0)
	move.l	#$56492D32,(A0)+
	move.l	(A0),8(A0)
	move.l	#T_4,(A0)
	move.l	$88.w,T_88	;trp2vec
	move.l	#T_8C,$88.w	;trp2vec
	move.l	$B8.w,T_480	;trp14vec
	move.l	#T_484,$B8.w	;trp14vec
	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	lea	D_B25(PC),A0
	cmpi.w	#2,B_E08
	bne.s	T_8E6
	lea	D_B34(PC),A0
T_8E6:	bsr.s	T_91C
	clr.w	-(SP)
	move.l	#$710,-(SP)
	move.w	#$31,-(SP)
	trap	#1	;Ptermres
T_8F6:	move.w	#$20,-(SP)
	trap	#1	;Super
	addq.l	#6,SP
	lea	D_B9C(PC),A0
	cmpi.w	#2,B_E08
	bne.s	T_910
	lea	D_BC3(PC),A0
T_910:	bsr	T_91C
	bsr	T_928
	clr.w	-(SP)
	trap	#1	;Pterm0
T_91C:	move.l	A0,-(SP)
	move.w	#9,-(SP)
	trap	#1	;Cconws
	addq.l	#6,SP
	rts	
T_928:	move.w	#7,-(SP)
	trap	#1	;Crawcin
	addq.l	#2,SP
	rts	
	move.l	D1,-(SP)
	moveq.l	#-1,D1
T_936:	divu.w	#10,D0
	swap	D0
	addi.w	#$30,D0
	move.w	D0,-(SP)
	addq.w	#1,D1
	clr.w	D0
	swap	D0
	bne.s	T_936
T_94A:	move.w	(SP)+,D0
	move.b	D0,(A0)+
	dbra	D1,T_94A
	move.l	(SP)+,D1
	rts	
	move.l	D1,-(SP)
	moveq.l	#0,D0
	moveq.l	#0,D1
T_95C:	tst.b	(A0)
	bne.s	T_964
	move.l	(SP)+,D1
	rts	
T_964:	mulu.w	#10,D0
	move.b	(A0)+,D1
	subi.b	#$30,D1
	add.w	D1,D0
	bra.s	T_95C
T_972:	moveq.l	#1,D6
	lea	D_C79(PC),A0
T_978:	clr.w	-(SP)
	move.l	A0,-(SP)
	move.w	#$3D,-(SP)
	trap	#1	;Fopen
	addq.l	#8,SP
	move.w	D0,D7
	bpl.s	T_992
	lea	D_C7A(PC),A0
	dbra	D6,T_978
	rts	
T_992:	lea	B_E0E(PC),A6
	move.l	A6,-(SP)
	pea	$A.w
	move.w	D7,-(SP)
	move.w	#$3F,-(SP)
	trap	#1	;Fread
	lea	12(SP),SP
	cmpi.l	#$5649322E,(A6)+
	bne.s	T_A02
	cmpi.l	#$494E4600,(A6)+
	bne.s	T_A02
	move.w	(A6)+,D6
	move.w	T_3A(PC),D0
	mulu.w	#$30,D0
	beq.s	T_9D6
	move.w	#1,-(SP)
	move.w	D7,-(SP)
	move.l	D0,-(SP)
	move.w	#$42,-(SP)
	trap	#1	;Fseek
	lea	10(SP),SP
T_9D6:	pea	T_A(PC)
	pea	$30.w	;osstart
	move.w	D7,-(SP)
	move.w	#$3F,-(SP)
	trap	#1	;Fread
	lea	12(SP),SP
	move.w	D7,-(SP)
	move.w	#$3E,-(SP)
	trap	#1	;Fclose
	addq.l	#4,SP
	or.w	T_A(PC),D6
	move.w	D6,T_A
	moveq.l	#0,D0
	rts	
T_A02:	moveq.l	#1,D0
	rts	
T_A06:	lea	B_5C2E(PC),A1
	move.w	D0,(A1)+
	subi.w	#10,D0
	move.w	D0,D1
	add.w	D0,D0
	add.w	D1,D0
	lea	D_CA8(PC),A0
	adda.w	D0,A0
	moveq.l	#0,D0
	movep.l	D0,0(A1)
	move.l	(A0),D0
	clr.b	D0
	movep.l	D0,1(A1)
	move.l	#D_C90,D1
	move.w	#$C8,D0
	trap	#2	;aes
	move.w	B_5C74(PC),D0
	rts	
	SECTION	DATA
D_A3C:	dc.b	'[1][Ce p'
	dc.b	'rogramme'
	dc.b	' ne peut'
	dc.b	' ˆtre ex'
	dc.b	'‚cut‚|qu'
	dc.b	$27,'… pa'
	dc.b	'rtir du '
	dc.b	'dossier '
	dc.b	'AUTO !]['
	dc.b	'Argh !]',$0
D_A89:	dc.b	'[1][This'
	dc.b	' program'
	dc.b	' can onl'
	dc.b	'y be exe'
	dc.b	'cuted|fr'
	dc.b	'om the A'
	dc.b	'UTO fold'
	dc.b	'er !][Ar'
	dc.b	'gh !]',$0
D_ACF:	dc.b	'Le fichi'
	dc.b	'er NEWDE'
	dc.b	'SK.INF e'
	dc.b	'st intro'
	dc.b	'uvable !'
	dc.b	$D,$A,$0
D_AFA:	dc.b	'The NEWD'
	dc.b	'ESK.INF '
	dc.b	'file has'
	dc.b	'n',$27,'t'
	dc.b	' been fo'
	dc.b	'und !',$D
	dc.b	$A,$0
D_B25:	dc.b	'Installe'
	dc.b	'd ! ',$D
	dc.b	$A,$0
D_B34:	dc.b	'Install‚'
	dc.b	' !',$D,$A
	dc.b	$0
D_B41:	dc.b	'Do you w'
	dc.b	'ant to r'
	dc.b	'un VI ? '
	dc.b	'(Y/N)',$D
	dc.b	$A,$0
D_B61:	dc.b	'Voulez-v'
	dc.b	'ous lanc'
	dc.b	'er VI ? '
	dc.b	'(O/N)',$D
	dc.b	$A,$0
D_B81:	dc.b	'Aborted '
	dc.b	'...',$D,$A
	dc.b	$0
D_B8F:	dc.b	'Annul‚ .'
	dc.b	'..',$D,$A
	dc.b	$0
D_B9C:	dc.b	$D,'VIDEL'
	dc.b	' INSIDE '
	dc.b	'is alrea'
	dc.b	'dy insta'
	dc.b	'lled !',$D
	dc.b	$A,$0
D_BC3:	dc.b	$D,'VIDEL'
	dc.b	' INSIDE '
	dc.b	'est d‚j…'
	dc.b	' install'
	dc.b	'‚ !',$D,$A
	dc.b	$0,'The ',$27
	dc.b	'VI2.INF',$27
	dc.b	' file ha'
	dc.b	'sn',$27,'t'
	dc.b	' been fo'
	dc.b	'und !',$D
	dc.b	$A,$0,'Le'
	dc.b	' fichier'
	dc.b	' ',$27,'V'
	dc.b	'I2.INF',$27
	dc.b	' est int'
	dc.b	'rouvable'
	dc.b	' !',$D,$A
	dc.b	$0
D_C39:	dc.b	$D,$A,$1B
	dc.b	'p- VIDEL'
	dc.b	' INSIDE '
	dc.b	'v2.01 -',$1B
	dc.b	'q',$D,$A
	dc.b	'by Zerkm'
	dc.b	'an/Triso'
	dc.b	'mic Deve'
	dc.b	'lopment',$D
	dc.b	$A,$0
D_C79:	dc.b	'\'
D_C7A:	dc.b	'VI2.INF',$0
D_C82:	dc.b	'\NEWDESK'
	dc.b	'.INF',$0
	dc.b	$0
D_C90:	dc.l	B_5C2E
	dc.l	B_5C38
	dc.l	B_5C54
	dc.l	B_5C74
	dc.l	B_5C82
	dc.l	B_5C8E
D_CA8:	dc.b	$0,$1,$0,$2
	dc.b	$1,$1,$2,$1
	dc.b	$1,$0,$1,$1
	dc.b	$2,$1,$1,$1
	dc.b	$1,$1,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$1,$0,$0,$1
	dc.b	$0,$3,$5,$0
	dc.b	$5,$5,$0,$0
	dc.b	$1,$1,$2,$1
	dc.b	$0,$10,$7
	dc.b	$1,$2,$1,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$1,$1,$1
	dc.b	$2,$1,$1,$2
	dc.b	$1,$1,$2,$1
	dc.b	$1,$1,$1,$2
	dc.b	$1,$1,$1,$2
	dc.b	$1,$2,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$2
	dc.b	$1,$1,$1,$1
	dc.b	$1,$6,$1,$1
	dc.b	$4,$1,$1,$1
	dc.b	$3,$1,$2,$1
	dc.b	$1,$4,$2,$1
	dc.b	$8,$1,$1,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$1,$1,$1
	dc.b	$9,$1,$0,$1
	dc.b	$1,$1,$1,$1
	dc.b	$0,$0,$5,$1
	dc.b	$3,$3,$1,$2
	dc.b	$2,$1,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$4,$3,$0
	dc.b	$8,$3,$0,$6
	dc.b	$1,$0,$8,$1
	dc.b	$0,$8,$1,$0
	dc.b	$4,$1,$1,$3
	dc.b	$1,$1,$0,$5
	dc.b	$0,$1,$1,$1
	dc.b	$0,$5,$0,$0
	dc.b	$1,$1,$0,$1
	dc.b	$1,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$2,$2
	dc.b	$0,$2,$3,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$5
	dc.b	$1,$0,$5,$1
	dc.b	$0,$1,$1,$0
	dc.b	$1,$1,$0,$2
	dc.b	$5,$0,$6,$1
	dc.b	$0,$2,$1,$0
	dc.b	$1,$1,$0,$6
	dc.b	$5,$0,$0,$0
	dc.b	$0,$0,$1,$1
	dc.b	$0,$1,$0,$2
	dc.b	$1,$0,$2,$1
	dc.b	$1,$1,$1,$1
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$0,$0,$0,$0
	dc.b	$1,$2,$3,$1
	dc.b	$2,$1,$1,$1
	dc.b	$1,$1,$1,$0
	dc.b	$1,$1,$0,$1
	dc.b	$3
	SECTION	BSS
B_E04:	ds.l	1	;=4
B_E08:	ds.w	1	;=2
B_E0A:	ds.l	1	;=4
B_E0E:	ds.l	5000	;=20000
B_5C2E:	ds.w	5	;=10
B_5C38:	ds.l	7	;=28
B_5C54:	ds.l	8	;=32
B_5C74:	ds.w	7	;=14
B_5C82:	ds.l	3	;=12
B_5C8E:	ds.l	1	;=4
	END
