# RISC-V HINT Instructions Documentation

This document describes the HINT instruction formats used in this test corpus for marking test case boundaries and providing metadata to emulators, recompilers, and testing tools.

## Overview

HINT instructions are RISC-V instructions that are architecturally defined as no-ops but can convey information to the microarchitecture or tooling. According to the RISC-V specification:

> "HINT instructions are usually used to communicate performance hints to the microarchitecture. HINTs are encoded as integer computational instructions with rd=x0."
> — RISC-V Unprivileged ISA Specification, Section 2.9

In this corpus, we use HINT instructions as runtime-identifiable markers to indicate when specific test cases are being executed.

## HINT Instruction Encoding

### Primary Format: ADDI with rd=x0

The primary HINT format used in this corpus is:

```
addi x0, x0, <immediate>
```

**Encoding (I-type format):**
```
| imm[11:0]  | rs1   | funct3 | rd    | opcode  |
| 12 bits    | 5 bits| 3 bits | 5 bits| 7 bits  |
| immediate  | 00000 | 000    | 00000 | 0010011 |
```

- **opcode**: `0010011` (OP-IMM)
- **rd**: `00000` (x0 - writes are discarded)
- **funct3**: `000` (ADDI)
- **rs1**: `00000` (x0 - reads as 0)
- **imm[11:0]**: Test case identifier (1-2047 for positive, or encoded as signed)

**Machine Code Calculation (Python):**
```python
def encode_hint(immediate):
    """Encode a HINT instruction with the given immediate value."""
    # ADDI x0, x0, imm
    opcode = 0b0010011  # OP-IMM
    rd = 0              # x0
    funct3 = 0b000      # ADDI
    rs1 = 0             # x0
    imm = immediate & 0xFFF  # 12-bit signed immediate
    
    instruction = (imm << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
    return instruction

# Example: HINT 1
hint_1 = encode_hint(1)
print(f"HINT 1: 0x{hint_1:08x}")  # Output: 0x00100013
```

### Special Case: NOP (HINT 0)

The standard NOP instruction is a special case of HINT:

```
addi x0, x0, 0    # NOP - encoded as HINT 0
```

**Machine Code**: `0x00000013`

This is the canonical NOP encoding and should NOT be used as a test marker to avoid confusion.

## Valid HINT Immediate Range

The immediate field in I-type instructions is a 12-bit signed value:

- **Positive range**: 1 to 2047 (0x001 to 0x7FF)
- **Negative range**: -2048 to -1 (0x800 to 0xFFF when sign-extended)

For test case markers, we use **positive values 1-2047** to ensure clarity and avoid confusion with error codes.

## Alternative HINT Encodings

While `addi x0, x0, imm` is the primary format, other instructions with `rd=x0` are also HINTs:

### SLTI/SLTIU with rd=x0
```
slti  x0, rs1, imm    # HINT - comparison result discarded
sltiu x0, rs1, imm    # HINT - unsigned comparison result discarded
```

### Logical Operations with rd=x0
```
andi x0, rs1, imm     # HINT - AND result discarded
ori  x0, rs1, imm     # HINT - OR result discarded
xori x0, rs1, imm     # HINT - XOR result discarded
```

### Shift Operations with rd=x0
```
slli x0, rs1, shamt   # HINT - shift result discarded
srli x0, rs1, shamt   # HINT - shift result discarded
srai x0, rs1, shamt   # HINT - shift result discarded
```

### Register-Register Operations with rd=x0
```
add  x0, rs1, rs2     # HINT - addition result discarded
sub  x0, rs1, rs2     # HINT - subtraction result discarded
sll  x0, rs1, rs2     # HINT - shift result discarded
# ... etc.
```

### LUI/AUIPC with rd=x0 and non-zero immediate
```
lui   x0, imm         # HINT when imm != 0
auipc x0, imm         # HINT when imm != 0
```

## Usage in Test Files

### Marking Test Case Boundaries

Each test case in an assembly file is preceded by a HINT instruction that identifies the test:

```asm
# ==========================================================================
# HINT 1: Test ADDI basic positive
# ==========================================================================
addi x0, x0, 1          # HINT 1: marks start of test case 1
li a0, 10
addi a1, a0, 5          # a1 = 15

# ==========================================================================
# HINT 2: Test SLTI signed comparison  
# ==========================================================================
addi x0, x0, 2          # HINT 2: marks start of test case 2
li t0, -5
slti t1, t0, 0          # t1 = 1
```

### Correspondence with Test Mapping JSON

The `hint_marker` field in the test mapping JSON corresponds to the immediate value in the HINT instruction:

```json
{
  "test_cases": [
    {
      "name": "ADDI basic positive",
      "hint_marker": 1,
      "instructions": ["ADDI"],
      "expected_behavior": {
        "registers": { "a1": 15 }
      },
      "comment": "ADDI adds the sign-extended 12-bit immediate to register rs1..."
    }
  ]
}
```

## Benefits of HINT Markers

1. **Runtime Identification**: Emulators and debuggers can detect when a specific test case begins by watching for the HINT instruction.

2. **No State Changes**: HINT instructions are guaranteed not to modify any architectural state (registers or memory).

3. **Portable**: The HINT encoding is part of the base RV32I/RV64I specification and works on all conforming implementations.

4. **Minimal Overhead**: A single 4-byte instruction per test case.

5. **Machine-Readable**: Tools can extract test case boundaries by scanning for the HINT encoding pattern.

## Detecting HINT Instructions

To detect HINT instructions in binary code:

```python
def is_hint_addi(instruction):
    """Check if instruction is ADDI x0, x0, imm (HINT)."""
    opcode = instruction & 0x7F
    rd = (instruction >> 7) & 0x1F
    funct3 = (instruction >> 12) & 0x7
    rs1 = (instruction >> 15) & 0x1F
    
    # ADDI x0, x0, imm
    return (opcode == 0x13 and  # OP-IMM
            rd == 0 and          # x0
            funct3 == 0 and      # ADDI
            rs1 == 0)            # x0

def get_hint_value(instruction):
    """Extract the immediate value from a HINT instruction."""
    if not is_hint_addi(instruction):
        return None
    imm = instruction >> 20
    # Sign extend from 12 bits
    if imm & 0x800:
        imm |= 0xFFFFF000
    return imm
```

## References

- RISC-V Unprivileged ISA Specification, Section 2.4.3 (NOP Instruction)
- RISC-V Unprivileged ISA Specification, Section 2.9 (HINT Instructions)
- Source: https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-98ea4b5-2025-11-05/riscv-unprivileged.html

## Specification Quote

From the RISC-V Unprivileged ISA Specification:

> "The NOP instruction does not change any user-visible state, except for advancing the pc and incrementing any applicable performance counters. NOP is encoded as ADDI x0, x0, 0."
>
> "A small number of RISC-V instructions have been allocated to the HINT space, which can be used to convey information to the microarchitecture. The instructions typically perform a NOP-like operation if not supported by the implementation."
