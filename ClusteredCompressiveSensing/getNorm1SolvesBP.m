function [norm1_solves, history] = getNorm1SolvesBP(measurement_data, sensing_data, rho, alpha)
%GETNORM1SOLVES_BP This function is used to resolve a norm 1 solution
%using BP algorithm.
%   norm1_solves: the norm1 solves
%   history: history is a structure that contains the objective value, the primal and
%            dual residual norms, and the tolerances for the primal and dual residual
%            norms at each iteration.
%   measurement_data: measurement data
%   sensing_data: sensing data
%   rho: the augmented Lagrangian parameter.
%   alpha: the over-relaxation parameter (typical values for alpha are
%          between 1.0 and 1.8).

t_start = tic;
QUIET    = 0;
MAX_ITER = 1000;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

[m n] = size(measurement_data);
solved_columns_count = size(sensing_data, 2);

norm1_solves = zeros(n, solved_columns_count);
z = zeros(n, solved_columns_count);
u = zeros(n, solved_columns_count);

% precompute static variables for x-update (projection on to Ax=b)
AAt = measurement_data * measurement_data';
P = eye(n) - measurement_data' * (AAt \ measurement_data);
q = measurement_data' * (AAt \ sensing_data);

for k = 1:MAX_ITER
    % x-update
    norm1_solves = P*(z - u) + q;

    % z-update with relaxation
    zold = z;
    x_hat = alpha*norm1_solves + (1 - alpha)*zold;
    z = shrinkage(x_hat + u, 1/rho);

    u = u + (x_hat - z);

    % diagnostics, reporting, termination checks
    history.objval(k)  = (objective(norm1_solves));

    history.r_norm(k)  = (norm(norm1_solves - z));
    history.s_norm(k)  = (norm(-rho*(z - zold)));

    history.eps_pri(k) = (sqrt(n)*ABSTOL + RELTOL*max(norm(norm1_solves), norm(-z)));
    history.eps_dual(k)= (sqrt(n)*ABSTOL + RELTOL*norm(rho*u));

    if ~QUIET
        fprintf('%3d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%10.2f\n', k, ...
            history.r_norm(k), history.eps_pri(k), ...
            history.s_norm(k), history.eps_dual(k), history.objval(k));
    end

    if (history.r_norm(k) < history.eps_pri(k) && ...
       history.s_norm(k) < history.eps_dual(k))
         break;
    end
end

if ~QUIET
    toc(t_start);
end
end

function obj = objective(x)
    x_vector_rows_count = size(x, 1);
    x_vector = [];
    for j = 1 : x_vector_rows_count
        x_vector = [x_vector; norm(x(j, :))];
    end
    obj = norm(x_vector,1);
end

function y = shrinkage(a, kappa)
    y = max(0, real(a - kappa)) - max(0, real(-a - kappa));
%     y = max(0, (a - kappa)'*(a - kappa)) - max(0, (-a - kappa)'*(-a - kappa));
end