function [] = lane_exchange_test()
    
    first_X = [-1 0.1 0 1.2 1 0 0 1]';
    delta_t = 0.05;

    syms px1 vx1 py1 vy1 px2 vx2 py2 vy2
    syms ax1 ay1
    syms ax2 ay2

    x = [px1; vx1; py1; vy1; px2; vx2; py2; vy2];
    u1 = [ax1; ay1];
    u2 = [ax2; ay2];

    A = [1 delta_t 0 0 0 0 0 0;
         0 1 0 0 0 0 0 0;
         0 0 1 delta_t 0 0 0 0;
         0 0 0 1 0 0 0 0;
         0 0 0 0 1 delta_t 0 0;
         0 0 0 0 0 1 0 0;
         0 0 0 0 0 0 1 delta_t;
         0 0 0 0 0 0 0 1];

    B1 = [0 0;
          delta_t 0;
          0 0;
          0 delta_t;
          0 0;
          0 0;
          0 0;
          0 0];

    B2 = [0 0;
          0 0;
          0 0;
          0 0;
          0 0;
          delta_t 0;
          0 0;
          0 delta_t];

    f = A * x + B1 * u1 + B2 * u2;

    d_target = (px1 - 1)^2 + (py1 - 10)^2 + (px2 + 1)^2 + (py2 - 10)^2;
    d_safe = 1/t2 * ((px1 - px2)^2 + (py1 - py2)^2);

    g1 = d_target - d_safe + vx1^2 + (vy1 - 1)^2+ 4*(u1'*u1);
    g2 = d_target - d_safe + vx2^2 + (vy2 - 1)^2+ 4*(u2'*u2);


    first_U2 = [0; 0];
    first_B2 = zeros([8, 2]);

    T = 30;

    X_array = zeros(8, 1, T + 1);
    X_prime_array = zeros(8, 1, T);
    U1_array = zeros(2, 1, T);
    U2_array = zeros(2, 1, T);

    eta = 0.5;
    step_threshold = 1;
    converge_threshold = 0.01;
    plot_num = 1;


    [new_X_array, new_X_prime_array, new_U1_array, new_U2_array, L1, L2] = ...
        iLQR(f, g1, g2, x, u1, u2, T, X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta, step_threshold, converge_threshold, plot_num);


    x1 = squeeze(new_X_array(1, 1, :));
    y1 = squeeze(new_X_array(3, 1, :));
    x2 = squeeze(new_X_array(5, 1, :));
    y2 = squeeze(new_X_array(7, 1, :));


    % Save the required variables to a .mat file after computations
    save('lane_exchange_data.mat', 'x1', 'y1', 'x2', 'y2');





end