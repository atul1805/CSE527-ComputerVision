fprintf('\nHere we train a Convolutional RBM on the MNIST Dataset.\n');
dataset = 'mnistSmall';


%addpath '/home/chaitu/computer_vision/project/medal'
%addpath '/home/chaitu/computer_vision/project/medal/models'
%load('mnistSmall.mat','trainData');
%trainData = reshape(trainData',28,28,10000);
%trainData = trainData(:,:,1:1);
[trainData, m,n] = loadImages;
dataSize = [m,n,1];  % [nY x nX x nChannels]

% DEFINE AN ARCHITECTURE
arch = struct('dataSize', dataSize, ...
		'nFM', 1, ...
        'filterSize', [7 7], ...
        'stride', [2 2], ...
        'inputType', 'binary');

% GLOBAL OPTIONS
arch.opts = {'nEpoch', 12, ...
			 'lRate', .000001, ...
			 'displayEvery',1, ...
			 'sparsity', .02, ...
			 'sparseGain', 5};% , ...
%  			 'visFun', @visBinaryCRBMLearning}; % UNCOMMENT TO VIEW LEARNING

% INITIALIZE AND TRAIN
cr = crbm(arch);
cr = cr.train(trainData);

% INFER HIDDEN AND POOLING LAYER EXPECTATIONS
% CONDITIONED ON SOME INPUT
i = 1;
while ~isempty(trainData)
    [cr,ep] = cr.poolGivVis(trainData(:,:,1));
    cr = cr.hidGivVis(trainData(:,:,1));

    % DISPLAY NETWORK FEATURES
    fig = figure;
    [nRows,nCols,nFM]=size(cr.W);
    W = reshape(cr.W,nRows*nCols,nFM);
    subplot(141);
    visWeights(W,1);
    title('Learned Filters');

    subplot(142);
    imagesc(trainData(:,:,1)); colormap gray; axis image; axis off
    title(sprintf('Sample Data\nPoint'));

    subplot(143);
    [nCols,nRows,k]=size(cr.eHid);
    eh = reshape(cr.eHid,nRows*nCols,k);
    visWeights(eh);
    title('Feature Maps')


    subplot(144);
    [eY,eX,k] = size(ep);
    visWeights(reshape(ep,eY*eX,k)); colormap gray
    title(sprintf('Pooling Layer\nExpectations'))
    drawnow
    print(strcat('fm\',num2str(i)),'-djpeg');
    i = i + 1;
    close(fig);
    trainData(:,:,1) = [];
end
