function slope = lerp(x, y)
    slope = polyfitn(x, y, 1).Coefficients(1);
end