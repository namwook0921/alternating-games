function [] = guide_vehicle_subgame_perfect_test()
    delta_t = 0.05;
    first_X = [0.5 0.5 2*pi/3 1 1 0 pi/2 1]';

    syms x1 y1 beta1 v1 x2 y2 beta2 v2
    syms omega1 alpha1
    syms omega2 alpha2

    x = [x1; y1; beta1; v1; x2; y2; beta2; v2];
    u1 = [omega1; alpha1];
    u2 = [omega2; alpha2];

    A = [1 0 0 delta_t * cos(beta1) 0 0 0 0;
         0 1 0 delta_t * sin(beta1) 0 0 0 0;
         0 0 1 0 0 0 0 0;
         0 0 0 1 0 0 0 0;
         0 0 0 0 1 0 0 delta_t * cos(beta2);
         0 0 0 0 0 1 0 delta_t * sin(beta2);
         0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 1];

    B1 = [0 0;
          0 0;
          delta_t 0;
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
          0 0;
          delta_t 0;
          0 delta_t];

    f = A * x + B1 * u1 + B2 * u2;

    g1 = 8*(x1 - 0.2)^2 + 2*(v1 - 1)^2 + 1*(u1' * u1);
    g2 = 4*(x2 - x1)^2 + 4*(v2 - 1)^2 + 1*(u2' * u2);


    first_U2 = [0; 0];
    first_B2 = zeros([8, 2]);

    T = 40;

    X_array = zeros(8, 1, T + 1);
    X_prime_array = zeros(8, 1, T);
    U1_array = zeros(2, 1, T);
    U2_array = zeros(2, 1, T);

    eta = 0.8;
    step_threshold = 0.2;
    converge_threshold = 0.005;
    plot_num = 1;


    [new_X_array, new_X_prime_array, new_U1_array, new_U2_array, L1, L2] = ...
        iLQR(f, g1, g2, x, u1, u2, T, X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta, step_threshold, converge_threshold, plot_num);


    x1 = squeeze(new_X_array(1, 1, 1:20));
    y1 = squeeze(new_X_array(2, 1, 1:20));
    x2 = squeeze(new_X_array(5, 1, 1:20));
    y2 = squeeze(new_X_array(6, 1, 1:20));


    subgame_first_X = new_X_array(:, :, 21);
    subgame_first_U2 = new_U2_array(:, :, 20);
    subgame_first_B2 = B2;
    subgame_T = 20;

    [subgame_X_array, subgame_X_prime_array, subgame_U1_array, subgame_U2_array, subgame_L1, subgame_L2] = ...
        iLQR(f, g1, g2, x, u1, u2, subgame_T, X_array, X_prime_array, U1_array, U2_array, subgame_first_U2, subgame_first_B2, subgame_first_X, eta, step_threshold, converge_threshold, plot_num);

    % Extract data
    x3 = squeeze(subgame_X_array(1, 1, :));
    y3 = squeeze(subgame_X_array(2, 1, :));
    x4 = squeeze(subgame_X_array(5, 1, :));
    y4 = squeeze(subgame_X_array(6, 1, :));


    % Save the required variables to a .mat file after computations
    save('subgame_perfect_data.mat', 'x1', 'y1', 'x2', 'y2', 'x3', 'y3', 'x4', 'y4');




end

