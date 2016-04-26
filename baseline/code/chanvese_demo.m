function chanvese_demo( imagePath, iterations, mu, method )

    if nargin < 2, iterations = 1000; end
    if nargin < 3, mu = 0.2; end
    if nargin < 4, method = 'chan'; end

    % if using Octave, load needed packages
    if exist ('OCTAVE_VERSION', 'builtin')
        pkg load image
    end
    
    I = imread(imagePath);
    seg = chanvese(I, 'medium', iterations, mu, method, false, true);

%-- End 
