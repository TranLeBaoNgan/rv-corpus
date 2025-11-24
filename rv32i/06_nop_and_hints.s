# RV32I NOP and Hint Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.8/2.9
# "The NOP instruction does not change any user-visible state"
#
# Test mapping: mappings/tests/rv32i_06_nop_and_hints.json
# HINT instructions mark test case boundaries (HINT N = test case N)
# NOTE: This file tests HINT behavior itself, so test markers use high values (100+)

.globl _start
.section .text

_start:
    # ==========================================================================
    # HINT 100: Test NOP instruction
    # Section 2.4.3: NOP Instruction
    # "The NOP instruction does not change any user-visible state, except
    # for advancing the pc and incrementing any applicable performance
    # counters. NOP is encoded as ADDI x0, x0, 0."
    # ==========================================================================
    addi x0, x0, 100        # HINT 100: NOP instruction test
    nop
    nop
    nop
    
    # ==========================================================================
    # HINT 101: Test NOP doesn't affect registers
    # ==========================================================================
    addi x0, x0, 101        # HINT 101: NOP doesn't affect registers test
    li a0, 42
    nop
    mv a1, a0               # a1 should still be 42
    
    # ==========================================================================
    # HINT 102: Test multiple NOPs in sequence
    # ==========================================================================
    addi x0, x0, 102        # HINT 102: Multiple NOPs in sequence test
    li t0, 1
    nop
    nop
    nop
    nop
    nop
    li t1, 2
    add t2, t0, t1          # t2 = 3
    
    # ==========================================================================
    # HINT 103: Test HINT instructions with non-zero immediates
    # Section 2.9: Hint Instructions
    # "HINT instructions are usually used to communicate performance hints
    # to the microarchitecture. HINTs are encoded as integer computational
    # instructions with rd=x0."
    # ==========================================================================
    addi x0, x0, 103        # HINT 103: HINT with non-zero immediate test
    # These are encoded as various register-immediate instructions with x0 as destination
    # They should behave as NOPs
    addi x0, x0, 1          # Hint: example hint
    addi x0, a0, 0          # Hint with rs1 != x0
    ori x0, a1, 0           # Hint using ORI
    
    # ==========================================================================
    # HINT 104: Test HINTs don't affect actual computation
    # ==========================================================================
    addi x0, x0, 104        # HINT 104: HINTs don't affect computation test
    li s0, 100
    addi x0, s0, 5          # This is a hint, s0 unchanged
    mv s1, s0               # s1 = 100
    
    # ==========================================================================
    # HINT 105: Test zero register behavior
    # "Register x0 is hardwired with all bits equal to 0. Writes to x0
    # are ignored, and reads from x0 always return 0."
    # ==========================================================================
    addi x0, x0, 105        # HINT 105: Zero register behavior test
    li a0, 999
    addi x0, a0, 0          # Attempt to write to x0 (ignored, this is a HINT)
    mv a1, x0               # a1 = 0 (x0 always returns 0)
    
    # ==========================================================================
    # HINT 106: Test more zero register writes
    # ==========================================================================
    addi x0, x0, 106        # HINT 106: Zero register writes test
    add x0, a0, a0          # Writing to x0 is ignored (HINT)
    or x0, a0, a0           # Writing to x0 is ignored (HINT)
    sub x0, a0, a0          # Writing to x0 is ignored (HINT)
    
    # ==========================================================================
    # HINT 107: Test reading from x0
    # ==========================================================================
    addi x0, x0, 107        # HINT 107: Reading from x0 test
    add a2, x0, a0          # a2 = 0 + a0 = a0
    sub a3, a0, x0          # a3 = a0 - 0 = a0
    or a4, x0, a0           # a4 = 0 | a0 = a0
    and a5, x0, a0          # a5 = 0 & a0 = 0
    
    # ==========================================================================
    # HINT 108: Test NOP equivalents
    # ==========================================================================
    addi x0, x0, 108        # HINT 108: NOP equivalents test
    addi x0, x0, 0          # Official NOP encoding
    addi x1, x1, 0          # MV-like NOP (no-op copy to itself)
    
    # ==========================================================================
    # HINT 109: Test NOPs with branches
    # ==========================================================================
    addi x0, x0, 109        # HINT 109: NOPs with branches test
    li t0, 5
    li t1, 10
    beq t0, t1, skip_nops   # Should not branch
    nop
    nop
    nop
skip_nops:
    
    # ==========================================================================
    # HINT 110: Test alignment and spacing with NOPs
    # ==========================================================================
    addi x0, x0, 110        # HINT 110: Alignment with NOPs test
    li s2, 1
    nop
    li s3, 2
    nop
    nop
    li s4, 3
    nop
    nop
    nop
    li s5, 4
    
    # Verify all values are correct
    add s6, s2, s3          # s6 = 3
    add s7, s4, s5          # s7 = 7
    add s8, s6, s7          # s8 = 10
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
