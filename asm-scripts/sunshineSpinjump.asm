.defineLabel MARIO_STRUCT, 0x8033B170

; See this wiki page for a list of Mario's actions: http://wiki.origami64.net/sm64:actions
.defineLabel ACTION_FALL, 0x0100088C
.defineLabel ACTION_MOVING, 0x04000440

; begin function
.orga 0xc7834 ; Set ROM address, we are overwritting a useless loop function as our hook.
.area 0xFF ; Set data import limit to 0xA4 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

; check if the player pressed L on this frame
.f_testInput BUTTON_L, BUTTON_PRESSED, proc802CB1C0_end
nop

; check if mario is in the moving state
li t0, MARIO_STRUCT
lw t1, 0x0C(t0) ; get mario's current action
li t2, ACTION_MOVING
bne t2, t1, proc802CB1C0_end
nop

; perform the spin jump
li t1, ACTION_FALL
sw t1, 0x0C(t0) ; Set mario's action to diving
li t1, 50.0
mtc1 t1, f2
swc1 f2, 0x4C(t0) ; Set mario's y-speed to 50.0

; end function
proc802CB1C0_end:
lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18
.endarea