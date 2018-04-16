
function vec = CreateYIQImageFeatureVector( rgbIm )
% Creates the features vector for the image 'rgbIm'.

    % Divide the image into 18x1 cells
    xLen = floor( size(rgbIm,1) / 18 );
%     seg=xLen*ones(18,1);
%     subIms = mat2cell( rgbIm,seg, size(rgbIm,2), 3 );
    subIms = mat2cell( rgbIm, ...
        [xLen, xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        size(rgbIm,1) - 17*xLen], ...
        size(rgbIm,2), 3 );
    
    vec = [];
    for i=1:numel(subIms)
        vec = [ vec, YIQVector(subIms{i}) ];
    end
    
   
    % Verify that there are no NaNs in the feature vector
    nans = find(isnan(vec));
    if ~isempty(nans)
        error( ['There are NaNs in the following locations:' num2str(nans)] );
    end
    
end

function yiqvec = YIQVector( rgbIm )

    yiqIm = rgb2ntsc( rgbIm );
    numPixels = numel(yiqIm(:,:,1));

    y = reshape( yiqIm(:,:,1), numPixels, 1 );
    i = reshape( yiqIm(:,:,2), numPixels, 1 );
    q = reshape( yiqIm(:,:,3), numPixels, 1 );

    yHist = hist( y, linspace(0,1,16) ); 
    iHist = hist( i, linspace(0,1,16) ); 
    qHist = hist( q, linspace(0,1,16) ); 

    % Normalization
    % It's impossible to divide by zero here because the values in all three
    % histograms are greater or equal to zero and at least one bin must be non-
    % empty (>0).
    yHist = yHist ./ sum(yHist);
    iHist = iHist ./ sum(iHist);
    qHist = qHist ./ sum(qHist);

    yiqvec = [yHist iHist qHist];

end

