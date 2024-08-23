function [] = simple_test()
    first_X = [1 1]';

    syms x1 x2
    syms v1 v2
    syms w1 w2

    x = [x1; x2];

    u1 = [v1; v2];
    u2 = [w1; w2];

    A = [1 0;
         0 1];

    B1 = [1 0;
          0 1];

    B2 = [1 0;
          0 1];

    f = A * x + B1 * u1 + B2 * u2;

    g1 = x2^2 + u1' * u1;
    g2 = (x2 - x1)^2 + u2' * u2;

    Q1 = [0 0;
          0 1];

    Q2 = [1 -1;
          -1 1];

    R1 = eye(2);

    R2 = eye(2);


    first_U2 = [0; 0];
    first_B2 = [1 0;
                0 1];

    T = 6;

    X_array = zeros(2, 1, T + 1);
    X_prime_array = zeros(2, 1, T);
    U1_array = zeros(2, 1, T);
    U2_array = zeros(2, 1, T);

    eta = 1;


    [S1_array, S2_array, T1_array, T2_array, result_X_array, X_prime_array, U1_array, U2_array, L1, L2] ...
        = general_solution(first_X, first_U2, A, B1, B2, Q1, Q2, R1, R2, T);

    

    % Graph of nth trajectory
    x1 = squeeze(result_X_array(1, 1, :));
    x2 = squeeze(result_X_array(2, 1, :));


    figure;
    plot(x1, x2, 'o-', 'DisplayName', 'Object 1');

    xlabel('X1 Coordinate');
    ylabel('X2 Coordinate');
    legend show; 
    grid on; 


    A_array = repmat(A, 1, 1, 7);
    A_prime_array = repmat(A, 1, 1, 6);
    B1_array = repmat(B1, 1, 1, 6);
    B2_array = repmat(B2, 1, 1, 6);
    Q1_array = repmat(Q1, 1, 1, 6);
    Q2_array = repmat(Q2, 1, 1, 6);
    R1_array = repmat(R1, 1, 1, 6);
    R2_array = repmat(R2, 1, 1, 6);
    q1 = [0; 0];
    q2 = [0; 0];
    q1_array = repmat(q1, 1, 1, 6);
    q2_array = repmat(q2, 1, 1, 6);
    r1 = [0; 0];
    r2 = [0; 0];
    r1_array = repmat(r1, 1, 1, 6);
    r2_array = repmat(r2, 1, 1, 6);
    

    % [final_X_array, final_X_prime_array, final_S1_array, final_S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    % = lq_cost_solution(first_X, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T);
 
    
    [result_X_array, result_X_prime_array, result_U1_array, result_U2_array, L1, L2] = ...
        iLQR(f, g1, g2, x, u1, u2, T, result_X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta, 2);


    % Graph of nth trajectory
    % x1 = squeeze(final_X_array(1, 1, :));
    % x2 = squeeze(final_X_array(2, 1, :));
    % 
    % 
    % figure;
    % plot(x1, x2, 'o-', 'DisplayName', 'Object 1');
    % 
    % xlabel('X1 Coordinate');
    % ylabel('X2 Coordinate');
    % legend show; 
    % grid on; 


end