# RV32I Edge Cases and Corner Cases Test
# Tests for overflow, underflow, and boundary conditions
# Reference: RISC-V Unprivileged ISA Specification, Section 2.4
#
# Test mapping: mappings/tests/rv32i_04_edge_cases.json
# HINT instructions mark test case boundaries (HINT N = test case N)

.globl _start
.section .text

_start:
    # ==========================================================================
    # HINT 1: Test integer overflow with ADDI
    # Section 2.4.1: "Arithmetic overflow is ignored and the result is
    # simply the low XLEN bits of the result"
    # ==========================================================================
    addi x0, x0, 1          # HINT 1: Integer overflow with ADDI test
    li t0, 0x7FFFFFFF       # MAX_INT32
    addi t1, t0, 1          # Should wrap to 0x80000000 (MIN_INT32)
    
    # ==========================================================================
    # HINT 2: Test integer underflow with ADDI
    # ==========================================================================
    addi x0, x0, 2          # HINT 2: Integer underflow with ADDI test
    li t2, 0x80000000       # MIN_INT32
    addi t3, t2, -1         # Should wrap to 0x7FFFFFFF (MAX_INT32)
    
    # ==========================================================================
    # HINT 3: Test ADD overflow with two MAX_INT
    # ==========================================================================
    addi x0, x0, 3          # HINT 3: ADD overflow with two MAX_INT test
    li a0, 0x7FFFFFFF
    li a1, 0x7FFFFFFF
    add a2, a0, a1          # Should produce negative result
    
    # ==========================================================================
    # HINT 4: Test SUB underflow from MIN_INT
    # ==========================================================================
    addi x0, x0, 4          # HINT 4: SUB underflow from MIN_INT test
    li a3, 0x80000000
    li a4, 1
    sub a5, a3, a4          # Should wrap around
    
    # ==========================================================================
    # HINT 5: Test zero register hardwired to 0
    # "Register x0 is hardwired with all bits equal to 0"
    # ==========================================================================
    addi x0, x0, 5          # HINT 5: Zero register hardwired to 0 test
    li t0, 42
    add t1, t0, zero        # t1 = t0
    add t2, zero, t0        # t2 = t0
    add t3, zero, zero      # t3 = 0
    
    # ==========================================================================
    # HINT 6: Test maximum shift amount (31)
    # ==========================================================================
    addi x0, x0, 6          # HINT 6: Maximum shift amount (31) test
    li s0, 0x80000000
    li s1, 31
    srl s2, s0, s1          # Should shift to 1
    sra s3, s0, s1          # Should shift to -1 (all 1s)
    
    # ==========================================================================
    # HINT 7: Test shift by 0
    # ==========================================================================
    addi x0, x0, 7          # HINT 7: Shift by 0 test
    li s4, 0x12345678
    li s5, 0
    sll s6, s4, s5          # Should be unchanged
    
    # ==========================================================================
    # HINT 8: Test shift amount uses only lower 5 bits
    # ==========================================================================
    addi x0, x0, 8          # HINT 8: Shift amount uses only lower 5 bits test
    li t4, 0xFFFFFFFF
    li t5, 32               # Treated as 0
    sll t6, t4, t5          # Should be unchanged
    
    li a6, 0xFFFFFFFF
    li a7, 33               # Treated as 1
    sll s7, a6, a7          # Should be 0xFFFFFFFE
    
    # ==========================================================================
    # HINT 9: Test SLTI boundary comparisons
    # ==========================================================================
    addi x0, x0, 9          # HINT 9: SLTI boundary comparisons test
    li t0, 0
    slti t1, t0, 1          # t1 = 1 (0 < 1)
    slti t2, t0, 0          # t2 = 0 (0 == 0)
    slti t3, t0, -1         # t3 = 0 (0 > -1 signed)
    
    # ==========================================================================
    # HINT 10: Test SLTU with max unsigned value
    # ==========================================================================
    addi x0, x0, 10         # HINT 10: SLTU with max unsigned value test
    li s0, 0xFFFFFFFF       # -1 signed, max unsigned
    li s1, 0
    sltu s2, s1, s0         # s2 = 1 (0 < max unsigned)
    sltu s3, s0, s1         # s3 = 0 (max > 0)
    
    # ==========================================================================
    # HINT 11: Test SLT with negative numbers
    # ==========================================================================
    addi x0, x0, 11         # HINT 11: SLT with negative numbers test
    li a0, -1
    li a1, -2
    slt a2, a0, a1          # a2 = 0 (-1 > -2)
    slt a3, a1, a0          # a3 = 1 (-2 < -1)
    
    # ==========================================================================
    # HINT 12: Test XOR self-cancellation
    # ==========================================================================
    addi x0, x0, 12         # HINT 12: XOR self-cancellation test
    li t0, 0x12345678
    xor t1, t0, t0          # Should be 0 (x XOR x = 0)
    xor t2, t0, zero        # Should be unchanged
    
    # ==========================================================================
    # HINT 13: Test maximum and minimum I-type immediates
    # ==========================================================================
    addi x0, x0, 13         # HINT 13: Maximum and minimum I-type immediates test
    addi s4, zero, 2047
    addi s5, zero, -2048
    
    # ==========================================================================
    # HINT 14: Test LUI with maximum value
    # ==========================================================================
    addi x0, x0, 14         # HINT 14: LUI with maximum value test
    lui s6, 0xFFFFF         # Upper 20 bits all 1s
    
    # ==========================================================================
    # HINT 15: Test AUIPC with maximum offset
    # ==========================================================================
    addi x0, x0, 15         # HINT 15: AUIPC with maximum offset test
    auipc s7, 0xFFFFF
    
    # ==========================================================================
    # HINT 16: Test BEQ with equal values - taken
    # ==========================================================================
    addi x0, x0, 16         # HINT 16: BEQ with equal values - taken test
    li t0, 42
    li t1, 42
    beq t0, t1, eq_taken
    li t2, 0
    j eq_end
eq_taken:
    li t2, 1
eq_end:
    
    # ==========================================================================
    # HINT 17: Test BNE with equal values - not taken
    # ==========================================================================
    addi x0, x0, 17         # HINT 17: BNE with equal values - not taken test
    bne t0, t1, ne_taken
    li t3, 1                # Should execute
    j ne_end
ne_taken:
    li t3, 0
ne_end:
    
    # ==========================================================================
    # HINT 18: Test BGE with equal values - taken
    # ==========================================================================
    addi x0, x0, 18         # HINT 18: BGE with equal values - taken test
    bge t0, t1, ge_taken
    li t4, 0
    j ge_end
ge_taken:
    li t4, 1
ge_end:
    
    # ==========================================================================
    # HINT 19: Test BGEU with equal values - taken
    # ==========================================================================
    addi x0, x0, 19         # HINT 19: BGEU with equal values - taken test
    bgeu t0, t1, geu_taken
    li t5, 0
    j geu_end
geu_taken:
    li t5, 1
geu_end:
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
