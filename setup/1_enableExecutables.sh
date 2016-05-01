#!/bin/sh

cd ../resources/libsvm-2.9_titans/
make
chmod +x svm-scale
chmod +x svm-train
chmod +x svm-predict
cd tools
chmod +x grid.py
chmod +x easy_titans.py
cd ../../..
chmod +x ./bossanova/bossanova.sh
chmod +x ./baseline/baseline.sh
