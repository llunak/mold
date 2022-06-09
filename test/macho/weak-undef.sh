#!/bin/bash
export LC_ALL=C
set -e
CC="${CC:-cc}"
CXX="${CXX:-c++}"
GCC="${GCC:-gcc}"
GXX="${GXX:-g++}"
OBJDUMP="${OBJDUMP:-objdump}"
MACHINE="${MACHINE:-$(uname -m)}"
testname=$(basename "$0" .sh)
echo -n "Testing $testname ... "
cd "$(dirname "$0")"/../..
t=out/test/macho/$testname
mkdir -p $t

cat <<EOF | $CC -c -o $t/a.o -xc -
#include <stdio.h>
int foo() __attribute__((weak));
int main() {
  printf("%d\n", foo ? foo() : 5);
}
EOF

cat <<EOF | $CC -c -o $t/b.o -xc -
int foo() { return 42; }
EOF

clang -o $t/exe1 $t/a.o -Wl,-U,_foo
$t/exe1 | grep -q '^5$'

clang -o $t/exe2 $t/a.o $t/b.o -Wl,-U,_foo
$t/exe2 | grep -q '^42$'

echo OK
