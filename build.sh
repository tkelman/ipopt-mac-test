#!/bin/sh
set -e
IPOPT_VER=3.11.4
curl -O http://www.coin-or.org/download/source/Ipopt/Ipopt-$IPOPT_VER.tgz
tar -xzf Ipopt-$IPOPT_VER.tgz
cd Ipopt-$IPOPT_VER
prefix=$PWD/build01


cd ThirdParty/Mumps
./get.Mumps
cd ../..
for i in Blas Lapack; do
  cd ThirdParty/$i
  ./get.$i
  mkdir -p build
  cd build
  ../configure --disable-shared --enable-static --with-pic --prefix=$prefix
  make install
  cd ../../..
done
mkdir -p build
cd build
../configure --with-blas=$prefix/lib/libcoinblas.a \
  --with-lapack=$prefix/lib/libcoinlapack.a \
  --prefix=$prefix --enable-dependency-linking
make install
make test
otool -L $prefix/lib/libipopt.dylib
ls $prefix/lib
