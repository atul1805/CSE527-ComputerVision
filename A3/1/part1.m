function [ y,y_relu,y_relu_pool ] = part1( file,stride,pad,pool )
    % Accepts argument filename, stride, padding and pooling value
    % Reading image
    I = im2single(imread(file));
    [W,H,D] = size(I);
    
    % Creating 2 sobel filters one in x and other in y direction
    sobel_x = [-1,0,1;-2,0,2;-1,0,1];
    sobel_y = sobel_x';

    % Creating 1x1xD (where D = num of channels in the image) dimensional matrices out of filters
    w1 = single(repmat(sobel_x, [1,1,D]));
    w2  = single(repmat(sobel_y, [1,1,D]));
    w = cat(4,w1,w2);

    % Creating bias
    b = single([]);
    
    % Applying nn_conv
    y = vl_nnconv(I,w,b,'stride',stride,'pad',pad);
    figure(1);
    colormap gray;
    vl_imarraysc(y);
    
    % Applying relu
    y_relu = vl_nnrelu(y);
    figure(2);
    colormap gray;
    vl_imarraysc(y_relu);
    
    % Applying pooling
    y_relu_pool = vl_nnpool(y_relu,pool);
    figure(3);
    colormap gray;
    vl_imarraysc(y_relu_pool);
end