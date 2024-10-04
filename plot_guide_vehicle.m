function [] = plot_guide_vehicle()

    load('guide_vehicle_data.mat');
    
    % Example data (replace x1, y1, x2, y2 with your actual data)
    n = length(x1);  % assuming x1, y1, x2, y2 are of the same length

    % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    
    % Create figure
    figure;
    
    % Plot Player 1
    scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A');
    
    hold on;
    
    % Plot Player 2s
    scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B');
    
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


    % figure;
    % 
    % trajectory_data = readmatrix('new_FBST_lane_changing_2_x.csv');
    % 
    % x1 = trajectory_data(:, 1);
    % y1 = trajectory_data(:, 2);
    % 
    % x2 = trajectory_data(:, 5);
    % y2 = trajectory_data(:, 6);
    % 
    % 
    % % Example data (replace x1, y1, x2, y2 with your actual data)
    % n = length(x1);  % assuming x1, y1, x2, y2 are of the same length
    % 
    % % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    % alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    % 
    % 
    % % Plot Player 1
    % scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A');
    % 
    % hold on;
    % 
    % % Plot Player 2s
    % scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B');
    % 
    % % Add labels and title
    % xlabel('x position', 'FontSize', 12, 'FontWeight', 'bold');
    % ylabel('y position', 'FontSize', 12, 'FontWeight', 'bold');
    % 
    % % Improve the legend
    % legend('Location', 'best', 'FontSize', 11);
    % 
    % % Grid, axis limits, and visual adjustments
    % grid off;
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold');  % Enhance axis font size and weight
    % 
    % % Add minor grid for better readability
    % grid minor;
    % 
    % % Show figure
    % hold off;
    % 
    %     figure;
    % 
    % trajectory_data = readmatrix('new_FBST_lane_changing_1_x.csv');
    % 
    % x1 = trajectory_data(:, 1);
    % y1 = trajectory_data(:, 2);
    % 
    % x2 = trajectory_data(:, 5);
    % y2 = trajectory_data(:, 6);
    % 
    % 
    % % Example data (replace x1, y1, x2, y2 with your actual data)
    % n = length(x1);  % assuming x1, y1, x2, y2 are of the same length
    % 
    % % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    % alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    % 
    % 
    % % Plot Player 1
    % scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A');
    % 
    % hold on;
    % 
    % % Plot Player 2s
    % scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B');
    % 
    % % Add labels and title
    % xlabel('x position', 'FontSize', 12, 'FontWeight', 'bold');
    % ylabel('y position', 'FontSize', 12, 'FontWeight', 'bold');
    % 
    % % Improve the legend
    % legend('Location', 'best', 'FontSize', 11);
    % 
    % % Grid, axis limits, and visual adjustments
    % grid off;
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold');  % Enhance axis font size and weight
    % 
    % % Add minor grid for better readability
    % grid minor;
    % 
    % % Show figure
    % hold off;
    % 
    % figure;
    % 
    % trajectory_data = readmatrix('payer1_cost_x2_minus_0.2_new_FBST_lane_changing_1_x.csv');
    % 
    % x1 = trajectory_data(:, 1);
    % y1 = trajectory_data(:, 2);
    % 
    % x2 = trajectory_data(:, 5);
    % y2 = trajectory_data(:, 6);
    % 
    % 
    % % Example data (replace x1, y1, x2, y2 with your actual data)
    % n = length(x1);  % assuming x1, y1, x2, y2 are of the same length
    % 
    % % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    % alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    % 
    % 
    % % Plot Player 1
    % scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A');
    % 
    % hold on;
    % 
    % % Plot Player 2s
    % scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B');
    % 
    % % Add labels and title
    % xlabel('x position', 'FontSize', 12, 'FontWeight', 'bold');
    % ylabel('y position', 'FontSize', 12, 'FontWeight', 'bold');
    % 
    % % Improve the legend
    % legend('Location', 'best', 'FontSize', 11);
    % 
    % % Grid, axis limits, and visual adjustments
    % grid off;
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold');  % Enhance axis font size and weight
    % 
    % % Add minor grid for better readability
    % grid minor;
    % 
    % % Show figure
    % hold off;
    % 
    %     figure;
    % 
    % trajectory_data = readmatrix('payer1_cost_x2_minus_0.2_new_FBST_lane_changing_2_x.csv');
    % 
    % x1 = trajectory_data(:, 1);
    % y1 = trajectory_data(:, 2);
    % 
    % x2 = trajectory_data(:, 5);
    % y2 = trajectory_data(:, 6);
    % 
    % 
    % % Example data (replace x1, y1, x2, y2 with your actual data)
    % n = length(x1);  % assuming x1, y1, x2, y2 are of the same length
    % 
    % % Create alpha values for the transparency gradation (starts transparent and becomes solid)
    % alpha_values = linspace(0.1, 1, n);  % Gradation from 0.1 (transparent) to 1 (solid)
    % 
    % 
    % % Plot Player 1
    % scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player A');
    % 
    % hold on;
    % 
    % % Plot Player 2s
    % scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values, 'DisplayName', 'Player B');
    % 
    % % Add labels and title
    % xlabel('x position', 'FontSize', 12, 'FontWeight', 'bold');
    % ylabel('y position', 'FontSize', 12, 'FontWeight', 'bold');
    % 
    % % Improve the legend
    % legend('Location', 'best', 'FontSize', 11);
    % 
    % % Grid, axis limits, and visual adjustments
    % grid off;
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold');  % Enhance axis font size and weight
    % 
    % % Add minor grid for better readability
    % grid minor;
    % 
    % % Show figure
    % hold off;



end

