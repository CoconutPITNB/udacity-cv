function [H, theta, rho] = hough_lines_acc(BW, bin_width, varargin)
    % Compute Hough accumulator array for finding lines.
    %
    % BW: Binary (black and white) image containing edge pixels
    % RhoResolution (optional): Difference between successive rho values, in pixels
    % Theta (optional): Vector of theta values to use, in degrees
    %
    % Please see the Matlab documentation for hough():
    % http://www.mathworks.com/help/images/ref/hough.html
    % Your code should imitate the Matlab implementation.
    %
    % Pay close attention to the coordinate system specified in the assignment.
    % Note: Rows of H should correspond to values of rho, columns those of theta.

    %% Parse input arguments
    p = inputParser();
    addParameter(p, 'RhoResolution', 1);
    addParameter(p, 'Theta', linspace(-90, 89, 180));
    parse(p, varargin{:});

    rhoStep = p.Results.RhoResolution;
    theta = p.Results.Theta;

    %% TODO: Your code here
    diagonal = round(sqrt(size(BW,1)^2 + size(BW,2)^2));
    rho = -diagonal:rhoStep:diagonal;
    H = zeros(length(rho),length(theta));
    for r = 1:size(BW,1)
        for c = 1:size(BW,2)
            if BW(r,c)
                for k = 1:length(theta)
                    d = c*cosd(theta(k)) + r*sind(theta(k));
                    d = round(d);
                    index = find(d == rho);
                    H(index,k)=H(index,k)+1;
                end
            end
        end
    end
    
    
    % Maybe using gaussian smoothing on the hough array will help
%     g = fspecial('gaussian',3,1);
%     H = imfilter(H,g,'symmetric');
    
    
    % at the moments the bin size is 1 pixel, I'm going to change that to
    % have a bin size of 9 pixels so the centre pixel will be the sum of 
    % votes in the surrounding pixels and itself. Then the surrounds will
    % be set to zero.
    edge = floor(bin_width/2);
    center = ceil(bin_width/2);
    
    for r = center:bin_width:size(H,1)
        for c = center:bin_width:size(H,2)
            if (r+edge)>size(H,1) && (c-edge)<1 %bottom left
                new_bottom = size(H,1)-r;
                bin_sum = sum(sum(H(r-edge:r+new_bottom,c:c+edge)))+sum(sum(H(r-edge:r+new_bottom,size(H,2)-edge+1:size(H,2))));
                H(r-edge:r+new_bottom,c:c+edge)=0;
                H(r-edge:r+new_bottom,size(H,2)-edge+1:size(H,2))=bin_sum;
                H(r,c)=bin_sum;
            elseif (r+edge)>size(H,1) && (c+edge)>size(H,2) %bottom right
                new_right = size(H,2)-c;
                new_bottom = size(H,1)-r;
                bin_sum = sum(sum(H(r-edge:r+new_bottom,c-edge:c+new_right)));
                H(r-edge:r+new_bottom,c-edge:c+new_right)=bin_sum;
                H(r,c)=bin_sum;
            elseif (c+edge)>size(H,2) %right side
                new_right = size(H,2)-c;
                bin_sum = sum(sum(H(r-edge:r+edge,c-edge:c+new_right)));
                H(r-edge:r+edge,c-edge:c+new_right)=bin_sum;
                H(r,c)=bin_sum;
            elseif (c-edge)<1 %left side
                bin_sum = sum(sum(H(r-edge:r+edge,c:c+edge)))+sum(sum(H(r-edge:r+edge,size(H,2)-edge+1:size(H,2))));
                H(r-edge:r+edge,c:c+edge)=0;
                H(r-edge:r+edge,size(H,2)-edge+1:size(H,2))=bin_sum;
                H(r,c)=bin_sum;
            elseif (r+edge)>size(H,1) %bottom
                new_bottom = size(H,1)-r;
                bin_sum = sum(sum(H(r-edge:r+new_bottom,c-edge:c+edge)));
                H(r-edge:r+new_bottom,c-edge:c+edge)=bin_sum;
                H(r,c)=bin_sum;
            else %everywhere else
                bin_sum = sum(sum(H(r-edge:r+edge,c-edge:c+edge)));
                H(r-edge:r+edge,c-edge:c+edge)=bin_sum;
                H(r,c)=bin_sum;
        end
    end
        
        
        
    
end
