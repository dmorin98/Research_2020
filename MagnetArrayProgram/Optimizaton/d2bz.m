function d2bzdz = d2bz(x)
%x = [wrow hrow Zrow Yrow Z Y K] (1x15);

x = mapping(x);
wvec = x(1:3);
hvec = x(4:6);
Zvec = x(7:9);
Yvec = x(10:12);
Z = x(13);
Y = x(14);
K = x(15);
sol = zeros(1,3);
for i = 1:3
    sol(i) = K*((2*(Y-Yvec(i))*(Z-Zvec(i)-0.5*wvec(i)))/((Z-Zvec(i)-...
        0.5*wvec(i))^2+(Y-Yvec(i))^2)^2 - 2*(Y-Yvec(i))*(Z-Zvec(i)+...
        0.5*wvec(i))/((Z-Zvec(i)+0.5*wvec(i))^2+(Y-Yvec(i))^2)^2-...
        (2*(Y-Yvec(i)+hvec(i))*(Z-Zvec(i)-0.5*wvec(i)))/((Z-Zvec(i)-...
        0.5*wvec(i))^2+(Y-Yvec(i)+hvec(i))^2)^2+(2*(Y-Yvec(i)+hvec(i))*(Z-...
        Zvec(i)+0.5*wvec(i)))/((Z-Zvec(i)+0.5*wvec(i))^2+(Y-Yvec(i)+...
        hvec(i))^2)^2);
end

d2bzdz = sum(sol);
end