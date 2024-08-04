% Approximate Solution of Linear Quadratic Cost - Code by Andrew Lee
% Iterate adding affine terms until cost is stabilized

function [X_array, X_prime_array, S1_array, S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    = lq_cost_approximation(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, r1_array, r2_array, K)

% Define size variable
X_size = size(X0);
U_size = size(first_U2);
Q_size = size(Q1_array(:, :, 1));
R_size = size(R1_array(:, :, 1));
P_size = [Q_size(1), R_size(1)];
S_size = [U_size(1), X_size(1)];
T_size = [U_size(1), U_size(1)];
V_size = [X_size(1), X_size(1)];
W_size = [X_size(1), U_size(1)];
Y_size = [U_size(1), X_size(1)];
Z_size = [U_size(1), U_size(1)];

% Initialize list of Xs, Us
X_array = zeros(X_size(1), X_size(2), K + 1);
X_array(:, :, 1) = X0;
X_prime_array = zeros(X_size(1), X_size(2), K);

U1_array = zeros(U_size(1), U_size(2), K);
U2_array = zeros(U_size(1), U_size(2), K);

alpha1_array = zeros(U_size(1), U_size(2), K);
alpha2_array = zeros(U_size(1), U_size(2), K);


% Initialize list of Qs, Rs, Ps
Q1_array_cumulative = zeros(Q_size(1), Q_size(2), K);
Q2_array_cumulative = zeros(Q_size(1), Q_size(2), K);

R1_array_cumulative = zeros(R_size(1), R_size(2), K);
R2_array_cumulative = zeros(R_size(1), R_size(2), K);

P1_array = zeros(P_size(1), P_size(2), K);
P2_array = zeros(P_size(1), P_size(2), K);


% Initialize list of Ss, Ts
S1_array = zeros(S_size(1), S_size(2), K);
S2_array = zeros(S_size(1), S_size(2), K);

T1_array = zeros(T_size(1), T_size(2), K);
T2_array = zeros(T_size(1), T_size(2), K);


% Initialize list of Vs, Ws
V1_array = zeros(V_size(1), V_size(2), K);
V2_array = zeros(V_size(1), V_size(2), K);

W1_array = zeros(W_size(1), W_size(2), K);
W2_array = zeros(W_size(1), W_size(2), K);

% Initialize list of Ys, Zs
Y1_array = zeros(Y_size(1), Y_size(2), K);
Y2_array = zeros(Y_size(1), Y_size(2), K);

Z1_array = zeros(Z_size(1), Z_size(2), K);
Z2_array = zeros(Z_size(1), Z_size(2), K);


% Define last elements of Q, R, P
Q1_array_cumulative(:, :, end) = Q1_array(:, :, end);
Q2_array_cumulative(:, :, end) = Q2_array(:, :, end);
R1_array_cumulative(:, :, end) = R1_array(:, :, end);
R2_array_cumulative(:, :, end) = R2_array(:, :, end);
P1_array(:, :, end) = zeros(P_size);
P2_array(:, :, end) = zeros(P_size);


% Compute S2_K, T2_K, S1_K, T1_K of last stage
S2_array(:, :, K) = (R2_array_cumulative(:, :,K) + B2_array(:, :, K)' * Q2_array_cumulative(:, :,K) * B2_array(:, :, K) + B2_array(:, :, K)' * P2_array(:, :,K) ...
    + P2_array(:, :,K)' * B2_array(:, :, K)) \ (B2_array(:, :, K)' * Q2_array_cumulative(:, :,K) + P2_array(:, :,K)') * A_prime_array(:, :, K);
T2_array(:, :, K) = (R2_array_cumulative(:, :,K) + B2_array(:, :, K)' * Q2_array_cumulative(:, :,K) * B2_array(:, :, K) + B2_array(:, :, K)' * P2_array(:, :,K) + ...
    + P2_array(:, :,K)' * B2_array(:, :, K)) \ (B2_array(:, :, K)' * Q2_array_cumulative(:, :,K) + P2_array(:, :,K)') * B1_array(:, :, K);
S1_array(:, :, K) = (R1_array_cumulative(:, :,K) + B1_array(:, :, K)' * Q1_array_cumulative(:, :,K) * B1_array(:, :, K) + B1_array(:, :, K)' * P1_array(:, :,K) ...
    + P1_array(:, :,K)' * B1_array(:, :, K)) \ (B1_array(:, :, K)' * Q1_array_cumulative(:, :,K) + P1_array(:, :,K)') * A_array(:, :, K);
T1_array(:, :, K) = (R1_array_cumulative(:, :,K) + B1_array(:, :, K)' * Q1_array_cumulative(:, :,K) * B1_array(:, :, K) + B1_array(:, :, K)' * P1_array(:, :,K) ...
    + P1_array(:, :,K)' * B1_array(:, :, K)) \ (B1_array(:, :, K)' * Q1_array_cumulative(:, :,K) + P1_array(:, :,K)') * B2_array(:, :, K - 1);


% Recursive step of computing all S, T in all time horizon from last to
% first
for i = K: -1: 2

   % Compute V2, W2
   V2_array(:, :, i) = A_prime_array(:, :, i) * A_array(:, :, i) - (eye(size(A_array(:, :, i))) + A_prime_array(:, :, i)) * B1_array(:, :, i) * S1_array(:, :, i) + B2_array(:, :, i) * S2_array(:, :, i) ...
       * (B1_array(:, :, i) * S1_array(:, :, i) - A_array(:, :, i)) + B2_array(:, :, i) * T2_array(:, :, i) * S1_array(:, :, i);
   W2_array(:, :, i) = A_prime_array(:, :, i) * B2_array(:, :, i - 1) - (eye(size(A_array(:, :, i))) + A_prime_array(:, :, i)) * B1_array(:, :, i) * T1_array(:, :, i) + B2_array(:, :, i) * S2_array(:, :, i) ...
       * (B1_array(:, :, i) * T1_array(:, :, i) - B2_array(:, :, i - 1)) + B2_array(:, :, i) * T2_array(:, :, i) * T1_array(:, :, i);

   % Compute Y2, Z2
   Y2_array(:, :, i) = S2_array(:, :, i) * B1_array(:, :, i - 1) * S1_array(:, :, i) + T2_array(:, :, i) * S1_array ...
       (:, :, i) - S2_array(:, :, i) * A_array(:, :, i);
   Z2_array(:, :, i) = S2_array(:, :, i) * B1_array(:, :, i - 1) * T1_array(:, :, i) + T2_array(:, :, i) * T1_array(:, :, i) - S2_array(:, :, i) * B2_array(:, :, i - 1);
   
   % Compute Q2, R2, P2
   Q2_array_cumulative(:, :, i - 1) = Q2_array(:, :, i - 1) + V2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * V2_array(:, :, i) + ...
       Y2_array(:, :, i)' * R2_array_cumulative(:, :, i) * Y2_array(:, :, i) + V2_array(:, :, i)' * P2_array(:, :, i) * Y2_array(:, :, i);
   R2_array_cumulative(:, :, i - 1) = R2_array(:, :, i - 1) + W2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * W2_array(:, :, i) + ...
       Z2_array(:, :, i - 1)' * R2_array_cumulative(:, :, i) * Z2_array(:, :, i) + W2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i);
   P2_array(:, :, i - 1) = V2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * W2_array(:, :, i) ...
       + Y2_array(:, :, i)' * R2_array_cumulative(:, :, i) * Z2_array(:, :, i) ...
       + V2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i) ...
       + Y2_array(:, :, i)' * P2_array(:, :, i)' * W2_array(:, :, i);

   % Compute S2, T2
   S2_array(:, :, i - 1) = (R2_array_cumulative(:, :, i - 1) + B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) * B2_array(:, :, i - 1) + B2_array(:, :, i - 1)' * P2_array(:, :, i - 1) + ...
   P2_array(:, :, i - 1)' * B2_array(:, :, i - 1)) \ (B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) + P2_array(:, :, i - 1)') * A_prime_array(:, :, i - 1);
   T2_array(:, :, i - 1) = (R2_array_cumulative(:, :, i - 1) + B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) * B2_array(:, :, i - 1) + B2_array(:, :, i - 1)' * P2_array(:, :, i - 1) + ...
   P2_array(:, :, i - 1)' * B2_array(:, :, i - 1)) \ (B2_array(:, :, i - 1)' * Q2_array_cumulative(:, :, i - 1) + P2_array(:, :, i - 1)') * B1_array(:, :, i - 1);

   % Compute V1, W1
   V1_array(:, :, i) = A_array(:, :, i) * A_prime_array(:, :, i - 1) - (eye(size(A_array(:, :, i))) + A_array(:, :, i)) * B2_array(:, :, i - 1) * S2_array(:, :, i - 1) + B1_array(:, :, i) * S1_array(:, :, i) ...
       * (B2_array(:, :, i - 1) * S2_array(:, :, i - 1) - A_prime_array(:, :, i - 1)) + B1_array(:, :, i) * T1_array(:, :, i) * S2_array(:, :, i - 1);
   W1_array(:, :, i) = A_array(:, :, i) * B1_array(:, :, i - 1) - (eye(size(A_array(:, :, i))) + A_array(:, :, i)) * B2_array(:, :, i - 1) * T2_array(:, :, i - 1) + B1_array(:, :, i) * S1_array(:, :, i) ...
       * (B2_array(:, :, i - 1) * T2_array(:, :, i - 1) - B1_array(:, :, i - 1)) + B1_array(:, :, i) * T1_array(:, :, i) * T2_array(:, :, i - 1);
    
   % Compute Y1, Z1
   Y1_array(:, :, i) = S1_array(:, :, i) * B2_array(:, :, i - 1) * S2_array(:, :, i - 1) + T1_array(:, :, i) * ...
       S2_array(:, :, i - 1) - S1_array(:, :, i) * A_prime_array(:, :, i - 1);
   Z1_array(:, :, i) = S1_array(:, :, i) * B2_array(:, :, i - 1) * T2_array(:, :, i - 1) + T1_array(:, :, i) * T2_array(:, :, i - 1) - S1_array(:, :, i) * B1_array(:, :, i - 1);

   % Compute Q1, R1, P1
   Q1_array_cumulative(:, :, i - 1) = Q1_array(:, :, i - 1) + V1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * V1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array_cumulative(:, :, i) * Y1_array(:, :, i) ...
       + V1_array(:, :, i)' * P1_array(:, :, i) * Y1_array(:, :, i);
   R1_array_cumulative(:, :, i - 1) = R1_array(:, :, i - 1) + W1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * W1_array(:, :, i) ...
       + Z1_array(:, :, i)' * R1_array_cumulative(:, :, i) * Z1_array(:, :, i) ...
       + W1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i);
   P1_array(:, :, i - 1) = V1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * W1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array_cumulative(i) * Z1_array(:, :, i) ...
       + V1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i) ...
       + Y1_array(:, :, i)' * P1_array(:, :, i)' * W1_array(:, :, i);

   % Compute S1, T1
   S1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * B1_array(:, :, i - 1) + B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
    P1_array(:, :, i - 1)' * B1_array(:, :, i - 1)) \ (B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * A_array(:, :, i);
    if i > 2
        T1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * B1_array(:, :, i - 1) + B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
            P1_array(:, :, i - 1)' * B1_array(:, :, i - 1)) \ (B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * B2_array(:, :, i - 2);
    else 
        T1_array(:, :, i - 1) = (R1_array_cumulative(:, :, i - 1) + B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) * B1_array(:, :, i - 1) + B1_array(:, :, i - 1)' * P1_array(:, :, i - 1) + ...
            P1_array(:, :, i - 1)' * B1_array(:, :, i - 1)) \ (B1_array(:, :, i - 1)' * Q1_array_cumulative(:, :, i - 1) + P1_array(:, :, i - 1)') * first_B2;
    end
end
 
% Compute base case X, X', U1, U2
U1_array(:, :, 1) = -S1_array(:, :, 1) * X_array(:, :, 1) - T1_array(:, :, 1) * first_U2;
X_prime_array(:, :, 1) = A_array(:, :, 1) * X_array(:, :, 1) + B1_array(:, :, 1) * U1_array(:, :, 1) + first_B2 * first_U2;
U2_array(:, :, 1) = -S2_array(:, :, 1) * X_prime_array(:, :, 1) - T1_array(:, :, 1) * U1_array(:, :, 1);
X_array(:, :, 2) = A_prime_array(:, :, 1) * X_prime_array(:, :, 1) + B1_array(:, :, 1) * U1_array(:, :, 1) + first_B2 * U2_array(:, :, 1);

% Recursively compute the state variables and action from start to end
for i = 2 : K
    U1_array(:, :, i) = -S1_array(:, :, i) * X_array(:, :, i) - T1_array(:, :, i) * U2_array(:, :, i - 1);
    X_prime_array(:, :, i) = A_array(:, :, i) * X_array(:, :, i) + B1_array(:, :, i) * U1_array(:, :, i) + B2_array(:, :, i - 1) * U2_array(:, :, i - 1);
    U2_array(:, :, i) = -S2_array(:, :, i) * X_prime_array(:, :, i) - T1_array(:, :, i) * U1_array(:, :, i);
    X_array(:, :, i + 1) = A_prime_array(:, :, i) * X_prime_array(:, :, i) + B1_array(:, :, i) * U1_array(:, :, i) + B2_array(:, :, i) * U2_array(:, :, i);
end

L1 = X_prime_array(:, :, 1)' * Q1_array_cumulative(:, :, 1) * X_prime_array(:, :, 1) ...
    + U1_array(:, :, 1)' * R1_array_cumulative(:, :, 1) * U1_array(:, :, 1) ...
    + X_prime_array(:, :, 1)' * P1_array(:, :, 1) * U1_array(:, :, 1);

L2 = X_array(:, :, 2)' * Q2_array_cumulative(:, :, 1) * X_array(:, :, 2) ...
    + U2_array(:, :, 1)' * R2_array_cumulative(:, :, 1) * U2_array(:, :, 1) ...
    + X_array(:, :, 2)' * P2_array(:, :, 1) * U2_array(:, :, 1);


for i = 1 : K
    alpha1_array(:, :, i) = (R1_array_cumulative(:, :, i) + B1_array(:, :, i)' * Q1_array_cumulative(:, :, i) * B1_array(:, :, i) + B1_array(:, :, i)' * P1_array(:, :, i) + ...
        P1_array(:, :, i)' * B1_array(:, :, i)) \ r1_array(:, :, i);
    alpha2_array(:, :, i) = (R2_array_cumulative(:, :, i) + B2_array(:, :, i)' * Q2_array_cumulative(:, :, i) * B2_array(:, :, i) + B2_array(:, :, i)' * P2_array(:, :, i) + ...
        P2_array(:, :, i)' * B2_array(:, :, i)) \ r2_array(:, :, i);
end


end