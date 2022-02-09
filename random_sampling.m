function sample = random_sampling(row_values, column_values)

sample = [];
save_ran = [];
count = 0;

while true
    ran = rand(length(row_values),1);
    if size(save_ran,2) ~= 0
        for i=1:size(save_ran,2)
            if ran ~= save_ran(i)
                sample = [sample, row_values column_values];
                save_ran = [save_ran, ran];
                count = count +1;
                if count == 3
                    return;
                end
            end
        end
    else
        sample = [sample, row_values column_values];
        save_ran = [save_ran, ran];
        count = count +1;
    end
end
        
end