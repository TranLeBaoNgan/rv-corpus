# RV32D Double-Precision Floating-Point Extension Test
# Reference: RISC-V Unprivileged ISA Specification
# https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html
# Chapter: "D" Extension for Double-Precision Floating-Point, Version 2.2

# From the specification:
# "This chapter describes the standard double-precision floating-point instruction-set
# extension, which is named 'D' and adds double-precision floating-point computational
# instructions compliant with the IEEE 754-2008 arithmetic standard."

.globl _start
.section .text

_start:
    # D Extension State
    # "The D extension widens the 32 floating-point registers, f0-f31, to 64 bits
    # (FLEN=64 in Figure 11.1). The f registers can now hold either 32-bit or 64-bit
    # floating-point values as described below in Section 11.2."
    
    # Test 1: Load/Store Instructions
    # "FLD and FSD are the double-precision floating-point load and store instructions."
    addi x0, x0, 1              # HINT marker: Test case 1 - FLD/FSD
    la t0, fp_data_double
    fld f0, 0(t0)               # Load double-precision float from memory
    fld f1, 8(t0)               # Load another double (8-byte aligned)
    fsd f0, 16(t0)              # Store double to memory
    
    # Test 2: Double-Precision Computational Instructions
    # "The double-precision floating-point computational instructions are defined
    # analogously to their single-precision counterparts, but operate on double-precision
    # operands and produce double-precision results."
    
    # FADD.D - Double-precision floating-point add
    addi x0, x0, 2              # HINT marker: Test case 2 - FADD.D
    fadd.d f2, f0, f1           # f2 = f0 + f1
    
    # Test 3: FSUB.D - Double-precision floating-point subtract
    addi x0, x0, 3              # HINT marker: Test case 3 - FSUB.D
    fsub.d f3, f0, f1           # f3 = f0 - f1
    
    # Test 4: FMUL.D - Double-precision floating-point multiply
    addi x0, x0, 4              # HINT marker: Test case 4 - FMUL.D
    fmul.d f4, f0, f1           # f4 = f0 * f1
    
    # Test 5: FDIV.D - Double-precision floating-point divide
    addi x0, x0, 5              # HINT marker: Test case 5 - FDIV.D
    fdiv.d f5, f0, f1           # f5 = f0 / f1
    
    # Test 6: FSQRT.D - Double-precision floating-point square root
    addi x0, x0, 6              # HINT marker: Test case 6 - FSQRT.D
    fsqrt.d f6, f0              # f6 = sqrt(f0)
    
    # Test 7: Double-Precision Fused Multiply-Add Instructions
    # "The double-precision fused multiply-add instructions have the same behavior
    # as their single-precision counterparts, operating on double-precision values."
    
    # FMADD.D - Fused multiply-add
    addi x0, x0, 7              # HINT marker: Test case 7 - FMADD.D
    fmadd.d f7, f0, f1, f2      # f7 = (f0 * f1) + f2
    
    # Test 8: FMSUB.D - Fused multiply-subtract
    addi x0, x0, 8              # HINT marker: Test case 8 - FMSUB.D
    fmsub.d f8, f0, f1, f2      # f8 = (f0 * f1) - f2
    
    # Test 9: FNMADD.D - Fused negative multiply-add
    addi x0, x0, 9              # HINT marker: Test case 9 - FNMADD.D
    fnmadd.d f9, f0, f1, f2     # f9 = -(f0 * f1) + f2
    
    # Test 10: FNMSUB.D - Fused negative multiply-subtract
    addi x0, x0, 10             # HINT marker: Test case 10 - FNMSUB.D
    fnmsub.d f10, f0, f1, f2    # f10 = -(f0 * f1) - f2
    
    # Test 11: Sign-Injection Instructions
    # "Sign-injection instructions for double-precision."
    addi x0, x0, 11             # HINT marker: Test case 11 - FSGNJ.D
    fsgnj.d f11, f0, f1         # f11 = |f0| with sign of f1
    fsgnjn.d f12, f0, f1        # f12 = |f0| with opposite sign of f1
    fsgnjx.d f13, f0, f1        # f13 = |f0| with XOR of signs
    
    # Test 12: Minimum/Maximum Instructions
    addi x0, x0, 12             # HINT marker: Test case 12 - FMIN.D/FMAX.D
    fmin.d f14, f0, f1          # f14 = min(f0, f1)
    fmax.d f15, f0, f1          # f15 = max(f0, f1)
    
    # Test 13: Comparison Instructions
    # "The double-precision floating-point compare instructions are defined analogously
    # to their single-precision counterparts, but operate on double-precision operands."
    addi x0, x0, 13             # HINT marker: Test case 13 - FEQ.D/FLT.D/FLE.D
    feq.d t1, f0, f1            # t1 = (f0 == f1) ? 1 : 0
    flt.d t2, f0, f1            # t2 = (f0 < f1) ? 1 : 0
    fle.d t3, f0, f1            # t3 = (f0 <= f1) ? 1 : 0
    
    # Test 14: Classification Instruction
    # "As with floating-point compare instructions, FCLASS.D examines the double-precision
    # value in floating-point register rs1."
    addi x0, x0, 14             # HINT marker: Test case 14 - FCLASS.D
    fclass.d t4, f0             # t4 = classification bits of f0
    
    # Test 15: Conversion Instructions - Double/Integer
    # "Floating-point-to-integer and integer-to-floating-point conversion instructions
    # operate on double-precision values."
    
    # FCVT.W.D - Convert double to signed 32-bit integer
    addi x0, x0, 15             # HINT marker: Test case 15 - FCVT.W.D/FCVT.WU.D
    fcvt.w.d t5, f0             # t5 = (int32_t)f0
    
    # FCVT.WU.D - Convert double to unsigned 32-bit integer
    fcvt.wu.d t6, f0            # t6 = (uint32_t)f0
    
    # Test 16: FCVT.D.W - Convert signed 32-bit integer to double
    addi x0, x0, 16             # HINT marker: Test case 16 - FCVT.D.W/FCVT.D.WU
    li a0, 42
    fcvt.d.w f16, a0            # f16 = (double)42
    
    # FCVT.D.WU - Convert unsigned 32-bit integer to double
    li a1, 100
    fcvt.d.wu f17, a1           # f17 = (double)100
    
    # Test 17: Conversion Instructions - Single/Double
    # "New floating-point-to-floating-point conversion instructions FCVT.S.D and
    # FCVT.D.S are added which convert between single and double-precision."
    
    # Load a single-precision value for conversion test
    addi x0, x0, 17             # HINT marker: Test case 17 - FCVT.D.S/FCVT.S.D
    la t0, fp_data_single
    flw f18, 0(t0)              # Load single-precision
    
    # FCVT.D.S - Convert single-precision to double-precision
    fcvt.d.s f19, f18           # f19 = (double)f18
    
    # FCVT.S.D - Convert double-precision to single-precision
    fcvt.s.d f20, f0            # f20 = (float)f0
    
    # Test 18: NaN Boxing
    # "When multiple floating-point precisions are supported, then valid values of
    # narrower n-bit types, n < FLEN, are represented in the lower n bits of an
    # FLEN-bit NaN value, in a process termed NaN-boxing."
    # Single-precision values in double-precision registers are NaN-boxed
    
    # Test operations on NaN-boxed values
    addi x0, x0, 18             # HINT marker: Test case 18 - NaN boxing
    fadd.s f21, f20, f18        # Single-precision add with NaN-boxed values
    
    # Exit
    li a7, 93                   # sys_exit
    li a0, 0
    ecall

.section .data
.align 3                        # Align to 8-byte boundary for doubles
fp_data_double:
    .double 3.141592653589793   # Pi (double precision)
    .double 2.718281828459045   # e (double precision)
    .double 0.0                 # Space for store
    .double 1.414213562373095   # sqrt(2) (double precision)

.align 2                        # Align to 4-byte boundary for floats
fp_data_single:
    .float 1.5                  # Single-precision for conversion test
    .float 2.5
