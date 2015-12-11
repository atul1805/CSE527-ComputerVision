function [ kernel ] = GaussianKernel( w, s)
%GAUSSIANKERNEL Returns 2D array containing a gaussian kernel with width
%w and variance s

kernel = zeros(w,w);
for i = 1:w
    for j = 1:w
        k = (i-(w+1)/2)^2 + (j-(w+1)/2)^2;
        kernel(i,j) = exp(-k/(2*s*s));
    end
end

kernel = kernel/sum(kernel(:));