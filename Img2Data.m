function Img2Data()
% TODO: add auto-image opening if filename is given as argument

MediumFont = 12;
SmallFont = 10;
VerySmallFont = 9;

separation_starts = [0 0.25 0.3 0.95 1];
separation_heights = diff(separation_starts);



% Globals.
I = imread('.\plots\sampleplot.png');
Axp = nan(2);
Ayp = nan(2);
Xop = nan(2);
Axn = nan(2);
Ayn = nan(2);
Xon = nan(2);
AxVal = nan(1, 2);
AyVal = nan(1, 2);
Xpx = [];
Xnrm = [];
Xout = [];
XLimNative = [];
YLimNative = [];
AutoColor = [255 255 255];
ColTolerance = [50 50 50];
XAuto = [];
YAuto = [];
AutoSearchZone = [];
PtLineStyle = '-';
PtMarkerStyle = 'x';
PtColor = 'k';
PtLineStyleList = {'-', '--', 'none'};
PtMarkerStyleList = {'x', '.', 'o', 'd', 'none'};
PtColorList = {'k', 'b', 'r', 'g', 'c', 'm', 'y', 'w'};

Gui = figure('position', [50 50 1200 600]);
MainFrame = uipanel('parent', Gui, 'units', 'norm', 'pos',[0 0 1 1], ...
        'BorderType','None', 'BackgroundColor', [0.9 0.9 0.9]);
MainSubFrame = uipanel('parent', MainFrame, 'units', 'norm', 'pos',[0 separation_starts(3) 1 separation_heights(3)], ...
        'BorderType','None', 'BackgroundColor', [.9 1 1]);
    
BaseOperationPanel = uipanel('parent', MainFrame, 'units', 'norm', 'pos',[0 separation_starts(4) 1 separation_heights(4)], ...
        'BorderType','None', 'BackgroundColor', [1 1 1]);

AxesWidth = 0.8;
HintFrame = uipanel('parent', MainFrame, 'units', 'norm', 'pos',[0 separation_starts(2) 1 separation_heights(2)], ...
        'BorderType','None', 'BackgroundColor', [1 1 .9]);
ControlFrame = uipanel('parent', MainFrame, 'units', 'norm', 'pos',[0 separation_starts(1) 1 separation_heights(1)], ...
        'BorderType','None', 'BackgroundColor', [.9 .9 .9]);
    
% Main Axes
ax1 = axes('parent', MainSubFrame, 'units', 'norm', 'pos',[0 0 AxesWidth 1]);
ax1.YDir = 'reverse';
i1 = image(I);
% TODO: Avoid replication into load image function.
line_ax = line('XData', [], 'YData', [], 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
line_ay = line('XData', [], 'YData', [], 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
line_origin = line('XData', [], 'YData', [], 'Color', 'b', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
line_pts = line('XData', [], 'YData', [], 'Color', PtColor, 'Marker', PtMarkerStyle, 'LineStyle', PtLineStyle, 'LineWidth', 2, 'MarkerSize', 10);
line_auto_pts = line('XData', [], 'YData', [], 'Color', 'c', 'Marker', '.', 'LineStyle', 'none', 'LineWidth', 2);
rectangle_man = rectangle('Position', [1 2 3 4], 'Visible', 'off');
rectangle_auto = rectangle('Position', [1 2 3 4], 'Visible', 'off', 'EdgeColor', 'c');
XLimNative = ax1.XLim;
YLimNative = ax1.YLim;

% Hint Text
HintText = uicontrol('parent', HintFrame,'Style','edit', 'units', 'norm', 'pos', [0 0 1 1], ...
    'String', 'Img2Data opened.', 'FontSize', SmallFont, 'enable', 'inactive');

% Upper controls
LoadImgButton = uicontrol('parent', BaseOperationPanel, 'style','pushbutton', ...
    'units','norm', 'position', [0 0 1/3 1], 'String', 'Load Image', ...
    'FontName', 'Arial', 'FontSize', MediumFont, 'Callback', @LoadImageFcn, ...
    'BackgroundColor', [.9 .9 .9]);
SaveSetButton = uicontrol('parent', BaseOperationPanel, 'style','pushbutton', ...
    'units','norm', 'position', [1/3 0 1/3 1], 'String', 'Save Dataset', ...
    'FontName', 'Arial', 'FontSize', MediumFont, 'Callback', @SaveSetFcn, ...
    'BackgroundColor', [.8 .8 1]);
BringBaseButton = uicontrol('parent', BaseOperationPanel, 'style','pushbutton', ...
    'units','norm', 'position', [2/3 0 1/3 1], 'String', 'Dataset --> Base Workspace', ...
    'FontName', 'Arial', 'FontSize', MediumFont, 'Callback', @BringBaseFcn, ...
    'BackgroundColor', [.9 .9 .9]);

%% Lower Controls
% AXIS CONTROLS
AxisFrame = uipanel('parent', ControlFrame, 'units', 'norm', 'pos',[0 0 1/3 1], ...
        'BorderType','etchedin', 'BackgroundColor', [.9 .9 .9]);
uicontrol('parent', AxisFrame, 'style','text', ...
    'units','norm', 'position', [0 8/9 1 1/9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Axes Definition:');
uicontrol('parent', AxisFrame, 'style','text', ...
    'units','norm', 'position', [0 7/9 1 1/9], ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'String',  'X - Axis:');
AxisX1DescrText = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [0 6/9 .5 1/9], ...
    'String', 'P1: X = ? px; Y = ? px, Val = ', 'FontSize', VerySmallFont, 'enable', 'inactive');
AxisX1ValEdit = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [.5 6/9 .2 1/9], ...
    'String', '1', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'X1V', 'Callback', @changeAxisVal); 
AxisX1SetBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.7 6/9 .15 1/9], 'String', 'Set', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @getAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'X1S');
AxisX1ClrBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.85 6/9 .15 1/9], 'String', 'Clear', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @clrAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'X1C');
AxisX2DescrText = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [0 5/9 .5 1/9], ...
    'String', 'P2: X = ? px; Y = ? px, Val = ', 'FontSize', VerySmallFont, 'enable', 'inactive');
