% Newton's Method
clear;
x0=[-1; 0.7];
x = x0;
all_x=x0;
step_size=0.1;
niters=0;
alpha=0.1;
beta=0.5;
while norm([exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+3*x(2)-0.1)-3*exp(x(1)-3*x(2)-0.1)],2)>0.01
    grad_x = [exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+3*x(2)-0.1)-3*exp(x(1)-3*x(2)-0.1)];
    h11_x = exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)+exp(-x(1)-0.1);
    h12_x = 3*exp(x(1)+3*x(2)-0.1)-3*exp(x(1)-3*x(2)-0.1);
    h21_x = h12_x;
    h22_x = 9*(exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1));
    hess_x = [h11_x h12_x; h21_x h22_x];
    del_x = -pinv(hess_x)*grad_x;    
    d = del_x;
    t=1;
    x_dash = x+t*d;
    new_f=exp(x_dash(1)+3*x_dash(2)-0.1)+exp(x_dash(1)-3*x_dash(2)-0.1)+exp(-x_dash(1)-0.1);
    while new_f>exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)+exp(-x(1)-0.1)+alpha*t*del_x'*d
        t=beta*t;
        x_dash = x+t*d;
        new_f=exp(x_dash(1)+3*x_dash(2)-0.1)+exp(x_dash(1)-3*x_dash(2)-0.1)+exp(-x_dash(1)-0.1);
    end
    x = x+t*d;
    all_x = [all_x, x];
    niters=niters+1;
end
optval=exp(x(1)+3*x(2)-0.1)+exp(x(1)-3*x(2)-0.1)+exp(-x(1)-0.1);
best_x=x;

x = all_x;
plot(x(1,1),x(2,1),'rx')
hold on
for i = 2:niters
    plot(x(1,i),x(2,i),'rx')
    draw_line(x(:,i-1),x(:,i))
    hold on
end
grid;
title("Convergence plot for BLS with Newton's Method");

