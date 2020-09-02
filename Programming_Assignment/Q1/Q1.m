% Q1
clear;
circle_fit;
number_of_variables=3;
A = ones(length(x), number_of_variables);
A(:,1) = 2*x;
A(:,2) = 2*y;
b = x.^2+y.^2;
cvx_begin quiet
    variable p %xc
    variable q %yc
    variable r %c**2-xc**2-yc**2
    minimize (norm(A*[p;q;r]- b,2))
cvx_end
xc=p;
yc=q;
r=sqrt(r+p^2+q^2);
t = linspace(0, 2*pi, 1000);
plot(x, y, 'o', r*cos(t) + xc, r*sin(t) + yc, '-');
hold on;
plot(xc, yc, 'o', 'MarkerFaceColor', 'g');
grid;
legend('Data Points','Best fit circle','Centre', 'Location','Best');
title('Best fit circle for given data');