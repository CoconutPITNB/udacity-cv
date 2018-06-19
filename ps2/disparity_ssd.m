function D = disparity_ssd(L, R)
    % Compute disparity map D(y, x) such that: L(y, x) = R(y, x + D(y, x))
    %
    % L: Grayscale left image
    % R: Grayscale right image, same size as L
    % D: Output disparity map, same size as L, R

    % TODO: Your code here
    
    tplrows =9;
    tplcols =9;
    
    %disparity matrix zero
    %for each row
        %for each pixel
            %find SSD vector for that pixel
        %find index of vector minimum for pixel
        %pixel disparity = index disparity
        %put disparity into disparity matrix
    
    
    D = zeros(size(L));
    %for each template window
    for r = ceil(tplrows/2):size(L,1)-floor(tplrows/2)
        for c = ceil(tplcols/2):size(L,2)-floor(tplcols/2)
            t = L(r-floor(tplrows/2):r+floor(tplrows/2),c-floor(tplcols/2):c+floor(tplcols/2)); %template window
            
            SSD = zeros(1,size(L,2)-tplcols+1); %SSD vec for each pixel in row
            
            %for each proposed location window on the ray
            for i = ceil(tplcols/2):size(L,2)-floor(tplcols/2)
                x = R(r-floor(tplrows/2):r+floor(tplrows/2),i-floor(tplcols/2):i+floor(tplcols/2));
                SSD(i-floor(tplcols/2)) = sum(sum((t - x).^2));
            [val,idx] = min(SSD);
            disparity = (idx+floor(tplcols/2))-c;
            D(r,c) = disparity;
            end
        end
    end
        
%     for i = 1:size(D,1)
%         for j = 1:size(D,2)
%             if D(i,j) > mean(D(:))+2*std(D(:))
%                 D(i,j) = mean(D(:));
%             end
%         end
%     end
    
    
    
    
end
