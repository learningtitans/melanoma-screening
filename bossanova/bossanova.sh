#!/bin/sh

# VARIABLES. Please, note that the following variables are used along the BossaNova pipeline. 
# They are set with the values described at the original paper. If you want to change them the 
# final results may be different than the reported ones. More details about each variable can 
# be found at the 'help' of each subprogram.
folds_number="1 2 3 4 5 6 7 8 9 10"

java_memory=12G		# Memory allocated by Java

low_level_sift_step=[8]
low_level_sift_size=[3.0,6.5,14.5,32.0]
low_level_sampling_sampledPointsNumber=500899
low_level_sampling_sampledPointsPerImageNumber=439
low_level_pca_dimension=64

codebook_size=2048

mid_level_bossanova_numberOfBins=4
mid_level_bossanova_alphas=[0.6,1.6]
mid_level_bossanova_scalesOfSpatialPyramids=1x1+2x2
# VARIABLES END.

# ARGUMENTS. No need to change this. 
dir_dataset=""
dir_lowlevel=""
dir_midlevel=""
dir_highlevel=""
experiment=""
path_matlab=""
path_vlfeat=""
# ARGUMENTS END.

# Usage
show_help() {
	echo "USAGE: bossanova.sh -d [DATASET] -l [LOW_LEVEL] -m [MID_LEVEL] -h [HIGH_LEVEL] -e [EXPERIMENT] -M [MATLAB] -V [VLFEAT]"
	echo "WHERE: "
	echo "	[DATASET]	: full path to the dataset directory (according to this repository)"
	echo "	[LOW_LEVEL]	: full path to the directory where the low level will be stored "
	echo "	[MID_LEVEL]	: full path to the directory where the mid level will be stored "
	echo "	[HIGH_LEVEL]	: full path to the directory where the high level will be stored "
	echo "	[EXPERIMENT] 	: 'lm' or 'lmplus' or 'lmh', as detailed at the paper "
	echo "	[MATLAB] 	: Matlab path, eg /usr/local/matlab/bin/matlab "
	echo "	[VLFEAT] 	: VLFeat path, eg ../vlfeat-0.9.16/toolbox/vl_setup "
	echo ""
	echo "	ATTENTION! This script assumes that the dependencies are settled in the path."
	echo "	-> See README file for the list of dependencies;"
}

# Check if all needed arguments were informed (not empty)
check_arguments() {
	if [ -z $dir_dataset ] || [ -z $dir_lowlevel ] || [ -z $dir_midlevel ] || 
		[ -z $dir_highlevel ] || [ -z $experiment ] || [ -z $path_matlab ] ||
		[ -z $path_vlfeat ] ; then
		show_help
		exit 1
	fi
}

# Input arguments
show_arguments() {
	echo "ARGUMENTS: "
	echo "	Dataset directory	=	$dir_dataset"
	echo "	Low-level directory	=	$dir_lowlevel"
	echo "	Mid-level directory	=	$dir_midlevel"
	echo "	High-level directory	=	$dir_highlevel"
	echo "	Experiment		=	$experiment"
	echo "	Matlab path		=	$path_matlab"
	echo "	VLFeat path		=	$path_vlfeat"
}

# Setup: create directories as needed
create_directories() {
	echo "$(tput setaf 2)Creating auxiliary directories...$(tput sgr 0)"
	mkdir -p folds_aux
	mkdir -p ${dir_lowlevel}/sifts
	mkdir -p ${dir_highlevel}/${experiment}
	for i in $folds_number
	do
		mkdir -p ${dir_lowlevel}/pcas/${experiment}/fold${i}
		mkdir -p ${dir_midlevel}/${experiment}/fold${i}
	done
	echo "$(tput setaf 2)Creating auxiliary directories...: DONE!$(tput sgr 0)"
}

