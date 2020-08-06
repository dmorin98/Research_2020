function Bz = dbz2(x)
%dBz = dbz2(K, Z, Y, parameters)
%parameters = [wcolumn, hcolumn, Zcolumn, Ycolumn]. 3x4 matrix.
%K, Z, Y, scalar
x = mapping(x);
wvec = x(1:3);
hvec = x(4:6);
Zvec = x(7:9);
Yvec = x(10:12);
Z = x(13);
Y = x(14);
K = x(15);
Bz = zeros(1,3);
for i = 1:3
    Bz(i) = -(Y-Yvec(i))/((Z-Zvec(i)-0.5*wvec(i))^2+(Y-Yvec(i))^2)...
        +(Y-Yvec(i))/((Z-Zvec(i)+0.5*wvec(i))^2+(Y-Yvec(i))^2)...
        +(Y-Yvec(i)+hvec(i))/((Z-Zvec(i)-0.5*wvec(i))^2+(Y-Yvec(i)+hvec(i))^2)...
        -(Y-Yvec(i)+hvec(i))/((Z-Zvec(i)+0.5*wvec(i))^2+(Y-Yvec(i)+hvec(i))^2);
end
Bz = K*sum(Bz);
end