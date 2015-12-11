function [ Iwarp, minR, minC ] = WarpImage( I, A )
    [r,c,color] = size(I);
    
    % get the the four corners of the given image
    corners = [1 1 1;
               r 1 1;
               1 c 1;
               r c 1];
    
    % Transform the the corner points using the transformation matrix
    cornersNew = corners*A;
    
    % calculate the range of values the corner points can take after
    % transforming
    minR = min(cornersNew(:,1));
    maxR = max(cornersNew(:,1));
    minC = min(cornersNew(:,2));
    maxC = max(cornersNew(:,2));
    
    % calculate width of warped image
    if minR < 0
        warpR =  ceil(max(maxR,r) - minR);
    else
        warpR =  max(maxR,r);
    end
    
    % calculate height of warped image
    if minC < 0
        warpC =  ceil(max(maxC,c) - minC);
    else
        warpC =  ceil(maxC,c);
    end
    
    Iwarp = zeros(warpR,warpC,color);
    
    % Backwarp Mapping Algorithm
    for row = ceil(minR):ceil(maxR)
        for col = ceil(minC):ceil(maxC)
            warpPoint = [row,col,1];
            originalPoint = warpPoint*inv(A);
            if originalPoint(1) >= 1 && originalPoint(1) <= r && originalPoint(2) >= 1 && originalPoint(2) <= c
                
                % First order interpolation
                x1 = ceil(originalPoint(1));
                y1 = ceil(originalPoint(2));
                x0 = x1 - 1;
                y0 = y1 - 1;
                deltaX = originalPoint(1) - x0;
                deltaY = originalPoint(2) - y0;
                f00 = I(x0,y0,1:3);
                f01 = I(x0,y1,1:3);
                f10 = I(x1,y0,1:3);
                f11 = I(x1,y1,1:3);
                firstOrderVal = f00 + (f10-f00)*deltaX + (f01-f00)*deltaY + (f11-f10-f01+f00)*deltaX*deltaY;
                
                Iwarp(ceil(row - minR),ceil(col - minC),1:3) = firstOrderVal;
            end
        end
    end
end