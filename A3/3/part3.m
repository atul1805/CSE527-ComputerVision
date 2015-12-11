% Loading the trained CNN
net = load('imagenet-caffe-alex.mat');
% cnn can be applied directly in vl_simplenn()
cnn = net;
for i = 1: numel(net.layers)
    if strcmp(net.layers{1,i}.type,'conv')
        cnn.layers{1,i} = rmfield(cnn.layers{1,i},'weights');
        cnn.layers{1,i}.filters = net.layers{1,i}.weights{1,1};
        cnn.layers{1,i}.biases = net.layers{1,i}.weights{1,2};
    end
end

% loop counter for each image
k = 1;

% counter for image label
l = 1;

% Calculating mean for each label
imgMean = 0;
imgCount = 0;
category = dir('croppedImages');
for i = 1: length(category)
    if category(i).name(1) == '.' 
        continue
    else
        fprintf('calculating mean %s\n', category(i).name);
        imageFile = dir(fullfile('croppedImages', category(i).name,'image*'));
        for j = 1: length(imageFile)
            if imageFile(j).name(1) == '.'
                continue
            else
                im = imread(fullfile('croppedImages',category(i).name, imageFile(j).name));
                imgMean = imgMean + mean(im(:));
                imgCount = imgCount + 1;
            end
        end
    end
end

avg = imgMean/imgCount;

category = dir('croppedImages');
for i = 1: length(category)
    if category(i).name(1) == '.' 
        continue
    else
        fprintf('processing %s\n', category(i).name);
        imageFile = dir(fullfile('croppedImages', category(i).name,'image*'));
        for j = 1: length(imageFile)
            if imageFile(j).name(1) == '.'
                continue
            else
                % obtain and preprocess an image
                im =  imread(fullfile('croppedImages',category(i).name, imageFile(j).name));
                im = im2single(im - avg);
                res = vl_simplenn(cnn, im);
                feature(k,:) = double(reshape((res(20).x),1,[]));
                
                % Extraction feature before the last convolution layer
                
                % Creating label for each image
                label(k,1) = double(l);
        
                % Marking Training and test set (3/5 of image in training
                % set and 2/5 in test set
                if j < (length(imageFile)*0.6)    
                    set(k,1) = 1;
                else
                    set(k,1) = 2;
                end
                % Increasing image counter
                k = k + 1;
            end
        end
        % increasing label counter
        l = l + 1;
    end
end

addpath '../liblinear-2.1/matlab';
model = train(label(set == 1),sparse(feature(set == 1)));
[predicted_labelTest] = predict(label(set == 2),sparse(feature(set == 2)),model);
[predicted_labelTraining] = predict(label(set == 1),sparse(feature(set == 1)),model);