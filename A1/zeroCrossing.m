function [edgeDetectedImage] = zeroCrossing(img_path,threshold)
%ZEROCROSSING Implements a zero crossing detector using the laplacian of
%gaussian kernel

laplacian_handle = @laplacian;
mhat_kernel = laplacian_handle();

img = conv2(double(imread(img_path)),double(mhat_kernel'),'same');
[m,n] = size(img);

threshold = threshold*max(max(img));
edgeDetectedImage = zeros(m,n);

for i = 2:m-1;
    for j = 2:n-1;
        if ( img(i,j) ~= 0)
            if ( img(i,j)*img(i,j+1) < 0 && abs(img(i,j) - img(i,j+1)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
            if ( img(i,j)*img(i,j-1) < 0 && abs(img(i,j) - img(i,j-1)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
            if ( img(i,j)*img(i+1,j) < 0 && abs(img(i,j) - img(i+1,j)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
            if ( img(i,j)*img(i-1,j) < 0 && abs(img(i,j) - img(i-1,j)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
        else
            if ( img(i,j-1)*img(i,j+1) < 0 && abs(img(i,j-1) - img(i,j+1)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
            if ( img(i-1,j)*img(i+1,j) < 0 && abs(img(i-1,j) - img(i+1,j)) > threshold )
                edgeDetectedImage(i,j) = img(i,j);
            end
        end
    end
end
end