clc
clear

tris_volumes =   [750, 800, 900, 950, 980, 990, 980, 980, 980]; % [uL 50 mM]
ONPG_volumes =   [250, 200, 100,  50,  20,  10,  20,  20,  20]; % [uL 4 mg/mL]
ONPG_masses = ONPG_volumes ./ 1000000 .* 4; % [g/L]
enzyme_volumes = [ 50,  50,  50,  50,  50,  50,  30,  20,  10]; % [uL]
total_volume = tris_volumes + ONPG_volumes + enzyme_volumes; % [uL]

path_length = 10; % [cm]
ONP_absorbance = 4.5*10^3; % [L/mol/cm]
ONPG_mass = 301.26; % [g/mol]
substrate_concentrations = ONPG_masses ./ (total_volume / 1000000); % [g/L]
substrate_concentrations = substrate_concentrations ./ ONPG_mass; % [mol/L]

data_table = readtable("all_data.csv");
data_table_truncated = readtable("data_truncated.csv");

rates = zeros(1, 9);
for i = 1:9
    raw_data.("t"+i) = [data_table.("time_"+i), ...
        data_table.("absorbance_"+i)];
    raw_data_truncated.("t"+i) = [data_table_truncated.("time_"+i), ...
        data_table_truncated.("absorbance_"+i)];
    data.("t"+i) = [raw_data.("t"+i)(:, 1), ...
        raw_data.("t"+i)(:, 2) ./ (path_length .* ONP_absorbance)];
    data_truncated.("t"+i) = [raw_data_truncated.("t"+i)(:, 1), ...
        raw_data_truncated.("t"+i)(:, 2) ./ (path_length .* ONP_absorbance)];
    x = data_truncated.("t"+i)(:, 1);
    y = data_truncated.("t"+i)(:, 2);
    fitn.("t"+i) = polyfitn(x, y, 1);
    rates(i) = fitn.("t"+i).Coefficients(1);
end

% Lineweaver-Burk plot
figure(1)
x = 1./substrate_concentrations(1:6);
y = 1./rates(1:6);
plot(x, y, 'ob', 'MarkerSize', 5, 'LineWidth', 1)
xlabel('[S]^{-1}')
ylabel('v^{-1}')

figure(2)
lineweaver_burk = polyfitn(x, y, 1);
plot(x, polyval(lineweaver_burk.Coefficients, x), '-b', 'LineWidth', 1)
xlabel('[S]^{-1}')
ylabel('v^{-1}')
V_max = 1/lineweaver_burk.Coefficients(2);
K_m = V_max * lineweaver_burk.Coefficients(1);

% Michaelis-Menten plot
figure(3)
S = substrate_concentrations(1:6);
V = rates(1:6);
plot(S, V, 'ob', 'MarkerSize', 5, 'LineWidth', 1)
xlim([0, 3.5e-3])
ylim([1.5e-7, 4.5e-7])
xlabel('Substrate Concentration (mol L^{-1})')
ylabel('Reaction Rate (mol L^{-1} s^{-1})')

figure(4)
model = @(b, x) (b(1) .* S) ./ (b(2) + S);
initial_guess = [V_max, K_m];
[beta, R, J, CovB, MSE, ErrorModelInfo] = ...
    nlinfit(S, V, model, initial_guess);
betaci = nlparci(beta, R, 'Jacobian', J);
x = linspace(S(1), S(6), 1000);
f = (beta(1) .* x) ./ (beta(2) + x);
plot(x, f, '-b')
xlim([0, 3.5e-3])
ylim([1.5e-7, 4.5e-7])
xlabel('Substrate Concentration (mol L^{-1})')
ylabel('Reaction Rate (mol L^{-1} s^{-1})')
