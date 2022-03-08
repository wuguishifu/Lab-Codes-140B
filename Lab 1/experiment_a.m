clc
clear

c_0 = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5]; % (M)
v_tit = [
    0.4, 4.9, 9.0, 13.5, 18.0, 22.2;
    0.5, 4.6, 9.4, 13.3, 18.0, 22.0;
    0.5, 5.2, 9.1, 13.5, 18.2, 22.0;
]; % (mL)

v_avg = sum(v_tit(:, :)./3); % (mL)
v_std = std(v_tit(:, :)); % (mL)

c_a = (0.1 .* v_avg) ./ 5;
c_a = c_a - c_a(1);
c_e = (0.1 .* v_std) ./ 5;

% concentration extract vs. initial concentration in wawter
figure()
hold on
errorbar(c_0, c_a, c_e, '.b', 'MarkerSize', 10);
xlabel('Initial Concentration in Water (M)')
ylabel('Concentration in Kerosene Extract (M)')

% linear regression of previous graph
fitn = fitlm(table(c_0', c_a'), 'Var2 ~ Var1', 'Intercept', false);
% figure()
plot(c_0, polyval([fitn.Coefficients.Estimate, 0], c_0), '-b')
xlabel('Initial Concentration in Water (M)')
ylabel('Concentration in Kerosene Extract (M)')
disp("Slope = " + fitn.Coefficients.Estimate)
disp("p-Value = " + fitn.Coefficients.pValue)

K_avg = sum(c_a(2:end) ./ c_0(2:end))/5;
K_std = std(c_a(2:end) ./ c_0(2:end));
disp("K = " + K_avg + " ± " + K_std)