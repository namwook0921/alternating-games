function [] = lq_test()

    syms x1 x2
    syms u1
    syms u2

    x = [x1; x2];

    f = x + [1; 0] * u1 + [0; 1] * u2;

    g1 = 8*(x1 - 0.2)^2 + u1' * u1;
    g2 = 4*(x2 - 1)^2 + u2' * u2;

    T = 10;
    X0 = [0; 0];
    first_U2 = 0;
    first_B2 = [0; 1];


    X_size = size(X0);
    U1_size = size(first_U2);
    U2_size = size(first_U2);

    X_array = zeros(X_size(1), X_size(2), T + 1);
    X_prime_array = zeros(X_size(1), X_size(2), T);
    U1_array = zeros(U1_size(1), U1_size(2), T);
    U2_array = zeros(U2_size(1), U2_size(2), T);

    A_array = zeros(X_size(1), X_size(1), T);
    A_prime_array = zeros(X_size(1), X_size(1), T);
    B1_array = zeros(X_size(1), U1_size(1), T);
    B2_array = zeros(X_size(1), U2_size(1), T);
    Q1_array = zeros(X_size(1), X_size(1), T);
    Q2_array = zeros(X_size(1), X_size(1), T);
    R1_array = zeros(U1_size(1), U1_size(1), T);
    R2_array = zeros(U2_size(1), U2_size(1), T);
    q1_array = zeros(X_size(1), 1, T);
    q2_array = zeros(X_size(1), 1, T);
    r1_array = zeros(U1_size(1), 1, T);
    r2_array = zeros(U2_size(1), 1, T);


    [X_array, X_prime_array] = get_trajectory(f, x, u1, u2, X_array, X_prime_array, U1_array, U2_array, first_U2, X0, T);

    [A_array(:, :, 1), B1_array(:, :, 1), B2_dummy] = ...
        linearizeSystem(f, x, u1, u2, X_array(:, :, 1), X_prime_array(:, :, 1), U1_array(:, :, 1), first_U2);
    [A_prime_array(:, :, 1), B1_dummy, B2_array(:, :, 1)] = ...
        linearizeSystem(f, x, u1, u2, X_array(:, :, 1), X_prime_array(:, :, 1), U1_array(:, :, 1), U2_array(:, :, 1));

    for i = 2 : T
        [A_array(:, :, i), B1_array(:, :, i), B2_array(:, :, i)] = ...
            linearizeSystem(f, x, u1, u2, X_array(:, :, i), X_prime_array(:, :, i), U1_array(:, :, i), U2_array(:, :, i - 1));
        [A_prime_array(:, :, i), B1_array(:, :, i), B2_array(:, :, i)] = ...
            linearizeSystem(f, x, u1, u2, X_array(:, :, i), X_prime_array(:, :, i), U1_array(:, :, i), U2_array(:, :, i));
    end

    for i = 1 : T
        [Q1_array(:, :, i), R1_array(:, :, i), q1_array(:, :, i), r1_array(:, :, i)] = quadraticizeCost(g1, x, u1, X_prime_array(:, :, i), U1_array(:, :, i));
        [Q2_array(:, :, i), R2_array(:, :, i), q2_array(:, :, i), r2_array(:, :, i)] = quadraticizeCost(g2, x, u2, X_array(:, :, i + 1), U2_array(:, :, i));
    end
    
    disp(Q1_array);
    disp(q1_array);


    [final_X_array, final_X_prime_array, final_S1_array, final_S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    = lq_cost_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T);
    
    % disp(final_X_array);
    
    x1_vector = squeeze(final_X_array(1, 1, :));
    x2_vector = squeeze(final_X_array(2, 1, :));

    time_frame = 1 : T + 1;

    figure;

    plot(time_frame, x1_vector, 'b', time_frame, x2_vector, 'r');

    xlabel('time');
    ylabel('control');
    legend('Player 1', 'Player 2');

