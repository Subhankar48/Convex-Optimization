% Q5
clear;
load('Q5_data.mat');
act_vals=sin(a);
A = flip(A,2);
cvx_begin quiet
    variables coefficients(K+1)
    minimize (norm(A*coefficients-act_vals', 1))
cvx_end
points = linspace(-1.1*pi, 1.1*pi, 1000);
act_vals1 = sin(points)';
pred_vals = coefficients(1)*ones(1,1000);
for i=2:K+1
    pred_vals = pred_vals.*points+coefficients(i);
end
plot(points', act_vals1, '-', points', pred_vals, '--', a',act_vals, 'o');
title('Fitting sin(x) to a polynomial of degree 3');
legend('sin(x)', 'Approximated Polynomial','data points', 'Location','Best');
grid;