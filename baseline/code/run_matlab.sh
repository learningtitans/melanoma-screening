mkdir results.gitnot



/local/carvalho/applications/matlab_2015b/bin/matlab -nodisplay -nodesktop -nosplash -r "skinScan('../datasets/atlas/folds.gitnot/sandra-spsr/sandra-spsr_train_1.csv', '../datasets/atlas/All_Flat.gitnot/', '../datasets/atlas/cache.gitnot/', 'results.gitnot/sandra-spsr_train_1_scores', 'results.gitnot/sandra-spsr_train_1_codebook', 'results.gitnot/sandra-spsr_train_1_features.svm', 'train', 6)"

/local/carvalho/applications/matlab_2015b/bin/matlab -nodisplay -nodesktop -nosplash -r "skinScan('../datasets/atlas/folds.gitnot/sandra-spsr/sandra-spsr_test_1.csv', '../datasets/atlas/All_Flat.gitnot/', '../datasets/atlas/cache.gitnot/', 'results.gitnot/sandra-spsr_train_1_scores', 'results.gitnot/sandra-spsr_train_1_codebook', 'results.gitnot/sandra-spsr_test_1_features.svm', 'test', 6)"
