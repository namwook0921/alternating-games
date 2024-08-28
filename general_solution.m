% General Solution of Alternating Game - Code by Andrew Lee


function [S1_array, S2_array, T1_array, T2_array, X_array, X_prime_array, ...
    U1_array, U2_array, L1, L2] = general_solution(X0, first_U2, A, B1, B2, Q1, Q2, R1, R2, T)

% Define size variable
X_size = size(X0);
U_size = size(first_U2);
Q_size = size(Q1);
R_size = size(R1);
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
Q1_array = zeros(Q_size(1), Q_size(2), T);
Q2_array = zeros(Q_size(1), Q_size(2), T);

R1_array = zeros(R_size(1), R_size(2), T);
R2_array = zeros(R_size(1), R_size(2), T);

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
Q1_array(:, :, end) = Q1;
Q2_array(:, :, end) = Q2;
R1_array(:, :, end) = R1;
R2_array(:, :, end) = R2;
P1_array(:, :, end) = zeros(P_size);
P2_array(:, :, end) = zeros(P_size);


% Compute S2_K, T2_K, S1_K, T1_K of last stage
S2_array(:, :, T) = (R2_array(:, :,T) + B2' * Q2_array(:, :,T) * B2 + 2 * B2' * P2_array(:, :,T)) ...
    \ (B2' * Q2_array(:, :,T) + P2_array(:, :,T)') * A;
T2_array(:, :, T) = (R2_array(:, :,T) + B2' * Q2_array(:, :,T) * B2 + 2 * B2' * P2_array(:, :,T)) ...
    \ (B2' * Q2_array(:, :,T) + P2_array(:, :,T)') * B1;
S1_array(:, :, T) = (R1_array(:, :,T) + B1' * Q1_array(:, :,T) * B1 + 2 * B1' * P1_array(:, :,T)) ...
    \ (B1' * Q1_array(:, :,T) + P1_array(:, :,T)') * A;
T1_array(:, :, T) = (R1_array(:, :,T) + B1' * Q1_array(:, :,T) * B1 + 2 * B1' * P1_array(:, :,T)) ...
    \ (B1' * Q1_array(:, :,T) + P1_array(:, :,T)') * B2;


