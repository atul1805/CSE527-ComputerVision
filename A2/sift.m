%phoneM=im2double(uint8(pgmRead('..\..\3\phone\phone001.pgm')));
%[ pos1, scale1, orient1, desc1 ] = SIFT(phoneM,4,2,ones(size(phoneM)),0.02,10,2);
%nutshellM=im2double(uint8(pgmRead('..\..\3\nutshell\nutshell001.pgm')));
%[ pos2, scale2, orient2, desc2 ] = SIFT(nutshellM,4,2,ones(size(nutshellM)),0.02,10,2);
%database = add_descriptors_to_database( phoneM, pos1, scale1, orient1, desc1);
%database = add_descriptors_to_database( nutshellM, pos2, scale2, orient2, desc2,database);

contents = dir('..\..\3\phone\*.pgm');
for i = 1:numel(contents)
     filename = contents(i).name;
     if ~strcmp(filename,'phone001.pgm')
         phone = im2double(imread(['..\..\3\phone\' filename]));
         [ pos, scale, orient, desc ] = SIFT(phone,4,2,ones(size(phone)),0.02,10,2);
         [IM_IDX, TRANS, THETA, RHO, DESC_IDX, NN_IDX, WGHT] = hough( database,pos,scale,orient,desc,1.5,0);
            
         [mx,idx] = max(WGHT);
         A = fit_robust_affine_transform(pos(DESC_IDX{idx},:)',pos1(NN_IDX{idx},:)')
         I = imWarpAffine(phoneM,A,1);
         original = figure;
         imshow(phone);
         aligned = figure;
         imshow(I);
         pause;
         close(original,aligned);
     end
end