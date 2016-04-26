% Tests Haar wavelets implementation in contrast to MATLAB reference implementation

function [ ] = testHaar( imageFile )

    if exist('OCTAVE_VERSION','builtin')
        pkg load image;
    end
    img = single(imread( imageFile ));
    if exist('rgb2gray')
        img = rgb2gray(img);
    else
        img = mean(img, 3);
    end
    f1 = features(haarFilter2( img, 3 ))
    if exist('dwt2')
        f2 = features(haarFilter2matlab( img, 3 ))
        sqrt(sum((f1-f2).*(f1-f2)))
    else
        warning('MATLAB dwt2 not present for comparison')
    end



function [ feat ] = features ( haarDecomposition )
    haarLevels = size(haarDecomposition, 1);
    feat = zeros(1, haarLevels*6 + 2);
    for h = 1:haarLevels
        % Extracts Haar wavelets from last levels' low band
        LL = haarDecomposition{h, 1};
        LH = haarDecomposition{h, 2};
        HL = haarDecomposition{h, 3};
        HH = haarDecomposition{h, 4};
        % Stores statistics on feature vector
        v = h - 1;
        feat(6*v+1) = mean(mean(LH));
        feat(6*v+2) =  mean(std(LH));
        feat(6*v+3) = mean(mean(HL));
        feat(6*v+4) =  mean(std(HL));
        feat(6*v+5) = mean(mean(HH));
        feat(6*v+6) =  mean(std(HH));
    end
    v = haarLevels;
    feat(6*v+1) = mean(mean(LL));
    feat(6*v+2) =  mean(std(LL));



% reference implementation using MATLAB's dwt2
function [ output ] = haarFilter2matlab( signal2D, levels )

    % if levels were not informed, assumes 1
    if nargin == 1
        levels = 1;
    end
        
    % filters
    output = cell(levels, 4);
    low  = signal2D;
    for level = 1:levels
        [ low, hiCol, hiRow, hiDiag ] = dwt2(low, 'haar');
        output{level, 1} = low;
        output{level, 2} = hiCol;
        output{level, 3} = hiRow;
        output{level, 4} = hiDiag;
    end


