#!/bin/sh

# Number of folds of the experiments.
folds_number="1 2 3 4 5 6 7 8 9 10"

# ARGUMENTS. No need to change this. 
dir_dataset=""
experiment=""
path_matlab=""
# ARGUMENTS END.

# Usage
show_help() {
	echo "USAGE: baseline.sh -d [DATASET] -e [EXPERIMENT] -M [MATLAB]"
	echo "WHERE: "
	echo "	[DATASET]	: full path to the dataset directory (according to this repository) "
	echo "	[EXPERIMENT] 	: 'lm' or 'lmplus' or 'lmh', as detailed at the paper "
	echo "	[MATLAB]	: Matlab path, eg /usr/local/matlab/bin/matlab "
	echo ""
	echo "	ATTENTION! This script assumes that the dependencies are settled in the path."
	echo "	-> See README file for the list of dependencies;"
}

# Check if all needed arguments were informed (not empty)
check_arguments() {
	if [ -z $dir_dataset ] || [ -z $experiment ] || [ -z $path_matlab ] ;
	 	then
		show_help
		exit 1
	fi
}

# Input arguments
show_arguments() {
	echo "ARGUMENTS: "
	echo "	Dataset directory	=	$dir_dataset"
	echo "	Experiment		=	$experiment"
	echo "	Matlab path		=	$path_matlab"
}

# Setup: create directories as needed
create_directories() {
	echo "$(tput setaf 2)Creating auxiliary directories...$(tput sgr 0)"
	mkdir -p features
	mkdir -p results
	echo "$(tput setaf 2)Creating auxiliary directories...: DONE!$(tput sgr 0)"
}

# Runs our reimplementation of SkinScan, segmenting the lesions, extracting features, 
# employing BoVW model and creating input files to SVM.
skinScan() {
	echo "$(tput setaf 2)Step 1. Applying skinScan algorithm...$(tput sgr 0)"
	for i in $folds_number
	do
		"${path_matlab}" -nodisplay -nodesktop -nosplash -r "skinScan(${dir_dataset}/folds/${experiment}/${experiment}_train_${i}.csv, ${dir_dataset}/images/, ./features/, ./results/${experiment}_train_${i}_scores, ./results/${experiment}_train_${i}_codebook, ./results/${experiment}_train_${i}_features.svm, 'train', 6, 1); exit"  
		"${path_matlab}" -nodisplay -nodesktop -nosplash -r "skinScan(${dir_dataset}/folds/${experiment}/${experiment}_test_${i}.csv, ${dir_dataset}/images/, ./features/, ./results/${experiment}_train_${i}_scores, ./results/${experiment}_train_${i}_codebook, ./results/${experiment}_test_${i}_features.svm, 'test', 6, 1)); exit"       
	done
	# case "$experiment" in
		# lmh) $path_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmh';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		# lmplus) $path_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmplus';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		# lm) $path_matlab -nodisplay -nodesktop -nosplash -r "experiment='lm';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		# teste) $path_matlab -nodisplay -nodesktop -nosplash -r "experiment='teste';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		#TODO: retirar teste do script
	# esac
	echo "$(tput setaf 2)Step 1. Applying skinScan algorithm...: DONE! "
}

# TODO : FIX ME!
# Classification step via LibSVM
classification() {
	echo "$(tput setaf 2)Step 2. Classification: this can take a long time... $(tput sgr 0)"
	for i in $folds_number
	do
		python ../resources/libsvm-2.9_titans/tools/easy_titans.py code/results/${experiment}/${experiment}_train_${i}.svm ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm
	done
	echo "$(tput setaf 2)Step 2. Classification: DONE! $(tput sgr 0)"
}

# TODO : FIX ME!
# Calculate AUC
calculate_auc() {	
	echo "$(tput setaf 2)Step 3. Calculating AUC: one fold per row... $(tput sgr 0)"
	for i in $folds_number
	do
		../resources/libsvm-2.9_titans/svm-predict ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm ${dir_highlevel}/${experiment}/${experiment}_train_${i}.svm.model ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm.predict
	done
	echo "$(tput setaf 2)Step 3. Calculating AUC...: DONE! $(tput sgr 0)"
}
#####################################################################################
#																					#
#									MAIN PROGRAM									#
#																					#
#####################################################################################

# If there is no enough arguments, tells the user how to use this script
OPTIND=1         
if [ $# -lt 6 ]; then 
	show_help 
	exit 1 
fi

# Parse the arguments
while getopts "d:e:M:" opt; do
    case "$opt" in
	d)  dir_dataset=$OPTARG ;;
	e)  experiment=$OPTARG ;;
	M)  path_matlab=$OPTARG ;;	
	esac
done

#shift $((OPTIND-1))
#[ "$1" = "--" ] && shift

# Before starting, check arguments
check_arguments

# Setup
show_arguments
create_directories

# Main pipeline
skinScan

# Classification & results (AUCs)
#classification
#calculate_auc

# End of baseline script
echo ""
echo "$(tput setaf 2)F I N I S H E D! $(tput sgr 0)"