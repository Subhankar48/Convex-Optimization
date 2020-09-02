% Q2
% gradient descent
clear;
x0=[-1; 0.7];
x = x0;
all_x=x0;
step_size=0.1;
niters=0;
while norm([exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+3*x(2)-0.1)-3*exp(x(1)-3*x(2)-0.1)],2)>0.01
    del_x = -[exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+3*x(2)-0.1)-3*exp(x(1)-3*x(2)-0.1)];
    x = x+step_size*del_x;
    all_x = [all_x, x];
    niters=niters+1;
end
best_x=x;
optval=exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)+exp(-x(1)-0.1);

x = all_x;
plot(x(1,1),x(2,1),'rx')
hold on
for i = 2:niters
    plot(x(1,i),x(2,i),'rx')
    draw_line(x(:,i-1),x(:,i))
    hold on
end
grid;
title("Convergence plot for Gradient Descent with step size 0.01");
