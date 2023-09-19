close all

path2project = '/Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Ekin/exoSpread';
addpath(genpath(path2project));

location_title = {'rhm_2', 'rhm_4','rhm_6', 'uvm_2', 'uvm_4','uvm_6'...
    'lhm_2', 'lhm_4','lhm_6', 'lvm_2','lvm_4', 'lvm_6'};
same_eccen_indices = [1, 4, 7, 10; 2, 5, 8, 11; 3, 6, 9, 12];
same_angle_indices = [1, 2, 3;4, 5, 6;7, 8, 9; 10, 11, 12];

subject_id = 'ET';

load(fullfile(path2project, 'Data', sprintf('/%s/titration_block/%s_exoSpread_Output.mat', subject_id, subject_id)))

loc_thresh= zeros(length(location_title), 1);
cmap =  [0,0,0;
    223,101,176;...
    0,109,44]/255;
figure;
for loc = 1:length(location_title)
    loc_thresh(loc, 1) = output.staircase.data(loc).mean;
    if sum(loc == same_eccen_indices(1,:))
        cmap_e = cmap(1, :);
    elseif sum(loc == same_eccen_indices(2,:))
        cmap_e = cmap(2, :);
    elseif sum(loc == same_eccen_indices(3,:))
        cmap_e = cmap(3, :);
    end

    if sum(loc == same_angle_indices(1,:))
        l_type = '-';
    elseif sum(loc == same_angle_indices(2,:))
        l_type = '--';
    elseif sum(loc == same_angle_indices(3,:))
        l_type = ':';
    elseif sum(loc == same_angle_indices(4,:))
        l_type = '-.';
    end
    plot(output.staircase.data(loc).xStaircase, 'color', cmap_e, 'LineWidth',2,...
        'linestyle', l_type)
    hold on
end
legend(location_title)

figure;
bar(loc_thresh)
set(gca, 'Xticklabel', location_title)
ylabel('Threshold (tilt in deg)')
set(gcf, 'color','w')
set(gca,'fontsize', 18)
box off
