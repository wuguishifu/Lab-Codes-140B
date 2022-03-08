function [mol, T] = mass(c)
    molar_mass = 74.5513; % g/mol

    data = readtable('data\cstr_kd_calibration.csv');
    cond = data.Conductivity;
    temp = data.Temperature;

    conds = [
        average(cond(1:12)), average(cond(18:31)), average(cond(33:44)),...
        average(cond(47:60)), average(cond(63:80)), average(cond(82:96)),...
        average(cond(99:114)), average(cond(116:131)), average(cond(135:146)),...
        average(cond(149:164)), average(cond(167:187))
    ];

    temps = [
        average(temp(1:12)), average(temp(18:31)), average(temp(33:44)),...
        average(temp(47:60)), average(temp(63:80)), average(temp(82:96)),...
        average(temp(99:114)), average(temp(116:131)), average(temp(135:146)),...
        average(temp(149:164)), average(temp(167:187))
    ];

    T_fit = polyfitn(temps, 0:10, 1);
    m_fit = polyfitn(conds, 0:10, 1);

    m = m_fit.Coefficients(1) * c + m_fit.Coefficients(2);
    mol = m/molar_mass;
    T = T_fit.Coefficients(1) * c + T_fit.Coefficients(2);
end