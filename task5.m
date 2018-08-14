clear;
clc;
close all;
%%
%Read in images
 Im1 = imread('images/flower.jpg');
% get the size of image
[rowIm,colIm] = size(Im1);
%%
% mark out a region and get the mask
mask = roipoly(Im1);
%%
result = Im1;
% change the color
result_R = Im1(:,:,1) * 1.5;
result_G = Im1(:,:,2) * 0.5;
result_B = Im1(:,:,3) * 0.5;

result(:,:,1) = solvePoisson5(result_R,Im1(:,:,1),mask);
result(:,:,2) = solvePoisson5(result_G,Im1(:,:,2),mask);
result(:,:,3) = solvePoisson5(result_B,Im1(:,:,3),mask);
%%
figure('Name', 'Task5 Result');
imshow(result);