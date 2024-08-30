function [X_array, X_prime_array, U1_array, U2_array, L1, L2] = ...
    iLQR(f, g1, g2, x, u1, u2, T, X_array, X_prime_array, U1_array, U2_array, first_U2, first_B2, first_X, eta, plot_num)

    X_size = size(X_array(:, :, 1));
    X_zeros = zeros(X_size);
    U1_size = size(U1_array(:, :, 1));
    U2_size = size(U2_array(:, :, 1));
    U2_zeros = zeros(U2_size);


    %Comment out here
    X_array = zeros(X_size(1), X_size(2), T + 1);
    X_prime_array = zeros(X_size(1), X_size(2), T);
    U1_array = zeros(U1_size(1), U1_size(2), T);
    U2_array = zeros(U2_size(1), U2_size(2), T);

    step_threshold = 0.5;
    converge_threshold = 0.001;

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

    n = 1;

    initial_eta = eta;
    eta_step = 0.5;
    max_iter = 10;

    allVars = [x; u1; u2];

    B1_dummy = zeros(size(B1_array(:, :, 1)));
    B2_dummy = zeros(size(B1_array(:, :, 1)));


    A_jacobian = jacobian(f, x);
    B1_jacobian = jacobian(f, u1);
    B2_jacobian = jacobian(f, u2);

    G1_x = gradient(g1, x);
    G1_u = gradient(g1, u1);
    H1_x = hessian(g1, x);
    H1_u = hessian(g1, u1);

    G2_x = gradient(g2, x);
    G2_u = gradient(g2, u2);
    H2_x = hessian(g2, x);
    H2_u = hessian(g2, u2);


    % Initial trajectory when there is no control
    [X_array, X_prime_array] = get_trajectory(f, x, u1, u2, X_array, X_prime_array, U1_array, U2_array, first_U2, first_X, T);



    % Loop until converges
    while 1
        disp(n)
        n = n + 1;
        
        if plot_num == 1
            if mod(n, 5) == 0
                % Graph of nth trajectory
                x1 = squeeze(X_array(1, 1, :));
                y1 = squeeze(X_array(2, 1, :));
                x2 = squeeze(X_array(5, 1, :));
                y2 = squeeze(X_array(6, 1, :));
    
    
                figure;
                plot(x1, y1, 'o-', 'DisplayName', 'Object 1');
    
                hold on;
    
                plot(x2, y2, 's-', 'DisplayName', 'Object 2');
    
                xlabel('X Coordinate');
                ylabel('Y Coordinate');
                legend show; 
                grid on; 
            end
        end

        if plot_num == 2
            % Graph of nth trajectory
            x1 = squeeze(X_array(1, 1, :));
            y1 = squeeze(X_array(2, 1, :));

            figure;
            plot(x1, y1, 'o-', 'DisplayName', 'Object 1');

            xlabel('X Coordinate');
            ylabel('Y Coordinate');
            legend show; 
            grid on; 
        end
        
        % Linearize the System (update A, B arrays)
        [A_array(:, :, 1), B1_array(:, :, 1), B2_dummy] = ...
            linearizeSystem(A_jacobian, B1_jacobian, B2_jacobian, x, u1, u2, X_array(:, :, 1), U1_array(:, :, 1), first_U2);
        [A_prime_array(:, :, 1), B1_dummy, B2_array(:, :, 1)] = ...
            linearizeSystem(A_jacobian, B1_jacobian, B2_jacobian, x, u1, u2, X_prime_array(:, :, 1), U1_array(:, :, 1), U2_array(:, :, 1));
        
       

        parfor i = 2 : T
            [A_array(:, :, i), B1_array(:, :, i), B2_dummy] = ...
                linearizeSystem(A_jacobian, B1_jacobian, B2_jacobian, x, u1, u2, X_array(:, :, i), U1_array(:, :, i), U2_array(:, :, i - 1));
            [A_prime_array(:, :, i), B1_dummy, B2_array(:, :, i)] = ...
                linearizeSystem(A_jacobian, B1_jacobian, B2_jacobian, x, u1, u2, X_prime_array(:, :, i), U1_array(:, :, i), U2_array(:, :, i));
        end
    

        % Quadraticize the costs (update Q, R arrays)
        for i = 1 : T
            [Q1_array(:, :, i), R1_array(:, :, i), q1_array(:, :, i), r1_array(:, :, i)] = quadraticizeCost(G1_x, G1_u, H1_x, H1_u, x, u1, X_prime_array(:, :, i), U1_array(:, :, i));
            [Q2_array(:, :, i), R2_array(:, :, i), q2_array(:, :, i), r2_array(:, :, i)] = quadraticizeCost(G2_x, G2_u, H2_x, H2_u, x, u2, X_array(:, :, i + 1), U2_array(:, :, i));
        end



        % Find the solution on delta X
        [delta_X_array, delta_X_prime_array, S1_array, S2_array, T1_array, T2_array, delta_U1_array, delta_U2_array, alpha1_array, alpha2_array, L1, L2] ...
        = new_lq_cost_solution(X_zeros, first_B2, U2_zeros, A_array, A_prime_array, B1_array, B2_array, Q1_array, Q2_array, R1_array, R2_array, q1_array, q2_array, r1_array, r2_array, T);
   
    

        for step_num = 1:max_iter
            curr_eta = initial_eta * (eta_step ^ (step_num - 1));

            new_X_array(:, :, 1) = first_X;
      
            new_U1_array(:, :, 1) = U1_array(:, :, 1) - S1_array(:, :, 1) * (new_X_array(:, :, 1) - X_array(:, :, 1)) ... 
                - curr_eta * alpha1_array(:, :, 1);
    
            new_X_prime_array(:, :, 1) = double(subs(f, allVars, [new_X_array(:, :, 1); new_U1_array(:, :, 1); first_U2]));
    
            new_U2_array(:, :, 1) = U2_array(:, :, 1) - S2_array(:, :, 1) * (new_X_prime_array(:, :, 1) - X_prime_array(:, :, 1)) ... 
                - T2_array(:, :, 1) * (new_U1_array(:, :, 1) - U1_array(:, :, 1)) - curr_eta * alpha2_array(:, :, 1);  

            new_X_array(:, :, 2) = double(subs(f, allVars, [new_X_prime_array(:, :, 1); new_U1_array(:, :, 1); new_U2_array(:, :, 1)]));
        
            for i = 2 : T
                new_U1_array(:, :, i) = U1_array(:, :, i) - S1_array(:, :, i) * (new_X_array(:, :, i) - X_array(:, :, i)) ... 
                    - T1_array(:, :, i) * (new_U2_array(:, :, i - 1) - U2_array(:, :, i - 1)) - curr_eta * alpha1_array(:, :, i);
                new_X_prime_array(:, :, i) = subs(f, allVars, [new_X_array(:, :, i); new_U1_array(:, :, i); new_U2_array(:, :, i - 1)]);

                new_U2_array(:, :, i) = U2_array(:, :, i) - S2_array(:, :, i) * (new_X_prime_array(:, :, i) - X_prime_array(:, :, i)) ... 
                    - T2_array(:, :, i) * (new_U1_array(:, :, i) - U1_array(:, :, i)) - curr_eta * alpha2_array(:, :, i);
                new_X_array(:, :, i + 1) = subs(f, allVars, [new_X_prime_array(:, :, i); new_U1_array(:, :, i); new_U2_array(:, :, i)]);

            end

    
            step_converged = true;

            for i = 1:T
                if norm(new_X_array(:, :, i) - X_array(:, :, i)) > step_threshold
                    step_converged = false;
                    break;
                end
                if norm(new_X_prime_array(:, :, i) - X_prime_array(:, :, i)) > step_threshold
                    step_converged = false;
                    break;
                end
            end
        
            if step_converged
                disp(["Converged", step_num]);
                break;
            end

        end

        converge = true;
        
        % Checking if converges
        for i = 1 : T
            if norm(new_X_array(:, :, i) - X_array(:, :, i)) > converge_threshold
                converge = false;
            end
            if norm(new_X_prime_array(:, :, i) - X_prime_array(:, :, i)) > converge_threshold
                converge = false;
            end
        end
        
        
        % Updating the states and actions for next iteration
        for i = 1 : T
            U1_array(:, :, i) = new_U1_array(:, :, i);
            U2_array(:, :, i) = new_U2_array(:, :, i);
            X_array(:, :, i) = new_X_array(:, :, i);
            X_prime_array(:, :, i) = new_X_prime_array(:, :, i);
        end

        X_array(:, :, T + 1) = new_X_array(:, :, T + 1);


        if converge
            disp("converged")

            break;
        end

    end

    % Calculating cost
    % L1 = 0;
    % L2 = 0;
    % 
    % for i = 1 : T
    %     L1 = L1 + double(subs(g1, [x; u1], [X_prime_array(:, :, i); U1_array(:, :, i)]));
    %     L2 = L2 + double(subs(g2, [x; u2], [X_array(:, :, i + 1); U2_array(:, :, i)]));
    % end
    % 
    % disp(L1);
    % disp(L2);


end