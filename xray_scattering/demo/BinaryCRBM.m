dataSet = load('data.mat');
images = dataSet.images;
tags = dataSet.tags;
clear dataSet;

dataSize = [128,128,1];  % [nY x nX x nChannels]
imgCount = 1;
experiments = size(images);
Data = [];
expToImg = cell(1,1);
for i = 1 : experiments(1)
    experimentSize = size(images{i,1});
    expToImg{i,1} =  experimentSize(1);
    for j = 1 : experimentSize(1)
        Data(:,:,imgCount) = images{i,1}{j,2};
        images{i,1}{j,2} = [];
        tag{imgCount,1} = images{i,1}{j,3};
        imgCount = imgCount + 1;
    end
end
clear images;
disp('Data Read');

% DEFINE AN ARCHITECTURE
arch = struct('dataSize', dataSize, ...
              'nFM', 1, ...
              'filterSize', [7 7], ...
              'stride', [2 2], ...
              'inputType', 'binary');

% GLOBAL OPTIONS
arch.opts = {'nEpoch', 1, ...
             'lRate', .000001, ...
             'displayEvery',1, ...
             'sparsity', .02, ...
             'sparseGain', 5};% , ...
%            'visFun', @visBinaryCRBMLearning}; % UNCOMMENT TO VIEW LEARNING

% INITIALIZE AND TRAIN
cr = crbm(arch);
cr = cr.train(Data);
disp('CRBM Training done for data');

i = 1;
while ~isempty(Data)
    % INFER HIDDEN AND POOLING LAYER EXPECTATIONS
    % CONDITIONED ON SOME INPUT
    [cr,ep] = cr.poolGivVis(Data(:,:,1));
    cr = cr.hidGivVis(Data(:,:,1));
    [nCols,nRows,k]=size(cr.eHid);
    features(i,:) = reshape(cr.eHid,nRows*nCols*k,1);
    i = i + 1;
    Data(:,:,1) = [];
end
clear Data;
clear cr;
clear arch;
save('features.mat','features','-v7.3');
%Features = load('features.mat');
%features = Features.features;
%clear Features;
disp('Features extracted');

numTestRun = length(expToImg);
finalResult = cell(numTestRun,1);
finalResult(:) = {cell(length(tags),2)};
for testRun = 1:numTestRun
    if testRun == 1
        trainFeatures = features((expToImg{1,1} + 1):end,:);
        trainTag = tag((expToImg{1,1} + 1):end,1);
        testFeatures = features(1:expToImg{1,1},:);
        testTag = tag(1:expToImg{1,1},1);
        clear features;
        clear tag;
    else
        offset = 0;
        for k = 1 : (testRun - 2)
            offset = offset + expToImg{k,1};
        end
        trainFA = trainFeatures(1:offset,:);
        trainFB = trainFeatures((offset+expToImg{testRun,1}+1):end,:);
        trainTA = trainTag(1:offset,:);
        trainTB = trainTag((offset+expToImg{testRun,1}+1):end,:);
        testFC = testFeatures;
        testTC = testTag;
        testFeatures = trainFeatures((offset+1):(offset+expToImg{testRun,1}),:);
        testTag = trainTag((offset+1):(offset+expToImg{testRun,1}),:);
        trainFeatures = [trainFA;testFC;trainFB];
        trainTag = [trainTA;testTC;trainTB];
        clear trainFA trainFB trainTA trainTB testFC testTC;
    end
    trainSize = size(trainFeatures);
    trainImgCount = trainSize(1);
    testSize = size(testFeatures);
    testImgCount = testSize(1);
    disp('Training and Test data created');
    
    % SVM Training and Prediction
    for i = 1 : length(tags)
        trainLabel = ones(trainImgCount, 1)*-1;
        for j = 1 : trainImgCount
            if ismember(tags{i,1}, trainTag{j,1})
                trainLabel(j,1) = 1;
            end
        end
        model = train(double(trainLabel),sparse(double(trainFeatures)),'-c 10 -n 4 -s 0');
        clear trainLabel;

        testLabel = ones(testImgCount, 1)*-1;
        for j = 1 : testImgCount
            if ismember(tags{i,1}, testTag{j,1})
                testLabel(j,1) = 1;
            end
        end
        [predict_label, accuracy, prob] = predict(double(testLabel),sparse(double(testFeatures)),model,'-b 1');
        clear model;
        finalResult{testRun}{i,1} = [predict_label, testLabel, tags{i,1}*ones(testImgCount, 1), prob];
        finalResult{testRun}{i,2} = accuracy;
        clear testLabel;
    end
end
save('finalResult128.mat','finalResult','-v7.3');