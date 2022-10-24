.org $8000

.define food_l           $00 ; food location, low byte
.define food_h           $01 ; food location, high byte
.define snake_direction  $02 ; snake direction
.define snake_length     $03 ; snake length, in number of bytes (2 bytes == 1 segment)
.define snake_l          $10 ; snake head screen location, low byte
.define snake_h          $11 ; snake head screen location, high byte
.define snake_body       $12 ; snake start body

.define seed_loc         $0f

.define up_pressed    1
.define down_pressed  2
.define left_pressed  4
.define right_pressed 8

.define last_key $4000

start:
JSR init
JSR loop

init:
    JSR init_snake
    JSR init_food

init_snake:
    LDA #right_pressed
    STA snake_direction     ; set start direction
    
    ; initial snake length in bytes
    LDA #4
    STA snake_length
    
    ; set snake head's location
    LDA #$11
    STA snake_l
    
    ; set snake body
    LDA #$10
    STA snake_body
    LDA #$0f
    STA $14
  
    ; the high bytes of head and body are set to screen ram page
    LDA #$02
    STA snake_h
    STA $13
    STA $15
    
    RTS

init_food:
    LDA #$02
    STA food_h
    
    LDA #34
    STA seed_loc
    JSR generate_food
    RTS

generate_food:
    ; JSR new_random_location
    LDA seed_loc
    STA food_l
    RTS

; FIXME: bugged
; new_random_location: 
;     LDA seed_loc
;     ASL A
;     EOR #$1d
;     STA seed_loc
;     RTS

loop: 
    JSR read_input
    JSR update_snake
    JSR draw_snake
    JSR draw_food
    JSR check_collisions
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

check_collisions:
    JSR check_food_collision
    
check_food_collision:
    LDA food_l
    CMP snake_l
    BNE no_collision_with_food
    JSR generate_food
    INC snake_length
no_collision_with_food:
    RTS
    
update_snake:
    LDX snake_length
    DEX
    TXA
update_loop:
    LDA snake_l, X
    STA snake_body, X
    DEX
    BPL update_loop
    
    LDA snake_direction ; load direction in A
    LSR A
    BCS up              ; started with 0001, the carry flag was set after one shift, so we need to go up
    LSR A
    BCS down            ; started with 0010, the carry flag was set after two shifts, so we need to go down
    LSR A
    BCS left            ; started with 0100, the carry flag was set after three shifts, so we need to go left
    LSR A
    BCS right           ; started with 1000, the carry flag was set after four shifts, so we need to go right  
up:
    LDA snake_l
    SEC
    SBC #$10 
    STA snake_l
    BCC upup
    RTS
upup:
    DEC snake_h         ; Decrement snake head's high byte 
    LDA #$1
    CMP snake_h
    BEQ wall_collision  ; if the cmp op result is 1, the snake collides with top screen
    RTS
right:
    INC snake_l
    LDA #$1f
    AND snake_l
    BEQ wall_collision
    RTS
down:
    LDA snake_l
    CLC
    ADC #$10
    STA snake_l
    BCS downdown
    RTS
downdown:
    INC snake_h
    LDA #$3
    CMP snake_h
    BEQ wall_collision   ; if the cmp op result is 1, the snake collides with bottom screen
    RTS
left:
    DEC snake_l
    LDA snake_l
    AND #$1f
    CMP #$1f
    BEQ wall_collision
    RTS
wall_collision:
    JMP game_over

draw_snake:
    LDX snake_length
    LDA #0
    STA (snake_l, X) ; erase end of tail

    LDX #0
    LDA #1
    STA (snake_l, X) ; paint head
    RTS

draw_food:
    LDY food_l
    LDA #$05
    STA $0200, Y
    RTS

game_over:
    JMP game_over

.goto $FFFA
.DW start   ; non maskable
.DW start   ; reset
.DW start   ; interrupt
