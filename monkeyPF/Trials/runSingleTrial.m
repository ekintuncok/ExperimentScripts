function [resMat, xUpdate_tilt, stairIndex, stairsUpdated]=runSingleTrial(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% [resMat] = runSingleTrial(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Main file of the experiment. Draw each sequence and return results.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design configurations.
% my_key : keyboard keys names.
% t : experiment meter.
% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
while KbCheck; end
FlushEvents('KeyDown');
target = expDes.expMat(t,3);
motion_dir = expDes.expMat(t,4);

if target <= 8
    Xposition = const.xDist(1,:);
    Yposition = const.yDist(1,:);
    angle = expDes.angle(1:8,t)';

elseif target > 8 && target <= 16
    Xposition = const.xDist(2,:);
    Yposition = const.yDist(2,:);
    angle = expDes.angle(9:16,t)';

elseif  target > 16 && target <= 24
    Xposition = const.xDist(3,:);
    Yposition = const.yDist(3,:);
    angle = expDes.angle(17:end,t)';

end

if ismember(0, angle)
    target_motion_dir = 1;
else
    target_motion_dir = -1;
end

if mod(target, const.num_locations) ~= 0
    single_targ_id = mod(target, const.num_locations);
else
    single_targ_id = 8;
end
% Main loop

stopThisTrial = 0; % For fixation calibration (NOT implemented yet)
fixation = 1; % for both eyetracking and no eyetracking

for tframes = 1:const.numFrm_Tot
    
    % Eytracker: Fixtion check
    if const.eyeMvt
         [xEye,yEye] = getCoord(scr,const); % eye coordinates
        if sqrt((xEye-scr.x_mid)^2+(yEye-scr.y_mid)^2) > scr.rad
            Eyelink('message','EVENT_FIXBREAK_START');
            stopThisTrial = 1;
            fixation = 0;
            break; 
        end
    end
        
    if tframes >= const.numFrm_T1_start && tframes <= const.numFrm_T1_end
        my_fixationCross(scr,const);
    elseif tframes >= const.numFrm_T2_start && tframes <= const.numFrm_T2_end
        my_fixationCross(scr,const);
    elseif tframes >= const.numFrm_T3_start && tframes <= const.numFrm_T3_end
        my_fixationCross(scr,const);
    elseif tframes == const.numFrm_T4_start
        complete = my_Gabor(scr, Xposition, Yposition, const, angle, fixation);
        if (const.eyeMvt) && (complete == 0)
            fixation = 0;
            DrawFormattedText(scr.main, sprintf('Please fixate'), 'center', 'center')
            Screen('Flip', scr.main); WaitSecs(1)
            stopThisTrial = 1;
            tframes = const.numFrm_Tot; % trying this?
        elseif complete == 1
            tframes = const.numFrm_Tot; % added
            break;
        end
    end

    my_fixationCross(scr,const);

    % Flip to the screen
    vbl = Screen('Flip', scr.main);

    if const.eyeMvt
        if tframes == const.numFrm_T1_start; Eyelink('message','T1'); end
        if tframes == const.numFrm_T2_start; Eyelink('message','T2'); end
        if tframes == const.numFrm_T3_start; Eyelink('message','T3'); end
        if tframes == const.numFrm_T4_start; Eyelink('message','T4'); end
        if tframes == const.numFrm_T5_start; Eyelink('message','T5'); end
    end
end

if ~stopThisTrial
    [key_press,tRT]= getAnswer(scr,const,my_key);
end

if fixation == 1
    if tRT == 1.5
        stopThisTrial = 1;
    else
        tRT = tRT - vbl;
    end
else
    tRT = 99;
    key_press.left = 0;
    key_press.right = 0;
    key_press.space = 0;
    key_press.escape = 0;
    answer = 99;
end

if stopThisTrial == 1 && tRT == 1.5
    trial_code = -2;% lost fixation (broken trial)
    disp('Late response...')
    answer = 99;
    tRT = 2;
    xUpdate_tilt = NaN;
    colorMatrixFeedback = const.lateAnswer;
    stairIndex = [];
    stairsUpdated = [];
elseif stopThisTrial == 1 && fixation == 0
    trial_code = -2;% lost fixation (broken trial)
    disp('Fixation lost...')
    answer = 99;
    tRT = NaN;
    xUpdate_tilt = NaN;
    colorMatrixFeedback = const.missedFixation;
    stairIndex = [];
    stairsUpdated = [];
else
    if key_press.right == 1
        trial_code = 2;
        if target_motion_dir == 1
            colorMatrixFeedback = const.incorrAns;
            answer = 0;
        else
            colorMatrixFeedback = const.corrAns;
            answer = 1;
        end
    elseif key_press.left == 1
        trial_code = 2;
        if target_motion_dir == 1
            colorMatrixFeedback = const.corrAns;
            answer = 1;
        else
            colorMatrixFeedback = const.incorrAns;
            answer = 0;
        end
    elseif key_press.escape == 1 || key_press.space == 1
        trial_code = -1;
        answer = 99;
    end
end

resMat = [target, Xposition(single_targ_id), Yposition(single_targ_id), motion_dir, target_motion_dir, key_press.left, key_press.right, tRT, answer,trial_code];
% Feedback display
my_feedback(scr,const,colorMatrixFeedback);
Screen('Flip', scr.main); WaitSecs(0.3);
% overDone
end