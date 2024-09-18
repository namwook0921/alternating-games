function[] = show_color()

    color_list = {
        '#FF910A',  % Original color 1
        '#828282',  % Original color 2
        '#1C9993',  % Original color 3
        '#B4259A',  % Original color 4
        '#B02418',  % Original color 5
        '#99331C',  % New color 1 (Complementary to #1C9993)
        '#FFA50A',  % New color 2 (Analogous to #FF910A)
        '#25B49A',  % New color 3 (Triadic to #B4259A)
        '#4A90E2'   % New color 4
    };
    
    figure;
    hold on;
    
    for i = 1:length(color_list)
        plot([0 1], [i i], 'LineWidth', 8, 'Color', color_list{i});
    end
    
    set(gca, 'YDir', 'reverse', 'YTick', 1:length(color_list), 'YTickLabel', color_list);
    title('Display of Colors in color\_list');


end