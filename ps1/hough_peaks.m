function peaks = hough_peaks(H, varargin)
    % Find peaks in a Hough accumulator array.
    %
    % Threshold (optional): Threshold at which values of H are considered to be peaks
    % NHoodSize (optional): Size of the suppression neighborhood, [M N]
    %
    % Please see the Matlab documentation for houghpeaks():
    % http://www.mathworks.com/help/images/ref/houghpeaks.html
    % Your code should imitate the matlab implementation.

    %% Parse input arguments
    p = inputParser;
    addOptional(p, 'numpeaks', 1, @isnumeric);
    addParameter(p, 'Threshold', 0.5 * max(H(:)));
    addParameter(p, 'NHoodSize', floor(size(H) / 100.0) *2 + 1);  % odd values >= size(H)/50
    parse(p, varargin{:});

    numpeaks = p.Results.numpeaks;
    threshold = p.Results.Threshold;
    nHoodSize = p.Results.NHoodSize;

    % TODO: Your code here
    
    % this sorts the Hough by votes, finds unique values, and then sorts
    % again in descending order
    votes = sort(H(:),'descend');
    votes = unique(votes,'rows');
    votes = sort(votes,'descend');
    
    
    % this deletes entries in the votes array that fall below threshold
    to_delete = false(1,length(votes));
    for i = 1:length(votes)
        if votes(i)<threshold
            to_delete(i) = true;
        end
    end
    votes(to_delete)=[];
    
    % this finds the indices in the Hough that have the values given in the
    % votes array
    peaks = [];
    for i = 1:length(votes)
        [r c] = find(H==votes(i));
        peaks = [peaks;r c];
    end
    
    % this deletes entries in the subpeaks indices matrix that are in the 
    % same neighbourhood as bigger peaks (non-maximal supression)
    for i = 1:numpeaks
        to_delete = false(1,length(peaks));
        for j = (i+1):size(peaks,1)
            if abs(peaks(i,1)-peaks(j,1))<nHoodSize(1) && abs((peaks(i,2)-peaks(j,2)))<nHoodSize(2)
                to_delete(j)=true;
            end
        end
        peaks(to_delete,:)=[];
    end
    
    % this simply chooses the top 10, isolated peaks.
    if size(peaks,1)>numpeaks
        peaks = peaks(1:numpeaks,:);
    end
    
    
    
    
    
        
    
end
