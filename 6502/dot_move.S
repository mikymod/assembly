.org $8000

.define dot_l $00       ; dot location, low byte
.define dot_h $01       ; dot location, high byte
.define direction $10   ; dot direction

.define random $fe
.define last_key $4000

.define none_pressed 0
.define up_pressed 1
.define down_pressed 2
.define left_pressed 4
.define right_pressed 8

start:

JSR init
JSR loop

init:
    LDA #$00
    STA dot_l           ; init position
    LDA #$02
    STA dot_h           ; init position

loop:
    JSR read_input
    JSR update_dot
    JSR draw_dot
    JMP loop

clear_screen:
    LDY dot_l
    LDA #0
    STA $0200, Y
    RTS

read_input:
    LDA last_key       ; read system input
    CMP #up_pressed
    BEQ up
    CMP #right_pressed
    BEQ right
    CMP #down_pressed
    BEQ down
    CMP #left_pressed
    BEQ left
    CMP #none_pressed
    BEQ none
    RTS

up:
    JSR clear_screen
    LDA #up_pressed
    STA direction
    RTS

down:
    JSR clear_screen
    LDA #down_pressed
    STA direction
    RTS

left:
    JSR clear_screen
    LDA #left_pressed
    STA direction
    RTS

right:
    JSR clear_screen
    LDA #right_pressed
    STA direction
    RTS

none:
    LDA #none_pressed
    STA direction
    RTS

update_dot:
    LDA direction
    CMP #up_pressed
    BEQ move_up
    CMP #right_pressed
    BEQ move_right
    CMP #down_pressed
    BEQ move_down
    CMP #left_pressed
    BEQ move_left
    RTS

move_up:
    LDA dot_l
    SBC #$10
    STA dot_l
    RTS

move_down:
    LDA dot_l
    ADC #$0F
    STA dot_l
    RTS

move_left:
    LDA dot_l
    SBC #$01
    NOP         ; TODO: add collision check
    STA dot_l
    RTS

move_right:
    LDA dot_l
    ADC #$01
    NOP         ; TODO: add collision check
    STA dot_l
    RTS

draw_dot:
    LDY dot_l
    LDA #random          ; random color
    STA $0200, Y
    RTS
    
.goto $FFFA
.dw start
.dw start
.dw start