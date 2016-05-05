function [common]=common()
	common.load_dataset = @load_dataset;
	common.start_matconvnet = @start_matconvnet;
	common.compute_class_AP = @compute_class_AP;
	common.extract_features = @extract_features;
	common.load_dataset_simple = @load_dataset_simple;
	common.load_subfold = @load_subfold;
end

function [net]=start_matconvnet()
	run('../resources/matconvnet/matlab/vl_setupnn');
	net = load('../resources/models/imagenet-vgg-m.mat');
end

function ap=compute_class_AP(labels_GT, scores)
    % Cette fonction calcule l'average precision pour un ensemble d'images.
    %-----------------------------------------------------------------------
    % labels_GT : vecteur des labels (1 ou -1) verite terrain des images 
    %             longueur du vecteur : nombre d'images testees
    % scores    : scores de classification donnes par le SVM
    %             longueur du vecteur : nombre d'images testees
    %-----------------------------------------------------------------------

    % compute precision/recall
    [so,si] = sort(-scores);
    fp = cumsum(labels_GT(si)<0);
    tp = cumsum(labels_GT(si)>0);
    recall    = tp/sum(labels_GT>0);
    precision = tp./(fp+tp);
    
    % compute average precision
    ap = 0;
    for t = 0:0.1:1
        p = max( precision(recall>=t) );
        if isempty(p)
            p = 0;
        end
        ap = ap+p/11;
    end     
end

function []=extract_features(layer)
	[dataset_name, labelmap] = load_dataset_simple();
	fprintf('Starting MatConvNet... ');
	net = start_matconvnet();
	images = keys(labelmap);
	fprintf('Done.\n\n');
	features = {};
	labels = {};
	for i=1:size(images,2)
		% Data Augmentation Point 1
		image_name = char(images(i));
		fprintf('%05d: Loading image %s... ', i, image_name);
		desc = load_image(net, layer, sprintf('../datasets/%s/data/%s', dataset_name, image_name));
		fprintf('Done.\n');
		features{i} = desc;
		labels{i} = labelmap(image_name);
	end
	fprintf('Saving descriptor file... ');
	save(sprintf('../datasets/%s/desc/%02d.desc.mat', dataset_name, layer), 'images', 'features', 'labels');
	fprintf('Done.\n');
end

function [dataset_name, labelmap]=load_dataset_simple()
	datasets = dir('../datasets');
	isfolder = [datasets(:).isdir];
	datasets = {datasets(isfolder).name}';
	datasets(ismember(datasets,{'.','..'})) = [];
	dschosen = -1;
	while dschosen < 1 || dschosen > size(datasets,1),
		fprintf('==============================\n');
		fprintf('===== Dataset  selection =====\n');
		fprintf('==============================\n');
		for i=1:size(datasets,1),
			fprintf('  %d) %s\n', i, char(datasets(i)));
		end
		dschosen = input(sprintf('Choose [1-%d]: ', size(datasets,1)));
		if dschosen < 1 || dschosen > size(datasets,1),
			fprintf('\nInvalid option. Please try again.\n\n');
		end
	end
	fprintf('\nLoading dataset labels... ');
	dataset_name = char(datasets(dschosen));
	labelmap = load_labels(sprintf('../datasets/%s/%s.conf', dataset_name, dataset_name));
	fprintf('Done.\n\n');
end

function [desc, labl]=load_image_desc(images, features, labels, image_name)
	for i=1:size(images,2)
		if strcmp(images(i),image_name) == 1
			desc = features(i);
			labl = labels(i);
			desc = desc{1};
			labl = labl{1};
			return;
		end
	end
	fprintf('Image %s not found.\n', image_name);
end

function [trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme]=load_features(dataset_name, layer, trn, val, tst, ftype, nfolds)
	if nfolds < 1
		return
	end

	fprintf('\nLoading features... ');

	try
		load(sprintf('../datasets/%s/desc/%02d.desc.mat', dataset_name, layer));
	catch
		excp = MException('Runtime:no_descriptor', sprintf('ERROR: No descriptor found for layer %d.\n', layer));
		throw(excp);
	end

	fprintf('Done.\n\n');

	if ftype{1}(1) == 0,
		[trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme] = load_folds(images, features, labels, trn, val, tst, ftype, nfolds);
	else
		excp = MException('Runtime:fold_type_not_supported', sprintf('ERROR: Fold type (%d) not supported.\n', ftype{1}(1)));
		throw(excp);
	end
	fprintf('\n');
