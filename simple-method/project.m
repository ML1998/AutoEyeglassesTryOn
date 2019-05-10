%% Final Project for Digital Image Processing
%  @ Columbia University, May 2019
%  Mingyu Lei

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto Eye-glasses Try on System:                          %
%                                                          %
% Copyright (C) 2019 Mingyu Lei. All rights reserved.      %
%                    mingyulei98@gmail.com                 %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all; clear


%% Check the necessary tool boxes for face and face parts detection

reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
reqToolboxes = string(reqToolboxes);
if( ~toolboxes(reqToolboxes) )
    error('Please install: Computer Vision System Toolbox and Image Processing Toolbox.');
end

%% Read in an image

[filename, pathname] = uigetfile(...    
    {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif; *.TIF; *.tiff, *.TIFF','Supported Files (*.jpg,*.img,*.tiff,)'; ...
    '*.jpg','jpg Files (*.jpg)';...
    '*.JPG','JPG Files (*.JPG)';...
    '*.jpeg','jpeg Files (*.jpeg)';...
    '*.JPEG','JPEG Files (*.JPEG)';...
    '*.img','img Files (*.img)';...
    '*.IMG','IMG Files (*.IMG)';...
    '*.tif','tif Files (*.tif)';...
    '*.TIF','TIF Files (*.TIF)';...
    '*.tiff','tiff Files (*.tiff)';...
    '*.TIFF','TIFF Files (*.TIFF)'});

% No image read in
if isequal(filename,0)
    error(' Load Error: No files selected! Load cancelled.')
end
    
% Show original image
fullname = fullfile(pathname,filename);
img = imread(fullname);

%% Detect the parts

detector = buildDetector(2,2);
[fp bbimg1 faces1 bbfaces1] = detectRotFaceParts(detector,img,2,15);

figure;imshow(bbimg1);


%% Size of two eyes
leftEyePara = fp(:,9:16);     % (x,y) set of four corner of left eye
rightEyePara = fp(:,17:24);   % (x,y) set of four corner of right eye
figure;imshow(img);

hold on
leyeCenter.x = (leftEyePara(1)+leftEyePara(5))/2;
leyeCenter.y = (leftEyePara(2)+leftEyePara(6))/2;
plot(leyeCenter.x, leyeCenter.y, '*');
text(leyeCenter.x, leyeCenter.y+50, 'left eye center','HorizontalAlignment','right');

reyeCenter.x = (rightEyePara(1)+rightEyePara(5))/2;
reyeCenter.y = (rightEyePara(2)+rightEyePara(6))/2;
plot(reyeCenter.x, reyeCenter.y, '*');
text(reyeCenter.x, reyeCenter.y+50, 'righteye center','HorizontalAlignment','left');

imgCenter.x = size(img,2)/2;
imgCenter.y = size(img,1)/2;
plot(imgCenter.x,imgCenter.y,'w*');
text(imgCenter.x,imgCenter.y(1)-50,'image center','HorizontalAlignment','center');
%% Rotate the image if it is not alighed and detect the eye again

eyeD = norm([leyeCenter.x, leyeCenter.y]-[reyeCenter.x, reyeCenter.y]);

degree = -asind((leyeCenter.y-reyeCenter.y)/eyeD);
rotatedI = imrotate(img,degree,'crop');
figure;
imshow(rotatedI);
hold on
leye = rotatePointLocation(leyeCenter,imgCenter,degree);
reye = rotatePointLocation(reyeCenter,imgCenter,degree);
plot(leye.x, leye.y, '*');
plot(reye.x, reye.y, '*');

%% Eye/sun glasses
%[ExtractedI, Mask,k1] = eyeglassExtract();
[ExtractedI, Mask,k1] = sunglassExtract();

%% Find the landmarks on eyeglasses

[coeffs,EdgeIgl] = eyeglassesFrame(Mask);
glassD = coeffs.size(2);
 eyeD = norm([leye.x, leye.y]-[reye.x, reye.y]);
eyesCenter = [(leye.x+reye.x)/2, (leye.y+reye.y)/2];
glassCenter = coeffs.glassCenter;

% Adjust the size of eye-glasses image accordingly
k = eyeD/glassD*k1;
glassOnlyI = imresize(ExtractedI,k);
glassMarkI = imresize(Mask,k);
glassCenter = glassCenter*k;

figure,imshow(glassOnlyI);
hold on
%plot(glassCenter(1),glassCenter(2),'*');

% "Put on" the glasses
[M, N, L] = size(img);
[m, n] = size(glassOnlyI(:,:,1));
NewI = zeros(M,N,1);

x = round(eyesCenter(2));
y = round(eyesCenter(1));
y1 = round(glassCenter(1));
y2 = n - y1;
x1 = round(glassCenter(2));
x2 = m - x1;

NewI(x-x1:x+x2-1,y-y1:y+y2-1)= glassMarkI;
NewGlassI = zeros(M,N,3);
for dim = 1:3
    NewGlassI(x-x1:x+x2-1,y-y1:y+y2-1,dim)= glassOnlyI(:,:,dim);
end
%figure,imshow(NewI);
%figure,imshow(uint8(NewGlassI));
hold on
%plot(y,x,'*');
%plot(y-y1,x-x1,'*');
%plot(y+y2,x+x2,'*');

%% Show the result 
% Put on the glasses with the help of the mask image
NewImg = rotatedI;
for a = 1:M
    for b = 1:N
        for dim = 1:3
            if (NewI(a,b))
                NewImg(a,b,dim) = NewGlassI(a,b,dim);
            end
        end
    end
end

figure;
imshow(NewImg);
imgBlurred = imgaussfilt(NewImg, 1);
imshow(imgBlurred);
hold on

%% Extract the image nose
% start from center of eye + 0.25eyeD
% end at eye+0.9eyeD
xleft = leye.x;
y1 = leye.y + 0.25*eyeD;
y2 = leye.y + 0.9*eyeD;
xright = reye.x;
y3 = reye.y + 0.25*eyeD;
y4 = reye.y + 0.9*eyeD;

plot(xleft, y1, '*');
plot(xleft, y2, '*');
plot(xright, y3, '*');
plot(xright, y4, '*');

nose = rotatedI(y1:y2,xleft:xright,:);
figure;
imshow(nose);
