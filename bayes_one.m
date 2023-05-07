clear

A = [0.2 0.9; 0.8 0.1]
D = [0.7; 0.3]

Joint = zeros(2,2)
for s = 1:2
    for o = 1:2
        Joint(o,s) = D(s) * A(o, s)
    end
end

Po = zeros(2)
Po = sum(Joint,2)

Ps_o = zeros(2,2)
for o=1:2
    for s= 1:2
            Ps_o(s,o) = Joint(o,s) / Po(o)
    end
end


% Functions
function Posterior_norm = Bayes(Likelihood, Prior, Observation)
    Posterior = Prior .* (Likelihood' * Observation)
    Posterior_norm = NORM(Posterior)
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