# Setup: create fold files as input for BossaNova pipeline
create_fold_files() {
	echo "$(tput setaf 2)Creating auxiliary files...$(tput sgr 0)"
	java -jar ./code/CreateBossaNovaFoldLists.jar ${dir_dataset} ${experiment} ${dir_lowlevel} ./folds_aux/
	echo "$(tput setaf 2)Creating auxiliary files...: DONE!$(tput sgr 0)"
}

# Low-level extraction (RootSIFT ; Sampling ; PCA)
low_level() {
	echo "$(tput setaf 2)Step 1. RootSIFT extraction...$(tput sgr 0)"
	java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/ROOT-SIFTExtraction.jar -i ${dir_dataset}/images -o ${dir_lowlevel}/sifts/ -sift vldsift -step ${low_level_sift_step} -size ${low_level_sift_size} -fast -floatdescriptors -rootsift -m ${path_matlab} -v ${path_vlfeat} 
	echo "$(tput setaf 2)Step 1. RootSIFT extraction...: DONE! "
	
	echo "$(tput setaf 2)Step 2. Sampling descriptors...$(tput sgr 0)"
	for i in $folds_number
	do
		if [ -f ${dir_lowlevel}/samples_${experiment}_fold${i}.obj ] ; then 
			echo "${dir_lowlevel}/samples_${experiment}_fold${i}.obj exists. Not creating it again." 
		else
			java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/SampleDescriptors.jar -i ./folds_aux/BossaNova_SIFT_${experiment}_train_${i}.txt -o ${dir_lowlevel}/samples_${experiment}_fold${i}.obj -m ${low_level_sampling_sampledPointsNumber} -p ${low_level_sampling_sampledPointsPerImageNumber}  
		fi	
	done
	echo "$(tput setaf 2)Step 2. Sampling descriptors...: DONE!$(tput sgr 0)"
	
	echo "$(tput setaf 2)Step 3. Applying PCA...$(tput sgr 0)"
	for i in $folds_number
	do
		java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/PCA.jar -i ./folds_aux/BossaNova_SIFT_${experiment}_train_${i}.txt -o ${dir_lowlevel}/pcas/${experiment}/fold${i}/ -d ${low_level_pca_dimension} -l ${dir_lowlevel}/samples_${experiment}_fold${i}.obj  
		java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/PCA.jar -i ./folds_aux/BossaNova_SIFT_${experiment}_test_${i}.txt -o ${dir_lowlevel}/pcas/${experiment}/fold${i}/ -d ${low_level_pca_dimension} -l ${dir_lowlevel}/samples_${experiment}_fold${i}.obj   
	done	
	echo "$(tput setaf 2)Step 3. Applying PCA...: DONE!$(tput sgr 0)"
}

# Create codebooks
create_codebooks() {
	echo "$(tput setaf 2)Step 4. Creating codebooks...$(tput sgr 0)"
	for i in $folds_number
	do
		if [ -f ${dir_lowlevel}/codebook_${experiment}_fold${i}.obj ] ; then 
			echo "${dir_lowlevel}/codebook_${experiment}_fold${i}.obj exists. Not creating it again." 
		else 	
			java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/CodeBook-1it.jar -i ./folds_aux/BossaNova_PCA_${experiment}_train_${i}.txt -n ${codebook_size} -m ${low_level_sampling_sampledPointsNumber} -p ${low_level_sampling_sampledPointsPerImageNumber} -o ${dir_lowlevel}/codebook_${experiment}_fold${i}.obj 
		fi
	done
	echo "$(tput setaf 2)Step 4. Creating codebooks...: DONE!$(tput sgr 0)"
}