% Recursive step of computing all S, T in all time horizon from last to
% first
for i = T: -1: 2

   % Compute V2, W2
   V2_array(:, :, i) = A^2 - (eye(size(A)) + A) * B1 * S1_array(:, :, i) + B2 * S2_array(:, :, i) ...
       * (B1 * S1_array(:, :, i) - A) + B2 * T2_array(:, :, i) * S1_array(:, :, i);
   W2_array(:, :, i) = A * B2 - (eye(size(A)) + A) * B1 * T1_array(:, :, i) + B2 * S2_array(:, :, i) ...
       * (B1 * T1_array(:, :, i) - B2) + B2 * T2_array(:, :, i) * T1_array(:, :, i);

   % Compute Y2, Z2
   Y2_array(:, :, i) = S2_array(:, :, i) * B1 * S1_array(:, :, i) + T2_array(:, :, i) * S1_array(:, :, i) - S2_array(:, :, i) * A;
   Z2_array(:, :, i) = S2_array(:, :, i) * B1 * T1_array(:, :, i) + T2_array(:, :, i) * T1_array(:, :, i) - S2_array(:, :, i) * B2;
   
   % Compute Q2, R2, P2
   Q2_array(:, :, i - 1) = Q2 + V2_array(:, :, i)' * Q2_array(:, :, i) * V2_array(:, :, i) ...
       + Y2_array(:, :, i)' * R2_array(:, :, i) * Y2_array(:, :, i) + 2 * V2_array(:, :, i)' * P2_array(:, :, i) * Y2_array(:, :, i);
   R2_array(:, :, i - 1) = R2 + W2_array(:, :, i)' * Q2_array(:, :, i) * W2_array(:, :, i) + ...
       + Z2_array(:, :, i)' * R2_array(:, :, i) * Z2_array(:, :, i) + 2 * W2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i);
   P2_array(:, :, i - 1) = V2_array(:, :, i)' * Q2_array(:, :, i) * W2_array(:, :, i) ...
       + Y2_array(:, :, i)' * R2_array(:, :, i) * Z2_array(:, :, i) ...
       + V2_array(:, :, i)' * P2_array(:, :, i) * Z2_array(:, :, i) ...
       + Y2_array(:, :, i)' * P2_array(:, :, i)' * W2_array(:, :, i);

   % Compute S2, T2
   S2_array(:, :, i - 1) = (R2_array(:, :, i - 1) + B2' * Q2_array(:, :, i - 1) * B2 + B2' * P2_array(:, :, i - 1) + ...
        P2_array(:, :, i - 1)' * B2) \ (B2' * Q2_array(:, :, i - 1) + P2_array(:, :, i - 1)') * A;
   T2_array(:, :, i - 1) = (R2_array(:, :, i - 1) + B2' * Q2_array(:, :, i - 1) * B2 + B2' * P2_array(:, :, i - 1) + ...
        P2_array(:, :, i - 1)' * B2) \ (B2' * Q2_array(:, :, i - 1) + P2_array(:, :, i - 1)') * B1;

   % Compute V1, W1
   V1_array(:, :, i) = A^2 - (eye(size(A)) + A) * B2 * S2_array(:, :, i - 1) + B1 * S1_array(:, :, i) ...
       * (B2 * S2_array(:, :, i - 1) - A) + B1 * T1_array(:, :, i) * S2_array(:, :, i - 1);
   W1_array(:, :, i) = A * B1 - (eye(size(A)) + A) * B2 * T2_array(:, :, i - 1) + B1 * S1_array(:, :, i) ...
       * (B2 * T2_array(:, :, i - 1) - B1) + B1 * T1_array(:, :, i) * T2_array(:, :, i - 1);
    
   % Compute Y1, Z1
   Y1_array(:, :, i) = S1_array(:, :, i) * B2 * S2_array(:, :, i - 1) + T1_array(:, :, i) * S2_array(:, :, i - 1) - S1_array(:, :, i) * A;
   Z1_array(:, :, i) = S1_array(:, :, i) * B2 * T2_array(:, :, i - 1) + T1_array(:, :, i) * T2_array(:, :, i - 1) - S1_array(:, :, i) * B1;

   % Compute Q1, R1, P1
   Q1_array(:, :, i - 1) = Q1 + V1_array(:, :, i)' * Q1_array(:, :, i) * V1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array(:, :, i) * Y1_array(:, :, i) + 2 * V1_array(:, :, i)' * P1_array(:, :, i) * Y1_array(:, :, i);
   R1_array(:, :, i - 1) = R1 + W1_array(:, :, i)' * Q1_array(:, :, i) * W1_array(:, :, i) ...
       + Z1_array(:, :, i)' * R1_array(:, :, i) * Z1_array(:, :, i) + 2 * W1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i);
   P1_array(:, :, i - 1) = V1_array(:, :, i)' * Q1_array(:, :, i) * W1_array(:, :, i) ...
       + Y1_array(:, :, i)' * R1_array(:, :, i) * Z1_array(:, :, i) ...
       + V1_array(:, :, i)' * P1_array(:, :, i) * Z1_array(:, :, i) ...
       + Y1_array(:, :, i)' * P1_array(:, :, i)' * W1_array(:, :, i);

   % disp("Q1")
   % disp(Q1_array(:, :, 2))
   % disp("R1")
   % disp(R1_array(:, :, 2))
   % disp("P1")
   % disp(P1_array(:, :, 2))
   % disp("V1")
   % disp(V1_array(:, :, 2))
   % disp("W1")
   % disp(W1_array(:, :, 2))
   % disp("Y1")
   % disp(Y1_array(:, :, 2))
   % disp("Z1")
   % disp(Z1_array(:, :, 2))

   % Compute S1, T1
   S1_array(:, :, i - 1) = (R1_array(:, :, i - 1) + B1' * Q1_array(:, :, i - 1) * B1 + B1' * P1_array(:, :, i - 1) + ...
       P1_array(:, :, i - 1)' * B1) \ (B1' * Q1_array(:, :, i - 1) + P1_array(:, :, i - 1)') * A;
   T1_array(:, :, i - 1) = (R1_array(:, :, i - 1) + B1' * Q1_array(:, :, i - 1) * B1 + B1' * P1_array(:, :, i - 1) + ...
       P1_array(:, :, i - 1)' * B1) \ (B1' * Q1_array(:, :, i - 1) + P1_array(:, :, i - 1)') * B2;
end
 
% Compute base case X, X', U1, U2
U1_array(:, :, 1) = -S1_array(:, :, 1) * X_array(:, :, 1) - T1_array(:, :, 1) * first_U2;
X_prime_array(:, :, 1) = A * X_array(:, :, 1) + B1 * U1_array(:, :, 1) + B2 * first_U2;
U2_array(:, :, 1) = -S2_array(:, :, 1) * X_prime_array(:, :, 1) - T2_array(:, :, 1) * U1_array(:, :, 1);
X_array(:, :, 2) = A * X_prime_array(:, :, 1) + B1 * U1_array(:, :, 1) + B2 * U2_array(:, :, 1);


% Recursively compute the state variables and action from start to end
for i = 2 : T
    U1_array(:, :, i) = -S1_array(:, :, i) * X_array(:, :, i) - T1_array(:, :, i) * U2_array(:, :, i - 1);
    X_prime_array(:, :, i) = A * X_array(:, :, i) + B1 * U1_array(:, :, i) + B2 * U2_array(:, :, i - 1);
    U2_array(:, :, i) = -S2_array(:, :, i) * X_prime_array(:, :, i) - T2_array(:, :, i) * U1_array(:, :, i);
    X_array(:, :, i + 1) = A * X_prime_array(:, :, i) + B1 * U1_array(:, :, i) + B2 * U2_array(:, :, i);
end


L1 = X_prime_array(:, :, 1)' * Q1_array(:, :, 1) * X_prime_array(:, :, 1) ...
    + U1_array(:, :, 1)' * R1_array(:, :, 1) * U1_array(:, :, 1) ...
    + X_prime_array(:, :, 1)' * P1_array(:, :, 1) * U1_array(:, :, 1);

L2 = X_array(:, :, 2)' * Q2_array(:, :, 1) * X_array(:, :, 2) ...
    + U2_array(:, :, 1)' * R2_array(:, :, 1) * U2_array(:, :, 1) ...
    + X_array(:, :, 2)' * P2_array(:, :, 1) * U2_array(:, :, 1);

% for i = 1 : K
%     disp(i)
%     disp(X_array(:, :, i + 1)' * Q2 * X_array(:, :, i + 1) + U2_array(:, :, i)' * R2 * U2_array(:, :, i))

end