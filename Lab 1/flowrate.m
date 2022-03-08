% returns a flowrate in L/s
function f = flowrate(p)
    speed = [10, 20, 30, 40, 50, 60]; % (%)
    flowrates = 1./[
        210, 92, 76, 50, 45, 35;
        205, 94, 75, 59, 41, 38;
        199, 96, 75, 53, 43, 35;
    ]; % (L/s)
    
    f_avg = sum(flowrates(:, :))./3; % (L/s)
    fitn = polyfitn(speed, f_avg, 1);
    f = fitn.Coefficients(1) * p + fitn.Coefficients(2);
end