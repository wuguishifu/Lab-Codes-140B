clc
clear

A = readtable("data\200cc_impulse_15s_0.1M_stir.csv");
B = readtable("data\250cc_impulse_75.csv");
C = readtable('data\50cc_step_0.1M_75stir.csv');
D = readtable('data\200cc_step_0.1M_nostir.csv');
figure()
subplot(2, 1, 2);
hold on
title('Stirring Off')
plot(A.Time, A.Tank1, '.', 'LineWidth', 2)
plot(A.Time, A.Tank2, '.', 'LineWidth', 2)
plot(A.Time, A.Tank3, '.', 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Conductivity (\mus/cm)')
legend('Tank 1', 'Tank 2', 'Tank 3')

subplot(2, 1, 1);
hold on
title('Stirring On')
plot(B.Time, B.Tank1, '.', 'LineWidth', 2)
plot(B.Time, B.Tank2, '.', 'LineWidth', 2)
plot(B.Time, B.Tank3, '.', 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Conductivity (\mus/cm)')
legend('Tank 1', 'Tank 2', 'Tank 3')

figure()
subplot(2, 1, 1)
hold on
title('Stirring On')
plot(C.Time, C.Tank1, '.', 'LineWidth', 2)
plot(C.Time, C.Tank2, '.', 'LineWidth', 2)
plot(C.Time, C.Tank3, '.', 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Conductivity (\mus/cm)')
legend({'Tank1', 'Tank2', 'Tank3'}, 'Location', 'SouthEast')

subplot(2, 1, 2);
hold on
title('Stirring Off')
xshift = 157;
indices = find(D.Time - xshift < 0);
D.Time(indices) = NaN;
plot(D.Time - xshift, D.Tank1, '.', 'LineWidth', 2)
plot(D.Time - xshift, D.Tank2, '.', 'LineWidth', 2)
plot(D.Time - xshift, D.Tank3, '.', 'LineWidth', 2)
xlabel('Time (s)')
ylabel('Conductivity (\mus/cm)')
legend({'Tank1', 'Tank2', 'Tank3'}, 'Location', 'SouthEast')
