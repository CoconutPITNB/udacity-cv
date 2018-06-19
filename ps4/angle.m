function theta = angle(Ix,Iy)

theta = zeros(size(Ix));


theta = atan2(Iy,Ix);

end