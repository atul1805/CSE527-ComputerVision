% Intrinsic camera parameters
intrinsic = [1600 0 400; 0 1600 300; 0 0 1];

% identity matrix to convert intrinsic matrix to 3x4
identity = [1 0 0 0; 0 1 0 0; 0 0 1 0];

% calculating rotation matrix
rotation = makehgtform('axisrotate',[3,4,-1],pi/3);

% adding translation
rotation(3,4) = 10;

% Camera matrix added for convenience
camera = intrinsic*identity*rotation;

% cube coordinates
cube = [1 1 1 1; 1 1 -1 1; 1 -1 1 1; 1 -1 -1 1; -1 1 1 1; -1 1 -1 1; -1 -1 1 1; -1 -1 -1 1];

pixelCoordinates = camera*cube';

% making the coordinates homogeneous
for i = 1:size(pixelCoordinates,1)
    for j = 1:size(pixelCoordinates,2)
        pixelCoordinatesH(i,j) = pixelCoordinates(i,j)/pixelCoordinates(3,j);
    end
end

% Plotting cube
for i = 1:size(pixelCoordinates,2)
    line([cube(i,1)' pixelCoordinatesH(1,i)],[cube(i,2)' pixelCoordinatesH(2,i)],[zeros(1,1) pixelCoordinatesH(3,i)]);
    hold on
end

% pixel coordinates for Inf points
infintePointX = [2^100 1 1 1];
pixelCoordinateInfX = camera*infintePointX';
pixelCoordinateInfX(1,1) = pixelCoordinateInfX(1,1)/pixelCoordinateInfX(3,1);
pixelCoordinateInfX(2,1) = pixelCoordinateInfX(2,1)/pixelCoordinateInfX(3,1);
pixelCoordinateInfX(3,1) = pixelCoordinateInfX(3,1)/pixelCoordinateInfX(3,1);

infintePointY = [1 2^100 1 1];
pixelCoordinateInfY = camera*infintePointY';
pixelCoordinateInfY(1,1) = pixelCoordinateInfY(1,1)/pixelCoordinateInfY(3,1);
pixelCoordinateInfY(2,1) = pixelCoordinateInfY(2,1)/pixelCoordinateInfY(3,1);
pixelCoordinateInfY(3,1) = pixelCoordinateInfY(3,1)/pixelCoordinateInfY(3,1);

infintePointZ = [1 1 2^100 1];
pixelCoordinateInfZ = camera*infintePointZ';
pixelCoordinateInfZ(1,1) = pixelCoordinateInfZ(1,1)/pixelCoordinateInfZ(3,1);
pixelCoordinateInfZ(2,1) = pixelCoordinateInfZ(2,1)/pixelCoordinateInfZ(3,1);
pixelCoordinateInfZ(3,1) = pixelCoordinateInfZ(3,1)/pixelCoordinateInfZ(3,1);

infintePointXYZ = [2^100 2^100 2^100 1];
pixelCoordinateInfXYZ = camera*infintePointXYZ';
pixelCoordinateInfXYZ(1,1) = pixelCoordinateInfXYZ(1,1)/pixelCoordinateInfXYZ(3,1);
pixelCoordinateInfXYZ(2,1) = pixelCoordinateInfXYZ(2,1)/pixelCoordinateInfXYZ(3,1);
pixelCoordinateInfXYZ(3,1) = pixelCoordinateInfXYZ(3,1)/pixelCoordinateInfXYZ(3,1);