% Q4
% direct minimization
clear;
load('Q4_data.mat');
y = xs(:,2:100);
x = xs(:,1:99);
n = size(x(:,1),1);
m = size(us(:,1),1);
cvx_begin quiet
    variables A(n,n)
    variables B(n,m)
    minimize (sum(sum_square_abs(y-A*x-B*us)))
cvx_end
estimation_error=cvx_optval;
best_A = A;
best_B = B;


% enforcing sparsity in A and B
nsteps=0;
load('Q4_data.mat');
y = xs(:,2:100);
x = xs(:,1:99);
n = size(x(:,1),1);
m = size(us(:,1),1);
non_zero_vals = [];
squared_errors = [];
threshold=0.01;
step_size=10;
for lambda = 10:2:70
    cvx_begin quiet
        variables A(n,n)
        variables B(n,m)
        minimize (sum(sum_square_abs(y-A*x-B*us))+lambda*(sum(sum(abs(A)))+sum(sum(abs(B)))))
    cvx_end
    num_non_zero = nnz(abs(A)>=threshold)+nnz(abs(B)>=threshold);
    penalty = norm(A(abs(A)<threshold),2)+norm(B(abs(B)<threshold),2); %a slight penalty term added to penalize values close to 0.01
    num_non_zero = num_non_zero+penalty;                                % Hence, my number of non zero points is not exactly an integer. 
    se = norm(y-A*x-B*us, 'fro')^2;
    non_zero_vals = [non_zero_vals num_non_zero];
    squared_errors = [squared_errors se];
    clear A;
    clear B;
    nsteps = nsteps+1;
end
x = [squared_errors; non_zero_vals];
plot(x(1,1),x(2,1),'rx')
hold on
for i = 2:nsteps
    plot(x(1,i),x(2,i),'rx')
    draw_line(x(:,i-1),x(:,i))
    hold on
end
plot(849.1936 ,73.0544, 'o', 'MarkerFaceColor', 'g');
grid;
text(849.1936 ,73.0544, 'Chosen Point', 'VerticalAlignment','bottom','HorizontalAlignment','left');
xlabel('Squared Error');
ylabel('Total Non-Zero Entries');
title('Pareto Frontier for the Optimization Problem');


