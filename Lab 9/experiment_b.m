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

figure(1)
errorbar(t_avg, conversion_avg, conversion_std, 'b.', 'MarkerSize', 20)
xlim([20, 60])
xlabel('Temperature (°C)')
ylabel('Conversion (%)')

figure(2)
fitn = polyfitn(t_avg, conversion_std, 1);
xlim([20, 60])
plot(25:55, polyval(fitn.Coefficients, 25:55), '-b')
xlim([20, 60])
xlabel('Temperature (°C)')
ylabel('Conversion (%)')

% tank_inner_diameter = 18.5 / 1000; % m;
% tube_inner_diameter =  6.0 / 1000; % m;
% num_coils = 36;
% tube_length = tank_inner_diameter * pi * 36;
% tube_area = pi * (tank_inner_diameter / 2)^2;
% 
% tua = tube_length * tube_area ./ (avg_naoh + avg_etac);
