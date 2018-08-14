clear;
clc;
close all;
%%
% Read images
Im1 = imread('images/words.jpg');
Im2 = imread('images/texture.jpeg');
% get the gryscale image 
Im1 = rgb2gray(Im1);
Im2 = rgb2gray(Im2);

% show the source imae
figure;
imshow(Im1);
%%
% get the mask of souce image
mask1 = roipoly(Im1);

%%
% show the target image and allow users to chose the insert point
figure;
imshow(Im2);
% get the selceted point information 
[insert_col,insert_row,~]=impixel(Im2);
%%
% get the size of mask of source image
[rowMask, colMask] = find(mask1);
% the start point to insert is the [min(rowMask),min(colMask)]
startPoint = [min(rowMask),min(colMask)];
% initialize the mask of target image
mask2 = zeros(size(Im2));
% r is the row numbers of unknown pixel in target image
r = insert_row+rowMask-startPoint(1);
% c is the col numbers of unknown pixel in target image
c = insert_col+colMask-startPoint(2);
% set the unknown pixels in target image as 1
mask2(sub2ind(size(Im2),r,c))=1;

% get the result 
result = solvePoisson2b(Im1,Im2,mask1,mask2,insert_row,insert_col);

%%

% show the result
figure('Name', 'Task2b Result');
imshow(result);