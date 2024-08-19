function [A, B1, B2] = linearizeSystem(A_jacobian, B1_jacobian, B2_jacobian, x, u1, u2, x_0, x_prime_0, u1_0, u2_0)

    % disp(A_jacobian);
    
    A = double(subs(A_jacobian, [x; u1; u2], [x_0; u1_0; u2_0]));
    B1 = double(subs(B1_jacobian, [x; u1; u2], [x_0; u1_0; u2_0]));
    B2 = double(subs(B2_jacobian, [x; u1; u2], [x_prime_0; u1_0; u2_0]));

    % disp(A);
    % disp(B1);
    % disp(B2);


   
end