classdef parameters < app & handle
    properties
        w1
        w2
        w3
        h1
        h2
        h3
        Z1
        Z2
        Z3
        Y1
        Y2
        Y3
        K1
        K2
        K3
        c
    end
    methods
        function param = parameters
            param@app;
            setparameters(param);
            param.c = 301;
            param.ax2.XLim = [param.Zmin.Value, param.Zmax.Value];
            param.ax2.YLim = [param.Ymin.Value, param.Ymax.Value];
            param.ax3.XLim = [param.Zmin.Value, param.Zmax.Value];
            param.ax4.XLim = [param.Ymin.Value, param.Ymax.Value];
            param.ax1.XLim = [param.Zmin.Value, param.Zmax.Value];
            param.ax1.YLim = [param.Ymin.Value, param.Ymax.Value];
            
            
            
        end
        
        function plotArray(param)
            setparameters(param);
            delete(param.ax1.Children);
            param.ax1.YLimMode = 'auto';
            param.ax1.XLimMode = 'auto';
            
            
            wvec = [param.w1; param.w2; param.w3];
            hvec = [param.h1; param.h2; param.h3];
            Zvec = [param.Z1; param.Z2; param.Z3];
            Yvec = [param.Y1; param.Y2; param.Y3];
            
            
            Xc = Zvec - 0.5*wvec;
            Yc = Yvec - hvec;
            pos = [Xc, Yc, wvec, hvec];
            col = {'r', 'k', 'b'};
            
            for i = 1:3
                rectangle(param.ax1, 'Position', pos(i,:), 'FaceColor', col{i});
                
            end
        end
        function setparameters(param)
            param.w1 = get(param.wL, 'Value');
            param.w2 = get(param.wC, 'Value');
            param.w3 = get(param.wR, 'Value');
            param.h1 = get(param.hL, 'Value');
            param.h2 = get(param.hC, 'Value');
            param.h3 = get(param.hR, 'Value');
            param.Z1 = get(param.ZL, 'Value');
            param.Z2 = get(param.ZC, 'Value');
            param.Z3 = get(param.ZR, 'Value');
            param.Y1 = get(param.YL, 'Value');
            param.Y2 = get(param.YC, 'Value');
            param.Y3 = get(param.YR, 'Value');
            param.K1 = get(param.KL, 'Value');
            param.K2 = get(param.KC, 'Value');
            param.K3 = get(param.KR, 'Value');

        end
        function [zmin, zmax, zval, ymin, ymax, yval] = getlims(param)
            zmin = get(param.Zmin, 'Value');
            zmax = get(param.Zmax, 'Value');
            ymin = get(param.Ymin, 'Value');
            ymax = get(param.Ymax, 'Value');
            zval = get(param.Zval, 'Value');
            yval = get(param.Yval, 'Value');
        end
        function Bo = bofnc(param)
            setparameters(param);
            [zmin, zmax, ~, ymin, ymax, ~] = getlims(param);
            Z = linspace(zmin, zmax, param.c)';
            Y = linspace(ymin, ymax, param.c);
            wvec = [param.w1; param.w2; param.w3];
            hvec = [param.h1; param.h2; param.h3];
            Zvec = [param.Z1; param.Z2; param.Z3];
            Yvec = [param.Y1; param.Y2; param.Y3];
            Kvec = [param.K1; param.K2; param.K3];
            Bo = {zeros(length(Y), length(Z)), zeros(length(Y), length(Z)), zeros(length(Y), length(Z))};
            [test1r, ~] = find(Y - Yvec == 0);
            [test2r, ~] = find(Y - Yvec == 0);
            if isempty(test1r) && isempty(test2r)
                for k = 1:3
                    for i = 1:length(Z)
                        for j = 1:length(Y)
                            Bo{k}(j,i) = -atan((Z(i)-Zvec(k)-0.5*wvec(k))/(Y(j) - Yvec(k)))...
                                +atan((Z(i)-Zvec(k)+0.5*wvec(k))/(Y(j) - Yvec(k)))...
                                +atan((Z(i)-Zvec(k)-0.5*wvec(k))/(Y(j)-Yvec(k)+hvec(k)))...
                                -atan((Z(i)-Zvec(k)+0.5*wvec(k))/(Y(j)-Yvec(k)+hvec(k)));
                        end
                    end
                end
                
                
            else
                Y = Y - 0.0001;
                for k = 1:3
                    for i = 1:length(Z)
                        for j = 1:length(Y)
                            Bo{k}(j,i) = -atan((Z(i)-Zvec(k)-0.5*wvec(k))/(Y(j) - Yvec(k)))...
                                +atan((Z(i)-Zvec(k)+0.5*wvec(k))/(Y(j) - Yvec(k)))...
                                +atan((Z(i)-Zvec(k)-0.5*wvec(k))/(Y(j)-Yvec(k)+hvec(k)))...
                                -atan((Z(i)-Zvec(k)+0.5*wvec(k))/(Y(j)-Yvec(k)+hvec(k)));
                        end
                    end
                end
            end
            Bo = Kvec(1)*Bo{1} + Kvec(2)*Bo{2} + Kvec(3)*Bo{3};
        end
        function By = byfnc(param)
            setparameters(param);
            [zmin, zmax, ~, ymin, ymax, ~] = getlims(param);
            Z = linspace(zmin, zmax, param.c)';
            Y = linspace(ymin, ymax, param.c)';
            wvec = [param.w1; param.w2; param.w3];
            hvec = [param.h1; param.h2; param.h3];
            Zvec = [param.Z1; param.Z2; param.Z3];
            Yvec = [param.Y1; param.Y2; param.Y3];
            Kvec = [param.K1; param.K2; param.K3];
            By = {zeros(length(Y), length(Z)), zeros(length(Y), length(Z)), zeros(length(Y), length(Z))};
            for k = 1:3
                for i = 1:length(Z)
                    for j = 1:length(Y)
                        By{k}(j,i) = log(((Y(j)-Yvec(k))^2+(Z(i)-Zvec(k)+0.5*wvec(k))^2)/...
                            ((Y(j)-Yvec(k))^2+(Z(i)-Zvec(k)-0.5*wvec(k))^2))...
                            -log(((Y(j)-Yvec(k)+hvec(k))^2+(Z(i)-Zvec(k)+0.5*wvec(k))^2)/...
                            ((Y(j)-Yvec(k)+hvec(k))^2+(Z(i)-Zvec(k)-0.5*wvec(k))^2));
                        
                    end
                end
            end
            By = 0.5*(Kvec(1)*By{1}+Kvec(2)*By{2}+Kvec(3)*By{3});
        end
        function AbsB = absbfnc(param)
            by = byfnc(param);
            bo = bofnc(param);
            AbsB = sqrt(by.^2+bo.^2);
        end
        function plotContour(param)
            setparameters(param);
            cla(param.ax2, 'reset');
            param.ax2.NextPlot = 'add';
            param.ax2.XLabel.String = 'Z (cm)';
            param.ax2.YLabel.String = 'Y (cm)';
            param.ax2.View = [0, 90];
            param.ax2.XGrid = 'on';
            param.ax2.YGrid = 'on';
            param.ax2.XLabel.FontWeight = 'bold';
            param.ax2.YLabel.FontWeight = 'bold';
            
            [zmin, zmax, zval, ymin, ymax, yval] = getlims(param);
            param.ax2.XLim = [zmin, zmax];
            param.ax2.YLim = [ymin, ymax];
            Z = linspace(zmin, zmax, param.c)';
            Y = linspace(ymin, ymax, param.c)';
            
            contour(param.ax2, Z, Y, absbfnc(param), 50);
            param.ax2.Toolbar = customtoolbar(param);
            if yval <= ymax && yval >= ymin
                plot(param.ax2, [zmin zmax], [yval yval], 'Color', 'b', 'LineWidth', 2);
            end
            if zval <= zmax && zval >= zmin
                plot(param.ax2, [zval zval], [ymin ymax], 'Color', 'r', 'LineWidth', 2);
            end
            
        end
        function plotSurface(param)
            cla(param.ax2, 'reset');
            param.ax2.NextPlot = 'add';
            param.ax2.XLabel.String = 'Z (cm)';
            param.ax2.YLabel.String = 'Y (cm)';
            param.ax2.ZLabel.String = '|B| (Gauss)';
            param.ax2.View = [225, 20];
            param.ax2.XLabel.FontWeight = 'bold';
            param.ax2.YLabel.FontWeight = 'bold';
            param.ax2.ZLabel.FontWeight = 'bold';
            
            param.c = 101;
            [zmin, zmax, zval, ymin, ymax, yval] = getlims(param);
            param.ax2.XLim = [zmin, zmax];
            param.ax2.YLim = [ymin, ymax];
            Z = linspace(zmin, zmax, param.c)';
            Y = linspace(ymin, ymax, param.c)';
            mesh(param.ax2, Z, Y, absbfnc(param));
            param.ax2.Toolbar = customtoolbar(param);
            b = max(max(absbfnc(param)));
            if yval <= ymax && yval >= ymin
                patch(param.ax2, 'XData', [zmin zmax zmax zmin], 'YData',...
                    [yval yval yval yval], 'ZData', [0 0 b b],...
                    'EdgeColor', 'b', 'FaceColor', 'none', 'LineWidth', 2);
            end
            if zval <= zmax && zval >= zmin
                patch(param.ax2, 'XData', [zval zval zval zval], 'YData',...
                    [ymin ymax ymax ymin], 'ZData', [0 0 b b],...
                    'EdgeColor', 'r', 'FaceColor', 'none', 'LineWidth', 2);
            end
            
            param.c = 301;
            
        end
        function plotVector(param)
            cla(param.ax2, 'reset');
            param.ax2.NextPlot = 'add';
            param.ax2.XLabel.String = 'Z (cm)';
            param.ax2.YLabel.String = 'Y (cm)';
            param.ax2.XGrid = 'on';
            param.ax2.YGrid = 'on';
            param.ax2.XLabel.FontWeight = 'bold';
            param.ax2.YLabel.FontWeight = 'bold';
            
            [zmin, zmax, zval, ymin, ymax, yval] = getlims(param);
            param.ax2.XLim = [zmin, zmax];
            param.ax2.YLim = [ymin, ymax];
            param.ax2.View = [0, 90];
            param.c = 16;
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            
            
            quiver(param.ax2, Z, Y, bofnc(param), byfnc(param), 'Color', [0 0.4470 0.7410]);
            param.ax2.Toolbar = customtoolbar(param);
            if yval <= ymax && yval >= ymin
                plot(param.ax2, [zmin zmax], [yval yval], 'LineWidth', 2, 'Color', 'b');
            end
            if zval <= zmax && zval >= zmin
                plot(param.ax2, [zval zval], [ymin ymax], 'LineWidth', 2, 'Color', 'r');
            param.c = 301;
            end
        end
        function plotBoYcross(param)
            delete(param.ax3.Children)
            [zmin, zmax, ~, ymin, ymax, yval] = getlims(param);
            param.ax3.XLim = [zmin, zmax];
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = bofnc(param);
            int = (ymax - ymin)/(param.c - 1);
            yind = (Y <= yval+0.5*int & Y > yval-0.5*int);
            B = B(yind,:);
            param.ax3.YLim = [min(min(B)), max(max(B))];
            param.ax3.YLabel.String = 'B_o (Gauss)';
            param.ax3.YLabel.FontWeight = 'bold';
            
            plot(param.ax3, Z, B, 'LineWidth', 1, 'Color', 'b');
            param.ax3.Children.Tag = 'B_o';
        end
        function plotByYcross(param)
            delete(param.ax3.Children)
            [zmin, zmax, ~, ymin, ymax, yval] = getlims(param);
            param.ax3.XLim = [zmin, zmax];
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = byfnc(param);
            int = (ymax - ymin)/(param.c - 1);
            yind = (Y <= yval+0.5*int & Y > yval-0.5*int);
            B = B(yind,:);
            param.ax3.YLim = [min(min(B)), max(max(B))];
            param.ax3.YLabel.String = 'B_y (Gauss)';
            param.ax3.YLabel.FontWeight = 'bold';
            plot(param.ax3, Z, B, 'LineWidth', 1, 'Color', 'b');
            param.ax3.Children.Tag = 'B_y';
        end
        function plotBYcross(param)
            delete(param.ax3.Children)
            [zmin, zmax, ~, ymin, ymax, yval] = getlims(param);
            param.ax3.XLim = [zmin, zmax];
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = absbfnc(param);
            int = (ymax - ymin)/(param.c - 1);
            yind = (Y <= yval+0.5*int & Y > yval-0.5*int);
            B = B(yind,:);
            param.ax3.YLim = [min(min(B)), max(max(B))];
            param.ax3.YLabel.String = '|B| (Gauss)';
            param.ax3.YLabel.FontWeight = 'bold';
            plot(param.ax3, Z, B, 'LineWidth', 1, 'Color', 'b');
            param.ax3.Children.Tag = '|B|';
        end
        function plotBoZcross(param)
            delete(param.ax4.Children)
            [zmin, zmax, zval, ymin, ymax, ~] = getlims(param);
            param.ax4.XLim = [ymin, ymax];
            
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = bofnc(param);
            int = (zmax - zmin)/(param.c - 1);
            zind = (Z <= zval+0.5*int & Z > zval-0.5*int);
            B = B(:,zind);
            param.ax4.YLim = [min(min(B)), max(max(B))];
            param.ax4.YLabel.String = 'B_o (Gauss)';
            param.ax4.YLabel.FontWeight = 'bold';
            
            plot(param.ax4, Y, B, 'LineWidth', 1, 'Color', 'r');
            param.ax4.Children.Tag = 'B_o';
        end
        function plotByZcross(param)
            delete(param.ax4.Children)
            [zmin, zmax, zval, ymin, ymax, ~] = getlims(param);
            param.ax4.XLim = [ymin, ymax];
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = byfnc(param);
            int = (zmax - zmin)/(param.c - 1);
            zind = (Z <= zval+0.5*int & Z > zval-0.5*int);
            B = B(:,zind);
            param.ax4.YLim = [min(min(B)), max(max(B))];
            param.ax4.YLabel.String = 'B_y (Gauss)';
            param.ax4.YLabel.FontWeight = 'bold';
           
            plot(param.ax4, Y, B, 'LineWidth', 1, 'Color', 'r');
            param.ax4.Children.Tag = 'B_y';
        end
        function plotBZcross(param)
            delete(param.ax4.Children)
            [zmin, zmax, zval, ymin, ymax, ~] = getlims(param);
            param.ax4.XLim = [ymin, ymax];
            Z = linspace(zmin, zmax, param.c);
            Y = linspace(ymin, ymax, param.c);
            B = absbfnc(param);
            int = (zmax - zmin)/(param.c - 1);
            zind = (Z <= zval+0.5*int & Z > zval-0.5*int);
            B = B(:,zind);
            param.ax4.YLim = [min(min(B)), max(max(B))];
            param.ax4.YLabel.String = '|B| (Gauss)';
            param.ax4.YLabel.FontWeight = 'bold';
            plot(param.ax4, Y, B, 'LineWidth', 1, 'Color', 'r');
            param.ax4.Children.Tag = '|B|';
        
        end
        function tb = customtoolbar(param)
            type = get(param.ax2.Children(end), 'Type');
            disableDefaultInteractivity(param.ax2);
            switch type
                case 'surface'
                    tb = axtoolbar(param.ax2, {'zoomin', 'zoomout',...
                        'rotate', 'pan', 'brush', 'export'});
                    enableDefaultInteractivity(param.ax2);
                otherwise
                    tb = axtoolbar(param.ax2, {'zoomin', 'zoomout',...
                        'export', 'pan', 'brush'});
                    param.ax2.Interactions = [panInteraction,...
                        zoomInteraction, dataTipInteraction,...
                        rulerPanInteraction];
                    
            end
            btn = axtoolbarbtn(tb, 'push');
            btn.Icon = 'restoreview';
            btn.Tooltip = 'Restore View';
            btn.ButtonPushedFcn = @customcallback;
            function customcallback(eventSrc, eventData)
                switch type
                    case 'surface'
                        param.ax2.View = [225, 20];
                        param.ax2.XLim = [param.Zmin.Value, param.Zmax.Value];
                        param.ax2.YLim = [param.Ymin.Value, param.Ymax.Value];
                        param.ax2.ZLim = [0, max(max(get(param.ax2.Children(end), 'ZData')))];
                    otherwise
                        param.ax2.View = [0, 90];
                        param.ax2.XLim = [param.Zmin.Value, param.Zmax.Value];
                        param.ax2.YLim = [param.Ymin.Value, param.Ymax.Value];
                end
            end
        end
    end
end