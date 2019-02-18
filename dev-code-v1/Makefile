default: main.6502.nes

.PHONY: clean
clean:
	rm -f *.nes
	rm -f *.fns

main.6502.nes: main.6502.asm
	nesasm $<

.PHONY: run
run: main.6502.nes
	fceux $<