function [c, ceq] = nonlincons(x)
x = mapping(x);
% param = [x(1) x(4) x(7) x(10);
%     x(2) x(5) x(8) x(11);
%     x(3) x(6) x(9) x(12)];
dBz = dbz2(x);
%dBz_11 = dbz2(x);
%dBz_12 = dbz2(x);
%dBz_21 = dbz2(x);
%dBz_22 = dbz2(x);
c = [dBz+20];
ceq = [];
end