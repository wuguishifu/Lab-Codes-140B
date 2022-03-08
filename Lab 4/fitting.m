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

tank_vol = 1.151856759; % L

c.a = mass(cond.a)/tank_vol/0.1;
c.b = mass(cond.b)/tank_vol/0.1;
c.c = mass(cond.c)/tank_vol/0.1;

y = -log(c.a);
x = -time.a;
fit = polyfitn(x, y, 1);
disp(1/fit.Coefficients(1))

y = -log(c.b);
x = -time.b;
fit = polyfitn(x, y, 1);
disp(1/fit.Coefficients(1))

y = -log(c.c);
x = -time.c;
fit = polyfitn(x, y, 1);
disp(1/fit.Coefficients(1))
