% Loading the trained CNN
cnn = load('cifar-experiment/cifrcnn.mat');

% Loading and merging images in different batches
batch1 = load('cifar-10-batches-mat/data_batch_1.mat');
batch2 = load('cifar-10-batches-mat/data_batch_2.mat');
batch3 = load('cifar-10-batches-mat/data_batch_3.mat');
batch4 = load('cifar-10-batches-mat/data_batch_4.mat');
batch5 = load('cifar-10-batches-mat/data_batch_5.mat');
test_batch = load('cifar-10-batches-mat/test_batch.mat');
    
temp_data = [batch1.data;batch2.data;batch3.data;batch4.data;batch5.data;test_batch.data];
temp_labels = [batch1.labels;batch2.labels;batch3.labels;batch4.labels;batch5.labels;test_batch.labels];

% Iteration over all images
for i=1:60000
    % Take the average image out
    im = im2single(reshape(temp_data(i,:),32,32,3));
    im = (im - cnn.imageMean);
    res = vl_simplenn(cnn, im);
    
    % Extraction feature before the last convolution layer
    feature(i,:) = double(reshape(res(9).x,1,[]));
    
    % Creating label for each image
    label(i,1) = double(temp_labels(i,1));
    
    % Marking Training and test set
    if i <= 50000    
        set(i,1) = 1;
    else
        set(i,1) = 2;
    end
end

addpath '../liblinear-2.1/matlab';
model = train(label(set == 1),sparse(feature(set == 1)));
[predicted_labelTest] = predict(label(set == 2),sparse(feature(set == 2)),model);
[predicted_labelTrain] = predict(label(set == 1),sparse(feature(set == 1)),model);