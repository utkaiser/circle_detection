function draw_circle(im, radius, centers)
%displays circles on the image

figure
imshow(im)
hold on;
for i=1:length(centers)
    th=0:pi/100:2*pi;
    h = plot(centers(i,2)+cos(th)*radius,centers(i,1)+sin(th)*radius,'LineWidth',5);
    title(strcat('radius=', int2str(radius)))
end
end