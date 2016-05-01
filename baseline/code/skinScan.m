% Implements the skinScan procedure, as described in 
% [1] Tarun Wadhawan, Ning Situ, Keith Lancaster, Xiaojing Yuan, George Zouridakis. SkinScan: 
%     A portable library for melanoma detection on handheld devices. DOI: 10.1109/ISBI.2011.5872372
%
% Lesion segmentation is performed as described in [1]-Section 2.2, using the technique below 
% [2] Tony F. Chan, Luminita A. Vese. Active Contours Without Edges. DOI: 10.1109/83.902291.
%
% Because some parameters were not found in the papers above, we also consulted 
% [3] Xiaojing Yuana, Ning Situc, George Zouridakis. A narrow band graph partitioning method for 
%     skin lesion segmentation. DOI: 
%
% This code is (c) Eduardo Valle (mail@eduardovalle.com), 2016
% This code is inspired on a previous version (c) Tiago Ferreira, 2015.
%
% The Active Contours [2] code is (c) Yue Wu (yue.wu@tufts.edu), 2009, licenced under BSD License,
% please, see the details at: 
% http://www.mathworks.com/matlabcentral/fileexchange/23445-chan-vese-active-contours-without-edges
%

function [ ] = skinScan( inFoldFile, inImageDir, inoutCacheDir, inoutScoresFile, ..., 
    inoutCodebookFile, outFeaturesFile, trainOrTest, loglevel, parallelThreads )

    if nargin < 8, loglevel = 2; end

    % this sets the process to use as many parallel threads as processors
    % this should be set to 1 to disable parallelism
    if nargin < 9, parallelThreads = 0; end

    % all hardwired parameters go in this section -----
    global skinScan_ImageSuffix;
    skinScan_ImageSuffix   = '.jpg';

    % ...parameters used in logprint
    global skinScan_LogLevel;
    skinScan_LogLevel = loglevel; % Only messages below or equal this level will be printed

    % ...parameters used in skinScan()
    % RandomSeed       = 39757; % Allow results be reproducible exactly
    CodebookSize     = 200;      % Parameter L=200 defined in [1]-Section 2.4.1
    KmeansIterations = 1000;     % Unspecified in the papers, known to have little effect on large BOWs
    KmeansMaxSample  = 1000000;  % Unspecified in the papers
    KmeansMinSample  = 10000;    % Unspecified in the papers
    KmeansSample     = 0.25;     % Unspecified in the papers

    % ...parameters used in getFeatures()
    global skinScan_ImageSuffix;
    skinScan_ImageSuffix  = '.jpg';

    % ...parameters used in getImageMask()
    global skinScan_MedianFilterProportion skinScan_StructElementProportion;
    global skinScan_ActiveContourInitialRadius skinScan_ActiveContourIterations;
    global skinScan_ActiveContourLengthCost;
    skinScan_MedianFilterProportion = 5.0 / 256.0;  % Defined as 5x5 for a 256x256 image in [3]
    skinScan_StructElementProportion = 3.0 / 256.0; % Deduced 3x3 default for 256x256 images
    skinScan_ActiveContourInitialRadius = 0.25; % Free parameter not present in papers, deduced
    skinScan_ActiveContourIterations    = 2000; % Idem, set by trial, with generous margin
    skinScan_ActiveContourLengthCost    = 0.02; % Idem, set by trial, affects little the results

    % ...parameters used in getImageFeatures()
    global skinScan_PatchSampling skinScan_PatchSize skinScan_HaarLevels;
    skinScan_PatchSampling = 10; % parameter M=10 defined in [1]-Section 2.4.1
    skinScan_PatchSize     = 24; % parameter K=24 defined in [1]-Section 2.4.1
    skinScan_HaarLevels    = 3;  % defined in [1]-Section 2.4.1, Algorithm step 1.d 

    % ----- end

    % if using Octave, loads needed packages
    global skinScan_Octave skinScan_Threads;
    if exist ('OCTAVE_VERSION', 'builtin')
        skinScan_Octave = true;
        logprint(sprintf('Running on Octave V. %s', OCTAVE_VERSION), 3);
        % disables irritating "warning: your version of XXX limits images to YYY bits per pixel"
        warning('off', 'Octave:GraphicsMagic-Quantum-Depth'); 
        pkg load image; % rgb2gray, mean2, std2
        pkg load statistics; % kmeans
        if parallelThreads ~= 1
            pkg load parallel; % kmeans
            if parallelThreads == 0
                skinScan_Threads = nproc;
            end
        else 
            skinScan_Threads = 1;      
        end
    else
        skinScan_Octave = false;
        logprint(sprintf('Running on MATLAB V. %s', version), 3);        
        if parallelThreads ~= 1
            if parallelThreads == 0
                parobj = parpool;
            else
                parobj = parpool(parallelThreads);
            end 
            skinScan_Threads = parobj.NumWorkers;
        else 
            skinScan_Threads = 1;
        end
    end

    % initializes random number generator predictably
    % rng(RandomSeed); --- not implemented in Octave

    % gets list of images describe
    logprint(sprintf('Reading fold description file: %s', inFoldFile), 2);
    [ images, truth ] = textread( inFoldFile, '%s  %d', 'delimiter', '\t', 'headerlines', 1 );

    % extracts low-level features
    logprint('Extracting features...', 2);
    features = getFoldFeatures( images, inImageDir, inoutCacheDir );
    nImages = size(features, 1);
    counts = arrayfun(@(idx)(size(features{idx}, 1)), 1:nImages);
    featuresMatrix = cell2mat(features);
    features = []; % for the sake of memory footprint

    % z-normalize low-level features 
    logprint('Normalizing (z-score)...', 2);
    if strcmp(trainOrTest, 'train')
        [featuresMatrix, trainMean, trainStddev] = zscore( featuresMatrix );
        save( inoutScoresFile, 'trainMean', 'trainStddev' );
        logprint('...z-score trained.', 2);
    else
        distrib = load( inoutScoresFile);
        trainMean = distrib.trainMean;
        trainStddev  = distrib.trainStddev;
        featuresMatrix = bsxfun( @minus,   featuresMatrix, trainMean );
        featuresMatrix = bsxfun( @rdivide, featuresMatrix, trainStddev );
        logprint('...z-score assigned.', 2);
    end

    % finds codebook and computes midlevel by hard assignment and sum-pooling
    % ... coding (assignment)
    if strcmp(trainOrTest, 'train') && exist( strcat( inoutCodebookFile, '.mat' ), 'file' ) == 0
        nFeatures = size(featuresMatrix, 1);
        nSample = max(floor(nFeatures*KmeansSample), KmeansMinSample);
        nSample = min(nSample, nFeatures);
        nSample = min(nSample, KmeansMaxSample);
        sample = randperm(nFeatures, nSample);
        sampled = featuresMatrix(sample,:);
        logprint(sprintf('Training codebook in sample of %d features from total of %d...', nSample, nFeatures), 2);
        [ assignments, centroids ] = ...
            kmeans( sampled, CodebookSize, 'MaxIter', KmeansIterations );
        save( inoutCodebookFile, 'centroids' );
        sample = []; % for the sake of memory footprint
        sampled = [];
    end
    logprint('Assigning codebook...', 2);
    centroids = load( inoutCodebookFile );
    % Runs a single round of k-means, just to perform the assignments
    [ assignments, centroids ] = kmeans( featuresMatrix, CodebookSize, 'Start', ...
        centroids.centroids, 'MaxIter', 1 );
    featuresMatrix = []; 

    % ... pooling
    logprint('Pooling features...', 2);
    midlevel = zeros(nImages, CodebookSize, 'single');
    f = 1;
    count = 0;
    for a = 1:length(assignments)
        while count >= counts(f)
            if count == 0 
                warning('skinScan:nodescriptors', 'No descriptors extracted for %dth image, %s', ...
                    f, images(f,1) )
            end
            f = f + 1;
            count = 0;
        end
        midlevel(f, assignments(a)) = midlevel(f, assignments(a)) + 1;
        count = count + 1;
    end

    % outputs midlevel in LIBSVM-friendly format
    logprint('Outputting midlevel...', 2);
    output = fopen(outFeaturesFile, 'w');
    for f = 1:nImages
        idxs = find(midlevel(f, :) ~= 0.0);
        values = midlevel(f, idxs);
        featuresFormatted = sprintf(' %d:%f', vertcat(idxs,values));
        fprintf(output, '%d%s\n', truth(f), featuresFormatted);
    end
    fclose(output);

    logprint('Done !', 2);



