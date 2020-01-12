function xa = nrm2arb(xn, ax, ay, axv, ayv)
% Transforms values taken from a normal representation to those in the
% arbitrary axis.
% xn: input points (base reference system)
% ax: 2 points describing arbitrary X axis
% ay: 2 points describing arbitrary Y axis
% axv: values of the X axis in the selected points
% ayv: values of the Y axis in the selected points

xo = find_origin(ax, ay);
ang_x = atan2(ax(2, 2) - ax(1, 2), ax(2, 1) - ax(1, 1));
ang_y = atan2(ay(2, 2) - ay(1, 2), ay(2, 1) - ay(1, 1));

M1 = [cos(ang_x) cos(ang_y); sin(ang_x) sin(ang_y)];
iM1 = inv(M1);

xr = zeros(size(xn));
for ii = 1:size(xn, 1)
    xr(ii, :) = reproj(xn(ii, :));
end

axr = zeros(size(ax));
ayr = zeros(size(ay));

for ii = 1:2
    axr(ii, :) = reproj(ax(ii, :));
    ayr(ii, :) = reproj(ay(ii, :));
end

% Scaling.
% Take into account origin value might as well NOT be 0!
ax_scale = axr(:, 1)';
ay_scale = ayr(:, 2)';

xa = zeros(size(xr));
for ii = 1:size(xa, 1)
    xa(ii, 1) = axv(1) + (xr(ii, 1) - ax_scale(1))*(axv(2) - axv(1))/(ax_scale(2) - ax_scale(1));
    xa(ii, 2) = ayv(1) + (xr(ii, 2) - ay_scale(1))*(ayv(2) - ayv(1))/(ay_scale(2) - ay_scale(1));
end

% keyboard

    function vo = reproj(vi)
        xb = vi' - xo';
        vo = (iM1 * xb)';
    end



end

