% Maggie Lawrence: 3-Magnet Array optimization
% May 26th 2020
% w1 = x1  w2 = x2  w3 = x3
% h1 = x4  h2 = x5  h3 = x6
% Z1 = x7  Z2 = x8  Z3 = x9
% Y1 = x10  Y2 = x11  Y3 = x12
% Z = x13  Y = x14  K = x15
clear
clc
iter = 4000;
c = 301;

coeff = NaN(1,4);

b = true;
i = 0;
while b
    i = i+1;
    if i == iter
        disp('Max iterations')
        beep
        return
    end
    IntCon = [1 2 3 4 5 6 14];
    x1_2_3 = [1, 2, 3];
    x4_5_6 = [3, 5];
    lb = [1, 1, 1, 1, 1, 1, -5, 0, 0, -3, -3, 0, -6, 1, 1500];
    ub = [3, 3, 3, 2, 2, 2, 0, 0, 5, 0, 0, 0, 6, 301, 1500];
    A = [0, 0.5, 0.5, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0;
        0.5, 0.5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0];
    b = [0;0;0];
    
    opts = optimoptions('ga', 'Display', 'off',...
        'MaxGenerations', 200);
    func = @(x)abs(dbz2(x));
    [x, fval] = ga(func, 15, A, b, [], [], lb, ub, @nonlincons, IntCon, opts);
    x = mapping(x);
    param = [x(1) x(4) x(7) x(10);
        x(2) x(5) x(8) x(11);
        x(3) x(6) x(9) x(12)];
    z = linspace(-6,6,c);
    Zind = find(z == x(13));
    Gz0 = bz2(x(15), x(13), x(14), param);
    n = 0;
    m = 0;
    Gzn = Gz0;
    Gzm = Gz0;
    while abs(Gz0 - Gzn) <= 4.5 && n < c-Zind-2
        n = n + 1;
        Gzn = bz2(x(15), z(Zind+n), x(14), param);
    end
    while abs(Gz0 - Gzm) <= 4.5 && m < Zind-2
        m = m + 1;
        Gzm = bz2(x(15), z(Zind-m), x(14), param);
    end
    z_ind = [(Zind-m):(Zind+n)];
    zvals = z((Zind-m):(Zind+n));
    if m+n+1 >= 70
        Bz_low = zeros(1,m+n+1);
        Bz_high = zeros(1,m+n+1);
        for k = 1:(m+n+1)
            Bz_low(k) = bz2(zvals(k), x(14)-0.5, param, x(15));
            Bz_high(k) = bz2(zvals(k), x(14)+0.5, param, x(15));
        end
        f_low = fit(zvals', Bz_low', 'poly1');
        f_high = fit(zvals', Bz_high', 'poly1');
        coeff(1:2) = coeffvalues(f_low);
        coeff(3:4) = coeffvalues(f_high);
        slope_var = abs(coeff(1)-coeff(3));
       % rlow = corrcoef(zvals', Bz_low');
        %rhigh = corrcoef(zvals', Bz_high');
        if slope_var <= 5 && (abs(coeff(1)) >= 20 || abs(coeff(3)) >= 20)
            save('parameters8.mat', 'x', 'z_ind', 'coeff',...
                '-append', '-nocompression');
            b = false;
        end
    end
end
beep