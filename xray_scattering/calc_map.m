function [] = extract_prob()

results = load('finalResult128.mat');
result = results.finalResult;

[result_m result_n] = size(result);


ap = zeros(13, 98);
for i = 1:result_m
    tags = result{i,1};
    [tags_m tags_n] = size(tags);
    for j = 1:tags_m
        cell2 = tags{1,1};
        [cell2_m cell2_n] = size(cell2);
        prob1 = cell2(:,4);
        prob2 = cell2(:,5);
        predicted_prob_one = prob2;  %%randomly assigning
        predicted_prob = cell2(:,1);
        gt = cell2(:,2);
        for k = 1:cell2_m
            if prob1(k) > prob2(k) && predicted_prob(k) == 1
                predicted_prob_one = prob1; %% probability values predicting one
                break;
            elseif prob1(k) > prob2(k) && predicted_prob(k) == -1
                predicted_prob_one = prob2; %% probability values predicting one
                break;
            end
        end
        avg_prec = ml_ap(predicted_prob_one, gt, 0);
        ap(i, j) = avg_prec;
     end
end

ap = ap';
mAP = mean(nanmean(ap, 2))
end
