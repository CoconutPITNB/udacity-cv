function M = least_squares(image_coords,world_coords)


A = zeros(2*size(image_coords,2),12);

for j = 1:2:size(A,1)
    idx = ceil(j/2);
    X = world_coords(1,idx);
    Y = world_coords(2,idx);
    Z = world_coords(3,idx);
    u = image_coords(1,idx);
    v = image_coords(2,idx);
    A(j:j+1,:) = [X Y Z 1 0 0 0 0 -u*X -u*Y -u*Z -u;
                  0 0 0 0 X Y Z 1 -v*X -v*Y -v*Z -v];
end



[V D] = eig(A'*A,'vector');

[val idx] = min(D);

M = reshape(V(:,idx),[4,3])';

end