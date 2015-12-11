function [mhat_kernel] = laplacian()
%LAPLACIAN convolves 11x11 gaussian with sigma 1 with a discrete laplacian
%kernel

gaussian_handle = @GaussianKernel;
gaussian = gaussian_handle(11,1);

laplacian = [0 1 0; 1 -4 1; 0 1 0];

mhat_kernel = conv2(gaussian,laplacian,'same');
end

