function R = harris(img,k,sigma)

alpha = 0.05; %for R calculation with trace of M
w = fspecial('gaussian',k,sigma); %weighting window
% fun =  @(u) imfilter(u,w,'symmetric');

%calculate gradients
[Ix,Iy] = gradients(img,k);

%calculate R for each pixel
R = zeros(size(img));

for r = ceil(k/2):size(img,1)-floor(k/2)
    for c = ceil(k/2):size(img,2)-floor(k/2)
        
        Ix_window = Ix(r-floor(k/2):r+floor(k/2),c-floor(k/2):c+floor(k/2));
                      
        Iy_window = Iy(r-floor(k/2):r+floor(k/2),c-floor(k/2):c+floor(k/2));
        
        %Ix^2 for each pixel in window
        Ix2_window = Ix_window.^2;
        %weight pixels in window based on gaussian and sum the window
        Ix2 = sum(sum(imfilter(Ix2_window,w,'symmetric')));
        
        %likewise for the Iy^2 values
        Iy2_window = Iy_window.^2;
        %weight pixels in window based on gaussian and sum the window
        Iy2 = sum(sum(imfilter(Iy2_window,w,'symmetric')));

        %likewise for the IxIy values
        IxIy_window = Ix_window.*Iy_window;
        %weight pixels in window based on gaussian and sum the window
        IxIy = sum(sum(imfilter(IxIy_window,w,'symmetric')));
        
        
        M = [Ix2 IxIy;IxIy Iy2];
        R(r,c) = det(M) - alpha*trace(M);
    end
end

end