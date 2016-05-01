%skinScan( inFoldFile, inImageDir, inoutCacheDir, inoutScoresFile, inoutCodebookFile, outFeaturesFile, trainOrTest, loglevel, parallelThreads )

for fold = 1:10
    skinScan(strcat(datasetFolder,'/folds/',experiment,'/',experiment,'_train_',int2str(fold),'.csv'), strcat(datasetFolder,'/images/'), strcat(datasetFolder,'/cache/'), strcat('results/',experiment,'_train_',int2str(fold),'_scores'), strcat('results/',experiment,'_train_',int2str(fold),'_codebook'), strcat('results/',experiment,'_train_',int2str(fold),'_features.svm'), 'train', 6)
	        
	skinScan(strcat(datasetFolder,'/folds/',experiment,'/',experiment,'_test_',int2str(fold),'.csv'), strcat(datasetFolder,'/images/'), strcat(datasetFolder,'/cache/'), strcat('results/',experiment,'_train_',int2str(fold),'_scores'), strcat('results/',experiment,'_train_',int2str(fold),'_codebook'), strcat('results/',experiment,'_test_',int2str(fold),'_features.svm'), 'test', 6)       
end