# Mid-level extraction (BossaNova)
mid_level() {	
	echo "$(tput setaf 2)Step 5. Starting mid-level extraction...$(tput sgr 0)"
	for i in $folds_number
	do
		java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/BossaNova.jar -i ./folds_aux/BossaNova_PCA_${experiment}_train_${i}.txt -o ${dir_midlevel}/${experiment}/fold${i}/ -c ${dir_lowlevel}/codebook_${experiment}_fold${i}.obj -b ${mid_level_bossanova_numberOfBins} -a ${mid_level_bossanova_alphas} -k 10 -n pnl2 -concat -f 1 -s ${mid_level_bossanova_scalesOfSpatialPyramids}   
		java -Xmx${java_memory} -client -XX:+UseParallelGC -XX:+UseParallelOldGC -jar ./code/BossaNova.jar -i ./folds_aux/BossaNova_PCA_${experiment}_test_${i}.txt -o ${dir_midlevel}/${experiment}/fold${i}/ -c ${dir_lowlevel}/codebook_${experiment}_fold${i}.obj -b ${mid_level_bossanova_numberOfBins} -a ${mid_level_bossanova_alphas} -k 10 -n pnl2 -concat -f 1 -s ${mid_level_bossanova_scalesOfSpatialPyramids} 	
	done
	echo "$(tput setaf 2)Step 5. Mid-level extraction...: DONE! $(tput sgr 0)"
}

# Create high-level features (inputs to LibSVM)
high_level() {
	echo "$(tput setaf 2)Step 6. Starting high-level extraction... $(tput sgr 0)"
	for i in $folds_number
	do
		java -jar ./code/CreateHighLevel.jar ${dir_midlevel} ${dir_highlevel} ${experiment} ${i} ${dir_dataset}/folds/${experiment}/${experiment}_train_${i}.csv
		java -jar ./code/CreateHighLevel.jar ${dir_midlevel} ${dir_highlevel} ${experiment} ${i} ${dir_dataset}/folds/${experiment}/${experiment}_test_${i}.csv
	done
	echo "$(tput setaf 2)Step 6. High-level extraction...: DONE! $(tput sgr 0)"
}

# Classification step via LibSVM
classification() {
	echo "$(tput setaf 2)Step 7. Classification: this can take a long time... $(tput sgr 0)"
	for i in $folds_number
	do
		python ../resources/libsvm-2.9_titans/tools/easy_titans.py ${dir_highlevel}/${experiment}/${experiment}_train_${i}.svm ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm
	done
	echo "$(tput setaf 2)Step 7. Classification: DONE! $(tput sgr 0)"
}

# Calculate AUC
calculate_auc() {	
	echo "$(tput setaf 2)Step 8. Calculating AUC... $(tput sgr 0)"
	chmod +x ../resources/auc.sh
	for i in $folds_number
	do
		../resources/auc.sh ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm ${dir_highlevel}/${experiment}/${experiment}_train_${i}.svm.model ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm.predict
	done
	echo "$(tput setaf 2)Step 8. Calculating AUC...: DONE! $(tput sgr 0)"
}

#####################################################################################
#																					#
#									MAIN PROGRAM									#
#																					#
#####################################################################################

# If there is no enough arguments, tells the user how to use this script
OPTIND=1         
if [ $# -lt 14 ]; then 
	show_help 
	exit 1 
fi

# Parse the arguments
while getopts "d:l:m:h:e:M:V:" opt; do
    case "$opt" in
	d)  dir_dataset=$OPTARG ;;
    l)  dir_lowlevel=$OPTARG ;;
    m)  dir_midlevel=$OPTARG ;;
	h)  dir_highlevel=$OPTARG ;;
	e)  experiment=$OPTARG ;;
	M)  path_matlab=$OPTARG ;;
	V)  path_vlfeat=$OPTARG ;;
	esac
done

#shift $((OPTIND-1))
#[ "$1" = "--" ] && shift

# Before starting, check arguments
check_arguments

# Setup
show_arguments
create_directories
create_fold_files

# Main pipeline
low_level
create_codebooks
mid_level
high_level

# Classification & results (AUCs)
classification
calculate_auc

# End of bossanova script
echo ""
echo "$(tput setaf 2)F I N I S H E D! $(tput sgr 0)"
