.import readnum

.segment "LDADDR"
                .word   $c000

CHROUT		= $ffd2
GETIN		= $ffe4
STROUT		= $ab1e

.code

main:
		jmp	readnum

