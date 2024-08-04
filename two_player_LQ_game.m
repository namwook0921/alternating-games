function [] = two_player_LQ_game()

A = eye(4);
B1 = [1/2 0 0 0;
    0 1/2 0 0]';
B2 = [0 0 1/2 0;
    0 0 0 1/2]';
% Q1 = [ 0 0 0 0;
%     0 0 0 0;
%     0 0 1 0;
%     0 0 0 1];
% Q1 = [ 0 0 0 0;
%      0 0 0 0;
%      0 0 1 -1;
%      0 0 -1 1];
Q1 = [ 1 0 -2 0;
      0 1 0 -2;
      -2 0 4 0;
      0 -2 0 4];

Q2 = [1 0 -1 0;
    0 1 0 -1;
    -1 0 1 0;
    0 -1 0 1];

R1 = eye(2);
R2 = eye(2);

%x = [p1x p1y p2x p2y]

X0 = [1, 2, 3, 4]';

first_U2 = [0 0]';

K = 60;

[S1_array, S2_array, T1_array, T2_array, X_array, X_prime_array, U1_array, U2_array, L1, L2] ...
    = general_solution(X0, first_U2, A, B1, B2, Q1, Q2, R1, R2, K);

disp("Player 1 Loss")
disp(L1);
disp("Player 2 Loss")
disp(L2);


%Stackelberg Solution

A = eye(4);
B1 = [1 0 0 0;
    0 1 0 0]';
B2 = [0 0 1 0;
    0 0 0 1]';
% Q1 = [ 0 0 0 0;
%     0 0 0 0;
%     0 0 1 0;
%     0 0 0 1];
% Q1 = [ 0 0 0 0;
%      0 0 0 0;
%      0 0 1 -1;
%      0 0 -1 1];
Q1 = [ 1 0 -2 0;
      0 1 0 -2;
      -2 0 4 0;
      0 -2 0 4];

Q2 = [1 0 -1 0;
      0 1 0 -1;
      -1 0 1 0;
      0 -1 0 1];

R1 = eye(2);
R2 = eye(2);


X0 = [1, 2, 3, 4]';

first_U2 = [0 0]';



figure;
plot(X_array(1, :), X_array(2, :), 'b', X_array(3, :),  X_array(4, :), 'r')

figure;
plot(1:K + 1, X_array(1, :), 'b', 1: K + 1, X_array(2, :), 'r', 1 : K + 1, ...
    X_array(3, :), 'g', 1 : K + 1, X_array(4, :), 'y')




[x, u1, u2, L1, L2, S1, S2] = Stackelberg(A, B1, B2, Q1, Q2, R1, R2, X0, K);

figure;
plot(x(1, :), x(2, :), 'b', x(3, :),  x(4, :), 'r')

figure;
plot(1:K + 1, x(1, :), 'b', 1: K + 1, x(2, :), 'r', 1 : K + 1, ...
    x(3, :), 'g', 1 : K + 1, x(4, :), 'y')


l1 = X0' * L1{1,1} * X0;
l2 = X0' * L2{1,1} * X0;

disp("Player 1 Stackelberg Loss")
disp(l1)
disp("Player 2 Stackelberg Loss")
disp(l2)



