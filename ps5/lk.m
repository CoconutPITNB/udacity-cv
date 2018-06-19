function [u v] = lk(img1,img2,sigma,window_size)
% 
% window_size = 3;
% sigma = 1;

[Ix,Iy] = gradients(img2,sigma,window_size);


h = fspecial('gaussian',window_size,sigma);
It = imfilter(double(img2-img1),h,'symmetric');


%solve for u and v over the image

u = zeros(size(img1));
v = zeros(size(img1));

for r = 1:size(img1,1)
    for c = 1:size(img1,2)
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

end