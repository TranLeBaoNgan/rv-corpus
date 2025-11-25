# RV64D Double-Precision Floating-Point Extension Test (RV64-only instructions)
# Reference: RISC-V Unprivileged ISA Specification
# https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html
# Chapter 21.5: Double-Precision Floating-Point Conversion and Move Instructions

# From the specification (Section 21.5):
# "Floating-point-to-integer and integer-to-floating-point conversion
# instructions are encoded in the OP-FP major opcode space. FCVT.W.D or
# FCVT.L.D converts a double-precision floating-point number in
# floating-point register rs1 to a signed 32-bit or 64-bit integer,
# respectively, in integer register rd. FCVT.D.W or FCVT.D.L converts a
# 32-bit or 64-bit signed integer, respectively, in integer register rs1
# into a double-precision floating-point number in floating-point register
# rd. FCVT.WU.D, FCVT.LU.D, FCVT.D.WU, and FCVT.D.LU variants convert to
# or from unsigned integer values. For RV64, FCVT.W[U].D sign-extends the
# 32-bit result. FCVT.L[U].D and FCVT.D.L[U] are RV64-only instructions."

.globl _start
.section .text

_start:
    # Test 1: Load test data
    addi x0, x0, 1              # HINT marker: Test case 1 - Load doubles
    la t0, fp_data
    fld f0, 0(t0)               # Load double-precision value (3.14159...)
    fld f1, 8(t0)               # Load another double (2.71828...)
    
    # RV64-only Conversion Instructions
    
    # Test 2: FCVT.L.D - Convert double to signed 64-bit integer
    # "FCVT.L.D converts a double-precision floating-point number in
    # floating-point register rs1 to a signed 32-bit or 64-bit integer"
    addi x0, x0, 2              # HINT marker: Test case 2 - FCVT.L.D
    fcvt.l.d a0, f0             # a0 = (int64_t)f0
    fcvt.l.d a1, f1             # a1 = (int64_t)f1
    
    # Test 3: Test with negative value
    addi x0, x0, 3              # HINT marker: Test case 3 - FCVT.L.D negative
    la t1, fp_data_neg
    fld f2, 0(t1)               # Load negative double
    fcvt.l.d a2, f2             # a2 = (int64_t)f2 (negative)
    
    # Test 4: FCVT.LU.D - Convert double to unsigned 64-bit integer
    # "FCVT.LU.D...variants convert to or from unsigned integer values"
    addi x0, x0, 4              # HINT marker: Test case 4 - FCVT.LU.D
    fcvt.lu.d a3, f0            # a3 = (uint64_t)f0
    fcvt.lu.d a4, f1            # a4 = (uint64_t)f1
    
    # Test 5: Test with large value
    addi x0, x0, 5              # HINT marker: Test case 5 - FCVT.LU.D large
    la t2, fp_data_large
    fld f3, 0(t2)               # Load large double
    fcvt.lu.d a5, f3            # a5 = (uint64_t)f3
    
    # Test 6: FCVT.D.L - Convert signed 64-bit integer to double
    # "FCVT.D.L converts a 32-bit or 64-bit signed integer, respectively, in
    # integer register rs1 into a double-precision floating-point number"
    addi x0, x0, 6              # HINT marker: Test case 6 - FCVT.D.L
    li t3, 9223372036854775807  # Max int64
    fcvt.d.l f4, t3             # f4 = (double)t3
    
    li t4, -9223372036854775808 # Min int64 (approximated)
    fcvt.d.l f5, t4             # f5 = (double)t4
    
    li t5, 42
    fcvt.d.l f6, t5             # f6 = (double)42
    
    # Test 7: FCVT.D.LU - Convert unsigned 64-bit integer to double
    # "FCVT.D.LU variants convert to or from unsigned integer values"
    addi x0, x0, 7              # HINT marker: Test case 7 - FCVT.D.LU
    li t6, 0xFFFFFFFFFFFFFFFF  # Max uint64
    fcvt.d.lu f7, t6            # f7 = (double)t6
    
    li s0, 0x8000000000000000  # Large unsigned value
    fcvt.d.lu f8, s0            # f8 = (double)s0
    
    li s1, 100
    fcvt.d.lu f9, s1            # f9 = (double)100
    
    # RV64-only Move Instructions
    
    # Test 8: FMV.X.D - Move double-precision bits to integer register (RV64-only)
    # From the specification:
    # "FMV.X.D moves the double-precision value in floating-point register rs1
    # to a representation in IEEE 754-2008 standard encoding in integer register rd"
    addi x0, x0, 8              # HINT marker: Test case 8 - FMV.X.D
    fmv.x.d s2, f0              # s2 = bit pattern of f0 (64 bits)
    fmv.x.d s3, f1              # s3 = bit pattern of f1
    
    # Test 9: FMV.D.X - Move integer bits to double-precision register (RV64-only)
    # From the specification:
    # "FMV.X.D and FMV.D.X do not modify the bits being transferred; in
    # particular, the payloads of non-canonical NaNs are preserved."
    
    # "FMV.D.X moves the bit pattern in IEEE 754-2008 standard encoding from
    # the integer register rs1 to the floating-point register rd"
    addi x0, x0, 9              # HINT marker: Test case 9 - FMV.D.X
    fmv.d.x f10, s2             # f10 = double from bit pattern in s2
    fmv.d.x f11, s3             # f11 = double from bit pattern in s3
    
    # Test 10: Test with arbitrary bit pattern
    addi x0, x0, 10             # HINT marker: Test case 10 - Arbitrary bit pattern
    li s4, 0x4009220000000000  # Bit pattern for ~3.14159
    fmv.d.x f12, s4             # f12 = double from bit pattern
    
    # Test 11: Combined operations: convert, move, and verify
    addi x0, x0, 11             # HINT marker: Test case 11 - Combined ops
    fcvt.l.d s5, f0             # Convert double to int64
    fcvt.d.l f13, s5            # Convert back to double
    fmv.x.d s6, f13             # Get bit pattern
    fmv.d.x f14, s6             # Restore from bit pattern
    
    # Test 12: Test 32-bit conversions with sign extension
    # "For RV64, FCVT.W[U].D sign-extends the 32-bit result."
    addi x0, x0, 12             # HINT marker: Test case 12 - FCVT.W.D sign-ext
    fcvt.w.d s7, f0             # Convert to signed 32-bit (sign-extended to 64)
    fcvt.wu.d s8, f0            # Convert to unsigned 32-bit (sign-extended to 64)
    
    # Test 13: Store results
    addi x0, x0, 13             # HINT marker: Test case 13 - Store results
    fsd f4, 16(t0)              # Store converted int64 max
    fsd f7, 24(t0)              # Store converted uint64 max
    fsd f10, 32(t0)             # Store moved value
    
    # Exit
    li a7, 93                   # sys_exit
    li a0, 0
    ecall

.section .data
.align 3                        # Align to 8-byte boundary for doubles
fp_data:
    .double 3.141592653589793   # Pi (double precision)
    .double 2.718281828459045   # e (double precision)
    .double 0.0                 # Space for store
    .double 0.0                 # Space for store
    .double 0.0                 # Space for store

.align 3
fp_data_neg:
    .double -123.456789         # Negative double for testing

.align 3
fp_data_large:
    .double 1.8446744073709552e19  # Large value near uint64 max
