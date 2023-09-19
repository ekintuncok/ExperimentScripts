close all
% simulate results for exo spread experiment:

attentional_spread_type = 'polar_angle_differs';
cue_locations = [-10, 0; 10, 0; 0, 10; 0, -10;...
    -6, 0; 6, 0; 0, 6; 0, -6;...
    -2, 0; 2, 0; 0, 2; 0, -2];

target_locations = [-10, 0; 10, 0; 0, 10; 0, -10;...
    -6, 0; 6, 0; 0, 6; 0, -6;...
    -2, 0; 2, 0; 0, 2; 0, -2];

cue_locations(cue_locations(:,1) == 0 & cue_locations(:,2) < 0, 3) = 1; % lower vertical meridian
cue_locations(cue_locations(:,1) == 0 & cue_locations(:,2) > 0, 3) = 2; % upper vertical meridian
cue_locations(cue_locations(:,2) == 0 & cue_locations(:,1) < 0, 3) = 3; % left horizontal meridian
cue_locations(cue_locations(:,2) == 0 & cue_locations(:,1) > 0, 3) = 4; % right horizontal meridian

target_locations(target_locations(:,1) == 0 & target_locations(:,2) < 0, 3) = 1;
target_locations(target_locations(:,1) == 0 & target_locations(:,2) > 0, 3) = 2;
target_locations(target_locations(:,2) == 0 & target_locations(:,1) < 0, 3) = 3;
target_locations(target_locations(:,2) == 0 & target_locations(:,1) > 0, 3) = 4;

% calculate the distance between each cue and target pair:

distance_from_cue = zeros(length(cue_locations), length(target_locations));
meridional_correspondence = zeros(length(cue_locations), length(target_locations));
for cue_id = 1:size(cue_locations, 1)
    for target_id = 1:size(target_locations, 1)
        cue_meridian = cue_locations(cue_id, 3);
        target_meridian = target_locations(target_id, 3);
        distance_from_cue(cue_id, target_id) = sqrt((cue_locations(cue_id, 1) - target_locations(target_id, 1)).^2 + ...
            (cue_locations(cue_id, 2) - target_locations(target_id, 2)).^2);
        meridional_correspondence(cue_id, target_id) = cue_meridian - target_meridian;
    end
end

% create the spatial grid to define the attentional spread over:
degree_vals = -15:0.1:15;
[X, Y] = meshgrid(degree_vals);
Y = -1 * Y;
y_vec = reshape(Y, size(Y, 1) * size(Y, 2), []);
x_vec = reshape(X, size(X, 1) * size(X, 2), []);
cart_locations = [x_vec, y_vec];

attentional_response = zeros(length(cue_locations), length(target_locations));

for cue = 1:length(cue_locations)

    center_x = cue_locations(cue,1);
    center_y = cue_locations(cue,2);
    meridian = cue_locations(cue,3);
    cue_eccen = sqrt(center_x.^2 + center_y.^2);

    switch attentional_spread_type
        case 'equal_spread'
            sigma = 2;
        case 'eccentricity_differs'
            sigma = cue_eccen * 1.5;
        case 'polar_angle_differs'
            if meridian == 1 %LVM
                sigma = cue_eccen * 0.5;
            elseif meridian == 2 %UVM
                sigma = cue_eccen * 1.5;
            elseif meridian == 3 % LHM
                sigma = cue_eccen * 1.4;
            elseif meridian == 4 % RHM
                sigma = cue_eccen * 1.8;
            end
    end
    % Attentional spread centered at the cue location, as a 2dimensional
    % Gaussian

    attention_field = exp(-((X-center_x).^2+ (Y - center_y).^2)./ (2 * sigma.^2));

    if cue == 1 || cue == 5 || cue == 9
        figure; imagesc(attention_field); axis equal; box off; set(gcf,'color','w', 'Position', [0,0,300,300]);
    end
    attention_field_temp = reshape(attention_field, size(attention_field, 1) * size(attention_field,2), []);
    exo_att_field = attention_field_temp;

    for target = 1:length(target_locations)
        curr_target_position = target_locations(target, 1:2);
        attentional_response(cue, target) = exo_att_field(dsearchn(cart_locations, curr_target_position));
    end
end


%% Visualize
cmap =  [0,0,0;
    223,101,176;...
    0,109,44]/255;

same_ecc_indices = [1, 2, 3, 4;...
    5, 6, 7, 8;...
    9, 10, 11, 12];
titles = {'10deg', '6deg','2deg'};

% average the results based on eccentricity:
figure;
for eccen = 1:size(same_ecc_indices,1)
    plot(mean(sort(distance_from_cue(same_ecc_indices(eccen,:),:)', 'ascend'),2),...
        mean(sort(attentional_response(same_ecc_indices(eccen,:),:)', 'descend'),2), '-o', 'color',cmap(eccen,:), 'LineWidth',2)
    hold on
    box off
    set(gca,'fontsize', 20)
    ylim([0, 1])
end
ylabel('Sensitivity benefit (au)')
xlabel('Cue-target distance (deg)')
legend(titles)
set(gcf,'color','w')
set(gcf,'position',[0,0,300,300])


titles = {'LHM','RHM','UVM','LVM'};
figure;
for polar_ang = 1:4
    subplot(4,1,polar_ang)
    pp = plot(sort(distance_from_cue(polar_ang:4:end,:)', 'ascend'),...
        sort(attentional_response(polar_ang:4:end,:)', 'descend'), '-o', 'LineWidth',2);
    for ii = 1:length(pp)
        pp(ii).Color = cmap(ii,:);
    end
    box off
    set(gca,'fontsize', 20)
    title(titles{polar_ang})
    if polar_ang == 1
        ylabel('Sensitivity benefit (au)')
        xlabel('Cue-target distance (deg)')
    end
end
set(gcf,'color','w')
set(gcf,'position',[0,0,300,600])
