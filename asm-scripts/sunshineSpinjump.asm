.defineLabel MARIO_STRUCT, 0x8033B170

; See this wiki page for a list of Mario's actions: http://wiki.origami64.net/sm64:actions
.defineLabel ACTION_FALL, 0x0100088C
.defineLabel ACTION_MOVING, 0x04000440
.defineLabel ACTION_STANDING, 0x0C400201
.defineLabel ACTION_JUMPLAND, 0x0C000230
.defineLabel ACTION_DJLAND, 0x0C000231
.defineLabel ACTION_TJLAND, 0x04000478

; begin function
.orga 0x861C0 ; Set ROM address, we are overwritting a useless loop function as our hook.
.area 0xA4 ; Set data import limit to 0xA4 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

; check if the player pressed L on this frame
.f_testInput BUTTON_L, BUTTON_PRESSED, proc802CB1C0_end
nop

; check if mario is in a state out of which he may jump
li t0, MARIO_STRUCT
lw t1, 0x0C(t0) ; get mario's current action
li t2, ACTION_MOVING
sub t3, t1, t2
li t2, ACTION_STANDING
sub t4, t1, t2
li t2, ACTION_JUMPLAND
and t6, t3, t4
sub t5, t1, t2
and t6, t6, t5
li t2, ACTION_DJLAND
sub t5, t1, t2
and t6, t6, t5
;li t2, ACTION_TJLAND
;sub t5, t1, t2
;and t6, t6, t5
bne t6, $zero, proc802CB1C0_end
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