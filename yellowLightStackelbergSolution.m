function [S1_1, S2_1, S2_0, S1_0] = yellowLightStackelbergSolution(A, B1, B2, Q1, Q2, R1, R2)
    % Compute S1_1
    S1_1 = inv(R1 + B1'*(eye(size(A)) - B2*inv(R2 + B2'*Q2*B2)*B2')'*Q1*(eye(size(A)) - B2*inv(R2 + B2'*Q2*B2)*B2'*B1))*A;
    
    % Compute S2_1
    S2_1 = inv(R2 + B2'*Q2*B2)*B2'*Q2*(A - B1*S1_1);
    
    % Compute Q'1
    Q1_prime = (A - B1*S1_1 - B2*S2_1)'*Q1*(A - B1*S1_1 - B2*S2_1) + S1_1'*B1'*R1*B1*S1_1 + Q1;
    
    % Compute Q'2
    Q2_prime = (A - B1*S1_1 - B2*S2_1)'*Q2*(A - B1*S1_1 - B2*S2_1) + S2_1'*B2'*R2*B2*S2_1 + Q2;
    
    % Compute C1
    C1 = (eye(size(A)) - B2*inv(R2 + B2'*Q2_prime*B2)*B2'*Q2_prime);
    
    % Compute S1_0
    S1_0 = inv(R1 + B1'*C1'*Q1*C1*B1)*A;

    % Compute S2_0
    S2_0 = inv(R2 + B2'*Q2'*B2)*B2'*Q2'*(A - B1*S1_0);
end