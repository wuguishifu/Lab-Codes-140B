clc
clear

speed = [10, 20, 30, 40, 50, 60]; % (%)
flowrates = 1./[
    210, 92, 76, 50, 45, 35;
    205, 94, 75, 59, 41, 38;
    199, 96, 75, 53, 43, 35;
]; % (L/s)

f_avg = sum(flowrates(:, :))./3; % (L/s)
f_std = std(flowrates(:, :)); % (L/s)

fitn = polyfitn(speed, f_avg, 1);

hold on
errorbar(speed, f_avg, f_std, '.b')
plot(speed, polyval(fitn.Coefficients, speed), '-r')
legend({'Raw Data', 'Linear Regression'}, 'Location', 'NorthWest')
xlabel('Controller Setting (%)')
ylabel('Flowrate (L s^{-1})')
