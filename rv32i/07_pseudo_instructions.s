# RV32I Pseudo Instructions Test
# Reference: RISC-V Assembly Programmer's Manual
# Tests common pseudo-instructions that map to base instructions
#
# Test mapping: mappings/tests/rv32i_07_pseudo_instructions.json
# HINT instructions mark test case boundaries (HINT N = test case N)

.globl _start
.section .text

_start:
    # Pseudo-instructions are convenience mnemonics for common instruction patterns
    # They are assembled into actual RV32I base instructions
    
    # ==========================================================================
    # HINT 1: Test NOP pseudo-instruction
    # Expands to: addi x0, x0, 0
    # ==========================================================================
    addi x0, x0, 1          # HINT 1: NOP pseudo-instruction test
    nop
    
    # ==========================================================================
    # HINT 2: Test LI pseudo-instruction
    # Can expand to lui/addi or just addi depending on value
    # ==========================================================================
    addi x0, x0, 2          # HINT 2: LI pseudo-instruction test
    li a0, 42               # Simple immediate
    li a1, 0x12345          # Larger immediate (uses lui + addi)
    li a2, -1               # Negative immediate
    li a3, 0                # Zero
    
    # ==========================================================================
    # HINT 3: Test MV pseudo-instruction
    # Expands to: addi rd, rs, 0
    # ==========================================================================
    addi x0, x0, 3          # HINT 3: MV pseudo-instruction test
    mv t0, a0               # t0 = a0
    mv t1, a1               # t1 = a1
    
    # ==========================================================================
    # HINT 4: Test NOT pseudo-instruction
    # Expands to: xori rd, rs, -1
    # ==========================================================================
    addi x0, x0, 4          # HINT 4: NOT pseudo-instruction test
    li s0, 0x0F0F0F0F
    not s1, s0              # s1 = ~s0
    
    # ==========================================================================
    # HINT 5: Test NEG pseudo-instruction
    # Expands to: sub rd, x0, rs
    # ==========================================================================
    addi x0, x0, 5          # HINT 5: NEG pseudo-instruction test
    li s2, 42
    neg s3, s2              # s3 = -42
    
    # ==========================================================================
    # HINT 6: Test SEQZ pseudo-instruction
    # Expands to: sltiu rd, rs, 1
    # ==========================================================================
    addi x0, x0, 6          # HINT 6: SEQZ pseudo-instruction test
    li t0, 0
    seqz t1, t0             # t1 = (t0 == 0) ? 1 : 0
    li t2, 5
    seqz t3, t2             # t3 = (t2 == 0) ? 1 : 0
    
    # ==========================================================================
    # HINT 7: Test SNEZ pseudo-instruction
    # Expands to: sltu rd, x0, rs
    # ==========================================================================
    addi x0, x0, 7          # HINT 7: SNEZ pseudo-instruction test
    li t4, 0
    snez t5, t4             # t5 = (t4 != 0) ? 1 : 0
    li t6, 5
    snez a4, t6             # a4 = (t6 != 0) ? 1 : 0
    
    # ==========================================================================
    # HINT 8: Test SLTZ and SGTZ pseudo-instructions
    # SLTZ expands to: slt rd, rs, x0
    # SGTZ expands to: slt rd, x0, rs
    # ==========================================================================
    addi x0, x0, 8          # HINT 8: SLTZ and SGTZ pseudo-instructions test
    li s4, -5
    sltz s5, s4             # s5 = (s4 < 0) ? 1 : 0
    li s6, 5
    sltz s7, s6             # s7 = (s6 < 0) ? 1 : 0
    
    li s8, 5
    sgtz s9, s8             # s9 = (s8 > 0) ? 1 : 0
    li s10, -5
    sgtz s11, s10           # s11 = (s10 > 0) ? 1 : 0
    
    # ==========================================================================
    # HINT 9: Test BEQZ pseudo-instruction
    # Expands to: beq rs, x0, offset
    # ==========================================================================
    addi x0, x0, 9          # HINT 9: BEQZ pseudo-instruction test
    li a5, 0
    beqz a5, beqz_taken
    li a6, 1                # Should not execute
    j beqz_end
beqz_taken:
    li a6, 2
beqz_end:
    
    # ==========================================================================
    # HINT 10: Test BNEZ pseudo-instruction
    # Expands to: bne rs, x0, offset
    # ==========================================================================
    addi x0, x0, 10         # HINT 10: BNEZ pseudo-instruction test
    li a7, 5
    bnez a7, bnez_taken
    li s0, 1                # Should not execute
    j bnez_end
bnez_taken:
    li s0, 2
bnez_end:
    
    # ==========================================================================
    # HINT 11: Test BLEZ pseudo-instruction
    # Expands to: bge x0, rs, offset
    # ==========================================================================
    addi x0, x0, 11         # HINT 11: BLEZ pseudo-instruction test
    li s1, -5
    blez s1, blez_taken
    li s2, 1                # Should not execute
    j blez_end
