function Bz = bz2(Z, Y, param, K)
% Bz = bz2(Z, Y, param, K)
% param = [wcol hcol Zcol Ycol] (3x4)
wvec = param(:,1);
hvec = param(:,2);
Zvec = param(:,3);
Yvec = param(:,4);
Bz = zeros(1,3);
for i = 1:3
    Bz(i) = -atan((Z-Zvec(i)-0.5*wvec(i))/(Y-Yvec(i)))+atan((Z-Zvec(i)+0.5*wvec(i))/(Y-Yvec(i)))...
        +atan((Z-Zvec(i)-0.5*wvec(i))/(Y-Yvec(i)+hvec(i)))-atan((Z-Zvec(i)+0.5*wvec(i))/(Y-Yvec(i)+hvec(i)));
end
Bz = K*sum(Bz);
end