function [ featuresMatrix ] = getFoldFeatures( imageFiles, imagesDir, cacheDir )    

    global skinScan_Octave skinScan_Threads skinScan_ImageSuffix;
    imageSuffix = skinScan_ImageSuffix;
  
    nImages = size(imageFiles, 1);

    imagePaths = cell(nImages, 1);
    maskPaths = cell(nImages, 1);
    featurePaths = cell(nImages, 1);
    for f = 1:nImages
        imagePaths{f}   = fullfile( imagesDir, strcat( imageFiles{f}, imageSuffix ) );
        maskPaths{f}    = fullfile( cacheDir,  strcat( imageFiles{f}, '.png' ) );
        featurePaths{f} = fullfile( cacheDir,  strcat( imageFiles{f}, '.mat' ) );
    end

    if skinScan_Threads == 1
        logprint('Processing fold (cellfun, single-thread)...', 3);        
        featuresMatrix = cellfun( @processSingleImage, ...
            imagePaths, maskPaths, featurePaths, 'UniformOutput', false );
    elseif skinScan_Octave
        logprint(sprintf('Processing fold (parcellfun, %d threads)...', skinScan_Threads), 3);        
        featuresMatrix = parcellfun(skinScan_Threads, @processSingleImage, ...
            imagePaths, maskPaths, featurePaths, 'UniformOutput', false, 'ChunksPerProc', 1 );
    else
        logprint(sprintf('Processing fold (parfor, %d threads)...', skinScan_Threads), 3);        

        % MATLAB's parfor doesn't play nice with globals, we have to read and pass them along
        % ...globals used in getImageFeatures()
        global skinScan_PatchSize skinScan_PatchSampling skinScan_HaarLevels;
        patchSize     = skinScan_PatchSize;
        patchSampling = skinScan_PatchSampling;
        haarLevels    = skinScan_HaarLevels;    
        % ...globals used in getImageMask()
        global skinScan_MedianFilterProportion skinScan_StructElementProportion;
        global skinScan_ActiveContourInitialRadius skinScan_ActiveContourIterations;
        global skinScan_ActiveContourLengthCost;
        medianProportion = skinScan_MedianFilterProportion;
        strelProportion  = skinScan_StructElementProportion;
        radiusFraction   = skinScan_ActiveContourInitialRadius;
        iterations       = skinScan_ActiveContourIterations;
        lengthCost       = skinScan_ActiveContourLengthCost;
        % ...globals used in logprint()
        global skinScan_LogLevel;
        logLevel = skinScan_LogLevel;

        % The actual parallel loop
        featuresMatrix = cell(nImages, 1);
        parfor f = 1:nImages
            featuresMatrix{f} = processSingleImage(imagePaths{f}, maskPaths{f}, featurePaths{f}, ...
                medianProportion, strelProportion, radiusFraction, iterations, lengthCost, ...
                patchSize, patchSampling, haarLevels, logLevel );
        end
    end



