function [] = plot_lane_exchange()

    load('lane_exchange_data.mat');
    
    % Example data (replace x1, y1, x2, y2 with your actual data)
    n = length(x1);  % assuming x1, y1, x2, y2 are of the same length

    % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    % 
    trajectory_data = readmatrix('LQ_game_fbne.csv');

    x1_ne = trajectory_data(:, 1);
    y1_ne = trajectory_data(:, 2);

    x2_ne = trajectory_data(:, 5);
    y2_ne = trajectory_data(:, 6);

    % Example data (replace x1, y1, x2, y2 with your actual data)
    n_ne = length(x1_ne);  % assuming x1, y1, x2, y2 are of the same length

    % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    alpha_values_ne = linspace(0.1, 1, n_ne); 
    
    % Create figure
    figure;

    trajectory_data_se = readmatrix('LQ_game_fbst.csv');

    x1_se = trajectory_data_se(:, 1);
    y1_se = trajectory_data_se(:, 2);

    x2_se = trajectory_data_se(:, 5);
    y2_se = trajectory_data_se(:, 6);

    % Example data (replace x1, y1, x2, y2 with your actual data)
    n_se = length(x1_se);  % assuming x1, y1, x2, y2 are of the same length

    % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    alpha_values_se = linspace(0.1, 1, n_se); 

   
    
    % Plot Player 1
    scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'magenta', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A, Interleaved');
    
    hold on;
    
   
    % Plot Player 2s
    scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B, Interleaved');


    scatter(x1_ne, y1_ne, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_ne, 'DisplayName', 'Player A, FNE');
    
    scatter(x2_ne, y2_ne, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_ne, 'DisplayName', 'Player B, FNE');



    scatter(x1_se, y1_se, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_se, 'DisplayName', 'Player A, FSE');
    
    scatter(x2_se, y2_se, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_se, 'DisplayName', 'Player B, FSE');
    
    % Add labels and title
    xlabel('x position', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('y position', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Improve the legend
    legend('Location', 'best', 'FontSize', 11);
    
    % Grid, axis limits, and visual adjustments
    grid off;
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');  % Enhance axis font size and weight

    % Add minor grid for better readability
    grid minor;
    
    % Show figure
    hold off;


end

