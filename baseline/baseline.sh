# Usage
show_help() {
	echo "USAGE: baseline.sh -m [MATLAB] -d [DATASET] -e [EXPERIMENT]"
	echo "WHERE: "
	echo "	[MATLAB]	: full path to the Matlab directory;"
	echo "	[DATASET]	: full path to the dataset directory;"
	echo "	[EXPERIMENT] 	: LM or LMplus or LMH, as detailed at the paper;"
	echo ""
	echo "	ATTENTION! This script assumes that the dependencies are settled in the path."
	echo "	-> See README file for the list of dependencies;"
}

# Input arguments
show_arguments() {
	echo "ARGUMENTS: "
	echo "dir_matlab=$dir_matlab"
	echo "dir_dataset=$dir_dataset"
	echo "experiment=$experiment"
}

# Setup: create directories as needed
create_directories() {
	mkdir -p code/results.gitnot
}

skinScan() {
	case "$experiment" in
		lmh) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmh';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		lmplus) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lmplus';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
		lm) $dir_matlab -nodisplay -nodesktop -nosplash -r "experiment='lm';datasetFolder='../$dir_dataset';run code/run_matlab.m;exit" ;;
	esac
}

# Reset in case getopts has been used previously in the shell.
OPTIND=1         

# If there is no argument, tells the user how to use this script. 
if [ $# -lt 1 ]; then 
	show_help 
	exit 1 
fi

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

# Setup
show_arguments
create_directories

# Main pipeline
skinScan

# Classification & results (AUCs)
#classification
#calculate_auc

# End of bossanova script
