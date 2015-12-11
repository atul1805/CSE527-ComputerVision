function [ edgeDetectedImage ] = cannyNonMax(img_path)
%CANNY Implements canny edge detection scheme with Non Max suppression

% Gaussian Smoothing
img = imread(img_path);
w=5;s=1; 
gaussian_handle = @GaussianKernel;
gaussian = gaussian_handle(w,s);
img = conv2(double(img),double(gaussian),'same');

% Sobel Detector
Dx = [-1 0 1 ; -2 0 2 ; -1 0 1];
Dy = [-1 -2 -1 ; 0 0 0 ; 1 2 1];

output_x = conv2(double(img),double(Dx),'same');
output_y = conv2(double(img),double(Dy),'same');

img = sqrt(output_x.^2 + output_y.^2);
grad =  atand(output_y./output_x);

% NONMAX_SUPPRESSION
[m,n] = size(img);
edgeDetectedImage = zeros(m,n);

for i = 2:m-1
    for j = 2:n-1
        if (grad(i,j) >= -22.5 && grad(i,j) < 22.5)
            if (img(i,j) > img(i,j-1) && img(i,j) > img(i,j+1))
                edgeDetectedImage(i,j) = img(i,j);
            end
        end
        if (grad(i,j) >= 22.5 && grad(i,j) < 67.5)
            if (img(i,j) > img(i-1,j+1) && img(i,j) > img(i+1,j-1))
                edgeDetectedImage(i,j) = img(i,j);
            end
        end
        if ((grad(i,j) >= 67.5 && grad(i,j) <= 90) || (grad(i,j) >= -90 && grad(i,j) < -67.5))
            if (img(i,j) > img(i-1,j) && img(i,j) > img(i+1,j))
                edgeDetectedImage(i,j) = img(i,j);
            end
        end
        if (grad(i,j) >= -67.5 && grad(i,j) < -22.5)
            if (img(i,j) > img(i-1,j-1) && img(i,j) > img(i+1,j+1))
                edgeDetectedImage(i,j) = img(i,j);
            end
        end
    end
end
edgeDetectedImage = uint8(edgeDetectedImage(2:m-1,2:n-1));
end