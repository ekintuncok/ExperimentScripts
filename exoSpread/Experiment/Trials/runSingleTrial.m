function  [trial_data, staircase] =runSingleTrial(scr, const, my_key, t, curr_block_mat, staircase)
while KbCheck; end
FlushEvents('KeyDown');
if const.task == 1 % staircase!
    curr_trial_info = curr_block_mat(t, :);
    target = curr_block_mat(t, 2);
    tilt_dir = curr_trial_info(:, 3); % either 1 or -1
    exo_cue_colors = repmat(const.black, const.num_locations*4, 3)';
    for ii = 1:const.num_locations
        target_angle(ii) =   staircase.data(ii).xCurrent;
    end
    target_angle = randsample([-1,-1,-1,-1,1,1,1,1], const.num_locations).* target_angle;
    resp_cue_colors = repmat(const.white, const.num_locations*4,3)';
    if target <= 8
        resp_cue_colors(:, 4*target-3:4*target) = repmat(const.black, 3, 4);
    elseif target > 8
        target_for_staircase = mod(target, const.num_locations);
        if target_for_staircase == 0
            target_for_staircase = 8;
        end
        resp_cue_colors(:, 4*target_for_staircase-3:4*target_for_staircase) = repmat(const.black, 3, 4);
    end
    
elseif const.task == 2
    curr_trial_info = curr_block_mat(t, 1:5);
    % get the target, cue and target tilt information of the current trial:
    target = curr_trial_info(:, 4);
    cue = curr_trial_info(:, 3);
    tilt_dir = curr_trial_info(:, 5); % either 1 or -1

    if cue == 0
        exo_cue_colors = repmat(const.black, const.num_locations*4, 3)';
    else
        exo_cue_colors = repmat(const.white, const.num_locations*4,3)';
        exo_cue_colors(:, 4*cue-3:4*cue) = repmat(const.black, 3, 4);
    end
    target_angle = randsample([-1,-1,-1,-1,1,1,1,1], const.num_locations) .* const.gaborOri;

    resp_cue_colors = repmat(const.white, const.num_locations*4,3)';
    resp_cue_colors(:, 4*target-3:4*target) = repmat(const.black, 3, 4);
end

if target <= 8
    if tilt_dir == -1 && target_angle(target) > 0
        target_angle(target) = -1 * target_angle(target);
    elseif tilt_dir == 1 && target_angle(target) < 0
        target_angle(target) = -1 * target_angle(target);
    end
elseif target > 8
    if tilt_dir == -1 && target_angle(target_for_staircase) > 0
        target_angle(target_for_staircase) = -1 * target_angle(target_for_staircase);
    elseif tilt_dir == 1 && target_angle(target_for_staircase) < 0
        target_angle(target_for_staircase) = -1 * target_angle(target_for_staircase);
    end
end

stopThisTrial = 0; % For fixation calibration (NOT implemented yet)
fixation = 1; % for both eyetracking and no eyetracking

% randomize the phase to avoid collinearity:
const.phaseSteps =  1:const.num_locations; const.gabor_phases = (const.phaseSteps) * rand*2 * pi;
const.gabors = zeros(const.gaborDim_xpix, const.gaborDim_xpix, const.num_locations);
gaborTex = struct('textureHandle', {[],[],[],[],[],[],[],[],[],[],[],[]});

for phase = 1:length(const.gabor_phases)
    const.gaborCarrier 	       = sin(2 *pi *const.nx * const.gaborSF + const.gabor_phases(phase));
    const.gabors(:,:,phase)     = ((const.gaborCarrier.*const.modula).* (const.gaborContrast * const.gray) + const.gray);
    gaborTex(phase).textureHandle = Screen('MakeTexture', scr.main , (const.gabors(:,:,phase)));
end

