function [] = yellow_light_solution()

d_safe = 0.2;
Delta_t = 0.1;

% x = [x_1 v_1 x_2 v_2 d_safe]

X0 = [-0.5 0.1 -1 0.1 d_safe]';
v02 = 0.1;
first_U2 = 0;
A = [1 Delta_t 0 0 0;
     0 1 0 0 0;
     0 0 1 Delta_t 0;
     0 0 0 1 0;
     0 0 0 0 1];
B1 = [0 Delta_t 0 0 0]';
B2 = [0 0 0 Delta_t 0]';
Q1 = [2 0 -1 0 -1;
      0 0 0 0 0;
      -1 0 1 0 1;
      0 0 0 0 0;
      -1 0 1 0 1];
Q2 = [1 0 -1 0 -1;
      0 0 0 0 0;
      -1 0 1 0 1;
      0 0 0 1 -v02/d_safe;
      -1 0 1 -v02/d_safe 1 + v02^2 / (d_safe)^2];
R1 = 1;
R2 = 1;
K = 30;

[S1_array, S2_array, T1_array, T2_array, X_array, X_prime_array, U1_array, U2_array, L1, L2] ...
    = general_solution(X0, first_U2, A, B1, B2, Q1, Q2, R1, R2, K);

disp("Player 1 Loss")
disp(L1);
disp("Player 2 Loss")
disp(L2);

U1_vector = squeeze(U1_array);
U2_vector = squeeze(U2_array);

time_frame = 1:length(U1_vector);

figure;
plot(time_frame, U1_vector, 'b', time_frame, U2_vector, 'r');

xlabel('time');
ylabel('control');
legend('Player 1', 'Player 2');

Player_1_coordinate = squeeze(X_array(1, 1, :));
Player_2_coordinate = squeeze(X_array(3, 1, :));


figure;
x_frame = 1:length(Player_1_coordinate);

plot(x_frame, Player_1_coordinate, 'b', x_frame, Player_2_coordinate, 'r', x_frame, Player_1_coordinate - Player_2_coordinate, 'g');

xlabel('time');
ylabel('distance');
legend('Player 1', 'Player 2');
% 
% Delta_t = 2 * Delta_t;
% 
% % x = [x_1 v_1 x_2 v_2 d_safe]
% 
% A = [1 Delta_t 0 0 0;
%      0 1 0 0 0;
%      0 0 1 Delta_t 0;
%      0 0 0 1 0;
%      0 0 0 0 1];
% B1 = [0 Delta_t 0 0 0]';
% B2 = [0 0 0 Delta_t 0]';
% Q1 = [2 0 -1 0 -1;
%       0 0 0 0 0;
%       -1 0 1 0 1;
%       0 0 0 0 0;
%       -1 0 1 0 1];
% Q2 = [1 0 -1 0 -1;
%       0 0 0 0 0;
%       -1 0 1 0 1;
%       0 0 0 1 -v02/d_safe;
%       -1 0 1 -v02/d_safe 1 + v02^2 / (d_safe)^2];
% 
% [x, u1, u2, L1, L2, S1, S2] = Stackelberg(A, B1, B2, Q1, Q2, R1, R2, X0, K);

% figure;
% plot(1:K, u1, 'b', 1:K,  u2, 'r')
% 
% figure;
% plot(1:K + 1, x(1, :), 'b', 1: K + 1, x(3, :), 'r', 1 : K + 1, x(1, :) - x(3, :), 'g')
% 
% 
% l1 = X0' * L1{1,1} * X0;
% l2 = X0' * L2{1,1} * X0;
% 
% disp("Player 1 Stackelberg Loss")
% disp(l1)
% disp("Player 2 Stackelberg Loss")
% disp(l2)


%Test Array Solution

X0 = [-0.5 0.1 -1 0.1 d_safe]';
v02 = 0.1;
first_U2 = 0;
A = [1 Delta_t 0 0 0;
     0 1 0 0 0;
     0 0 1 Delta_t 0;
     0 0 0 1 0;
     0 0 0 0 1];
B1 = [0 Delta_t 0 0 0]';
B2 = [0 0 0 Delta_t 0]';
Q1 = [2 0 -1 0 -1;
      0 0 0 0 0;
      -1 0 1 0 1;
      0 0 0 0 0;
      -1 0 1 0 1];
Q2 = [1 0 -1 0 -1;
      0 0 0 0 0;
      -1 0 1 0 1;
      0 0 0 1 -v02/d_safe;
      -1 0 1 -v02/d_safe 1 + v02^2 / (d_safe)^2];
R1 = [1];
R2 = [1];

A_array = repmat(A, 1, 1, K);
A_prime_array = repmat(A, 1, 1, K);
B1_array = repmat(B1, 1, 1, K);
B2_array = repmat(B2, 1, 1, K);
Q1_array = repmat(Q1, 1, 1, K);
Q2_array = repmat(Q2, 1, 1, K);
R1_array = repmat(R1, 1, 1, K);
R2_array = repmat(R2, 1, 1, K);
first_B2 = B2;
K = 30;

[X_array, X_prime_array, U1_array, U2_array, L1, L2] ...
    = array_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, K);

disp("Player 1 Loss")
disp(L1);
disp("Player 2 Loss")
disp(L2);

U1_vector = squeeze(U1_array);
U2_vector = squeeze(U2_array);

time_frame = 1:length(U1_vector);

figure;
plot(time_frame, U1_vector, 'b', time_frame, U2_vector, 'r');

xlabel('time');
ylabel('control');
legend('Player 1', 'Player 2');

Player_1_coordinate = squeeze(X_array(1, 1, :));
Player_2_coordinate = squeeze(X_array(3, 1, :));


figure;
x_frame = 1:length(Player_1_coordinate);

plot(x_frame, Player_1_coordinate, 'b', x_frame, Player_2_coordinate, 'r', x_frame, Player_1_coordinate - Player_2_coordinate, 'g');

xlabel('time');
ylabel('distance');
legend('Player 1', 'Player 2');




end

