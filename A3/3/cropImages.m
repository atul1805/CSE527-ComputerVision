% Function to crop and resize images of caltech 101 dataset to 224*224
% Input: 
% caltechPath: path to caltech 101 dataset.
% eg:'SomePath/101_ObjectCategories'
% outPath: path to cropped dataset.
function cropImages(caltechPath, outPath)
    if ~exist(outPath,'dir')
        cmd = sprintf('mkdir %s', outPath);
        system(cmd);
    end
    category = dir(caltechPath);
    outSize = 227;
    for i = 1: length(category)
        if category(i).name(1) == '.' 
            continue
        else
            fprintf('processing %s\n', category(i).name);
            imageFile = dir(fullfile(caltechPath, category(i).name,'image*'));
            if ~exist(fullfile(outPath,category(i).name),'dir')
                cmd = sprintf('mkdir %s', fullfile(outPath,category(i).name));
                system(cmd);
            end
            for j = 1: length(imageFile)
                if imageFile(j).name(1) == '.'
                    continue
                else
                    im = imread(fullfile(caltechPath,category(i).name, imageFile(j).name));
                    [r,c,m] = size(im);  
                    if m < 3
                        im = cat(3, im,im,im);
                    end
                    t = max(r,c);
                    template = 255*ones(t,t,3,'uint8');
                    if r < c 
                        template(floor((t-r)/2)+1:floor((t-r)/2)+r,:,:) = im;
                    else
                        template(:,floor((t-c)/2)+1:floor((t-c)/2)+c,:) = im;
                    end
                    im2 = imresize(template, [outSize, outSize]);
                    if exist(fullfile(outPath,category(i).name,imageFile(j).name),'file')
                        cmd = sprintf('rm %s', fullfile(outPath,category(i).name,imageFile(j).name));
                        system(cmd);
                    end
                    imwrite(im2, fullfile(outPath,category(i).name,imageFile(j).name));  
                end
            end
        end
    end
end