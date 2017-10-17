C64SYS?=c64
C64AS?=ca65
C64LD?=ld65

C64ASFLAGS?=-t $(C64SYS) -g
C64LDFLAGS?=-Ln binseq.lbl -m binseq.map -Csrc/binseq.cfg

binseq_OBJS:=$(addprefix obj/,main.o numconv.o)
binseq_BIN:=binseq.prg

all: $(binseq_BIN)

$(binseq_BIN): $(binseq_OBJS)
	$(C64LD) -o$@ $(C64LDFLAGS) $^

obj:
	mkdir obj

obj/%.o: src/%.s src/binseq.cfg Makefile | obj
	$(C64AS) $(C64ASFLAGS) -o$@ $<

clean:
	rm -fr obj *.lbl *.map

distclean: clean
	rm -f $(binseq_BIN)

.PHONY: all clean distclean

