function lesionseg_demo( imagePath, iterations, mu, method )

    if nargin < 2, iterations = 2000; end
    if nargin < 3, mu = 0.02; end
    if nargin < 4, method = 'chan'; end

    % if using Octave, load needed packages
    if exist ('OCTAVE_VERSION', 'builtin')
        pkg load image;
    end
    
    % reads image and converts to grayscale
    img = imread(imagePath);
    img = rgb2gray(img);

    rows = size(img, 1);
    cols = size(img, 2);

    % Applies median filter with strength proportional to image size
    global lesionseg_structure_size;
    n = min(rows, cols); 	% size of smallest of width and height
    n = n / 256.0 * 5.0;    % the original paper uses a 5x5 filter for a 256x256 image
    n = 2*floor(n/2)+1;     % rounds to the nearest odd integer
    img = medfilt2(img, [n n]);
    lesionseg_structure_size = n;


    % initializes active contour to filled circle with radius proportional to image size...
    radiusFraction = 0.25;
    radius = round( min(rows, cols) * radiusFraction );
    cr = rows/2;
    cc = cols/2;
    r  = 1:rows;
    c  = 1:cols;
    [c, r] = meshgrid(c, r);
    % ... prepares the initial mask : ones inside the circle, zeros outside
    mask = min( (r-cr).^2 + (c-cc).^2 - (radius.^2) , 0 );
    mask = logical(mask);
    % % ... prepares the initial mask : ones inside the rectangle, zeros outside
    % mask = (floor(rows/10.0) < r & r < floor(rows/10.0*9.0)) &  (floor(cols/10.0) < c & c < floor(cols/10.0*9.0));
    % mask = logical(mask);


    % adjusts active contours from initial circular mask
    global chanvese_showphi_callback
    chanvese_showphi_callback = @showphi_callback;
    mask1 = chanvese(img, mask, iterations, mu, method, false, true);

	% shows final segmentation
	showmask(mask1);



function showphi_callback(I, phi, i)
	if mod(i,100) == 0
		mask1 = phi(:,:,1)<=0; %-- Get mask from levelset
		showmask(mask1);
	end



function showmask( mask1 )
    global lesionseg_structure_size;
    n = lesionseg_structure_size;

    % morphological operations to get rid of small components 
    se = strel('disk', n, 0);
    mask2 = mask1;
    % opening --- get rid of small components
    mask2 = imerode(mask2,  se);
    mask2 = imdilate(mask2, se);
    % closing --- get rid of small gaps
    mask2 = imdilate(mask2, se);
    mask2 = imerode(mask2,  se);

    % labels connected components
    components = bwlabel(mask2);
    imageStats = regionprops(components, 'area'); 
    allAreas = [ imageStats.Area ];
    [ sortedAreas, sortIndexes ] = sort(allAreas, 'descend');
    biggestBlob = ismember(components, sortIndexes(1:1));

    % uses largest connected component as mask
    mask3 = biggestBlob > 0;

	% mask to show
	mask1 = max(mask1, mask3); 
	mask2 = max(mask2, mask3); 
	mask4 = single(cat(3, mask1, mask2, mask3)); % R G B
	imshow(mask4, 'displayrange',[0 1.0]);
	title('Final Segmentation');
