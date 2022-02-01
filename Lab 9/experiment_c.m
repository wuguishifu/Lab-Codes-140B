clc
clear

t = 1:30;
v_sample = 10; % mL
v_tit = [5.1, 5.3, 5.6, 5.9, 5.8, 5.9, 6.2, 6.4, 6.8, 6.8, 7.0, 7.1,...
         7.3, 7.5, 7.6, 7.5, 7.6, 7.7, 7.9, 8.1, 8.2, 8.5, 8.3, 8.2,...
         8.7, 8.6, 8.6, 8.7, 8.8, 9.0]; % mL NaOH
c_tit = 0.1; % mol/L NaOH
n_naoh = 250 / 1000 * 0.1; % mol

c0 = n_naoh .* ones(1, 30); % initial concentration
c = (10 - v_tit) ./ 1000 .* 0.1; % current concentration
conversion = (c0 - c) ./ c;

% apply k = Ae^{-E/RT}
T = 25 + 273; % kelvin
R = 8.31; % J/k*mol

% literature values
k_lit = 6.1; % 1/mol*min abu1994mathematical
E_lit = 43; % kJ/mol kirby1972kinetics
A_lit = 1.05e3; % m^3/mol*s mukhtar2015chemical

% figure
% plot(t, v_tit, 'b.')
% xlabel('Time (min)')
% ylabel('Volume of 0.1 M NaOH Required to Titrate (mL)')
% 
% figure
% hold on
% fitn1 = polyfitn(t, c, 1);
% plot(t, c, '.b')
% plot(t, polyval(fitn1.Coefficients, t), '-r')
% disp(fitn1.R2)
% xlabel('Time (min)')
% ylabel('[NaOH] (mol/L)')
% legend('Data', 'Regression')
% 
% figure
% hold on
% fitn2 = polyfitn(t, log(c), 1);
% plot(t, log(c), '.b')
% plot(t, polyval(fitn2.Coefficients, t), '-r')
% disp(fitn2.R2)
% xlabel('Time (min)')
% ylabel('ln([NaOH])')
% legend('Data', 'Regression')
% 
% figure
% hold on
% fitn3 = polyfitn(t, 1./(c), 1);
% plot(t, 1./(c), '.b')
% plot(t, polyval(fitn3.Coefficients, t), '-r')
% disp(fitn3.R2)
% xlabel('Time (min)')
% ylabel('[NaOH]^{-1} (L/mol)')
% legend('Data', 'Regression')

% centered difference implementation
data = zeros(2, 30);
figure()
hold on
for i=2:29
    data(1, i) = 1/3 * (c(i+1) + c(i) + c(i-1)); % c_avg
    data(2, i) = (c(i+1) - c(i-1)) / 2; % r
end

mask = all(data >= 0);
data(:, mask) = [];
fitcd = polyfitn(log(data(1, :)), log(-data(2, :)), 1);
plot(log(data(1, :)), log(-data(2, :)), 'o')
plot(log(data(1, :)), polyval(fitcd.Coefficients, log(data(1, :))))
xlabel('C_{avg} (mol/L)')
ylabel('Reaction Rate (mol/L\cdotmin)')
title('Centered Difference Implementation')
disp(fitcd.p)


% Richardson's extrapolation implementation
figure
hold on
for i = 3:28
    data(1, i) = 0.2 * (c(i+2) + c(i+1) + c(i) + c(i-1) + c(i-2)); % c_avg
    data(2, i) = (-c(i+2) + 8*c(i+1) - 8*c(i-1) + c(i-2))/12; % r
end
mask = all(data >= 0);
data(:, mask) = [];
fitre = polyfitn(log(data(1, :)), log(-data(2, :)), 1);
plot(log(data(1, :)), log(-data(2, :)), 'o')
plot(log(data(1, :)), polyval(fitre.Coefficients, log(data(1, :))))
xlabel('C_{avg} (mol/L)')
ylabel('Reaction Rate (mol/L\cdotmin)')
title('Richardson Extrapolation Implementation')
disp(fitre.p)

% lerp implementation
figure
hold on
data = zeros(2, 30);
for i = 3:28
    data(1, i) = 0.2 * (c(i+2) + c(i+1) + c(i) + c(i-1) + c(i-2)); % c_avg
    data(2, i) = lerp(1:5, c(i-2:i+2));
end
mask = all(data >= 0);
data(:, mask) = [];
fitle = polyfitn(log(data(1, :)), log(-data(2, :)), 1);
plot(log(data(1, :)), log(-data(2, :)), 'o');
plot(log(data(1, :)), polyval(fitle.Coefficients, log(data(1, :))))
xlabel('C_{avg} (mol/L)')
ylabel('Reaction Rate (mol/L\cdotmin)')
title('Moving Lerp Implementation')
disp(fitle.p)
