function [coeff,edgeI] = eyeglassesFrame(dilatedI)

% Input:
%   A BW image of front eyeglasses frame
% Output:
%   coeff: A struct to store image coefficients

%   edgeI: detected edge using matlab function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto Eye-glasses Try on System:                          %
%                                                          %
% Copyright (C) 2019 Mingyu Lei. All rights reserved.      %
%                    mingyulei98@gmail.com                 %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the edge and size of eyeglasses

edgeI = edge(dilatedI(:,:,1));
figure;
imshow(edgeI);
hold on;
[m,n] = size(edgeI);

% Find the most right and most right point of the eyeglass
minWY = n;
for x = 1:m
    for y = 1:n
        if(edgeI(x,y) == 1)
            if(minWY>y)
                minWY = y;
                minWX = x;   
            break;
            end
        end
    end
end

for y = n:-1:minWY
    if(edgeI(minWX,y) == 1)
        maxWY = y;
        break;
    end
end

coeff.width = {[minWY,minWX],[maxWY,minWX]};
plot(minWY,minWX,'*');
plot(maxWY,minWX,'*');
width = maxWY-minWY;

% Find the left most up and most down point of the eyeglass
minHXL = m;
for y = 1:n/2
    for x = 1:m
        if(edgeI(x,y) == 1)
            if(minHXL>x)
                minHYL = y;
                minHXL = x;   
            break;
            end
        end
    end
end

for x = m:-1:minHXL
    if(edgeI(x,minHYL) == 1)
        maxHXL = x;
        break;
    end
end

% Find the right most up and most down point of the eyeglass
minHXR = m;
for y = round(n/2):n
    for x = 1:m
        if(edgeI(x,y) == 1)
            if(minHXR>x)
                minHYR = y;
                minHXR = x;   
            break;
            end
        end
    end
end

for x = m:-1:minHXR
    if(edgeI(x,minHYR) == 1)
        maxHXR = x;
        break;
    end
end

plot(minHYL,minHXL,'*');
plot(minHYL,maxHXL,'*');

plot(minHYR,minHXR,'*');
plot(minHYR,maxHXR,'*');

coeff.left = {[minHYL,minHXL],[minHYL,maxHXL]};
coeff.right = {[minHYR,minHXR],[minHYR,maxHXR]};

coeff.lcenter = [minHYL,(minHXL+maxHXL)/2];
coeff.rcenter = [minHYR,(minHXR+maxHXR)/2];

coeff.glassCenter = (coeff.lcenter+coeff.rcenter)/2;
coeff.glassCenter(1) = coeff.glassCenter(1) + 30; 
coeff.glassCenter(2) = (coeff.glassCenter(2)+minHXL)/2;

plot(coeff.lcenter(1),coeff.lcenter(2),'*');
plot(coeff.rcenter(1),coeff.rcenter(2),'*');
distance = minHYR - minHYL;
height = maxHXL-minHXL;
coeff.size = [width,distance,height];

end

