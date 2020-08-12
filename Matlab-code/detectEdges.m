%MATLAB code for the Edge Detection (Modifications of the code were used
%for certain images to provide better results in that specific case).

%To find the edges of the images.
%Author:Abishek Krishnan
clc;
close all;
clear all;

%Read all the images from a folder
warning('off', 'Images:initSize:adjustingMag'); 
%To turn off the warning the image is to big to fit in this window

d = dir('*.jpg');
files = {d.name};
number_of_images = length(d);

%To segments for morphological operations
se1 = strel('line',3,0);
se2 = strel ('line',3,90);
se1e = strel('line',2,0);
se2e = strel ('line',2,90);

for k=1:number_of_images
	I{k} = imread(files{k});
	level = graythresh(I{k});
	level1 = graythresh(I{1});
	I_binary = im2bw(I{k},level);
	I_binary1 = im2bw(I{1},level1);
	I_noise_remove_salt_and_pepper = medfilt2(I_binary,[3 3]);
	I_noise_remove_salt_and_pepper1 = medfilt2(I_binary1,[3 3]);
	I_noise_removed = wiener2(I_noise_remove_salt_and_pepper,[3 3]);
	I_noise_removed1 = wiener2(I_noise_remove_salt_and_pepper1,[3 3]);
	I_binary_complement = imcomplement(I_noise_removed);
	I_binary_complement1 = imcomplement(I_noise_removed1);
	I_sobel = edge(I_binary_complement,'sobel');
	I_sobel1 = edge(I_binary_complement1,'sobel');
	I_filled_holes = imfill(I_sobel,'holes');
	I_filled_holes1 = imfill(I_sobel1,'holes');33
	I_extra_sobel = edge(I_filled_holes,'sobel');
	I_extra_sobel1 = edge(I_filled_holes1,'sobel');
	I_dilated = imdilate(I_extra_sobel,[se1e se2e]);
	I_dilated1 = imdilate(I_extra_sobel1,[se1e se2e]);
	Result{k} = I_dilated; % or I_dilated1 depending on the input image
end