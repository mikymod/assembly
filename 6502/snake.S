.org $8000

.define snake_l          $00 ; snake location, low byte
.define snake_h          $01 ; snake location, high byte
.define snake_direction  $02 ; snake direction
.define snake_body_start $03 ; snake start body
.define snake_length     $04 ; snake length

.define food_l           $10 ; food location, low byte
.define food_h           $11 ; food location, high byte

.define up_pressed    1
.define down_pressed  2
.define left_pressed  4
.define right_pressed 8

.define last_key $4000
.define seed $20

start:
    LDA #$ef
    STA seed ; init seed

    JSR init
    JSR loop

init:
    JSR read_input
    JSR init_snake
    JSR init_food

init_snake:
    LDA #right_pressed
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
    JSR read_input
    JSR draw_food
    JSR draw_snake
    JMP loop

read_input:
    LDA last_key
    
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
    LDA #down_pressed
    BIT snake_direction
    BEQ skip_input

    LDA #up_pressed
    STA snake_direction
    RTS

move_down:
    LDA #up_pressed
    BIT snake_direction
    BEQ skip_input
    
    LDA #down_pressed
    STA snake_direction
    RTS

move_left:
    LDA #right_pressed
    BIT snake_direction
    BEQ skip_input
    
    LDA #left_pressed
    STA snake_direction
    RTS
    
move_right:
    LDA #left_pressed
    BIT snake_direction     ; if the previous dir was left, you can't move to right
    BEQ skip_input
    
    LDA #right_pressed
    STA snake_direction
    RTS
    
skip_input:
    RTS
    
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