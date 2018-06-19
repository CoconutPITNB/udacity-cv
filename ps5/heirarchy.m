function [u,v] = heirarchy(L,R,sigma,window,levels)

L_pyramid = reduce(L,sigma,window,levels);
R_pyramid = reduce(R,sigma,window,levels);

u_pyramid = cell(size(L_pyramid));
v_pyramid = cell(size(L_pyramid));

u_pyramid{levels} = zeros(size(L_pyramid{levels}));
v_pyramid{levels} = zeros(size(L_pyramid{levels}));

for i = levels:-1:1
    if i~=levels
        u_temp = expand(u_pyramid{i+1},sigma,window,2);
        u_pyramid{i} = 2.*u_temp{2};
        v_temp = expand(v_pyramid{i+1},sigma,window,2);
        v_pyramid{i} = 2.*v_temp{2};
    end
    Wk = warp(double(L_pyramid{i}),...
                     u_pyramid{i}(1:size(L_pyramid{i},1),1:size(L_pyramid{i},2)),...
                     v_pyramid{i}(1:size(L_pyramid{i},1),1:size(L_pyramid{i},2)));
    sigma_lk = 2;
    window_lk = 5;
    [du,dv] = lk(double(Wk),double(R_pyramid{i}),sigma_lk,window_lk);
    u_pyramid{i} = u_pyramid{i}(1:size(L_pyramid{i},1),1:size(L_pyramid{i},2))+du;
    v_pyramid{i} = v_pyramid{i}(1:size(L_pyramid{i},1),1:size(L_pyramid{i},2))+dv;
    
    
    
end

u = u_pyramid{1};
v = v_pyramid{1};










end