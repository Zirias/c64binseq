.export numtostring
.export stringtonum
.export readnum
.export nc_string
.export nc_num

TMP_X		= $26

.code

syntaxerr:	jmp	$af08
illquant:	jmp	$b248

readnum:
		jsr	$aefd
		bcs	syntaxerr
		ldx	#$00
rn_loop:	sta	nc_string,x
		inx
		cpx	#$15
		beq	illquant
		jsr	$73
		bcc	rn_loop
		sta	nc_string,x

stringtonum:
		ldx	#$ff
stn_strlen:	inx
		lda	nc_string,x
		bne	stn_strlen
		ldy	#$15
stn_copybcd:	dey
		dex
		bmi	stn_fillzero
		lda	nc_string,x
		and	#$f
		sta	nc_string,y
		bpl	stn_copybcd
stn_fillzero:	lda	#$0
		sta	nc_string,y
		dey
		bpl	stn_fillzero
		lda	#$0
		ldx	#$7
stn_znumloop:	sta	nc_num,x
		dex
		bpl	stn_znumloop
		ldx	#$40
stn_loop:	ldy	#$6c
		clc
stn_rorloop:	lda	nc_string-$6b,y
		bcc	stn_skipbit
		ora	#$10
stn_skipbit:	lsr	a
		sta	nc_string-$6b,y
		iny
		bpl	stn_rorloop
		stx	TMP_X
		ldx	#$7
stn_ror:	ror	nc_num,x
		dex
		bpl	stn_ror
		ldx	TMP_X
		dex
		bne	stn_sub
		ldx	nc_string+$14
		bne	illquant
		rts
stn_sub:	ldy	#$13
stn_subloop:	lda	nc_string+1,y
		cmp	#$8
		bmi	stn_nosub
		sbc	#$3
		sta	nc_string+1,y
stn_nosub:	dey
		bpl	stn_subloop
		bmi	stn_loop

numtostring:
		ldx	#$15
		lda	#$0
nts_fillzero:	sta	nc_string-1,x
		dex
		bne	nts_fillzero
		ldx	#$40
nts_bcdloop:	ldy	#$13
nts_addloop:	lda	nc_string+1,y
		cmp	#$5
		bmi	nts_noadd
		adc	#$2
		sta	nc_string+1,y
nts_noadd:	dey
		bpl	nts_addloop
		ldy	#$4
		asl	nc_num
		stx	TMP_X
		ldx	#$f9
nts_rol:	rol	nc_num-$f8,x
		inx
		bne	nts_rol
		ldx	TMP_X
nts_rolloop:	lda	nc_string+1,y
		rol	a
		cmp	#$10
		and	#$f
		sta	nc_string+1,y
nts_rolnext:	dey
		bpl	nts_rolloop
		dex
		bne	nts_bcdloop
nts_scan:	cpy	#$14
		beq	nts_copydigits
		iny
		lda	nc_string,y
		beq	nts_scan
nts_copydigits:	ora	#$30
		sta	nc_string,x
		inx
		iny
		cpy	#$15
		beq	nts_done
		lda	nc_string,y
		bcc	nts_copydigits
nts_done:	lda	#$0
		sta	nc_string,x
		rts

.bss

nc_string:	.res	21
nc_num:		.res	8
