classdef userfields < panel %& array
    properties
        wL;
        wC;
        wR;
        hL;
        hC;
        hR;
        ZL;
        ZC;
        ZR;
        YL;
        YC;
        YR;
        KL;
        KC;
        KR;
        Kstring
        Lstring;
        Cstring;
        Rstring;
        wstring;
        hstring;
        Ystring;
        Zstring;
        Ymin;
        Ymax;
        Zmin;
        Zmax;        
        Yminstring;
        Ymaxstring;
        Zminstring;
        Zmaxstring;
        Yvalstring;
        Zvalstring;
    end
    properties (SetObservable)
        Yval;
        Zval;
    end
%     properties (Dependent)
%         Zvallims;
%         Yvallims;
%     end
    methods
        function values = userfields
            values@panel;
            
            values.wL = uieditfield(values.p3, 'numeric');
            values.wL.Position = [75, 200, 75, 25];
            values.wL.Value = 3;
            
            values.wC = uieditfield(values.p3, 'numeric');
            values.wC.Position = [75, 150, 75, 25];
            values.wC.Value = 2;
            
            values.wR = uieditfield(values.p3, 'numeric');
            values.wR.Position = [75, 100, 75, 25];
            values.wR.Value = 3;
            
            values.hL = uieditfield(values.p3, 'numeric');
            values.hL.Position = [200, 200, 75, 25];
            values.hL.Value = 3;
            
            values.hC = uieditfield(values.p3, 'numeric');
            values.hC.Position = [200, 150, 75, 25];
            values.hC.Value = 3;
            
            values.hR = uieditfield(values.p3, 'numeric');
            values.hR.Position = [200, 100, 75, 25];
            values.hR.Value = 3;
            
            values.ZL = uieditfield(values.p3, 'numeric');
            values.ZL.Position = [325, 200, 75, 25];
            values.ZL.Value = -3.008;
            
            values.ZC = uieditfield(values.p3, 'numeric');
            values.ZC.Position = [325, 150, 75, 25];
            values.ZC.Value = 0;
            
            values.ZR = uieditfield(values.p3, 'numeric');
            values.ZR.Position = [325, 100, 75, 25];
            values.ZR.Value = 3.008;
            
            values.YL = uieditfield(values.p3, 'numeric');
            values.YL.Position = [450, 200, 75, 25];
            values.YL.Value = 0;
            
            values.YC = uieditfield(values.p3, 'numeric');
            values.YC.Position = [450, 150, 75, 25];
            values.YC.Value = -0.48;
            
            values.YR = uieditfield(values.p3, 'numeric');
            values.YR.Position = [450, 100, 75, 25];
            values.YR.Value = 0;
            
            values.Lstring = uilabel(values.p3);
            values.Lstring.Text = 'Left';
            values.Lstring.Position = [25, 200, 50, 25];
            values.Lstring.FontWeight = 'bold';
            
            values.Cstring = uilabel(values.p3);
            values.Cstring.Text = 'Centre';
            values.Cstring.Position = [25, 150, 50, 25];
            values.Cstring.FontWeight = 'bold';
            
            values.Rstring = uilabel(values.p3);
            values.Rstring.Text = 'Right';
            values.Rstring.Position = [25, 100, 50, 25];
            values.Rstring.FontWeight = 'bold';
            
            values.wstring = uilabel(values.p3);
            values.wstring.Text = 'Width (cm)';
            values.wstring.Position = [75, 225, 75, 25];
            values.wstring.FontWeight = 'bold';
            
            values.hstring = uilabel(values.p3);
            values.hstring.Text = 'Height (cm)';
            values.hstring.Position = [200, 225, 75, 25];
            values.hstring.FontWeight = 'bold';
            
            values.Zstring = uilabel(values.p3);
            values.Zstring.Text = 'Z (cm)';
            values.Zstring.Position = [325, 225, 75, 25];
            values.Zstring.FontWeight = 'bold';
            
            values.Ystring = uilabel(values.p3);
            values.Ystring.Text = 'Y (cm)';
            values.Ystring.Position = [450, 225, 75, 25];
            values.Ystring.FontWeight = 'bold';
            
            values.KL = uieditfield(values.p3, 'numeric');
            values.KL.Position = [575, 200, 75, 25];
            values.KL.Value = 1500;
            
            values.KC = uieditfield(values.p3, 'numeric');
            values.KC.Position = [575, 150, 75, 25];
            values.KC.Value = 1500;
            
            values.KR = uieditfield(values.p3, 'numeric');
            values.KR.Position = [575, 100, 75, 25];
            values.KR.Value = 1500;
            
            values.Kstring = uilabel(values.p3);
            values.Kstring.Text = 'K (Gauss)';
            values.Kstring.Position = [575, 225, 75, 25];
            values.Kstring.FontWeight = 'bold';
            
            values.Ymax = uieditfield(values.p2, 'numeric');
            values.Ymax.Position = [102, 350, 75, 25];
            values.Ymax.Value = 5;
            
            values.Ymin = uieditfield(values.p2, 'numeric');
            values.Ymin.Position = [100, 300, 75, 25];
            values.Ymin.Value = -1;
            
            values.Zmax = uieditfield(values.p2, 'numeric');
            values.Zmax.Position = [100, 250, 75, 25];
            values.Zmax.Value = 6;
                        
            values.Zmin = uieditfield(values.p2, 'numeric');
            values.Zmin.Position = [100, 200, 75, 25];
            values.Zmin.Value = -6;
            
            values.Yval = uispinner(values.p2);
            values.Yval.Position = [100, 150, 75, 25];
            values.Yval.Step = 0.1;
            values.Yval.Limits = [-inf, inf];
            
            values.Zval = uispinner(values.p2);
            values.Zval.Position = [100, 100, 75, 25];
            values.Zval.Step = 0.1;
            values.Zval.Limits = [-inf, inf];
            
            values.Ymaxstring = uilabel(values.p2);
            values.Ymaxstring.Text = 'Ymax (cm)';
            values.Ymaxstring.Position = [25, 350, 75, 25];
            values.Ymaxstring.FontWeight = 'bold';
            
            values.Yminstring = uilabel(values.p2);
            values.Yminstring.Text = 'Ymin (cm)';
            values.Yminstring.Position = [25, 300, 75, 25];
            values.Yminstring.FontWeight = 'bold';
            
            values.Zmaxstring = uilabel(values.p2);
            values.Zmaxstring.Text = 'Zmax (cm)';
            values.Zmaxstring.Position = [25, 250, 75, 25];
            values.Zmaxstring.FontWeight = 'bold';
            
            values.Zminstring = uilabel(values.p2);
            values.Zminstring.Text = 'Zmin (cm)';
            values.Zminstring.Position = [25, 200, 75, 25];
            values.Zminstring.FontWeight = 'bold';
            
            values.Yvalstring = uilabel(values.p2);
            values.Yvalstring.Text = 'Y (cm)';
            values.Yvalstring.Position = [25, 150, 75, 25];
            values.Yvalstring.FontWeight = 'bold';
            
            values.Zvalstring = uilabel(values.p2);
            values.Zvalstring.Text = 'Z (cm)';
            values.Zvalstring.Position = [25, 100, 75, 25];
            values.Zvalstring.FontWeight = 'bold';
        end
%         function Zvallims = get.Zvallims(values)
%             Zlow = get(values.Zmin, 'Value');
%             Zhigh = get(values.Zmax, 'Value');
%             Zvallims = [Zlow, Zhigh];
%         end
%         function Yvallims = get.Yvallims(values)
%             Ylow = get(values.Ymin, 'Value');
%             Yhigh = get(values.Ymax, 'Value');
%             Yvallims = [Ylow, Yhigh];
%         end
    end
end