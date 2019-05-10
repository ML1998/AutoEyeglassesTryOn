function [EyeGlass, Mask, k1] = eyeglassExtract()
% Eye glasses Extraction Function 
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
%figure;imshow(Igl);

close all;clc;
grayIgl = rgb2gray(Igl);

seBH = strel('disk',80);
J = imbothat(grayIgl,seBH);
%figure,imshow(J);

%%
% determine the threshold according to global var
varImg = var(double(grayIgl(:)));
th = decideTh(varImg);

bwIgl = imbinarize(J,'adaptive','Sensitivity',th);
figure,imshow(bwIgl);

%%
se = strel('disk',3);
erodedI = imerode(bwIgl,se);
%figure,imshow(erodedI);

%%
FiltedI = bwareafilt(erodedI,1);
%figure,imshow(FiltedI);
se = strel('disk',3);
Mask = imdilate(FiltedI,se);
%figure,imshow(Mask);

%%
EyeGlass(:,:,1) = uint8(Mask) .* Igl(:,:,1);
EyeGlass(:,:,2) = uint8(Mask) .* Igl(:,:,2);
EyeGlass(:,:,3) = uint8(Mask) .* Igl(:,:,3);

figure,imshow(EyeGlass);
k1 = 1.1;
end