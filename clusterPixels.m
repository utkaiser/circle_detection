function [labelIm] = clusterPixels(Im, k)
% Given an h x w x 3 matrix ‘Im‘, where h and w are the height and width of the image, 
% this applies k-means to cluster associated pixels.

%useful variables
avg = zeros(k,3);
dummya = 255 * rand(1,k); dummyb = 255 * rand(1,k); dummyc = 255 * rand(1,k);
for counter=1:k
    avg(counter,:) = [dummya(counter),dummyb(counter),dummyc(counter)];
end

[row_size, column_size, ~] = size(Im);
d_image = double(Im);
r_arr = []; g_arr = []; b_arr = [];
for counter=1:column_size
    r_arr = [r_arr; d_image(:,counter,1)]; g_arr = [g_arr; d_image(:,counter,2)]; b_arr = [b_arr; d_image(:,counter,3)];
end
rgb_matrix = [r_arr g_arr b_arr];
flatten = row_size*column_size;
cost_matrix = [0 0];

%main algorithm
for index=2:30 %number of iterations changeable
    location = 0;
    cluster_matrix = zeros(flatten,k);
    l2norm = zeros(flatten,k);
    cost_matrix(index) = 0;
    cluster_matrix_sum = zeros(1,k);
    index2 = 1;
    counter = 1;
    
    while counter<=flatten
        for cl_it=1:k
            %calculate distance
            l2norm(counter,cl_it) = (rgb_matrix(counter,:)-avg(cl_it,:))*(rgb_matrix(counter,:)-avg(cl_it,:))';
        end
        
        [~, low_index] = min(l2norm(counter,:));
        cluster_matrix(counter,low_index) = 1;
        counter = counter +1;
    end
    
    counter = 1;
    while counter<=flatten
        for cl_it=1:k
            %calculate cost
            cost_matrix(index) = cost_matrix(index)+cluster_matrix(counter,cl_it)*l2norm(counter,cl_it); 
            fill = cluster_matrix(counter,cl_it) * rgb_matrix(counter,:);
            if fill ~= zeros(1,3)
                avg(cl_it,:) = avg(cl_it,:)+fill;
            end
        end
        %summing up cluster matrix
        cluster_matrix_sum = cluster_matrix(counter,:) + cluster_matrix_sum;
        counter = counter +1;
    end
    
    %show the image
    res = zeros(row_size,column_size,3);
    counter = 1;
    while counter<=column_size*row_size
        [~, fill_index] = max(cluster_matrix(counter,:));
        res(counter-location,index2,1) = avg(fill_index,1); res(counter-location,index2,2) = avg(fill_index,2); res(counter-location,index2,3) = avg(fill_index,3);
        %boundaries
        if counter - location == row_size
            location = location + row_size;
            index2 = index2 + 1;
        end
        counter = counter + 1;
    end
    
    counter = 1;
    while counter<=k
        if cluster_matrix_sum(counter) ~= 0
            %normalizing it
            avg(counter,:) = avg(counter,:)/cluster_matrix_sum(counter);
        end
        counter = counter +1;
    end
  
    %threshold
    if sqrt((cost_matrix(index)-cost_matrix(index-1))^2)<5, break; end
end

%creating labelIm
M = zeros(row_size,column_size);

%reshaping flat vector to a matrix which can be displayed
for counter=1:k
    v = cluster_matrix(:,counter);
    V = reshape(v,row_size,column_size)*counter;
    M = M + V;
end

labelIm = M;
end