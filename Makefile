AS = nasm
ASFLAGS = -f elf64
LD = ld
SHELL = /bin/bash -O extglob

release: main.o dict.o lib.o 
	$(LD) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f !(lib).o release

.PHONY: clean
