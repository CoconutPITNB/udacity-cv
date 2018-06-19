%% PS0 for Introduction to CV by Udacity
clear all
close all
clc

%% Question 1

img_fuji = imread('output/ps0-1-a-1.png');
img_shard = imread('output/ps0-1-a-2.png');

% figure
% imshow(img_fuji);
% figure
% imshow(img_shard);

% size(img_fuji);
% size(img_shard);

%% Question 2


%% a
swap_1 = img_fuji(:,:,1);
swap_3 = img_fuji(:,:,3);
img_fuji_swap = img_fuji;
img_fuji_swap(:,:,1) = swap_3;
img_fuji_swap(:,:,3) = swap_1;
imwrite(img_fuji_swap,'output/ps0-2-a-1.png')
figure
imshow(img_fuji)
figure
imshow(img_fuji_swap)

%% b
img_fuji_green = img_fuji(:,:,2);
imwrite(img_fuji_green,'output/ps0-2-b-1.png')
figure
imshow(img_fuji_green)

%% c
img_fuji_red = img_fuji(:,:,1);
imwrite(img_fuji_red,'output/ps0-2-c-1.png')
figure
imshow(img_fuji_red)

%% d
%% no idea

%% Question 3

%%

img = imread('output/ps0-2-c-1.png');
img_center = img(floor(size(img,1)/2)-50:floor(size(img,1)/2)+49,...
                 floor(size(img,2)/2)-50:floor(size(img,2)/2)+49);
imshow(img_center)
imwrite(img_center,'output/ps0-3-a-1.png')

%% Question 4

%% a

img_green = imread('output/ps0-2-b-1.png');
c = max(img_green(:));
d = min(img_green(:));
fprintf('The max is %i and the min is %i\n',c,d);
m = mean(img_green(:));
fprintf('The mean is %i\n',m);
s = std(double(img_green(:)));
fprintf('The SD is %i\n',s);


%% b
img_green_new = (img_green - m)/s*10 + m;
imwrite(img_green_new,'output/ps0-4-b-1.png')

%% c
img_green_shift = img_green;
px = 2;
img_green_shift(:,1:end-px) = img_green_shift(:,(px+1):end);
img_green_shift(:,end-(px+1):end) = 0;
imshow(img_green_shift)
imwrite(img_green_shift,'output/ps0-4-c-1.png')

%% d

img_diff = imabsdiff(img_green,img_green_shift);
imshow(img_diff)
imwrite(img_diff,'output/ps0-4-d-1.png')

%% Question 5

%% a

img = img_fuji;
green_noise = imnoise(img(:,:,2),'gaussian',0,1);
img_noisy = img;
img_noisy(:,:,2) = green_noise;
imshow(img_noisy)
imwrite(img_noisy,'output/ps0-5-a-1.png')

img_noisy = img;
blue_noise = imnoise(img(:,:,3),'gaussian',0,1);
img_noisy(:,:,3) = blue_noise;
imshow(img_noisy)
imwrite(img_noisy,'output/ps0-5-b-1.png')
