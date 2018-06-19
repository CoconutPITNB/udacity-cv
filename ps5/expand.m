function g = expand(img,sigma,window,levels)

g = cell(1,levels);
g{1} = img;
for i = 1:(levels-1)
% for i =1
    img_expand = zeros(size(g{i})*2);
    img_expand(1:2:end,1:2:end)=g{i};
    h = fspecial('gaussian',window,sigma);
    img_expand = imfilter(img_expand,h,'symmetric')*4;
    g{i+1} = img_expand;
end

end