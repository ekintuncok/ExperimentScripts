function [expDes]=designConfig(const)

expDes.timeCalibMin = 7;
expDes.timeCalib = expDes.timeCalibMin * 60;

if const.task == 1
    expDes.num_target_locations = 12;
    expDes.num_trials_per_loc = 50;
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
        expDes.num_target_locations = 12;
        expDes.num_distractors = 11;
        expDes.num_target_trials_per_loc = 550;

        expDes.num_trials  = expDes.num_target_trials_per_loc * expDes.num_target_locations;
        expDes.cue_validity = 0.5;
        expDes.num_valid_trials_per_loc = expDes.cue_validity * expDes.num_target_trials_per_loc;
        expDes.num_invalid_trials_per_loc = expDes.num_target_trials_per_loc - expDes.num_valid_trials_per_loc;

        for target_id = 1:const.num_locations
            distractors = setdiff(1:const.num_locations, target_id);
            distractors_vec = reshape(repmat(distractors, expDes.num_invalid_trials_per_loc/expDes.num_distractors,1), expDes.num_invalid_trials_per_loc, []);
            expDes.cue_info(:, target_id) = target_id * (ones(expDes.num_valid_trials_per_loc+expDes.num_invalid_trials_per_loc,1));
            temp = [target_id * ones(expDes.num_valid_trials_per_loc,1);distractors_vec ];
            expDes.target_pairing(:, target_id) = temp(randperm(length(temp)));
        end

        expDes.cue_target_pairing  = [reshape(expDes.cue_info, size( expDes.cue_info, 1)*size( expDes.cue_info, 2),[]),...
            reshape(expDes.target_pairing, size( expDes.target_pairing, 1)*size( expDes.target_pairing, 2),[])];
        expDes.cue_target_pairing = expDes.cue_target_pairing(randperm(size(expDes.cue_target_pairing, 1)), :);
        expDes.num_blocks = 8;
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
        save([const.subj_output_dir, '/', const.design_fileMat],'expDes');
    else
        %load the experimental design matrix
        load([const.subj_output_dir, '/', const.design_fileMat], 'expDes')
    end
end