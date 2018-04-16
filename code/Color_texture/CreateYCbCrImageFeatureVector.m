
function vec = CreateYCbCrImageFeatureVector( rgbIm )
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
        vec = [ vec, YCbCrVector(subIms{i}) ];
    end
    
   
    % Verify that there are no NaNs in the feature vector
    nans = find(isnan(vec));
    if ~isempty(nans)
        error( ['There are NaNs in the following locations:' num2str(nans)] );
    end
    
end

function ycbcrvec = YCbCrVector( rgbIm )

    ycbcrIm = rgb2ycbcr( rgbIm );
    numPixels = numel(ycbcrIm(:,:,1));

    yc = reshape( ycbcrIm(:,:,1), numPixels, 1 );
    bc = reshape( ycbcrIm(:,:,2), numPixels, 1 );
    r = reshape( ycbcrIm(:,:,3), numPixels, 1 );
    
    yc = double(yc) / 255; 
    bc = double(bc) / 255; 
    r = double(r) / 255; 

    ycHist = hist( yc, linspace(0,1,16) ); 
    bcHist = hist( bc, linspace(0,1,16) ); 
    rHist = hist( r, linspace(0,1,16) ); 

    % Normalization
    % It's impossible to divide by zero here because the values in all three
    % histograms are greater or equal to zero and at least one bin must be non-
    % empty (>0).
    ycHist = ycHist ./ sum(ycHist);
    bcHist = bcHist ./ sum(bcHist);
    rHist = rHist ./ sum(rHist);

    ycbcrvec = [ycHist bcHist rHist];

end

