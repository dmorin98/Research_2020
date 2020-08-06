function  MRI

clc %clear command window
%% initialize or declare global variables
global a
global gradient
global width height
global x y Q D output recalculate h
global N M msg minLine maxLine potLine YLine XLine
global X Y B X_mesh Y_mesh PHI method BX BY XLin YLin dataToExport
h = []; 
%initialization
BX = 0; BY = 0; XLin = 0; YLin = 0;
%initialize method and dataToExport
method = 'ac'; dataToExport = 'M';
%initialize potLine
potLine = 0; recalculate = 0;
%initialize YLine and XLine
YLine = []; XLine = [];
%% ------------ GUI layout ---------------

% set colour to be default
panelColor = get(0,'DefaultUicontrolBackgroundColor');

% create a figure
f = figure('Units', 'normalized',...% normalized uints between [0,1]
    'Position',[0.1 0.05 0.8 0.78],... % position of the figure
    'Color',panelColor,... % default color
    'Name','MRI'); % title of the figure

% Add about button
addToolbar = uitoolbar(f); % add toolbar to hold about and help buttons
cdat_about = imread('about.bmp','bmp');% load image
aboutPushtool= uipushtool(addToolbar,'CData',cdat_about,...
    'TooltipString','About This Program',...% title
    'ClickedCallback',@about_callback);% callback function

% Add help button
cdat_help = imread('help.bmp','bmp');% load image
helpPushtool= uipushtool(addToolbar,'CData',cdat_help,...
    'TooltipString','Click for Help (Windonws Only)',...% title
    'ClickedCallback',@help_callback);% callback function
%% Create the top left uipanel container
topLeftPanel = uipanel('BorderType', 'etchedin',...
    'BackgroundColor',panelColor,...
    'Units','normalized',...
    'Position',[0.01 0.8 0.3 0.2],...
    'Parent',f,...% parent figure is f
    'title', '1.Choose a method and a coordinate: ');% name of the panel

%% Create the bottom left panel container
bottomLeftPanel = uipanel('bordertype','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','normalized',...
    'Position',[0.01 0 0.3 0.55],...
    'Title', '4. Scalar Potential Plot ',...
    'Parent',f);
%% Create the bottom right panel container
bottomRightPanel = uipanel('bordertype','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','normalized',...
    'Position',[0.31 0 0.69 0.55],...
    'Parent',f);

%% Create the middle left panel container
middleLeftPanel = uipanel('bordertype','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','normalized',...
    'Position', [0.01 0.55 0.3 0.25],...
    'Parent',f,...
    'Title', '2. Input Variables: ');

%% Create the top right panel container
topRightPanel = uipanel('bordertype','etchedin',...
    'BackgroundColor',panelColor,...
    'Units','normalized',...
    'Position', [0.31 0.55 0.69 0.45],...
    'Title', '3. Magnetic Field Plot ',...
    'Parent',f);

%% Add two axes 
% Add scalar potential axes 
handles.scalarPotential = axes('parent',bottomRightPanel,...
    'Position', [0.14 0.12 0.8 0.85],...
    'tag','scalarPotential');

% Add string
str_scalarPotential = uicontrol('Style','text',...
    'String','Scalar Potential Plot',...
    'Units','normalized',...
    'Position',[0.4 0 0.3 0.05],...
    'parent',bottomRightPanel);

%%
%Add magnetic field axes
handles.magneticField = axes('parent',topRightPanel,...
    'Position', [0.15 0.13 0.6 0.6],...
    'tag','magneticField');

% Add string
str_magneticField = uicontrol('Style','text',...
    'String','Magnetic Field Plot',...
    'Units','normalized',...
    'Position',[0.13 0 0.7 0.05],...
    'parent',topRightPanel);

% Add the Y Cross Section plot axes
handles.magneticFieldX = axes('parent',topRightPanel,...
    'Position', [0.15 0.85 0.6 0.15],...
    'tag','scalarPotential',...
    'HandleVisibility','callback');

% Add strings and labels
str_CrossSectionX_Xlabel = uicontrol('Style','text',...
    'String','X Cross Section Plot','Units','normalized',...
    'Position',[0.13 0.74 0.7 0.04],'fontsize',8,...
    'parent',topRightPanel);
str_CrossSectionX_Ylabel = uicontrol('Style','text',...
    'String','Y','Units','normalized',...
    'Position',[0 0.9 0.05 0.05],'fontsize',8,...
    'parent',topRightPanel);

% Add the X Cross Section plot axes
handles.magneticFieldY = axes('parent',topRightPanel,...
    'Position', [0.87 0.13 0.1 0.6],...
    'tag','scalarPotential',...
    'HandleVisibility','callback',...
    'parent',topRightPanel);

% Add strings and labels
ylabel(handles.magneticFieldY,'Y Cross Section','fontsize',8);
str_CrossSecitonY_Xlabel = uicontrol('Style','text',...
    'String','X','Units','normalized',...
    'Position',[0.87 0 0.1 0.06],'fontsize',8,...
    'parent',topRightPanel);

%Add ymin slider
yminSlider = uicontrol('Style','slider',...
    'Units','normalized',...
    'Position',[0.02 0.1 0.02 0.85],...
    'sliderstep',[0.05 0.05],...% step size
    'min',0,'max',1,... % set the slider value to be within [0,1] and convert other values to a number between [0,1].
    'value',0,... % set current value to be 0
    'BackgroundColor',[1 1 1],...
    'parent',bottomRightPanel);

% Add strings
str_yminSlider = uicontrol('Style','text',...
    'String','Ymin',...
    'Units','normalized',...
    'Position',[0 0.96 0.05 0.03],...
    'parent',bottomRightPanel,...
    'HandleVisibility','on');

%Add ymin slider textbox. User can input ymin value manually.
yminBox = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0 0.01 0.05 0.05],...
    'String','1.5',...
    'BackgroundColor',[1 1 1],...
    'parent',bottomRightPanel,...
    'HandleVisibility','on',...
    'Callback',@yminBox_callback);

%set yminSlider callback function
set(yminSlider,'callback',@yminSlider_callback);

%Add ymax slider
ymaxSlider = uicontrol('Style','slider',...
    'Units','normalized',...
    'Position',[0.06 0.1 0.02 0.85],...
    'sliderstep',[0.05 0.05],...
    'min',0,'max',1,...% see yminSlider
    'value',0,...
    'BackgroundColor',[1 1 1],...
    'parent',bottomRightPanel);

