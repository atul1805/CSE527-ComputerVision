results = load ('finalResult128.mat');
finalResult = results.finalResult;
resultSize = size(finalResult);

stats = cell(98,4);
count = 1;
for i = 1 : resultSize(1)
    for j = 1 : 98
        exSize = size(finalResult{i,1}{j,1});
        for k = 1 : exSize(1)
            tag = finalResult{i,1}{j,1}(k,3);
            predict = finalResult{i,1}{j,1}(k,1);
            actual = finalResult{i,1}{j,1}(k,2);
            flag = 0;
            for l = 1 : 98
                if stats{l,1} == tag
                    flag = 1;
                    break
                end
            end
            if flag == 0
                stats{count,1} = tag;
                if predict < 0
                    predict = 2;
                end
                if actual < 0
                    actual = 2;
                end
                cm = zeros(2,2);
                cm(actual,predict) = 1;
                stats{count,2} = cm;
                count = count + 1;
            else
                cm = stats{l,2};
                if predict < 0
                    predict = 2;
                end
                if actual < 0
                    actual = 2;
                end
                cm(actual,predict) = cm(actual,predict) + 1;
                stats{l,2} = cm;
            end
        end
    end
end

for i = 1 : 98
   cm = stats{i,2};
   accuracy = (cm(1,1) + cm(2,2))/sum(cm(:));
   precision1 = cm(1,1)/(cm(1,1) + cm(2,1));
   recall1 = cm(1,1)/(cm(1,1) + cm(1,2));
   stats{i,3} = precision1;
   stats{i,4} = recall1;
end