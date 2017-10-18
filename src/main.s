.import readnum
.import numtostring
.import nc_string
.import nc_num

.segment "LDADDR"
                .word   $c000

.segment "MAIN"
main:
		ldx	#$0f
		lda	#$00
clearloop:	sta	num_a,x
		dex
		bne	clearloop
		lda	#$01
		sta	num_a
		sta	num_b
		ldx	#$08
findmsb:	dex
		lda	nc_num,x
		beq	findmsb
		ldy	#$09
findbit:	asl	nc_num,x
		dey
		bcc	findbit
		bcs	loopentry
mainloop:	dex
		bmi	done
		ldy	#$08
bitloop:	asl	nc_num,x
		bcc	tgt_b
loopentry:	lda	#<(num_a-$f8)
		bcs	tgt_a
tgt_b:		lda	#<(num_b-$f8)
tgt_a:		sta	tgt_low
		stx	$fe
		ldx	#$f8
		clc
addloop:	lda	num_a-$f8,x
		adc	num_b-$f8,x
tgt_low		= *+1
		sta	num_a-$f8,x
		inx
		bne	addloop
		ldx	$fe
		dey
		bne	bitloop
		beq	mainloop
done:		ldx	#$f8
addloop2:	lda	num_a-$f8,x
		adc	num_b-$f8,x
		sta	nc_num-$f8,x
		inx
		bne	addloop2
		lda	nc_num
		sbc	#$01
		sta	nc_num
		ldx	#$f9
subloop:	lda	nc_num-$f8,x
		sbc	#$00
		sta	nc_num-$f8,x
		inx
		bne	subloop

.segment "OUTPUT"
		lda	#<nc_string
		ldy	#>nc_string
		jmp	$ab1e

.bss

num_a:		.res	8
num_b:		.res	8

