classdef panel < handle
    properties
        fig;
        p1;
        p2;
        p3;
        ax1;
        ax2;
        ax3;
        ax4;
        

    end
    methods
        function panels = panel

            
            panels.fig = uifigure('Name', 'Magnet Array');
            panels.fig.Position = [100, 50, 1200, 750];
            
            panels.p1 = uipanel('Parent', panels.fig);
            panels.p1.Title = 'Menu';
            panels.p1.Position = [0, 700, 1200, 50];
            
            panels.p2 = uipanel('Parent', panels.fig);
            panels.p2.Title = 'Plots';
            panels.p2.Position = [0, 300, 1200, 400];
            
            panels.p3 = uipanel('Parent', panels.fig);
            panels.p3.Title = 'Array';
            panels.p3.Position = [0, 0, 1200, 300];
            
            panels.ax1 = uiaxes('Parent', panels.p3);
            panels.ax1.Position = [700, 50, 450, 200];
            panels.ax1.XLabel.String = 'Z (cm)';
            panels.ax1.YLabel.String = 'Y (cm)';
            panels.ax1.XGrid = 'on';
            panels.ax1.YGrid = 'on';
            panels.ax1.XLabel.FontWeight = 'bold';
            panels.ax1.YLabel.FontWeight = 'bold';
            
            panels.ax2 = uiaxes('Parent', panels.p2);
            panels.ax2.Position = [300, 25, 600, 200];
            panels.ax2.NextPlot = 'add';
                                  
            
            
            panels.ax3 = uiaxes('Parent', panels.p2);
            panels.ax3.Position = [300, 250, 600, 100];
            panels.ax3.XLabel.String = 'Z (cm)';
            panels.ax3.XGrid = 'on';
            panels.ax3.YGrid = 'on';
            panels.ax3.NextPlot = 'replacechildren';
            panels.ax3.XLabel.FontWeight = 'bold';
            
            
            panels.ax4 = uiaxes('Parent', panels.p2);
            panels.ax4.Position = [1000, 25, 150, 200];
            panels.ax4.XLabel.String = 'Y (cm)';
            panels.ax4.XGrid = 'on';
            panels.ax4.YGrid = 'on';
            panels.ax4.NextPlot = 'replacechildren';
            panels.ax4.XLabel.FontWeight = 'bold';
            
        end
    end
end