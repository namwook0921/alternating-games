% LQ cost Solution of Alternating Game - Code by Andrew Lee
% Substitute all A, B, Q, R to array form

function [final_X_array, final_X_prime_array, final_S1_array, final_S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    = lq_cost_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T)
 


% Redefine X0, A_array, A_prime_array, Q1_array, Q2_array
n = size(X0, 1);
m = size(first_U2, 1);
new_A_array = zeros(n + 1, n + 1, T);
new_A_prime_array = zeros(n + 1, n + 1, T);
new_Q1_array = zeros(n + 1, n + 1, T);
new_Q2_array = zeros(n + 1, n + 1, T);
new_B1_array = zeros(n + 1, m);
new_B2_array = zeros(n + 1, m);

for i = 1: T
    new_A_array(:, :, i) = [A_array(:, :, i), zeros(n, 1); zeros(1, n + 1)];
    new_A_array(n + 1, n + 1, i) = 1;
    new_A_prime_array(:, :, i) = [A_prime_array(:, :, i), zeros(n, 1); zeros(1, n + 1)];
    new_A_prime_array(n + 1, n + 1, i) = 1;
    new_Q1_array(:, :, i) = [Q1_array(:, :, i), q1_array(:, :, i);  [q1_array(:, :, i)', 1]];
    new_Q2_array(:, :, i) = [Q2_array(:, :, i), q2_array(:, :, i);  [q2_array(:, :, i)', 1]];
    new_B1_array(:, :, i) = [B1_array(:, :, i); zeros(size(first_U2))'];
    new_B2_array(:, :, i) = [B2_array(:, :, i); zeros(size(first_U2))'];

end

X0 = [X0; 1];


% Define size variable
X_size = size(X0);
U_size = size(first_U2);
Q_size = size(new_Q1_array(:, :, 1));
R_size = size(R1_array(:, :, 1));
P_size = [Q_size(1), R_size(1)];
S_size = [U_size(1), X_size(1)];
T_size = [U_size(1), U_size(1)];
V_size = [X_size(1), X_size(1)];
W_size = [X_size(1), U_size(1)];
Y_size = [U_size(1), X_size(1)];
Z_size = [U_size(1), U_size(1)];

% Initialize list of Xs, Us
X_array = zeros(X_size(1), X_size(2), T + 1);
X_array(:, :, 1) = X0;
X_prime_array = zeros(X_size(1), X_size(2), T);

U1_array = zeros(U_size(1), U_size(2), T);
U2_array = zeros(U_size(1), U_size(2), T);


% Initialize list of Qs, Rs, Ps
Q1_array_cumulative = zeros(Q_size(1), Q_size(2), T);
Q2_array_cumulative = zeros(Q_size(1), Q_size(2), T);

R1_array_cumulative = zeros(R_size(1), R_size(2), T);
R2_array_cumulative = zeros(R_size(1), R_size(2), T);

P1_array = zeros(P_size(1), P_size(2), T);
P2_array = zeros(P_size(1), P_size(2), T);


% Initialize list of Ss, Ts
S1_array = zeros(S_size(1), S_size(2), T);
S2_array = zeros(S_size(1), S_size(2), T);

T1_array = zeros(T_size(1), T_size(2), T);
T2_array = zeros(T_size(1), T_size(2), T);


% Initialize list of Vs, Ws
V1_array = zeros(V_size(1), V_size(2), T);
V2_array = zeros(V_size(1), V_size(2), T);

W1_array = zeros(W_size(1), W_size(2), T);
W2_array = zeros(W_size(1), W_size(2), T);

% Initialize list of Ys, Zs
Y1_array = zeros(Y_size(1), Y_size(2), T);
Y2_array = zeros(Y_size(1), Y_size(2), T);

Z1_array = zeros(Z_size(1), Z_size(2), T);
Z2_array = zeros(Z_size(1), Z_size(2), T);


% Define last elements of Q, R, P
Q1_array_cumulative(:, :, end) = new_Q1_array(:, :, end);
Q2_array_cumulative(:, :, end) = new_Q2_array(:, :, end);
R1_array_cumulative(:, :, end) = R1_array(:, :, end);
R2_array_cumulative(:, :, end) = R2_array(:, :, end);
P1_array(:, :, end) = zeros(P_size);
P1_array(n + 1, :, end) = r1_array(:, :, end)';
P2_array(:, :, end) = zeros(P_size);
P2_array(n + 1, :, end) = r2_array(:, :, end)';


% Compute S2_K, T2_K, S1_K, T1_K of last stage
S2_array(:, :, T) = (R2_array_cumulative(:, :,T) + new_B2_array(:, :, T)' * Q2_array_cumulative(:, :,T) * new_B2_array(:, :, T) + new_B2_array(:, :, T)' * P2_array(:, :,T) ...
    + P2_array(:, :,T)' * new_B2_array(:, :, T)) \ (new_B2_array(:, :, T)' * Q2_array_cumulative(:, :,T) + P2_array(:, :,T)') * new_A_prime_array(:, :, T);
T2_array(:, :, T) = (R2_array_cumulative(:, :,T) + new_B2_array(:, :, T)' * Q2_array_cumulative(:, :,T) * new_B2_array(:, :, T) + new_B2_array(:, :, T)' * P2_array(:, :,T) + ...
    + P2_array(:, :,T)' * new_B2_array(:, :, T)) \ (new_B2_array(:, :, T)' * Q2_array_cumulative(:, :,T) + P2_array(:, :,T)') * new_B1_array(:, :, T);
S1_array(:, :, T) = (R1_array_cumulative(:, :,T) + new_B1_array(:, :, T)' * Q1_array_cumulative(:, :,T) * new_B1_array(:, :, T) + new_B1_array(:, :, T)' * P1_array(:, :,T) ...
    + P1_array(:, :,T)' * new_B1_array(:, :, T)) \ (new_B1_array(:, :, T)' * Q1_array_cumulative(:, :,T) + P1_array(:, :,T)') * new_A_array(:, :, T);
T1_array(:, :, T) = (R1_array_cumulative(:, :,T) + new_B1_array(:, :, T)' * Q1_array_cumulative(:, :,T) * new_B1_array(:, :, T) + new_B1_array(:, :, T)' * P1_array(:, :,T) ...
    + P1_array(:, :,T)' * new_B1_array(:, :, T)) \ (new_B1_array(:, :, T)' * Q1_array_cumulative(:, :,T) + P1_array(:, :,T)') * new_B2_array(:, :, T - 1);

P_zeros = zeros(n, m);

% Recursive step of computing all S, T in all time horizon from last to
% first
for i = T: -1: 2

   % Compute V2, W2
   V2_array(:, :, i) = new_A_prime_array(:, :, i) * new_A_array(:, :, i) - (eye(size(new_A_array(:, :, i))) + new_A_prime_array(:, :, i)) * new_B1_array(:, :, i) * S1_array(:, :, i) + new_B2_array(:, :, i) * S2_array(:, :, i) ...
       * (new_B1_array(:, :, i) * S1_array(:, :, i) - new_A_array(:, :, i)) + new_B2_array(:, :, i) * T2_array(:, :, i) * S1_array(:, :, i);
   W2_array(:, :, i) = new_A_prime_array(:, :, i) * new_B2_array(:, :, i - 1) - (eye(size(new_A_array(:, :, i))) + new_A_prime_array(:, :, i)) * new_B1_array(:, :, i) * T1_array(:, :, i) + new_B2_array(:, :, i) * S2_array(:, :, i) ...
       * (new_B1_array(:, :, i) * T1_array(:, :, i) - new_B2_array(:, :, i - 1)) + new_B2_array(:, :, i) * T2_array(:, :, i) * T1_array(:, :, i);

   % Compute Y2, Z2
   Y2_array(:, :, i) = S2_array(:, :, i) * new_B1_array(:, :, i - 1) * S1_array(:, :, i) + T2_array(:, :, i) * S1_array ...
       (:, :, i) - S2_array(:, :, i) * new_A_array(:, :, i);
   Z2_array(:, :, i) = S2_array(:, :, i) * new_B1_array(:, :, i - 1) * T1_array(:, :, i) + T2_array(:, :, i) * T1_array(:, :, i) - S2_array(:, :, i) * new_B2_array(:, :, i - 1);
   
   % Compute Q2, R2, P2
   Q2_array_cumulative(:, :, i - 1) = new_Q2_array(:, :, i - 1) + V2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * V2_array(:, :, i) + ...
       Y2_array(:, :, i)' * R2_array_cumulative(:, :, i) * Y2_array(:, :, i) + V2_array(:, :, i)' * P2_array(:, :, i) * Y2_array(:, :, i);
   R2_array_cumulative(:, :, i - 1) = R2_array(:, :, i - 1) + W2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * W2_array(:, :, i) + ...
       Z2_array(:, :, i - 1)' * R2_array_cumulative(:, :, i) * Z2_array(:, :, i) + W2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i);
   P2_array(:, :, i - 1) = V2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * W2_array(:, :, i) ...
       + Y2_array(:, :, i)' * R2_array_cumulative(:, :, i) * Z2_array(:, :, i) ...
       + V2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i) ...
       + Y2_array(:, :, i)' * P2_array(:, :, i)' * W2_array(:, :, i) + [P_zeros; r2_array(:, :, end)'];

   % Compute S2, T2
   S2_array(:, :, i - 1) = (R2_array_cumulative(:, :, i - 1) + new_B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) * new_B2_array(:, :, i - 1) + new_B2_array(:, :, i - 1)' * P2_array(:, :, i - 1) + ...
   P2_array(:, :, i - 1)' * new_B2_array(:, :, i - 1)) \ (new_B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) + P2_array(:, :, i - 1)') * new_A_prime_array(:, :, i - 1);
   T2_array(:, :, i - 1) = (R2_array_cumulative(:, :, i - 1) + new_B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) * new_B2_array(:, :, i - 1) + new_B2_array(:, :, i - 1)' * P2_array(:, :, i - 1) + ...
   P2_array(:, :, i - 1)' * new_B2_array(:, :, i - 1)) \ (new_B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) + P2_array(:, :, i - 1)') * new_B1_array(:, :, i - 1);

   % Compute V1, W1
   V1_array(:, :, i) = new_A_array(:, :, i) * new_A_prime_array(:, :, i - 1) - (eye(size(new_A_array(:, :, i))) + new_A_array(:, :, i)) * new_B2_array(:, :, i - 1) * S2_array(:, :, i - 1) + new_B1_array(:, :, i) * S1_array(:, :, i) ...
       * (new_B2_array(:, :, i - 1) * S2_array(:, :, i - 1) - new_A_prime_array(:, :, i - 1)) + new_B1_array(:, :, i) * T1_array(:, :, i) * S2_array(:, :, i - 1);
   W1_array(:, :, i) = new_A_array(:, :, i) * new_B1_array(:, :, i - 1) - (eye(size(new_A_array(:, :, i))) + new_A_array(:, :, i)) * new_B2_array(:, :, i - 1) * T2_array(:, :, i - 1) + new_B1_array(:, :, i) * S1_array(:, :, i) ...
       * (new_B2_array(:, :, i - 1) * T2_array(:, :, i - 1) - new_B1_array(:, :, i - 1)) + new_B1_array(:, :, i) * T1_array(:, :, i) * T2_array(:, :, i - 1);
    
   % Compute Y1, Z1
   Y1_array(:, :, i) = S1_array(:, :, i) * new_B2_array(:, :, i - 1) * S2_array(:, :, i - 1) + T1_array(:, :, i) * ...
       S2_array(:, :, i - 1) - S1_array(:, :, i) * new_A_prime_array(:, :, i - 1);
   Z1_array(:, :, i) = S1_array(:, :, i) * new_B2_array(:, :, i - 1) * T2_array(:, :, i - 1) + T1_array(:, :, i) * T2_array(:, :, i - 1) - S1_array(:, :, i) * new_B1_array(:, :, i - 1);

   % Compute Q1, R1, P1
   Q1_array_cumulative(:, :, i - 1) = new_Q1_array(:, :, i - 1) + V1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * V1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array_cumulative(:, :, i) * Y1_array(:, :, i) ...
       + V1_array(:, :, i)' * P1_array(:, :, i) * Y1_array(:, :, i);
   R1_array_cumulative(:, :, i - 1) = R1_array(:, :, i - 1) + W1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * W1_array(:, :, i) ...
       + Z1_array(:, :, i)' * R1_array_cumulative(:, :, i) * Z1_array(:, :, i) ...
       + W1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i);
   P1_array(:, :, i - 1) = V1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * W1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array_cumulative(i) * Z1_array(:, :, i) ...
       + V1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i) ...
       + Y1_array(:, :, i)' * P1_array(:, :, i)' * W1_array(:, :, i) + [P_zeros; r1_array(:, :, end)'];


   % disp(size(P1_array(:, :, i - 1)));
   % disp(size(new_B1_array(:, :, i - 1)));
   % disp(size(Q1_array_cumulative(:, :, i - 1)));

   % Compute S1, T1
   S1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * new_B1_array(:, :, i - 1) + new_B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
   P1_array(:, :, i - 1)' * new_B1_array(:, :, i - 1)) \ (new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * new_A_array(:, :, i);
   if i > 2
        T1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * new_B1_array(:, :, i - 1) + new_B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
            P1_array(:, :, i - 1)' * new_B1_array(:, :, i - 1)) \ (new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * new_B2_array(:, :, i - 2);
   else 
        T1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * new_B1_array(:, :, i - 1) + new_B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
            P1_array(:, :, i - 1)' * new_B1_array(:, :, i - 1)) \ (new_B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * [first_B2; zeros(size(first_U2))'];
   end
end
 
% Compute base case X, X', U1, U2
U1_array(:, :, 1) = -S1_array(:, :, 1) * X_array(:, :, 1) - T1_array(:, :, 1) * first_U2;
X_prime_array(:, :, 1) = new_A_array(:, :, 1) * X_array(:, :, 1) + new_B1_array(:, :, 1) * U1_array(:, :, 1) + [first_B2; zeros(size(first_U2))'] * first_U2;
U2_array(:, :, 1) = -S2_array(:, :, 1) * X_prime_array(:, :, 1) - T1_array(:, :, 1) * U1_array(:, :, 1);
X_array(:, :, 2) = new_A_prime_array(:, :, 1) * X_prime_array(:, :, 1) + new_B1_array(:, :, 1) * U1_array(:, :, 1) + [first_B2; zeros(size(first_U2))'] * U2_array(:, :, 1);

% Recursively compute the state variables and action from start to end
for i = 2 : T
    U1_array(:, :, i) = -S1_array(:, :, i) * X_array(:, :, i) - T1_array(:, :, i) * U2_array(:, :, i - 1);
    X_prime_array(:, :, i) = new_A_array(:, :, i) * X_array(:, :, i) + new_B1_array(:, :, i) * U1_array(:, :, i) + new_B2_array(:, :, i - 1) * U2_array(:, :, i - 1);
    U2_array(:, :, i) = -S2_array(:, :, i) * X_prime_array(:, :, i) - T1_array(:, :, i) * U1_array(:, :, i);
    X_array(:, :, i + 1) = new_A_prime_array(:, :, i) * X_prime_array(:, :, i) + new_B1_array(:, :, i) * U1_array(:, :, i) + new_B2_array(:, :, i) * U2_array(:, :, i);
end

L1 = X_prime_array(:, :, 1)' * Q1_array_cumulative(:, :, 1) * X_prime_array(:, :, 1) ...
    + U1_array(:, :, 1)' * R1_array_cumulative(:, :, 1) * U1_array(:, :, 1) ...
    + X_prime_array(:, :, 1)' * P1_array(:, :, 1) * U1_array(:, :, 1);

L2 = X_array(:, :, 2)' * Q2_array_cumulative(:, :, 1) * X_array(:, :, 2) ...
    + U2_array(:, :, 1)' * R2_array_cumulative(:, :, 1) * U2_array(:, :, 1) ...
    + X_array(:, :, 2)' * P2_array(:, :, 1) * U2_array(:, :, 1);

S1_size = size(S1_array(:, :, 1));
S2_size = size(S2_array(:, :, 1));

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
    final_S2_array(:, :, i) = S1_array(:, 1 : S2_size(2) - 1, i);
    final_X_array(:, :, i) = X_array(1 : n, :, i);
    final_X_prime_array(:, :, i) = X_prime_array(1 : n,: , i);
end

final_X_array(:, :, T + 1) = X_array(1 : n, :, T + 1);


end