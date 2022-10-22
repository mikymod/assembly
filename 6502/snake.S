.org $8000

.define snake_l          $00 ; snake location, low byte
.define snake_h          $01 ; snake location, high byte
.define snake_direction  $02 ; snake direction
.define snake_body_start $03 ; snake start body
.define snake_length     $04 ; snake length

.define food_l           $10 ; food location, low byte
.define food_h           $11 ; food location, high byte

.define move_up 1
.define move_down 2
.define move_left 4
.define move_right 8

.define last_key $4000
.define seed $20

start:
    LDA #$ef
    STA seed ; init seed

    JSR init
    JSR loop

init:
    JSR init_snake
    JSR init_food

init_snake:
    LDA #move_right
    STA snake_direction ; set right as start direction
    
    LDA #2
    STA snake_length    ; set 2 as initial length
    
    LDA #$11
    STA snake_l
    
    LDA #$10
    STA snake_body_start

    LDA #$0f
    STA $14 ; body segment 1
  
    LDA #$02
    STA snake_h
    STA $13 ; body segment 1
    STA $15 ; body segment 2
    
    RTS

init_food:
    LDA #$02
    STA food_h
    LDA #$55    
    STA food_l  
    RTS

loop:
    JSR draw_food
    JSR draw_snake
    JMP loop

draw_snake:
    LDX snake_length
    LDA #0
    STA (snake_l, X) ; erase end of tail

    LDX #0
    LDA #1
    STA (snake_l, X) ; paint head
    RTS

draw_food:
    LDY #0
    LDA #$05
    STA (food_l), Y
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;nmi:
;    RTS
    
;interrupt:
;    RTS

.goto $FFFA
.dw start         ; non maskable
.dw start       ; reset
.dw start   ; interrupt