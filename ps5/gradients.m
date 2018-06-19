function [dIdx,dIdy] = gradients(img,sigma,window)

%convert rgb image to greyscale
% img_gray = rgb2gray(img);

%set our sigma for both directions to 1*support value (k)
% sigma = 2;

%define kernel filter (derivative of gaussian)
h = fspecial('gaussian',window,sigma);
[gx,gy] = gradient(h);

%apply the filters to compute image derivatives
dIdx = imfilter(double(img),gx,'symmetric');
dIdy = imfilter(double(img),gy,'symmetric');

end