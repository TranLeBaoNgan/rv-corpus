# RV32IMA Atomic Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Chapter 8
# "The 'A' standard extension for atomic memory operations"

.globl _start
.section .text

_start:
    # Chapter 8: "A" Standard Extension for Atomic Instructions
    # "The atomic-instruction extension, 'A', provides support for
    # atomic read-modify-write operations for multiprocessor synchronization"
    
    # Test 1: Initialize test memory
    addi x0, x0, 1              # HINT marker: Test case 1 - Initialize
    la s0, atomic_var
    li t0, 100
    sw t0, 0(s0)
    
    # Test 2: Section 8.2: Load-Reserved/Store-Conditional
    # "LR.W loads a word from the address in rs1, places the sign-extended
    # value in rd, and registers a reservation on the memory address"
    addi x0, x0, 2              # HINT marker: Test case 2 - LR.W
    lr.w t1, (s0)           # Load-reserved from atomic_var
    
    # Test 3: "SC.W conditionally writes a word in rs2 to the address in rs1.
    # The SC.W succeeds only if the reservation is still valid and the
    # reservation set contains the bytes being written."
    addi x0, x0, 3              # HINT marker: Test case 3 - SC.W success
    li t2, 200
    sc.w t3, t2, (s0)       # Store-conditional (should succeed, t3=0)
    
    # Test 4: Verify the store succeeded
    addi x0, x0, 4              # HINT marker: Test case 4 - Verify SC
    lw t4, 0(s0)            # Should be 200
    
    # Test 5: Test failed SC (reservation should be lost after first SC)
    addi x0, x0, 5              # HINT marker: Test case 5 - SC.W fail
    li t5, 300
    sc.w t6, t5, (s0)       # This should fail (t6=1)
    
    # Test 6: Section 8.3: Atomic Memory Operations (AMOs)
    # "The atomic fetch-and-op memory instructions perform an atomic
    # read-modify-write operation."
    
    # Reset test value
    addi x0, x0, 6              # HINT marker: Test case 6 - AMOSWAP.W
    li a0, 10
    sw a0, 0(s0)
    
    # AMOSWAP.W atomically swaps values
    # "AMOSWAP.W loads the word at address rs1, then writes the value
    # from rs2 to the address in rs1. The value loaded is placed in rd."
    li a1, 50
    amoswap.w a2, a1, (s0)  # a2 = old value (10), mem = 50
    lw a3, 0(s0)            # a3 = 50
    
    # Test 7: AMOADD.W atomically adds
    # "AMOADD.W loads the word at address rs1, adds the value in rs2,
    # then writes the result to the address in rs1."
    addi x0, x0, 7              # HINT marker: Test case 7 - AMOADD.W
    li a4, 25
    amoadd.w a5, a4, (s0)   # a5 = old value (50), mem = 75
    lw a6, 0(s0)            # a6 = 75
    
    # Test 8: AMOXOR.W atomically XORs
    addi x0, x0, 8              # HINT marker: Test case 8 - AMOXOR.W
    li a7, 0xFF
    amoxor.w s1, a7, (s0)   # s1 = old value (75), mem = 75 XOR 0xFF
    lw s2, 0(s0)            # Load result
    
    # Test 9: AMOAND.W atomically ANDs
    addi x0, x0, 9              # HINT marker: Test case 9 - AMOAND.W
    li s3, 0xF0
    amoand.w s4, s3, (s0)   # s4 = old value, mem = old AND 0xF0
    lw s5, 0(s0)            # Load result
    
    # Test 10: AMOOR.W atomically ORs
    addi x0, x0, 10             # HINT marker: Test case 10 - AMOOR.W
    li s6, 0x0F
    amoor.w s7, s6, (s0)    # s7 = old value, mem = old OR 0x0F
    lw s8, 0(s0)            # Load result
    
    # Test 11: Reset for min/max tests
    addi x0, x0, 11             # HINT marker: Test case 11 - AMOMIN.W
    li t0, 100
    sw t0, 0(s0)
    
    # AMOMIN.W atomically computes signed minimum
    # "AMOMIN.W loads the word at address rs1, compares it with the
    # value in rs2 treating both as signed numbers, then writes the
    # smaller value to the address in rs1."
    li t1, 50
    amomin.w t2, t1, (s0)   # t2 = 100, mem = min(100, 50) = 50
    lw t3, 0(s0)            # t3 = 50
    
    # Test 12: AMOMAX.W atomically computes signed maximum
    addi x0, x0, 12             # HINT marker: Test case 12 - AMOMAX.W
    li t4, 150
    amomax.w t5, t4, (s0)   # t5 = 50, mem = max(50, 150) = 150
    lw t6, 0(s0)            # t6 = 150
    
    # Test 13: AMOMINU.W atomically computes unsigned minimum
    addi x0, x0, 13             # HINT marker: Test case 13 - AMOMINU.W
    li a0, 0xFFFFFFFF       # Large unsigned value
    sw a0, 0(s0)
    li a1, 200
    amominu.w a2, a1, (s0)  # a2 = 0xFFFFFFFF, mem = 200
    lw a3, 0(s0)            # a3 = 200
    
    # Test 14: AMOMAXU.W atomically computes unsigned maximum
    addi x0, x0, 14             # HINT marker: Test case 14 - AMOMAXU.W
    li a4, 0xFFFFFFFF
    amomaxu.w a5, a4, (s0)  # a5 = 200, mem = 0xFFFFFFFF
    lw a6, 0(s0)            # a6 = 0xFFFFFFFF
    
    # Test 15: Section 8.4: Memory Ordering
    # Test with acquire/release semantics
    addi x0, x0, 15             # HINT marker: Test case 15 - acquire/release
    la s0, atomic_var
    li t0, 42
    sw t0, 0(s0)
    
    # LR.W with acquire semantics
    lr.w.aq t1, (s0)
    
    # SC.W with release semantics
    li t2, 84
    sc.w.rl t3, t2, (s0)
    
    # AMO with both acquire and release (sequential consistency)
    li a0, 100
    amoswap.w.aqrl a1, a0, (s0)
    
    # Test 16: Test fence instruction
    # "The FENCE instruction is used to order device I/O and memory
    # accesses as viewed by other RISC-V harts and external devices"
    addi x0, x0, 16             # HINT marker: Test case 16 - FENCE
    fence
    fence.i                  # Instruction fence
    
    # Test 17: Test multiple LR/SC pairs
    addi x0, x0, 17             # HINT marker: Test case 17 - LR/SC pairs
    la s1, atomic_var2
    li t0, 1
    sw t0, 0(s1)
    
    # First LR/SC pair
    lr.w t1, (s1)
    addi t1, t1, 1
    sc.w t2, t1, (s1)       # Should succeed
    
    # Second LR/SC pair
    lr.w t3, (s1)
    addi t3, t3, 1
    sc.w t4, t3, (s1)       # Should succeed
    
    lw t5, 0(s1)            # Should be 3
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall

.section .data
.align 4
atomic_var:
    .word 0
atomic_var2:
    .word 0
