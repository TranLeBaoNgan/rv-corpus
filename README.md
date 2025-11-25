# RiscV Assembly Test Corpus

A comprehensive test corpus of RiscV assembly programs for testing RiscV compilers, emulators, and recompilers like rv286.

## Overview

This corpus contains hand-written assembly tests targeting different RiscV instruction set configurations:
- **RV32I**: 32-bit base integer instruction set
- **RV64I**: 64-bit base integer instruction set  
- **RV32IM**: 32-bit with M extension (multiply/divide)
- **RV64IM**: 64-bit with M extension
- **RV32IMA**: 32-bit with M and A extensions (atomic operations)
- **RV64IMA**: 64-bit with M and A extensions
- **RV32I_Zicsr**: 32-bit with Zicsr extension (CSR instructions)
- **RV32F**: 32-bit with F extension (single-precision floating-point)
- **RV32D**: 32-bit with D extension (double-precision floating-point)
- **RV32FD**: 32-bit with F and D extensions (combined floating-point)
- **RV64D**: 64-bit with D extension (double-precision floating-point, RV64-only instructions)

All tests are compiled using LLVM/Clang toolchain and include verbatim citations from the RISC-V Unprivileged ISA Specification as comments.

### Specification References

- **For AI agents and automated tools**: Download the specification directly from: `https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html` - This file can be downloaded using `wget` or `curl` to bypass network restrictions.
- **For human review**: The same link provides the full specification with proper formatting: [RISC-V Unprivileged ISA Specification](https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html)

## Test Organization

### RV32I Tests (corpus/rv32i/)
- **01_integer_computational.s**: Tests all integer computational instructions
  - Register-immediate operations (ADDI, SLTI, SLTIU, ANDI, ORI, XORI)
  - Shift operations (SLLI, SRLI, SRAI)
  - Upper immediate operations (LUI, AUIPC)
  - Register-register operations (ADD, SUB, SLL, SRL, SRA, SLT, SLTU, AND, OR, XOR)
  
- **02_control_transfer.s**: Tests control flow instructions
  - Unconditional jumps (JAL, JALR)
  - Conditional branches (BEQ, BNE, BLT, BLTU, BGE, BGEU)
  - Forward and backward branches
  
- **03_load_store.s**: Tests memory access instructions
  - Load operations (LW, LH, LHU, LB, LBU)
  - Store operations (SW, SH, SB)
  - Sign extension vs zero extension
  - Positive and negative offsets
  
- **04_edge_cases.s**: Tests boundary conditions and corner cases
  - Arithmetic overflow/underflow
  - Maximum/minimum values
  - Division by zero
  - Zero register behavior
  - Maximum shift amounts
  
- **05_simple_program.s**: Practical program examples
  - Recursive factorial calculation
  - Fibonacci sequence
  - Array sum
  - Demonstrates real-world instruction combinations

- **06_nop_and_hints.s**: Tests NOP and hint instructions
  - NOP instruction behavior
  - Hint instructions (encoded as operations to x0)
  - Zero register hardwired behavior
  - Verification that NOPs don't affect state

- **07_pseudo_instructions.s**: Tests pseudo-instructions
  - Common pseudo-instructions (MV, NOT, NEG, SEQZ, SNEZ, etc.)
  - Branch pseudo-instructions (BEQZ, BNEZ, BLEZ, BGEZ, etc.)
  - Jump pseudo-instructions (J, JR, RET, CALL)
  - Load address (LA)

### RV32IM Tests (corpus/rv32im/)
- **01_multiply_divide.s**: Tests M extension instructions
  - Multiplication operations (MUL, MULH, MULHU, MULHSU)
  - Division operations (DIV, DIVU, REM, REMU)
  - Overflow and division by zero cases
  - Signed vs unsigned operations

### RV32IMA Tests (corpus/rv32ima/)
- **01_atomic_operations.s**: Tests A extension instructions
  - Load-reserved/store-conditional (LR.W, SC.W)
  - Atomic memory operations (AMOSWAP, AMOADD, AMOXOR, AMOAND, AMOOR)
  - Atomic min/max (AMOMIN, AMOMAX, AMOMINU, AMOMAXU)
  - Memory ordering annotations (acquire/release)
  - Fence instructions

