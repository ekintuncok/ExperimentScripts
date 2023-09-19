function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=expDesConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute an experimental randomised matrix containing all variable data
% used in the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all variable data randomised.
% ----------------------------------------------------------------------

% Experimental variables
expDes.num_target_trials_per_loc = 2;
expDes.num_target_locations = 24;
expDes.num_trials  = expDes.num_target_trials_per_loc * expDes.num_target_locations;
expDes.num_distractor_trials_per_loc = expDes.num_trials - expDes.num_target_trials_per_loc;

% we have 8 locations, one of which is the taarget location on a given
% trials. Randomly assign this information:
temp_target_vec = repelem(1:expDes.num_target_locations, expDes.num_target_trials_per_loc);
temp_angle_per_loc = [zeros(1,expDes.num_target_trials_per_loc/2), 180*ones(1,expDes.num_target_trials_per_loc/2)];

%temp_dist_angle_per_loc = [datasample([15:30], expDes.num_distractor_trials_per_loc/2).*rand,...
%    datasample([155:170], expDes.num_distractor_trials_per_loc/2).*rand];
temp_dist_angle_per_loc = datasample([45, 135], expDes.num_distractor_trials_per_loc);

expDes.target_location = temp_target_vec(randperm(length(temp_target_vec)));
expDes.angle = zeros(expDes.num_target_locations, expDes.num_trials);

for target = 1:expDes.num_target_locations
    target_indices = expDes.target_location == target;
    distractor_indices =  target_indices == 0;
    target_dir  = temp_angle_per_loc(randperm(length(temp_angle_per_loc)));
    distractor_dir  = temp_dist_angle_per_loc(randperm(length(temp_dist_angle_per_loc)));
    expDes.angle(target, target_indices) = target_dir;
    expDes.angle(target, distractor_indices) = distractor_dir;
end

for trial = 1:length(expDes.target_location)
    crr_trg = expDes.target_location(trial);
    expDes.motion_dir(trial) = expDes.angle(crr_trg, trial);
end

%% Experimental expDes matrix maker
trialMat      = repelem(const.fromBlock, expDes.num_trials)';
trialMat(:,2) = 1:expDes.num_trials;
trialMat(:,3) = expDes.target_location;
trialMat(:,4) = expDes.motion_dir;
for t_trial = 1:expDes.num_trials
    Var1 = trialMat(t_trial,3); % mapping stim
    Var2 = trialMat(t_trial,4); % pre cue
    expDes.j = t_trial;
    expDes.expMat(expDes.j,:)= [trialMat(t_trial,1),t_trial,Var1,Var2];
end

% Saving procedure :
save([const.subj_output_dir, '/', const.design_fileMat],'expDes');
