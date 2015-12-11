function [] = part2(varargin)

    % Load the image dataset
    prepareDatahandler = @prepareData;
    imdb = prepareDatahandler();
    
    % Number of filters in various convolution layers
    m1=20;
    m2=50;
    m3=500;
    
    % Creating a Convolutional Neural Network
    net = initializeCNN(m1,m2,m3);
    
    % Take the average image out
    imageMean = mean(imdb.images.data(:));
    imdb.images.data = imdb.images.data - imageMean;
    
    % Call training function in MatConvNet
    [net,info] = cnn_train(net, imdb, @getBatch,varargin{:});
    
    % Save the result for later use
    net.layers(end) = [] ;
    net.imageMean = imageMean ;
    save('cifar-experiment/cifrcnn.mat', '-struct', 'net');
    
    % visualize the learned filters
    figure(2) ; clf ; colormap gray ;
    vl_imarraysc(squeeze(net.layers{1}.filters),'spacing',2)
    axis equal ;
    title('filters in the first layer') ;
end

function [im, labels] = getBatch(imdb, batch)
    im = imdb.images.data(:,:,:,batch) ;
    im = 256 * reshape(im, 32, 32, 3, []) ;
    labels = imdb.images.label(1,batch) ;
end

% Function to combine all the bacthes into one dataset
function [imdb] = prepareData()
    batch1 = load('cifar-10-batches-mat/data_batch_1.mat');
    batch2 = load('cifar-10-batches-mat/data_batch_2.mat');
    batch3 = load('cifar-10-batches-mat/data_batch_3.mat');
    batch4 = load('cifar-10-batches-mat/data_batch_4.mat');
    batch5 = load('cifar-10-batches-mat/data_batch_5.mat');
    test_batch = load('cifar-10-batches-mat/test_batch.mat');
    temp_data = [batch1.data;batch2.data;batch3.data;batch4.data;batch5.data;test_batch.data];
    temp_labels = [batch1.labels;batch2.labels;batch3.labels;batch4.labels;batch5.labels;test_batch.labels];
    for i=1:60000
        imdb.images.data(:,:,:,i) = im2single(reshape(temp_data(i,:),32,32,3,[]));
        imdb.images.label(1,i) = double(temp_labels(i,1));
        imdb.images.id(1,i) = i;
        if i <= 50000
            imdb.images.set(1,i) = 1;
        else
            imdb.images.set(1,i) = 2;
        end
    end
end