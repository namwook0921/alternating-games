function [] = guide_vehicle_test()
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

    g1 = 8*(x1 - 0.2)^2 + 2*(u1' * u1) + 2*(v1 - 1)^2;
    g2 = 4*(x2 - x1)^2 + 4*(v2 - 1)^2 + 2*(u2' * u2);


    first_U2 = [0; 0];
    first_B2 = zeros([8, 2]);

    T = 25;

    X_array = zeros(8, 1, T + 1);
    X_prime_array = zeros(8, 1, T);
    U1_array = zeros(2, 1, T);
    U2_array = zeros(2, 1, T);

    eta = 0.9;


    [new_X_array, new_X_prime_array, new_U1_array, new_U2_array, L1, L2] = ...
        iLQR(f, g1, g2, x, u1, u2, T, X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta);



end