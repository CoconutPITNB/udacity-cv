function F_hat = fundamental(p,p_prime)


A = zeros(size(p,2),9);

for j = 1:size(A,1)
    u = p(1,j);
    v = p(2,j);
    u_prime = p_prime(1,j);
    v_prime = p_prime(2,j);
    A(j,:) = [u_prime*u u_prime*v u_prime v_prime*u v_prime*v v_prime u v 1];
end


[V D] = eig(A'*A,'vector');

[val idx] = min(D);

F = reshape(V(:,idx),[3,3])';


%reduce its rank
[U S V] = svd(F);
S_hat = S;
S_hat(end,end) = 0;
F_hat = U*S_hat*V';



end