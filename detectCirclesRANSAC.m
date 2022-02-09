function [centers] = detectCirclesRANSAC(im, radius)

%image preprocessing
data = edge(imgaussfilt(rgb2gray(im),3), 'Canny', [0.04, 0.09]);
[row_values, column_values] = find(data);

%useful variables
edge__value_size = length(column_values) - 1;
threshold_multiple = 30;
threshold_inliers = radius*5.7;
upper_bound_norm = 1.09;
lower_bound_norm = 0.94;

y_vector = zeros(20,1);
y_vector2 = zeros(20,1);
best_model_value = 0;
best_centers = 0;

%iterations to determine the best fitting model
for c2=1:20
    sum_inliers = 0;
    centers = zeros(0,2);
    counter = 1;
    
    %iterations to determine a fitting model
    while counter<=40000
        l2_norm = 0;
        while  l2_norm>2.6*radius || l2_norm<1.4*radius

            %determine random values
            rand_value_1 = edge__value_size*rand();
            rand_value_2 = edge__value_size*rand();
            %determine random sets on edge
            set_a = [row_values(round(rand_value_1)+1), column_values(round(rand_value_1)+1)];
            set_b = [row_values(round(rand_value_2)+1), column_values(round(rand_value_2)+1)];
            %calculate l2 norm of these sets
            l2_norm = sqrt((set_a(1)-set_b(1))^2+(set_a(2)-set_b(2))^2);

        end

        %return center points
        out = (set_a(:) + set_b(:)).'/2;

        %loop to determine the number of inliers
        num_in = 0;
        for iter=1:length(column_values)
            l2_norm = sqrt((column_values(iter)-out(2))^2+(row_values(iter)-out(1))^2);

            if(l2_norm<radius*upper_bound_norm && l2_norm>radius*lower_bound_norm)
                num_in = num_in+1;
            end  
        end
        %add center xy point if num_in above threshold_inliers
        if(num_in>threshold_inliers)
            if ~exist('centers', 'var')
                centers = zeros(0,2);
            else
                centers = [centers; out(2), out(1)];
            end
        end
        sum_inliers = sum_inliers + num_in;
        counter = counter + 1;
    end
    
%save the best model in case
if sum_inliers>best_model_value
    best_model_value = sum_inliers;
    best_centers = centers;
end
y_vector(c2) = sum_inliers;
y_vector2(c2) = best_model_value;
end

centers = best_centers;

%delete duplicates
iter = 1;
%first sort by row to get row duplicates
centers = sortrows(centers);
[row_dim, ~] = size(centers);
for index=1:row_dim-1
    if iter==row_dim
        break
    end
    if (abs(centers(iter,1)-centers(iter+1,1))+abs(centers(iter,2)-centers(iter+1,2)))< threshold_multiple
        centers(iter+1,:) = [];
        iter = iter - 1;
        row_dim = row_dim - 1;
    end
    iter = iter + 1;
end

%second sort by column to get column duplicates
centers = sortrows(centers,2);
iter = 1;
[row_dim, ~] = size(centers);
for index=1:row_dim-1
    if iter==row_dim
        break
    end
    if (abs(centers(iter,1)-centers(iter+1,1))+abs(centers(iter,2)-centers(iter+1,2)))< threshold_multiple
        centers(iter+1,:) = [];
        iter = iter - 1;
        row_dim = row_dim - 1;
    end
    iter = iter + 1;
end
[row_dim, column_dim] = size(centers);
%[wrong_pixels,~] = ind2sub([row_dim column_dim],find(centers == 0));
%centers(wrong_pixels,:) = [];
%draw_circle(im,radius,flip(centers,2));

%display progress
figure;
plot([1:20],y_vector);
hold on
plot([1:20],y_vector2);


end



