function prog = MagnetArray2020
prog = parameters;
prog.Run.ButtonPushedFcn = @Runclicked;
prog.Contour.ButtonPushedFcn = @ContourClicked;
prog.Surface.ButtonPushedFcn = @SurfaceClicked;
prog.Vector.ButtonPushedFcn = @VectorClicked;
prog.Bo_Ycross.ButtonPushedFcn = @Bo_YcrossClicked;
prog.By_Ycross.ButtonPushedFcn = @By_YcrossClicked;
prog.B_Ycross.ButtonPushedFcn = @B_YcrossClicked;
prog.Bo_Zcross.ButtonPushedFcn = @Bo_ZcrossClicked;
prog.By_Zcross.ButtonPushedFcn = @By_ZcrossClicked;
prog.B_Zcross.ButtonPushedFcn = @B_ZcrossClicked;
prog.exportY.ButtonPushedFcn = @exportYClicked;
prog.exportZ.ButtonPushedFcn = @exportZClicked;
prog.exportB.ButtonPushedFcn = @exportBClicked;
prog.Yval.ValueChangedFcn = @YvalChanged;
prog.Zval.ValueChangedFcn = @ZvalChanged;
prog.Ymin.ValueChangedFcn = @YlimsChanged;
prog.Ymax.ValueChangedFcn = @YlimsChanged;
prog.Zmin.ValueChangedFcn = @ZlimsChanged;
prog.Zmax.ValueChangedFcn = @ZlimsChanged;
prog.wL.ValueChangedFcn = @paramsChanged;
prog.wC.ValueChangedFcn = @paramsChanged;
prog.wR.ValueChangedFcn = @paramsChanged;
prog.hL.ValueChangedFcn = @paramsChanged;
prog.hC.ValueChangedFcn = @paramsChanged;
prog.hR.ValueChangedFcn = @paramsChanged;
prog.ZL.ValueChangedFcn = @paramsChanged;
prog.ZC.ValueChangedFcn = @paramsChanged;
prog.ZR.ValueChangedFcn = @paramsChanged;
prog.YL.ValueChangedFcn = @paramsChanged;
prog.YC.ValueChangedFcn = @paramsChanged;
prog.YR.ValueChangedFcn = @paramsChanged;
prog.KL.ValueChangedFcn = @paramsChanged;
prog.KC.ValueChangedFcn = @paramsChanged;
prog.KR.ValueChangedFcn = @paramsChanged;
    function Runclicked(eventSrc, eventData)        
        plotArray(prog);
    end
    function ContourClicked(eventSrc, eventData)        
        plotContour(prog)
    end
    function SurfaceClicked(eventSrc, eventData)        
        plotSurface(prog)
    end
    function VectorClicked(eventSrc, eventData)        
        plotVector(prog)
    end
    function Bo_YcrossClicked(eventSrc, eventData)        
        plotBoYcross(prog)
    end
    function By_YcrossClicked(eventSrc, eventData)        
        plotByYcross(prog)
    end
    function B_YcrossClicked(eventSrc, eventData)        
        plotBYcross(prog)
    end
    function Bo_ZcrossClicked(eventSrc, eventData)        
        plotBoZcross(prog)
    end
    function By_ZcrossClicked(eventSrc, eventData)        
        plotByZcross(prog)
    end
    function B_ZcrossClicked(eventSrc, eventData)        
        plotBZcross(prog)
    end
    function exportYClicked(eventSrc, eventData)
       props = {'XData', 'YData'};
       savecell = get(prog.ax3.Children, props);
       Zvals = savecell{1}';
       FieldData = savecell{2}';
       filetypes = {'*.mat', 'MATLAB Workspace Variable (*.mat)';
           '*.csv', 'Spreadsheet (*.csv)';
           '*.txt', 'Text File (*.txt)'};
       [file, path, index] = uiputfile(filetypes, 'Export Y Cross Section',...
           'Y_Cross_Section');
       savefile = strcat(path, file);
       if index > 1           
           data = [Zvals, FieldData];
           writematrix(data, savefile);
           
       else
            save(savefile, 'Zvals', 'FieldData');
       end
       
        
    end
    function exportZClicked(eventSrc, eventData)
       props = {'XData', 'YData'};
       savecell = get(prog.ax4.Children, props);
       Yvals = savecell{1}';
       FieldData = savecell{2}';
       filetypes = {'*.mat', 'MATLAB Workspace Variable (*.mat)';
           '*.csv', 'Spreadsheet (*.csv)';
           '*.txt', 'Text File (*.txt)'};      
           
       [file, path, index] = uiputfile(filetypes, 'Export Z Cross Section',...
           'Z_Cross_Section');
       savefile = strcat(path, file);
       if index > 1           
           data = [Yvals, FieldData];
           writematrix(data, savefile);
       else
            save(savefile, 'Yvals', 'FieldData');
       end 
    end
    function exportBClicked(eventSrc, eventData)
        type = get(prog.ax2.Children(end), 'Type');
        filetypes = {'*.mat', 'MATLAB Workspace Variable (*.mat)';
           '*.csv', 'Spreadsheet (*.csv)';
           '*.txt', 'Text File (*.txt)'};
        [file, path, index] = uiputfile(filetypes, 'Export B',...
           'Magnetic_Field');
        savefile = strcat(path, file);
        switch type
            case 'contour'
                props = {'XData', 'YData', 'ZData'};
                [r, ~] = size(prog.ax2.Children);
                if r == 1
                    Bmat = get(prog.ax2.Children, props);
                elseif r == 2
                    line = get(prog.ax2.Children(1), props);
                    Bmat = get(prog.ax2.Children(2), props);
                    colour = get(prog.ax2.Children(1), 'Color');
                    if colour == [1 0 0]
                        Yline = line;
                        YlineZ = Yline{1};
                        YlineY = Yline{2};
                        YData = [YlineZ; YlineY];
                        if index > 1
                            writematrix(YData, savefile);
                        else
                            save(savefile, 'YlineZ', 'YlineY');
                        end
                    else
                        Zline = line;
                        ZlineZ = Zline{1};
                        ZlineY = Zline{2};
                        ZData = [ZlineZ; ZlineY];
                        if index > 1
                            writematrix(ZData, savefile);
                        else
                            save(savefile, 'ZlineZ', 'ZlineY');
                        end
                    end
                elseif r == 0
                    disp('No data')
                else
                    Yline = get(prog.ax2.Children(2), props);
                    Zline = get(prog.ax2.Children(1), props);
                    Bmat = get(prog.ax2.Children(3), props);
                    YlineZ = Yline{1};
                    YlineY = Yline{2};
                    ZlineZ = Zline{1};
                    ZlineY = Zline{2};
                    ZData = [ZlineZ; ZlineY];
                    YData = [YlineZ; YlineY];
                    if index > 1
                        writematrix(ZData, savefile);
                        writematrix(YData, savefile, 'WriteMode', 'append');
                    else
                        save(savefile, 'ZlineZ', 'ZlineY', 'YlineZ', 'YlineY');
                    end
                end
                Zvals = Bmat{1}';
                Yvals = Bmat{2};
                FieldData = Bmat{3};
                FieldData = [Yvals, FieldData];
                FieldData = [NaN Zvals; FieldData];
                if index > 1
                    if r > 1
                        writematrix(FieldData, savefile, 'WriteMode', 'append');
                    else
                        writematrix(FieldData, savefile);
                    end
                else
                    if r > 1
                        save(savefile, 'FieldData', '-append');
                    else
                        save(savefile, 'FieldData');
                    end
                end
            case 'surface'
                props = {'XData', 'YData', 'ZData'};
                [r, ~] = size(prog.ax2.Children);
                if r == 1
                    Bmat = get(prog.ax2.Children, props);
                elseif r == 2
                    patch = get(prog.ax2.Children(1), props);
                    Bmat = get(prog.ax2.Children(2), props);
                    colour = get(prog.ax2.Children(1), 'Color');
                    if colour == [1 0 0]
                        Ypatch = patch;
                        YpatchZ = Ypatch{1};
                        YpatchY = Ypatch{2};
                        YpatchB = Ypatch{3};
                        YData = [YpatchZ, YpatchY, YpatchB];
                        if index > 1
                            writematrix(YData, savefile);
                        else
                            save(savefile, 'YpatchZ', 'YpatchY', 'YpatchB')
                        end
                    else
                        Zpatch = patch;
                        ZpatchZ = Zpatch{1};
                        ZpatchY = Zpatch{2};
                        ZpatchB = Zpatch{3};
                        ZData = [ZpatchZ, ZpatchY, ZpatchB];
                        if index > 1
                            writematrix(ZData, savefile);
                        else
                            save(savefile, 'ZpatchZ', 'ZpatchY', 'ZpatchB');
                        end
                    end
                elseif r == 0
                    disp('No data')
                else
                    Ypatch = get(prog.ax2.Children(2), props);
                    Zpatch = get(prog.ax2.Children(1), props);
                    Bmat = get(prog.ax2.Children(3), props);
                    YpatchZ = Ypatch{1};
                    YpatchY = Ypatch{2};
                    YpatchB = Ypatch{3};
                    ZpatchZ = Zpatch{1};
                    ZpatchY = Zpatch{2};
                    ZpatchB = Zpatch{3};
                    if index > 1
                        ZData = [ZpatchZ, ZpatchY, ZpatchB];
                        YData = [YpatchZ, YpatchY, YpatchB];
                        writematrix(ZData, savefile);
                        writematrix(YData, savefile, 'WriteMode', 'append');
                    else
                        save(savefile, 'ZpatchZ', 'ZpatchY', 'ZpatchB',...
                            'YpatchZ', 'YpatchY', 'YpatchB');
                    end
                end
                Zvals = Bmat{1}';
                Yvals = Bmat{2}; 
                FieldData = Bmat{3};
                if index > 1
                    FieldData = [Yvals, FieldData];
                    FieldData = [NaN Zvals; FieldData];
                    if r > 1
                        writematrix(FieldData, savefile, 'WriteMode', 'append');
                    else
                        writematrix(FieldData, savefile);
                    end
                else
                    if r > 1
                        save(savefile, 'FieldData', '-append');
                    else
                        save(savefile, 'FieldData')
                    end
                end
            case 'quiver'
                props = {'XData', 'YData', 'UData', 'VData'};
                [r, ~] = size(prog.ax2.Children);
                if r == 1
                    Bmat = get(prog.ax2.Children, props);
                elseif r == 2
                    line = get(prog.ax2.Children(1), props(1,2));
                    Bmat = get(prog.ax2.Children(2), props);
                    colour = get(prog.ax2.Children(1), 'Color');
                    if colour == [1 0 0]
                        Yline = line;
                        YlineZ = Yline{1};
                        YlineY = Yline{2};
                        YData = [YlineZ; YlineY];
                        if index > 1
                            writematrix(YData, savefile);
                        else
                            save(savefile, 'YlineZ', 'YlineY');
                        end
                    else
                        Zline = line;
                        ZlineZ = Zline{1};
                        ZlineY = Zline{2};
                        ZData = [ZlineZ; ZlineY];
                        if index > 1
                            writematrix(ZData, savefile);
                        else
                            save(savefile, 'ZlineZ', 'ZlineY')
                        end
                    end
                else
                    Yline = get(prog.ax2.Children(2), props(1:2));
                    Zline = get(prog.ax2.Children(1), props(1:2));
                    Bmat = get(prog.ax2.Children(3), props);
                    YlineZ = Yline{1};
                    YlineY = Yline{2};
                    ZlineZ = Zline{1};
                    ZlineY = Zline{2};
                    YData = [YlineZ; YlineY];
                    ZData = [ZlineZ; ZlineY];
                    if index > 1
                        writematrix(ZData, savefile);
                        writematrix(YData, savefile, 'WriteMode', 'append');
                    else
                        save(savefile, 'YlineZ', 'YlineY', 'ZlineZ', 'ZlineY');
                    end
                end
                Zvals = Bmat{1}';
                Yvals = Bmat{2}';
                BoComp = Bmat{3};
                ByComp = Bmat{4};
                if index > 1
                    if r > 1
                        writematrix(Zvals, savefile, 'WriteMode', 'append');
                        writematrix(Yvals, savefile, 'WriteMode', 'append');
                        writematrix(BoComp, savefile, 'WriteMode', 'append');
                        writematrix(ByComp, savefile, 'WriteMode', 'append');
                    else
                        writematrix(Zvals, savefile);
                        writematrix(Yvals, savefile);
                        writematrix(BoComp, savefile);
                        writematrix(ByComp, savefile);
                    end
                else
                    if r > 1
                        save(savefile, 'Zvals', 'Yvals', 'BoComp', 'ByComp', '-append');
                    else
                        save(savefile, 'Zvals', 'Yvals', 'BoComp', 'ByComp');
                    end
                end
        end
       
       
       
    end
    function YvalChanged(eventSrc, eventData)
               
        setparameters(prog)
        [~, ~, ~, ymin, ymax, yval] = getlims(prog);
        
        if ~isempty(prog.ax2.Children)
            if yval <= ymax && yval >= ymin
                type = get(prog.ax2.Children(3), 'Type');
                switch type
                    case 'surface'
                        plotSurface(prog)
                    case 'quiver'
                        plotVector(prog)
                    case 'contour'
                        plotContour(prog)
                end
            end
        end
        if ~isempty(prog.ax3.Children)
            tag = prog.ax3.Children.Tag;
            switch tag
                case 'B_o'
                    plotBoYcross(prog)
                case 'B_y'
                    plotByYcross(prog)
                case '|B|'
                    plotBYcross(prog)
            end
        end
    end
    function ZvalChanged(eventSrc, eventData)
        setparameters(prog)
        [zmin, zmax, zval, ~, ~, ~] = getlims(prog);
        
        if ~isempty(prog.ax2.Children)
            if zval <= zmax && zval >= zmin
                type = get(prog.ax2.Children(3), 'Type');
                switch type
                    case 'surface'
                        plotSurface(prog)
                    case 'quiver'
                        plotVector(prog)
                    case 'contour'
                        plotContour(prog)
                end
            end
        end
        if ~isempty(prog.ax4.Children)
            tag = prog.ax4.Children.Tag;
            switch tag
                case 'B_o'
                    plotBoZcross(prog)
                case 'B_y'
                    plotByZcross(prog)
                case '|B|'
                    plotBZcross(prog)
            end
        end
    end
    function YlimsChanged(eventSrc, eventData)
        setparameters(prog);
        [~, ~, ~, ymin, ymax, yval] = getlims(prog);
        
        if ~isempty(prog.ax2.Children)
            if yval <= ymax && yval >= ymin
                type = get(prog.ax2.Children(end), 'Type');
                switch type
                    case 'surface'
                        plotSurface(prog)
                    case 'quiver'
                        plotVector(prog)
                    case 'contour'
                        plotContour(prog)
                end
            end
        end
        
        if ~isempty(prog.ax4.Children)
            tag = prog.ax4.Children.Tag;
            switch tag
                case 'B_o'
                    plotBoZcross(prog)
                case 'B_y'
                    plotByZcross(prog)
                case '|B|'
                    plotBZcross(prog)
            end
        end
    end
    function ZlimsChanged(eventSrc, eventData)
        setparameters(prog);
        [zmin, zmax, zval, ~, ~, ~] = getlims(prog);
        
        if ~isempty(prog.ax2.Children)
            if zval <= zmax && zval >= zmin
                type = get(prog.ax2.Children(end), 'Type');
                switch type
                    case 'surface'
                        plotSurface(prog)
                    case 'quiver'
                        plotVector(prog)
                    case 'contour'
                        plotContour(prog)
                end
            end
        end
        
        if ~isempty(prog.ax3.Children)
            tag = prog.ax3.Children.Tag;
            switch tag
                case 'B_o'
                    plotBoYcross(prog)
                case 'B_y'
                    plotByYcross(prog)
                case '|B|'
                    plotBYcross(prog)
            end
        end
    end
    function paramsChanged(eventSrc, eventData)
        if ~isempty(prog.ax1.Children)
            plotArray(prog);
        end
        if ~isempty(prog.ax2.Children)
            type = get(prog.ax2.Children(3), 'Type');
            switch type
                case 'contour'
                    plotContour(prog)
                case 'quiver'
                    plotVector(prog)
                case 'surface'
                    plotSurface(prog)
            end
        end
        if ~isempty(prog.ax3.Children)
            tag = get(prog.ax3.Children, 'Tag');
            switch tag
                case 'B_o'
                    plotBoYcross(prog)
                case 'B_y'
                    plotByYcross(prog)
                case '|B|'
                    plotBYcross(prog)
            end
        end
        if ~isempty(prog.ax4.Children)
            tag = get(prog.ax3.Children, 'Tag');
            switch tag
                case 'B_o'
                    plotBoZcross(prog)
                case 'B_y'
                    plotByYcross(prog)
                case '|B|'
                    plotBYcross(prog)
            end
        end
    end
end
