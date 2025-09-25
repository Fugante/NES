; cpu registers
PPUCTRL     := $2000
PPUMASK     := $2001
PPUSTATUS   := $2002
OAMADDR     := $2003
OAMDATA     := $2004
PPUSCROLL   := $2005
PPUADDR     := $2006
PPUDATA     := $2007
DMC_FREQ    := $4010
OAMDMA      := $4014
JOY1        := $4016
JOY2_APUFC  := $4017    ; read: bits 0-4 joy data lines (bit 0 being normal controller), bits 6-7 are FC inhibit and mode

; controller buttons
BTN_RIGHT   := %00000001
BTN_LEFT    := %00000010
BTN_DOWN    := %00000100
BTN_UP      := %00001000
BTN_START   := %00010000
BTN_SELECT  := %00100000
BTN_B       := %01000000
BTN_A       := %10000000

; screen and coordinates
SCREEN_HEIGHT   := 240
SCREEN_WIDTH    := 256
