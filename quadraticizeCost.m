function [Q, R, q, r] = quadraticizeCost(G_x, G_u, H_x, H_u, x, u, x0, u0)


    allVars = [x; u];
    allVars0 = [x0; u0];


    q = subs(G_x, allVars, allVars0);
    r = subs(G_u, allVars, allVars0);

    Q = subs(H_x, allVars, allVars0);
    R = subs(H_u, allVars, allVars0);
    
  
    Q = double(Q);
    R = double(R);
    q = double(q);
    r = double(r);

end
