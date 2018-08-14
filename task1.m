clear;
clc;
close all;
%%
%Read in images
I1 = imread('images/moon.jpg');
% I1 = imread('images/trees.jpg');
% get the grayscale image
Im1 = rgb2gray(I1);
% get the size of image
[rowIm,colIm] = size(Im1);
%%
% mark out a region and get the mask
mask = roipoly(Im1);
%%
% get the size of the selected region
[rowMask, colMask] = find(mask);
% convert the image value to double values
img1 = double(Im1);
%initialise the result
result = img1; 
% the number of unknown pixels
unknown_pixels = size(find(mask), 1);
% unknown_index is the indeices of the the unknown pixels in image
unknown_index =find(mask);
% initialise the b vector
b = zeros(unknown_pixels,1);

% set new indices to the unknown pixels
% this indices will help to set values in matrix A
index_mask = zeros(rowIm, colIm);
index_mask(unknown_index) = 1:size(unknown_index,1);

%initialise the A matrix where A is a sparse marix
A = sparse(unknown_pixels, unknown_pixels);
% counter is the row index of matrix A
counter = 1;
% use for-loop to find the selected region
for j=1:colIm
    for i=1:rowIm
        % if the pixel is unknown, check the neighbours of the pixel
        if(mask(i,j) == 1)
            % all values of the diagnal line of A is 4
             A(counter, counter) = 4;
             % if the neighbour of pixel is also unknown, 
             % set the correspongding vaule in A as -1.
             % if the neighbour of pixel is not unknown,the pixel in the
             % boundary region, then
             % the corresponding value in b will plus the pixel value
             
             % check upper neighbour 
             if(mask(i-1,j)==1)
                 A(counter, index_mask(i-1,j)) = -1;
             else
                 b(counter) = b(counter) + img1(i-1,j);
             end
             
             % check the left neighbour 
             if(mask(i,j-1)==1)
                 A(counter, index_mask(i,j-1)) = -1;
             else
                 b(counter) = b(counter) + img1(i,j-1);
             end
             
             % check the lower neighbour
             if(mask(i+1,j)==1)
                 A(counter, index_mask(i+1,j)) = -1;
             else
                 b(counter) = b(counter) + img1(i+1,j);
             end
             
             % check the right neighbour 
             if(mask(i,j+1)==1)
                 A(counter, index_mask(i,j+1)) = -1;
             else
                 b(counter) = b(counter) + img1(i,j+1);
             end
             counter = counter+1;
        end
    end
end

% when the size of selected is increasing, the gradient of the result region 
% will be smooth. Thus, the result will be more smooth.

% Solve Ax = b
x = A\b;
% Put solution into result
result(unknown_index) = x(1:unknown_pixels);
result = uint8(result);
%%
figure('Name', 'Task_1 Result');
imshow(result);