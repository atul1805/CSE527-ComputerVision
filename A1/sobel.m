function [ output ] = sobel( threshold )
%SOBEL Applies soble edge detection to a given image

img = imread('hw1_images\building.bmp');
sobel_x = [-1 0 1 ; -2 0 2 ; -1 0 1];
sobel_y = [-1 -2 -1 ; 0 0 0 ; 1 2 1];

output_x = conv2(double(img),double(sobel_x),'same');
output_y = conv2(double(img),double(sobel_y),'same');

output = sqrt(output_x.^2 + output_y.^2);
threshold = threshold*max(max(output));
belowThreshold = output < threshold;
output(belowThreshold) = 0;
end