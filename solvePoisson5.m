function result = solvePoisson5(img1, img2, mask)

img1 = double(img1);
img2 = double(img2);
% initialize the result
result = img2;
% get the size of the target image
[rowIm,colIm] = size(img2);
% get the size of the selected region


% the number of unknown pixels
unknown_pixels = size(find(mask), 1);
% unknown_index is the indeices of the the unknown pixels in image
unknown_index = find(mask);


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
        % if the pixel is unknown, check the neighbours of the pixel
        if(mask(i,j) == 1)
            % all values of the diagnal line of A is 4
             A(counter, counter) = 4;
             % if the neighbour of pixel is also unknown, 
             % set the correspongding vaule in A as -1 and add v_pq
             % if the neighbour of pixel is not unknown,the pixel in the
             % boundary region, then
             % the corresponding value in b will plus the pixel value in 
             % target image
             
             % check upper neighbour 
             v_pq1 = img1(i,j)-img1(i-1,j);
             if(mask(i-1,j)==1)
                 A(counter, index_mask(i-1,j)) = -1;
                 b(counter)= b(counter) + v_pq1;
             else
                 b(counter) = b(counter) + v_pq1+ img2(i-1,j);
             end
             
             % check the left neighbour
             v_pq2 = img1(i,j)-img1(i,j-1);
             if(mask(i,j-1)==1)
                 A(counter, index_mask(i,j-1)) = -1;
                 b(counter)= b(counter) + v_pq2;
             else
                 b(counter) = b(counter) + v_pq2 + img2(i,j-1);
             end
             
             % check the lower neighbour
             v_pq3 = img1(i,j)-img1(i+1,j);
             if(mask(i+1,j)==1)
                 A(counter, index_mask(i+1,j)) = -1;
                 b(counter)= b(counter) + v_pq3;
             else
                 b(counter) = b(counter) + v_pq3 + img2(i+1,j);
             end
             
             % check the right neighbour
             v_pq4 = img1(i,j)-img1(i,j+1);
             if(mask(i,j+1)==1)
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

result = uint8(result);
end