end

function [trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme]=load_folds(images, features, labels, trn, val, tst, ftype, nfolds)
	trn_set = cell(1,nfolds);
	val_set = cell(1,nfolds);
	tst_set = cell(1,nfolds);
	for i=1:nfolds
		trn_set{i} = [];
		val_set{i} = [];
		tst_set{i} = [];
    end
	trn_lbl = [];
	trn_nme = [];
	val_lbl = [];
	val_nme = [];
	tst_lbl = [];
	tst_nme = [];
	for i=1:nfolds
		fprintf('Pre-loading subfold %d... ', i);

		desc = [];
		labl = [];
		cpos = 1;
		for img=1:size(trn{i},1)
			[general_desc, general_labl] = load_image_desc(images, features, labels, trn{i}(img));
			for k=1:size(general_desc,1)
				labl(cpos,:) = general_labl;
				desc(cpos,:) = general_desc;
				cpos = cpos + 1;
			end
		end
		trn_set{i} = desc;
		trn_lbl{i} = labl;
		trn_nme{i} = trn{i};

		desc = [];
		labl = [];
		cpos = 1;
		forsize = 0;
		try
			forsize = size(val{i},1)
		end
		for img=1:forsize
			[general_desc, general_labl] = load_image_desc(images, features, labels, val{i}(img));
			for k=1:size(general_desc,1)
				labl(cpos,:) = general_labl;
				desc(cpos,:) = general_desc;
				cpos = cpos + 1;
			end
		end
		val_set{i} = desc;
		val_lbl{i} = labl;
		if forsize > 0
			val_nme{i} = val{i};
		end

		desc = [];
		labl = [];
		cpos = 1;
		forsize = 0;
		try
			forsize = size(tst{i},1)
		end
		for img=1:forsize
			[general_desc, general_labl] = load_image_desc(images, features, labels, tst{i}(img));
			for k=1:size(general_desc,1)
				labl(cpos,:) = general_labl;
				desc(cpos,:) = general_desc;
				cpos = cpos + 1;
			end
		end
		tst_set{i} = desc;
		tst_lbl{i} = labl;
		if forsize > 0
			tst_nme{i} = tst{i};
		end
		
		fprintf('OK.\n');
	end
end

function [trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index]=load_subfold(valchosen, fold, nfolds, trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme)
	if valchosen == 1,
		[trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index] = build_validation(fold, nfolds, trn_set, trn_lbl, trn_nme);
	elseif valchosen == 2,
		[trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index] = build_cross_validation(fold, nfolds, trn_set, trn_lbl, trn_nme);
	end
end

function [trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index]=build_validation(fold, nfolds, trn_set, trn_lbl, trn_nme)
	trn_data = [];
	val_data = [];
	tst_data = [];
	trn_labl = [];
	val_labl = [];
	tst_labl = [];
	trn_name = [];
	val_name = [];
	tst_name = [];

	valnumber = fold;
	tstnumber = mod(fold, nfolds)+1;
	tst_index = tstnumber;

	for i=1:nfolds
		if i==tstnumber
			tst_data = trn_set{i};
			tst_labl = trn_lbl{i};
			tst_name = trn_nme{i};
		elseif i==valnumber
			val_data = trn_set{i};
			val_labl = trn_lbl{i};
			val_name = trn_nme{i};
		else
			try
				trn_data = [trn_data; trn_set{i}];
				trn_labl = [trn_labl; trn_lbl{i}];
				trn_name = [trn_name; trn_nme{i}];
			catch
				trn_data = trn_set{i};
				trn_labl = trn_lbl{i};
				trn_name = trn_nme{i};
			end
		end
	end
end

function [trn_data, trn_labl, trn_name, val_data, val_labl, val_name, tst_data, tst_labl, tst_name, tst_index]=build_cross_validation(fold, nfolds, trn_set, trn_lbl, trn_nme)
	trn_data = [];
	val_data = [];
	tst_data = [];
	trn_labl = [];
	val_labl = [];
	tst_labl = [];

	valnumber = fix((fold-1)/(nfolds-1))+1;
	tstnumber = fold - (valnumber-1) * (nfolds-1);

	if tstnumber >= valnumber
		tstnumber = tstnumber + 1;
	end
	tst_index = tstnumber;
	
	for i=1:nfolds
		if i==tstnumber
			tst_data = trn_set{i};
			tst_labl = trn_lbl{i};
			tst_name = trn_nme{i};
		elseif i==valnumber
			val_data = trn_set{i};
			val_labl = trn_lbl{i};
			val_name = trn_nme{i};
		else
			try
				trn_data = [trn_data; trn_set{i}];
				trn_labl = [trn_labl; trn_lbl{i}];
				trn_name = [trn_name; trn_nme{i}];
			catch
				trn_data = trn_set{i};
				trn_labl = trn_lbl{i};
				trn_name = trn_nme{i};
			end
		end
	end
