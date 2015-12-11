function [ mosaicImg ] = mosaic( )
    I1 = im2double(imread('../humanity/humanity01.JPG'));
    I2 = im2double(imread('../humanity/humanity02.JPG'));

    % corresponding points in both images
    points1 = [439 837 1; 763 979 1; 369 1173 1; 583 731 1; 123 1153 1; 567 833 1; 442 816 1];
    points2 = [419 215 1; 743 361 1; 357 545 1; 570 100 1 ; 127 531 1; 551 209 1; 423 192 1];

    % computing the transformation matrix
    A = ComputeWarpMapping(points1, points2);

    % warping image1
    [Iwarp, minR, minC] = WarpImage(I1, A);
    mosaicImg = Iwarp;
    
    [row, col, color] = size(I2);

    % Merging both images
    for r = 1:row
        for c = 1:col
            x = ceil(abs(r-minR));
            y = ceil(abs(c-minC));
            for channel = 1:color
                if mosaicImg(x,y,channel) ~= 0 % warped image overlaping with image2 then take average 
                    mosaicImg(x,y,channel) = (mosaicImg(x,y,channel) + I2(r,c,channel))/2;
                else
                    mosaicImg(x,y,channel) = I2(r,c,channel); % no overlap simply copy image2
                end
            end
        end
    end
end