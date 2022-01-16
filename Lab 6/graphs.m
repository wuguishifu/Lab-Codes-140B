clc
clear

tris_volumes =   [750, 800, 900, 950, 980, 990, 980, 980, 980]; % [uL 50 mM]
ONPG_volumes =   [250, 200, 100,  50,  20,  10,  20,  20,  20]; % [uL 4 mg/mL]
enzyme_volumes = [ 50,  50,  50,  50,  50,  50,  30,  20,  10]; % [uL]

data_table = readtable("all_data.csv");
for i = 1:9
    data.("t"+i) = [data_table.("time_"+i), data_table.("absorbance_"+i)];
end

% varied enzyme concentrations at 980 uL 50 mM tris and 20 uL 4 mg/mL ONPG
figure(1)
hold on
trials = [5, 7, 8, 9];
colors = ["r", "g", "b", "k"];
for i = 1:4
    plot(data.("t" + trials(i))(:, 1), ...
        data.("t" + trials(i))(:, 2), ("."+colors(i)), 'MarkerSize', 4)
end
xlabel('Time (s)')
ylabel('Absorbance')
legend({'50 \muL', '30 \muL', '20 \muL', '10 \muL'}, ...
    "Location", "southeast");
