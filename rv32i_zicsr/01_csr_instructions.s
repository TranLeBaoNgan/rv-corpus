# RV32I Zicsr Extension Test - Control and Status Register Instructions
# Reference: RISC-V Unprivileged ISA Specification
# https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html
# Chapter: "Zicsr", Extension for Control and Status Register (CSR) Instructions, Version 2.0

# From the specification:
# "RISC-V defines a separate address space of 4096 Control and Status registers
# associated with each hart. This chapter defines the full set of CSR instructions
# that operate on these CSRs."

.globl _start
.section .text

_start:
    # CSR Instructions - All CSR instructions atomically read-modify-write a single CSR
    
    # Test 1: CSRRW (Atomic Read/Write CSR)
    # "The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in
    # the CSRs and integer registers. CSRRW reads the old value of the CSR,
    # zero-extends the value to XLEN bits, then writes it to integer register rd.
    # The initial value in rs1 is written to the CSR."
    addi x0, x0, 1              # HINT marker: Test case 1 - CSRRW
    li t0, 0x1F                 # Load value to write to CSR
    csrrw t1, 0x001, t0         # Write t0 to fflags (CSR 0x001), read old value to t1
    
    # Test 2: CSRRS (Atomic Read and Set Bits in CSR)
    # "The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of
    # the CSR, zero-extends the value to XLEN bits, and writes it to integer
    # register rd. The initial value in integer register rs1 is treated as a bit
    # mask that specifies bit positions to be set in the CSR."
    addi x0, x0, 2              # HINT marker: Test case 2 - CSRRS
    li t2, 0x10                 # Bit mask for setting bits
    csrrs t3, 0x001, t2         # Set bits in fflags, read old value to t3
    
    # Test 3: CSRRC (Atomic Read and Clear Bits in CSR)
    # "The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value
    # of the CSR, zero-extends the value to XLEN bits, and writes it to integer
    # register rd. The initial value in integer register rs1 is treated as a bit
    # mask that specifies bit positions to be cleared in the CSR."
    addi x0, x0, 3              # HINT marker: Test case 3 - CSRRC
    li t4, 0x08                 # Bit mask for clearing bits
    csrrc t5, 0x001, t4         # Clear bits in fflags, read old value to t5
    
    # Test 4: Test with x0 register behavior
    # "For both CSRRS and CSRRC, if rs1=x0, then the instruction will not write
    # to the CSR at all, and so shall not cause any of the side effects that might
    # otherwise occur on a CSR write"
    addi x0, x0, 4              # HINT marker: Test case 4 - CSR read-only with x0
    csrrs t6, 0x001, x0         # Read fflags without modifying (rs1=x0)
    csrrc a0, 0x001, x0         # Read fflags without modifying (rs1=x0)
    
    # Test 5: CSRRWI (Immediate variants - 5-bit zero-extended immediate)
    # "The immediate forms use a 5-bit zero-extended immediate encoded in the
    # rs1 field."
    addi x0, x0, 5              # HINT marker: Test case 5 - CSRRWI
    csrrwi a1, 0x001, 0x05      # Write immediate 0x05 to fflags
    
    # Test 6: CSRRSI (Atomic Read and Set Bits Immediate)
    addi x0, x0, 6              # HINT marker: Test case 6 - CSRRSI
    csrrsi a2, 0x001, 0x02      # Set bit 1 in fflags using immediate
    
    # Test 7: CSRRCI (Atomic Read and Clear Bits Immediate)
    addi x0, x0, 7              # HINT marker: Test case 7 - CSRRCI
    csrrci a3, 0x001, 0x04      # Clear bit 2 in fflags using immediate
    
    # Test 8: Test with common user-accessible CSRs
    # Reading cycle counter (CSR 0xC00)
    addi x0, x0, 8              # HINT marker: Test case 8 - cycle/time/instret
    csrr a4, 0xC00              # Read cycle counter (pseudo-instruction: csrrs rd, csr, x0)
    
    # Reading time counter (CSR 0xC01)
    csrr a5, 0xC01              # Read time counter
    
    # Reading instructions retired counter (CSR 0xC02)
    csrr a6, 0xC02              # Read instret counter
    
    # Test 9: Test floating-point CSRs (accessible with F or D extension)
    # frm - Floating-point rounding mode (CSR 0x002)
    addi x0, x0, 9              # HINT marker: Test case 9 - FP CSRs
    li s0, 0x01                 # Rounding mode: towards zero
    csrrw s1, 0x002, s0         # Set rounding mode, read old value
    
    # fcsr - Floating-point control and status register (CSR 0x003)
    li s2, 0x00                 # Clear all flags
    csrrw s3, 0x003, s2         # Write to fcsr, read old value
    
    # Test 10: Test read-only CSRs (cycle, time, instret have high bits in RV32)
    addi x0, x0, 10             # HINT marker: Test case 10 - high CSRs
    csrr s4, 0xC80              # Read cycleh (upper 32 bits of cycle on RV32)
    csrr s5, 0xC81              # Read timeh (upper 32 bits of time on RV32)
    csrr s6, 0xC82              # Read instreth (upper 32 bits of instret on RV32)
    
    # Test 11: Demonstrate atomic read-modify-write behavior
    addi x0, x0, 11             # HINT marker: Test case 11 - atomic RMW
    li t0, 0xFF
    csrrw t1, 0x001, t0         # Write 0xFF, read old value
    csrrs t2, 0x001, x0         # Read current value (should be 0xFF or masked)
    li t3, 0x0F
    csrrc t4, 0x001, t3         # Clear lower 4 bits, read old value
    
    # Exit
    li a7, 93                   # sys_exit
    li a0, 0
    ecall
