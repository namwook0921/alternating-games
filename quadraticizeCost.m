function [Q, R, q, r] = quadraticizeCost(G_x, G_u, H_x, H_u, x, u, x0, u0)


    allVars = [x; u];
    allVars0 = [x0; u0];


    q = subs(G_x, allVars, allVars0);
    r = subs(G_u, allVars, allVars0);

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

end