str_ymaxSlider = uicontrol('Style','text',...
    'String','Ymax',...
    'min',1.5,'max',5,...
    'Units','normalized',...
    'Position',[0.05 0.96 0.05 0.03],...
    'parent',bottomRightPanel,...
    'HandleVisibility','on');

%Add ymax slider textbox. User can input ymax value manually.
ymaxBox = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.06 0.01 0.05 0.05],...
    'BackgroundColor',[1 1 1],...
    'String','5',...
    'parent',bottomRightPanel,...
    'HandleVisibility','on',...
    'Callback',@ymaxBox_callback);

%set ymaxSlider callback function
set(ymaxSlider,'callback',@ymaxSlider_callback);


%Add Y slider
YSlider = uicontrol('Style','slider',...
    'Units','normalized',...
    'Position',[0.02 0.1 0.02 0.65],...
    'sliderstep',[0.05 0.05],...
    'min',0,'max',1,... % set the slider value to be within [0,1] and convert other values to a number between [0,1].
    'value',0,... % set current value to be 0
    'BackgroundColor',[1 1 1],...
    'parent',topRightPanel);

% Set Y slider callback function
set(YSlider,'callback',@YSlider_callback);

% Add strings
str_YSlider = uicontrol('Style','text',...
    'String','Y',...
    'FontWeight','bold',...
    'Units','normalized',...
    'Position',[0.005 0.75 0.05 0.05],...
    'parent',topRightPanel,...
    'HandleVisibility','on');

% Add text to show the current value of Y slider
YText = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0 0.01 0.05 0.06],...
    'parent',topRightPanel,...
    'HandleVisibility','on',...
    'Callback',@YText_callback);

%Add X slider
XSlider = uicontrol('Style','slider',...
    'Units','normalized',...
    'Position',[0.07 0.1 0.02 0.65],...
    'sliderstep',[0.05 0.05],...
    'min',0,'max',1,...% see yminSlider
    'value',0,...
    'BackgroundColor',[1 1 1],...
    'parent',topRightPanel);

% Set X slider callback function
set(XSlider,'callback',@XSlider_callback);

% Add strings
str_XSlider = uicontrol('Style','text',...
    'String','X',...
    'FontWeight','bold',...
    'min',1.5,'max',5,...
    'Units','normalized',...
    'Position',[0.055 0.75 0.05 0.05],...
    'parent',topRightPanel,...
    'HandleVisibility','on');

% Add text to show the current value of X slider
XText = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0.055 0.01 0.06 0.06],...
    'parent',topRightPanel,...
    'HandleVisibility','on',...
    'Callback',@XText_callback);

%% Add methodRbtnGroup 

methodRbtnGroup = uibuttongroup('Units','normalized',...
    'parent',topLeftPanel);

analyticalCartesianRbtn = uicontrol('Style','Radio',...
    'String','Analytical Cartesian',...
    'tag','ac',...% use tags to identify buttons
    'Units','normalized',...
    'Position',[0.05 0.75 0.6 0.16],...
    'Parent',methodRbtnGroup);

analyticalPolarRbtn = uicontrol('Style','Radio',...
    'String','Analytical Polar',...
    'tag','ap',...% use tags to identify buttons
    'Units','normalized',...
    'Position',[0.05 0.45 0.6 0.16],...
    'Parent',methodRbtnGroup);

numericalSphericalRbtn = uicontrol('Style','Radio',...
    'String','Numerical Spherical     Iteration',...
    'tag','ns',...% use tags to identify buttons
    'Units','normalized',...
    'Position',[0.05 0.15 0.7 0.16],...
    'Parent',methodRbtnGroup);

% function to call when selection of the button changes
set(methodRbtnGroup, 'SelectionChangeFcn',@methodVars); 
set(methodRbtnGroup, 'Visible','on');

%Add iteration button
%When user clicks 'Iteration', call function iteration_callback
iteration = uicontrol('Style','edit',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.15 0.15 0.18],...
    'parent',topLeftPanel);

