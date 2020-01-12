function xo = find_origin(ax, ay)

x_f = polyfit(ax(:, 1), ax(:, 2), 1);
y_f = polyfit(ay(:, 2), ay(:, 1), 1); % avoid problems if vertical

% origin:
yo_n = (x_f(1) * y_f(2) + x_f(2)) / (1 - x_f(1) * y_f(1));
xo_n = y_f(1) * yo_n + y_f(2);

xo = [xo_n, yo_n];