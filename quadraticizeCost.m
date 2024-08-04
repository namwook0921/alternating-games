function [Q, R, q, r] = quadraticizeCost(g, x, u, x0, u0)


    allVars = [x; u];
    allVars0 = [x0; u0];
    


    gradG_x = gradient(g, x);
    gradG_u = gradient(g, u);

    % disp(allVars0);
    % disp(allVars);
    % disp(gradG_x);
    % disp(gradG_u);

    q = subs(gradG_x, allVars, allVars0);
    r = subs(gradG_u, allVars, allVars0);

    

    H_x = hessian(g, x);  
    H_u = hessian(g, u); 

    % disp(H_x);
    % disp(H_u);
    

    Q = subs(H_x, allVars, allVars0);
    R = subs(H_u, allVars, allVars0);
    
  
    Q = double(Q);
    Q = Q/2;
    R = double(R);
    R = R/2;
    q = double(q);
    q = q/2;
    r = double(r);
    r = r/2;

    % disp(Q);
    % disp(R);
    % disp(q);
    % disp(r);

end
