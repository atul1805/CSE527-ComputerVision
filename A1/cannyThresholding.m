function [ ThresImg ] = cannyThresholding( low_thres, high_thres)
%CANNY Implements canny edge detection scheme with thresholding

% Gaussian Smoothing
img = imread('hw1_images\building.bmp');
w = 5;
s = 1; 
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
            grad(i,j) = 0;
        end
        if (grad(i,j) >= 22.5 && grad(i,j) < 67.5)
            if (img(i,j) > img(i-1,j+1) && img(i,j) > img(i+1,j-1))
                edgeDetectedImage(i,j) = img(i,j);
            end
            grad(i,j) = 45;
        end
        if ((grad(i,j) >= 67.5 && grad(i,j) <= 90) || (grad(i,j) >= -90 && grad(i,j) < -67.5))
            if (img(i,j) > img(i-1,j) && img(i,j) > img(i+1,j))
                edgeDetectedImage(i,j) = img(i,j);
            end
            if (grad(i,j) > 0)
                grad(i,j) = 90;
            else
                grad(i,j) = -90;
            end
        end
        if (grad(i,j) >= -67.5 && grad(i,j) < -22.5)
            if (img(i,j) > img(i-1,j-1) && img(i,j) > img(i+1,j+1))
                edgeDetectedImage(i,j) = img(i,j);
            end
            grad(i,j) = -45;
        end
    end
end

%HYSTERESIS_THRESHOLDING
ThresImg = zeros(m,n);
low_thres = low_thres*(max(max(edgeDetectedImage(2:m-1,2:n-1))));
high_thres = high_thres*(max(max(edgeDetectedImage(2:m-1,2:n-1))));

is_visited = zeros(m,n);
for i = 2:m-1
    for j = 2:n-1
        if (edgeDetectedImage(i,j) > high_thres)
            ThresImg(i,j) = 1;
            ThresImg = hysteresis(grad,ThresImg,edgeDetectedImage,low_thres,high_thres,i,j,is_visited);
        end
    end
end
ThresImg = ThresImg(2:m-1,2:n-1);
end

function [ ThresImg ] = hysteresis(grad,ThresImg,edgeDetectedImage,low_thres,high_thres,i,j,is_visited)
    weak = java.util.Stack();
    if (grad(i,j) == -45)
        if (edgeDetectedImage(i-1,j-1) > low_thres && edgeDetectedImage(i-1,j-1) < high_thres)
            ThresImg(i-1,j-1) = 1;
            weak.push(i-1);
            weak.push(j-1);
        end
        if (edgeDetectedImage(i+1,j+1) > low_thres && edgeDetectedImage(i+1,j+1) < high_thres)
            ThresImg(i+1,j+1) = 1;
            weak.push(i+1);
            weak.push(j+1);
        end
    end
    if (grad(i,j) == 90 || grad(i,j) == -90)
        if (edgeDetectedImage(i-1,j) > low_thres && edgeDetectedImage(i-1,j) < high_thres)
            ThresImg(i-1,j) = 1;
            weak.push(i-1);
            weak.push(j);
        end
        if (edgeDetectedImage(i+1,j) > low_thres && edgeDetectedImage(i+1,j) < high_thres)
            ThresImg(i+1,j) = 1;
            weak.push(i+1);
            weak.push(j);
        end
    end
    if (grad(i,j) == 45)
        if (edgeDetectedImage(i-1,j+1) > low_thres && edgeDetectedImage(i-1,j+1) < high_thres)
            ThresImg(i-1,j+1) = 1;
            weak.push(i-1);
            weak.push(j+1);
        end
        if (edgeDetectedImage(i+1,j-1) > low_thres && edgeDetectedImage(i+1,j-1) < high_thres)
            ThresImg(i+1,j-1) = 1;
            weak.push(i+1);
            weak.push(j-1);
        end
    end
    if (grad(i,j) == 0)
        if (edgeDetectedImage(i,j-1) > low_thres && edgeDetectedImage(i,j-1) < high_thres)
            ThresImg(i,j-1) = 1;
            weak.push(i);
            weak.push(j-1);
        end
        if (edgeDetectedImage(i,j+1) > low_thres && edgeDetectedImage(i,j+1) < high_thres)
            ThresImg(i,j+1) = 1;
            weak.push(i);
            weak.push(j+1);
        end
    end
    
    while (~weak.empty())
        y = weak.pop();
        x = weak.pop();
        if (~is_visited(x,y))
            is_visited(x,y) = 1;
            ThresImg = hysteresis(grad,ThresImg,edgeDetectedImage,low_thres,high_thres,x,y,is_visited);
        end
    end
end