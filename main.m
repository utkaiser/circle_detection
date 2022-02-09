function run()
% I = imread('data/coins.jpg');
% [centers] = detectCirclesHT(I,4);

im = imread('data/planets.jpg');

[a] = detectCirclesHT(im,27);



%%%%%%%%%%%%%% chapter 3 %%%%%%%%%%%%%%%
% [labelIm] = clusterPixels(im, 8);
% disp(labelIm);
% b_im = boundaryPixels(labelIm);
% 
% cmap = [0, 0, 1; ... % Blue for 1
%   0, 0, 0; ...       % Black for 2
%   0, 1, 1; ...       % Green for 3
%   1, 0, 0;...        % Red for 4
%   1, 1, 0;...        % Yellow for 5
%   0.5,0.5,0.5;...    % grey for 6
%   1,1,1;...          % white for 7
%   1,0,1];            % magenta for 8        
% 
% RGB = ind2rgb(labelIm,cmap);
% figure;
% subplot(3,1,1), imshow(im), title("normal image");
% subplot(3,1,2), imshow(RGB), title("kmeans with k = 8");
% subplot(3,1,3), imshow(b_im), title("boundary image with k = 8");


end