%% PS4

%% 1-a

transA = imread(fullfile('input','transA.jpg'));
simA = imread(fullfile('input','simA.jpg'));

[Ix_simA,Iy_simA] = gradients(transA,3);

[Ix_simA,Iy_simA] = gradients(simA,3);

Ix_transA_gray = mat2gray(Ix_simA);
Iy_transA_gray = mat2gray(Iy_simA);

Ix_simA_gray = mat2gray(Ix_simA);
Iy_simA_gray = mat2gray(Iy_simA);

figure
montage([Ix_transA_gray,Iy_transA_gray]);
saveas(gcf,'output/ps4-1-a-1.png');

montage([Ix_simA_gray,Iy_simA_gray]);
saveas(gcf,'output/ps4-1-a-2.png');


%% 1-b & 1-c

%% Corner detection for transA

transA = imread(fullfile('input','transA.jpg'));

R_transA = harris(transA,3,1);

threshold = 100000;
k = 15;
features_transA = suppress(R_transA,k,threshold);

[r c] = find(features_transA==1);
img_features = insertMarker(transA,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-1.png'));



%% Corner detection for transB

transB = imread(fullfile('input','transB.jpg'));

R_transB = harris(transB,3,1);

threshold = 100000;
k = 15;
features_transB = suppress(R_transB,k,threshold);

[r c] = find(features_transB==1);
img_features = insertMarker(transB,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-2.png'));


%% Corner detection for simA

simA = imread(fullfile('input','simA.jpg'));

R_simA = harris(simA,3,1);

threshold = 50000;
k = 11;
features_simA = suppress(R_simA,k,threshold);

[r c] = find(features_simA==1);
img_features = insertMarker(simA,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-3.png'));

%% Corner detection for simB

simB = imread(fullfile('input','simB.jpg'));

R_simB = harris(simB,3,1);

threshold = 50000;
k = 11;
features_simB = suppress(R_simB,k,threshold);

[r c] = find(features_simB==1);
img_features = insertMarker(simB,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-4.png'));







%% 2-a


%% transA

[Ix_simA,Iy_simA] = gradients(transA,3);

[r_simA c_simA] = find(features_transA==1);

Ix_features = zeros(length(r_simA),1);
Iy_features = zeros(length(r_simA),1);

for i = 1:length(r_simA)
    Ix_features(i) = Ix_simA(r_simA(i),c_simA(i));
    Iy_features(i) = Iy_simA(r_simA(i),c_simA(i));
end

theta_simA = atan2(Iy_features,Ix_features);

magnitudes_simA = sqrt(Ix_features.^2 + Iy_features.^2);

imshow(transA)
hold on
for i = 1:length(r_simA)
    x_start=c_simA(i);
    y_start=r_simA(i);
    x_end=c_simA(i)+cos(theta_simA(i)).*magnitudes_simA(i);
    y_end=r_simA(i)+sin(theta_simA(i)).*magnitudes_simA(i);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off


%% transB

[Ix_simB,Iy_simB] = gradients(transB,3);

[r_simB c_simB] = find(features_transB==1);

Ix_features = zeros(length(r_simB),1);
Iy_features = zeros(length(r_simB),1);

for i = 1:length(r_simB)
    Ix_features(i) = Ix_simB(r_simB(i),c_simB(i));
    Iy_features(i) = Iy_simB(r_simB(i),c_simB(i));
end

theta_sim = atan2(Iy_features,Ix_features);

magnitudes_simB = sqrt(Ix_features.^2 + Iy_features.^2);

imshow(transB)
hold on
for i = 1:length(r_simB)
    x_start=c_simB(i);
    y_start=r_simB(i);
    x_end=c_simB(i)+cos(theta_sim(i)).*magnitudes_simB(i);
    y_end=r_simB(i)+sin(theta_sim(i)).*magnitudes_simB(i);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off


%% Feature matching
% Now we have the locations and gradient vectors for all feature points

mod_simA = sqrt(Ix_simA.^2 + Iy_simA.^2);
ang_simA = atan2(Iy_simA,Ix_simA);
grd_simA = shiftdim(cat(3,mod_simA,ang_simA),2);
grd_simA = single(grd_simA);
f_simA = [c_simA';r_simA';ones(1,length(c_simA));theta_simA']; 
d_simA = vl_siftdescriptor(grd_simA,f_simA);

mod_simB = sqrt(Ix_simB.^2 + Iy_simB.^2);
ang_simB = atan2(Iy_simB,Ix_simB);
grd_simB = shiftdim(cat(3,mod_simB,ang_simB),2);
grd_simB = single(grd_simB);
f_simB = [c_simB';r_simB';ones(1,length(c_simB));theta_sim']; 
d_simB = vl_siftdescriptor(grd_simB,f_simB);

[matches_sim scores_sim] = vl_ubcmatch(d_simA,d_simB);

%% lets draw some fucking lines!
% aww yiss, lines!
sim = [transA,transB];
imshow(sim)
hold on
for i = 1:size(matches_sim,2)
% for i = 1
    A = matches_sim(1,i);
    B = matches_sim(2,i);
    x_start=f_simA(1,A);
    y_start=f_simA(2,A);
    x_end=size(transA,2)+f_simB(1,B);
    y_end=f_simB(2,B);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off

% well that looks fucking disgusting

%% RANSAC for translation %well fuck theyve all been changed to simA and B.
concensus_best = 0;
pair_best = 1;

for i = 1:length(pair)
    %calculate proposed offsets based on single pair
    test_pair = matches_sim(:,i);
    x_simA = f_simA(1,test_pair(1));
    x_simB = f_simB(1,test_pair(2));
    x_offset = x_simB-x_simA;
    y_simA = f_simA(2,test_pair(1));
    y_simB = f_simB(2,test_pair(2));
    y_offset = y_simB-y_simA;
    
    %stipulate allowed tolerance to join concensus
    %lets say within 10 px in either direction
    tol = 10;
    concensus = 0;
    concensus_vector = [];
    for j = 1:size(matches_sim,2)
        %for each match
        test_pair = matches_sim(:,j);
        %proposed x and y position in transB
        % = x in transA for pair + x translation
        % = y in transA for pair + y translation
        x_transB_proposed = f_simA(1,test_pair(1))+x_offset;
        y_transB_proposed = f_simA(2,test_pair(1))+y_offset;
        %actual x and y position in transB
        % = x in transB for pair
        % = y in transB for pair
        x_simB_actual = f_simB(1,test_pair(2));
        y_simB_actual = f_simB(2,test_pair(2));
        if abs(x_simB_actual-x_transB_proposed)<tol && abs(y_simB_actual-y_transB_proposed)<tol
            concensus=concensus+1;
            concensus_vector = [concensus_vector j];
        end
    end
    if concensus > concensus_best
        concensus_best = concensus;
        concensus_vector_best = concensus_vector;
        pair_best = i;
        x_offset_best = x_offset;
        y_offset_best = y_offset;
    end
    
    
end


pair_draw = matches_sim(:,pair_best);

% now lets draw lines using the best pair
sim = [transA,transB];
imshow(sim)
hold on
%for each match in concensus set!
for i = 1:size(matches_sim,2)
    if ismember(i,concensus_vector_best)
        %feature in A
        A = matches_sim(1,i);
        %feature in B
        B = matches_sim(2,i);
        %x start is column of feature A
        x_start=f_simA(1,A);
        %y start is row of feature in A
        y_start=f_simA(2,A);
        %x end is column of feature in A + best offset + columns of A
        x_end=size(transA,2)+x_start+x_offset_best;
        %y end is row of feature in A + best offset
        y_end=y_start+y_offset_best;
        if i==pair_best
            line([x_start x_end],[y_start y_end],'Color','red');
        else
            line([x_start x_end],[y_start y_end],'Color','green');
        end
    end
end
hold off



%% 2-a


%%%%%%%%%%%%%%%%%%%%%


% Everything for the similarity images %


%%%%%%%%%%%%%%%%%%%%%%


%% simA Gradients
simA = imread(fullfile('input','simA.jpg'));
[Ix_simA,Iy_simA] = gradients(simA,3);


%% Corner detection for simA

R_simA = harris(simA,3,1);

threshold = 100000;
k = 11;
features_simA = suppress(R_simA,k,threshold);

[r c] = find(features_simA==1);
img_features = insertMarker(simA,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-3.png'));


%% simA angles and mags

[r_simA c_simA] = find(features_simA==1);

Ix_features = zeros(length(r_simA),1);
Iy_features = zeros(length(r_simA),1);

for i = 1:length(r_simA)
    Ix_features(i) = Ix_simA(r_simA(i),c_simA(i));
    Iy_features(i) = Iy_simA(r_simA(i),c_simA(i));
end

theta_simA = atan2(Iy_features,Ix_features);

magnitudes_simA = sqrt(Ix_features.^2 + Iy_features.^2);

imshow(simA)
hold on
for i = 1:length(r_simA)
    x_start=c_simA(i);
    y_start=r_simA(i);
    x_end=c_simA(i)+cos(theta_simA(i)).*magnitudes_simA(i);
    y_end=r_simA(i)+sin(theta_simA(i)).*magnitudes_simA(i);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off


%% simB Gradients
simB = imread(fullfile('input','simB.jpg'));
[Ix_simB,Iy_simB] = gradients(simB,3);



%% Corner detection for simB

simB = imread(fullfile('input','simB.jpg'));

R_simB = harris(simB,3,1);

threshold = 100000;
k = 11;
features_simB = suppress(R_simB,k,threshold);

[r c] = find(features_simB==1);
img_features = insertMarker(simB,[c r],'+');
imshow(img_features)
imwrite(img_features,fullfile('output','ps4-1-c-4.png'));


%% simA angle and mags

[r_simB c_simB] = find(features_simB==1);

Ix_features = zeros(length(r_simB),1);
Iy_features = zeros(length(r_simB),1);

for i = 1:length(r_simB)
    Ix_features(i) = Ix_simB(r_simB(i),c_simB(i));
    Iy_features(i) = Iy_simB(r_simB(i),c_simB(i));
end

theta_sim = atan2(Iy_features,Ix_features);

magnitudes_simB = sqrt(Ix_features.^2 + Iy_features.^2);

imshow(simB)
hold on
for i = 1:length(r_simB)
    x_start=c_simB(i);
    y_start=r_simB(i);
    x_end=c_simB(i)+cos(theta_sim(i)).*magnitudes_simB(i);
    y_end=r_simB(i)+sin(theta_sim(i)).*magnitudes_simB(i);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off


%% Feature matching for simA and simB
% Now we have the locations and gradient vectors for all feature points

mod_simA = sqrt(Ix_simA.^2 + Iy_simA.^2);
ang_simA = atan2(Iy_simA,Ix_simA);
grd_simA = shiftdim(cat(3,mod_simA,ang_simA),2);
grd_simA = single(grd_simA);
f_simA = [c_simA';r_simA';ones(1,length(c_simA));theta_simA']; 
d_simA = vl_siftdescriptor(grd_simA,f_simA);

mod_simB = sqrt(Ix_simB.^2 + Iy_simB.^2);
ang_simB = atan2(Iy_simB,Ix_simB);
grd_simB = shiftdim(cat(3,mod_simB,ang_simB),2);
grd_simB = single(grd_simB);
f_simB = [c_simB';r_simB';ones(1,length(c_simB));theta_sim']; 
d_simB = vl_siftdescriptor(grd_simB,f_simB);

matches_sim = vl_ubcmatch(d_simA,d_simB);

%% lets draw some fucking lines!
% aww yiss, lines!
sim = [simA,simB];
imshow(sim)
hold on
for i = 1:size(matches_sim,2)
% for i = 1
    A = matches_sim(1,i);
    B = matches_sim(2,i);
    x_start=f_simA(1,A);
    y_start=f_simA(2,A);
    x_end=size(simA,2)+f_simB(1,B);
    y_end=f_simB(2,B);
    line([x_start x_end],[y_start y_end],'Color','green');
end
hold off

% well that looks fucking disgusting

%% RANSAC for similarity
concensus_best = 0;
combos = nchoosek(1:size(matches_sim,2),2);

for i = 1:size(combos,1)
    %calculate proposed sim transform (M) based on 2 pairs
    % [u v] =[x val of point in A for match, y val of point in A for match]
    %first pair, first image point
    u1 = f_simA(1,matches_sim(1,combos(i,1)));
    v1 = f_simA(2,matches_sim(1,combos(i,1)));
    %first pair, second image point
    u1_p = f_simB(1,matches_sim(2,combos(i,1)));
    v1_p = f_simB(2,matches_sim(2,combos(i,1)));
    %second pair, first image point
    u2 = f_simA(1,matches_sim(1,combos(i,2)));
    v2 = f_simA(2,matches_sim(1,combos(i,2)));
    %second pair, second image point
    u2_p = f_simB(1,matches_sim(2,combos(i,2)));
    v2_p = f_simB(2,matches_sim(2,combos(i,2)));
   
    A = [u1,-v1,1,0;
         v1, u1,0,1;
         u2,-v2,1,0;
         v2, u2,0,1];
     
    x = A\[u1_p;v1_p;u2_p;v2_p];
    a = x(1);
    b = x(2);
    c = x(3);
    d = x(4);
    M = [a -b c; b a d];
     
    
    %stipulate allowed tolerance to join concensus
    %lets say within 10 px in either direction
    tol = 10;
    concensus = 0;
    concensus_vector = [];
    for j = 1:size(matches_sim,2)
        %for each match; test_pair(1) will be feature in image A
        % test_pair(2) will be feature in image B
        test_pair = matches_sim(:,j);
        %proposed x and y position in simB
        % = proposed M*point in simA
        uv_prime_proposed = M*[f_simA(1:2,test_pair(1));1];
        %actual x and y position in simB
        % = x in simB for pair
        % = y in simB for pair
        uv_prime_actual = f_simB(1:2,test_pair(2));
        if norm(uv_prime_actual-uv_prime_proposed)<tol
            concensus=concensus+1;
            concensus_vector = [concensus_vector j];
        end
    end
    if concensus > concensus_best
        concensus_best = concensus;
        concensus_vector_best = concensus_vector;
        pair_best = i;
        M_best = M;
    end
    
    
end

% now lets draw lines using the best combo
sim = [simA,simB];
imshow(sim)
hold on
%for each match in concensus set!
for i = 1:size(matches_sim,2)
    if ismember(i,concensus_vector_best)
        %feature in A
        A = matches_sim(1,i);
        %feature in B
        B = matches_sim(2,i);
        %x start is column of feature A
        x_start=f_simA(1,A);
        %y start is row of feature in A
        y_start=f_simA(2,A);
        
        uv_end = M_best*[x_start;y_start;1];
        x_end = size(transA,2)+uv_end(1);
        y_end = uv_end(2);
        
        if i==combos(pair_best,1) || i==combos(pair_best,2)
            line([x_start x_end],[y_start y_end],'Color','red');
        else
            line([x_start x_end],[y_start y_end],'Color','green');
        end
    end
end
hold off