AxisX2ValEdit = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [.5 5/9 .2 1/9], ...
    'String', '1', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'X2V', 'Callback', @changeAxisVal); 
AxisX2SetBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.7 5/9 .15 1/9], 'String', 'Set', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @getAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'X2S');
AxisX2ClrBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.85 5/9 .15 1/9], 'String', 'Clear', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @clrAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'X2C');

uicontrol('parent', AxisFrame, 'style','text', ...
    'units','norm', 'position', [0 4/9 1 1/9], ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'String',  'Y - Axis:');
AxisY1DescrText = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [0 3/9 .5 1/9], ...
    'String', 'P1: X = ? px; Y = ? px, Val = ', 'FontSize', VerySmallFont, 'enable', 'inactive');
AxisY1ValEdit = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [.5 3/9 .2 1/9], ...
    'String', '1', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'Y1V', 'Callback', @changeAxisVal); 
AxisY1SetBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.7 3/9 .15 1/9], 'String', 'Set', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @getAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'Y1S');
AxisY1ClrBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.85 3/9 .15 1/9], 'String', 'Clear', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @clrAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'Y1C');
AxisY2DescrText = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [0 2/9 .5 1/9], ...
    'String', 'P2: X = ? px; Y = ? px, Val = ', 'FontSize', VerySmallFont, 'enable', 'inactive');
AxisY2ValEdit = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [.5 2/9 .2 1/9], ...
    'String', '1', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'Y2V', 'Callback', @changeAxisVal); 
AxisY2SetBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.7 2/9 .15 1/9], 'String', 'Set', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @getAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'Y2S');
AxisY2ClrBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.85 2/9 .15 1/9], 'String', 'Clear', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @clrAxisPoint, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'Y2C');

uicontrol('parent', AxisFrame, 'style','text', ...
    'units','norm', 'position', [0 1/9 .5 1/9], ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'String',  'Origin:');
OriginDescrText = uicontrol('parent', AxisFrame,'Style','edit', 'units', 'norm', 'pos', [0 0/9 .5 1/9], ...
    'String', 'O: X = ? px; Y = ? px', 'FontSize', VerySmallFont, 'enable', 'inactive'); 
uicontrol('parent', AxisFrame, 'style','text', ...
    'units','norm', 'position', [.5 1/9 .5 1/9], ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'String',  'Manage Axes:');
AxisResetBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 0/9 .2 1/9], 'String', 'Reset', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AxisResetFcn, ...
    'BackgroundColor', [.9 .9 .9]);
AxisSaveBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.7 0/9 .15 1/9], 'String', 'Save', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AxisSaveFcn, ...
    'BackgroundColor', [.9 .9 .9]);
AxisLoadBtn = uicontrol('parent', AxisFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.85 0/9 .15 1/9], 'String', 'Load', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AxisLoadFcn, ...
    'BackgroundColor', [.9 .9 .9]);

% MANUAL POINTS CONTROL
ManFrame = uipanel('parent', ControlFrame, 'units', 'norm', 'pos',[1/3 0 1/3 1], ...
        'BorderType','etchedin', 'BackgroundColor', [.9 .9 .9]);