function [ featureVectors ] = processSingleImage( imagePath, maskPath, featurePath, ...
    medianProportion, strelProportion, radiusFraction, iterations, lengthCost, ...
    patchSize, patchSampling, haarLevels, logLevel ) 

    if nargin > 3
        % MATLAB's parfor doesn't play nice with globals, we have to read and pass them along
        % ...globals used in getImageFeatures()
        global skinScan_PatchSize skinScan_PatchSampling skinScan_HaarLevels;
        skinScan_PatchSize     = patchSize;
        skinScan_PatchSampling = patchSampling;
        skinScan_HaarLevels    = haarLevels;
        % ...globals used in getImageMask()
        global skinScan_MedianFilterProportion skinScan_StructElementProportion;
        global skinScan_ActiveContourInitialRadius skinScan_ActiveContourIterations;
        global skinScan_ActiveContourLengthCost;
        skinScan_MedianFilterProportion     = medianProportion;
        skinScan_StructElementProportion    = strelProportion;
        skinScan_ActiveContourInitialRadius = radiusFraction;
        skinScan_ActiveContourIterations    = iterations;
        skinScan_ActiveContourLengthCost    = lengthCost;
        % ...globals used in logprint()
        global skinScan_LogLevel;
        skinScan_LogLevel = logLevel;
    end

    if exist( maskPath, 'file' ) == 2
        logprint(sprintf('...mask cached, reading %s', maskPath), 3);        
        mask = imread( maskPath );
        mask = logical(mask);
        remasked = false;
    else
        logprint(sprintf('...extracting mask for %s', imagePath), 3);        
        img = imread( imagePath );
        mask = getImageMask( img );
        imwrite( mask, maskPath );
        remasked = true;
    end

    if ~remasked && exist( featurePath, 'file' ) == 2
        logprint(sprintf('...features cached, reading %s', featurePath), 3);        
        load( featurePath, '-mat', 'featureVectors' );
    else 
        logprint(sprintf('...extracting features for %s', imagePath), 3);        
        if ~remasked
            img = imread( imagePath );
        end      
        featureVectors = getImageFeatures( img, mask );
        save( featurePath, '-mat', 'featureVectors' );
    end



