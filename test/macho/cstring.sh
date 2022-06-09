#!/bin/bash
export LC_ALL=C
set -e
CC="${TEST_CC:-cc}"
CXX="${TEST_CXX:-c++}"
GCC="${TEST_GCC:-gcc}"
GXX="${TEST_GXX:-g++}"
OBJDUMP="${OBJDUMP:-objdump}"
MACHINE="${MACHINE:-$(uname -m)}"
testname=$(basename "$0" .sh)
echo -n "Testing $testname ... "
cd "$(dirname "$0")"/../..
t=out/test/macho/$testname
mkdir -p $t

cat <<EOF | $CC -o $t/a.o -c -xc -
const char *x = "Hello world\n";
EOF

cat <<EOF | $CC -o $t/b.o -c -xc -
#include <stdio.h>

extern const char *x;
const char *y = "Hello world\n";
const char *z = "Howdy world\n";

int main() {
  printf("%d %d\n", x == y, y == z);
}
EOF

clang --ld-path=./ld64 -o $t/exe $t/a.o $t/b.o
$t/exe | grep -q '^1 0$'

echo OK
