function [x, u1, u2, L1, L2, S1, S2] = Stackelberg(A,B1,B2,Q1,Q2,R1,R2,x0,T)
[n,m1] = size(B1);
m2 = size(B2,2);

S1 = cell(T,1);
S2 = cell(T,1);
L1 = cell(T+1,1);
L2 = cell(T+1,1);
L1{T+1} = Q1;
L2{T+1} = Q2;
for k = linspace(T,1,T)
%     LL1 = (eye(n)+L2{k+1}*B2*B2')^(-1)*L1{k+1}*(eye(n)+L2{k+1}*B2*B2')^(-1);
%     S1{k} = ( R1 + B1'*LL1    *B1 )^(-1)*B1'*LL1    *A;
    M = -B1 + B2*(R2 + B2'*L2{k+1}*B2)^(-1)*B2'*L2{k+1}*B1;
    N = A   - B2*(R2 + B2'*L2{k+1}*B2)^(-1)*B2'*L2{k+1}*A;

    S1{k} = (R1 + M'*L1{k+1}*M)^(-1) * (-M'*L1{k+1}*N); % feedback strategy
    S2{k} = ( R2 + B2'*L2{k+1}*B2 )^(-1)*B2'*L2{k+1}*(A - B1*S1{k}); % feedback strategy
    
    F = (A-B1*S1{k}-B2*S2{k});
    
    L1{k} = F'*L1{k+1}*F + S1{k}'*R1*S1{k} + Q1;
    L2{k} = F'*L2{k+1}*F + S2{k}'*R2*S2{k} + Q2;
end

x = [x0, zeros(n,T)];
u1 = zeros(m1,T);
u2 = zeros(m2,T);

for t = 1:T
    u1(:,t) = -S1{t}*x(:,t);
    u2(:,t) = -S2{t}*x(:,t);
    x(:,t+1) = A*x(:,t) + B1*u1(:,t) + B2*u2(:,t);
end

end