.export numtostring
.export stringtonum
.export readnum
.export nc_string
.export nc_num

.segment "INPUT"
readnum:
		jsr	$aefd
		ldx	#$00
rn_loop:	sta	nc_string,x
		inx
		jsr	$73
		bcc	rn_loop
		sta	nc_string,x

stringtonum:
		ldy	#$ff
stn_strlen:	iny
		lda	nc_string,y
		bne	stn_strlen
		ldx	#$15
stn_copybcd:	dex
		dey
		bmi	stn_fillzero
		lda	nc_string,y
		and	#$f
		sta	nc_string,x
		bpl	stn_copybcd
stn_fillzero:	lda	#$0
		sta	nc_string,x
		dex
		bpl	stn_fillzero
		lda	#$0
		ldy	#$7
stn_znumloop:	sta	nc_num,y
		dey
		bpl	stn_znumloop
		ldy	#$40
stn_loop:	ldx	#$6c
		clc
stn_rorloop:	lda	nc_string-$6b,x
		bcc	stn_skipbit
		ora	#$10
stn_skipbit:	lsr	a
		sta	nc_string-$6b,x
		inx
		bpl	stn_rorloop
		ldx	#$7
stn_ror:	ror	nc_num,x
		dex
		bpl	stn_ror
		dey
		beq	stn_out
stn_sub:	ldx	#$13
stn_subloop:	lda	nc_string+1,x
		cmp	#$8
		bmi	stn_nosub
		sbc	#$3
		sta	nc_string+1,x
stn_nosub:	dex
		bpl	stn_subloop
		bmi	stn_loop
stn_out:

.segment "TOSTRING"
numtostring:
		ldy	#$15
		lda	#$0
nts_fillzero:	sta	nc_string-1,y
		dey
		bne	nts_fillzero
		ldy	#$40
nts_bcdloop:	ldx	#$13
nts_addloop:	lda	nc_string+1,x
		cmp	#$5
		bmi	nts_noadd
		adc	#$2
		sta	nc_string+1,x
nts_noadd:	dex
		bpl	nts_addloop
		asl	nc_num
		ldx	#$f9
nts_rol:	rol	nc_num-$f8,x
		inx
		bne	nts_rol
		ldx	#$13
nts_rolloop:	lda	nc_string+1,x
		rol	a
		cmp	#$10
		and	#$f
		sta	nc_string+1,x
nts_rolnext:	dex
		bpl	nts_rolloop
		dey
		bne	nts_bcdloop
nts_scan:	cpx	#$14
		beq	nts_copydigits
		inx
		lda	nc_string,x
		beq	nts_scan
nts_copydigits:	ora	#$30
		sta	nc_string,y
		iny
		inx
		cpx	#$15
		beq	nts_done
		lda	nc_string,x
		bcc	nts_copydigits
nts_done:	lda	#$0
		sta	nc_string,y

.bss

nc_string:	.res	21
nc_num:		.res	8
