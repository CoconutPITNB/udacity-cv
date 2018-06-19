function [centers, radii] = find_circles(BW, radius_range)
    % Find circles in given radius range using Hough transform.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius_range: Range of circle radii [min max] to look for, in pixels

    % TODO: Your code here
    
    %%
    %peaks matrix has votes for each peak in at each scale and the location
    numpeaks = 10;
    peaks_matrix = zeros((radius_range(2)-radius_range(1))*numpeaks,4);
    
    for i = 1:radius_range(2)-radius_range(1)+1
        current_radius = i+radius_range(1)-1;
        H = hough_circles_acc(BW,current_radius,3);  % defined in hough_lines_acc.m
        H_gray = uint8(255 * mat2gray(H));
        imshow(H_gray)
        imwrite(H_gray, fullfile('output', 'ps1-4-c-1.png'));  % save as output/ps1-2-a-1.png

        %%
        peaks = hough_peaks(H, numpeaks);  % defined in hough_peaks.m
        invpeaks = [peaks(:,2) peaks(:,1)];
        H_peaks = insertMarker(H_gray,invpeaks,'s','size',10);
        imwrite(H_peaks,fullfile('output','ps1-4-c-2.png'));
        imshow(H_peaks)
    
        norm_votes = zeros(numpeaks,1);
        for j = 1:numpeaks
%             norm_votes(j) = (H(peaks(j,1),peaks(j,2))-min(H(:)))/(max(H(:))-min(H(:)));
            norm_votes(j) = H(peaks(j,1),peaks(j,2));
        end
        
        peaks_matrix(numpeaks*(i-1)+1:numpeaks*(i-1)+numpeaks,:)=[norm_votes peaks ones(numpeaks,1)*current_radius];
    
    end 
    
    peaks_matrix = sortrows(peaks_matrix,'descend');
    if size(peaks_matrix,1)>numpeaks
        peaks_matrix = peaks_matrix(1:numpeaks,:)
    end
    
    
    centers = peaks_matrix(:,2:3);
    radii = peaks_matrix(:,4);
    
end
