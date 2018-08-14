clear;
clc;
close all;
%%
%Read in images
% Im1 = imread('images/dog.png');
% Im2 = imread('images/background.jpeg');
% Im1 = imread('images/door.jpg');
% Im2 = imread('images/background.jpeg');
Im1 = imread('images/p.jpg');
Im2 = imread('images/water.jpg');
[rowIm,colIm] = size(Im2);
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
mask2 = zeros(rowIm,colIm);
% r is the row numbers of unknown pixel in target image
r = insert_row+rowMask-startPoint(1);
% c is the col numbers of unknown pixel in target image
c = insert_col+colMask-startPoint(2);
% set the unknown pixels in target image as 1
mask2(sub2ind(size(Im2),r,c))=1;

%%
%initialize the result
result = Im2;
result(:,:,1) = solvePoisson2a(Im1(:,:,1),Im2(:,:,1),mask1,mask2,insert_row,insert_col);
result(:,:,2) = solvePoisson2a(Im1(:,:,2),Im2(:,:,2),mask1,mask2,insert_row,insert_col);
result(:,:,3) = solvePoisson2a(Im1(:,:,3),Im2(:,:,3),mask1,mask2,insert_row,insert_col);
% result(:,:,1) = solvePoisson2b(Im1(:,:,1),Im2(:,:,1),mask1,mask2,insert_row,insert_col);
% result(:,:,2) = solvePoisson2b(Im1(:,:,2),Im2(:,:,2),mask1,mask2,insert_row,insert_col);
% result(:,:,3) = solvePoisson2b(Im1(:,:,3),Im2(:,:,3),mask1,mask2,insert_row,insert_col);

%%
% show the result 
figure('Name', 'Task3 Result');
imshow(result);