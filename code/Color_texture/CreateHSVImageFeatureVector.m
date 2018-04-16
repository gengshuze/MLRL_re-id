
function vec = CreateHSVImageFeatureVector( rgbIm )
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
        vec = [ vec, HSVVector(subIms{i}) ];
    end
    
   
    % Verify that there are no NaNs in the feature vector
    nans = find(isnan(vec));
    if ~isempty(nans)
        error( ['There are NaNs in the following locations:' num2str(nans)] );
    end
    
end

function vec = HSVVector( rgbIm )

    hsvIm = rgb2hsv( rgbIm );

    numPixels = numel(hsvIm(:,:,1));

    h = reshape( hsvIm(:,:,1), numPixels, 1 );
    s = reshape( hsvIm(:,:,2), numPixels, 1 );
    v = reshape( hsvIm(:,:,3), numPixels, 1 );

    hHist = hist( h, linspace(0,1,16) ); 
    sHist = hist( s, linspace(0,1,16) ); 
    vHist = hist( v, linspace(0,1,16) ); 

    % Normalization
    % It's impossible to divide by zero here because the values in all three
    % histograms are greater or equal to zero and at least one bin must be non-
    % empty (>0).
    hHist = hHist ./ sum(hHist);
    sHist = sHist ./ sum(sHist);
    vHist = vHist ./ sum(vHist);

    vec = [hHist sHist vHist];

end

