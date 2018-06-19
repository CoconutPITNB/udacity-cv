function [warpI2]=warp(i2,u,v) 
    % warp i2 according to flow field in u v 
    % this is a "backwards" warp: 
    % if u,v are correct then warpI2==i1
    [M,N]=size(i2);
    [x,y]=meshgrid(1:N,1:M);
    %use Matlab interpolation routine
    warpI3=interp2(x,y,i2,x+u,y+v,'nearest');
    %use Matlab interpolation routine
    warpI2=interp2(x,y,i2,x+u,y+v,'linear');
    I=find(isnan(warpI2));
    warpI2(I)=warpI3(I);
    I=find(warpI2==0);
    warpI2(I)=warpI3(I);
        
end