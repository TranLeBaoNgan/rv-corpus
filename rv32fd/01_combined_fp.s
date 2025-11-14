# RV32FD Combined Floating-Point Extension Test
# Reference: RISC-V Unprivileged ISA Specification
# https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html
# Chapters: "F" Extension for Single-Precision and "D" Extension for Double-Precision

# From the F Extension specification:
# "This chapter describes the standard instruction-set extension for single-precision
# floating-point, which is named 'F' and adds single-precision floating-point
# computational instructions compliant with the IEEE 754-2008 arithmetic standard."

# From the D Extension specification:
# "This chapter describes the standard double-precision floating-point instruction-set
# extension, which is named 'D' and adds double-precision floating-point computational
# instructions compliant with the IEEE 754-2008 arithmetic standard."

.globl _start
.section .text

_start:
    # Test interoperability between single and double precision
    la t0, test_data
    
    # Load single and double precision values
    flw f0, 0(t0)               # Load single-precision
    fld f1, 8(t0)               # Load double-precision
    
    # Single-precision operations
    flw f2, 4(t0)
    fadd.s f3, f0, f2           # Single-precision add
    fmul.s f4, f0, f2           # Single-precision multiply
    
    # Double-precision operations
    fld f5, 16(t0)
    fadd.d f6, f1, f5           # Double-precision add
    fmul.d f7, f1, f5           # Double-precision multiply
    
    # Conversions between precisions
    # "New floating-point-to-floating-point conversion instructions FCVT.S.D and
    # FCVT.D.S are added which convert between single and double-precision."
    fcvt.d.s f8, f0             # Convert single to double
    fcvt.s.d f9, f1             # Convert double to single
    
    # Mixed precision arithmetic (via conversions)
    fcvt.d.s f10, f3            # Convert single result to double
    fadd.d f11, f10, f6         # Add converted single to double
    
    # Test fused multiply-add with both precisions
    fmadd.s f12, f0, f2, f3     # Single-precision FMA
    fmadd.d f13, f1, f5, f6     # Double-precision FMA
    
    # Comparison operations
    feq.s t1, f0, f2            # Single-precision equality
    flt.d t2, f1, f5            # Double-precision less than
    
    # Integer conversions for both types
    fcvt.w.s a0, f0             # Single to int
    fcvt.w.d a1, f1             # Double to int
    
    li a2, 123
    fcvt.s.w f14, a2            # Int to single
    fcvt.d.w f15, a2            # Int to double
    
    # Store results
    fsw f9, 24(t0)              # Store converted single
    fsd f8, 32(t0)              # Store converted double
    
    # Exit
    li a7, 93
    li a0, 0
    ecall

.section .data
.align 3
test_data:
    .float 1.5                  # Single-precision value
    .float 2.5                  # Another single-precision value
    .double 3.14159265359       # Double-precision value
    .double 2.71828182846       # Another double-precision value
    .float 0.0                  # Space for single store
    .space 4                    # Alignment padding
    .double 0.0                 # Space for double store
