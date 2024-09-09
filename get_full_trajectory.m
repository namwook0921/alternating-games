function [full_trajectory] = get_full_trajectory(X_array, X_prime_array, T);
    
    X_null = zeros(size(X_array));
    
    full_trajectory = repmat(X_null, 1, 1, 2*T + 1);
    full_trajectory(:, :, 1) = X_array(:, :, 1);


    for i = 1 : T
        full_trajectory(:, :, 2 * i) = X_prime_array(:, :, i);
        full_trajectory(:, :, 2 * i + 1) = X_array(:, :, i + 1);
    end

end