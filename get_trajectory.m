function [X_array, X_prime_array] = get_trajectory(f, x, u1, u2, X_array, X_prime_array, U1_array, U2_array, first_U2, first_X, T)
    
    allVars = [x; u1; u2];

    X_array(:, :, 1) = first_X;
    X_prime_array(:, :, 1) = double(subs(f, allVars, [X_array(:, :, 1); U1_array(:, :, 1); first_U2]));

    for i = 2 : T
        X_array(:, :, i) = double(subs(f, allVars, [X_prime_array(:, :, i - 1); U1_array(:, :, i - 1); U2_array(:, :, i - 1)]));
        X_prime_array(:, :, i) = double(subs(f, allVars, [X_array(:, :, i); U1_array(:, :, i); U2_array(:, :, i - 1)]));
    end

    X_array(:, :, T + 1) = double(subs(f, allVars, [X_prime_array(:, :, T); U1_array(:, :, T); U2_array(:, :, T)]));

end    