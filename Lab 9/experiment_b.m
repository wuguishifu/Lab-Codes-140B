clc
clear

data_table = readtable("data_full.csv");

t_avg = zeros(1, 4);
t_std = zeros(1, 4);
e_avg = zeros(1, 4);
e_std = zeros(1, 4);
v_avg = zeros(1, 4);
v_std = zeros(1, 4);

for i = 1:4
    x = (i - 1) * 3 + 1;
    t_avg(i) = sum(data_table.t(x:x+2))/3;
    t_std(i) = std(data_table.t(x:x+2));
    e_avg(i) = sum(data_table.e(x:x+2))/3;
    e_std(i) = std(data_table.e(x:x+2));
    v_avg(i) = sum(data_table.v(x:x+2))/3;
    v_std(i) = std(data_table.v(x:x+2));
end

v_sample = 10; % mL
v_quench = 10; % mL HCl
c_quench = 0.1; % mol/L HCl

flowrates_a = [101., 100., 102.];
flowrates_b = [99.9, 101., 100.];
c_naoh = 0.1; % mol/L NaOH

avg_naoh = sum(flowrates_a) / 3; % mL/min
avg_etac = sum(flowrates_b) / 3; % mL/min
std_naoh = std(flowrates_a); % mL/min
std_etac = std(flowrates_b); % mL/min

naoh_in_avg = avg_naoh ./ 10 ./ 1000 .* c_naoh .* ones(1, 4); % mol/min
naoh_out_avg = (10 - v_avg) ./ 1000 .* 0.1; % mol/min
conversion_avg = (naoh_in_avg - naoh_out_avg) ./ naoh_in_avg .* 100;

naoh_in_std = avg_naoh ./ 10 ./ 1000 .* c_naoh .* ones(1, 4); % mol/min
naoh_out_std = (10 - v_std) ./ 1000 .* 0.1; % mol/min
conversion_std = (naoh_in_std - naoh_out_std) ./ naoh_in_std * 100;

% figure(1)
% errorbar(t_avg, conversion_avg, conversion_std, 'b.', 'MarkerSize', 20)
% xlim([20, 60])
% xlabel('Temperature (°C)')
% ylabel('Conversion (%)')
% 
% figure(2)
% fitn = polyfitn(t_avg, conversion_avg, 1);
% xlim([20, 60])
% plot(25:55, polyval(fitn.Coefficients, 25:55), '-b')
% xlim([20, 60])
% xlabel('Temperature (°C)')
% ylabel('Conversion (%)')
% fitn.Coefficients
% fitn.p

tank_inner_diameter = 185. / 1000; % mm;
tube_inner_diameter =  6.0 / 1000; % mm;
num_coils = 36;
tube_length = tank_inner_diameter * pi * 36; % m
tube_area = pi * (tank_inner_diameter / 2)^2; % m^2
tau = tube_length * tube_area ./ (200e-6) .* 60; % 1/min

k_exp = (conversion_avg .* 0.01)./(1-conversion_avg .* 0.01)./tau./0.1;
k_err = (conversion_std .* 0.01)./(1-conversion_std .* 0.01)./tau./0.1;

figure()
hold on
x = 1./(t_avg + 273);
y = log(k_exp);
plot(x, y, 'b.', 'MarkerSize', 20)
fit = polyfitn(x, y, 1);
plot(x, polyval(fit.Coefficients, x), 'r-')
xlabel('T^{-1} (K^{-1})')
ylabel('ln(k)')
legend('Data', 'Linear Regression')
fit.Coefficients
fit.ParameterStd
fit.p

temps_lit = [25, 35, 45, 55] + 273;
coeff_lit = [-5457.8, 16.119];
k_lit = exp(1./temps_lit.*coeff_lit(1) + coeff_lit(2));

figure()
hold on
plot(x, log(k_exp), 'b.', 'MarkerSize', 20)
plot(x, log(k_lit), 'r.', 'MarkerSize', 20)
legend('Experimental', 'Literature')

R = 8.31; % J/k*mol
E = -fit.Coefficients(1) * R;
A = exp(fit.Coefficients(2))
