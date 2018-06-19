function logic_best = suppress(R,k,threshold)

%apply threshold to R
R_best = R.*(R>threshold);

%for each window, find the maximum value, suppress the rest
logic_best = zeros(size(R_best));

for r = ceil(k/2):size(R_best,1)-floor(k/2)
    for c = ceil(k/2):size(R_best,2)-floor(k/2)
        R_window = R_best(r-floor(k/2):r+floor(k/2),c-floor(k/2):c+floor(k/2));
        maxim = max(max(R_window));
        if R_best(r,c)==maxim && maxim~=0
            logic_best(r,c)=1;
    end
end

end