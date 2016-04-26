function [] = run_matlab( datasetFolder, experiment )

switch experiment
    case('lmh')
    	for fold = 1:10
    		skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_train_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lmh_train_',int2str(fold),'_scores'), strcat('results.gitnot/lmh_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lmh_train_',int2str(fold),'_features.svm'), 'train', 6)
	        
	        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmh/lmh_test_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lmh_train_',int2str(fold),'_scores'), strcat('results.gitnot/lmh_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lmh_test_',int2str(fold),'_features.svm'), 'test', 6)
	        
	    end
        exit
        
    case('lm')
    	for fold = 1:10
        	skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_train_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lm_train_',int2str(fold),'_scores'), strcat('results.gitnot/lm_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lm_train_',int2str(fold),'_features.svm'), 'train', 6)
	        
	        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lm/lm_test_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lm_train_',int2str(fold),'_scores'), strcat('results.gitnot/lm_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lm_test_',int2str(fold),'_features.svm'), 'test', 6)
	    end
        exit
        
    case('lmplus')
    	for fold = 1:10
    		skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_train_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lmplus_train_',int2str(fold),'_scores'), strcat('results.gitnot/lmplus_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lmplus_train_',int2str(fold),'_features.svm'), 'train', 6)
	        
	        skinScan(strcat(datasetFolder,'atlas/folds.gitnot/lmplus/lmplus_test_',int2str(fold),'.csv'), strcat(datasetFolder,'atlas/All_flat.gitnot/'), strcat(datasetFolder,'atlas/cache.gitnot/'), strcat('results.gitnot/lmplus_train_',int2str(fold),'_scores'), strcat('results.gitnot/lmplus_train_',int2str(fold),'_codebook'), strcat('results.gitnot/lmplus_test_',int2str(fold),'_features.svm'), 'test', 6)	    end
        exit
end
end

    	