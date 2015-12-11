function [ difference ] = GaussianAs1D(w,s)
% Genarates 2 1D gaussian and convolves with an image.
% Convolves 2D gaussian kernel with the same image and compares it with the
% above result. 

img = imread('hw1_images\lena.bmp');

X = 1:w;
for i = 1:w
    X(i) = exp(-((i-(w+1)/2)^2)/(2*s^2));
end
X = X/sum(X(:));
Y = X';

conv_x = conv2(double(img),double(X),'same');
img1 = conv2(double(conv_x),double(Y),'same');

gaussian_handle = @GaussianKernel;
gaussian = gaussian_handle(w,s);

img2 = conv2(double(img),double(gaussian),'same');
difference = max(max(abs(img2 - img1)));

end