%% Add strings for input variables
str_a = uicontrol('Style','text',...
    'String','a(cm)',...
    'Units','normalized',...
    'Position',[0.01 0.8 0.12 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_gradient = uicontrol('Style','text',...
    'String','Gradient/B(/cm)',...
    'Units','normalized',...
    'Position',[0.24 0.8 0.7 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_width = uicontrol('Style','text',...
    'String','Width(cm)',...
    'Units','normalized',...
    'Position',[0 0.46 0.21 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_height = uicontrol('Style','text',...
    'String','Height(cm)',...
    'Units','normalized',...
    'Position',[0.5 0.46 0.22 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_x = uicontrol('Style','text',...
    'String','x(cm)',...
    'Units','normalized',...
    'Position',[0.01 0.64 0.12 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_y = uicontrol('Style','text',...
    'String','y(cm)',...
    'Units','normalized',...
    'Position',[0.35 0.64 0.5 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_N = uicontrol('Style','text',...
    'String','N',...
    'Units','normalized',...
    'Position',[0 0.3 0.1 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

str_M = uicontrol('Style','text',...
    'String','M',...
    'Units','normalized',...
    'Position',[0.55 0.3 0.1 0.1],...
    'parent',middleLeftPanel,...
    'HandleVisibility','on');

%% Add text edit boxes for input variables
var_a = uicontrol('Style','edit',...
    'Tag','var_a',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'String','',...
    'Position',[0.21 0.8 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);

var_gradient = uicontrol('Style','edit',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.8 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);
var_x = uicontrol('Style','edit',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.21 0.64 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);
var_y = uicontrol('Style','edit',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.64 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);
var_width = uicontrol('Style','edit',...
    'Units','normalized',...
    'enable','on',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.21 0.47 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);

var_height = uicontrol('Style','edit',...
    'Units','normalized',...
    'enable','on',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.47 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);

var_N = uicontrol('Style','edit',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.21 0.3 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);

var_M = uicontrol('Style','edit',...
    'Units','normalized',...
    'enable','off',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.75 0.3 0.2 0.12],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @getVariables);

%Add run button
%user clicks 'run' to run the program
runBtn = uicontrol('String','Run',...
    'Units','normalized',...
    'Position',[0.25 0.02 0.2 0.18],...
    'parent',middleLeftPanel,...
    'FontWeight','bold',...
    'HandleVisibility','on',...
    'Callback',@runBtnClicked);

%Add clear button
%When user clicks 'Clear', all the input variables will be cleared
clearInputBtn = uicontrol('string','Clear',...
    'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Position',[0.5 0.02 0.2 0.18],...
    'parent',middleLeftPanel,...
    'HandleVisibility','Callback',...
    'Callback', @clearInputBtnClicked);


%Add Ymin/Ymax/Xmax/Xmin textboxes
%Ymin/Ymax are the range for ymin/ymax sliders and ymin/ymax textboxes.
setXmin = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.05 0.38 0.15 0.06],...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'String','-7'); % Xmin default value
setXmax = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.3 0.38 0.15 0.06],...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'String','7'); % Xmax default value
setYmin = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.05 0.53 0.15 0.06],...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'String', '1.5'); % Ymin default value
setYmax = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.3 0.53 0.15 0.06],...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'String','5');% Ymax default value

str_setXmin = uicontrol('Style','text',...
    'String','Set Xmin:',...
    'Units','normalized',...
    'Position',[0.01 0.46 0.28 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');
str_setXmax= uicontrol('Style','text',...
    'String','Set Xmax:',...
    'Units','normalized',...
    'Position',[0.25 0.46 0.28 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');
str_setYmin = uicontrol('Style','text',...
    'String','Set Ymin:',...
    'Units','normalized',...
    'Position',[0.01 0.61 0.28 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');
str_setYmax= uicontrol('Style','text',...
    'String','Set Ymax:',...
    'Units','normalized',...
    'Position',[0.25 0.61 0.28 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');

%clear SetX and SetY
clearSetX = uicontrol('Units','normalized',...
    'Position',[0.5 0.38 0.18 0.065],...
    'String','Clear',...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'Callback',@clearX_callback);
clearSetY = uicontrol('Units','normalized',...
    'Position',[0.5 0.53 0.18 0.065],...
    'String','Clear',...
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'Callback',@clearY_callback);

%Add replot button and set its callbck function
replotBtn = uicontrol('String','Replot',...
    'Units','normalized',...
    'Position',[0.75 0.45 0.18 0.07],...
    'parent',bottomLeftPanel,...
    'FontWeight','bold',...
    'Value',false,...
    'HandleVisibility','on',...
    'Callback',@replotBtnClicked);

%Add output coeff text edit box
%when 'run' button is clicked, program returns output coefficients in this
%box
outputCoeff = uicontrol('Style','list',...
    'Units','normalized',...
    'Position',[0 0.73 0.4 0.2],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');

% this box is for user to input output coefficient manually 
handles.userOutputCoeff = uicontrol('Style','edit',...
    'Units','normalized',...
    'Position',[0.5 0.73 0.4 0.2],...
    'min',0,'max',10,...% maximum 10 ouput coeff can be entered at the box
    'BackgroundColor',[1 1 1],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');

% Add strings
str_output = uicontrol('Style','text',...
    'String','Output Coefficients:',...
    'Units','normalized',...
    'Position',[0.01 0.94 0.4 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');
str_userOutput = uicontrol('Style','text',...
    'String','Input Output Coefficients:',...
    'Units','normalized',...
    'Position',[0.42 0.94 0.55 0.04],...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on');

%Add recalculate button
%when recalculate button is clicked, program takes 'outputCoeff' and
%recalculate scalar potential plot and magnetic field plot
recalculateBtn = uicontrol('String','Recalculate',...
    'Units','normalized',...
    'Position',[0.5 0.65 0.4 0.06],...
    'FontWeight','bold',...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'Callback',@recalculateBtnClicked);

%Add export buttons and callbck functions
exportRbtnGroup = uibuttongroup('Units','normalized',...
    'parent',bottomLeftPanel);
set(exportRbtnGroup, 'SelectionChangeFcn',@exportWhat);% functiont to call when selection changes
set(exportRbtnGroup, 'Visible','on');

% export magnetic field plot
exportM = uicontrol('style','radio',...
    'String','Magnetic Field B',...
    'Units','normalized',...
    'Position',[0.05 0.29 0.5 0.065],...
    'HandleVisibility','on',...
    'tag','M',...
    'Parent',exportRbtnGroup);

%Add export button and set its callbck function
%export magnetic field plot in X cross section
exportXM = uicontrol('style','radio',...
    'String','X Cross Section of B',...
    'Units','normalized',...
    'Position',[0.05 0.23 0.6 0.065],...
    'HandleVisibility','on',...
    'tag','XM',...% tags to identify buttons
    'Parent',exportRbtnGroup);

%Add export button and set its callbck function
%export magnetic field plot in Y cross section
exportYM = uicontrol('style','radio',...
    'String','Y Cross Section of B',...
    'Units','normalized',...
    'Position',[0.05 0.17 0.6 0.065],...
    'HandleVisibility','on',...
    'tag','YM',...% tags to identify buttons
    'Parent',exportRbtnGroup);

%Add export button and set its callbck function
%export scalar potenial plot
exportS = uicontrol('style','radio',...
    'String','Scalar Potential',...
    'Units','normalized',...
    'Position',[0.05 0.11 0.5 0.065],...
    'HandleVisibility','on',...
    'tag','S',...% tags to identify buttons
    'Parent',exportRbtnGroup);

%Add export button and set its callbck function
%export pole piece
exportPole = uicontrol('style','radio',...
    'String','Pole Piece',...
    'Units','normalized',...
    'Position',[0.05 0.05 0.6 0.065],...
    'HandleVisibility','on',...
    'tag','Pole',...
    'Parent',exportRbtnGroup);

% to export 
exportBtn = uicontrol('String','Export',...
    'Units','normalized',...
    'Position',[0.75 0.15 0.18 0.065],...
    'FontWeight','bold',...
    'parent',bottomLeftPanel,...
    'HandleVisibility','on',...
    'Callback',@exportBtnClicked);

%% enable and disable input variables according to which method is selected
    function methodVars(object, eventdata)
        method = lower(get(eventdata.NewValue,'tag'));
        switch method
            case 'ac' % Analytical cartesian method
                set(var_a,'enable','on')
                set(var_M, 'enable','off')
                
            case 'ap' % Analytical polar method
                set(var_a,'enable','off')
                set(var_M, 'enable','off')
                
            case 'ns' % Numerical analytical method
                set(var_a,'enable','off')
                set(var_M, 'enable','on')
                
        end
    end


%% get user inputs and convert from strings to double
    function getVariables(object, eventdata)

        a = str2double(get(var_a,'String'));
        gradient = str2double(get(var_gradient,'String'));
        width = str2double(get(var_width,'String'));
        height = str2double(get(var_height,'String'));
        x = str2double(get(var_x,'String'));
        y = str2double(get(var_y,'String'));
        N = str2double(get(var_N,'String'));
        M = str2double(get(var_M,'String'));

    end
%% replot magnetic field and scalar potential using user input output coefficient
    function recalculateBtnClicked(hObject,event_data)
        recalculate = 1;
        %when run is clicked, check to see which method is selected
        axes(handles.magneticField);
        cla                                    %clear axes for new plot
        axes(handles.scalarPotential);
        cla                                    %clear axes for new plot

        [xmin, xmax] = getXminXmax;            % get Xmin/Xmax range
        if (isempty(xmin)&&isempty(xmax))
        else
            xlim([xmin xmax]);                 % set x-axis limits
        end

        methodCoordinate_callback(hObject)     %check which routine to use

        potLine = 0;                           % initialize potLine
        YLine = [];
        XLine = [];
        plotDefaultYlims                       % plot default Ylim lines
        draw_pole(2,4)                         % draw default Ymin@2 and Ymax@4
        recalculate = 0;
        % reset the 'recalculate' so that the program will not use
        % user input output coefficients.
        
       
    end
%% get user inputs and call appropriate method
    function runBtnClicked (hObject,event_data)

        %when run is clicked, check to see which method is selected
        axes(handles.magneticField);
        cla   %clear axes for new plot

        axes(handles.scalarPotential);
        cla
        
        methodCoordinate_callback(hObject);     %check which routine to use


        [xmin, xmax] = getXminXmax;            % get Xmin/Xmax range

        if (isempty(xmin)&&isempty(xmax))

        else
            xlim([xmin xmax]);                 % set x-axis limits
        end

        potLine = 0;                           % initialize potLine
        YLine = [];                            % initialize YLine     
        XLine = [];                            % initialize XLine             
        plotDefaultYlims                       % plot default Ylim lines
        draw_pole(2,4)                         % draw default Ymin@2 and Ymax@4
      
        
    end %end of function

%% function to update output coefficients
    function updateOutputCoeff(object)

        set(outputCoeff,'String',object)       % set the output coeffs

    end

%% function to clear all the input variables
    function clearInputBtnClicked(hObject,event_data,handles)
        set(var_a,'String','');         set(var_gradient,'String','');
        set(var_width,'String','');     set(var_height,'String','');
        set(var_x,'String','');         set(var_y,'String','');
        set(var_N,'String','');         set(var_M,'String','');
    end

%% function to clear the user input Xmin and Xmax value
    function clearX_callback(hObject,event_data,handles)
        set(setXmin,'String',''); set(setXmax,'String','');

    end
%% function to clear the user input Ymin and Ymax value
    function clearY_callback(hObject,event_data,handles)
        set(setYmin,'String',''); set(setYmax,'String','');
    end

%% function to plot ylim lines based on ymin slider values;
%  highlight the selected countour.
    function yminSlider_callback(hObject,event_data)

        %{
        get the Ymin/Ymax values;
        get the slider value;
        convert the slider value to be the value between [Ymin,Ymax]
        %}
        [newMinValue,newMaxValue]=convertValues;

        % check to see if replotBtn is clicked: 1=yes; []=not
        replot = get(replotBtn,'UserData');

        % if not replot, redraw ymin line eveytime when ymin slider value changes.
        if(isempty(replot))
            delete(minLine)
            pt1=[-8 8]; pt2=[newMinValue newMinValue];  % draw ymin line
            axes(handles.scalarPotential);
            minLine = plot(pt1,pt2,'r');
            hold on

            % if replot, redraw ymin and ymax line for once.
        else
            delete(minLine);delete(maxLine);
            pt1=[-8 8]; pt2=[newMinValue newMinValue];
            pt3=[-8 8]; pt4=[newMaxValue newMaxValue];

            axes(handles.scalarPotential);
            minLine = plot(pt1,pt2,'r');
            maxLine = plot(pt3,pt4);
            hold on;
            % after redraw ymin and ymax once, reset replotBtn 'UserData' value
            set(replotBtn,'UserData',0   );

        end

        %%%%  call draw_pole function to select appropriate contour
        draw_pole (newMinValue,newMaxValue)
        %%%%

    end
%% Silimar to yminSlider_callback
    function ymaxSlider_callback(hObject,event_data)
        %%%
        [newMinValue,newMaxValue] = convertValues;
        %%%

        replot = get(replotBtn,'UserData');

        if(isempty(replot))

            delete(maxLine);
            pt1=[-8 8]; pt2=[newMaxValue newMaxValue];
            axes(handles.scalarPotential);
            maxLine = plot(pt1,pt2);
            hold on

        else
            delete(minLine);delete(maxLine);
            pt1=[-8 8]; pt2=[newMinValue newMinValue];
            pt3=[-8 8]; pt4=[newMaxValue newMaxValue];

            axes(handles.scalarPotential);
            minLine = plot(pt1,pt2,'r');
            maxLine = plot(pt3,pt4);
            hold on;
            set(replotBtn,'UserData',0);
        end

        %%%%
        draw_pole (newMinValue,newMaxValue)
        %%%%
    end


%% function to plot ymin lines and select appropriate contour
    function yminBox_callback(hObject, event_data)
        [t1,t2] = getYminYmax;
        [yminInput,ymaxInput] = getYminYmaxBox;

        if (yminInput<t1) % user has to input a value within the Ymin and Ymax range
            errordlg('Must be within Ymin and Ymax range','Bad Input','modal')

        else
            ratio = (yminInput-t1)/(t2-t1); % conver ymin box value to be within [0,1]
            set(yminSlider,'value',ratio)

            delete(minLine) % redraw ymin lines with the new value
            pt3=[-8 8]; pt4=[yminInput yminInput];
            axes(handles.scalarPotential);
            minLine = plot(pt3,pt4,'r');

            %%%%  call draw_pole function to select appropriate contour
            draw_pole (yminInput,ymaxInput)
            %%%%
        end

    end

%% Similar to yminBox_callback
    function ymaxBox_callback(hObject, event_data)
        [t1,t2] = getYminYmax;
        [yminInput,ymaxInput] = getYminYmaxBox;

        if (ymaxInput>t2)
            errordlg('Must be within Ymin and Ymax range','Bad Input','modal')

        else
            %%%%
            draw_pole (yminInput,ymaxInput)
            %%%%
            ratio = (ymaxInput-t1)/(t2-t1);
            set(ymaxSlider,'value',ratio)

            delete(maxLine)
            pt3=[-8 8]; pt4=[ymaxInput ymaxInput];
            axes(handles.scalarPotential);
            maxLine = plot(pt3,pt4);

        end

    end
%% Convert ymin and ymax to be values between [0,1]
% [0,1] is the range for both sliders.
    function [newMinValue, newMaxValue] = convertValues
        % Get the Ymin and Ymax range [t1,t2]
        [t1,t2] = getYminYmax;

        % Get the current slider value 'ratio', which is a value between[0,1].
        % Convert this ratio to be a value between [t1,t2] for both
        % ymin/ymax textboxes
        ratio = get(ymaxSlider,'value');
        newMaxValue = t1 + ratio*(t2-t1);
        set(ymaxBox,'String',num2str(newMaxValue))

        ratio = get(yminSlider,'value');
        newMinValue = t1 + ratio*(t2-t1);
        set(yminBox,'String',num2str(newMinValue))

    end
%% funtion to plot Default Ylims
    function plotDefaultYlims
        % Convert the values and plot
        set(yminSlider,'value',(2-1.5)/(5-1.5));
        set(yminBox,'value',2);
        set(ymaxSlider,'value',(4-1.5)/(5-1.5));
        set(ymaxBox,'value',4);
        left = str2num(get(setXmin,'string'));
        right = str2num(get(setXmax,'string'));

        pt1=[left right]; pt2=[2 2];
        axes(handles.scalarPotential);
        minLine = plot(pt1,pt2,'r');
        hold on

        pt3=[left right]; pt4=[4 4];
        axes(handles.scalarPotential);
        maxLine = plot(pt3,pt4,'b');

    end
%% function to plot default ymin and ymax lines when replot is clicked
    function replotDefaultYlims

        [ymin, ymax] = getYminYmax;

        pt1=[-7 7]; pt2=[ymin ymin];
        axes(handles.scalarPotential);
        minLine = plot(pt1,pt2,'r');
        hold on

        pt3=[-7 7]; pt4=[ymax ymax];
        axes(handles.scalarPotential);
        maxLine = plot(pt3,pt4,'b');

        draw_pole(ymin,ymax)

        %% set ymin and ymax box value corresponding to the slider values
        [newMinValue, newMaxValue] = convertValues;

    end

%% Get Xmin and Xmax values
    function [xmin, xmax] = getXminXmax

        xminStr = get(setXmin, 'string');
        xmin = str2num(xminStr);

        xmaxStr = get(setXmax, 'string');
        xmax = str2num(xmaxStr);

    end

%% Get Ymin and Ymax values
    function [ymin, ymax] = getYminYmax

        yminStr = get(setYmin, 'string');
        ymin = str2num(yminStr);
        ymaxStr = get(setYmax, 'string');
        ymax = str2num(ymaxStr);

    end
%% Get ymin/ymax slider textboxes values
    function [ymin,ymax] = getYminYmaxBox

        yminStr = get(yminBox,'String');
        ymin = str2num(yminStr);
        ymaxStr = get(ymaxBox,'String');
        ymax = str2num(ymaxStr);

    end
%% if replot button is pressed, replot using new values
    function replotBtnClicked(hObject,event_data)
        set(replotBtn,'UserData',1) % Use 'UserData' to check if replotBtn is clicked.

        clearAxes % Clear axes

        % check to see which method and method is selected
        switch  method  % check which method

            case 'ac' % tag for analytical cartesian
                analytical_cartesian_replot


            case 'ap' % tag for analytical polar
                analytical_polar_replot


            case 'ns'% tag for numerical spherical
                numerical_spherical_replot(hObject)

        end % end of switch

        maxLine = 0; % Initialize maxLine handle
        minLine = 0; % Initialize minLine handle
        potLine = 0; % Initialize potLine handle
        replotDefaultYlims % replot using new Ymin/Ymax values.

    end

%% check to see which method and coordinate is selected and then call
%  callback functions accordingly
    function methodCoordinate_callback(hObject,event_data,handles)
        D = [0];
        % start timer and set the time status to 'on'
        status = 'on';
        runningStatus(status);
        
        
        % check to see which method and method is selected
       
        switch  method  % check which method

            case 'ac'% tag for analytical cartesian
                D = analytical_cartesian_callback(hObject);
                analytical_cartesian_replot(hObject);

            case 'ap'% tag for analytical polar
                D = analytical_polar_callback(hObject);
                analytical_polar_replot(hObject);

            case 'ns'% tag for numerical spherical
                D = numerical_spherical_callback(hObject);
                numerical_spherical_replot(hObject)

        end % end of switch

        % set the timer status to 'off'
        status = 'off';
        runningStatus(status);

        % Initialize maxLine and minLine
        maxLine = 0;
        minLine = 0;

    end

%%
    function D = analytical_cartesian_callback(hObject)

        getVariables (hObject); %get input variables
        output = str2num(get(handles.userOutputCoeff,'String')); % convert strings to numbers for calculation
               
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        % check if to use userinput output coefficients D
        if(recalculate == 1)
            D = output;
            M = 0;
            N = length(D);
        else
             B0 = 1;
        Gy = gradient;
        r0 = y;

        for n = 1:N
            for i = 1:N
                A(i,n) = (-1*n*a)^(i-1)*exp(-n*a*r0);
            end
        end

        M = inv(A)*[B0; Gy; zeros(1,N-2)];
            D = M./a./(1:N)';
        end

        updateOutputCoeff (D); % update output coefficients

        x_width = linspace(x-width/2,x+width/2,101);
        y_height = linspace(y-height/2,y+height/2,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);


        Nk = length(D);

        PHI = zeros(size(X_mesh));
        Bx = zeros(size(X_mesh));
        By = Bx;

        for n = 1:Nk
      
            Bx = Bx + exp(-n.*a.*Y_mesh).*(n.*a.*D(n).*cos(n.*a.*X_mesh));
            By = By + exp(-n.*a.*Y_mesh).*(n.*a.*D(n).*sin(n.*a.*X_mesh));
       
        end

        B = sqrt(Bx.^2+By.^2);
        axes(handles.magneticField);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        
        contour(X_mesh,Y_mesh,B,50);
        hold on
        
    end


%%
     function D = numerical_spherical_callback(hObject)

        getVariables (hObject);%get input variables
        output = str2num(get(handles.userOutputCoeff,'String')); % convert strings to numbers for calculation
        
        numOfIteration = str2num(get(iteration,'string')); 
        % check to see the number of iteration that user entered. 

        %%%% plot the B0 field

        if(recalculate == 1)
            D = output';
            M = 0;
            N = length(D);
        else
            % Computation starts here....
             Q = ones(size(1:M));
            % X = fminsearch(@(X) optimize_spherical(X,gradient,x,y,width,height,N), Q,optimset('MaxFunEvals',Iterations));
        
            % check to see if user specifies the number of iteration
            if(isempty(numOfIteration))
                X = fminsearch(@(X) optimize_spherical(X,gradient,x,y,width,height,N), Q);
                % use the user input number of iteration
            else
                X = fminsearch(@(X) optimize_spherical(X,gradient,x,y,width,height,N), Q, optimset('MaxFunEvals',numOfIteration));
                % otherwise, do not use iteration
            end
            D = X;
            Gy = gradient;
            r0 = y;
            B0 = 1;

            Bvec = [B0 Gy];

            for kk = 3:N;
                Bvec = [Bvec 0];
            end

            Bvec = Bvec(1:N);

            D0 = calc_coeffs_constrained(Bvec',D,r0)';
            D = [D0 D];
        end
        
        updateOutputCoeff (D); %output coefficients
       
        x_width = linspace(x-width/2,x+width/2,101);
        y_height = linspace(y-height/2,y+height/2,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);

        R = sqrt(X_mesh.^2+Y_mesh.^2);
        Theta = acos(Y_mesh./R).*sign(X_mesh);

        Nk = length(D);

        PHI = zeros(size(R));
        Br = zeros(size(R));
        Bt = Br;

        for n = 1:Nk
            L = legendre(n,cos(Theta));

            Br = Br+(-n-1).*D(n).*R.^(-n-2).*reshape(L(1,:,:),size(R));

            Bt = Bt + D(n).*R.^(-n-2).*-sin(Theta).*dLdx(n,cos(Theta));

        end

        B = sqrt(Br.^2+Bt.^2);
        axes(handles.magneticField);
        axis([x-width/2 x+width/2 y-height/2 y+height/2])
        contour(X_mesh,Y_mesh,B,50);
        hold on

    end

%%
    function D = analytical_polar_callback(hObject)
        getVariables (hObject);%get input variables
        output = str2num(get(handles.userOutputCoeff,'String')); % convert strings to numbers for calculation
        
        if(recalculate == 1)
            D = output;
            M = 0;
            N = length(D);
        else
            B0 = 1;
            Gy = gradient;
            r0 = y;


            for n = 2:(N+1)
                for i = 1:(N)
                    A(i,n) = prod(-n-(0:(i-1))).*r0.^(-n-i).*(-1).^ceil((n-1)/2);
                end
            end

            A = A(:,2:(N+1));

            C = inv(A)*[B0; Gy; zeros(1,N-2)'];
            D = ([0;C]);
        end
        updateOutputCoeff (D); %output coefficients

        x_width = linspace(x-width/2,x+width/2,101);
        y_height = linspace(y-height/2,y+height/2,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);

        R = sqrt(X_mesh.^2+Y_mesh.^2);
        Theta = atan2(Y_mesh,X_mesh);

        Nk = length(D);

        PHI = zeros(size(R));
        Br = zeros(size(R));
        Bt = Br;

        C = zeros(size(D));
        Dx = C;

        Dx(1:2:end)= D(1:2:end);
        C(2:2:end)= D(2:2:end);

        for n = 1:Nk

            Br = Br - n.*C(n).*R.^(-n-1).*cos(n.*Theta)-n.*Dx(n).*R.^(-n-1).*sin(n.*Theta);
            Bt = Bt - n.*C(n).*R.^(-n-1).*sin(n.*Theta)+n.*Dx(n).*R.^(-n-1).*cos(n.*Theta);

        end % for

        B = sqrt(Br.^2+Bt.^2);
   
        axes(handles.magneticField)
        axis([x-width/2 x+width/2 y-height/2 y+height/2])
        contour(X_mesh,Y_mesh,B,100);
        
        hold on

    end

%% function to show program is running
    function runningStatus(status)
        T = timer;
        set(timer,'userData','status');

        switch (status)
            case 'on'
                % waiting message when program is running
                msg = waitbar(0,'Please wait...this may take a while');
                for i=1:400, % computation here %
                    waitbar(i/400)
                end
                % close the message when program is done
            case 'off'
                close(msg);
        end
    end
%% function to clear axes
    function clearAxes
        axes (handles.scalarPotential)
        cla
    end
%% Replot scalar potential
    function analytical_cartesian_replot(hObject,event_data)
        
        [xmin,xmax] = getXminXmax; % get the new lims set by users
        [ymin,ymax] = getYminYmax;

        x_width = linspace(xmin,xmax,101);
        y_height = linspace(ymin,ymax,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);

        Nk = length(D);

        PHI = zeros(size(X_mesh));


        for n = 1:Nk
            PHI = PHI + exp(-n.*a.*Y_mesh).*(D(n).*cos(n.*a.*X_mesh));
            
        end

        axes(handles.scalarPotential);
        contour(X_mesh,Y_mesh,PHI,100);

        hold on
        axis([xmin xmax ymin ymax]);
        %colorBar = colorbar('location','eastoutside');

    end

%% Replot scalar potential
    function numerical_spherical_replot (hObject,event_data)
       
        [xmin,xmax] = getXminXmax; % get the new lims set by users
        [ymin,ymax] = getYminYmax;

        x_width = linspace(xmin,xmax,101);
        y_height = linspace(ymin,ymax,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);

        R = sqrt(X_mesh.^2+Y_mesh.^2);
        Theta = acos(Y_mesh./R).*sign(X_mesh);

        Nk = length(D);

        PHI = zeros(size(R));


        for n = 1:Nk
            L = legendre(n,cos(Theta));
            PHI = PHI+D(n).*R.^(-n-1).*reshape(L(1,:,:),size(R));

        end

        axes(handles.scalarPotential);
        contour(X_mesh,Y_mesh,PHI,100);
        
        hold on
        axis([xmin xmax ymin ymax]);
        %colorbar('location','eastoutside');


    end

%% Replot scalar potential
    function analytical_polar_replot(hObject,event_data)
        
        [xmin,xmax] = getXminXmax; % get the new lims set by users
        [ymin,ymax] = getYminYmax;

        x_width = linspace(xmin,xmax,101);
        y_height = linspace(ymin,ymax,101);

        [X_mesh Y_mesh] = meshgrid(x_width,y_height);

        R = sqrt(X_mesh.^2+Y_mesh.^2);
        
        Theta = atan2(Y_mesh,X_mesh);
        Nk = length(D);

        PHI = zeros(size(R));


        C = zeros(size(D));
        Dx = C;

        Dx(1:2:end)=D(1:2:end);
        C(2:2:end)=D(2:2:end);

        for n = 1:Nk

            PHI = PHI + C(n).*R.^(-n).*cos(n.*Theta) + Dx(n).*R.^(-n).*sin(n.*Theta);

        end % for

        axes(handles.scalarPotential);
        contour(X_mesh,Y_mesh,PHI,100);
        axis([xmin xmax ymin ymax]);
        
        hold on
       
    end

%% function to draw pole pieces
    function draw_pole (yPmin,yPmax)

        [xmin,xmax] = getXminXmax;

        d_ymax = yPmax;
        z_width = linspace(xmin,xmax,200);

        [zz yy] = meshgrid(z_width,d_ymax);
        N = length(D); %remember to get D first!

        R = sqrt(zz.^2+d_ymax.^2);

        Theta = acos(d_ymax./R).*sign(zz);
        PHI1 = zeros(size(zz));
        
      
        switch method
            case 'ac' 
                %analytical_cartesian_replot
                for n = 1:N
                    PHI1 = PHI1+ exp(-n.*a.*yy).*(D(n).*cos(n.*a.*zz));                    
                end
                
                k = max(PHI1);
                rXt = linspace(-pi./a,pi./a,101);

                for t = 1:length(rXt)
                    Q = [];
                    for n = 1:N
                        Q = [D(n).*cos(n.*a.*rXt(t))  Q];
                    end

                    R = roots([Q -k]);

                    rts = -1./a.*log(R);
                    rtsR = real(rts)./(imag(rts)+eps);
                    rX(t) = rts(find(rtsR==max(rtsR)));

                end

                y1 = real(rX);
                x1 = rXt;

            case 'ap' %analytical polar replot

                [xmin,xmax] = getXminXmax; % get the new lims set by users
                [ymin,ymax] = getYminYmax;

                x_width = linspace(xmin,xmax,101);
                y_height = d_ymax;

                [X_mesh Y_mesh] = meshgrid(x_width,y_height);

                R = sqrt(X_mesh.^2+Y_mesh.^2);
                Theta = atan2(Y_mesh,X_mesh);
                Nk = length(D);

                PHI = zeros(size(R));


                C = zeros(size(D));
                Dx = C;

                Dx(1:2:end)=D(1:2:end);
                C(2:2:end)=D(2:2:end);

                for n = 1:Nk

                    PHI = PHI + C(n).*R.^(-n).*cos(n.*Theta) + Dx(n).*R.^(-n).*sin(n.*Theta);

                end % for

                k = min(PHI);
                T = linspace(0,pi,101);

                for t = 1:length(T)
                    Q = [];
                    for n = 1:N
                        Q = [C(n).*cos(n.*T(t))+Dx(n).*sin(n.*T(t))  Q];
                    end

                    R = roots([Q -k]);
                    rX(t) = max(real(1./R));
                   
                end

                y1 = real(rX.*sin(T));
                x1 = real(rX.*cos(T));

            case 'ns' % numerical spherical replot
                for n = 1:N
                    L = legendre(n,cos(Theta));
                    PHI1 = PHI1+D(n).*R.^(-n-1).*reshape(L(1,:,:),size(R));
                end
                k = min(PHI1);
                
                %%%% find the pole shape

                T = linspace(-pi/2,pi/2,101);

                for t = 1:length(T)
                    Q = 0;
                    for n = 1:N
                        L = legendre(n,cos(T(t)));
                        Q = [D(n).*L(1)  Q];
                    end

                    R = roots([Q -k]);

                    rX(t) = max(real(1./R));

                end

                y1 = real(rX.*cos(T));
                x1 = real(rX.*sin(T));     

        end % end case

        id1 = min(find(y1>yPmin));
        id2 = max(find(y1>yPmin));

        Y=y1((id1):(id2));
        X=x1((id1):(id2));

        m1 = (Y(2)-Y(1))/(X(2)-X(1));
        %
        Y = [yPmin Y yPmin];
        X = [(m1.*X(1)-Y(2)+yPmin)./m1 X -(m1.*X(1)-Y(2)+yPmin)./m1];

        if(potLine) % if potLine exists
            delete(potLine)
        end

        axes(handles.scalarPotential);
        potLine = plot(X,Y,'k','LineWidth', 2);
    end
%% Callback function to plot X cross section 
    function magneticFieldY_callback(hObject,event_data)
        set(YSlider,'userdata',1);
        magneticFieldVectorPlot(hObject);
        set(YSlider,'userdata',0);
    end

%% Callback function to plot Y cross section 
    function magneticFieldX_callback(hObject,event_data)
        magneticFieldVectorPlot(hObject);
    end

%% function to calculate and plot X cross section based on Y slider value;
    function YSlider_callback(hObject,event_data)

        %{
        get the Ymin/Ymax values;
        get the slider value (slider value is between (0,1));
        convert the slider value to be the value between [Ymin,Ymax]
        %}
        [newYValue, newXValue] = convertXY;
        xmin = x - width/2; % set the limits of the plot
        xmax = x + width/2; % set the limits of the plot
        
        delete(YLine); % delete old one
        pt1=[xmin xmax];
        pt2=[newYValue newYValue];

        axes(handles.magneticField)
        YLine = plot(pt1,pt2,'b','LineWidth', 2); % plot the new line
        
        hold on
        magneticFieldX_callback(hObject);
       
    end
%% Silimar to YSlider_callback
    function XSlider_callback(hObject,event_data)
        [newYValue, newXValue] = convertXY;
        ymin = y - height/2; % set the limits of the plot
        ymax = y + height/2; % set the limits of the plot
        
        delete(XLine); % delete old one
        pt1=[ymin ymax]; pt2=[newXValue newXValue];
        axes(handles.magneticField)
        XLine = plot(pt2,pt1,'r','LineWidth', 2); % plot the new line
        
        hold on
        magneticFieldY_callback(hObject);
    end
%% Convert Y and X to be values between [0,1]
% [0,1] is the range for both sliders.
    function [newYValue, newXValue] = convertXY
        
        % Get the current slider value 'ratio', which is a value between[0,1].
        % Convert this ratio to be a value between [t1,t2] for both
        % ymin/ymax textboxes
        % get X and Y slider limits from the width and height information
        xmin = x - width/2;
        xmax = x + width/2;        
        ymin = y - height/2;
        ymax = y + height/2;
        
        ratio = get(YSlider,'value');
        newYValue = ymin + ratio * (ymax-ymin); %newYValue = ymin + ratio * 1;
        set(YText,'String',num2str(newYValue));

        ratio = get(XSlider,'value');
        newXValue = xmin + ratio * (xmax-xmin); %newXValue = xmin + ratio * 1;
        set(XText,'String',num2str(newXValue));

    end
%% Function to plot cross sections
    function magneticFieldVectorPlot(hObject,event_data)
        isYPlot = get(YSlider,'userdata');
        [newYValue, newXValue] = convertXY;
        
        % check to see if 'replot' is clicked
        %%%
        if(isYPlot) % plot Y cross section 
            YLin = linspace(y-height/2,y+height/2,101);
            XLin = newXValue * ones(1,101);
            axes(handles.magneticFieldY);
        else % plot X cross section 
            XLin = linspace(x-width/2,x+width/2,101);
            YLin = newYValue * ones(1,101);
            axes(handles.magneticFieldX);
        end
        %%% end of if

        switch method
            
            case 'ns' % numerical spherical
                R = sqrt(XLin.^2+YLin.^2);
                Theta = acos(YLin./R).*sign(XLin);
                Nk = length(D);
                PHI = zeros(size(R));
                Br = zeros(size(R));
                Bt = Br;

                %%%
                for n = 1:Nk
                    L = legendre(n,cos(Theta));
                    Br = Br+(-n-1).*D(n).*R.^(-n-2).*reshape(L(1,:,:),size(R));
                    Bt = Bt + D(n).*R.^(-n-2).*-sin(Theta).*dLdx(n,cos(Theta));
                end
                %%% end of for
            
            case 'ac' % analytical cartesian
                Nk = length(D);
                PHI = zeros(size(XLin));
                Br = zeros(size(XLin));
                Bt = Br;

                for n = 1:Nk

                    Br = Br + exp(-n.*a.*YLin).*(n.*a.*D(n).*cos(n.*a.*XLin));
                    Bt = Bt + exp(-n.*a.*YLin).*(n.*a.*D(n).*sin(n.*a.*XLin));

                end
                %%%end of for

            case 'ap' %analytical polar
                R = sqrt(XLin.^2+YLin.^2);
                Theta = atan2(YLin,XLin);

                Nk = length(D);

                PHI = zeros(size(R));
                Br = zeros(size(R));
                Bt = Br;

                C = zeros(size(D));
                Dx = C;

                Dx(1:2:end)=D(1:2:end);
                C(2:2:end)=D(2:2:end);

                for n = 1:Nk

                    Br = Br - n.*C(n).*R.^(-n-1).*cos(n.*Theta)-n.*Dx(n).*R.^(-n-1).*sin(n.*Theta);
                    Bt = Bt - n.*C(n).*R.^(-n-1).*sin(n.*Theta)+n.*Dx(n).*R.^(-n-1).*cos(n.*Theta);

                end
                %%% for


        end

        B = sqrt(Br.^2+Bt.^2);
        B(find(B==Inf))=NaN;

        %%%
        if(isYPlot) % Y cross section plot 
            plot(YLin,B,'b');
            ylabel(handles.magneticFieldY,'Y Cross Section','fontsize',8);
            BY = B;
            grid on;
            
        else         % X cross section plot
            plot(XLin,B,'b');
            BX = B;  
            grid on;
        end
        %%% end of if

        axis tight auto;

    end

%% enable and disable input variables according to the method that user selects
    function exportWhat(object, eventdata)
        dataToExport = get(eventdata.NewValue,'tag');  
    end
%% function to export data
    function exportBtnClicked (object, eventdata)
        
        switch dataToExport
            case 'M' % export magnetic field plot
                [file,path] = uiputfile('MagneticField.txt','Save file name');
                savefile = strcat(path,file);
                separator = NaN(1,50); %variables are seperated by 'NaN'
                save(savefile,'X_mesh','separator','Y_mesh','separator','B','-ASCII')
                
            case 'YM' % export Y cross section 
                [file,path] = uiputfile('MagneticField_YCrossSection.txt','Save file name');
                savefile = strcat(path,file);
                separator = NaN(1,50);%variables are seperated by 'NaN'
                save(savefile,'XLin','separator','BY','-ASCII')
                
            case 'XM' % export X cross section
                [file,path] = uiputfile('MagneticField_XCrossSection.txt','Save file name');
                savefile = strcat(path,file);
                separator = NaN(1,50);%variables are seperated by 'NaN'
                save(savefile,'YLin','separator','BX','-ASCII')
            
            case 'S' % export scalar potential 
                [file,path] = uiputfile('ScalarPotential.txt','Save file name');
                savefile = strcat(path,file);
                separator = NaN(1,50);%variables are seperated by 'NaN'
                save(savefile,'X_mesh','separator','Y_mesh','separator','PHI','-ASCII')
                
            case 'Pole'   % export pole piece
                [file,path] = uiputfile('PolePiece.txt','Save file name');
                savefile = strcat(path,file);
                separator = NaN(1,50);%variables are seperated by 'NaN'
                save(savefile,'X','separator','Y','-ASCII')
                       
        end
        
    end
%% About this program
    function about_callback (object, eventdata)
    
        figure('name','About This Program','MenuBar','none');
        
        strAbout(1) = {'About This Program: '};
        strAbout(2) = {''};
        strAbout(3) = {'Version 1.0'};
        strAbout(4) = {'Date: April 20,2007'};
        strAbout(5) = {'Created by: Chen Wang'};
        strAbout(6) = {''};
        strAbout(7) = {'Program is based on Andrew Marble '' PHD Thesis 2007'};
        strAbout(8) = {'Property of the University of New Brunswick'};
        uicontrol('Style','text',...
            'String',strAbout,'backgroundColor',[0.8 0.8 0.8],...
            'fontweight','bold','fontsize',12,'foregroundColor',[0 0 0],...
            'Units','normalized',...
            'Position',[0.1 0.1 0.8 0.8],...
            'HorizontalAlignment','left');
    end
%% Open Help file of this program(only works on windows machine)
    function help_callback (object, eventdata)
    winopen('help.doc')
    end
end %end of class






