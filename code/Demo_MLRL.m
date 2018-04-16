
close all; clear; clc;

feaFile1 = '../data/prid450s_color_texture.mat';  %% feature one
feaFile2 = '../data/prid450s_LOMO.mat';  %% feature two
feaFile3 = '../data/prid450s_GOG.mat'; %% feature three

numClass = 450;
numFolds = 10;
numRanks = 100;

%% load the extracted features  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(feaFile1, 'input');
load(feaFile2, 'descriptors');
load(feaFile3, 'feature_all_A');
%% %%%%%%%%%%%%%%% layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 descriptors= descriptors';
% input.data=input.data';

% galFea = descriptors(1 : numClass, :);
% probFea = descriptors(numClass + 1 : end, :);

galFea00 = descriptors(1:2:end-1, :);
probFea00 = descriptors (2:2:end,:);

input.galFeasec00 = galFea00; 
input.probFeasec00 = probFea00; 

% input.galImg = input.data(1:2:end-1, :);
% input.probImg = input.data (2:2:end,:);
%% 
galFea0 = input.Xview1';
probFea0 = input.Xview2';


galFea000 = feature_all_A(1:2:end-1, :);
probFea000 = feature_all_A (2:2:end,:);


%% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% clear descriptors

%% set the seed of the random stream. The results reported in our CVPR 2015 paper are achieved by setting seed = 0. 
seed = 0;
rng(seed);

%% evaluate
cms = zeros(numFolds, numRanks);

for nf = 1 : numFolds
    p = randperm(numClass);
    
    galFea1 = galFea0( p(1:numClass/2), : );
    probFea1 = probFea0( p(1:numClass/2), : );
    
    %% layer two
    galFea2 = galFea00( p(1:numClass/2), : );  
    probFea2 = probFea00( p(1:numClass/2), : );
    %% layer three
    galFea3 = galFea000( p(1:numClass/2), : );
    probFea3 = probFea000( p(1:numClass/2), : );
    
    t0 = tic;
    [W1, M1] = MLRL(galFea1, probFea1, (1:numClass/2)', (1:numClass/2)');
    [W2, M2] = MLRL(galFea2, probFea2, (1:numClass/2)', (1:numClass/2)');
    [W3, M3] = MLRL(galFea3, probFea3, (1:numClass/2)', (1:numClass/2)');
    
 %%
    
   
    
    clear galFea1 probFea1
    trainTime = toc(t0);
    
    galFea3 = galFea0(p(numClass/2+1 : end), : );
    probFea3 = probFea0(p(numClass/2+1 : end), : );
    
    %% %% layer two
    galFea4 = galFea00(p(numClass/2+1 : end), : );
    probFea4 = probFea00(p(numClass/2+1 : end), : );
    %% layer three
    galFea5 = galFea000(p(numClass/2+1 : end), : );
    probFea5 = probFea000(p(numClass/2+1 : end), : );
    %% image
%     input.galImg2 = input.galImg(p(numClass/2+1 : end), : );
%     input.probImg2 = input.probImg(p(numClass/2+1 : end), : );
    
%% distance computing
    t0 = tic;
    dist1 = MahDist(M1, galFea3 * W1, probFea3 * W1);
   
    matchTime = toc(t0);
    
    fprintf('Fold %d: ', nf);
    fprintf('Training time: %.3g seconds. ', trainTime);    
    fprintf('Matching time: %.3g seconds.\n', matchTime);
    
%%  multiple layers   
   [cms(nf,:),input] = M_layers( -dist1, 1 : numClass / 2, 1 : numClass / 2, numRanks,input,galFea4, probFea4,M2,W2,galFea5,probFea5,M3,W3);
           
    fprintf(' Rank1,  Rank5, Rank10, Rank15, Rank20\n');
    fprintf('%5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%\n\n', cms(nf,[1,5,10,15,20]) * 100);
end

meanCms = mean(cms);
plot(1 : numRanks, meanCms);

fprintf('The average performance:\n');
fprintf(' Rank1,  Rank5, Rank10, Rank15, Rank20\n');
fprintf('%5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%\n\n', meanCms([1,5,10,15,20]) * 100);
