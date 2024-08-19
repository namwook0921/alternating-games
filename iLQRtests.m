function [] = iLQRtests()
    % d_safe = 0.2;
    % Delta_t = 0.1;
    % v_0 = 0.1;
    % T = 20;
    % 
    % eta = 0.8;
    % 
    % A = [1 Delta_t 0 0;
    %      0 1 0 0;
    %      0 0 1 Delta_t;
    %      0 0 0 1];
    % B1 = [0 Delta_t 0 0]';
    % B2 = [0 0 0 Delta_t]';
    % 
    % first_U2 = 0;
    % first_B2 = [0 0 0 Delta_t]';
    % first_X = [-0.5 0.1 -1 0.1]';
    % 
    % A_size = size(A);
    % 
    % X_array = zeros(A_size(1), 1, T + 1);
    % X_prime_array = zeros(A_size(1), 1, T);
    % U1_array = zeros(1, 1, T);
    % U2_array = zeros(1, 1, T);
    % 
    % syms x1 v1 x2 v2
    % syms u1
    % syms u2
    % x = [x1; v1; x2; v2;];
    % 
    % f = A * x + B1 * u1 + B2 * u2;
    % g1 = x1^2 + (x1 - x2 - d_safe)^2 + u1^2;
    % g2 = (v2 - v_0)^2 + (x1 - x2 - d_safe)^2 + u2^2;


    delta_t = 0.05;
    first_X = [0.5 0.5 2*pi/3 1 1 0 pi/2 1]';

    syms x1 y1 beta1 v1 x2 y2 beta2 v2
    syms omega1 alpha1
    syms omega2 alpha2

    x = [x1; y1; beta1; v1; x2; y2; beta2; v2];
    u1 = [omega1; alpha1];
    u2 = [omega2; alpha2];

    % syms f(x, u1, u2);
    % syms g1(x, u1);
    % syms g2(x, u2);

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

    eta = 0.8;


    [new_X_array, new_X_prime_array, new_U1_array, new_U2_array, L1, L2] = ...
        iLQR(f, g1, g2, x, u1, u2, T, X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta);

    % disp("Player 1 Loss")
    % disp(L1);
    % disp("Player 2 Loss")
    % disp(L2);
    % 
    % U1_vector = squeeze(new_U1_array);
    % U2_vector = squeeze(new_U2_array);
    % 
    % time_frame = 1:length(U1_vector);
    % 
    % figure;

    % plot(time_frame, U1_vector, 'b', time_frame, U2_vector, 'r');
    % 
    % xlabel('time');
    % ylabel('control');
    % legend('Player 1', 'Player 2');
    
    % x1 = squeeze(new_X_array(1, 1, :));
    % y1 = squeeze(new_X_array(2, 1, :));
    % x2 = squeeze(new_X_array(5, 1, :));
    % y2 = squeeze(new_X_array(6, 1, :));
    % 
    % 
    % figure;
    % plot(x1, y1, 'o-', 'DisplayName', 'Object 1'); 
    % 
    % hold on;
    % 
    % plot(x2, y2, 's-', 'DisplayName', 'Object 2'); 
    % 
    % xlabel('X Coordinate');
    % ylabel('Y Coordinate');
    % legend show; 
    % grid on; 


end