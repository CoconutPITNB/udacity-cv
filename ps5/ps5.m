%% PS5 - Optical Flow

%% 1-a

img_0 = imread(fullfile('input\testSeq','Shift0.png'));
img_1 = imread(fullfile('input\testSeq','ShiftR2.png'));

%find gradients of smoothed image (normalised sum)
window_size = 5;
sigma = 2;
h = fspecial('gaussian',window_size,sigma);

[Ix,Iy] = gradients(img_0,sigma,window_size);
It = imfilter(double(img_1-img_0),h,'symmetric');


%solve for u and v over the image

u = zeros(size(img_0));
v = zeros(size(img_0));

for r = 1:size(img_0,1)
    for c = 1:size(img_0,2)
        ATA = [Ix(r,c)^2 Ix(r,c)*Iy(r,c);Ix(r,c)*Iy(r,c) Iy(r,c)^2];
        b = [-Ix(r,c)*It(r,c);-Iy(r,c)*It(r,c)];
        result = ATA\b;
        if isnan(result(1)) || abs(result(1))>50
            result(1)=0;
        end
        if isnan(result(2)) || abs(result(2))>50
            result(2)=0;
        end        
        u(r,c) = result(1);
        v(r,c) = result(2);
    end
end

imagesc(u)
colormap(jet)
colorbar
figure
imagesc(v)
colormap(jet)
colorbar

%% 2-a reduce

img = imread(fullfile('input\DataSeq1','yos_img_01.jpg'));
levels = 4;
yos_reduce = reduce(img,1,5,levels);
figure
for i = 1:levels
    subplot(2,2,i)
    imshow(imresize(uint8(yos_reduce{i}),size(img)))
end

%% 2-b expand

img = imread(fullfile('input\DataSeq1','yos_img_01.jpg'));
levels = 4;
yos_expand = expand(yos_reduce{end},1,5,levels);
figure
for i = 1:levels
    subplot(2,2,i)
    imshow(imresize(uint8(yos_expand{i}),size(img)))
end


%% 2-c laplacian pyramid
%yos_reduce{1} is the original image
%yos_expand{1} is the farthest reduced image
%eg. yos_expand{2} is the farthest reduced expanded to yos_reduce{3} size
G4 = yos_reduce{3};
L3 = yos_reduce{3}-yos_expand{2}(1:end-1,1:end-1);
L2 = yos_reduce{2}-yos_expand{3}(1:end-2,1:end-2);
L1 = yos_reduce{1}-yos_expand{4}(1:end-4,1:end-4);
original = L1 + yos_expand{4}(1:end-4,1:end-4);
figure
imshow(original)

%% 3-a LK warping

levels =3;
img_0_pyramid = reduce(imread(fullfile('input\DataSeq1','yos_img_02.jpg')),2,5,levels);
img_1_pyramid = reduce(imread(fullfile('input\DataSeq1','yos_img_03.jpg')),2,5,levels);

img_0_red = img_0_pyramid{end};
img_1_red = img_1_pyramid{end};

%find gradients of smoothed image (normalised sum)
window_size = 3;
sigma = 1;

[Ix,Iy] = gradients(img_1_red,sigma,window_size);


h = fspecial('gaussian',window_size,sigma);
It = imfilter(double(img_1_red-img_0_red),h,'symmetric');


%solve for u and v over the image

u = zeros(size(img_0_red));
v = zeros(size(img_0_red));

for r = 1:size(img_0_red,1)
    for c = 1:size(img_0_red,2)
        ATA = [Ix(r,c)^2 Ix(r,c)*Iy(r,c);Ix(r,c)*Iy(r,c) Iy(r,c)^2];
        b = [-Ix(r,c)*It(r,c);-Iy(r,c)*It(r,c)];
        result = ATA\b;
        if isnan(result(1)) || abs(result(1))>10
            result(1)=0;
        end
        if isnan(result(2)) || abs(result(2))>10
            result(2)=0;
        end        
        u(r,c) = result(1);
        v(r,c) = result(2);
    end
end

%% warp it

warpi2 = warp(double(img_1_red),u,v);
imshow(img_0_red)
figure
imshow(img_1_red)
figure
imshow(uint8(warpi2))



%% 4-a
levels = 4;
sigma = 2;
window = 5;
L = imread(fullfile('input\DataSeq1','yos_img_01.jpg'));
R = imread(fullfile('input\DataSeq1','yos_img_03.jpg'));
[u,v] = heirarchy(L,R,sigma,window,levels);

%%
warpi2 = warp(double(L),u,v);
imshow(L)
figure
imshow(uint8(warpi2))
figure
imshow(R)

%% 4-c
levels = 7;
sigma = 2;
window = 5;
L = rgb2gray(imread(fullfile('input\DataSeq2','0.png')));
R = rgb2gray(imread(fullfile('input\DataSeq2','2.png')));
[u,v] = heirarchy(L,R,sigma,window,levels);
warpi2 = warp(double(L),u,v);
imshow(L)
figure
imshow(uint8(warpi2))
figure
imshow(R)
%the stuff of nightmares
%%
L_pyramid = reduce(L,2,window,7);
R_pyramid = reduce(R,2,window,7);

imshow(uint8(L_pyramid{6}))
figure
imshow(uint8(R_pyramid{6}))