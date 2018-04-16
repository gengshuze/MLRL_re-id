
function vec = CreateRGBImageFeatureVector( rgbIm )
% Creates the features vector for the image 'rgbIm'.

    % Divide the image into 18x1 cells
    xLen = floor( size(rgbIm,1) / 18 );
    subIms = mat2cell( rgbIm, ...
        [xLen, xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        size(rgbIm,1) - 17*xLen], ...
        size(rgbIm,2), 3 );
    
    
    vec = [];
    for i=1:numel(subIms)
        vec = [ vec, RGBVector(subIms{i}) ];
    end
    
   
    % Verify that there are no NaNs in the feature vector
    nans = find(isnan(vec));
    if ~isempty(nans)
        error( ['There are NaNs in the following locations:' num2str(nans)] );
    end
    
end

function rgbvec = RGBVector( rgbIm )

    numPixels = numel(rgbIm(:,:,1));

    r = reshape( rgbIm(:,:,1), numPixels, 1 );
    g = reshape( rgbIm(:,:,2), numPixels, 1 );
    b = reshape( rgbIm(:,:,3), numPixels, 1 );
    
    r = double(r) / 255; 
    g = double(g) / 255; 
    b = double(b) / 255; 

    rHist = hist( r, linspace(0,1,16) ); 
    gHist = hist( g, linspace(0,1,16) ); 
    bHist = hist( b, linspace(0,1,16) ); 

    % Normalization
    % It's impossible to divide by zero here because the values in all three
    % histograms are greater or equal to zero and at least one bin must be non-
    % empty (>0).
    rHist = rHist ./ sum(rHist);
    gHist = gHist ./ sum(gHist);
    bHist = bHist ./ sum(bHist);

    rgbvec = [rHist gHist bHist];

end

