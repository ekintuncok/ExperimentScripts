function [Output, StaircaseOutput] = runTrials(scr,const,expDes,el,my_key,textExp,button)
% ----------------------------------------------------------------------
% runTrials(scr,const,expDes,my_key,textExp,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function, display the trial function and save the experi-
% -mental data in different files.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design and configurations.
% el : ....
% my_key : keyborad keys names
% textExp : struct contanining all instruction text.
% button : struct containing all button text.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 01 / 2014
% Project : Yeshurun98
% Version : -
% ----------------------------------------------------------------------

%% Gereral instructions:
instructions(scr,const,my_key,textExp.instruction1,button.instruction1);
instructionsFB(scr,const,my_key,'instructionsattpRF')
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

%% Main Loop
expDone = 0;
newJ = 0;
expDes.expMatAdd = [];
expDes.angleAdd = [];
startJ = 1;
sectionsize=expDes.j/8;  % break size
initialLength = size(expDes.expMat,1);
waitSpace = 0;

if ~const.expStart && const.nbDebugTrials
    expDes.expMat = expDes.expMat(1:const.nbDebugTrials,:);
end

endJ = size(expDes.expMat,1); 
while ~expDone
    for t = startJ:endJ %size(expDes.expMat,1) %% NEW
        
        if const.practiceRound == 0
            if endJ > 20
                if ~rem(t,sectionsize) && (t~=expDes.j) % <- maybe check: expDes.j won't match the "length" of your experiment anymore if you add trials
                    instructions(scr,const,my_key,textExp.pause,button.pause);
                    waitSpace = 1;
                end
            end
        end
        
        trialDone = 0;
        
        while ~trialDone
            
            if const.eyeMvt
                Eyelink('command', 'record_status_message ''TRIAL %d''', t);
                Eyelink('message', 'TRIALID %d', t);
                
                ncheck = 0;
                fix    = 0;
                record = 0;
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
                        if t == 1 || calibBreak == 1 || waitSpace == 1
                            calibBreak = 0;
                            wait_key(scr,const,my_key,t);                       %% wait_key
                        end
                        waitSpace = 0;
                        [fix]=check_fix(scr,const,my_key);                      %% check_fix
                        ncheck = ncheck + 1;
                        fix = 1;
                    end
                    if fix~=1 && record
                        eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Error calibration instruction');
                        textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                        eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                        instructionsFB(scr,const,my_key,'Calibration');
                        EyelinkDoTrackerSetup(el);
                        calibBreak = 1;
                        record = 0;
                    end
                end
                
                % Trial beginning
                const.eyeMvt
                Eyelink('message', 'TRIAL_START %d', t);
                Eyelink('message', 'SYNCTIME');
            end
            
            
            if const.task == 1
                [resMat,xUpdate_tilt, stairIndex, stairsUpdated] = runSingleTrial(scr,const,expDes,my_key,t);
                if isempty(stairsUpdated) == 0
                    const.stairs = stairsUpdated;
                end
                if xUpdate_tilt ~= 99 && isempty(stairIndex) == 0
                    const.stairs(stairIndex).xCurrent = xUpdate_tilt; % added
                end
            else
                [resMat] = runSingleTrial(scr,const,expDes,my_key,t);
            end
            
            if const.eyeMvt && resMat(3) ~= -1
                Eyelink('message', 'TRIAL_END %d',  t);
                Eyelink('stoprecording');
            end
            
            trialDone = 1;
            
            if resMat(end) == -1 % if pausing experiment (space) (code = -1)
                newJ = newJ+1;
                expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);  
                expDes.angleAdd(:, newJ) = expDes.angle(:,t);
                instructions(scr,const,my_key,textExp.pause,button.pause);
                expResMat(t,:)= [expDes.expMat(t,:),resMat];
            elseif resMat(end) == -2 % broken fixation (code = -2)
                newJ = newJ+1;
                expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);    
                expDes.angleAdd(:, newJ) = expDes.angle(:,t);
                expResMat(t,:)= [expDes.expMat(t,:),resMat];
            else
                expResMat(t,:)= [expDes.expMat(t,:),resMat];
                csvwrite(const.expRes_fileCsv,expResMat);
            end
            Output(t,:) = expResMat(t,:);
            fprintf('current trial: %i\n', t);
        end
        % If error of fixation 
        if ~newJ
            expDone = 1;
        else
            endJ = endJ+newJ; %% NEW
            expDes.j = expDes.j+newJ;
            expDes.expMat=[expDes.expMat;expDes.expMatAdd];
            expDes.angle=[expDes.angle,expDes.angleAdd];
            expDes.expMatAdd = [];
            expDes.angleAdd = [];
            newJ = 0;
        end
        
        % add new trials to end
        if t<endJ && t==initialLength
            expDone = 0;
            startJ = initialLength+1;
        end
    end
end
%% NEW : closing stuff (following lines) needs to be out of trial loop; I added the "end" in line 202
const.my_clock_end = clock;
const_file = fopen(const.const_fileDat,'a+');
fprintf(const_file,'Ending time :\t%ih%i',const.my_clock_end(4),const.my_clock_end(5));
fclose('all');

if const.eyeMvt
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
    WaitSecs(1);
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'The end');
end

instructions(scr,const,my_key,textExp.end,button.end);

% end