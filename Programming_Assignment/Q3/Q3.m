% Q3
clear;
boolean;
m=size(A,1);
n=size(A,2);
summer = ones(n,1);
cvx_begin quiet
    variables l(m)
    maximize (-b'*l + summer'*min(0, c+A'*l))
    subject to
        l>=0
cvx_end