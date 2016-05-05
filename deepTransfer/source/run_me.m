function []=run_me()
	s = RandStream('mt19937ar','Seed','shuffle'); % Generate a new seed based on the current time
    RandStream.setGlobalStream(s);

    c_grid = [0.0001 0.001 0.01 0.1 1.0 10.0 100.0 1000.0];
    w_grid = [1 2 3 4 5 6 7 8];
    enable_full = false; % Change to true to enable full verbose (other metrics and test groups)

    fcommon = common;

	[dataset_name, fold_group, layer, trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme, nfolds, test_groups] = fcommon.load_dataset();
	
    valchosen = -1;
    subfolds = -1;
    while valchosen < 1 || valchosen > 2,
        fprintf('==============================\n');
        fprintf('==== Validation selection ====\n');
        fprintf('==============================\n');
        fprintf('  1) Cross validation for test + fixed validation set (%d runs)\n', nfolds);
        fprintf('  2) Cross validation for test + dynamic validation set (%d runs)\n', nfolds*(nfolds-1));
        valchosen = input(sprintf('Choose [1-2]: '));
        if valchosen == 1,
            subfolds = nfolds;
        elseif valchosen == 2,
            subfolds = nfolds*(nfolds-1);
        else,
            fprintf('\nInvalid option. Please try again.\n\n');
        end
    end

    % To output the scores, uncomment the following lines
    % diary(sprintf('%s/%s.csv', fold_group, fold_group));
    % diary on;

	fprintf('Grid Search for %s (%s).\n', dataset_name, fold_group);

    if ispc
        addpath('../resources/liblinear-1.96/windows');
    else
        addpath('../resources/liblinear-1.96/matlab');
    end

    classes = unique(vertcat(unique(trn_lbl{1}),unique(val_lbl{1}),unique(tst_lbl{1})));
    nclasses = size(classes,1);

    classcount = [];
    for i=1:nclasses
        classcount(i) = sum(trn_lbl{1}==classes(i)) + sum(val_lbl{1}==classes(i));
    end

    fprintf('Run;BestValidationScore;C;');
    if size(test_groups,1) > 0 && enable_full
        for i = 1:size(test_groups,1)
            if nclasses == 2
                fprintf('Group;AUC;ACC;AP;Sensitivity;Specificity;');
            else
                fprintf('Group;AP;ACC;Sensitivity;Specificity;');
            end
        end
    end
    if enable_full
        if nclasses == 2
            fprintf('Group;AUC;ACC;AP;Sensitivity;Specificity;\n');
        else
            fprintf('Group;AP;ACC;Sensitivity;Specificity;\n');
        end
    else
        if nclasses == 2
            fprintf('Group;AUC;\n');
        else
            fprintf('Group;AP;\n');
        end
    end

    selected_folds = cell(nfolds, 3 + 6*(size(test_groups,1)+1));
    current_fold = cell(1, 3 + 6*(size(test_groups,1)+1));

    for fold=1:subfolds
        fprintf('%02d;', fold);
        cfoldindex = 1;

        [trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index] = fcommon.load_subfold(valchosen, fold, nfolds, trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme);

        prev = 0;
        best_c = 0;
        
        for c = c_grid
            if nclasses == 2
                model = train(trn_labl, sparse(trn_data), sprintf('-q -c %f', c));
                [predicted_labels, accuracy, scores] = predict(val_labl, sparse(val_data), model, '-q');
                clearvars model;
                [ign,ign,ign,auc] = perfcurve(val_labl,scores,1);
                if auc > prev
                    best_c = c;
                    prev = auc;
                end
            else
                model = train(trn_labl, sparse(trn_data), sprintf('-q -c %f', c));
                [predicted_labels, accuracy, scores] = predict(val_labl, sparse(val_data), model, '-q');
                clearvars model;
                ap = fcommon.compute_class_AP(val_labl, scores);
                if ap > prev
                    best_c = c;
                    prev = ap;
                end
            end
        end
		
		fprintf('%f;%f;', prev, best_c);
        current_fold{cfoldindex} = fold;
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = prev;
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = best_c;
        cfoldindex = cfoldindex + 1;
		
        fulltrain_lbl = vertcat(trn_labl, val_labl);
        fulltrain_set = vertcat(trn_data, val_data);

        if nclasses == 2
            model = train(fulltrain_lbl, sparse(fulltrain_set), sprintf('-q -c %f', best_c));
        else
            model = train(fulltrain_lbl, sparse(fulltrain_set), sprintf('-q -c %f', best_c));
        end
        
		if size(test_groups,1) > 0
			total = [];
			for key = keys(test_groups)
				tgroup = test_groups(char(key));
				tgroup = tgroup(:);
				tname = tst_name(:);
				[names_used, index_tst, ign] = intersect(tname, tgroup);
				total = vertcat(total, names_used);
				if size(index_tst,1) < 1
					continue
				end
				if numel(unique(tst_labl(index_tst))) == 1
					error = sprintf('ERROR: Single-class fold found on group "%s" with %d image(s):\n', char(key), numel(names_used));
					for name = names_used
						error = sprintf('%s%s ', error, char(name));
					end
					excp = MException('Runtime:groups_mismatch', error);
					throw(excp);
				end
                test_labels = tst_labl(index_tst);
				[predicted_labels, accuracy, scores] = predict(test_labels, sparse(tst_data(index_tst,:)), model, '-q');
                
                % To output the scores, uncomment the following line
                % save(sprintf('%s/%d_%s.mat', fold_group, fold, char(key)), 'scores', 'test_labels');

				ap = fcommon.compute_class_AP(test_labels, scores);
				[specificity,sensitivity] = calculate_specsens(test_labels, predicted_labels, 1);
                if enable_full
    				if nclasses == 2
    					[ign,ign,ign,auc] = perfcurve(test_labels, scores, 1);
    					fprintf('%s;%f;%f;%f;%f;%f;', char(key), auc, accuracy(1)/100.0, ap, sensitivity, specificity);
    				else
    					fprintf('%s;%f;%f;%f;%f;', char(key), ap, accuracy(1)/100.0, sensitivity, specificity);
    				end
                end
                current_fold{cfoldindex} = char(key);
                cfoldindex = cfoldindex + 1;
                if nclasses == 2
                    current_fold{cfoldindex} = auc;
                else
                    current_fold{cfoldindex} = -1;
                end
                cfoldindex = cfoldindex + 1;
                current_fold{cfoldindex} = accuracy(1)/100.0;
                cfoldindex = cfoldindex + 1;
                current_fold{cfoldindex} = ap;
                cfoldindex = cfoldindex + 1;
                current_fold{cfoldindex} = sensitivity;
                cfoldindex = cfoldindex + 1;
                current_fold{cfoldindex} = specificity;
                cfoldindex = cfoldindex + 1;
			end
			if numel(intersect(total, tst_name)) ~= numel(tst_name)
				nogroup = setdiff(tst_name, total);
				error = sprintf('ERROR: Groups do not cover the entire test fold. Images without group (%d):\n', numel(nogroup));
				for name = nogroup
					error = sprintf('%s%s ', error, char(name));
				end
				excp = MException('Runtime:groups_mismatch', error);
				throw(excp);
			end
		end
        test_labels = tst_labl;
		[predicted_labels, accuracy, scores] = predict(test_labels, sparse(tst_data), model, '-q');

        % To output the scores, uncomment the following line
        % save(sprintf('%s/%d_all.mat', fold_group, fold), 'scores', 'test_labels');

		ap = fcommon.compute_class_AP(tst_labl, scores);
		[specificity,sensitivity] = calculate_specsens(tst_labl, predicted_labels, 1);
        if enable_full
    		if nclasses == 2
    			[ign,ign,ign,auc] = perfcurve(tst_labl, scores, 1);
    			fprintf('all;%f;%f;%f;%f;%f;\n', auc, accuracy(1)/100.0, ap, sensitivity, specificity);
    		else
    			fprintf('all;%f;%f;%f;%f;\n', ap, accuracy(1)/100.0, sensitivity, specificity);
    		end
        else
            if nclasses == 2
                [ign,ign,ign,auc] = perfcurve(tst_labl, scores, 1);
                fprintf('all;%f;\n', auc);
            else
                fprintf('all;%f;\n', ap);
            end
        end
        current_fold{cfoldindex} = 'all';
        cfoldindex = cfoldindex + 1;
        if nclasses == 2
            current_fold{cfoldindex} = auc;
        else
            current_fold{cfoldindex} = -1;
        end
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = accuracy(1)/100.0;
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = ap;
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = sensitivity;
        cfoldindex = cfoldindex + 1;
        current_fold{cfoldindex} = specificity;
        cfoldindex = cfoldindex + 1;

        if isempty(selected_folds{tst_index,2}) || selected_folds{tst_index,2} < current_fold{2}
            selected_folds(tst_index,:) = current_fold;
        end

        clearvars model;
    end
    % Summary for cross-validation for test with dynamic validation set
    if valchosen == 2
        fprintf('\n\nSelected folds, according to the best score in the dynamic validation set:\n\n');
        fprintf('Fold;BestValidationScore;C;');
        if size(test_groups,1) > 0 && enable_full
            for i = range(size(test_groups,1))
                if nclasses == 2
                    fprintf('Group;AUC;ACC;AP;Sensitivity;Specificity;');
                else
                    fprintf('Group;AP;ACC;Sensitivity;Specificity;');
                end
            end
        end
        if enable_full
            if nclasses == 2
                fprintf('Group;AUC;ACC;AP;Sensitivity;Specificity;\n');
            else
                fprintf('Group;AP;ACC;Sensitivity;Specificity;\n');
            end
        else
            if nclasses == 2
                fprintf('Group;AUC;\n');
            else
                fprintf('Group;AP;\n');
            end
        end
        for fold=1:nfolds
            indx = 4;
            fprintf('%02d;%f;%f;', fold, selected_folds{fold,2}, selected_folds{fold,3});
            if size(test_groups,1) > 0
                if enable_full
                    for i=1:size(test_groups,1)+1
                        if nclasses == 2
                            fprintf('%s;%f;%f;%f;%f;%f;', selected_folds{fold,indx}, selected_folds{fold,indx+1}, selected_folds{fold,indx+2}, selected_folds{fold,indx+3}, selected_folds{fold,indx+4}, selected_folds{fold,indx+5});
                        else
                            fprintf('%s;%f;%f;%f;%f;', selected_folds{fold,indx}, selected_folds{fold,indx+2}, selected_folds{fold,indx+3}, selected_folds{fold,indx+4}, selected_folds{fold,indx+5});
                        end
                        indx = indx + 6;
                    end
                else
                    fprintf('%s;%f;', selected_folds{fold,size(test_groups,1)*6 + 4}, selected_folds{fold,size(test_groups,1)*6 + 5});
                end
            else
            	fprintf('%s;%f;', selected_folds{fold,size(test_groups,1)*6 + 4}, selected_folds{fold,size(test_groups,1)*6 + 5});
            end
            fprintf('\n');
        end
    end
    % To output the scores, uncomment the following line
    % diary off;
end

function [specificity,sensitivity]=calculate_specsens(ground_truth,predicted_labels,positive_class)
    gt_positive = (ground_truth == positive_class);
    gt_negative = (ground_truth ~= positive_class);
    pr_positive = (predicted_labels == positive_class);
    pr_negative = (predicted_labels ~= positive_class);
    
    true_positive = sum(gt_positive & pr_positive);
    true_negative = sum(gt_negative & pr_negative);
    false_positive = sum(gt_negative & pr_positive);
    false_negative = sum(gt_positive & pr_negative);
    
    sensitivity = true_positive / (true_positive + false_negative);
    specificity = true_negative / (true_negative + false_positive);
end
