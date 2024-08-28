% LQ cost Solution of Alternating Game - Code by Andrew Lee
% Substitute all A, B, Q, R to array form

function [final_X_array, final_X_prime_array, final_S1_array, final_S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    = new_lq_cost_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T)
 


% Redefine X0, A_array, A_prime_array, Q1_array, Q2_array
n = size(X0, 1);
m = size(first_U2, 1);

new_A_array = zeros(n + 1, n + 1, T);
new_A_prime_array = zeros(n + 1, n + 1, T);
new_Q1_array = zeros(n + 1, n + 1, T);
new_Q2_array = zeros(n + 1, n + 1, T);
new_B1_array = zeros(n + 1, m, T);
new_B2_array = zeros(n + 1, m, T);
new_P1_array = zeros(n + 1, m, T);
new_P2_array = zeros(n + 1, m, T);

P_zeros = zeros(n, m);

for i = 1: T
    new_A_array(:, :, i) = [A_array(:, :, i), zeros(n, 1); zeros(1, n + 1)];
    new_A_array(n + 1, n + 1, i) = 1;
    new_A_prime_array(:, :, i) = [A_prime_array(:, :, i), zeros(n, 1); zeros(1, n + 1)];
    new_A_prime_array(n + 1, n + 1, i) = 1;
    new_Q1_array(:, :, i) = [Q1_array(:, :, i), q1_array(:, :, i);  [q1_array(:, :, i)', 1]];
    new_Q2_array(:, :, i) = [Q2_array(:, :, i), q2_array(:, :, i);  [q2_array(:, :, i)', 1]];
    new_B1_array(:, :, i) = [B1_array(:, :, i); zeros(size(first_U2))'];
    new_B2_array(:, :, i) = [B2_array(:, :, i); zeros(size(first_U2))'];
    new_P1_array(:, :, i) = [P_zeros; r1_array(:, :, i)'];
    new_P2_array(:, :, i) = [P_zeros; r2_array(:, :, i)'];
end

X0 = [X0; 1];
first_B2 = [first_B2; zeros(m, 1)'];

[X_array, X_prime_array, S1_array, S2_array, T1_array, T2_array, U1_array, U2_array, L1, L2] ...
    = linear_offset_array_solution(X0, first_B2, first_U2, new_A_array, new_A_prime_array, new_B1_array, new_B2_array, new_Q1_array, new_Q2_array, R1_array, R2_array, new_P1_array, new_P2_array, T);
% 
% disp(S1_array)
% disp(S2_array)

S1_size = size(S1_array(:, :, 1));
S2_size = size(S2_array(:, :, 1));

U_size = size(U1_array);

alpha1_array = zeros(U_size(1), U_size(2), T);
alpha2_array = zeros(U_size(1), U_size(2), T);

final_X_array = zeros(n, 1, T + 1);
final_X_prime_array = zeros(n, 1, T);

final_S1_array = zeros(m, n, T);
final_S2_array = zeros(m, n, T);

for i = 1 : T
    alpha1_array(:, :, i) = S1_array(:, S1_size(2) : S1_size(2), i);
    alpha2_array(:, :, i) = S2_array(:, S2_size(2) : S2_size(2), i);
    final_S1_array(:, :, i) = S1_array(:, 1 : S1_size(2) - 1, i);
    final_S2_array(:, :, i) = S2_array(:, 1 : S2_size(2) - 1, i);
    final_X_array(:, :, i) = X_array(1 : n, :, i);
    final_X_prime_array(:, :, i) = X_prime_array(1 : n,: , i);
end

final_X_array(:, :, T + 1) = X_array(1 : n, :, T + 1);


end