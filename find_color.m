function s_out = find_color(img, col, tol, varargin)
% Browses figure c_out (RGB, 8 bit per channel) looking for vertical
% coordinates of color col +/- tol
% tol can either be a scalar or a 1 x 3 vector as col.

if isempty(varargin)
    c_start = 1;
    c_end = size(img, 1);
    r_start = 1;
    r_end = size(img, 2);
else
    c_start = varargin{1}(3);
    c_end = varargin{1}(4);
    r_start = varargin{1}(1);
    r_end = varargin{1}(2);
end

c_lo = col - tol;
c_hi = col + tol;

s_out.row = [r_start:r_end]';
s_out.pxf = cell(size(s_out.row));
s_out.pxm = zeros(size(s_out.row));

col_ind = [c_start:c_end];

for i_r = 1:length(s_out.row)
    % select one picture column
    pxv = img(c_start:c_end, s_out.row(i_r), :);
    fnd = [];
    for i_c = 1:length(pxv)
        curr_col = [pxv(i_c, 1, 1), pxv(i_c, 1, 2), pxv(i_c, 1, 3)];
        if check_col(curr_col)
            fnd = [fnd; col_ind(i_c)];
        end
    end
    % disp(fnd);
    s_out.pxf{i_r} = fnd;
    s_out.pxm(i_r) = mean(fnd); % THIS WILL NEED UPDATE IF THE AREA IS MODIFIED.
%     keyboard
end


    function out = check_col(c_in)
        if ((c_in(1) >= c_lo(1) && c_in(1) <= c_hi(1)) && ...
                (c_in(2) >= c_lo(2) && c_in(2) <= c_hi(2)) && ...
                (c_in(3) >= c_lo(3) && c_in(3) <= c_hi(3)))
            out = true;
        else
            out = false;
        end
    end



end

