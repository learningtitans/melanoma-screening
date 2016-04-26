function [] = run_matlab( datasetFolder, experiment )

switch experiment
    case('lmh')
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_1_scores', 'results.gitnot/lmh_train_1_codebook', 'results.gitnot/lmh_train_1_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_1_scores', 'results.gitnot/lmh_train_1_codebook', 'results.gitnot/lmh_test_1_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_2_scores', 'results.gitnot/lmh_train_2_codebook', 'results.gitnot/lmh_train_2_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_2_scores', 'results.gitnot/lmh_train_2_codebook', 'results.gitnot/lmh_test_2_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_3_scores', 'results.gitnot/lmh_train_3_codebook', 'results.gitnot/lmh_train_3_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_3_scores', 'results.gitnot/lmh_train_3_codebook', 'results.gitnot/lmh_test_3_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_4_scores', 'results.gitnot/lmh_train_4_codebook', 'results.gitnot/lmh_train_4_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_4_scores', 'results.gitnot/lmh_train_4_codebook', 'results.gitnot/lmh_test_4_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_5_scores', 'results.gitnot/lmh_train_5_codebook', 'results.gitnot/lmh_train_5_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_5_scores', 'results.gitnot/lmh_train_5_codebook', 'results.gitnot/lmh_test_5_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_6_scores', 'results.gitnot/lmh_train_6_codebook', 'results.gitnot/lmh_train_6_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_6_scores', 'results.gitnot/lmh_train_6_codebook', 'results.gitnot/lmh_test_6_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_7_scores', 'results.gitnot/lmh_train_7_codebook', 'results.gitnot/lmh_train_7_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_7_scores', 'results.gitnot/lmh_train_7_codebook', 'results.gitnot/lmh_test_7_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_8_scores', 'results.gitnot/lmh_train_8_codebook', 'results.gitnot/lmh_train_8_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_8_scores', 'results.gitnot/lmh_train_8_codebook', 'results.gitnot/lmh_test_8_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_9_scores', 'results.gitnot/lmh_train_9_codebook', 'results.gitnot/lmh_train_9_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_9_scores', 'results.gitnot/lmh_train_9_codebook', 'results.gitnot/lmh_test_9_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_10_scores', 'results.gitnot/lmh_train_10_codebook', 'results.gitnot/lmh_train_10_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmh_train_10_scores', 'results.gitnot/lmh_train_10_codebook', 'results.gitnot/lmh_test_10_features.svm', 'test', 6)
        
        exit
        
    case('lm')
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_1_scores', 'results.gitnot/lm_train_1_codebook', 'results.gitnot/lm_train_1_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_1_scores', 'results.gitnot/lm_train_1_codebook', 'results.gitnot/lm_test_1_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_2_scores', 'results.gitnot/lm_train_2_codebook', 'results.gitnot/lm_train_2_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_2_scores', 'results.gitnot/lm_train_2_codebook', 'results.gitnot/lm_test_2_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_3_scores', 'results.gitnot/lm_train_3_codebook', 'results.gitnot/lm_train_3_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_3_scores', 'results.gitnot/lm_train_3_codebook', 'results.gitnot/lm_test_3_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_4_scores', 'results.gitnot/lm_train_4_codebook', 'results.gitnot/lm_train_4_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_4_scores', 'results.gitnot/lm_train_4_codebook', 'results.gitnot/lm_test_4_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_5_scores', 'results.gitnot/lm_train_5_codebook', 'results.gitnot/lm_train_5_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_5_scores', 'results.gitnot/lm_train_5_codebook', 'results.gitnot/lm_test_5_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_6_scores', 'results.gitnot/lm_train_6_codebook', 'results.gitnot/lm_train_6_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_6_scores', 'results.gitnot/lm_train_6_codebook', 'results.gitnot/lm_test_6_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_7_scores', 'results.gitnot/lm_train_7_codebook', 'results.gitnot/lm_train_7_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_7_scores', 'results.gitnot/lm_train_7_codebook', 'results.gitnot/lm_test_7_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_8_scores', 'results.gitnot/lm_train_8_codebook', 'results.gitnot/lm_train_8_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_8_scores', 'results.gitnot/lm_train_8_codebook', 'results.gitnot/lm_test_8_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_9_scores', 'results.gitnot/lm_train_9_codebook', 'results.gitnot/lm_train_9_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_9_scores', 'results.gitnot/lm_train_9_codebook', 'results.gitnot/lm_test_9_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_10_scores', 'results.gitnot/lm_train_10_codebook', 'results.gitnot/lm_train_10_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lm_train_10_scores', 'results.gitnot/lm_train_10_codebook', 'results.gitnot/lm_test_10_features.svm', 'test', 6)
        
        exit
        
    case('lmplus')
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_1_scores', 'results.gitnot/lmplus_train_1_codebook', 'results.gitnot/lmplus_train_1_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_1.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_1_scores', 'results.gitnot/lmplus_train_1_codebook', 'results.gitnot/lmplus_test_1_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_2_scores', 'results.gitnot/lmplus_train_2_codebook', 'results.gitnot/lmplus_train_2_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_2.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_2_scores', 'results.gitnot/lmplus_train_2_codebook', 'results.gitnot/lmplus_test_2_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_3_scores', 'results.gitnot/lmplus_train_3_codebook', 'results.gitnot/lmplus_train_3_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_3.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_3_scores', 'results.gitnot/lmplus_train_3_codebook', 'results.gitnot/lmplus_test_3_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_4_scores', 'results.gitnot/lmplus_train_4_codebook', 'results.gitnot/lmplus_train_4_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_4.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_4_scores', 'results.gitnot/lmplus_train_4_codebook', 'results.gitnot/lmplus_test_4_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_5_scores', 'results.gitnot/lmplus_train_5_codebook', 'results.gitnot/lmplus_train_5_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_5.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_5_scores', 'results.gitnot/lmplus_train_5_codebook', 'results.gitnot/lmplus_test_5_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_6_scores', 'results.gitnot/lmplus_train_6_codebook', 'results.gitnot/lmplus_train_6_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_6.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_6_scores', 'results.gitnot/lmplus_train_6_codebook', 'results.gitnot/lmplus_test_6_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_7_scores', 'results.gitnot/lmplus_train_7_codebook', 'results.gitnot/lmplus_train_7_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_7.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_7_scores', 'results.gitnot/lmplus_train_7_codebook', 'results.gitnot/lmplus_test_7_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_8_scores', 'results.gitnot/lmplus_train_8_codebook', 'results.gitnot/lmplus_train_8_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_8.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_8_scores', 'results.gitnot/lmplus_train_8_codebook', 'results.gitnot/lmplus_test_8_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_9_scores', 'results.gitnot/lmplus_train_9_codebook', 'results.gitnot/lmplus_train_9_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_9.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_9_scores', 'results.gitnot/lmplus_train_9_codebook', 'results.gitnot/lmplus_test_9_features.svm', 'test', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_10_scores', 'results.gitnot/lmplus_train_10_codebook', 'results.gitnot/lmplus_train_10_features.svm', 'train', 6)
        
        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_10.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), 'results.gitnot/lmplus_train_10_scores', 'results.gitnot/lmplus_train_10_codebook', 'results.gitnot/lmplus_test_10_features.svm', 'test', 6)
        
        exit
end
end