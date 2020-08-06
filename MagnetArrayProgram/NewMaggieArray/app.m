classdef app < userfields
    properties
        Run;
        exportY;
        exportZ;
        exportB;
        Contour;
        Surface;
        Vector;
        Bo_Ycross;
        By_Ycross;
        B_Ycross;
        Bo_Zcross;
        By_Zcross;
        B_Zcross;
    end
    properties (Dependent)
        param;
    end
%     events
%         Runclick;
%         exportYclick;
%         exportZclick;
%         exportBclick;
%         Contourclick;
%         Surfaceclick;
%         Vectorclick;
%         Bo_Ycrossclick;
%         By_Ycrossclick;
%         B_Ycrossclick;
%         Bo_Zcrossclick;
%         By_Zcrossclick;
%         B_Zcrossclick;
%     end
    methods
        function push = app
            push@userfields;
                                    
            push.Run = uibutton(push.p3);
            push.Run.Position = [200, 50, 200, 25];
            push.Run.Text = 'Run';
            %push.Run.ButtonPushedFcn = @Runclicked;
            
            push.exportB = uibutton(push.p2);
            push.exportB.Position = [1000, 250, 150, 25];
            push.exportB.Text = 'Export B';
            
            push.exportZ = uibutton(push.p2);
            push.exportZ.Position = [1000, 300, 150, 25];
            push.exportZ.Text = 'Export Z Cross Section';
            
            push.exportY = uibutton(push.p2);
            push.exportY.Position = [1000, 350, 150, 25];
            push.exportY.Text = 'Export Y Cross Section';
            
            push.Contour = uibutton(push.p2);
            push.Contour.Position = [250, 150, 50, 25];
            push.Contour.Text = 'Contour';
            
            push.Surface = uibutton(push.p2);
            push.Surface.Position = [250, 100, 50, 25];
            push.Surface.Text = 'Surface';
            
            push.Vector = uibutton(push.p2);
            push.Vector.Position = [250, 50, 50, 25];
            push.Vector.Text = 'Vector';
            
            push.Bo_Ycross = uibutton(push.p2);
            push.Bo_Ycross.Position = [250, 275, 50, 25];
            push.Bo_Ycross.Text = 'Bo';
            
            push.By_Ycross = uibutton(push.p2);
            push.By_Ycross.Position = [250, 300, 50, 25];
            push.By_Ycross.Text = 'By';
            
            push.B_Ycross = uibutton(push.p2);
            push.B_Ycross.Position = [250, 325, 50, 25];
            push.B_Ycross.Text = '|B|';
            
            push.Bo_Zcross = uibutton(push.p2);
            push.Bo_Zcross.Position = [950, 50, 50, 25];
            push.Bo_Zcross.Text = 'Bo';
            
            push.By_Zcross = uibutton(push.p2);
            push.By_Zcross.Position = [950, 100, 50, 25];
            push.By_Zcross.Text = 'By';
            
            push.B_Zcross = uibutton(push.p2);
            push.B_Zcross.Position = [950, 150, 50, 25];
            push.B_Zcross.Text = '|B|';
                        
        end
        function param = get.param(push)
            w1 = get(push.wL, 'Value');
            w2 = get(push.wC, 'Value');
            w3 = get(push.wR, 'Value');
            h1 = get(push.hL, 'Value');
            h2 = get(push.hC, 'Value');
            h3 = get(push.hR, 'Value');
            Z1 = get(push.ZL, 'Value');
            Z2 = get(push.ZC, 'Value');
            Z3 = get(push.ZR, 'Value');
            Y1 = get(push.YL, 'Value');
            Y2 = get(push.YC, 'Value');
            Y3 = get(push.YR, 'Value');
            K1 = get(push.KL, 'Value');
            K2 = get(push.KC, 'Value');
            K3 = get(push.KR, 'Value');
            param = [w1, h1, Z1, Y1, K1;
                w2, h2, Z2, Y2, K2;
                w3, h3, Z3, Y3, K3];
            
        end
       

    end
end