blez_taken:
    li s2, 2
blez_end:
    
    # ==========================================================================
    # HINT 12: Test BGEZ pseudo-instruction
    # Expands to: bge rs, x0, offset
    # ==========================================================================
    addi x0, x0, 12         # HINT 12: BGEZ pseudo-instruction test
    li s3, 5
    bgez s3, bgez_taken
    li s4, 1                # Should not execute
    j bgez_end
bgez_taken:
    li s4, 2
bgez_end:
    
    # ==========================================================================
    # HINT 13: Test BLTZ pseudo-instruction
    # Expands to: blt rs, x0, offset
    # ==========================================================================
    addi x0, x0, 13         # HINT 13: BLTZ pseudo-instruction test
    li s5, -5
    bltz s5, bltz_taken
    li s6, 1                # Should not execute
    j bltz_end
bltz_taken:
    li s6, 2
bltz_end:
    
    # ==========================================================================
    # HINT 14: Test BGTZ pseudo-instruction
    # Expands to: blt x0, rs, offset
    # ==========================================================================
    addi x0, x0, 14         # HINT 14: BGTZ pseudo-instruction test
    li s7, 5
    bgtz s7, bgtz_taken
    li s8, 1                # Should not execute
    j bgtz_end
bgtz_taken:
    li s8, 2
bgtz_end:
    
    # ==========================================================================
    # HINT 15: Test BGT pseudo-instruction
    # Expands to: blt rs2, rs1, offset
    # ==========================================================================
    addi x0, x0, 15         # HINT 15: BGT pseudo-instruction test
    li t0, 10
    li t1, 5
    bgt t0, t1, bgt_taken
    li t2, 1
    j bgt_end
bgt_taken:
    li t2, 2
bgt_end:
    
    # ==========================================================================
    # HINT 16: Test BLE pseudo-instruction
    # Expands to: bge rs2, rs1, offset
    # ==========================================================================
    addi x0, x0, 16         # HINT 16: BLE pseudo-instruction test
    li t3, 5
    li t4, 10
    ble t3, t4, ble_taken
    li t5, 1
    j ble_end
ble_taken:
    li t5, 2
ble_end:
    
    # ==========================================================================
    # HINT 17: Test BGTU pseudo-instruction
    # Expands to: bltu rs2, rs1, offset
    # ==========================================================================
    addi x0, x0, 17         # HINT 17: BGTU pseudo-instruction test
    li t6, 0xFFFFFFFF       # Large unsigned value
    li a0, 100
    bgtu t6, a0, bgtu_taken
    li a1, 1
    j bgtu_end
bgtu_taken:
    li a1, 2
bgtu_end:
    
    # ==========================================================================
    # HINT 18: Test BLEU pseudo-instruction
    # Expands to: bgeu rs2, rs1, offset
    # ==========================================================================
    addi x0, x0, 18         # HINT 18: BLEU pseudo-instruction test
    li a2, 5
    li a3, 10
    bleu a2, a3, bleu_taken
    li a4, 1
    j bleu_end
bleu_taken:
    li a4, 2
bleu_end:
    
    # ==========================================================================
    # HINT 19: Test J pseudo-instruction
    # Expands to: jal x0, offset
    # ==========================================================================
    addi x0, x0, 19         # HINT 19: J pseudo-instruction test
    j jump_target
    li a5, 1                # Should not execute
jump_target:
    li a5, 2
    
    # ==========================================================================
    # HINT 20: Test JR pseudo-instruction
    # Expands to: jalr x0, 0(rs)
    # ==========================================================================
    addi x0, x0, 20         # HINT 20: JR pseudo-instruction test
    la t0, jr_target
    jr t0
    li a6, 1                # Should not execute
jr_target:
    li a6, 2
    
    # ==========================================================================
    # HINT 21: Test RET pseudo-instruction
    # Expands to: jalr x0, 0(x1)
    # ==========================================================================
    addi x0, x0, 21         # HINT 21: RET pseudo-instruction test
    jal ra, test_ret
    j after_ret
test_ret:
    li a7, 3
    ret                     # Returns to after jal
after_ret:
    
    # ==========================================================================
    # HINT 22: Test CALL pseudo-instruction
    # Can expand to: auipc x1, offset[31:12]; jalr x1, x1, offset[11:0]
    # or just: jal x1, offset
    # ==========================================================================
    addi x0, x0, 22         # HINT 22: CALL pseudo-instruction test
    call test_call
    j after_call
test_call:
    li s9, 4
    ret
after_call:
    
    # ==========================================================================
    # HINT 23: Test LA pseudo-instruction
    # Expands to: auipc rd, offset[31:12]; addi rd, rd, offset[11:0]
    # ==========================================================================
    addi x0, x0, 23         # HINT 23: LA pseudo-instruction test
    la s10, test_data
    lw s11, 0(s10)
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall

.section .data
test_data:
    .word 0x12345678
