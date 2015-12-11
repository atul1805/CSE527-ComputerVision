function [ trainingData,m,n ] = loadImages()
    sourceDirectory = 'C:\Users\Atul\Documents\MATLAB\CV\xray_scattering\sample_image\';
    Files=dir(sourceDirectory);
    i = 1;
    trainingData = [];
    for k = 3:length(Files)
    %for k = 1:3
        FileName=Files(k).name;
        if ~strcmp(FileName,'.') && ~strcmp(FileName,'..');
            image =  im2double(imread(strcat(sourceDirectory,FileName)));
            [m,n] = size(image);
            image = imresize(image,128/m);
            [m,n] = size(image);
            image = (image - mean(image(:)));
            trainingData = cat(3, trainingData, image);
            i = i + 1;
        end
    end
    trainingData = im2double(trainingData);
end