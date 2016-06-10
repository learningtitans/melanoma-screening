#!/bin/bash

BASEDIR=$(dirname $0)
if [ $BASEDIR = '.' ]; then
	BASEDIR=$(pwd)
fi

wget -P $BASEDIR/resources/models http://www.vlfeat.org/matconvnet/models/imagenet-vgg-m.mat
