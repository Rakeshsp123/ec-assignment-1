function process_gap_files()
    total_files = 12;
    aggregated_results = cell(total_files, 1);

    % Iterate over all gap files
    for file_index = 1:total_files
        file_name = sprintf('gap%d.txt', file_index);
        file_id = fopen(file_name, 'r');
        if file_id == -1
            error('Error opening file: %s', file_name);
        end

        % Read the number of problem instances
        problem_count = fscanf(file_id, '%d', 1);
        file_results = cell(problem_count, 1);

        for prob_idx = 1:problem_count
            % Read problem specifications
            server_count = fscanf(file_id, '%d', 1);
            user_count = fscanf(file_id, '%d', 1);

            % Read cost and resource matrices
            cost_matrix = fscanf(file_id, '%d', [user_count, server_count])';
            resource_matrix = fscanf(file_id, '%d', [user_count, server_count])';

            % Read server capacities
            capacity_vector = fscanf(file_id, '%d', [server_count, 1]);

            % Solve the optimization problem
            allocation_matrix = optimize_gap(server_count, user_count, cost_matrix, resource_matrix, capacity_vector);
            optimal_value = sum(sum(cost_matrix .* allocation_matrix));

            % Store formatted output
            file_results{prob_idx} = sprintf('s%d-u%d-%d', server_count, user_count, round(optimal_value));
        end

        % Close file
        fclose(file_id);
        aggregated_results{file_index} = file_results;
    end

    % Display results side by side
    display_results(aggregated_results, total_files);
end

function allocation_matrix = optimize_gap(s_count, u_count, cost_mat, res_mat, cap_vec)
    objective_func = -cost_mat(:);

    % Constraint 1: Each user assigned exactly once
    user_assignment = kron(eye(u_count), ones(1, s_count));
    user_constraints = ones(u_count, 1);

    % Constraint 2: Server resource constraints
    server_constraints = zeros(s_count, s_count * u_count);
    for srv = 1:s_count
        for usr = 1:u_count
            server_constraints(srv, (usr-1)*s_count + srv) = res_mat(srv, usr);
        end
    end
    server_limits = cap_vec;

    % Variable bounds (binary decision variables)
    lower_bounds = zeros(s_count * u_count, 1);
    upper_bounds = ones(s_count * u_count, 1);
    int_vars = 1:(s_count * u_count);

    % Solve using integer linear programming
    solver_options = optimoptions('intlinprog', 'Display', 'off');
    allocation_vector = intlinprog(objective_func, int_vars, server_constraints, server_limits, user_assignment, user_constraints, lower_bounds, upper_bounds, solver_options);

    % Reshape result into allocation matrix
    allocation_matrix = reshape(allocation_vector, [s_count, u_count]);
end

function display_results(results, file_count)
    files_per_row = 4;
    for start_idx = 1:files_per_row:file_count
        end_idx = min(start_idx + files_per_row - 1, file_count);

        % Print headers
        for f = start_idx:end_idx
            fprintf('gap%d		', f);
        end
        fprintf('\n');

        % Determine max problems in this row
        max_problems = max(cellfun(@length, results(start_idx:end_idx)));

        % Print data row-wise
        for p = 1:max_problems
            for f = start_idx:end_idx
                if p <= length(results{f})
                    fprintf('%s\t', results{f}{p});
                else
                    fprintf('\t\t');
                end
            end
            fprintf('\n');
        end

        fprintf('\n');
    end
end

% Run the function
process_gap_files();