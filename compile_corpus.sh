#!/bin/bash
# Compilation script for RiscV test corpus using LLVM tools
# Compiles RV32I, RV64I, and extension tests

# Ensure script runs in the directory where it's located
cd "$(dirname "$0")"

set -e

CLANG="${CLANG:-clang}"
LLVM_OBJCOPY="${LLVM_OBJCOPY:-llvm-objcopy}"

echo "=== RiscV Test Corpus Compilation ==="
echo "Using LLVM toolchain: $CLANG"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

compile_test() {
    local src="$1"
    local arch="$2"
    local abi="$3"
    local output="${src%.s}"
    
    echo -n "Compiling $(basename "$src")... "
    
    if $CLANG --target=riscv32 -march="$arch" -mabi="$abi" \
        -nostdlib -static -Wl,-e_start \
        "$src" -o "$output" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        return 1
    fi
}

# Compile RV32I tests
echo ""
echo "=== Compiling RV32I Tests ==="
success=0
total=0
for test in rv32i/*.s; do
    total=$((total + 1))
    if compile_test "$test" "rv32i" "ilp32"; then
        success=$((success + 1))
    fi
done
echo "RV32I: $success/$total tests compiled successfully"

# Compile RV32IM tests
echo ""
echo "=== Compiling RV32IM Tests ==="
im_success=0
im_total=0
for test in rv32im/*.s; do
    im_total=$((im_total + 1))
    if compile_test "$test" "rv32im" "ilp32"; then
        im_success=$((im_success + 1))
    fi
done
echo "RV32IM: $im_success/$im_total tests compiled successfully"

# Compile RV32IMA tests
echo ""
echo "=== Compiling RV32IMA Tests ==="
ima_success=0
ima_total=0
for test in rv32ima/*.s; do
    ima_total=$((ima_total + 1))
    if compile_test "$test" "rv32ima" "ilp32"; then
        ima_success=$((ima_success + 1))
    fi
done
echo "RV32IMA: $ima_success/$ima_total tests compiled successfully"

# Compile RV64I tests
echo ""
echo "=== Compiling RV64I Tests ==="
rv64_success=0
rv64_total=0
for test in rv64i/*.s; do
    rv64_total=$((rv64_total + 1))
    if compile_test "$test" "rv64i" "lp64"; then
        rv64_success=$((rv64_success + 1))
    fi
done
echo "RV64I: $rv64_success/$rv64_total tests compiled successfully"

# Compile RV64IM tests
echo ""
echo "=== Compiling RV64IM Tests ==="
rv64im_success=0
rv64im_total=0
for test in rv64im/*.s; do
    rv64im_total=$((rv64im_total + 1))
    if compile_test "$test" "rv64im" "lp64"; then
        rv64im_success=$((rv64im_success + 1))
    fi
done
echo "RV64IM: $rv64im_success/$rv64im_total tests compiled successfully"

# Compile RV64IMA tests
echo ""
echo "=== Compiling RV64IMA Tests ==="
rv64ima_success=0
rv64ima_total=0
if [ -d rv64ima ] && [ "$(ls -A rv64ima/*.s 2>/dev/null)" ]; then
    for test in rv64ima/*.s; do
        [ -f "$test" ] || continue
        rv64ima_total=$((rv64ima_total + 1))
        if compile_test "$test" "rv64ima" "lp64"; then
            rv64ima_success=$((rv64ima_success + 1))
        fi
    done
    echo "RV64IMA: $rv64ima_success/$rv64ima_total tests compiled successfully"
else
    echo "RV64IMA: No tests found (directory empty or doesn't exist)"
fi

# Compile RV32I_Zicsr tests
echo ""
echo "=== Compiling RV32I Zicsr Tests ==="
zicsr_success=0
zicsr_total=0
if [ -d rv32i_zicsr ] && [ "$(ls -A rv32i_zicsr/*.s 2>/dev/null)" ]; then
    for test in rv32i_zicsr/*.s; do
        [ -f "$test" ] || continue
        zicsr_total=$((zicsr_total + 1))
        if compile_test "$test" "rv32i_zicsr" "ilp32"; then
            zicsr_success=$((zicsr_success + 1))
        fi
    done
    echo "RV32I_Zicsr: $zicsr_success/$zicsr_total tests compiled successfully"
else
    echo "RV32I_Zicsr: No tests found (directory empty or doesn't exist)"
fi

# Compile RV32F tests
echo ""
echo "=== Compiling RV32F Tests ==="
f_success=0
f_total=0
if [ -d rv32f ] && [ "$(ls -A rv32f/*.s 2>/dev/null)" ]; then
    for test in rv32f/*.s; do
        [ -f "$test" ] || continue
        f_total=$((f_total + 1))
        if compile_test "$test" "rv32if" "ilp32f"; then
            f_success=$((f_success + 1))
        fi
    done
    echo "RV32F: $f_success/$f_total tests compiled successfully"
else
    echo "RV32F: No tests found (directory empty or doesn't exist)"
fi

# Compile RV32D tests
echo ""
echo "=== Compiling RV32D Tests ==="
d_success=0
d_total=0
if [ -d rv32d ] && [ "$(ls -A rv32d/*.s 2>/dev/null)" ]; then
    for test in rv32d/*.s; do
        [ -f "$test" ] || continue
        d_total=$((d_total + 1))
        if compile_test "$test" "rv32ifd" "ilp32d"; then
            d_success=$((d_success + 1))
        fi
    done
    echo "RV32D: $d_success/$d_total tests compiled successfully"
else
    echo "RV32D: No tests found (directory empty or doesn't exist)"
fi

# Compile RV32FD tests
echo ""
echo "=== Compiling RV32FD Tests ==="
fd_success=0
fd_total=0
if [ -d rv32fd ] && [ "$(ls -A rv32fd/*.s 2>/dev/null)" ]; then
    for test in rv32fd/*.s; do
        [ -f "$test" ] || continue
        fd_total=$((fd_total + 1))
        if compile_test "$test" "rv32ifd" "ilp32d"; then
            fd_success=$((fd_success + 1))
        fi
    done
    echo "RV32FD: $fd_success/$fd_total tests compiled successfully"
else
    echo "RV32FD: No tests found (directory empty or doesn't exist)"
fi

# Compile RV64D tests
echo ""
echo "=== Compiling RV64D Tests ==="
rv64d_success=0
rv64d_total=0
if [ -d rv64d ] && [ "$(ls -A rv64d/*.s 2>/dev/null)" ]; then
    for test in rv64d/*.s; do
        [ -f "$test" ] || continue
        rv64d_total=$((rv64d_total + 1))
        if compile_test "$test" "rv64ifd" "lp64d"; then
            rv64d_success=$((rv64d_success + 1))
        fi
    done
    echo "RV64D: $rv64d_success/$rv64d_total tests compiled successfully"
else
    echo "RV64D: No tests found (directory empty or doesn't exist)"
fi

# Summary
echo ""
echo "=== Compilation Summary ==="
total_success=$((success + im_success + ima_success + rv64_success + rv64im_success + rv64ima_success + zicsr_success + f_success + d_success + fd_success + rv64d_success))
total_tests=$((total + im_total + ima_total + rv64_total + rv64im_total + rv64ima_total + zicsr_total + f_total + d_total + fd_total + rv64d_total))
echo "Total: $total_success/$total_tests tests compiled successfully"

if [ $total_success -eq $total_tests ]; then
    echo -e "${GREEN}All tests compiled successfully!${NC}"
    exit 0
else
    echo -e "${YELLOW}Some tests failed to compile${NC}"
    exit 1
fi