for tframes = 1:const.numFrm_Tot

    if const.eyeMvt
        [xEye,yEye] = getCoord(scr,const); % eye coordinates
        if sqrt((xEye-scr.x_mid)^2+(yEye-scr.y_mid)^2) > scr.rad
            Eyelink('message','EVENT_FIXBREAK_START');
            stopThisTrial = 1;
            fixation = 0;
            break
        end
    end

    Screen('DrawDots', scr.main,const.placeholders_loc', const.cue_size, const.white,  scr.mid, 1);

    if tframes >= const.numFrm_T1_start && tframes <= const.numFrm_T1_end
        my_fixationCross(scr,const);
    elseif tframes >= const.numFrm_T2_start && tframes <= const.numFrm_T2_end
        my_fixationCross(scr,const);
        Screen('DrawDots', scr.main,const.placeholders_loc',const.cue_size, exo_cue_colors,  scr.mid, 1);
    elseif tframes >= const.numFrm_T3_start && tframes <= const.numFrm_T3_end
        my_fixationCross(scr,const);
    elseif tframes >= const.numFrm_T4_start && tframes <= const.numFrm_T4_end
        if const.eyeMvt
            [xEye,yEye] = getCoord(scr,const); % eye coordinates
            if sqrt((xEye-scr.x_mid)^2+(yEye-scr.y_mid)^2) > scr.rad
                Eyelink('message','EVENT_FIXBREAK_START');
                stopThisTrial = 1;
                count_fixation_breaks = count_fixation_breaks + 1;
                fixation = 0;
                break
            end
        end

        my_fixationCross(scr,const);
        Screen('DrawTextures', scr.main, [gaborTex(1).textureHandle,gaborTex(2).textureHandle,...
            gaborTex(3).textureHandle,gaborTex(4).textureHandle,...
            gaborTex(5).textureHandle,gaborTex(6).textureHandle,...
            gaborTex(7).textureHandle, gaborTex(8).textureHandle],...
            repmat(const.src_rect', 1,const.num_locations),...
            const.dest_rect, target_angle);
    elseif tframes >= const.numFrm_T5_start && tframes <= const.numFrm_T5_end
        my_fixationCross(scr,const);
    elseif tframes >= const.numFrm_T6_start && tframes <= const.numFrm_T6_end
        my_fixationCross(scr,const);
        Screen('DrawDots', scr.main,const.placeholders_loc', const.cue_size, resp_cue_colors,  scr.mid, 1);
    end
    my_fixationCross(scr,const);

    % Flip to the screen
    vbl = Screen('Flip', scr.main);

    if const.eyeMvt
        if tframes == const.numFrm_T1_start; Eyelink('message','fixation'); end
        if tframes == const.numFrm_T2_start; Eyelink('message','cue'); end
        if tframes == const.numFrm_T3_start; Eyelink('message','isi'); end
        if tframes == const.numFrm_T4_start; Eyelink('message','target'); end
        if tframes == const.numFrm_T5_start; Eyelink('message','resp_cue'); end
    end
end

if stopThisTrial ~= 1 && fixation == 1 
    [key_press,tRT]= getAnswer(scr,const,my_key);
    tRT = tRT - vbl;
else
    tRT = 99;
    key_press.left = 0;
    key_press.right = 0;
    key_press.space = 0;
    key_press.escape = 0;
    answer = 99;
end


if stopThisTrial == 1 && fixation == 0
    trial_code = 0;% lost fixation (broken trial)
    disp('Fixation lost...')
    answer = 99;
    tRT = NaN;
    updated_tilt = NaN;
    colorMatrixFeedback = const.missedFixation;
else
    if key_press.right == 1
        trial_code = 1;
        if tilt_dir == 1
            colorMatrixFeedback = const.corrAns;
            answer = 1;
        else
            colorMatrixFeedback = const.incorrAns;
            answer = 0;
        end
    elseif key_press.left == 1
        trial_code = 1;
        if tilt_dir == 1
            colorMatrixFeedback = const.incorrAns;
            answer = 0;
        else
            colorMatrixFeedback = const.corrAns;
            answer = 1;
        end
    elseif key_press.escape == 1 || key_press.space == 1
        trial_code = -1;
        answer = 99;
    end
end

if const.task == 1 && answer ~= 99
    % staircase calibration does not seem to work consistently. I haven't
    % yet figured out the best set of input parameters to have it working
    % better. So it's optional for the time being
    if const.staircase_calibration == 1 && t < 20
        answer = rand > 0.5;
    end
    staircase.data(target) = usePalamedes(staircase.data(target), answer);
    updated_tilt = staircase.data(target).xCurrent;
end

my_feedback(scr,const,colorMatrixFeedback);
Screen('DrawDots', scr.main,const.placeholders_loc', const.cue_size, const.white,  scr.mid, 1);
Screen('Flip', scr.main); WaitSecs(0.3);

if const.task == 1
    trial_data = [target, tilt_dir, updated_tilt, tRT, answer, trial_code];
else
    trial_data = [cue, target, tilt_dir, key_press.left, key_press.right, tRT, answer, trial_code];
end

end