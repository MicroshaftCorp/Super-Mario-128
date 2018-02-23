// SM64 function addresses
.defineLabel func_osViBlack, 0x80323340
.defineLabel func_DMACopy, 0x80278504

// Addresses to the custom text
.defineLabel RamCopyAddr, 0x80370000
.defineLabel RamCopyAddr_ROM_start, 0x7CC6C0
.defineLabel RamCopyAddr_ROM_end, 0x7CC84C

// Call our custom function with DMACopy from the top-most levelscript.
.orga 0x108A18
.word 0x11080000, 0x8024B940

//************** Copy data from ROM into RAM **************//
.orga 0x6940 ; Overwrite the unused function 0x8024B940
.area 0x64 ; Set data import limit to 0x64 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)
sw a0, 0x10 (sp) ; lvl cmd 0x11 safeguard

// These three are nessecary because of what we overwrote at 0x108A18.
jal func_osViBlack ; call osViBlack
move a0, r0
sw r0, 0x8038BE24 ; Set level accumulator to 0

// Copies 0xF4 bytes from ROM addr 0x7CC6C0 to RAM addr 0x80370000
la a0, RamCopyAddr ; RAM address to copy to
la a1, RamCopyAddr_ROM_start ; ROM address start to copy from
la.u a2, RamCopyAddr_ROM_end ; ROM address end point (determines copy size)
jal func_DMACopy ; call DMACopy function
la.l a2, RamCopyAddr_ROM_end ; ROM address end point (determines copy size)

lw v0, 0x10 (sp) ; lvl cmd 0x11 safeguard
lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18
.endarea

//************** run the function we loaded from RAM **************//
.orga 0x861C0 ; Set ROM address
.area 0xA4 ; Set data import limit to 0xA4 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

jal RamCopyAddr
nop

lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18
.endarea