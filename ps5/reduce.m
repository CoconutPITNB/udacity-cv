function g = reduce(img,sigma,window,levels)

g = cell(1,levels);
g{1} = img;
for i = 1:(levels-1)
    h = fspecial('gaussian',sigma,window);
    img_filt = imfilter(g{i},h,'symmetric');
    g{i+1} = img_filt(1:2:end,1:2:end);
end
end