uicontrol('parent', ManFrame, 'style','text', ...
    'units','norm', 'position', [0 7/9 1 2/9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Manual Control:');  
AddPointBtn = uicontrol('parent', ManFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 6/9 .25 1/9], 'String', 'Add Point', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AddPointFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
RmPointBtn = uicontrol('parent', ManFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.25 6/9 .25 1/9], 'String', 'Remove Point(s)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @RmPointFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
ZoomBtn = uicontrol('parent', ManFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 6/9 .25 1/9], 'String', 'Zoom', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @ZoomFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
ResetZoomBtn = uicontrol('parent', ManFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.75 6/9 .25 1/9], 'String', 'Reset Zoom', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @ResetZoomFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
FreeModeBtn = uicontrol('parent', ManFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 4/9 1 2/9], 'String', 'Free Mode', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @FreeModeFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
% Points visualization settings.
uicontrol('parent', ManFrame, 'style','text', ...
    'units','norm', 'position', [0 3/9 1 1/9], 'BackgroundColor', [.9 .9 .9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Point Visualization Options:');  
uicontrol('parent', ManFrame, 'style','text', ...
    'units','norm', 'position', [0 2/9 1/3 1/9], 'BackgroundColor', [.9 .9 .9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Line:');  
PtLineStyleListBox = uicontrol('parent', ManFrame, 'style', 'listbox', ...
    'units', 'norm', 'position', [0 0/9 1/3 2/9], 'FontName', 'Arial', ...
    'FontSize', SmallFont, 'String', PtLineStyleList, 'Callback', ...
    @PtStyleFcn, 'min', 1, 'max', 1);
uicontrol('parent', ManFrame, 'style','text', ...
    'units','norm', 'position', [1/3 2/9 1/3 1/9], 'BackgroundColor', [.9 .9 .9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Marker:');  
PtMarkerStyleListBox = uicontrol('parent', ManFrame, 'style', 'listbox', ...
    'units', 'norm', 'position', [1/3 0/9 1/3 2/9], 'FontName', 'Arial', ...
    'FontSize', SmallFont, 'String', PtMarkerStyleList, 'Callback', ...
    @PtStyleFcn, 'min', 1, 'max', 1);
uicontrol('parent', ManFrame, 'style','text', ...
    'units','norm', 'position', [2/3 2/9 1/3 1/9], 'BackgroundColor', [.9 .9 .9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Color:');  
PtColorListBox = uicontrol('parent', ManFrame, 'style', 'listbox', ...
    'units', 'norm', 'position', [2/3 0/9 1/3 2/9], 'FontName', 'Arial', ...
    'FontSize', SmallFont, 'String', PtColorList, 'Callback', ...
    @PtStyleFcn, 'min', 1, 'max', 1);
% Automatic mode.
AutoFrame = uipanel('parent', ControlFrame, 'units', 'norm', 'pos',[2/3 0 1/3 1], ...
        'BorderType','etchedin', 'BackgroundColor', [.9 .9 .9]);
uicontrol('parent', AutoFrame, 'style','text', ...
    'units','norm', 'position', [0 7/9 1 2/9], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Automatic Control:'); 
% color picker
AutoColRDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [0/6 6/9 1/6 1/9], ...
    'String', 'R: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoColRVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [1/6 6/9 1/6 1/9], ...
    'String', '255', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'RColVal', 'Callback', @changeColorFcn); 
AutoColGDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [2/6 6/9 1/6 1/9], ...
    'String', 'G: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoColGVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [3/6 6/9 1/6 1/9], ...
    'String', '255', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'GColVal', 'Callback', @changeColorFcn); 
AutoColBDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [4/6 6/9 1/6 1/9], ...
    'String', 'B: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoColBVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [5/6 6/9 1/6 1/9], ...
    'String', '255', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'BColVal', 'Callback', @changeColorFcn); 
% Pick button.
PickColorBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 4/9 1 2/9], 'String', 'Pick Color', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PickColorFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
% Tolerance definer
AutoTolRDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [0/6 3/9 1/6 1/9], ...
    'String', 'Tol. R: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoTolRVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [1/6 3/9 1/6 1/9], ...
    'String', '50', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'RColVal', 'Callback', @changeTolFcn); 
AutoTolGDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [2/6 3/9 1/6 1/9], ...
    'String', 'Tol. G: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoTolGVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [3/6 3/9 1/6 1/9], ...
    'String', '', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'GColVal', 'Callback', @changeTolFcn); 
AutoTolBDescr = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [4/6 3/9 1/6 1/9], ...
    'String', 'Tol. B: ', 'FontSize', VerySmallFont, 'enable', 'inactive', 'BackgroundColor', [.9 .9 .9]);
AutoTolBVal = uicontrol('parent', AutoFrame,'Style','edit', 'units', 'norm', 'pos', [5/6 3/9 1/6 1/9], ...
    'String', '', 'FontSize', VerySmallFont, 'enable', 'on', 'Tag', 'BColVal', 'Callback', @changeTolFcn); 
% Find color inside image.
% remember to update graphChanged. 
AutoFindPtsBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 2/9 1 1/9], 'String', 'Find Points', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AutoFindPtsFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
AutoAddFoundBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 1/9 .5 1/9], 'String', 'Add Found (raw)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AutoAddFoundFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
AutoAddSmoothBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 1/9 .5 1/9], 'String', 'Add Found (avg)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AutoAddSmoothFcn, ...
    'BackgroundColor', [.9 .9 .9]); %, 'Tag', 'Y2C');  
