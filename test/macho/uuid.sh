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
#include <stdio.h>
int main() {
  printf("Hello world\n");
}
EOF

clang --ld-path=./ld64 -o $t/exe1 $t/a.o -Wl,-final_output,exe1
otool -l $t/exe1 | grep -q LC_UUID

clang --ld-path=./ld64 -o $t/exe2 $t/a.o -Wl,-final_output,exe1
otool -l $t/exe2 | grep -q LC_UUID

diff -q $t/exe1 $t/exe2 > /dev/null

clang --ld-path=./ld64 -o $t/exe3 $t/a.o -Wl,-no_uuid
otool -l $t/exe3 > $t/log3
! grep -q LC_UUID $t/log3 || false

clang --ld-path=./ld64 -o $t/exe4 $t/a.o -Wl,-random_uuid
otool -l $t/exe4 | grep -q LC_UUID

echo OK
