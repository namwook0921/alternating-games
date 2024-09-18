function [] = plot_subgame_perfect()

    load('subgame_perfect_data.mat');

    % Gradation for Player A (concatenate alpha values)
    n1 = length(x1);  % Length for Player A initial (x1)
    n3 = length(x3);  % Length for Player A subgame (x3)
    alpha_values_A1 = linspace(0.6, 0.8, n1);  % Gradation from 0.1 to 1 for Player A initial (x1)
    alpha_values_A3 = linspace(0.8, 1, n3);  % Gradation from 0.1 to 1 for Player A subgame (x3)

    % Gradation for Player B (concatenate alpha values)
    n2 = length(x2);  % Length for Player B initial (x2)
    n4 = length(x4);  % Length for Player B subgame (x4)
    alpha_values_B2 = linspace(0.6, 0.8, n2);  % Gradation from 0.1 to 1 for Player B initial (x2)
    alpha_values_B4 = linspace(0.8, 1, n4);  % Gradation from 0.1 to 1 for Player B subgame (x4)

    % Create figure
    figure;
    
    % Plot Player A initial (x1, red color)
    scatter(x1, y1, 70, 's', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_A1, 'DisplayName', 'Player A initial');
    
    hold on;
    
    % Plot Player B initial (x2, blue color)
    scatter(x2, y2, 70, 's', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_B2, 'DisplayName', 'Player B initial');
    
    % Plot Player A subgame (x3, magenta color)
    scatter(x3, y3, 70, 's', 'MarkerFaceColor', 'magenta', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_A3, 'DisplayName', 'Player A subgame');
    
    % Plot Player B subgame (x4, cyan color)
    scatter(x4, y4, 70, 's', 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 'flat', 'AlphaData', alpha_values_B4, 'DisplayName', 'Player B subgame');
    
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
