# RV32IM Multiply and Divide Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Chapter 7
# "The 'M' standard extension for integer multiplication and division"
#
# Test mapping: mappings/tests/rv32im_01_multiply_divide.json
# HINT instructions mark test case boundaries (HINT N = test case N)

.globl _start
.section .text

_start:
    # Chapter 7: RV32M Standard Extension
    # "The RV32M extension adds instructions to multiply and divide values
    # held in the integer register file."
    
    # ==========================================================================
    # HINT 1: Test MUL basic multiplication
    # Section 7.1: Multiplication Operations
    # "MUL performs an XLEN-bit×XLEN-bit multiplication and places the
    # lower XLEN bits in the destination register."
    # ==========================================================================
    addi x0, x0, 1          # HINT 1: MUL basic multiplication test
    li a0, 10
    li a1, 20
    mul a2, a0, a1          # a2 = 200
    
    # ==========================================================================
    # HINT 2: Test MUL with negative numbers
    # ==========================================================================
    addi x0, x0, 2          # HINT 2: MUL with negative numbers test
    li t0, -5
    li t1, 6
    mul t2, t0, t1          # t2 = -30
    
    # ==========================================================================
    # HINT 3: Test MUL overflow case
    # ==========================================================================
    addi x0, x0, 3          # HINT 3: MUL overflow case test
    li t3, 0x10000
    li t4, 0x10000
    mul t5, t3, t4          # t5 = 0 (lower 32 bits)
    
    # ==========================================================================
    # HINT 4: Test MULH signed × signed upper bits
    # "MULH, MULHU, and MULHSU perform the same multiplication but
    # return the upper XLEN bits of the full 2×XLEN-bit product"
    # ==========================================================================
    addi x0, x0, 4          # HINT 4: MULH signed × signed upper bits test
    li s0, -5
    li s1, 6
    mulh s2, s0, s1         # s2 = upper 32 bits of (-5 * 6)
    
    # ==========================================================================
    # HINT 5: Test MULHU unsigned × unsigned upper bits
    # ==========================================================================
    addi x0, x0, 5          # HINT 5: MULHU unsigned × unsigned upper bits test
    li s3, 0xFFFFFFFF       # Max unsigned 32-bit
    li s4, 2
    mulhu s5, s3, s4        # s5 = upper 32 bits
    
    # ==========================================================================
    # HINT 6: Test MULHSU signed × unsigned
    # "MULHSU performs a signed rs1 × unsigned rs2 multiplication"
    # ==========================================================================
    addi x0, x0, 6          # HINT 6: MULHSU signed × unsigned test
    li s6, -1               # Signed -1
    li s7, 2                # Unsigned 2
    mulhsu s8, s6, s7       # s8 = upper 32 bits of signed×unsigned
    
    # ==========================================================================
    # HINT 7: Test large multiplication with MULH
    # ==========================================================================
    addi x0, x0, 7          # HINT 7: Large multiplication with MULH test
    li a3, 0x7FFFFFFF       # Max positive int
    li a4, 2
    mul a5, a3, a4          # Lower bits
    mulh a6, a3, a4         # Upper bits
    
    # ==========================================================================
    # HINT 8: Test DIV and REM basic division
    # Section 7.2: Division Operations
    # "DIV and DIVU perform signed and unsigned integer division of
    # XLEN bits by XLEN bits. REM and REMU provide the remainder."
    # ==========================================================================
    addi x0, x0, 8          # HINT 8: DIV and REM basic division test
    li t0, 100
    li t1, 10
    div t2, t0, t1          # t2 = 10
    rem t3, t0, t1          # t3 = 0
    
    # ==========================================================================
    # HINT 9: Test division with remainder
    # ==========================================================================
    addi x0, x0, 9          # HINT 9: Division with remainder test
    li t4, 100
    li t5, 7
    div t6, t4, t5          # t6 = 14
    rem a7, t4, t5          # a7 = 2
    
    # ==========================================================================
    # HINT 10: Test division by zero
    # "The quotient of division by zero has all bits set, i.e. 2^XLEN−1
    # for unsigned division or −1 for signed division."
    # ==========================================================================
    addi x0, x0, 10         # HINT 10: Division by zero test
    li s0, 100
    li s1, 0
    div s2, s0, s1          # s2 = -1 (all bits set)
    divu s3, s0, s1         # s3 = 0xFFFFFFFF
    
    # ==========================================================================
    # HINT 11: Test remainder of division by zero
    # "The remainder of division by zero equals the dividend."
    # ==========================================================================
    addi x0, x0, 11         # HINT 11: Remainder of division by zero test
    rem s4, s0, s1          # s4 = 100
    remu s5, s0, s1         # s5 = 100
    
    # ==========================================================================
    # HINT 12: Test signed division with negative dividend
    # ==========================================================================
    addi x0, x0, 12         # HINT 12: Signed division with negative dividend test
    li a0, -100
    li a1, 10
    div a2, a0, a1          # a2 = -10
    rem a3, a0, a1          # a3 = 0
    
    # ==========================================================================
    # HINT 13: Test signed division with negative dividend and remainder
    # ==========================================================================
    addi x0, x0, 13         # HINT 13: Signed division with remainder test
    li a4, -100
    li a5, 7
    div a6, a4, a5          # a6 = -14
    rem a7, a4, a5          # a7 = -2 (remainder has sign of dividend)
    
    # ==========================================================================
    # HINT 14: Test DIVU and REMU unsigned division
    # ==========================================================================
    addi x0, x0, 14         # HINT 14: DIVU and REMU unsigned division test
    li t0, 0xFFFFFFFF       # Max unsigned value
    li t1, 2
    divu t2, t0, t1         # t2 = 0x7FFFFFFF
    remu t3, t0, t1         # t3 = 1
    
    # ==========================================================================
    # HINT 15: Test signed division overflow
    # "The quotient of signed division with overflow is equal to the
    # dividend. The remainder of signed division with overflow is zero."
    # Overflow occurs with MIN_INT / -1
    # ==========================================================================
    addi x0, x0, 15         # HINT 15: Signed division overflow test
    li s6, 0x80000000       # MIN_INT
    li s7, -1
    div s8, s6, s7          # s8 = 0x80000000 (overflow)
    rem s9, s6, s7          # s9 = 0
    
    # ==========================================================================
    # HINT 16: Test unsigned division
    # ==========================================================================
    addi x0, x0, 16         # HINT 16: Unsigned division test
    li t4, 1000
    li t5, 3
    divu t6, t4, t5         # t6 = 333
    remu a0, t4, t5         # a0 = 1
    
    # ==========================================================================
    # HINT 17: Test division resulting in zero
    # ==========================================================================
    addi x0, x0, 17         # HINT 17: Division resulting in zero test
    li a1, 5
    li a2, 100
    div a3, a1, a2          # a3 = 0 (5 / 100 = 0)
    rem a4, a1, a2          # a4 = 5
    
    # ==========================================================================
    # HINT 18: Test chained multiply and divide
    # ==========================================================================
    addi x0, x0, 18         # HINT 18: Chained multiply and divide test
    li s0, 10
    li s1, 5
    li s2, 3
    mul s3, s0, s1          # s3 = 50
    div s4, s3, s2          # s4 = 16
    rem s5, s3, s2          # s5 = 2
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
