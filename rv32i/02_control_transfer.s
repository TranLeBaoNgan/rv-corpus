# RV32I Control Transfer Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.5
# "Control transfer instructions in RISC-V include unconditional jumps
# and conditional branches"
#
# Test mapping: mappings/tests/rv32i_02_control_transfer.json
# HINT instructions mark test case boundaries (HINT N = test case N)

.globl _start
.section .text

_start:
    # ==========================================================================
    # HINT 1: Test JAL and JALR basic jump and return
    # Section 2.5.1: Unconditional Jumps
    # "The jump and link (JAL) instruction uses the J-type format, where
    # the J-immediate encodes a signed offset in multiples of 2 bytes.
    # The offset is sign-extended and added to the pc to form the jump
    # target address. JAL stores the address of the instruction following
    # the jump (pc+4) into register rd."
    # ==========================================================================
    addi x0, x0, 1          # HINT 1: JAL and JALR basic jump and return test
    jal ra, test_jal
    j after_jal
test_jal:
    li t0, 1
    jalr zero, ra, 0        # return using jalr
after_jal:
    
    # ==========================================================================
    # HINT 2: Test JALR indirect jump
    # "The indirect jump instruction JALR (jump and link register) uses
    # the I-type encoding. The target address is obtained by adding the
    # 12-bit signed I-immediate to the register rs1, then setting the
    # least-significant bit of the result to zero."
    # ==========================================================================
    addi x0, x0, 2          # HINT 2: JALR indirect jump test
    la t1, jalr_target
    jalr ra, t1, 0
    j after_jalr
jalr_target:
    li t2, 2
    jalr zero, ra, 0
after_jalr:
    
    # ==========================================================================
    # HINT 3: Test BEQ branch if equal - taken
    # Section 2.5.2: Conditional Branches
    # "All branch instructions use the B-type instruction format. The
    # 12-bit B-immediate encodes signed offsets in multiples of 2, and is
    # added to the current pc to give the target address."
    # "BEQ and BNE take the branch if registers rs1 and rs2 are equal
    # or unequal respectively."
    # ==========================================================================
    addi x0, x0, 3          # HINT 3: BEQ branch if equal - taken test
    li a0, 10
    li a1, 10
    beq a0, a1, beq_taken
    li t3, 0                # should not execute
    j beq_end
beq_taken:
    li t3, 1
beq_end:
    
    # ==========================================================================
    # HINT 4: Test BNE branch if not equal - taken
    # ==========================================================================
    addi x0, x0, 4          # HINT 4: BNE branch if not equal - taken test
    li a2, 5
    li a3, 10
    bne a2, a3, bne_taken
    li t4, 0                # should not execute
    j bne_end
bne_taken:
    li t4, 1
bne_end:
    
    # ==========================================================================
    # HINT 5: Test BLT branch if less than signed - taken
    # "BLT and BLTU take the branch if rs1 is less than rs2, using
    # signed and unsigned comparison respectively."
    # ==========================================================================
    addi x0, x0, 5          # HINT 5: BLT branch if less than signed - taken test
    li s0, -5
    li s1, 10
    blt s0, s1, blt_taken
    li t5, 0
    j blt_end
blt_taken:
    li t5, 1
blt_end:
    
    # ==========================================================================
    # HINT 6: Test BLTU branch if less than unsigned - taken
    # ==========================================================================
    addi x0, x0, 6          # HINT 6: BLTU branch if less than unsigned - taken test
    li s2, 0xFFFFFFFF       # -1 as signed, large unsigned
    li s3, 10
    bltu s3, s2, bltu_taken # 10 < 0xFFFFFFFF unsigned
    li t6, 0
    j bltu_end
bltu_taken:
    li t6, 1
bltu_end:
    
    # ==========================================================================
    # HINT 7: Test BGE branch if greater or equal signed - taken
    # "BGE and BGEU take the branch if rs1 is greater than or equal
    # to rs2, using signed and unsigned comparison respectively."
    # ==========================================================================
    addi x0, x0, 7          # HINT 7: BGE branch if greater or equal signed - taken test
    li a4, 20
    li a5, 10
    bge a4, a5, bge_taken
    li s4, 0
    j bge_end
bge_taken:
    li s4, 1
bge_end:
    
    # ==========================================================================
    # HINT 8: Test BGEU branch if greater or equal unsigned - equal case
    # ==========================================================================
    addi x0, x0, 8          # HINT 8: BGEU branch if greater or equal unsigned - equal case test
    li a6, 10
    li a7, 10
    bgeu a6, a7, bgeu_taken
    li s5, 0
    j bgeu_end
bgeu_taken:
    li s5, 1
bgeu_end:
    
    # ==========================================================================
    # HINT 9: Test forward and backward branches
    # ==========================================================================
    addi x0, x0, 9          # HINT 9: Forward and backward branches test
    j forward_target
backward_source:
    li s6, 2
    j exit_test
forward_target:
    li s6, 1
    j backward_source
    
exit_test:
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
