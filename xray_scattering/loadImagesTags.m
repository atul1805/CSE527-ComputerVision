function [ images,tags,m,n ] = loadImagesTags()

    images = cell(2,1);
    tags = cell(1,2);
    %imageDir = 'C:\Users\Atul\Documents\MATLAB\CV\xray_scattering\sample_image\';
    imageDir = '/media/atul/OS/Users/Atul/Documents/MATLAB/CV/xray_scattering/sample_image';
    Files=dir(imageDir);
    i = 1;
    j = 1;
    for k=3:length(Files)
        FileName=Files(k).name;
        image =  im2double(imread([imageDir, '/', FileName]));
        [m,n] = size(image);
        image = imresize(image,1024/m);
        image = (image - mean(image(:)));% / std(image(:));
        [m,n] = size(image);
        if k > 0.75*length(Files)
            images{1}{i,1} = FileName;
            images{1}{i,2} = image;
            i = i + 1;
        else
            images{2}{j,1} = FileName;
            images{2}{j,2} = reshape(image,m,n,1);
            j = j + 1;
        end
    end
    %tagDir = 'C:\Users\Atul\Documents\MATLAB\CV\xray_scattering\sample_tag';
    tagDir = '/media/atul/OS/Users/Atul/Documents/MATLAB/CV/xray_scattering/sample_tag';
    Files=dir(tagDir);
    i = 1;
    p = 1;
    tagCount = 1;
    for k=3:length(Files)
        FileName=Files(k).name;
        tagContent = fileread([tagDir, '/', FileName]);
        tagIdStart = strfind(tagContent, '<tag id="');
        tagIdEnd = strfind(tagContent, '</tag>');
        tagArray = zeros(1,length(tagIdStart));
        for j = 1 : length(tagIdStart)
            tagLine = tagContent(tagIdStart(j) : tagIdEnd(j) + 1);
            countEnd = strfind(tagLine, '">') - 1;
            nameEnd = strfind(tagLine, '</') - 1;
            tagNum = str2double(tagLine(10 : countEnd));
            tagArray(j) = tagNum;
            tagName = tagLine(countEnd + 3: nameEnd);
               
            if isempty(find([tags{:, 1}] == tagNum, 1))
                tags{tagCount, 1} = tagNum;
                tags{tagCount, 2} = tagName;
                tagCount = tagCount + 1;
            end
        end
        if any(ismember([40 52 56 64], tagArray))
            tagArray(end + 1) = 201;
        end
        if any(ismember([39 47 51 55 59 63], tagArray))
            tagArray(end + 1) = 202;
        end
        if any(ismember([41 49 53 57 65], tagArray))
            tagArray(end + 1) = 203;
        end
        if any(ismember(85:89, tagArray))
            tagArray(end + 1) = 204;
        end
        if any(ismember(67:73, tagArray))
            tagArray(end + 1) = 205;
        end
        if any(ismember([42 46 50 54 58 62 66], tagArray))
            tagArray(end + 1) = 206;
        end
        
        if k > 0.75*length(Files)
            images{1}{i,3} = tagArray;
            i = i + 1;
        else
            images{2}{p,3} = tagArray;
            p = p + 1;
        end
    end
end