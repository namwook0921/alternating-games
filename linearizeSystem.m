function [A, B1, B2] = linearizeSystem(f, x, u1, u2, x_0, x_prime_0, u1_0, u2_0)

    A_jacobian = jacobian(f, x);
    B1_jacobian = jacobian(f, u1);
    B2_jacobian = jacobian(f, u2);
    % disp(A_jacobian);
    
    A = double(subs(A_jacobian, [x; u1; u2], [x_0; u1_0; u2_0]));
    B1 = double(subs(B1_jacobian, [x; u1; u2], [x_0; u1_0; u2_0]));
    B2 = double(subs(B2_jacobian, [x; u1; u2], [x_prime_0; u1_0; u2_0]));

    % disp(A);
    % disp(B1);
    % disp(B2);


   
end