; begin function
.orga 0x861C0 ; Set ROM address, we are overwritting a useless loop function as our hook.
.area 0xA4 ; Set data import limit to 0xA4 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

; call our custom function at the end of the rom memory
jal 0x7CC6C0
nop

; end function
proc802CB1C0_end:
lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18
.endarea