.include "constants.asm"
.include "io.asm"

.zeropage
tmp1: .res 1                        ; $0000
tmp2: .res 1                        ; $0001
addr1: .res 2                       ; $0002 - $0003
seed: .res 2                        ; $0004 - $0005
player_x: .res 1                    ; $0006
player_y: .res 1                    ; $0007
player_sprite_attrs: .res 1         ; $0008
ppu_scroll_y: .res 1                ; $0009
ppu_scroll_x: .res 1                ; $000a
current_ppu_ctrl: .res 1            ; $000b
current_ppu_mask: .res 1            ; $000c
; s p - - - - - -
; | +------------------------------ 0 normal, 1 paused
; +-------------------------------  0 working, 1 sleeping
game_state: .res 1                  ; $000d
joy1: .res 1                        ; $000e
joy2: .res 1                        ; $000f
; enemy object pool
enemy_x_pos: .res NUM_ENEMIES       ; $0010 - $0014
enemy_y_pos: .res NUM_ENEMIES       ; $0015 - $001a
enemy_x_vels: .res NUM_ENEMIES      ; $001b - $001f
enemy_y_vels: .res NUM_ENEMIES      ; $0020 - $0024
enemy_flags: .res NUM_ENEMIES       ; $0025 - $002a
; a _ _ _ _ t t t
; |         +-+-+------------------- enemy type (8 posible enemies)
; +---------------------------------  0 inactive, 1 active
current_enemy: .res 1               ; $002b
current_enemy_type: .res 1          ; $002c
enemy_timer: .res 1                 ; $002d
enemy_sprite_attrs: .res 1          ; $002e
; player bullet pool
bullet_xs: .res NUM_BULLETS         ; $002f - $0030
bullet_ys: .res NUM_BULLETS         ; $0031 - $0033

.exportzp tmp1
.exportzp tmp2
.exportzp addr1
.exportzp seed
.exportzp player_x
.exportzp player_y
.exportzp player_sprite_attrs
.exportzp ppu_scroll_x
.exportzp ppu_scroll_y
.exportzp current_ppu_ctrl
.exportzp current_ppu_mask
.exportzp game_state
.exportzp joy1
.exportzp joy2
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
