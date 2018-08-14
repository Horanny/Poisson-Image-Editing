function result = solvePoisson2b(img1, img2, mask1, mask2, insert_row,insert_col)

img1 = double(img1);
img2 = double(img2);
% initialize the result
result = img2;
% get the size of the target image
[rowIm,colIm] = size(img2);
% get the size of the selected region
[rowMask, colMask] = find(mask1);
startPoint = [min(rowMask),min(colMask)];

% the number of unknown pixels
unknown_pixels = size(find(mask1), 1);
% unknown_index is the indeices of the the unknown pixels in image
unknown_index = find(mask2);


%Create b vector
 b = zeros(unknown_pixels,1);
 
% set new indices to the unknown pixels
% this indices will help to set values in matrix A
index_mask = zeros(rowIm, colIm);
index_mask(unknown_index) = 1:size(unknown_index,1);


%Create A matrix
A = sparse(unknown_pixels, unknown_pixels);
% counter is the row index of matrix A
counter = 1;
for j=1:colIm
    for i=1:rowIm
        % x is the corresponding row in source image 
        x = i + startPoint(1) - insert_row;
        % y is the corresponding column in source image 
        y = j + startPoint(2) - insert_col;
        
        % if the pixel is unknown, check the neighbours of the pixel
        if(mask2(i,j) == 1)
             % all values of the diagnal line of A is 4
             A(counter, counter) = 4;
            % if the neighbour of pixel is also unknown, 
             % set the correspongding vaule in A as -1 and add v_pq
             % if the neighbour of pixel is not unknown,the pixel in the
             % boundary region, then
             % the corresponding value in b will plus the pixel value in 
             % target image
             
             % the v_pq is fStar_p - fStar_q when the 
             %|fStar_p - fStar_q|>|g_p - g_q|
             % otherwise, v_pq is g_p - g_q
             
             % check upper neighbour 
             if(abs(img1(x,y)-img1(x-1,y))<abs(img2(i,j)-img2(i-1,j)))
                 v_pq1 = img2(i,j)-img2(i-1,j);
             else
                 v_pq1 = img1(x,y)-img1(x-1,y);
             end
             if(mask2(i-1,j)==1)
                 A(counter, index_mask(i-1,j)) = -1;
                 b(counter)= b(counter) + v_pq1;
             else
                 b(counter) = b(counter) + v_pq1 + img2(i-1,j);
             end
             
             % check the left neighbour
             if(abs(img1(x,y)-img1(x,y-1))<abs(img2(i,j)-img2(i,j-1)))
                 v_pq2 = img2(i,j)-img2(i,j-1);
             else
                 v_pq2 = img1(x,y)-img1(x,y-1);
             end
             
             if(mask2(i,j-1)==1)
                 A(counter, index_mask(i,j-1)) = -1;
                 b(counter)= b(counter) + v_pq2;
             else
                 b(counter) = b(counter) + v_pq2 + img2(i,j-1);
             end
             
             % check the lower neighbour
             if(abs(img1(x,y)-img1(x+1,y))<abs(img2(i,j)-img2(i+1,j)))
                 v_pq3 = img2(i,j)-img2(i+1,j);
             else
                 v_pq3 = img1(x,y)-img1(x+1,y);
             end
             
             if(mask2(i+1,j)==1)
                 A(counter, index_mask(i+1,j)) = -1;
                 b(counter)= b(counter) + v_pq3;
             else
                 b(counter) = b(counter) + v_pq3 + img2(i+1,j);
             end
             
             % check the right neighbour
             if(abs(img1(x,y)-img1(x,y+1))<abs(img2(i,j)-img2(i,j+1)))
                 v_pq4 = img2(i,j)-img2(i,j+1);
             else
                 v_pq4 = img1(x,y)-img1(x,y+1);
             end
             if(mask2(i,j+1)==1)
                 A(counter, index_mask(i,j+1)) = -1;
                 b(counter)= b(counter) + v_pq4;
             else
                 b(counter) = b(counter) + v_pq4 + img2(i,j+1);
             end
             counter = counter+1;
        end
    end
end


%Solve Ax = b
x = A\b;

%Put solution intensities from x into img
result(unknown_index) = x(1:unknown_pixels);
result(unknown_index) = x(1:unknown_pixels);
result = uint8(result);
end

