; load the whole AIV logo in the chr to the left (nametable 0) AND right (nametable 1) nametables
; implement horizontal scrolling driven by the joypad
; AND implement horizontal and vertical scrolling for one sprite (again managed by the joypad)

.DB "NES", $1A, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0

.define PPUCTRL   $2000
.define PPUMASK   $2001
.define PPUSTATUS $2002
.define OAMADDR   $2003
.define OAMDATA   $2004
.define PPUSCROLL $2005
.define PPUADDR   $2006
.define PPUDATA   $2007
.define JOYPAD1   $4016

.define scroll_x  $00
.define buttons   $01
.define nam_l     $02
.define nam_h     $03

.ORG $8000

load_bg_palette:
    ; background palette
    LDA #$3f
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    
    LDA #$3f
    STA PPUDATA   
    LDA #$14
    STA PPUDATA
    LDA #$24
    STA PPUDATA
    LDA #$34
    STA PPUDATA
    RTS

load_background:
    LDA PPUSTATUS
    LDA nam_h
    STA PPUADDR
    LDA nam_l
    STA PPUADDR
    
    LDY #$00
    LDX #$40
loop_bg:
    STX PPUDATA
    INX
    CPX #$cf
    BEQ end_bg
    TXA
    AND #$0f
    BNE loop_bg
    ; go down
    TYA
    ADC #$20
    TAY
    LDA PPUSTATUS
    LDA nam_h
    STA PPUADDR
    STY PPUADDR
    JMP loop_bg
end_bg:
    RTS

start:
    ; enable ppu
    LDA #%10000000
    STA PPUCTRL

    ; set ppu mask
    LDA #%000111100
    STA PPUMASK

    JSR load_bg_palette

    LDA #$20
    STA nam_h
    LDA #$00
    STA nam_l
    JSR load_background

    LDA #$24
    STA nam_h
    LDA #$00
    STA nam_l
    JSR load_background

loop:
    JMP loop

readjoy:
    PHA
    LDA #$01
    STA JOYPAD1
    STA buttons
    LSR a
    STA JOYPAD1
joyloop:
    LDA JOYPAD1
    LSR A
    ROL buttons
    BCC joyloop
    PLA
    RTS
    
nmi:
    JSR readjoy
    
    LDA buttons
    AND #%00000001
    BNE scroll_bg_right
    LDA buttons
    AND #%00000010
    BNE scroll_bg_left
    RTI
scroll_bg_right:
    INC scroll_x
    LDA scroll_x
    STA PPUSCROLL
    LDA #0
    STA PPUSCROLL
    RTI
scroll_bg_left:
    DEC scroll_x
    LDA scroll_x
    STA PPUSCROLL
    LDA #0
    STA PPUSCROLL
    RTI
  
irq:
    RTI
    


.goto $FFFA

.DW nmi
.DW start
.DW irq

pattern0: .INCBIN "aiv256.chr"
pattern1: .INCBIN "aiv256.chr"


