% 2D Haar wavelets 
%
% This code is (c) Eduardo Valle (mail@eduardovalle.com), 2016
%

% haarFilter2( signal2D, 1) => dwt2( signal2D, 'haar')
%
function [ output ] = haarFilter2( signal2D, levels )

    global haarFilter2_padarray_warning

    if nargin == 1
        levels = 1;
    end

    % Haar wavelets, low and high components
    haarLow = [ sqrt(2.0)/2.0  sqrt(2.0)/2.0 ];
    haarHi  = [ -sqrt(2.0)/2.0 sqrt(2.0)/2.0 ];

    % Convert input and wavelets to single or double precision floating point
    if isa(signal2D, 'uint8')  || isa(signal2D, 'int8') || ...
       isa(signal2D, 'uint16') || isa(signal2D, 'int16') 
        signal2D = single(signal2D);
    elseif ~(isa(signal2D, 'single') || isa(signal2D, 'double'))
        signal2D = double(signal2D);
    end
    if isa(signal2D, 'single')
        haarLow = single(haarLow);
        haarHi  = single(haarHi);
        outtype = 'single';
    else
        outtype = 'double';
    end

    % padding signal augments compatibility with MATLAB's dwt2
    lengths = size(signal2D);
    if length(lengths) > 2
        error('haarFilter2 not implemented for multi-channel images')
    end
    minimumSize  = 2^levels;
    rowsTwoPower = 2^ceil(log2(lengths(1)));
    colsTwoPower = 2^ceil(log2(lengths(2)));
    rowsPadding = rowsTwoPower - lengths(1);
    colsPadding = colsTwoPower - lengths(2);
    if (rowsPadding>0 || colsPadding>0)
        if exist('padarray')
            signal2D = padarray(signal2D, ...
                [ floor(rowsPadding/2.0), floor(colsPadding/2.0) ], 'symmetric', 'pre');
            signal2D = padarray(signal2D, ...
                [ ceil(rowsPadding/2.0),  ceil(colsPadding/2.0) ],  'symmetric', 'post');
        else
            if ~isa(haarFilter2_padarray_warning, 'logical') || haarFilter2_padarray_warning
                warning('haarFilter2:padarray', ...
                    'padarray not available : results will differ from MATLAB dwt2')
            end
        end
    end

    % filters
    output = cell(levels, 4);
    low  = signal2D;
    lengths = size(low);
    rows = lengths(1);
    cols = lengths(2);
    for level = 1:levels
        % intermediate step : filter rows
        cols = floor(cols/2);
        lowStep = zeros(rows, cols, outtype);
        hiStep  = zeros(rows, cols, outtype);
        for row = 1:rows
            [ lowStep(row,:), hiStep(row,:) ] = fastWavelet1(low(row,:), haarLow, haarHi);
        end
        % final step : filter columns
        rows = floor(rows/2);
        low    = zeros(rows, cols, outtype);
        hiCol  = zeros(rows, cols, outtype);
        hiRow  = zeros(rows, cols, outtype);
        hiDiag = zeros(rows, cols, outtype);
        for col = 1:cols
            [   low(:,col),  hiCol(:,col) ] = fastWavelet1(lowStep(:,col), haarLow, haarHi);
            [ hiRow(:,col), hiDiag(:,col) ] = fastWavelet1( hiStep(:,col), haarLow, haarHi);
        end
        % outputs components for this level
        output{level, 1} = low;
        output{level, 2} = hiCol;
        output{level, 3} = hiRow;
        output{level, 4} = hiDiag;
    end



% 1-level 1D Haar filter (provided for refernece)
% haarFilter1( signal ) => dwt( signal, 'haar' )
function [ low, hi ]= haarFilter1( signal1D )

    % Haar wavelets, low and high components
    haarLow = [ sqrt(2.0)/2.0  sqrt(2.0)/2.0 ];
    haarHi  = [ -sqrt(2.0)/2.0 sqrt(2.0)/2.0 ];

    % Convert input and wavelets to single or double precision floating point
    if isa(signal1D, 'uint8')  || isa(signal1D, 'int8') || ...
       isa(signal1D, 'uint16') || isa(signal1D, 'int16') 
        signal1D = single(signal1D);
    elseif ~(isa(signal1D, 'single') || isa(signal1D, 'double'))
        signal1D = double(signal1D);
    end
    if isa(signal1D, 'single')
        haarLow = single(haarLow);
        haarHi  = single(haarHi);
    end
    
    % if signal has odd length, extends with constant border
    if mod(length(signal1D), 2) ~= 0
        signal1D(length(signal1D)+1) = signal1D(length(signal1D));
    end

    % filters
    [ low, hi ] = fastWavelet1(signal1D, haarLow, haarHi);



function [ low, hi ]= fastWavelet1( signal1D, waveletLo, waveletHi )

    % performs the convolutions and downsamplings
    low = conv(signal1D, waveletLo, 'valid');
    low = low(1:2:length(low));
    hi  = conv(signal1D, waveletHi, 'valid');
    hi  = hi(1:2:length(hi));