% Definition of the part of the graph to be selected.
AutoSelZoneDefBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 0/9 .5 1/9], 'String', 'Define Search Zone', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AutoSelZoneDefFcn, ...
    'BackgroundColor', [.9 .9 .9]);
AutoSelZoneDelBtn = uicontrol('parent', AutoFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 0/9 .5 1/9], 'String', 'Clear Search Zone', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @AutoSelZoneDelFcn, ...
    'BackgroundColor', [.9 .9 .9]);


% Point List frame and subfunctions
PointListFrame = uipanel('parent', MainSubFrame, 'units', 'norm', 'pos',[AxesWidth 0 (1 - AxesWidth) 1], ...
        'BorderType','None', 'BackgroundColor', [1 .9 1]);
uicontrol('parent', PointListFrame, 'style','text', ...
    'units','norm', 'position', [0 .95 1 .05], ...
    'FontName', 'Arial', 'FontSize', SmallFont, 'String',  'Sampled Points:'); 
PointListTable = uitable('parent', PointListFrame, 'units', 'normalized', ...
    'pos', [0 0.2 1 0.75], 'Data', [NaN, NaN], 'ColumnName', {'X', 'Y'}, ...
    'ColumnWidth', 'auto');
% Sorting buttons.
PLSortByAscXBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 .15 .5 .05], 'String', 'Sort (Ascending X)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PLSortFcn, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'S_AX');  
PLSortByDescXBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 .15 .5 .05], 'String', 'Sort (Descending X)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PLSortFcn, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'S_DX');  
PLSortByAscYBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 .1 .5 .05], 'String', 'Sort (Ascending Y)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PLSortFcn, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'S_AY');  
PLSortByDescYBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [.5 .1 .5 .05], 'String', 'Sort (Descending Y)', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PLSortFcn, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'S_DY');  
PLClearAllBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 .05 1 .05], 'String', 'Erase all points', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @ClearAllPoints, ...
    'BackgroundColor', [1 .7 .7], 'Tag', 'S_DY');  
PLGraphBtn = uicontrol('parent', PointListFrame, 'style','pushbutton', ...
    'units','norm', 'position', [0 0 1 .05], 'String', 'Plot Points', ...
    'FontName', 'Arial', 'FontSize', VerySmallFont, 'Callback', @PLGraphFcn, ...
    'BackgroundColor', [.9 .9 .9], 'Tag', 'S_DY');  
    
    
    

