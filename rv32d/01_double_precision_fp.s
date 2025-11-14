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
    
    # Load/Store Instructions
    # "FLD and FSD are the double-precision floating-point load and store instructions."
    la t0, fp_data_double
    fld f0, 0(t0)               # Load double-precision float from memory
    fld f1, 8(t0)               # Load another double (8-byte aligned)
    fsd f0, 16(t0)              # Store double to memory
    
    # Double-Precision Computational Instructions
    # "The double-precision floating-point computational instructions are defined
    # analogously to their single-precision counterparts, but operate on double-precision
    # operands and produce double-precision results."
    
    # FADD.D - Double-precision floating-point add
    fadd.d f2, f0, f1           # f2 = f0 + f1
    
    # FSUB.D - Double-precision floating-point subtract
    fsub.d f3, f0, f1           # f3 = f0 - f1
    
    # FMUL.D - Double-precision floating-point multiply
    fmul.d f4, f0, f1           # f4 = f0 * f1
    
    # FDIV.D - Double-precision floating-point divide
    fdiv.d f5, f0, f1           # f5 = f0 / f1
    
    # FSQRT.D - Double-precision floating-point square root
    fsqrt.d f6, f0              # f6 = sqrt(f0)
    
    # Double-Precision Fused Multiply-Add Instructions
    # "The double-precision fused multiply-add instructions have the same behavior
    # as their single-precision counterparts, operating on double-precision values."
    
    # FMADD.D - Fused multiply-add
    fmadd.d f7, f0, f1, f2      # f7 = (f0 * f1) + f2
    
    # FMSUB.D - Fused multiply-subtract
    fmsub.d f8, f0, f1, f2      # f8 = (f0 * f1) - f2
    
    # FNMADD.D - Fused negative multiply-add
    fnmadd.d f9, f0, f1, f2     # f9 = -(f0 * f1) + f2
    
    # FNMSUB.D - Fused negative multiply-subtract
    fnmsub.d f10, f0, f1, f2    # f10 = -(f0 * f1) - f2
    
    # Sign-Injection Instructions
    # "Sign-injection instructions for double-precision."
    fsgnj.d f11, f0, f1         # f11 = |f0| with sign of f1
    fsgnjn.d f12, f0, f1        # f12 = |f0| with opposite sign of f1
    fsgnjx.d f13, f0, f1        # f13 = |f0| with XOR of signs
    
    # Minimum/Maximum Instructions
    fmin.d f14, f0, f1          # f14 = min(f0, f1)
    fmax.d f15, f0, f1          # f15 = max(f0, f1)
    
    # Comparison Instructions
    # "The double-precision floating-point compare instructions are defined analogously
    # to their single-precision counterparts, but operate on double-precision operands."
    feq.d t1, f0, f1            # t1 = (f0 == f1) ? 1 : 0
    flt.d t2, f0, f1            # t2 = (f0 < f1) ? 1 : 0
    fle.d t3, f0, f1            # t3 = (f0 <= f1) ? 1 : 0
    
    # Classification Instruction
    # "As with floating-point compare instructions, FCLASS.D examines the double-precision
    # value in floating-point register rs1."
    fclass.d t4, f0             # t4 = classification bits of f0
    
    # Conversion Instructions - Double/Integer
    # "Floating-point-to-integer and integer-to-floating-point conversion instructions
    # operate on double-precision values."
    
    # FCVT.W.D - Convert double to signed 32-bit integer
    fcvt.w.d t5, f0             # t5 = (int32_t)f0
    
    # FCVT.WU.D - Convert double to unsigned 32-bit integer
    fcvt.wu.d t6, f0            # t6 = (uint32_t)f0
    
    # FCVT.D.W - Convert signed 32-bit integer to double
    li a0, 42
    fcvt.d.w f16, a0            # f16 = (double)42
    
    # FCVT.D.WU - Convert unsigned 32-bit integer to double
    li a1, 100
    fcvt.d.wu f17, a1           # f17 = (double)100
    
    # Conversion Instructions - Single/Double
    # "New floating-point-to-floating-point conversion instructions FCVT.S.D and
    # FCVT.D.S are added which convert between single and double-precision."
    
    # Load a single-precision value for conversion test
    la t0, fp_data_single
    flw f18, 0(t0)              # Load single-precision
    
    # FCVT.D.S - Convert single-precision to double-precision
    fcvt.d.s f19, f18           # f19 = (double)f18
    
    # FCVT.S.D - Convert double-precision to single-precision
    fcvt.s.d f20, f0            # f20 = (float)f0
    
    # NaN Boxing
    # "When multiple floating-point precisions are supported, then valid values of
    # narrower n-bit types, n < FLEN, are represented in the lower n bits of an
    # FLEN-bit NaN value, in a process termed NaN-boxing."
    # Single-precision values in double-precision registers are NaN-boxed
    
    # Test operations on NaN-boxed values
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
