%{ 
This code returns a binary image with filled holes of a 150x150
Lightning ray color image.
This code is an adaptation from this matlab tutorial:
Thé, A. (2014). "Image Processing Made Easy - Previous Version". Retrived
from: https://youtu.be/1-jURfDzP1s

Author: Daniel Rodriguez
Year: 2021
Course: Cibernetica 3
%}
close all
clear all
clc

%% Step 1: load image you want to transform
imgDir = 'imgOriginal/30.jpg'; % route to the image folder with image name
img2c = '30-2C.png'; % new image name
I = imread(imgDir);
%imshow(I);

%% Step 2: Chage image to gray scale and reduce elements in it
g_img = rgb2gray(I); % Gray scale conversion
lv_gray=0.8;
i1=im2bw(g_img,lv_gray); % Binary image conversion

%% Step 3: Fill holes
Ifilled = imfill(i1,'holes'); % first filled holes
% Fill holes with geometric method
se = strel('disk', 1);
Iopenned = imopen(Ifilled,se);

%% Step 4: Save the image in a new file
imwrite(Iopenned, img2c);
