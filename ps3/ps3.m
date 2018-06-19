%% PS3

%% 1-a setup

fileID = fopen(fullfile('input','pts2d-norm-pic_a.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

img_coords = reshape(A,[2,20]);

fileId = fopen(fullfile('input','pts3d-norm.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

world_coords = reshape(A,[3,20]);

%% 1-a

M = least_squares(img_coords,world_coords);

%% 1-a test

img_coords_est = M*[world_coords;ones(1,size(world_coords,2))];
for i = 1:size(img_coords_est,2)
    img_coords_est(1,i) = img_coords_est(1,i)/img_coords_est(3,i);
    img_coords_est(2,i) = img_coords_est(2,i)/img_coords_est(3,i);
end

ssd = norm(img_coords-img_coords_est(1:2,:),2)

%% 1-b setup

fileID = fopen(fullfile('input','pts2d-pic_a.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

img_coords = reshape(A,[2,20]);

fileId = fopen(fullfile('input','pts3d.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

world_coords = reshape(A,[3,20]);




%%



%% normalise?????
pic_a = rgb2gray(imread(fullfile('input','pic_a.jpg')));
img_center = [floor(size(pic_a,2)/2);floor(size(pic_a,1)/2)]; %[x,y]
img_coords_centered = img_coords-img_center;
img_coords_scaled = img_coords_centered./img_center;
img_coords = img_coords_scaled;
norms = [];
for i = 1:size(world_coords,2)
    norms = [norms norm(world_coords(:,i))];
end
[val longest] = max(norms);
for i = 1:size(world_coords,2)
    world_coords(:,i)=world_coords(:,i)/val;
end

    




%% 1-b
residuals = [];
ssd_best = 100;
for k = 8:4:16
    for trial = 1:10
        idx = randsample(size(img_coords,2),k);
        image_trial = img_coords(:,idx);
        world_trial = world_coords(:,idx);
        M = least_squares(image_trial,world_trial);
        
        img_coords_est = M*[world_coords;ones(1,size(world_coords,2))];
        for i = 1:size(img_coords_est,2)
            img_coords_est(1,i) = img_coords_est(1,i)/img_coords_est(3,i);
            img_coords_est(2,i) = img_coords_est(2,i)/img_coords_est(3,i);
        end

        idx_test = 1:20;
        for i = 1:length(idx)
            idx_test = idx_test(idx_test~=idx(i));
        end
        idx_test = randsample(idx_test,4);
        
        ssd = norm(img_coords(:,idx_test)-img_coords_est(1:2,idx_test),2);
        if ssd<ssd_best
            M_best = M;
            ssd_best = ssd;
        end
        residuals = [residuals ssd];
    end
end
        
M_best
        
        
        
%% 1-c

C = [-inv(M(:,1:3))*M(:,4);1];


%% 2-a

fileID = fopen(fullfile('input','pts2d-pic_a.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

img_a = reshape(A,[2,20]);

fileId = fopen(fullfile('input','pts2d-pic_b.txt'),'r');
A = fscanf(fileID,'%f');
fclose(fileID);

img_b = reshape(A,[2,20]);
        
pic_a = rgb2gray(imread(fullfile('input','pic_a.jpg')));
img_center = [floor(size(pic_a,2)/2);floor(size(pic_a,1)/2)]; %[x,y]
img_a_centered = img_a-img_center;
img_a_scaled = img_a_centered./img_center;
img_a = img_a_scaled;

pic_b = rgb2gray(imread(fullfile('input','pic_b.jpg')));
img_center = [floor(size(pic_b,2)/2);floor(size(pic_b,1)/2)]; %[x,y]
img_b_centered = img_b-img_center;
img_b_scaled = img_b_centered./img_center;
img_b = img_b_scaled;

%% fundamental matrix calcs (parts a & b)

F = fundamental(img_a,img_b)

%% c

p_ul = [-1 -1 1];
p_ur = [1 -1 1];
p_bl = [-1 1 1];
p_br = [1 1 1];

l_l = cross(p_ul,p_bl);
l_r = cross(p_ur,p_br);


%% b image
figure
%lines in b
lb = F*[img_a;ones(1,size(img_a,2))];
%intersections in b
int_b_left = zeros(3,20);
int_b_right = zeros(3,20);
for i = 1:size(lb,2)
    int_b_left(:,i) = cross(lb(:,i),l_l');
    int_b_right(:,i) = cross(lb(:,i),l_r');
end

%turning into imhomogeneous
for i = 1:size(int_b_left,2)
    int_b_left(1,i) = int_b_left(1,i)/int_b_left(3,i);
    int_b_left(2,i) = int_b_left(2,i)/int_b_left(3,i);
    int_b_right(1,i) = int_b_right(1,i)/int_b_right(3,i);
    int_b_right(2,i) = int_b_right(2,i)/int_b_right(3,i);
end

%turn into image points
%remember to use correct centers, etc
int_b_left_image = (int_b_left(1:2,:).*img_center)+img_center;
int_b_right_image = (int_b_right(1:2,:).*img_center)+img_center;

imshow(pic_b)
for i = 1:20
    line([1 size(pic_b,2)],[int_b_left_image(2,i) int_b_right_image(2,i)],'Color','blue');
end


%% a image

%lines in a
la = F'*[img_b;ones(1,size(img_b,2))];
%intersections in b
int_a_left = zeros(3,20);
int_a_right = zeros(3,20);
for i = 1:size(lb,2)
    int_a_left(:,i) = cross(la(:,i),l_l');
    int_a_right(:,i) = cross(la(:,i),l_r');
end

%turning into imhomogeneous
for i = 1:size(int_a_left,2)
    int_a_left(1,i) = int_a_left(1,i)/int_a_left(3,i);
    int_a_left(2,i) = int_a_left(2,i)/int_a_left(3,i);
    int_a_right(1,i) = int_a_right(1,i)/int_a_right(3,i);
    int_a_right(2,i) = int_a_right(2,i)/int_a_right(3,i);
end

%turn into image points
%remember to use correct centers, etc
int_a_left_image = (int_a_left(1:2,:).*img_center)+img_center;
int_a_right_image = (int_a_right(1:2,:).*img_center)+img_center;

imshow(pic_a)
for i = 1:20
    line([1 size(pic_a,2)],[int_a_left_image(2,i) int_a_right_image(2,i)],'Color','blue');
end


%% fookin stoked aye