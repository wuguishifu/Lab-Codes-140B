clc
clear

x = 1:100;
a = 0.1;
y = (a.*x)./(1+a.*x);
plot(x, y, '-b', 'LineWidth', 2)
xlabel('$k$', 'Interpreter','latex')
ylabel('$X$', 'Interpreter','latex')
