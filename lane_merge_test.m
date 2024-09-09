function [] = lane_merge_test()

    delta_t = 0.05;

    first_X =  [
        0.9;
        1.2;
        0.0;
        3.5;
        0.5;
        0.6;
        0.0;
        3.8;
    ];

    syms x1 y1 theta1 v1 x2 y2 theta2 v2
    syms omega1 alpha1
    syms omega2 alpha2

    x = [x1; y1; theta1; v1; x2; y2; theta2; v2];
    u1 = [omega1; alpha1];
    u2 = [omega2; alpha2];

    A = [1 0 0 delta_t * sin(theta1) 0 0 0 0;
         0 1 0 delta_t * cos(theta1) 0 0 0 0;
         0 0 1 0 0 0 0 0;
         0 0 0 1 0 0 0 0;
         0 0 0 0 1 0 0 delta_t * sin(theta2);
         0 0 0 0 0 1 0 delta_t * cos(theta2);
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

    d_safe = 0.45;

    control = abs(sqrt((x1 - x2)^2 + (y1 - y2)^2) - d_safe) - (sqrt((x1 - x2)^2 + (y1 - y2)^2) - d_safe) ;

    g1 = 10*(x1 - 0.4)^2 + 6*(v1 - v2)^2 + 2*(u1' * u1) + 1000*control;
    g2 = theta2^4 + 2*(u2' * u2) + 1000*control;



    first_U2 = [0; 0];
    first_B2 = zeros([8, 2]);

    T = 20;

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


    x1 = squeeze(new_X_array(1, 1, :));
    y1 = squeeze(new_X_array(2, 1, :));
    x2 = squeeze(new_X_array(5, 1, :));
    y2 = squeeze(new_X_array(6, 1, :));


    figure;
    plot(x1, y1, 'o-', 'DisplayName', 'Object 1');

    hold on;

    plot(x2, y2, 's-', 'DisplayName', 'Object 2');

    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    legend show; 
    grid on; 


    [traj] = get_full_trajectory(X_array, X_prime_array, T);

    disp(traj)
end