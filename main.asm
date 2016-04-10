RESET:
  SEI
  CLD
  LDX #$40
  STX APUIRQ
  LDX #$FF
  TXS
  INX
  STX PPUCTRL
  STX PPUMASK
  STX DMC_FREQ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  JSR vblankwait

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clrmem:
  LDA #$00
  STA $0000, X
  STA $0100, X
  STA $0200, X
  STA $0400, X
  STA $0500, X
  STA $0600, X
  STA $0700, X
  LDA #$FE
  STA $0300, X
  INX
  BNE clrmem

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  JSR vblankwait

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_palettes:
  LDA PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  LDX #$00
load_palettes_loop:
  LDA palette, X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_background:
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  LDA #LOW(background)
  STA <rle_pointer
  LDA #HIGH(background)
  STA <rle_pointer+1

  JSR do_rle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_attributes:
  LDA PPUSTATUS
  LDA #$23
  STA PPUADDR
  LDA #$C0
  STA PPUADDR

  LDX #$40
  LDA #$00
load_attributes_loop:
  STA PPUDATA
  DEX
  BNE load_attributes_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clear_audio:
  LDX #$00
  LDX #$00
clear_audio_loop:
  STA SQ1_VOL, X
  INX
  CPX #$0F
  BNE clear_audio_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  LDA #$10
  STA DMC_FREQ
  LDA #$00
  STA DMC_RAW
  STA DMC_START
  STA DMC_LEN

  LDA #$0F
  STA APUFLAGS

  LDA #$C0
  STA APUIRQ

  LDA #$00
  LDX #$00
  JSR NSF_INIT

  LDA #$90
  STA PPUCTRL

  LDA #$1E
  STA PPUMASK

  LDA #$00
  STA PPUSCROLL
  STA PPUSCROLL

  LDA #$0F
  STA APUFLAGS

  LDA #$00
  STA $2003
  LDA #$03
  STA $4014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

forever:
  JMP forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vblankwait:
  BIT PPUSTATUS
  BPL vblankwait

  RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

do_rle:
  PHA
  TXA
  PHA
  TYA
  PHA

  LDY #$00

do_rle_start:
  LDA [rle_pointer], Y

  CMP #$FF
  BEQ do_rle_done

  CMP #$80
  BCC do_rle_repeat

do_rle_length:
  AND #$7F
  TAX
  INY
  BNE do_rle_length_loop
  INC <rle_pointer+1

do_rle_length_loop:
  LDA [rle_pointer], Y
  STA PPUDATA

  INY
  BNE do_rle_length_loop_continue
  INC <rle_pointer+1
do_rle_length_loop_continue:

  DEX
  BNE do_rle_length_loop

  JMP do_rle_start

do_rle_repeat:
  TAX
  INY
  BNE do_rle_repeat_continue
  INC <rle_pointer+1

do_rle_repeat_continue:
  LDA [rle_pointer], Y

do_rle_repeat_loop:
  STA PPUDATA
  DEX
  BNE do_rle_repeat_loop

  INY
  BNE do_rle_repeat_done
  INC <rle_pointer+1

do_rle_repeat_done:

  JMP do_rle_start

do_rle_done:

  PLA
  TAY
  PLA
  TAY
  PLA

  RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NMI:
  JSR NSF_PLAY

  RTI