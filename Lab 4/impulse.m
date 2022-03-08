clc
clear

A = readtable('data\50cc_step_0.1M_75stir.csv');

figure()
hold on
title('50mL 0.1M, 75% Stirring, Step Input')
xlabel('Time (s)')
ylabel('Conductivity (\mus/cm)')
legend({'Tank1', 'Tank2', 'Tank3'}, 'Location', 'SouthEast')
plot(A.Time, A.Tank1, '.', 'LineWidth', 2)
plot(A.Time, A.Tank2, '.', 'LineWidth', 2)
plot(A.Time, A.Tank3, '.', 'LineWidth', 2)

x = [154, 702; 684, 1888; 1432, 3962];
x = [
    find(A.Time==x(1, 1)), find(A.Time==x(1, 2));
    find(A.Time==x(2, 1)), find(A.Time==x(2, 2));
    find(A.Time==x(3, 1)), find(A.Time==x(3, 2));
];

time.a = A.Time(x(1, 1):x(1, 2));
time.b = A.Time(x(2, 1):x(2, 2));
time.c = A.Time(x(3, 1):x(3, 2));

cond.a = A.Tank1(x(1, 1):x(1, 2));
cond.b = A.Tank2(x(2, 1):x(2, 2));
cond.c = A.Tank3(x(3, 1):x(3, 2));

figure()
hold on
title('Linear Regions - Linear Regression')
xlabel('Time (s)')
ylabel('Conducitivity (\mus/cm)')
% plot(time.a, cond.a, '.');
% plot(time.b, cond.b, '.');
% plot(time.c, cond.c, '.');

fit.a = polyfitn(time.a, cond.a, 1);
fit.b = polyfitn(time.b, cond.b, 1);
fit.c = polyfitn(time.c, cond.c, 1);

plot(time.a, polyval(fit.a.Coefficients, time.a), '-', 'LineWidth', 2);
plot(time.b, polyval(fit.b.Coefficients, time.b), '-', 'LineWidth', 2);
plot(time.c, polyval(fit.c.Coefficients, time.c), '-', 'LineWidth', 2);
legend({'Tank1', 'Tank2', 'Tank3'}, 'Location', 'SouthEast')

line.a = polyval(fit.a.Coefficients, time.a);
line.b = polyval(fit.b.Coefficients, time.b);
line.c = polyval(fit.c.Coefficients, time.c);

dcdt.a = (line.a(end) - line.a(1)) / (time.a(end) - time.a(1));
dcdt.b = (line.b(end) - line.b(1)) / (time.b(end) - time.b(1));
dcdt.c = (line.c(end) - line.c(1)) / (time.c(end) - time.c(1));
disp(dcdt.a)
disp(dcdt.b)
disp(dcdt.c)
xlim([0, 4000])
