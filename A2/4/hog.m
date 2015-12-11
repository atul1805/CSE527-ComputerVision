clear;
for name={'qutubminar7','qutubminar8'}

    testI = strcat(name,'.jpg');
    xx=strcat(name,'.png');
    Itest = im2single(imread(strcat('images\',testI{1})));
    contents = dir('cropped\*.png');
    k = 1;
    for i = 1:numel(contents)
        filename = contents(i).name;
        if ~strcmp(filename,xx)
            I = imread(['cropped\' filename]);
            IC = im2single(I);
            hogf = vl_hog(IC,8);
        
            %imhog = vl_hog('render', hogf) ;
            %fig = figure;
            %clf ; imagesc(imhog) ; colormap gray ;
            %print(strcat('HOG_Features\',filename),'-djpeg');
            %close(fig);
            [x,y,z] = size(hogf);
            hogF(:,k) =  reshape(hogf,[x*y*z,1]);
            k = k + 1;
        end
    end


    
    if ~strcmp('IG',name{1}(1:2))
        label = [1,1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
        lambda = 0.01;
    maxIter = 10/lambda;
    [w b info] = vl_svmtrain(hogF,label, lambda, 'MaxNumIterations', maxIter);
    width = 192;
    height = 258;
    [X,Y,Z] = size(Itest);
        min = 1;
    for i = 1:(Y-width)
        %display((100*i)/(Y-width));
        for j = 1:(X-height)
            Icrop = imcrop(Itest,[i,j,width,height]);
            hogftest = vl_hog(Icrop,8);
            [x,y,z] = size(hogftest);
            hogFtest =  reshape(hogftest,[x*y*z,1]);
            score(i,j) = w'*hogFtest + b;
            if (score(i,j) < min)
                min = score(i,j);
                zzz = [i,j,width,height];
            end
        end
    end
    else
        label = [1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
        lambda = 0.01;
    maxIter = 10/lambda;
    [w b info] = vl_svmtrain(hogF,label, lambda, 'MaxNumIterations', maxIter);
    width = 192;
    height = 258;
    [X,Y,Z] = size(Itest);
        max = -1;
    for i = 1:(Y-width)
        %display((100*i)/(Y-width));
        for j = 1:(X-height)
            Icrop = imcrop(Itest,[i,j,width,height]);
            hogftest = vl_hog(Icrop,8);
            [x,y,z] = size(hogftest);
            hogFtest =  reshape(hogftest,[x*y*z,1]);
            score(i,j) = w'*hogFtest + b;
            if (score(i,j) > max)
                max = score(i,j);
                zzz = [i,j,width,height];
            end
        end
    end
    end
    
    fig=figure;
    %imshow(imcrop(Itest,zzz));
    imshow(insertShape(Itest, 'rectangle', zzz, 'LineWidth', 5));
    print(strcat('result\',strcat(name{1},'_detected.jpg')),'-djpeg');
end