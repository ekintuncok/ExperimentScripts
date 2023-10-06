function output = runTrials(scr,const,expDes,el,staircase, my_key,textExp,button)

% Gereral instructions:
if const.in_R2 == 1
    instructionsFB(scr,const,my_key,'instructions_exoSp')
end

% first mouse config
if const.eyeMvt;HideCursor;end

% first calibration
if const.eyeMvt
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'1st Calibration instruction');
    calibresult = EyelinkDoTrackerSetup(el);
    if calibresult==el.TERMINATE_KEY
        return
    end
end

% added
while KbCheck; end
FlushEvents('KeyDown');
clear KbCheck;

calibBreak = 0;
expDone = 0;
expDes.addCue = [];
expDes.addTarget = [];

if const.task == 1 && const.practiceRound == 0
    curr_block_mat = expDes.expMat;
    break_size = 5;
    full_length = length(curr_block_mat);
    trial_per_sub_block =reshape(repmat(1:break_size, length(curr_block_mat)/break_size, 1), 1, full_length)';
    block_info_column_ind = 4;
    curr_block_mat(:, block_info_column_ind) = trial_per_sub_block;
elseif const.task == 2 && const.practiceRound == 0
    % get this block's trial sequence using the inputted block number:
    curr_block_mat = expDes.expMat(expDes.expMat(:,1) == const.fromBlock, :);
    break_size = 11;
    full_length = length(curr_block_mat);
    trial_per_sub_block =reshape(repmat(1:break_size, length(curr_block_mat)/break_size, 1), 1, full_length)';
    block_info_column_ind = 6;
    curr_block_mat(:,block_info_column_ind) = trial_per_sub_block;
elseif const.practiceRound == 1
    curr_block_mat = expDes.expMat(expDes.expMat(:,1) == const.fromBlock, :);
    full_length = 40;
    curr_block_mat = curr_block_mat(1:full_length,:);
    break_size = 1;
    trial_per_sub_block =reshape(repmat(1:break_size, length(curr_block_mat)/break_size, 1), 1, full_length)';
    block_info_column_ind = 6;
    curr_block_mat(:,block_info_column_ind) = trial_per_sub_block;
end

waitSpace = 0;

if ~const.expStart && const.nbDebugTrials
    expDes.expMat = expDes.expMat(1:const.nbDebugTrials,:);
end

while ~expDone
    cumulative_trial_count = 1;
    for current_block = 1:break_size
        curr_subblock = curr_block_mat(curr_block_mat(:,block_info_column_ind) == current_block,:);
        t = 1;
        total_trials_in_this_block = length(curr_subblock);
        while t <= total_trials_in_this_block
            fprintf('current block = %i, current trial: %i\n', current_block, t);
            if current_block > 1 && t == 1
                textExp.pause{3} = sprintf('%i/%i blocks completed!', current_block-1, break_size);
                instructions(scr,const,my_key,textExp.pause,button.pause);
                waitSpace = 1;
            end
            trialDone = 0;
            while ~trialDone
                if const.eyeMvt
                    Eyelink('command', 'record_status_message ''TRIAL %d''', t);
                    Eyelink('message', 'TRIALID %d', t);
                end
                ncheck = 0;
                fix    = 0;
                record = 0;
                clear calibresult
                while fix ~= 1 || ~record
                    if const.eyeMvt
                        if ~record
                            Eyelink('startrecording');
                            key=1;
                            while key ~=  0
                                key = EyelinkGetKey(el);		% dump any pending local keys
                            end

                            error2=Eyelink('checkrecording'); 	% check recording status
                            if error2==0
                                record = 1;
                                Eyelink('message', 'RECORD_START');
                            else
                                record = 0;
                                Eyelink('message', 'RECORD_FAILURE');
                            end
                        end
                    else
                        record = 1;
                    end


                    if fix~=1 && record
                        if const.eyeMvt
                            drawTrialInfoEL(scr,const,expDes,t);  % put info on Eyelink screen
                        end
                        if const.in_R2 == 1
                            if  t == 1 || calibBreak == 1 || waitSpace == 1
                                calibBreak = 0;
                                wait_key(scr,const,my_key,t);                       %% wait_key
                            end
                        end
                        waitSpace = 0;
                        [fix]=check_fix(scr,const,my_key);                      %% check_fix
                        ncheck = ncheck + 1;
                    end

                    if fix~=1 && record
                        calibBreak = 1;
                        eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Error calibration instruction');
                        instructionsFB(scr,const,my_key,'Calibration');
                        calibresult = EyelinkDoTrackerSetup(el);
                        if calibresult==el.TERMINATE_KEY
                            return
                        end
                        record = 0;
                    end
                end

                % Trial beginning
                if const.eyeMvt
                    Eyelink('message', 'TRIAL_START %d', t);
                    Eyelink('message', 'SYNCTIME');
                end

                [trial_data, staircase] = runSingleTrial(scr, const, my_key, t, curr_subblock, staircase);

                if const.eyeMvt
                    Eyelink('message', 'TRIAL_END %d',  t);
                    Eyelink('stoprecording');
                end

                trialDone = 1;
            end

            cumulative_trial_count = cumulative_trial_count + 1;
            block_data(cumulative_trial_count,:) = trial_data;

            if trial_data(end) == -1
                total_trials_in_this_block = total_trials_in_this_block + 1;
                instructions(scr,const,my_key,textExp.pause,button.pause);
                curr_subblock(total_trials_in_this_block, :) = curr_subblock(t, :);
            elseif trial_data(end) == 0
                total_trials_in_this_block = total_trials_in_this_block + 1;
                curr_subblock(total_trials_in_this_block, :) = curr_subblock(t, :);
            end
            t = t + 1;
        end
    end
    if current_block == break_size
        expDone = 1;
    end
end

output.block_data = block_data;
output.staircase = staircase;

const.my_clock_end = clock;

if const.eyeMvt
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
    WaitSecs(1);
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'The end');
end

instructions(scr,const,my_key,textExp.end,button.end);
