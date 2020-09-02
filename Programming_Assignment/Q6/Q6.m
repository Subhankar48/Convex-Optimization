% Q6;
clear;
C_hat = [1 -0.76 0.07 -0.96; -0.76 1 0.18 0.07; 0.07 0.18 1 0.41; -0.96 0.07 0.41 1];
m = size(C_hat,1);
cvx_begin sdp quiet
    variable C(m,m) semidefinite
    minimize (norm(C-C_hat, 'fro'))
    subject to
        C(1,1)==1
        C(2,2)==1
        C(3,3)==1
        C(4,4)==1
cvx_end