  .inesprg 2
  .ineschr 1
  .inesmir 0
  .inesmap 0

  .include "constants.asm"

  .bank 0
  .org $8000

  .bank 1
  .org $A000
  .include "data.asm"

  .org NSF_ADDR
  .incbin "sega.nsf"

  .bank 2
  .org $C000

  .bank 3
  .org $E000
  .include "main.asm"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw $0000

  .bank 4
  .org $1000
  .incbin "sega.chr"