### RV64I Tests (corpus/rv64i/)
- **01_basic_64bit.s**: Tests 64-bit specific instructions
  - 64-bit register operations
  - Word operations (ADDIW, SLLIW, SRLIW, SRAIW, ADDW, SUBW, SLLW, SRLW, SRAW)
  - 64-bit loads and stores (LD, SD, LWU)
  - Sign extension behavior in 64-bit mode

### RV64IM Tests (corpus/rv64im/)
- **01_multiply_divide_64.s**: Tests 64-bit M extension instructions
  - 64-bit multiplication operations (MUL, MULH, MULHU, MULHSU)
  - 64-bit division operations (DIV, DIVU, REM, REMU)
  - Word operations (MULW, DIVW, DIVUW, REMW, REMUW)
  - Overflow and division by zero in 64-bit mode

### RV32I_Zicsr Tests (rv32i_zicsr/)
- **01_csr_instructions.s**: Tests Zicsr extension CSR instructions
  - Atomic read-modify-write operations (CSRRW, CSRRS, CSRRC)
  - Immediate variants (CSRRWI, CSRRSI, CSRRCI)
  - User-accessible CSRs (cycle, time, instret counters)
  - Floating-point CSRs (fflags, frm, fcsr)
  - x0 register behavior for side-effect control

### RV32F Tests (rv32f/)
- **01_single_precision_fp.s**: Tests F extension single-precision floating-point instructions
  - Load/store operations (FLW, FSW)
  - Arithmetic operations (FADD.S, FSUB.S, FMUL.S, FDIV.S, FSQRT.S)
  - Fused multiply-add (FMADD.S, FMSUB.S, FNMADD.S, FNMSUB.S)
  - Sign-injection (FSGNJ.S, FSGNJN.S, FSGNJX.S)
  - Min/max operations (FMIN.S, FMAX.S)
  - Comparison operations (FEQ.S, FLT.S, FLE.S)
  - Classification (FCLASS.S)
  - Conversions (FCVT.W.S, FCVT.WU.S, FCVT.S.W, FCVT.S.WU)
  - Move operations (FMV.X.W, FMV.W.X)

### RV32D Tests (rv32d/)
- **01_double_precision_fp.s**: Tests D extension double-precision floating-point instructions
  - Load/store operations (FLD, FSD)
  - Arithmetic operations (FADD.D, FSUB.D, FMUL.D, FDIV.D, FSQRT.D)
  - Fused multiply-add (FMADD.D, FMSUB.D, FNMADD.D, FNMSUB.D)
  - Sign-injection (FSGNJ.D, FSGNJN.D, FSGNJX.D)
  - Min/max operations (FMIN.D, FMAX.D)
  - Comparison operations (FEQ.D, FLT.D, FLE.D)
  - Classification (FCLASS.D)
  - Conversions (FCVT.W.D, FCVT.WU.D, FCVT.D.W, FCVT.D.WU)
  - Single/double conversions (FCVT.S.D, FCVT.D.S)
  - NaN-boxing behavior

### RV32FD Tests (rv32fd/)
- **01_combined_fp.s**: Tests combined F and D extension interoperability
  - Mixed precision operations
  - Conversions between single and double precision
  - Combined arithmetic with both precisions
  - Integer conversions for both float types

### RV64D Tests (rv64d/)
- **01_rv64_double_precision_fp.s**: Tests RV64-only D extension instructions
  - 64-bit integer conversions (FCVT.L.D, FCVT.LU.D, FCVT.D.L, FCVT.D.LU)
  - Double-precision move operations (FMV.X.D, FMV.D.X)
  - Sign extension behavior for 32-bit conversions
  - Bit pattern preservation for non-canonical NaNs
  - Tests with max/min int64 and uint64 values

## Using This Corpus

### As a Git Submodule (Recommended)

The recommended way to use this corpus in your project is as a git submodule:

```bash
# Add the corpus as a submodule
git submodule add https://github.com/portal-co/rv-corpus.git corpus

# Clone a project with this submodule
git clone --recurse-submodules <your-project-url>

# Update an existing submodule
git submodule update --init --recursive
```

This ensures you always have the latest test binaries and mappings synchronized with your project.

## Compilation

### Prerequisites
- LLVM/Clang with RiscV target support (version 10.0 or later)
- The tests have been written to compile with the LLVM toolchain

