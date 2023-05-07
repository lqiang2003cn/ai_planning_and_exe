clear;

A = [0.9 0.1; 0.1 0.9];

B = zeros(2,2,2);
% pi = 1: stay
B(:,:,1) = [0.9 0.1; 0.1 0.9];
% pi = 2: trans
B(:,:,2) = [0.1 0.9; 0.9 0.1];

D = [0.3; 0.7];
E = [0.5; 0.5];

%P(o1,o2,s1,s1,pi)
Joint = zeros(2,2,2,2,2);
for o1=1:2
    for o2=1:2
        for s1 = 1:2
            for s2 = 1:2
                for pi = 1:2            
                    Joint(o1,o2,s1,s2,pi) = E(pi) * D(s1) * A(o1,s1) * B(s2,s1,pi) * A(o2,s2);
                end
            end
        end
    end
end
disp(sum(Joint,"all"))
%disp(Joint(1,1,1,1,1))
%disp(Joint(2,1,1,1,1))

Po = zeros(2,2);
for o1=1:2
    for o2=1:2
        Po(o1,o2)=sum(Joint(o1,o2,:,:,:), "all");
    end
end
disp(sum(Po,"all"))

%p(s1,s2,pi|o1,o2)
Ps1_s2_pi_o = zeros(2,2,2,2,2);
for o1 = 1:2
    for o2 = 1:2
        for s1=1:2
            for s2=1:2             
                for pi=1:2
                    Ps1_s2_pi_o(s1,s2,pi,o1,o2) = Joint(o1,o2,s1,s2,pi) / Po(o1,o2);
                end
            end
        end
    end
end
for o1=1:2
    for o2=1:2
        disp(sum(Ps1_s2_pi_o(:,:,:,o1,o2),"all"))
    end
end

Ps1_o = zeros(2,2,2);
Ps2_o = zeros(2,2,2);
Ppi_o = zeros(2,2,2);
for o2 = 1:2
    for o1 = 1:2
        Ps1_o(:,o1,o2)=sum(Ps1_s2_pi_o(:,:,:,o1,o2),[2,3]);
        Ps2_o(:,o1,o2)=sum(Ps1_s2_pi_o(:,:,:,o1,o2),[1,3]);
        Ppi_o(:,o1,o2)=sum(Ps1_s2_pi_o(:,:,:,o1,o2),[1,2]);
        disp(sum(Ps1_o(:,o1,o2),"all"))
        disp(sum(Ps2_o(:,o1,o2),"all"))
        disp(sum(Ppi_o(:,o1,o2),"all"))
    end
end
disp(Ppi_o(:,1,1))


disp('c')











% Functions
function Posterior_norm = Bayes(Likelihood, Prior, Observation)
    Posterior = Prior .* (Likelihood' * Observation);
    Posterior_norm = NORM(Posterior);
end

function A = NORM(A)
    % Normalisation of probability matrix (column elements sum to 1)
    %----------------------------------------------------------------------
    % The function goes column by column and it normalise such that 
    % elements of each colums sum to 1

    for i = 1:size(A,2)     
        for j = 1:size(A,3)
            for k = 1:size(A,4)
                for l = 1:size(A,5)
                    S = sum(A(:,i,j,k,l),1);
                    if S > 0
                        A(:,i,j,k,l) = A(:,i,j,k,l)/S;
                    else
                        A(:,i,j,k,l) = 1/size(A,1);
                    end
                end
            end
        end
    end
end