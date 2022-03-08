clc
clear

format shortE

trials.f30.F = flowrate(30); % (L/s)
trials.f40.F = flowrate(40); % (L/s)
trials.f60.F = flowrate(60); % (L/s)
trials.flowrates = [trials.f30.F, trials.f40.F, trials.f60.F];
disp(trials.flowrates)

trials.f30 = [
    3500, 3000, 2000, 1500, 1000; % (RPM)
    3.7, 3.6, 3.2, 2.9, 2.7;
];

trials.f40 = [
    3500, 3000, 2000, 1500, 1000; % (RPM)
    3.7, 3.5, 3.2, 2.9, 2.7; % (mL)
];

trials.f60 = [
    3500, 3000, 2000, 1500, 1000; % (RPM)
    2.8, 2.7, 2.5, 2.2, 2.3; % (mL)
];

trials.f30(2, :) = (0.1 .* trials.f30(2, :)) ./ 5;
trials.f40(2, :) = (0.1 .* trials.f40(2, :)) ./ 5;
trials.f60(2, :) = (0.1 .* trials.f60(2, :)) ./ 5;
trials.f30(3, :) = 0.1 - trials.f30(2, :);
trials.f40(3, :) = 0.1 - trials.f40(2, :);
trials.f60(3, :) = 0.1 - trials.f60(2, :);

% distribution ratio vs. rotor speed
figure()
D.f30 = trials.f30(2, :)./trials.f30(3, :);
D.f40 = trials.f40(2, :)./trials.f40(3, :);
D.f60 = trials.f60(2, :)./trials.f60(3, :);
hold on
plot(trials.f30(1, :), D.f30, '.r', 'MarkerSize', 15)
plot(trials.f40(1, :), D.f40, '.g', 'MarkerSize', 15)
plot(trials.f60(1, :), D.f60, '.b', 'MarkerSize', 15)
xlabel('Rotor Speed (RPM)')
ylabel('Distribution Ratio')
legend({'30% Flowrate', '40% Flowrate', '60% Flowrate'}, 'Location', 'NorthWest')

% figure()
fitn.f30.d = polyfitn(trials.f30(1, :), D.f30, 1);
fitn.f40.d = polyfitn(trials.f40(1, :), D.f40, 1);
fitn.f60.d = polyfitn(trials.f60(1, :), D.f60, 1);
hold on
plot(trials.f30(1, :), polyval(fitn.f30.d.Coefficients, trials.f30(1, :)), '-r')
plot(trials.f40(1, :), polyval(fitn.f40.d.Coefficients, trials.f40(1, :)), '-g')
plot(trials.f60(1, :), polyval(fitn.f60.d.Coefficients, trials.f60(1, :)), '-b')
xlabel('Rotor Speed (RPM)')
ylabel('Distribution Ratio')
legend({'30% Flowrate', '40% Flowrate', '60% Flowrate'}, 'Location', 'NorthWest')
fitn.d.Coefficients = [fitn.f30.d.Coefficients; fitn.f40.d.Coefficients; fitn.f60.d.Coefficients];
fitn.d.p = [fitn.f30.d.p; fitn.f40.d.p; fitn.f60.d.p];
disp(fitn.d.Coefficients)
disp(fitn.d.p)

% percent extraction vs. rotor speed
figure()
E.f30 = 100 .* D.f30 ./ (1 + D.f30);
E.f40 = 100 .* D.f40 ./ (1 + D.f40);
E.f60 = 100 .* D.f60 ./ (1 + D.f60);
hold on
plot(trials.f30(1, :), E.f30, '.r', 'MarkerSize', 15)
plot(trials.f40(1, :), E.f40, '.g', 'MarkerSize', 15)
plot(trials.f60(1, :), E.f60, '.b', 'MarkerSize', 15)
xlabel('Rotor Speed (RPM)')
ylabel('Percent Extraction (%)')
legend({'30% Flowrate', '40% Flowrate', '60% Flowrate'}, 'Location', 'NorthWest')

% figure()
fitn.f30.e = polyfitn(trials.f30(1, :), E.f30, 1);
fitn.f40.e = polyfitn(trials.f40(1, :), E.f40, 1);
fitn.f60.e = polyfitn(trials.f60(1, :), E.f60, 1);
hold on
plot(trials.f30(1, :), polyval(fitn.f30.e.Coefficients, trials.f30(1, :)), '-r')
plot(trials.f40(1, :), polyval(fitn.f40.e.Coefficients, trials.f40(1, :)), '-g')
plot(trials.f60(1, :), polyval(fitn.f60.e.Coefficients, trials.f60(1, :)), '-b')
xlabel('Rotor Speed (RPM)')
ylabel('Percent Extraction (%)')
legend({'30% Flowrate', '40% Flowrate', '60% Flowrate'}, 'Location', 'NorthWest')
fitn.e.Coefficients = [fitn.f30.e.Coefficients; fitn.f40.e.Coefficients; fitn.f60.e.Coefficients];
fitn.e.p = [fitn.f30.e.p; fitn.f40.e.p; fitn.f60.e.p];
disp(fitn.e.Coefficients)
disp(fitn.e.p)

% our data point
figure()
rpm = 3000;
v_tit = [7.2, 7.5, 7.0];
m_in = 0.17;
m_y = (0.1 .* v_tit) ./ 5;
m_x = m_in - m_y;
d = m_y ./ m_x;
d_avg = sum(d)/3;
d_std = std(d);
hold on
plot(trials.f30(1, :), polyval(fitn.f30.d.Coefficients, trials.f30(1, :)), '-r')
errorbar(rpm, d_avg, d_std, '.b', 'MarkerSize', 15);
xlabel('Rotor Speed (RPM)')
ylabel('Distribution Ratio')
legend({'Previous Distribution Ratio at 30% Flowrate', 'New Data Point at 3000 RPM'}, ...
    'Location', 'NorthWest')

figure()
e = 100 .* d ./ (d + 1);
e_avg = sum(e)/3;
e_std = std(e);
hold on
plot(trials.f30(1, :), polyval(fitn.f30.e.Coefficients, trials.f30(1, :)), '-r')
errorbar(rpm, e_avg, e_std, '.b', 'MarkerSize', 15)
xlabel('Rotor Speed (RPM)')
ylabel('Percent Extraction (%)')
legend({'Previous Percent Extraction at 30% Flowrate', 'New Data Point at 3000 RPM'}, ...
    'Location', 'NorthWest')
