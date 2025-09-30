.include "constants.asm"
.include "io.asm"

.zeropage
tmpA: .res 1                        ; $0000
tmpX: .res 1                        ; $0001
tmpY: .res 1                        ; $0002
tmp1: .res 1                        ; $0003
tmp2: .res 1                        ; $0004
addr1: .res 2                       ; $0005 - $0006
seed: .res 2                        ; $0007 - $0008
player_x: .res 2                    ; $0009 - $000a
player_y: .res 2                    ; $000b - $000c
target_velocity_x: .res 1           ; $000d
target_velocity_y: .res 1           ; $000e
player_velocity_x: .res 1           ; $000f
player_velocity_y: .res 1           ; $0010
player_sprite_x: .res 1             ; $0011
player_sprite_y: .res 1             ; $0012
player_sprite_attrs: .res 1         ; $0013
ppu_scroll_y: .res 1                ; $0014
ppu_scroll_x: .res 1                ; $0015
current_ppu_ctrl: .res 1            ; $0016
current_ppu_mask: .res 1            ; $0017
; s p - - - - - -
; | +------------------------------ 0 normal, 1 paused
; +-------------------------------- 0 working, 1 sleeping
game_state: .res 1                  ; $0018
joy1_press: .res 1                  ; $0019
joy2_press: .res 1                  ; $001a
joy1_down: .res 1                   ; $001b
joy2_down: .res 1                   ; $001c
; enemy object pool
enemy_x_pos: .res NUM_ENEMIES       ; $001d - $0021
enemy_y_pos: .res NUM_ENEMIES       ; $0022 - $0026
enemy_x_vels: .res NUM_ENEMIES      ; $0027 - $002b
enemy_y_vels: .res NUM_ENEMIES      ; $002c - $0030
enemy_flags: .res NUM_ENEMIES       ; $0031 - $0035
; a _ _ _ _ t t t
; |         +-+-+------------------- enemy type (8 posible enemies)
; +---------------------------------  0 inactive, 1 active
current_enemy: .res 1               ; $0036
current_enemy_type: .res 1          ; $0037
enemy_timer: .res 1                 ; $0038
enemy_sprite_attrs: .res 1          ; $0039
; player bullet pool
bullet_xs: .res NUM_BULLETS         ; $003a - $003c
bullet_ys: .res NUM_BULLETS         ; $003d - $003f

.exportzp tmpA
.exportzp tmpX
.exportzp tmpY
.exportzp tmp1
.exportzp tmp2
.exportzp addr1
.exportzp seed
.exportzp player_x
.exportzp player_y
.exportzp target_velocity_x
.exportzp target_velocity_y
.exportzp player_velocity_x
.exportzp player_velocity_y
.exportzp player_sprite_x
.exportzp player_sprite_y
.exportzp player_sprite_attrs
.exportzp ppu_scroll_x
.exportzp ppu_scroll_y
.exportzp current_ppu_ctrl
.exportzp current_ppu_mask
.exportzp game_state
.exportzp joy1_press
.exportzp joy2_press
.exportzp joy1_down
.exportzp joy2_down
.exportzp enemy_x_pos
.exportzp enemy_y_pos
.exportzp enemy_x_vels
.exportzp enemy_y_vels
.exportzp enemy_flags
.exportzp current_enemy
.exportzp current_enemy_type
.exportzp enemy_timer
.exportzp enemy_sprite_attrs
.exportzp bullet_xs
.exportzp bullet_ys
