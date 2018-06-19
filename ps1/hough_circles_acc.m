function H = hough_circles_acc(BW, radius_, bin_width)
    % Compute Hough accumulator array for finding circles.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius: Radius of circles to look for, in pixels

    % TODO: Your code here 
    
    H = zeros(size(BW));
    for r = 1:size(BW,1)
        for c = 1:size(BW,2)
%             fprintf('pixel %i,%i \n',[r c])
            if BW(r,c)
                for radius = radius_ %pixels
                    if r-radius<=0 && c-radius<=0 %top left
%                         fprintf('top left\n')
                        for j = 1:c+radius
                            for i = 1:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                                    
                    elseif r-radius<=0 && c+radius>size(H,2) %top right
%                         fprintf('top right\n')
                        for j = c-radius:size(H,2)
                            for i = 1:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;   
                                end
                            end
                        end
                        
                    elseif r+radius>size(H,1) && c-radius<=0 %bottom left
%                         fprintf('bottom left\n')
                        for j = 1:c+radius
                            for i = r-radius:size(H,1)
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                        
                    elseif r+radius>size(H,1) && c+radius>size(H,2) %bottom right
%                         fprintf('bottom right\n')
                        for j = c-radius:size(H,2)
                            for i = r-radius:size(H,1)
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                        
                    elseif r-radius<=0 %top edge
%                         fprintf('top edge\n')
                        for j = c-radius:c+radius
                            for i = 1:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end                        
                            
                    elseif r+radius>size(H,1) %bottom edge
%                         fprintf('bottom edge\n')
                        for j = c-radius:c+radius
                            for i = r-radius:size(H,1)
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end                        
                        
                    elseif c-radius<=0 %left edge
%                         fprintf('left edge\n')
                        for j = 1:c+radius
                            for i = r-radius:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                        
                    elseif c+radius>size(H,2) %right edge
%                         fprintf('right edge\n')
                        for j = c-radius:size(H,2)
                            for i = r-radius:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                        
                    else
%                         fprintf('normal\n')
                        for j = c-radius:c+radius
                            for i = r-radius:r+radius
                                if (j-c)^2 + (i-r)^2 == radius^2
                                    H(i,j)=H(i,j)+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end


    
    
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

