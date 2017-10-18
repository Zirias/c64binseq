.import readnum
.import numtostring
.import nc_string

.segment "LDADDR"
                .word   $c000

CHROUT		= $ffd2
GETIN		= $ffe4
STROUT		= $ab1e

.code

main:
		jsr	readnum
		jsr	numtostring
		lda	#<nc_string
		ldy	#>nc_string
		jmp	STROUT

