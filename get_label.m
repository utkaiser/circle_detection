function [label, label_matrix] = get_label(labelIm, ind_1, ind_2, label_matrix)
% returns a specific label for itersections of different labels

diff = abs(labelIm(ind_1) - labelIm(ind_2));
sum = labelIm(ind_1) + labelIm(ind_2);

[row_size, ~] = size(label_matrix);

counter = 0;
for i=1:row_size
    if label_matrix(i,1) == diff && label_matrix(i,2) == sum
        label = i;
        counter = counter + 1;
        break
    end  
end

if counter == 0
    label_matrix = [label_matrix; diff, sum];
    [label, ~] = size(label_matrix);
end

end



