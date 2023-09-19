function [cor]=check_fix(scr,const,my_key)
% ----------------------------------------------------------------------
% [cor]=ckeckFix(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Show fixation target and wait for sufficient fixation.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing varions constant.
% my_key : keyborad keys names
% ----------------------------------------------------------------------
% Output(s):
% cor : flag or signal of a right fixation of FP.
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 2021-07-11
% Project : -
% Version : -
% ----------------------------------------------------------------------

%% Compute and simplify var names :
timeout = const.timeOut;     % maximum fixation check time
tCorMin = const.tCorMin;     % minimum correct fixation time

%% Eye movement config
radBef = scr.rad ;

%% Eye data coordinates
if const.eyeMvt
    Eyelink('message', 'EVENT_FixationCheck');
end

my_fixationCross(scr,const); 
       
Screen('Flip',scr.main);
        
if const.eyeMvt
    tstart = GetSecs;
    cor = 0;
    corStart=0;
    tCor = 0;
    t=tstart;

    while KbCheck; end

    while ((t-tstart)<timeout && tCor<= tCorMin)
        
        %Screen('FillRect',scr.main,const.gray)
        
        [x,y]=getCoord(scr,const);
        
        if sqrt((x-scr.x_mid)^2+(y-scr.y_mid)^2) < radBef
            cor = 1;
        else
            cor = 0;
        end

        if cor == 1 && corStart == 0
            tCorStart = GetSecs;
            corStart = 1;
        elseif cor == 1 && corStart == 1
            tCor = GetSecs-tCorStart;
        else
            corStart = 0;
        end
        t = GetSecs;

        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown
            if keyCode(my_key.escape)  && ~const.expStart
                sca
            end
        end
    end
else 
    cor=1;
end
end