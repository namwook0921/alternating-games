function [] = tests()

    %linearizeSystem test

    % syms x [2 1] real
    % syms u1 [1 1] real
    % syms u2 [1 1] real
    % f = [x(1)^2 + 2*x(2)^2 + 3*u1^2 + 4*u1 + 2*u2 + 7; x(1)^3 + 2*x(2) + u1^4];
    % x_0 = [1; 2];
    % x_prime_0 = [1.1; 2.1];
    % u1_0 = 3;
    % u2_0 = 1;
    % 
    % 
    % [A, B1, B2] = linearizeSystem(f, x, u1, u2, x_0, x_prime_0, u1_0, u2_0);
    % 
    % disp(A)
    % disp(B1)
    % disp(B2)


    %quadraticizeCost test

    % syms x [2 1] real
    % syms u [1 1] real
    % g = (x(1) -1)^4 + x(2)^4 + 12*x(1)^2*x(2)^2 + u^4;
    % x0 = [123; 323];
    % u0 = 7;
    % 
    % [Q, R] = quadraticizeCost(g, x, u, x0, u0);
    % 
    % disp(Q)
    % disp(R)


    
    
    Delta_t = 0.1;

    X0 = [-0.5 0.1 -1 0.1]';
    first_U2 = 0;
    A = [1 Delta_t 0 0;
         0 1 0 0;
         0 0 1 Delta_t;
         0 0 0 1];
    B1 = [0 Delta_t 0 0]';
    B2 = [0 0 0 Delta_t]';
    first_B2 = [0 0 0 Delta_t]';
    Q1 = [2 0 -1 0;
          0 0 0 0;
          -1 0 1 0;
          0 0 0 0];
    Q2 = [1 0 -1 0;
          0 0 0 0;
          -1 0 1 0;
          0 0 0 1];
    R1 = [1];
    R2 = [1];
    T = 30;
    % 
    % 
    % [S1_array, S2_array, T1_array, T2_array, X_array, X_prime_array, ...
    % U1_array, U2_array, L1, L2] = general_solution(X0, first_U2, A, B1, B2, Q1, Q2, R1, R2, T);
    % disp(U1_array)
    % disp(U2_array)

    q1 = [-0.2;
        0;
        0.2;
        0];
    q2 = [-0.2;
        0;
        0.2;
        -0.1];
    r1 = [0];
    r2 = [0];


    % lq cost solution test
    A_array = repmat(A, 1, 1, T);
    A_prime_array = repmat(A, 1, 1, T);
    B1_array = repmat(B1, 1, 1, T);
    B2_array = repmat(B2, 1, 1, T);
    Q1_array = repmat(Q1, 1, 1, T);
    Q2_array = repmat(Q2, 1, 1, T);
    R1_array = repmat(R1, 1, 1, T);
    R2_array = repmat(R2, 1, 1, T);
    q1_array = repmat(q1, 1, 1, T);
    q2_array = repmat(q2, 1, 1, T);
    r1_array = repmat(r1, 1, 1, T);
    r2_array = repmat(r2, 1, 1, T);




    [X_array, final_X_prime_array, final_S1_array, final_S2_array, T1_array, T2_array, U1_array, U2_array, alpha1_array, alpha2_array, L1, L2] ...
    = lq_cost_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T);

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
    
    disp(L1);
    disp(L2);

    % [X_array, final_X_prime_array, S1_array, S2_array, T1_array, T2_array, U1_array, U2_array, L1, L2] ...
    % = array_solution(X0, first_B2, first_U2, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, T);
    % 
    % 
    % U1_vector = squeeze(U1_array);
    % U2_vector = squeeze(U2_array);
    % 
    % time_frame = 1:length(U1_vector);
    % 
    % figure;
    % plot(time_frame, U1_vector, 'b', time_frame, U2_vector, 'r');
    % 
    % xlabel('time');
    % ylabel('control');
    % legend('Player 1', 'Player 2');
    % 
    % Player_1_coordinate = squeeze(X_array(1, 1, :));
    % Player_2_coordinate = squeeze(X_array(3, 1, :));
    % 
    % 
    % figure;
    % x_frame = 1:length(Player_1_coordinate);
    % 
    % plot(x_frame, Player_1_coordinate, 'b', x_frame, Player_2_coordinate, 'r', x_frame, Player_1_coordinate - Player_2_coordinate, 'g');
    % 
    % xlabel('time');
    % ylabel('distance');
    % legend('Player 1', 'Player 2');
    


end