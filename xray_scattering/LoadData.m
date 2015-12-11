function [ ] = LoadData()
    dataPath = '/media/atul/OS/Users/Atul/Documents/MATLAB/CV/dataset/data';
    tagPath = '/media/atul/OS/Users/Atul/Documents/MATLAB/CV/dataset/tags';
    
    %dataPath = '/home/chaitanya/dataset/data';
    %tagPath = '/home/chaitanya/dataset/tags';
    
    images = cell(13,1);
    tags = cell(1,2);
    expCount = 1;
    tagCount = 1;
    tagFreq = zeros(1000,1);
    
    level1Data = dir(dataPath);  
    for i = 3 : numel(level1Data)
        level2Data = dir([dataPath,'/',level1Data(i).name]);
        if level2Data(3).isdir() == 0
            [images, tags, tagCount, tagFreq] = readDir([dataPath,'/', level1Data(i).name], images, expCount, [tagPath,'/',level1Data(i).name], tags, tagCount, tagFreq);
            expCount = expCount + 1;
        else
            for j = 3 : numel(level2Data)
                [images, tags, tagCount, tagFreq] = readDir([dataPath, '/',level1Data(i).name, '/', level2Data(j).name], images, expCount, [tagPath,'/',level1Data(i).name, '/', level2Data(j).name], tags, tagCount, tagFreq);
                expCount = expCount + 1;
            end
        end
    end
    
    j = 1;
    for i = 1 : length(tagFreq)
        if tagFreq(i) < 10 && i ~= 201 && i ~= 202 &&i ~= 203 && i ~= 204 && i ~= 205 && i ~= 206
            removeTag(j) = i;
            j = j + 1;
        end
    end
    
    i = 1;
    while i <= length(tags)
        if any(ismember(removeTag, tags{i,1}))
            tags(i,:) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    
    tags(end+1:end+6, :) = {201 'Diffuse high-q'; 202 'Diffuse low-q'; 203 'Halo'; 204 'Higher orders'; 205 'Peaks'; 206 'Ring'};
    tags = sortrows(tags, 1);
    
	for i = 1 : length(images)
        j = 1;
        while j <= length(images{i})
            if isempty(images{i}{j,3})
                images{i}(j,:) = [];
                j = j - 1;
            else
                k = 1;
                while k <= numel(images{i}{j,3})
                    if any(ismember(removeTag,images{i}{j,3}(k)))
                        images{i}{j,3}(k) = [];
                        k = k - 1;
                    end
                    k = k + 1;
                end
            end
            j = j + 1;
        end
    end
    save('data.mat','images','tags','-v7.3')
end


function [ images, tags, tagCount, tagFreq ] = readDir( pathImages, images, expCount, pathTag, tags, tagCount, tagFreq)
    contents = dir(pathImages);
    imageCount = 1;
    
    for i = 3 : numel(contents)
        if isempty(strfind(contents(i).name, '.~'))
            images{expCount}{imageCount,1} = contents(i).name;
            image =  im2double(imread([pathImages, '/', contents(i).name]));
            [m,n] = size(image);
            image = imresize(image,128/m);
            image = (image - mean(image(:)));
            images{expCount}{imageCount,2} = image;
            clear image;
            imageCount = imageCount + 1;
        end
    end
    
    contents = dir(pathTag);
    
    for i = 3 : numel(contents)
        if ~isempty(strfind(contents(i).name, '.tag'))
            tagFileName = contents(i).name(1 : length(contents(i).name) - 4);
            for l = 1 : length(images{expCount})
                if strcmp(images{expCount}(l), tagFileName)
                    break;
                end
            end
            
            tagContent = fileread([pathTag, '/', contents(i).name]);
            tagIdStart = strfind(tagContent, '<tag id="');
            tagIdEnd = strfind(tagContent, '</tag>');
            
            tagArray = zeros(1,length(tagIdStart));
            for j = 1 : length(tagIdStart)
               tagLine = tagContent(tagIdStart(j) : tagIdEnd(j) + 1);
               countEnd = strfind(tagLine, '">') - 1;
               nameEnd = strfind(tagLine, '</') - 1;
               tagNum = str2double(tagLine(10 : countEnd));
               tagFreq(tagNum,1) = tagFreq(tagNum,1) + 1;
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
            images{expCount}{l,3} = tagArray;
        end
    end
end
