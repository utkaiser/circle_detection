function [centers] = detectCirclesHT(im, radius)
% performs Hough Transform to a given image with a fixed radius
% returns the centers of any detected circles of about that size (dont exploit gradient direction, but the magnitude)
% input: image im and fixed radius
% output: N x 2 matrix in which each row lists the x,y position of a detected circle’s center

im_color = imread('data/coins.jpg');
radius = 27;
%useful variables
im = rgb2gray(im_color);
%im = imgaussfilt(im,3);
canny_settings_sol1 = [0.04, 0.09];
data = edge(im,'Canny',canny_settings_sol1); %optimize later 
[row_size, column_size] = size(data);
threshold_voting = 360*0.415;
threshold_multiple = 40;
[row_values, column_values]= find(data);
bin_size = 3;

%%%%%%%%%% solution1 %%%%%%%%%%%
rows = row_size+2*radius;
columns = column_size+2*radius;
space=zeros(rows,columns);


%main algorithm: voting
for index=1:size(row_values)
    %for every gradient direction
    for th=0:359
        bogenmass = th*pi/180;
        a = radius + row_values(index) + round(radius*cos(bogenmass));
        b = radius + column_values(index) - round(radius*sin(bogenmass));
        space(a,b) = space(a,b) + 1;
    end
end

%threshold voting
space_threshold=space(radius+1:rows-radius, radius+1:columns-radius);
space_threshold(space_threshold<threshold_voting)=0;
space_threshold(space_threshold>threshold_voting)=1;
[row_values, column_values]= find(space_threshold);
centers=[row_values column_values];

[row_dim, ~] = size(centers);

%delete duplicates, similar to bins, but gives local maxima in circles
j = 1;
centers = sortrows(centers,1);
for index=1:row_dim-1
    if j==row_dim
        break
    end
    if (abs(centers(j,1)-centers(j+1,1))+abs(centers(j,2)-centers(j+1,2)))< threshold_multiple
        centers(j+1,:) = [];
        j = j - 1;
        row_dim = row_dim - 1;
    end
    j = j + 1;
end
j = 1;
centers = sortrows(centers,2);
for index=1:row_dim-1
    if j==row_dim
        break
    end
    if (abs(centers(j,1)-centers(j+1,1))+abs(centers(j,2)-centers(j+1,2)))< threshold_multiple
        centers(j+1,:) = [];
        j = j - 1;
        row_dim = row_dim - 1;
    end
    j = j + 1;
end
  
% draw_circle(im_color,radius, centers);


%%%%%%%%%% solution2 %%%%%%%%%%%
% % implementation with bins
% space=zeros(row_size,column_size);
% result = space;
% 
% for iter = 1:size(row_values)
%     for th=0:359
%         bogenmass = th*pi/180;
%         a = column_values(iter) + radius * round(cos(bogenmass));
%         b = row_values(iter) + radius * round(sin(bogenmass));
%         if a > 0  && b > 0 && a < column_size+1 && b < row_size+1
%             space(b, a) = space(b, a) + 1;
%         end
%     end
% end
% 
% iter_r = row_size;
% iter_c = column_size;
% while iter_r > 0
%     while iter_c > 0
%         summe = 0;
%         if iter_r+bin_size - 1 > row_size
%             limit_row = row_size;
%         else
%             limit_row = iter_r+bin_size - 1;
%         end
%         if iter_c+bin_size - 1 > column_size
%             limit_column = column_size;
%         else
%             limit_column = iter_c+bin_size - 1;
%         end
%         bin_matrix = space(iter_r:limit_row, iter_c:limit_column);
%         [index1, index2] = min(-(bin_matrix(:)));
%         [row_index, column_index] = ind2sub(size(bin_matrix), index2);
%         
%         for i=1:length(bin_matrix)
%             summe = summe + bin_matrix(i);
%         end
%         
%         [dim_a, dim_b] = size(bin_matrix);
%         bin_matrix = zeros(dim_a, dim_b);
%         bin_matrix(row_index, column_index) = summe;
%         result(iter_r:limit_row, iter_c:limit_column) = bin_matrix;
%         iter_c = iter_c - bin_size;
%     end
%     iter_c = column_size;
%     iter_r = iter_r - bin_size;
% end
% 
% threshold_voting = 360*0.8;
% result(result<threshold_voting)=0; %thresholding
% %maybe add this for better thresholding, and dont do thresholding like above
% [row_values, column_values] = find(result > int32(max(result(:)) * 0.8));
% [row_values, column_values] = find(result);
% centers = [column_values, row_values];
% 
% draw_circle(im_color,radius,flip(centers,2));

end
