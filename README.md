ROBUST MELANOMA-SCREENING
=========================

This repository contains the implementation of three techniques 
for automated melanoma screening (a Baseline, BossaNova and Deep 
Learning + Transfer Learning). We have compared them in the paper 
[Towards Automated Melanoma Screening: Proper Computer Vision & 
Reliable Results](http://arxiv.org/abs/1604.04024). 

You can find more details about the concepts and parametrization 
of each technique at the paper. The codes available in this 
repository are already parametrized according to the details 
provided in the text. 

TABLE OF CONTENTS
------------------

 - Dependencies 
 - Installation
 - Repository contents
 - Running

DEPENDENCIES
-------------

Note: we assume that the codes available here will be run on an 
Unix OS. You will need: 

 - Matlab;
 - [VLFeat](http://www.vlfeat.org/install-matlab.html) for Matlab;
 - Java;
 - Python;
 - LIBLINEAR: already provided in this repository;
 - LIBSVM: already provided in this repository.

INSTALLATION
-------------

Please, follow the download and installation guidelines of each dependency. 

For LIBSVM, it will be necessary to generate the executables through the 
command "make". Please, follow the guidelines at each README file and 
ignore the warning messages (if any). 

After generating the LIBSVM executables, browse to the directory 
[setup] and allow the execution of the script "1_enableExecutables.sh":

	chmod +x 1_enableExecutables.sh

Then, run the script. It will give execute permissions to all programs/scripts 
in this repository. 

REPOSITORY CONTENTS
--------------------

	baseline: 					
		code: 					baseline source code. 
		baseline.sh: 			main script to run experiments with baseline code. 
	bossanova: 					
		code: 					BossaNova source code. 
		bossanova.sh: 			main script to run experiments with BossaNova code. 
	dataset:
		images: 				directory to store the images of Baseline and BossaNova experiments. 
		folds: 					directory containing the fold files of each validation protocol. 
	deep-transfer: 				
		datasets:				the folder to organize datasets for "deep + transfer" experiments.
		resources:				stores the "deep + transfer" code dependencies. 
		source:					"deep + transfer" source code. 
		download_model.sh:		a script to download the VGG-M model file. 
		READ_ME.txt:			an explanation about how to run the deep learning code
	resources:					
		libsvm-2.9_titans: 		a modified version of LIBSVM. See its README file for details. 
	setup: 						
		1_enableExecutables.sh: script to setup the running environment. 
	README.md:	 				this file; 

RUNNING
--------

1) Baseline: follow the usage indications provided by running "baseline.sh" without arguments;

2) BossaNova: follow the usage indications provided by running "bossanova.sh" without arguments;

3) Deep+Transfer: follow the instructions provided at the specific README file.

