.include "constants.asm"
.include "io.asm"

.zeropage
tmpA: .res 1                        ; $0000
tmpX: .res 1                        ; $0001
tmpY: .res 1                        ; $0002
tmp1: .res 1                        ; $0003
tmp2: .res 1                        ; $0004
tmp3: .res 1                        ; $0005
addr1: .res 2                       ; $0006 - $0007
addr2: .res 2                       ; $0008 - $0009
seed: .res 2                        ; $000a - $000b
player_x: .res 2                    ; $000c - $000d
player_y: .res 2                    ; $000e - $000f
target_velocity_x: .res 1           ; $0010
target_velocity_y: .res 1           ; $0011
player_velocity_x: .res 1           ; $0012
player_velocity_y: .res 1           ; $0013
player_sprite_x: .res 1             ; $0014
player_sprite_y: .res 1             ; $0015
player_sprite_attrs: .res 1         ; $0016
ppu_scroll_y: .res 1                ; $0017
ppu_scroll_x: .res 1                ; $0018
current_ppu_ctrl: .res 1            ; $0019
current_ppu_mask: .res 1            ; $001a
; s p - - - - - -
; | +------------------------------ 0 normal, 1 paused
; +-------------------------------- 0 working, 1 sleeping
game_state: .res 1                  ; $001b
joy1_press: .res 1                  ; $001c
joy2_press: .res 1                  ; $001d
joy1_down: .res 1                   ; $001e
joy2_down: .res 1                   ; $001f
; enemy object pool
enemy_x_pos: .res NUM_ENEMIES       ; $0020 - $0024
enemy_y_pos: .res NUM_ENEMIES       ; $0025 - $0029
enemy_x_vels: .res NUM_ENEMIES      ; $002a - $002e
enemy_y_vels: .res NUM_ENEMIES      ; $002f - $0033
enemy_flags: .res NUM_ENEMIES       ; $0034 - $0038
; a _ _ _ _ t t t
; |         +-+-+------------------- enemy type (8 posible enemies)
; +---------------------------------  0 inactive, 1 active
current_enemy: .res 1               ; $0039
current_enemy_type: .res 1          ; $003a
enemy_timer: .res 1                 ; $003b
enemy_sprite_attrs: .res 1          ; $003c
; player bullet pool
bullet_xs: .res NUM_BULLETS         ; $003d - $003f
bullet_ys: .res NUM_BULLETS         ; $0040 - $0042

.exportzp tmpA
.exportzp tmpX
.exportzp tmpY
.exportzp tmp1
.exportzp tmp2
.exportzp tmp3
.exportzp addr1
.exportzp addr2
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
