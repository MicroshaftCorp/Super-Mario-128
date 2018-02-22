//mario struct
.defineLabel MARIO_STRUCT, 0x8033B170

//mario actions
.defineLabel ACTION_DIVE, 0x0188088A 
.defineLabel ACTION_SLIDE, 0x00880456
.defineLabel ACTION_SLIDERECOVER, 0x00000386
.defineLabel ACTION_SLOPESLIDE, 0x00880453
.defineLabel ACTION_FALL, 0x0100088C
.defineLabel ACTION_MOVING, 0x04000440
.defineLabel ACTION_STANDING, 0x0C400201
.defineLabel ACTION_JUMPLAND, 0x0C000230
.defineLabel ACTION_DJLAND, 0x0C000231
.defineLabel ACTION_TJLAND, 0x04000478

//custom actions
.defineLabel spinJumpState, 0x802CB260

//begin function
.orga 0x7CC6C0 ; Set ROM address, we are overwritting a useless loop function as our hook.
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

//************** Spin Jump **************//

; get mario struct data
li t0, MARIO_STRUCT
lw t1, 0x0C(t0) ; get mario's current action

;check if the player is mid-spinjump
li t2, 1
lw t7, spinJumpState
bne t7, t2, skip0

;the player is mid-spinJump, so check his state; if he's not falling, set spinJump back to 0
li t3, ACTION_FALL
beq t1, t3, applySpinJumpGravity
li t7, 0
sw t7, spinJumpState

;we are mid spinJump;
;add to the y-speed a small amount
applySpinJumpGravity:
lwc1 f2, 0x4C(t0)
li.s f4, 1.5
add.s f6, f2, f4
swc1 f6, 0x4C(t0)
;add to the rotation a small amount
lh t8, 0x2E(t0)
mtc1 t8, f2
li.s f4, 2.2
add.s f6, f2, f4
mfc1 t8, f6
sh t8, 0x2E(t0)

skip0:
; check if the player pressed L on this frame
.f_testInput BUTTON_L, BUTTON_PRESSED, endSpinJump
nop

; check if mario is in a state out of which he may jump
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
li t2, ACTION_TJLAND
sub t5, t1, t2
and t6, t6, t5
bne t6, $zero, endSpinJump
nop

addi t7, $zero, 1 ;set spinJumpState register to 1
; perform the spin jump
li t1, ACTION_FALL
sw t7, spinJumpState
sw t1, 0x0C(t0) ; Set mario's action to falling
li t1, 50.0
mtc1 t1, f2
swc1 f2, 0x4C(t0) ; Set mario's y-speed to 50.0

endSpinJump:

//************** Dive Hop **************//

; check if the player pressed B on this frame
.f_testInput BUTTON_B, BUTTON_PRESSED, endDiveHop
nop

; check if mario is in the dive slide state, the slope slide state, or the slide recover state
li t0, MARIO_STRUCT
lw t1, 0x0C(t0) ; get mario's current action
li t2, ACTION_SLIDE
sub t3, t1, t2
li t2, ACTION_SLIDERECOVER
sub t4, t1, t2
li t2, ACTION_SLOPESLIDE
and t6, t3, t4
sub t5, t1, t2
and t6, t6, t5
bne t6, $zero, endDiveHop
nop

; perform the dive hop
li t1, ACTION_DIVE
sw t1, 0x0C(t0) ; Set mario's action to diving
li t1, 30.0
mtc1 t1, f2
swc1 f2, 0x4C(t0) ; Set mario's y-speed to 30.0

endDiveHop:

//end function
proc802CB1C0_end:
lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18