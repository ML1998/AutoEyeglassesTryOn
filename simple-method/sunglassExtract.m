function [EyeGlass, filledMask,k1] = sunglassExtract()
% Sun glasses Extraction Function 
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
figure;imshow(Igl);

close all;clc;
grayIgl = rgb2gray(Igl);

seBH = strel('disk',75);
J = imbothat(grayIgl,seBH);
figure,imshow(J);

%% Detect the Edge of the sun glasses
% determine the threshold according to global var
varImg = var(double(grayIgl(:)));

bwIgl = imbinarize(J,'adaptive','Sensitivity',0.94);
figure;
imshow(bwIgl);
se = strel('disk',4);
Mask = imdilate(bwIgl,se);


figure,imshow(Mask);
filledMask = imfill(Mask,'holes');
figure,imshow(filledMask);

%%
EyeGlass(:,:,1) = uint8(filledMask) .* Igl(:,:,1);
EyeGlass(:,:,2) = uint8(filledMask) .* Igl(:,:,2);
EyeGlass(:,:,3) = uint8(filledMask) .* Igl(:,:,3);

figure,imshow(EyeGlass);
k1 = 1.3;
end