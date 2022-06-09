#!/bin/bash -x
set -e
source /etc/os-release

# The first line for each distro installs a build dependency.
# The second line installs extra packages for `make test`.

case "$ID$VERSION_ID" in
ubuntu20.04)
  apt install -y git cmake libssl-dev zlib1g-dev gcc g++ g++-10
  apt-get install -y file bsdmainutils
  ;;
ubuntu22.04 | debian11)
  apt install -y git cmake libssl-dev zlib1g-dev gcc g++
  apt-get install -y file bsdmainutils
  ;;
fedora*)
  dnf install -y git gcc-g++ cmake openssl-devel zlib-devel
  dnf install -y glibc-static file libstdc++-static diffutils
  ;;
opensuse-leap*)
  zypper install -y git make cmake zlib-devel libopenssl-devel gcc-c++ gcc11-c++
  zypper install -y glibc-devel-static tar diffutils util-linux
  ;;
opensuse-tumbleweed*)
  zypper install -y git make cmake zlib-devel libopenssl-devel gcc-c++
  zypper install -y glibc-devel-static tar diffutils util-linux
  ;;
gentoo*)
  emerge dev-vcs/git dev-util/cmake sys-libs/zlib
  ;;
*)
  echo "Error: don't know anything about build dependencies on $ID $VERSION_ID"
  exit 1
esac
