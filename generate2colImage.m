% prueba de concepto contador de rayos
% Daniel Rodriguez - 2021
% Cibernetica 3

% Ejemplo adaptado de tutorial de matlab
close all
clear all
clc

%% Paso 1: carga imagen
imgDir = 'img/30.jpg';
img2c = '30-2C.png';
I = imread(imgDir);
%imshow(I);

%% Paso 2: Cambio a escala de grises y reducción de elementos en la imagen
g_img = rgb2gray(I);
%imshow(g_img);
lv_gray=0.8;
i1=im2bw(g_img,lv_gray);
%imshow(i1);

%% Paso 3: Rellenar agujeros
Ifilled = imfill(i1,'holes');
%figure, imshow(Ifilled);

%% Paso 4: Segunda rellenada de agujeros
se = strel('disk', 1);
Iopenned = imopen(Ifilled,se);
% figure,imshowpair(Iopenned, I);
%imshow(Iopenned);
imwrite(Iopenned, img2c);
