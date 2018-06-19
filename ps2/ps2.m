% ps2

%% 1-a
% Read images
L = im2double(imread(fullfile('input', 'pair0-L.png')));
R = im2double(imread(fullfile('input', 'pair0-R.png')));

% Compute disparity
D_L = disparity_ssd(L, R);
D_R = disparity_ssd(R, L);

% TODO: Save output images (D_L as output/ps2-1-a-1.png and D_R as output/ps2-1-a-2.png)
% Note: They may need to be scaled/shifted before saving to show results properly

% TODO: Rest of your code here
img_DL = mat2gray(D_L);
img_DR = mat2gray(D_R);


imshow(img_DL);
figure
imshow(img_DR);
% Looks like it doesn't like edges

imwrite(img_DL,fullfile('output','ps2-1-a-1.png'));
imwrite(img_DR,fullfile('output','ps2-1-a-2.png'));


%% 2-a

L = im2double(imread(fullfile('input', 'pair1-L.png')));
R = im2double(imread(fullfile('input', 'pair1-R.png')));

L = rgb2gray(L);
R = rgb2gray(R);

D_L = disparity_ssd(L, R);
% D_R = disparity_ssd(R, L);

img_DL = mat2gray(D_L);
% img_DR = mat2gray(D_R);


imshow(img_DL);
figure
% imshow(img_DR);

% Looks like it doesn't like edges

imwrite(img_DL,fullfile('output','ps2-2-a-1.png'));
% imwrite(img_DR,fullfile('output','ps2-2-a-2.png'));


%% 4-a
% Read images
L = im2double(imread(fullfile('input', 'pair0-L.png')));
R = im2double(imread(fullfile('input', 'pair0-R.png')));

% Compute disparity
D_L = disparity_ncorr(L, R);

% TODO: Save output images (D_L as output/ps2-1-a-1.png and D_R as output/ps2-1-a-2.png)
% Note: They may need to be scaled/shifted before saving to show results properly

% TODO: Rest of your code here
img_DL = mat2gray(D_L);
% img_DR = mat2gray(D_R);


imshow(img_DL);
% figure
% imshow(img_DR);
% Looks like it doesn't like edges

imwrite(img_DL,fullfile('output','ps2-4-a-1.png'));
imwrite(img_DR,fullfile('output','ps2-4-a-2.png'));

