#####################################################################
#####################################################################
# THIS FILE BELONGS TO THE SUPPLEMENTARY MATERIAL PROVIDED WITH THE #
# PAPER "TOWARDS AUTOMATED MELANOMA SCREENING: ROBUST APPROACHES    #
# AND RELIABLE EXPERIMENTS"                                         #
#####################################################################
#####################################################################

Hello !

Thank you for downloading our source code.
Please feel free to contact us if you have any questions or comments.

Here we provide the implementation of our methods, so you can quickly
start to test them. Please note that the transfer experiments require
the use of the proprietary software MATLAB.

#####################################################################
#                          GETTING STARTED                          #
#####################################################################

Inside this folder you will find 1 script file and 3 folders:
- datasets -- a folder where you should organize your datasets; we
provide an example called "example", so you can easily understand
what to do;
- resources -- a folder where we keep liblinear, matconvnet and the
models used to extract features. This folder is used only internally,
so you don't need to do anything inside it;
- source -- a folder with our source code! The instructions we offer
in the next topics will teach you to use the files inside this
folder.
- download_model.sh -- dowloads the model file for VGG-M and places
it in the resources/models folder;

The first step is to run download_model.sh. It will download VGG-M so
you can use it in your experiments.

#####################################################################
#                       PREPARING MY DATASET                        #
#####################################################################

To prepare your dataset, you can start by putting all of your images
in the datasets/your_dataset_name/data folder. We suggest you keep
filenames in lowercase, just to avoid future problems.

The next step is to create a file named your_dataset_name.conf inside
datasets/your_dataset_name. Inside this file, you should indicate all
images and their respective labels, one per line. Each line should be
in the format "image_name_with_extension.jpg,label", where label is
the label of the image (for binary classification, 1 and -1).

After that, you have to choose which folds to use, and indicate it
inside datasets/your_dataset_name/folds. You can create as many
groups as you want. Each group is only a different set of folds,
in case you want to try many of them. Inside the folder of a group
you should create files named as <number>.conf, where number goes
from 1 up to the number of folds you want. Please be extra careful,
as each image shall belong only to a single fold, otherwise you will
have data contamination problems. The structure of this file is very
simple: just name every image from such fold, comma separated and
without spaces. For example: "image1.jpg,image3.jpg,image5.jpg".

If you have any doubts, please check out the "example" dataset we've
left inside the datasets folder.

And after that, you're ready to go!

*IMPORTANT*: we have already prepared the dataset folder for this 
paper, but you need to copy the images from "../dataset/images" 
to "../deep-transfer/datasets/atlas/data". 

#####################################################################
#                      TRAINING ON MY DATASET                       #
#####################################################################

To start, open MATLAB and navigate to the source folder.

The first thing to do is to describe your dataset using the model. To
do so, you have to run the following commands:
>> fcommon = common;
>> fcommon.extract_features(19);

Please note that "19", in the last command, is the layer from which
we will extract the features. In our paper, we adopt layer 19 from
VGG-M.

After running these steps, a descriptor file will be created inside
the datasets/your_dataset_name/desc folder. It will be used during
the training phase.

Now, to train on your dataset, you just have to run:
>> run_me;

Throughout these commands, a series of questions will pop up on the
screen. They will guide the software to correctly parameterize your
dataset, and learn on it. For "Descriptor Configuration", remember 
to choose layer 19. 

The output of "run_me" will be already formatted for a CSV file, so,
you can simply save it inside a file with a .csv format and open it
later in your favorite spreadsheet editor to run any further
analysis.