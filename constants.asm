  .rsset $0000
rle_pointer .rs 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
OAMADDR   = $2003

PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SQ1_VOL   = $4000
SQ1_SWEEP = $4001
SQ1_LO    = $4002
SQ1_HI    = $4003

DMC_FREQ  = $4010
DMC_RAW   = $4011
DMC_START = $4012
DMC_LEN   = $4013
OAMDMA    = $4014
APUFLAGS  = $4015

APUIRQ    = $4017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NSF_ADDR  = $A8D6
NSF_INIT  = $A999
NSF_PLAY  = $A99C