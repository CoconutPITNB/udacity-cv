function hough_lines_draw(img, outfile, peaks, rho, theta)
    % Draw lines found in an image using Hough transform.
    %
    % img: Image on top of which to draw lines
    % outfile: Output image filename to save plot as
    % peaks: Qx2 matrix containing row, column indices of the Q peaks found in accumulator
    % rho: Vector of rho values, in pixels
    % theta: Vector of theta values, in degrees

    % TODO: Your code here
    polar = zeros(size(peaks));
    for i = 1:size(peaks,1)
        polar(i,:) = [rho(peaks(i,1))' theta(peaks(i,2))'];
    end
   
    for i = 1:size(polar,1)
        if polar(i,1)<0 && polar(i,2)<0
            polar(i,:) = abs(polar(i,:));
        end
    end
    
    imshow(img)
    hold on
    for  i = 1:size(polar,1)
        if ~polar(i,2)
            line([polar(i,1) polar(i,1)],[1 size(img,1)],'Color','blue');
        else
            y0 = (-cosd(polar(i,2))/sind(polar(i,2))) + (polar(i,1) / sind(polar(i,2)));
            
            yend = (-cosd(polar(i,2))/sind(polar(i,2)))*size(img,2) + (polar(i,1) / sind(polar(i,2)));
            
            line([1 size(img,2)],[y0 yend],'Color','blue');
            
        end
    end
    
    hold off
    saveas(gcf,outfile)
    
    
end
