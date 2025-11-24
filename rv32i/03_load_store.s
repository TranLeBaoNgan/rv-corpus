# RV32I Load and Store Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.6
# "Load and store instructions transfer values between registers and memory"
#
# Test mapping: mappings/tests/rv32i_03_load_store.json
# HINT instructions mark test case boundaries (HINT N = test case N)

.globl _start
.section .text

_start:
    # ==========================================================================
    # HINT 1: Test LW load word
    # Section 2.6: Load and Store Instructions
    # "RV32I provides load and store instructions for 8-bit (byte),
    # 16-bit (halfword), and 32-bit (word) values. Loads are encoded
    # in the I-type format and stores are S-type."
    # ==========================================================================
    addi x0, x0, 1          # HINT 1: LW load word test
    
    # Initialize base address
    la s0, test_data
    
    # "LW loads a 32-bit value from memory into rd. The effective address
    # is obtained by adding register rs1 to the sign-extended 12-bit offset."
    lw t0, 0(s0)            # Load word at test_data
    lw t1, 4(s0)            # Load word at test_data+4
    
    # ==========================================================================
    # HINT 2: Test LH load halfword sign-extended
    # "LH loads a 16-bit value from memory, then sign-extends to 32-bits
    # before storing in rd."
    # ==========================================================================
    addi x0, x0, 2          # HINT 2: LH load halfword sign-extended test
    lh t2, 0(s0)            # Load halfword (sign-extended)
    lh t3, 2(s0)            # Load another halfword
    
    # ==========================================================================
    # HINT 3: Test LHU load halfword zero-extended
    # "LHU loads a 16-bit value from memory but zero extends to 32 bits."
    # ==========================================================================
    addi x0, x0, 3          # HINT 3: LHU load halfword zero-extended test
    lhu t4, 0(s0)           # Load halfword (zero-extended)
    
    # ==========================================================================
    # HINT 4: Test LB load byte sign-extended
    # "LB loads an 8-bit value from memory, then sign-extends to 32-bits."
    # ==========================================================================
    addi x0, x0, 4          # HINT 4: LB load byte sign-extended test
    lb t5, 0(s0)            # Load byte (sign-extended)
    lb t6, 1(s0)            # Load another byte
    
    # ==========================================================================
    # HINT 5: Test LBU load byte zero-extended
    # "LBU loads an 8-bit value from memory but zero extends to 32 bits."
    # ==========================================================================
    addi x0, x0, 5          # HINT 5: LBU load byte zero-extended test
    lbu a0, 0(s0)           # Load byte (zero-extended)
    
    # ==========================================================================
    # HINT 6: Test SW store word
    # "SW, SH, and SB store 32-bit, 16-bit, and 8-bit values from the
    # low bits of register rs2 to memory. The effective address is
    # obtained by adding register rs1 to the sign-extended 12-bit offset."
    # ==========================================================================
    addi x0, x0, 6          # HINT 6: SW store word test
    
    # Test stores
    la s1, store_area
    
    # Store word
    li a1, 0x12345678
    sw a1, 0(s1)
    
    # ==========================================================================
    # HINT 7: Test SH store halfword
    # ==========================================================================
    addi x0, x0, 7          # HINT 7: SH store halfword test
    li a2, 0xABCD
    sh a2, 4(s1)
    
    # ==========================================================================
    # HINT 8: Test SB store byte
    # ==========================================================================
    addi x0, x0, 8          # HINT 8: SB store byte test
    li a3, 0xEF
    sb a3, 6(s1)
    
    # ==========================================================================
    # HINT 9: Test verify stores with different load widths
    # ==========================================================================
    addi x0, x0, 9          # HINT 9: Verify stores with different load widths test
    lw a4, 0(s1)            # Should be 0x12345678
    lh a5, 4(s1)            # Should be 0xFFFFABCD (sign-extended)
    lhu a6, 4(s1)           # Should be 0x0000ABCD (zero-extended)
    lb a7, 6(s1)            # Should be 0xFFFFFFEF (sign-extended)
    lbu s2, 6(s1)           # Should be 0x000000EF (zero-extended)
    
    # ==========================================================================
    # HINT 10: Test negative offset loads
    # ==========================================================================
    addi x0, x0, 10         # HINT 10: Negative offset loads test
    la s3, middle_data
    lw s4, -4(s3)           # Load word before middle_data
    lw s5, 0(s3)            # Load word at middle_data
    lw s6, 4(s3)            # Load word after middle_data
    
    # ==========================================================================
    # HINT 11: Test sign extension boundary - 0xFF byte
    # ==========================================================================
    addi x0, x0, 11         # HINT 11: Sign extension boundary - 0xFF byte test
    li t0, 0xFF
    sb t0, 7(s1)
    lb t1, 7(s1)            # Should be -1 (sign-extended)
    lbu t2, 7(s1)           # Should be 255 (zero-extended)
    
    # ==========================================================================
    # HINT 12: Test store zero register
    # ==========================================================================
    addi x0, x0, 12         # HINT 12: Store zero register test
    sw zero, 8(s1)
    lw s7, 8(s1)            # Should be 0
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall

.section .data
test_data:
    .word 0x12345678
    .word 0x9ABCDEF0
middle_data:
    .word 0x11111111
    .word 0x22222222
    .byte 0x80, 0x7F, 0xFF, 0x00
    
.section .bss
store_area:
    .skip 64
