# RV32F Single-Precision Floating-Point Extension Test
# Reference: RISC-V Unprivileged ISA Specification
# https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html
# Chapter: "F" Extension for Single-Precision Floating-Point, Version 2.2

# From the specification:
# "This chapter describes the standard instruction-set extension for single-precision
# floating-point, which is named 'F' and adds single-precision floating-point
# computational instructions compliant with the IEEE 754-2008 arithmetic standard."

.globl _start
.section .text

_start:
    # F Extension State
    # "The F extension adds 32 floating-point registers, f0-f31, each 32 bits wide,
    # and a floating-point control and status register fcsr, which contains the
    # operating mode and exception status of the floating-point unit."
    
    # Test 1: Load/Store Instructions
    # "FLW and FSW are the single-precision floating-point load and store instructions."
    addi x0, x0, 1              # HINT marker: Test case 1 - FLW/FSW
    la t0, fp_data
    flw f0, 0(t0)               # Load single-precision float from memory
    flw f1, 4(t0)               # Load another float
    fsw f0, 8(t0)               # Store float to memory
    
    # Test 2: Floating-Point Computational Instructions
    # "Floating-point arithmetic instructions with one or two source operands use
    # the FPU's control and status register (fcsr) to determine the rounding mode
    # and to report exceptions."
    
    # FADD.S - Single-precision floating-point add
    # "FADD.S performs single-precision floating-point addition."
    addi x0, x0, 2              # HINT marker: Test case 2 - FADD.S
    fadd.s f2, f0, f1           # f2 = f0 + f1
    
    # Test 3: FSUB.S - Single-precision floating-point subtract
    # "FSUB.S performs single-precision floating-point subtraction."
    addi x0, x0, 3              # HINT marker: Test case 3 - FSUB.S
    fsub.s f3, f0, f1           # f3 = f0 - f1
    
    # Test 4: FMUL.S - Single-precision floating-point multiply
    # "FMUL.S performs single-precision floating-point multiplication."
    addi x0, x0, 4              # HINT marker: Test case 4 - FMUL.S
    fmul.s f4, f0, f1           # f4 = f0 * f1
    
    # Test 5: FDIV.S - Single-precision floating-point divide
    # "FDIV.S performs single-precision floating-point division."
    addi x0, x0, 5              # HINT marker: Test case 5 - FDIV.S
    fdiv.s f5, f0, f1           # f5 = f0 / f1
    
    # Test 6: FSQRT.S - Single-precision floating-point square root
    # "Floating-point square root instructions are provided for each supported
    # floating-point format."
    addi x0, x0, 6              # HINT marker: Test case 6 - FSQRT.S
    fsqrt.s f6, f0              # f6 = sqrt(f0)
    
    # Test 7: Floating-Point Fused Multiply-Add Instructions
    # "The fused multiply-add instructions must set the invalid operation exception
    # flag when the multiplicands are infinity and zero, even when the addend is a
    # quiet NaN."
    
    # FMADD.S - Fused multiply-add: (f0 * f1) + f2
    addi x0, x0, 7              # HINT marker: Test case 7 - FMADD.S
    fmadd.s f7, f0, f1, f2      # f7 = (f0 * f1) + f2
    
    # Test 8: FMSUB.S - Fused multiply-subtract: (f0 * f1) - f2
    addi x0, x0, 8              # HINT marker: Test case 8 - FMSUB.S
    fmsub.s f8, f0, f1, f2      # f8 = (f0 * f1) - f2
    
    # Test 9: FNMADD.S - Fused negative multiply-add: -(f0 * f1) + f2
    addi x0, x0, 9              # HINT marker: Test case 9 - FNMADD.S
    fnmadd.s f9, f0, f1, f2     # f9 = -(f0 * f1) + f2
    
    # Test 10: FNMSUB.S - Fused negative multiply-subtract: -(f0 * f1) - f2
    addi x0, x0, 10             # HINT marker: Test case 10 - FNMSUB.S
    fnmsub.s f10, f0, f1, f2    # f10 = -(f0 * f1) - f2
    
    # Test 11: Sign-Injection Instructions
    # "Sign-injection instructions, FSGNJ.S, FSGNJN.S, and FSGNJX.S, produce a result
    # that takes all bits except the sign bit from rs1."
    
    # FSGNJ.S - Sign-inject (copy sign from f1 to f0's magnitude)
    addi x0, x0, 11             # HINT marker: Test case 11 - FSGNJ.S
    fsgnj.s f11, f0, f1         # f11 = |f0| with sign of f1
    
    # Test 12: FSGNJN.S - Sign-inject negated
    addi x0, x0, 12             # HINT marker: Test case 12 - FSGNJN.S
    fsgnjn.s f12, f0, f1        # f12 = |f0| with opposite sign of f1
    
    # Test 13: FSGNJX.S - Sign-inject XOR
    addi x0, x0, 13             # HINT marker: Test case 13 - FSGNJX.S
    fsgnjx.s f13, f0, f1        # f13 = |f0| with XOR of signs
    
    # Test 14: Minimum/Maximum Instructions
    # "The FMIN.S and FMAX.S instructions return the smaller or larger of rs1 and rs2."
    addi x0, x0, 14             # HINT marker: Test case 14 - FMIN.S/FMAX.S
    fmin.s f14, f0, f1          # f14 = min(f0, f1)
    fmax.s f15, f0, f1          # f15 = max(f0, f1)
    
    # Test 15: Comparison Instructions
    # "Floating-point compare instructions perform the specified comparison between
    # floating-point registers, writing 1 to the integer register rd if the condition
    # holds, and 0 otherwise."
    
    # FEQ.S - Floating-point equal
    addi x0, x0, 15             # HINT marker: Test case 15 - FEQ.S/FLT.S/FLE.S
    feq.s t1, f0, f1            # t1 = (f0 == f1) ? 1 : 0
    
    # FLT.S - Floating-point less than
    flt.s t2, f0, f1            # t2 = (f0 < f1) ? 1 : 0
    
    # FLE.S - Floating-point less than or equal
    fle.s t3, f0, f1            # t3 = (f0 <= f1) ? 1 : 0
    
    # Test 16: Classification Instruction
    # "The FCLASS.S instruction examines the value in floating-point register rs1
    # and writes to integer register rd a 10-bit mask that indicates the class of
    # the floating-point number."
    addi x0, x0, 16             # HINT marker: Test case 16 - FCLASS.S
    fclass.s t4, f0             # t4 = classification bits of f0
    
    # Test 17: Conversion Instructions
    # "Floating-point-to-integer and integer-to-floating-point conversion instructions
    # are encoded in the OP-FP major opcode space."
    
    # FCVT.W.S - Convert float to signed 32-bit integer
    addi x0, x0, 17             # HINT marker: Test case 17 - FCVT.W.S/FCVT.WU.S
    fcvt.w.s t5, f0             # t5 = (int32_t)f0
    
    # FCVT.WU.S - Convert float to unsigned 32-bit integer
    fcvt.wu.s t6, f0            # t6 = (uint32_t)f0
    
    # Test 18: FCVT.S.W - Convert signed 32-bit integer to float
    addi x0, x0, 18             # HINT marker: Test case 18 - FCVT.S.W/FCVT.S.WU
    li a0, 42
    fcvt.s.w f16, a0            # f16 = (float)42
    
    # FCVT.S.WU - Convert unsigned 32-bit integer to float
    li a1, 100
    fcvt.s.wu f17, a1           # f17 = (float)100
    
    # Test 19: Move Instructions
    # "FMV.X.W moves the single-precision value in floating-point register rs1
    # represented in IEEE 754-2008 encoding to the lower 32 bits of integer register rd."
    addi x0, x0, 19             # HINT marker: Test case 19 - FMV.X.W/FMV.W.X
    fmv.x.w a2, f0              # a2 = bit pattern of f0
    
    # "FMV.W.X moves the single-precision value encoded in IEEE 754-2008 standard
    # encoding from the lower 32 bits of integer register rs1 to the floating-point
    # register rd."
    fmv.w.x f18, a2             # f18 = float from bit pattern in a2
    
    # Exit
    li a7, 93                   # sys_exit
    li a0, 0
    ecall

.section .data
fp_data:
    .float 3.14159              # Pi approximation
    .float 2.71828              # e approximation
    .float 0.0                  # Space for store
    .float 1.41421              # sqrt(2) approximation
