function [expDes]=designConfig(const)

expDes.timeCalibMin = 7;
expDes.timeCalib = expDes.timeCalibMin * 60;

if const.task == 1
    expDes.num_target_locations = const.num_locations*2;
    expDes.num_trials_per_loc = 45;
    expDes.num_trials  = expDes.num_trials_per_loc * expDes.num_target_locations;
    temp = reshape(repmat(1:expDes.num_target_locations, expDes.num_trials_per_loc,1), expDes.num_trials, []);
    expDes.target_for_staircase = temp(randperm(length(temp)));
    expDes.tilt_direction = [ones(1,expDes.num_trials/2), -1*ones(1,expDes.num_trials/2)];
    expDes.tilt_direction = expDes.tilt_direction(randperm(length(expDes.tilt_direction)));
    
    trialMat = zeros(expDes.num_trials, 3);
    trialMat(:,1) = 1:expDes.num_trials;
    trialMat(:,2) = expDes.target_for_staircase; % cue
    trialMat(:,3) = expDes.tilt_direction; %target
    
    expDes.expMat = trialMat;
    
    % Saving procedure :
    save([const.subj_output_dir, '/', const.titration_design_fileMat],'expDes');
    
elseif const.task == 2
    if const.fromBlock == 1
        expDes.num_target_locations = const.num_locations;
        expDes.num_distractors = expDes.num_target_locations - 1;
        expDes.num_cued_trials_per_loc = 420;
        expDes.num_baseline_trials_per_loc = expDes.num_cued_trials_per_loc/2;

        expDes.num_trials  = (expDes.num_baseline_trials_per_loc+expDes.num_cued_trials_per_loc) * expDes.num_target_locations;
        expDes.cue_validity = 0.5;
        expDes.num_valid_trials_per_loc = expDes.cue_validity * expDes.num_cued_trials_per_loc;
        expDes.num_invalid_trials_per_loc = expDes.num_cued_trials_per_loc - expDes.num_valid_trials_per_loc;
        expDes.cue_info = zeros(expDes.num_cued_trials_per_loc, expDes.num_target_locations);
        for target_id = 1:const.num_locations
            distractors = setdiff(1:const.num_locations, target_id);
            distractors_vec = reshape(repmat(distractors, expDes.num_invalid_trials_per_loc/expDes.num_distractors,1), expDes.num_invalid_trials_per_loc, []);
            expDes.cue_info(:, target_id) = target_id * (ones(expDes.num_valid_trials_per_loc+expDes.num_invalid_trials_per_loc ,1));
            temp = [target_id * ones(expDes.num_valid_trials_per_loc,1);distractors_vec ];
            expDes.target_pairing(:, target_id) = temp(randperm(length(temp)));
        end
        temp_base_vec = repmat(1:expDes.num_target_locations, expDes.num_baseline_trials_per_loc,1);
        temp_base_vec = reshape(temp_base_vec, [expDes.num_baseline_trials_per_loc*expDes.num_target_locations,1]);
        expDes.baseline_targets = temp_base_vec(randperm(length(temp_base_vec)));
        expDes.baseline_cue = zeros(expDes.num_baseline_trials_per_loc*expDes.num_target_locations, 1);
        expDes.cue_target_pairing_in_cued  = [reshape(expDes.cue_info, size(expDes.cue_info, 1)*size( expDes.cue_info, 2),[]),...
            reshape(expDes.target_pairing, size( expDes.target_pairing, 1)*size( expDes.target_pairing, 2),[])];
        expDes.cue_target_pairing = [[expDes.baseline_cue ,expDes.baseline_targets];  expDes.cue_target_pairing_in_cued];
        expDes.cue_target_pairing = expDes.cue_target_pairing(randperm(size(expDes.cue_target_pairing, 1)), :);
        expDes.num_blocks = 4;
        expDes.num_trials_per_block = expDes.num_trials/expDes.num_blocks;
        expDes.num_blocks_vec = reshape(repelem(1:expDes.num_blocks,expDes.num_trials_per_block,1), expDes.num_trials, []);
        expDes.tilt_direction = [ones(1,expDes.num_trials/2), -1*ones(1,expDes.num_trials/2)];
        expDes.tilt_direction = expDes.tilt_direction(randperm(length(expDes.tilt_direction)));
        
        trialMat = zeros(expDes.num_trials, 4);
        trialMat(:,1) = expDes.num_blocks_vec;
        trialMat(:,2) = 1:expDes.num_trials;
        trialMat(:,3) = expDes.cue_target_pairing(:,1); % cue
        trialMat(:,4) = expDes.cue_target_pairing(:,2); %target
        trialMat(:,5) = expDes.tilt_direction; %target
        
        expDes.expMat = trialMat;
        
        % Saving procedure :
        save(fullfile(const.output_dir, sprintf('%s', const.sjct), 'design_matrix'),'expDes');
        fprintf('>> Design file is saved for the participant. Make sure the same file is fetched for different blocks. \n');
    else
        %load the experimental design matrix
        load(fullfile(const.output_dir, sprintf('%s', const.sjct), 'design_matrix', sprintf('%s_exoSpread_design.mat', const.sjct)))
        fprintf('>> Existed design file is loaded for this participant. \n');
        
    end
end