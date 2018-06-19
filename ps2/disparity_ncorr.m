function D = disparity_ncorr(L, R)
    % Compute disparity map D(y, x) such that: L(y, x) = R(y, x + D(y, x))
    %
    % L: Grayscale left image
    % R: Grayscale right image, same size as L
    % D: Output disparity map, same size as L, R

    % TODO: Your code here
    
    
        
    tplrows =9;
    tplcols =9;
    
    D = zeros(size(L));
    %for each template window
    for r = ceil(tplrows/2):size(L,1)-floor(tplrows/2)
        for c = ceil(tplcols/2):size(L,2)-floor(tplcols/2)
            t = L(r-floor(tplrows/2):r+floor(tplrows/2),c-floor(tplcols/2):c+floor(tplcols/2)); %template window
            xcorr = normxcorr2(t,R);
            scanray = xcorr(r,:);
            [~,idx] = max(scanray);
            disparity = idx-c; % no idea
            D(r,c) = disparity;
        end
    
    end
        
    for i = 1:size(D,1)
        for j = 1:size(D,2)
            if D(i,j) > mean(D(:))+2*std(D(:))
                D(i,j) = mean(D(:));
            end
        end
    end
    
    
    
    
end
