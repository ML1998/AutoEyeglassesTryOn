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
[fp bbimg faces bbfaces] = detectRotFaceParts(detector,img,2,15);

figure;imshow(bbimg);


%% Size of two eyes
leftEyePara = fp(:,9:16);     % (x,y) set of four corner of left eye
rightEyePara = fp(:,17:24);   % (x,y) set of four corner of right eye
figure;imshow(img);

hold on
leyeCenter.x = (leftEyePara(1)+leftEyePara(5))/2;
leyeCenter.y = (leftEyePara(2)+leftEyePara(6))/2;
plot(leyeCenter.x, leyeCenter.y, '*');

reyeCenter.x = (rightEyePara(1)+rightEyePara(5))/2;
reyeCenter.y = (rightEyePara(2)+rightEyePara(6))/2;
plot(reyeCenter.x, reyeCenter.y, '*');

%% Eye glasses
[filename, pathname] = uigetfile(...    
    {'*.jpg; *.png; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif; *.TIF; *.tiff, *.TIFF','Supported Files (*.jpg,*.img,*.tiff,)'; ...
    '*.jpg','jpg Files (*.jpg)';...
    '*.png','png Files (*.png)';...
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
Igl = imread(fullname);

%% Extract the eyeglasses frame(front) from the image

seBH = strel('disk',75);
J = imbothat(Igl(:,:,1),seBH);
figure,imshow(J);
bwJ = imbinarize(J,'adaptive','Sensitivity',0.2);
figure,imshow(bwJ);

se = strel('disk',4);
erodedI = imerode(bwJ,se);
figure,imshow(erodedI);


FiltedI = bwareafilt(erodedI,1);
figure,imshow(FiltedI);
se = strel('disk',3);
dilatedI = imdilate(FiltedI,se);
figure,imshow(dilatedI);

ExtractedI(:,:,1) = uint8(dilatedI) .* Igl(:,:,1);
ExtractedI(:,:,2) = uint8(dilatedI) .* Igl(:,:,2);
ExtractedI(:,:,3) = uint8(dilatedI) .* Igl(:,:,3);

figure,imshow(ExtractedI);

%% Find the landmarks on eyeglasses

[coeffs,EdgeIgl] = eyeglassesFrame(dilatedI);
glassD = coeffs.size(2);
 eyeD = norm([leyeCenter.x, leyeCenter.y]-[reyeCenter.x, reyeCenter.y]);
eyesCenter = [(leyeCenter.x+reyeCenter.x)/2, (leyeCenter.y+reyeCenter.y)/2];
glassCenter = coeffs.glassCenter;

% Adjust the size of eye-glasses image accordingly
glassOnlyI = imresize(ExtractedI,eyeD/glassD);
glassMarkI = imresize(dilatedI,eyeD/glassD);
glassCenter = glassCenter*eyeD/glassD;

figure,imshow(glassOnlyI);
hold on
plot(glassCenter(1),glassCenter(2),'*');

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
figure,imshow(NewI);
figure,imshow(uint8(NewGlassI));
hold on
plot(y,x,'*');
plot(y-y1,x-x1,'*');
plot(y+y2,x+x2,'*');

%% Show the result 
% Put on the glasses with the help of the mask image
for a = 1:M
    for b = 1:N
        for dim = 1:3
            if (NewI(a,b))
                img(a,b,dim) = NewGlassI(a,b,dim);
            end
        end
    end
end

figure;
imshow(img);
imgBlurred = imgaussfilt(img, 2);
imshow(imgBlurred);
