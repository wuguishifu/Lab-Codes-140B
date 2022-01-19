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
end

% absorbance of ONP vs. time plot for varied enzyme volumes at 980 uL 50 mM
% tris and 20 uL 4 mg/mL ONPG
figure(1)
hold on
trials = [5, 7, 8, 9];
colors = ["r", "g", "b", "k"];
for i = 1:4
    plot(raw_data.("t" + trials(i))(:, 1), ...
        raw_data.("t" + trials(i))(:, 2), ("."+colors(i)), 'MarkerSize', 4)
end
xlabel('Time (s)')
ylabel('Absorbance')
legend({'50 \muL', '30 \muL', '20 \muL', '10 \muL'}, ...
    "Location", "southeast");

% concentration of ONP vs. time plot for varied enzyme volumes at 980 uL 50
% mM tris and 20 uL 4 mg/mL ONPG
figure(2)
hold on
trials = [5, 7, 8, 9];
colors = ["r", "g", "b", "k"];
for i = 1:4
    plot(raw_data.("t" + trials(i))(:, 1), ...
        raw_data.("t" + trials(i))(:, 2), ("."+colors(i)), 'MarkerSize', 4)
end
xlabel('Time (s)')
ylabel('Concentration ONP (mol L^{-1})')
legend({'50 \muL', '30 \muL', '20 \muL', '10 \muL'}, ...
    "Location", "southeast");

% concentration of ONP vs. time plot and linear regression for varied
% enzyme volumes at 980 uL 50 mM tris and 20 uL 4 mg/mL ONPG
figure(3)
hold on
trials = [5, 7, 8, 9];
colors = ["r", "g", "b", "k"];
for i = 1:4
    x = data_truncated.("t" + trials(i))(:, 1);
    y = data_truncated.("t" + trials(i))(:, 2);
    plot(x, y, ("." + colors(i)), 'MarkerSize', 5)
end
xlabel('Time (s)')
ylabel('Concentration ONP (mol L^{-1})')
legend({'50 \muL', '30 \muL', '20 \muL', '10 \muL'}, ...
    "Location", "southeast");
ylim([0, 2.5e-5])

figure(4)
hold on
trials = [5, 7, 8, 9];
colors = ["r", "g", "b", "k"];
for i = 1:4
    x = data_truncated.("t" + trials(i));
    plot(x, polyval(fitn.("t" + trials(i)).Coefficients, x), ...
        ("-" + colors(i)), 'LineWidth', 1)
end
xlabel('Time (s)')
ylabel('Concentration ONP (mol L^{-1})')
legend({'50 \muL', '30 \muL', '20 \muL', '10 \muL'}, ...
    "Location", "southeast");
ylim([0, 2.5e-5])

figure(5)
hold on
trials = [5, 7, 8, 9];
x = zeros(1, 4);
y = zeros(1, 4);
for i = 1:4
    y(i) = fitn.("t" + trials(i)).Coefficients(1);
    x(i) = enzyme_volumes(trials(i));
end
plot(x, y, 'ob', 'MarkerSize', 5, 'LineWidth', 1)
xlim([5, 55])
xlabel('Purified Enzyme Volume (\muL)')
ylabel('Reaction Rate (mol L^{-1} s^{-1})')

figure(6)
fit = polyfitn(x, y, 1);
plot(x, polyval(fit.Coefficients, x), '-b', 'LineWidth', 1)
xlim([5, 55])
xlabel('Purified Enzyme Volume (\muL)')
ylabel('Reaction Rate (mol L^{-1} s^{-1})')

% concentration of ONP vs. time plot and linear regression for varied
% substrate concentrations.
figure(7)
hold on
trials = [1, 2, 3, 4, 5, 6];
colors = ['r', 'g', 'b', 'k', 'm', 'c'];
for i = 1:6
    x = data_truncated.("t" + trials(i))(:, 1);
    y = data_truncated.("t" + trials(i))(:, 2);
    plot(x, y, ("." + colors(i)), 'MarkerSize', 5)
end
xlabel('Time (s)')
ylabel('Concentration ONP (mol L^{-1})')
legend(cellstr(num2str(substrate_concentrations(1:6)', '%.2e mol/L')),...
    "Location", "southeast")

figure(8)
hold on
trials = [1, 2, 3, 4, 5, 6];
colors = ['r', 'g', 'b', 'k', 'm', 'c'];
for i = 1:6
    x = data_truncated.("t" + trials(i))(:, 1);
    plot(x, polyval(fitn.("t" + trials(i)).Coefficients, x), ...
        ("-" + colors(i)), 'LineWidth', 1)
end
xlabel('Time (s)')
ylabel('Concentration ONP (mol L^{-1})')
legend(cellstr(num2str(substrate_concentrations(1:6)', '%.2e mol/L')),...
    "Location", "southeast")