%% subfunctions
    function hintlog(str_in)
        HintText.String = str_in;
    end

    function LoadImageFcn(obj, event)
        [Name, Path] = uigetfile('*.*');
        try 
            removePointsRectangle([0 Inf 0 Inf])
            I = imread([Path, Name]);
            hintlog(['File ', Path, Name, ' opened.']);
            ax1;
            i1 = image(I);
            line_ax = line('XData', [], 'YData', [], 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
            line_ay = line('XData', [], 'YData', [], 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
            line_origin = line('XData', [], 'YData', [], 'Color', 'b', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 2);
            line_pts = line('XData', [], 'YData', [], 'Color', PtColor, 'Marker', PtMarkerStyle, 'LineStyle', PtLineStyle, 'LineWidth', 2, 'MarkerSize', 10);
            line_auto_pts = line('XData', [], 'YData', [], 'Color', 'c', 'Marker', '.', 'LineStyle', 'none', 'LineWidth', 2);
            rectangle_man = rectangle('Position', [1 2 3 4], 'Visible', 'off');
            rectangle_auto = rectangle('Position', [1 2 3 4], 'Visible', 'off', 'EdgeColor', 'c');
            XLimNative = [.5 size(I, 2) + .5];
            YLimNative = [.5 size(I, 1) + .5];
        catch
            hintlog(['Could not load ', Path, Name]);
        end
        resetAll([], []);
    end

    % TODO: add origin.
    function axesConfigChanged()
        Ayn = px2nrm(Ayp, ax1);
        Axn = px2nrm(Axp, ax1);
        Xop = find_origin(Axp, Ayp);
        Xon = find_origin(Axn, Ayn);
        line_ax.XData = Axp(:, 1);
        line_ax.YData = Axp(:, 2);
        line_ay.XData = Ayp(:, 1);
        line_ay.YData = Ayp(:, 2);
        line_origin.XData = Xop(1);
        line_origin.YData = Xop(2);
        if ~isempty(Xpx)
            line_pts.XData = Xpx(:, 1);
            line_pts.YData = Xpx(:, 2);
            line_pts.Marker = PtMarkerStyle;
            line_pts.Color = PtColor;
            line_pts.LineStyle = PtLineStyle;
        else
            line_pts.XData = [];
            line_pts.YData = [];
        end
        line_auto_pts.XData = XAuto;
        line_auto_pts.YData = YAuto;
        % Update description strings.
        AxisX1DescrText.String = ['P1: X = ', num2str(round(Axp(1, 1))), ' px; Y = ', ...
            num2str(round(Axp(1, 2))), ' px, Val = '];
        AxisX2DescrText.String = ['P2: X = ', num2str(round(Axp(2, 1))), ' px; Y = ', ...
            num2str(round(Axp(2, 2))), ' px, Val = '];
        AxisY1DescrText.String = ['P1: X = ', num2str(round(Ayp(1, 1))), ' px; Y = ', ...
            num2str(round(Ayp(1, 2))), ' px, Val = '];
        AxisY2DescrText.String = ['P2: X = ', num2str(round(Ayp(2, 1))), ' px; Y = ', ...
            num2str(round(Ayp(2, 2))), ' px, Val = '];
        OriginDescrText.String = ['O: X = ', num2str(round(Xop(1, 1))), ' px; Y = ', ...
            num2str(round(Xop(1, 2))), ' px'];
        AxisY2ValEdit.String = num2str(AyVal(2));
        AxisY1ValEdit.String = num2str(AyVal(1));
        AxisX2ValEdit.String = num2str(AxVal(2));
        AxisX1ValEdit.String = num2str(AxVal(1));
        % Xpx Xrn Xout
        Xnrm = px2nrm(Xpx, ax1);
        Xout = nrm2arb(Xnrm, Axn, Ayn, AxVal, AyVal);
        if ~isempty(Xout)
            % xpt = table(Xout(:, 1), Xout(:, 2), 'VariableNames', {'X', 'Y'});
            set(PointListTable, 'Data', Xout);
        else
            set(PointListTable, 'Data', []);
        end
        if ~isempty(AutoSearchZone)
            rcpos = [AutoSearchZone(1) AutoSearchZone(3) ...
                (AutoSearchZone(2) - AutoSearchZone(1)) ...
                (AutoSearchZone(4) - AutoSearchZone(3))];
            rectangle_auto.Position = rcpos;
            rectangle_auto.Visible = 'on';
        else
            rectangle_auto.Visible = 'off';
        end
        % pwpn = px2nrm(pwpx, f2);
        % xa = nrm2arb(pwpn, ax_x, ax_y, [1000 6000], [80 280]);
        % hintlog('Graph updated.');
    end

    function PtStyleFcn(obj, event)
        PtLineStyle = PtLineStyleList{PtLineStyleListBox.Value};
        PtMarkerStyle = PtMarkerStyleList{PtMarkerStyleListBox.Value};
        PtColor = PtColorList{PtColorListBox.Value};
        axesConfigChanged();
    end

    function out = getAxisPoint(obj, event)
        if strcmp(obj.Tag, 'X1S')
            hintlog('Left-click a point on X - Axis');
            px1 = ginput(1);
            Axp(1, :) = px1;
        elseif strcmp(obj.Tag, 'X2S')
            hintlog('Left-click a point on X - Axis');
            px1 = ginput(1);
            Axp(2, :) = px1;
        elseif strcmp(obj.Tag, 'Y1S')
            hintlog('Left-click a point on Y - Axis');
            px1 = ginput(1);
            Ayp(1, :) = px1;
        elseif strcmp(obj.Tag, 'Y2S')
            hintlog('Left-click a point on Y - Axis');
            px1 = ginput(1);
            Ayp(2, :) = px1;
        else
            error('Unrecognized Button Tag.');
        end   
        axesConfigChanged();
    end

    function clrAxisPoint(obj, event)
        if strcmp(obj.Tag, 'X1C')
            Axp(1, :) = nan(1, 2);
            hintlog('First X - Axis point deleted.');
        elseif strcmp(obj.Tag, 'X2C')
            Axp(2, :) = nan(1, 2);
            hintlog('Second X - Axis point deleted.');
        elseif strcmp(obj.Tag, 'Y1C')
            Ayp(1, :) = nan(1, 2);
            hintlog('First Y - Axis point deleted.');
        elseif strcmp(obj.Tag, 'Y2C')
            Ayp(2, :) = nan(1, 2);
            hintlog('Second Y - Axis point deleted.');
        else
            error('Unrecognized Button Tag.');
        end   
        axesConfigChanged();
    end

    function changeAxisVal(obj, event)
        try
            AxVal(1) = str2double(AxisX1ValEdit.String);
            AxVal(2) = str2double(AxisX2ValEdit.String);
            AyVal(1) = str2double(AxisY1ValEdit.String);
            AyVal(2) = str2double(AxisY2ValEdit.String);
            % TODO: this should be more communicative.
            hintlog('Modified Axis Value.');
        catch
            error('Non-numeric value for axis value.');
        end
        axesConfigChanged();
    end
    
    % Reset all selected graphic elements inside the figure.
    function resetAll(obj, event)
        Axp = nan(2);
        Ayp = nan(2);
        Xpx = [];
        XAuto = [];
        YAuto = [];
        AutoSearchZone = [];
        axesConfigChanged();
    end
    
    function AxisResetFcn(obj, event)
        Axp = nan(2);
        Ayp = nan(2);
        AxVal = [NaN, NaN];
        AxVal = [NaN, NaN];
        axesConfigChanged();
    end

    function AxisLoadFcn(obj, event)
        hintlog('Specify the input filename for axis configuration:');
        input_fn = inputdlg('Filename:', '', 1, {'axis.mat'});
        try
            p_ax = load(input_fn{1});
            if ((isfield(p_ax, 'AxVal')) && (isfield(p_ax, 'AyVal')) && ...
                    (isfield(p_ax, 'Axp')) && (isfield(p_ax, 'Ayp')))
                Axp = p_ax.Axp;
                Ayp = p_ax.Ayp;
                AxVal = p_ax.AxVal;
                AyVal = p_ax.AyVal;
            else
                hintlog('Error: the filename you specified did not contain axis variables.');
            end
        catch
            hintlog('Error: the specified filename does not exist.');
        end
        axesConfigChanged();
    end

    function AxisSaveFcn(obj, event)
        hintlog('Specify an output filename for axis configuration.');
        output_fn = inputdlg('Filename:', '', 1, {'axis.mat'});
        save(output_fn{1}, 'AxVal', 'Axp', 'AyVal', 'Ayp');
    end

    function AddPointFcn(obj, event)
        hintlog('Click on the graph where you want to add a data point.');
        px1 = ginput(1);
        addPoint(px1(1), px1(2));
    end

    function RmPointFcn(obj, event)
        hintlog('Click 2 Points on the graph defining a rectangle. Points inside will be removed.');
        rct = getRectangle();
        rcpos = [rct(1) rct(3) (rct(2) - rct(1)) (rct(4) - rct(3))];
        rectangle_man.Position = rcpos;
        rectangle_man.Visible = 'on';
        pause(1);
        rectangle_man.Visible = 'off';
        removePointsRectangle(rct);
        hintlog('Points removed.');
    end

    function ZoomFcn(obj, event)
        hintlog('Click 2 Points on the graph defining a rectangular area to zoom.');
        rct = getRectangle();
        rcpos = [rct(1) rct(3) (rct(2) - rct(1)) (rct(4) - rct(3))];
        rectangle_man.Position = rcpos;
        rectangle_man.Visible = 'on';
        pause(1);
        rectangle_man.Visible = 'off';
        ax1.XLim = [rct(1) rct(2)];
        ax1.YLim = [rct(3) rct(4)];
    end

    function ResetZoomFcn(obj, event)
        ax1.XLim = XLimNative;
        ax1.YLim = YLimNative;
        hintlog('Zoom reset.');
    end

    function addPoint(xp, yp)
        Xpx = [Xpx; xp yp];
        axesConfigChanged();
        try
            hintlog(['Added point (', num2str(Xout(end, 1)), '; ', ...
                num2str(Xout(end, 2)), ').']);
        catch
            hintlog('Could not retrieve new point coordinates');
        end
    end

    function removePointsRectangle(rct_in)
        ind_excl = [];
        for i_r = 1:size(Xpx, 1)
            if ((Xpx(i_r, 1) >= rct_in(1)) && ...
                    (Xpx(i_r, 2) >= rct_in(3)) && ...
                    (Xpx(i_r, 1) <= rct_in(2)) && ...
                    (Xpx(i_r, 2) <= rct_in(4)))
                ind_excl = [ind_excl; i_r];
            end
        end
        Xpx(ind_excl, :) = [];
        axesConfigChanged();
    end

    function FreeModeFcn(obj, event)
        std_hint_str = ['Free Mode enabled. Left click for point addition, ', ...
            'right click (two points) to zoom over rectangular area (click again to reset), ', ...
            'center button (two points) to remove points in a rectangular ', ...
            'area; press RETURN to quit.'];
        hintlog(std_hint_str);
        x0 = 0;
        y0 = 0;
        b = 0;
        IsDrawingDeleteRect = false;
        IsDrawingZoomRect = false;
        StandardZoom = true;
        DeleteTemp = [];
        ZoomTemp = [];
        while ~isempty(b)
            [x0, y0, b] = ginput(1);
            if isempty(b)
                hintlog('Exit from Free mode');
                return
            else
            switch b
                case 1 % left-click
                    addPoint(x0, y0);
                case 2 % center click
                    if IsDrawingDeleteRect
                        DeleteRect = [min([DeleteTemp(1) x0]) max([DeleteTemp(1) x0]) ...
                            min([DeleteTemp(2) y0]) max([DeleteTemp(2) y0])];
                        removePointsRectangle(DeleteRect);
                        hintlog(std_hint_str);
                        IsDrawingDeleteRect = false;
                    else
                        IsDrawingDeleteRect = true;
                        DeleteTemp = [x0 y0];
                        hintlog('Center-click second point for deletion...');
                    end
                case 3 % right click
                    if StandardZoom
                        if IsDrawingZoomRect
                            ZoomRect = [min([ZoomTemp(1) x0]) max([ZoomTemp(1) x0]) ...
                                min([ZoomTemp(2) y0]) max([ZoomTemp(2) y0])];
                            rcpos = [ZoomRect(1) ZoomRect(3) (ZoomRect(2) - ZoomRect(1)) (ZoomRect(4) - ZoomRect(3))];
                            rectangle_man.Position = rcpos;
                            rectangle_man.Visible = 'on';
                            pause(1);
                            rectangle_man.Visible = 'off';
                            ax1.XLim = [ZoomRect(1) ZoomRect(2)];
                            ax1.YLim = [ZoomRect(3) ZoomRect(4)];
                            StandardZoom = false;
                            hintlog(std_hint_str);
                            IsDrawingZoomRect = false;
                        else
                            IsDrawingZoomRect = true;
                            ZoomTemp = [x0 y0];
                            hintlog('Right-click second point for zoom...');
                        end
                    else
                        ResetZoomFcn();
                        StandardZoom = true;
                    end
            end
            end
            axesConfigChanged();
        end
    end

    function out_rct = getRectangle()
        out_rct = zeros(1, 4);
        gi1 = ginput(2);
        out_rct(1) = min(gi1(:, 1));
        out_rct(2) = max(gi1(:, 1));
        out_rct(3) = min(gi1(:, 2));
        out_rct(4) = max(gi1(:, 2));
    end

    % Automatic control functions
    function changeColorFcn(obj, event)
        rcol = min([round(str2double(AutoColRVal.String)) 255]);
        gcol = min([round(str2double(AutoColGVal.String)) 255]);
        bcol = min([round(str2double(AutoColBVal.String)) 255]);
        AutoColor = [rcol bcol gcol];
        hintlog(['Color for automatic detection was manually set to ', ...
            num2str(rcol), ' - ', num2str(gcol), ' - ', num2str(bcol), ...
            '.']);
    end
    
    % Pick color from specified pixel.
    function PickColorFcn(obj, event)
        hintlog('Click on the (colored) line you are willing to detect');
        xv = ginput(1);
        acr = I(round(xv(2)), round(xv(1)), 1);
        acg = I(round(xv(2)), round(xv(1)), 2);
        acb = I(round(xv(2)), round(xv(1)), 3);
        AutoColor = [acr acg acb];
        AutoColRVal.String = num2str(acr);
        AutoColGVal.String = num2str(acg);
        AutoColBVal.String = num2str(acb);
        hintlog('Color for automatic detection was picked from image.');
    end

    % Change the tolerance for RGB color recognition
    function changeTolFcn(obj, event)
        rtol = min([round(str2double(AutoTolRVal.String)) 255]);
        if isempty(AutoTolGVal.String)
            gtol = rtol; btol = rtol;
        else
            gtol = min([round(str2double(AutoTolGVal.String)) 255]);
            btol = min([round(str2double(AutoTolBVal.String)) 255]);
        end
        ColTolerance = [rtol gtol btol];
        hintlog(['Color tolerance set to (+/-)', ...
            num2str(rtol), ' - ', num2str(gtol), ' - ', num2str(btol), ...
            '.']);
    end

    % Automatic find points according to specified color and tolerances
    % TODO: Add compatibility to auto exclusion zone.
    function AutoFindPtsFcn(obj, event)
        XAuto = [];
        YAuto = [];
        if isempty(AutoSearchZone)
            s_out = find_color(I, double(AutoColor), ColTolerance);
        else
            s_out = find_color(I, double(AutoColor), ColTolerance, AutoSearchZone);
        end
        for ii = 1:length(s_out.pxf)
            yv = s_out.pxf{ii};
            xv = s_out.row(ii) * ones(size(yv));
            XAuto = [XAuto; xv];
            YAuto = [YAuto; yv];
        end
        axesConfigChanged();
        hintlog('Automatic point detection complete.');
    end

    % Add found points (raw mode)
    function AutoAddFoundFcn(obj, event)
        for i_xa = 1:length(XAuto)
            Xpx = [Xpx; XAuto(i_xa), YAuto(i_xa)];
        end
        XAuto = []; YAuto = [];
        axesConfigChanged();
        hintlog('Output of automatic detection added to the current set of points.');
    end

    % Add found points averaging per X.
    function AutoAddSmoothFcn(obj, event)
        xpxu = unique(XAuto);
        for i_xu = 1:length(xpxu)
            i_u = find(XAuto == xpxu(i_xu));
            Xpx = [Xpx; xpxu(i_xu), mean(YAuto(i_u))];
        end
        XAuto = []; YAuto = [];
        axesConfigChanged();
        hintlog('Output of automatic detection added (averaging for each X pixel) to the current set.');
    end

    function AutoSelZoneDefFcn(obj, event)
        hintlog('Pick two points to define the area of the picture to be searched for points automatically.');
        rcts = getRectangle();
        AutoSearchZone = round(rcts);
        hintlog('Automatic search area defined.');
        axesConfigChanged();
    end

    function AutoSelZoneDelFcn(obj, event)
        AutoSearchZone = [];
        hintlog('Automatic search area cleared.');
        axesConfigChanged();
    end

    % Sort the sampled points.
    function PLSortFcn(obj, event)
        if strcmp(obj.Tag, 'S_AX')
            [~, ord_p] = sort(Xout(:, 1), 'ascend');
            hintlog('Sorting points by ascending X');
        elseif strcmp(obj.Tag, 'S_DX')
            [~, ord_p] = sort(Xout(:, 1), 'descend');
            hintlog('Sorting points by descending X');
        elseif strcmp(obj.Tag, 'S_AY')
            [~, ord_p] = sort(Xout(:, 2), 'ascend');
            hintlog('Sorting points by ascending Y');
        elseif strcmp(obj.Tag, 'S_DY')
            [~, ord_p] = sort(Xout(:, 2), 'descend');
            hintlog('Sorting points by descending Y');
        else
            error('Unrecognized sorting tag');
        end
        Xpx = Xpx(ord_p, :);
        axesConfigChanged();
    end

    % Clear all points.
    function ClearAllPoints(obj, event)
        Xpx = [];
        hintlog('All points have been erased.');
        axesConfigChanged();
    end

    function SaveSetFcn(obj, event)
        hintlog('Specify an output filename for current dataset');
        if ~isempty(Xout)
            Data.x = Xout(:, 1);
            Data.y = Xout(:, 2);
            Data.xy = Xout;
            output_fn = inputdlg('Filename:', '', [1 100], ...
                {[datestr(now, 'yyyy_mm_dd_HH_MM_SS'), '_dataset.mat']});
            if ~isempty(output_fn)
                save(output_fn{1}, 'Data');
            else
                hintlog('Operation canceled');
            end
        else
            hintlog('Error: empty dataset...');
        end
    end

    % Bring Xout to the base workspace.
    function BringBaseFcn(obj, event)
        hintlog('Output points brought to Base workspace under the ''Data'' struct.');
        if ~isempty(Xout)
            Data.x = Xout(:, 1);
            Data.y = Xout(:, 2);
            Data.xy = Xout;
        end
        assignin('base', 'Data', Data);
    end

    function PLGraphFcn(obj, event)
        hintlog('Output points brought to Base workspace under the ''Data'' struct.');
        figure;
        plot(Xout(:, 1), Xout(:, 2), 'r-');
        grid on;
        xlabel('X');
        ylabel('Y');
        title('Current Dataset');
    end

end