end

function [dataset_name, fold_group, layer, trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme, nfolds, test_groups]=load_dataset()
	[dataset_name, labelmap] = load_dataset_simple();
	dataconf = dir(sprintf('../datasets/%s/folds', dataset_name));
	isfolder = [dataconf(:).isdir];
	dataconf = {dataconf(isfolder).name}';
	dataconf(ismember(dataconf,{'.','..'})) = [];
	dcchosen = -1;
	while dcchosen < 1 || dcchosen > size(dataconf,1),
		fprintf('==============================\n');
		fprintf('=== Dataset  configuration ===\n');
		fprintf('==============================\n');
		for i=1:size(dataconf,1),
			fprintf('  %d) %s\n', i, char(dataconf(i)));
		end
		dcchosen = input(sprintf('Choose [1-%d]: ', size(dataconf,1)));
		if dcchosen < 1 || dcchosen > size(dataconf,1),
			fprintf('\nInvalid option. Please try again.\n\n');
		end
	end
	test_groups = containers.Map;
	if exist(sprintf('../datasets/%s/test_groups.csv', dataset_name), 'file')
		fobj = fopen(sprintf('../datasets/%s/test_groups.csv', dataset_name),'r');
		predata = textscan(fobj, repmat('%s', 1, 2), 'delimiter', ',', 'CollectOutput', true);
		data = predata{1};
		fclose(fobj);
		for i = 1:size(data,1)
			if isKey(test_groups,char(data(i,2)))
				test_groups(char(data(i,2))) = [test_groups(char(data(i,2))), char(data(i,1))];
			else
				test_groups(char(data(i,2))) = {char(data(i,1))};
			end
		end
	end
	fprintf('\nLoading folds... ');
	fold_group = char(dataconf(dcchosen));
	trn = {};
	val = {};
	tst = {};
	[trn, nfolds] = load_simple_folds(labelmap, sprintf('../datasets/%s/folds/%s', dataset_name, fold_group));
	if nfolds == 0
		[trn, val, tst, ftype, nfolds] = load_defined_folds(labelmap, sprintf('../datasets/%s/folds/%s', dataset_name, fold_group));
	else
		ftype = num2cell(zeros(1,nfolds));
	end
	if nfolds > 0
		fprintf('Done.\n\n');
	else
		fprintf('Failed.\n\n');
	end

	layer = -1;
	while layer < 1 || layer > 22,
		fprintf('==============================\n');
		fprintf('== Descriptor Configuration ==\n');
		fprintf('==============================\n');
		layer = input(sprintf('Choose [1-22]: '));
		if layer < 1 || layer > 22,
			fprintf('\nInvalid option. Please try again.\n\n');
		end
	end
	
	% save_folds(test_groups, trn, nfolds);

	[trn_set, trn_lbl, trn_nme, val_set, val_lbl, val_nme, tst_set, tst_lbl, tst_nme] = load_features(dataset_name, layer, trn, val, tst, ftype, nfolds);
end

% This function is for validation only, it has no other use.
function []=save_folds(test_groups, trn, nfolds)
	for fold = 1:nfolds
		for key = keys(test_groups)
			tgroup = test_groups(char(key));
			tgroup = tgroup(:);
			[names_used, index_tst, ign] = intersect(tgroup, trn{fold});
			outputfile = fopen(sprintf('fold_%d_%s.txt', fold-1, char(key)), 'w');
			for i = 1:numel(names_used)
				if i > 1
					fprintf(outputfile, ',');
				end
				fprintf(outputfile, '%s', char(names_used(i)));
			end
			fclose(outputfile);
		end
	end
end

function [labelmap]=load_labels(dataset_descriptor)
	[images, labels] = textread(dataset_descriptor, '%s%d', 'delimiter', ',\n');
	labelmap = containers.Map();
	for i=1:size(images,1)
		labelmap(char(images(i))) = int8(labels(i));
	end