### Building the Corpus
```bash
cd corpus
./compile_corpus.sh
```

This will compile all tests and produce ELF binaries ready for execution or recompilation.

### Manual Compilation Examples
```bash
# RV32I test
clang --target=riscv32 -march=rv32i -mabi=ilp32 -nostdlib -static \
  rv32i/01_integer_computational.s -o rv32i/01_integer_computational

# RV32IM test
clang --target=riscv32 -march=rv32im -mabi=ilp32 -nostdlib -static \
  rv32im/01_multiply_divide.s -o rv32im/01_multiply_divide

# RV64I test  
clang --target=riscv64 -march=rv64i -mabi=lp64 -nostdlib -static \
  rv64i/01_basic_64bit.s -o rv64i/01_basic_64bit
```

## Testing with rv286

The rv286 recompiler currently supports **RV32I only**. The corpus includes tests for other ISA variants (RV32IM, RV32IMA, RV64I, RV64IM, RV64IMA) which can be used to test other RiscV tools, but these are not compatible with rv286.

To test the RV32I corpus with rv286:

```bash
# Automated testing
./corpus/test_rv286.sh

# Manual testing of individual tests
./rv286.sh corpus/rv32i/01_integer_computational corpus/rv32i/01_integer_computational.x86
```

The test script automatically tests all RV32I binaries and reports success/failure.

## Specification References

All tests include citations from the RISC-V Unprivileged ISA Specification:
- **Chapter 2**: RV32I Base Integer Instruction Set
- **Chapter 5**: RV64I Base Integer Instruction Set  
- **Chapter 7**: "M" Standard Extension for Integer Multiplication and Division
- **Chapter 8**: "A" Standard Extension for Atomic Instructions
- **Chapter 9**: "Zicsr" Extension for Control and Status Register Instructions
- **Chapter 11**: "F" Extension for Single-Precision Floating-Point
- **Chapter 12**: "D" Extension for Double-Precision Floating-Point

Each instruction test is documented with relevant specification quotes to ensure correctness.

## Test Status

| ISA Variant | Tests | Compilation | rv286 Support |
|-------------|-------|-------------|---------------|
| RV32I       | 7     | ✓           | ✓             |
| RV32IM      | 1     | ✓           | ✗             |
| RV32IMA     | 1     | ✓           | ✗             |
| RV32I_Zicsr | 1     | ✓           | ✗             |
| RV32F       | 1     | ✓           | ✗             |
| RV32D       | 1     | ✓           | ✗             |
| RV32FD      | 1     | ✓           | ✗             |
| RV64I       | 1     | ✓           | ✗             |
| RV64IM      | 1     | ✓           | ✗             |
| RV64IMA     | 0     | -           | ✗             |
| RV64D       | 1     | ✓           | ✗             |

**Note**: rv286 currently only supports RV32I. The other ISA variants (RV32IM, RV32IMA, RV64I, RV64IM, RV64IMA) are included in the corpus for completeness and testing other RiscV tools, but are not compatible with rv286.

## Known Issues and Test Results

### rv286 Test Results (RV32I only)

All 7 RV32I tests successfully recompile with rv286:
- ✓ 01_integer_computational.s
- ✓ 02_control_transfer.s
- ✓ 03_load_store.s
- ✓ 04_edge_cases.s
- ✓ 05_simple_program.s
- ✓ 06_nop_and_hints.s
- ✓ 07_pseudo_instructions.s

**Note**: Tests for other ISA variants (RV32IM, RV32IMA, RV64I, RV64IM, RV64IMA) are not tested with rv286 as it only supports RV32I. These tests are provided for testing other RiscV compilers and emulators.

## Future Work

- Add more complex RV64I tests
- Add RV64IM and RV64IMA tests
- Add tests for trap handling
- Add performance benchmarks
- Add tests for compressed instructions (C extension)
- Add tests for Q extension (quad-precision floating-point)
- Add tests for vector extensions (V)

## Contributing

When adding new tests:
1. Follow the naming convention: `XX_description.s`
2. Include specification citations as comments
3. Document the purpose and expected behavior
4. Test compilation with LLVM tools
5. Update this README with test descriptions

## License

This corpus is provided as part of the rv286 project. See the repository LICENSE file for details.
