function [pt,imgout] = findLargestPixel(img,m)

%FINDLARGESTPIXEL Summary of this function goes here
I1 = double(img(:,:,1));
I2 = double(img(:,:,2));
I3 = double(img(:,:,3));
D = I1+I2+I3;

pt = zeros(m,3);


for i = 1:m
[M,ind] = max(D(:));
D(ind) = 0;
pt(i,:) = [I1(ind),I2(ind),I3(ind)];
I1(ind) = 255;
I2(ind) = 0;
I3(ind) = 0;
end

pt = mean(pt);
imgout = uint8(cat(3,I1,I2,I3));