function [ featureVectors ] = getImageFeatures( image, mask )

    global skinScan_PatchSize skinScan_PatchSampling skinScan_HaarLevels;
    patchSize     = skinScan_PatchSize;
    patchSampling = skinScan_PatchSampling;
    haarLevels    = skinScan_HaarLevels;    

    % samples image patches and saves those inside the mask
    w = size(image, 1);
    h = size(image, 2);
    nPatches = 0;
    centers = zeros(1000, 2); % initial guess about # of patches
    half = patchSize/2.0;
    patchStart = floor(-half)+1;
    patchEnd = floor(half);
    for x = (1-patchStart):patchSampling:(w-patchEnd)
        for y = (1-patchStart):patchSampling:(h-patchEnd)
            if mask(x, y)
                nPatches = nPatches + 1;
                centers(nPatches, 1) = x;
                centers(nPatches, 2) = y;
            end
        end
    end
    centers = centers(1:nPatches, :);

    % fetches the actual patches
    patches = cell(nPatches);
    for p = 1:nPatches
        xs = centers(p, 1)+patchStart;
        xe = centers(p, 1)+patchEnd;
        ys = centers(p, 2)+patchStart;
        ye = centers(p, 2)+patchEnd;
        patches{p} = image(xs:xe, ys:ye);
    end
    
    % applies 2D multi-level Haar wavelet transform
    featureVectors = zeros(nPatches, 6*(haarLevels) + 2, 'single');

    for p = 1:nPatches;
        feature = [];
        % Extracts Haar wavelets
        haarDecomposition = haarFilter2(patches{p}, haarLevels);
        % Stores statistics on feature vector
        for h = 1:haarLevels
            LL = haarDecomposition{h, 1};
            LH = haarDecomposition{h, 2};
            HL = haarDecomposition{h, 3};
            HH = haarDecomposition{h, 4};
            v = h - 1;
            featureVectors(p, 6*v+1) = mean2(LH);
            featureVectors(p, 6*v+2) =  std2(LH);
            featureVectors(p, 6*v+3) = mean2(HL);
            featureVectors(p, 6*v+4) =  std2(HL);
            featureVectors(p, 6*v+5) = mean2(HH);
            featureVectors(p, 6*v+6) =  std2(HH);
        end
        v = haarLevels;
        featureVectors(p, 6*v+1) = mean2(LL);
        featureVectors(p, 6*v+2) =  std2(LL);
    end



function [ mask ] = getImageMask( img )

    global skinScan_MedianFilterProportion skinScan_StructElementProportion;
    global skinScan_ActiveContourInitialRadius skinScan_ActiveContourIterations;
    global skinScan_ActiveContourLengthCost;
    medianProportion = skinScan_MedianFilterProportion;
    strelProportion  = skinScan_StructElementProportion;
    radiusFraction   = skinScan_ActiveContourInitialRadius;
    iterations       = skinScan_ActiveContourIterations;
    lengthCost       = skinScan_ActiveContourLengthCost;

    % reads image and converts to grayscale
    img = rgb2gray(img);

    rows = size(img, 1);
    cols = size(img, 2);

    % Applies median filter with strength proportional to image size
    n = min(rows, cols);
    n = n * medianProportion; % makes median filter proportional to smallest image side
    n = 2*floor(n/2)+1;       % rounds to the nearest odd integer
    img = medfilt2(img, [n n]);

    % initializes active contour to filled circle with radius proportional to image size...
    radius = round( min(rows, cols) * radiusFraction );
    cr = rows/2;
    cc = cols/2;
    r  = 1:rows;
    c  = 1:cols;
    [c, r] = meshgrid(c, r);
    % ... prepares the initial mask : ones inside the circle, zeros outside
    mask = min( (r-cr).^2 + (c-cc).^2 - (radius.^2) , 0 );
    mask = logical(mask);

    % adjusts active contours from initial circular mask
    mask = chanvese(img, mask, iterations, lengthCost, 'chan');

    % morphological operations to get rid of small structures
    n = min(rows, cols);      
    n = n * strelProportion; % makes structurant element proportional to smallest image side
    n = 2*floor(n/2)+1;      % rounds to the nearest odd integer 
    se = strel('disk', n, 0); 
    % opening --- gets rid of small components
    mask = imerode(mask,  se);
    mask = imdilate(mask, se);
    % closing --- gets rid of small gaps
    mask = imdilate(mask, se);
    mask = imerode(mask,  se);

    % labels connected components
    components = bwlabel(mask);
    imageStats = regionprops(components, 'area'); 
    allAreas = [ imageStats.Area ];
    [ sortedAreas, sortIndexes ] = sort(allAreas, 'descend');
    biggestBlob = ismember(components, sortIndexes(1:1));

    % uses largest connected component as mask
    mask = biggestBlob > 0;



% Print log messages : level can be one of
% -1 - fatal
% 0 -  error
% 1 -  warning
% 2 -  info  --- This is the normal one
% 3 -  debug
% A message will be printed if it is below or equal the current LogLevel
% A level < 0 will also abort the program. If the current loglevel is below that level, a stack 
% trace will alson be printed.

function logprint( message, level )
    if nargin < 2, level = 2; end
    global skinScan_LogLevel;
    if level <= skinScan_LogLevel 
        fprintf('%s: %s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF'), message);
    end
    if level < 0
        if level <= skinScan_LogLevel 
            display(dbstack('-completenames'));
        end
        quit(1)
    end
