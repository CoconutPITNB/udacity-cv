% ps1

%% 1-a
img = imread(fullfile('input', 'ps1-input0.png'));  % already grayscale
%% TODO: Compute edge image img_edges
img_edges = edge(img,'canny');

imwrite(img_edges, fullfile('output', 'ps1-1-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-a
[H, theta, rho] = hough_lines_acc(img_edges,3);  % defined in hough_lines_acc.m
%% TODO: Plot/show accumulator array H, save as output/ps1-2-a-1.png
H_gray = uint8(255 * mat2gray(H));
imshow(H_gray)
imwrite(H_gray, fullfile('output', 'ps1-2-a-1.png'));  % save as output/ps1-2-a-1.png

%% 2-b
peaks = hough_peaks(H, 10);  % defined in hough_peaks.m
%% TODO: Highlight peak locations on accumulator array, save as output/ps1-2-b-1.png
invpeaks = [peaks(:,2) peaks(:,1)];
H_peaks = insertMarker(H_gray,invpeaks,'s','size',10);
imwrite(H_peaks,fullfile('output','ps1-2-b-1.png'));
imshow(H_peaks)

%% TODO: Rest of your code here


hough_lines_draw(img,'ps1-2-c-1.png', peaks, rho, theta)

img_hough = imread('ps1-2-c-1.png');
imshow(img_hough)

%% 3-a
img_noisy = imread(fullfile('input','ps1-input0-noise.png'));
figure
imshow(img_noisy)
h = fspecial('gaussian',15,5);
img_filt = imfilter(img_noisy,h,'symmetric');
figure
imshow(img_filt)
imwrite(img_filt,fullfile('output','ps1-3-a-1.png'));

%% 3-b
noisy_edges = edge(img_noisy,'canny');
smooth_edges = edge(img_filt,'canny');
imshow(noisy_edges)
figure
imshow(smooth_edges)
imwrite(noisy_edges,fullfile('output','ps1-3-b-1.png'));
imwrite(smooth_edges,fullfile('output','ps1-3-b-2.png'));

%% 3-c

[H, theta, rho] = hough_lines_acc(smooth_edges,3);  % defined in hough_lines_acc.m
H_gray = uint8(255 * mat2gray(H));
imshow(H_gray)
%%
peaks = hough_peaks(H, 10);  % defined in hough_peaks.m
invpeaks = [peaks(:,2) peaks(:,1)];
H_peaks = insertMarker(H_gray,invpeaks,'s','size',10);
imwrite(H_peaks,fullfile('output','ps1-3-c-1.png'));
imshow(H_peaks)
%%
hough_lines_draw(img_noisy,'ps1-3-c-2.png', peaks, rho, theta)
img_hough = imread('ps1-3-c-2.png');
imshow(img_hough)



%% fuck this shit

%% 4-a

img = imread(fullfile('input','ps1-input1.png'));
imshow(img)
img = rgb2gray(img);
imshow(img)
h = fspecial('gaussian',21,7);
img = imfilter(img,h,'symmetric');
imshow(img)
img_edges = edge(img,'canny');
figure
imshow(img_edges)
%%
[H, theta, rho] = hough_lines_acc(img_edges,3);  % defined in hough_lines_acc.m

H_gray = uint8(255 * mat2gray(H));
imshow(H_gray)
imwrite(H_gray, fullfile('output', 'ps1-4-c-1.png'));  % save as output/ps1-2-a-1.png
%%
peaks = hough_peaks(H, 10);  % defined in hough_peaks.m
invpeaks = [peaks(:,2) peaks(:,1)];
H_peaks = insertMarker(H_gray,invpeaks,'s','size',10);
imwrite(H_peaks,fullfile('output','ps1-4-c-2.png'));
imshow(H_peaks)
%%
hough_lines_draw(img,'ps1-4-c-3.png', peaks, rho, theta)

img_hough = imread('ps1-4-c-3.png');
imshow(img_hough)







%% 5-a


img = imread(fullfile('input','ps1-input1.png'));
imshow(img)
img = rgb2gray(img);
imshow(img)
h = fspecial('gaussian',19,6);
img = imfilter(img,h,'symmetric');
imshow(img)
img_edges = edge(img,'canny');
figure
imshow(img_edges)



%%

[centers, radii] = find_circles(img_edges, [20 50]);

canny_edges = uint8(255 * mat2gray(img_edges));

invpeaks = [centers(:,2) centers(:,1)];
canny_edges = insertMarker(canny_edges,invpeaks,'s','size',10);
imshow(canny_edges)