NAME := sega

all: build

build: $(NAME).asm
	@# Build nesasm
	@make -C utilities/nesasm > /dev/null

	@# Generate CHR
	@python utilities/img2chr/img2chr.py $(NAME).png

	@# Generate RLE
	@touch background.rle
	@python utilities/graveyardduck/graveduck.py -c background.rle 0 background.bin > /dev/null 2>&1

	@# Compile ROM
	@utilities/nesasm/nesasm $(NAME).asm

clean:
	rm -f $(NAME).chr
	rm -f background.rle