function xo = px2nrm(px, varargin)
% nargin 2: il secondo argomento può essere l'asse o la figura di
% riferimento
% nargin 3: secondo è xlim, terzo ylim.
% Per usare su figura, invertire colonne x e y ed usare per xlim e ylim 0 e
% fine. forse.

if nargin == 2
    v1 = varargin{1};
    wv1 = whos('v1');
    if strcmp(wv1.class, 'matlab.graphics.axis.Axes')
        XLim = v1.XLim;
        YLim = v1.YLim;
    elseif strcmp(wv1.class, 'matlab.ui.Figure')
        XLim = v1.CurrentAxes.XLim;
        YLim = v1.CurrentAxes.YLim;
    else
        error('Second argument is not an Axes, nor a Figure');
    end
elseif nargin == 3
    XLim = varargin{1};
    YLim = varargin{1};
else
    error('Wrong number of arguments');
end

xo = zeros(size(px));
for ii = 1:size(px, 1)
    xo(ii, 1) = (px(ii, 1) - XLim(1)) / (XLim(2) - XLim(1));
    xo(ii, 2) = 1 - (px(ii, 2) - YLim(1)) / (YLim(2) - YLim(1));
end

