function [boundaryIm] = boundaryPixels(labelIm)
%returns a specific label for each label boundary (e.g. each label
%intersection has a specific number)

% boundaryIm = edge(labelIm);

% [der_x,der_y] = imgradientxy(labelIm);
% e_values = abs(der_x)+abs(der_y);
% boundaryIm = e_values;

[row_size, column_size] = size(labelIm);
boundaryIm = zeros(row_size, column_size);
label_matrix = zeros(0,2);

for i=2:row_size-1
    for j=2:column_size-1
        a = labelIm(i,j) - labelIm(i,j-1);
        b = labelIm(i,j) - labelIm(i,j+1);
        c = labelIm(i,j) - labelIm(i+1,j);
        d = labelIm(i,j) - labelIm(i-1,j);
        e = labelIm(i,j) - labelIm(i+1,j+1);
        f = labelIm(i,j) - labelIm(i+1,j-1);
        g = labelIm(i,j) - labelIm(i-1,j+1);
        h = labelIm(i,j) - labelIm(i-1,j-1);
        if a>0
            [label, label_matrix] = get_label(labelIm,i,j-1,label_matrix);
            boundaryIm(i,j) = label;
        elseif b>0
            [label, label_matrix] = get_label(labelIm,i,j+1,label_matrix);
            boundaryIm(i,j) = label;
        elseif c>0
            [label, label_matrix] = get_label(labelIm,i+1,j,label_matrix);
            boundaryIm(i,j) = label;
        elseif d>0
            [label, label_matrix] = get_label(labelIm,i-1,j,label_matrix);
            boundaryIm(i,j) = label;
        elseif e>0
            [label, label_matrix] = get_label(labelIm,i+1,j+1,label_matrix);
            boundaryIm(i,j) = label;
        elseif f>0
            [label, label_matrix] = get_label(labelIm,i+1,j+1,label_matrix);
            boundaryIm(i,j) = label;
        elseif g>0
            [label, label_matrix] = get_label(labelIm,i-1,j-1,label_matrix);
            boundaryIm(i,j) = label;
        elseif h>0
            [label, label_matrix] = get_label(labelIm,i-1,j-1,label_matrix);
            boundaryIm(i,j) = label;
        end
    end
end
end

