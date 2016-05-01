
# VARIABLES. Please, note that the following variables are used along the BossaNova pipeline. 
# They are set with the values described at the original paper. If you want to change them the 
# final results may be different than the reported ones. More details about each variable can 
# be found at the 'help' of each subprogram.
folds_number="1 2 3 4 5 6 7 8 9 10"

# Usage
show_help() {
	echo "USAGE: baseline.sh -d [DATASET] -e [EXPERIMENT] -m [MATLAB]"
	echo "WHERE: "
	echo "	[DATASET]	: full path to the dataset directory (according to this repository)"
	echo "	[EXPERIMENT] 	: 'lm' or 'lmplus' or 'lmh', as detailed at the paper "
	echo "	[MATLAB] 	: Matlab path, eg /usr/local/matlab/bin/matlab "
	echo ""
	echo "	ATTENTION! This script assumes that the dependencies are settled in the path."
	echo "	-> See README file for the list of dependencies;"
}

# Check if all needed arguments were informed (not empty)
check_arguments() {
	if [ -z $dir_dataset ] || [ -z $experiment ] || [ -z $dir_matlab ] ;
	 	then
		show_help
		exit 1
	fi
}

# Input arguments
show_arguments() {
	echo "ARGUMENTS: "
	echo "dir_dataset=$dir_dataset"
	echo "experiment=$experiment"
	echo "dir_matlab=$dir_matlab"
}

# Setup: create directories as needed
create_directories() {
	echo "$(tput setaf 2)Creating auxiliary directories...$(tput sgr 0)"
	mkdir -p code/results
	echo "$(tput setaf 2)Creating auxiliary directories...: DONE!$(tput sgr 0)"
}

skinScan() {
	echo "$(tput setaf 2)Step 1. Applying skinScan algorithm...$(tput sgr 0)"
	case "$experiment" in
		lmh) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmh';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		lmplus) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmplus';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		lm) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lm';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		teste) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='teste';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		#TODO: retirar teste do script
	esac
	echo "$(tput setaf 2)Step 1. Applying skinScan algorithm...: DONE! "
}

# Classification step via LibSVM
classification() {
	echo "$(tput setaf 2)Step 2. Classification: this can take a long time... $(tput sgr 0)"
	for i in $folds_number
	do
		python ../resources/easy_titans.py code/results/${experiment}/${experiment}_train_${i}.svm ${dir_highlevel}/${experiment}/${experiment}_test_${i}.svm
	done
	echo "$(tput setaf 2)Step 2. Classification: DONE! $(tput sgr 0)"
}

# Calculate AUC
calculate_auc() {	
	echo "$(tput setaf 2)Step 3. Calculating AUC... $(tput sgr 0)"
	
	echo "T O D O !"
	
	echo "$(tput setaf 2)Step 3. Calculating AUC...: DONE! $(tput sgr 0)"
}
#####################################################################################
#																					#
#									MAIN PROGRAM									#
#																					#
#####################################################################################

# If there is no enough arguments, tells the user how to use this script
OPTIND=1         
#if [ $# -lt 14 ]; then 
#	show_help 
#	exit 1 
#fi

# Parse the arguments
while getopts "d:l:m:h:e:" opt; do
    case "$opt" in
    m)  dir_matlab=$OPTARG
        ;;	
	d)  dir_dataset=$OPTARG
        ;;
	e)  experiment=$OPTARG
        ;;
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
classification
#calculate_auc
calculate_auc

# End of skinScan script
echo ""
echo "$(tput setaf 2)F I N I S H E D! $(tput sgr 0)"