end

function [folds,nfolds]=load_simple_folds(labelmap, dataset_fold_path)
	fold_index = 1;
	folds = {};
	used_images = containers.Map();
	while true
		filename = sprintf('%s/%d.conf', dataset_fold_path, fold_index);
		if ~exist(filename)
			nfolds = fold_index - 1;
			break;
		end
		[fold_images] = textread(filename, '%s', 'delimiter', ',\n');
		for i=1:size(fold_images,1)
			image_name = char(fold_images(i));
			if ~isKey(labelmap,image_name)
				excp = MException('Runtime:unlabeled_image', sprintf('ERROR: Unlabeled image "%s" in fold %d.\n', image_name, fold_index));
				throw(excp);
			end
			if isKey(used_images,image_name)
				excp = MException('Runtime:contamined_folds', sprintf('ERROR: Contaminated folds. Image %s is present in both folds %d and %d.\n', image_name, used_images(image_name), fold_index));
				throw(excp);
			else
				used_images(image_name) = fold_index;
			end
		end
		folds{fold_index} = fold_images;
		fold_index = fold_index + 1;
	end
end

function [trn, val, tst, ftype, nfolds]=load_defined_folds(labelmap, dataset_fold_path)
	fold_index = 1;
	trn = {};
	val = {};
	tst = {};
	ftype = {};
	while true
		used_images = containers.Map();
		filename_trn = sprintf('%s/%d.conf.trn', dataset_fold_path, fold_index);
		filename_val = sprintf('%s/%d.conf.val', dataset_fold_path, fold_index);
		filename_tst = sprintf('%s/%d.conf.tst', dataset_fold_path, fold_index);
		if ~(exist(filename_trn) && exist(filename_tst))
			nfolds = fold_index - 1;
			break;
		end
		[trn_images] = textread(filename_trn, '%s', 'delimiter', ',\n');
		for i=1:size(trn_images,1)
			image_name = char(trn_images(i));
			if ~isKey(labelmap,image_name)
				excp = MException('Runtime:unlabeled_image', sprintf('ERROR: Unlabeled image "%s" in training set for fold %d.\n', image_name, fold_index));
				throw(excp);
			end
			used_images(image_name) = 'training';
		end
		has_val = false;
		if exist(filename_val)
			[val_images] = textread(filename_val, '%s', 'delimiter', ',\n');
			for i=1:size(val_images,1)
				image_name = char(val_images(i));
				if ~isKey(labelmap,image_name)
					excp = MException('Runtime:unlabeled_image', sprintf('ERROR: Unlabeled image "%s" in validation set for fold %d.\n', image_name, fold_index));
					throw(excp);
				end
				if isKey(used_images,image_name)
					excp = MException('Runtime:contamined_folds', sprintf('ERROR: Contaminated folds. Image %s is present in both training and validation folds.\n', image_name));
					throw(excp);
				else
					used_images(image_name) = 'validation';
				end
			end
			has_val = true;
		end
		[tst_images] = textread(filename_tst, '%s', 'delimiter', ',\n');
		for i=1:size(tst_images,1)
			image_name = char(tst_images(i));
			if ~isKey(labelmap,image_name)
				excp = MException('Runtime:unlabeled_image', sprintf('ERROR: Unlabeled image "%s" in test set for fold %d.\n', image_name, fold_index));
				throw(excp);
			end
			if isKey(used_images,image_name)
				excp = MException('Runtime:contamined_folds', sprintf('ERROR: Contaminated folds. Image %s is present in both %s and test folds.\n', image_name, used_images(image_name)));
				throw(excp);
			else
				used_images(image_name) = 'test';
			end
		end
		if has_val
			ftype{fold_index} = 2;
			val{fold_index} = val_images;
		else
			ftype{fold_index} = 1;
		end
		trn{fold_index} = trn_images;
		tst{fold_index} = tst_images;
		fold_index = fold_index + 1;
	end
end

function desc=load_image(net, layer, image_path)
	image = imresize(single(imread(image_path)), net.meta.normalization.imageSize(1:2)) - net.meta.normalization.averageImage;
	fulldesc = vl_simplenn(net, image);
    raw = fulldesc(layer+1).x;
    val = squeeze(double(raw));
    fdim = 1;
    for i = size(val)
		fdim = fdim * i;
    end
    val = reshape(val, 1, fdim);
	no = norm(val, 2);
	desc = reshape(raw ./ no, 1, fdim);
end
