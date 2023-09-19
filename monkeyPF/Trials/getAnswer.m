function [key_press,tRt]=getAnswer(scr,const,my_key)
% ----------------------------------------------------------------------
% [key_press]=getAnswer(scr,const,expDes,t,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Check keyboard press, and return flags.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing all the constant configurations.
% my_key : keyboard keys names.
% tRt : machine time of button press
% ----------------------------------------------------------------------
% Output(s):
% key_press : struct containing key answer.
% ----------------------------------------------------------------------
% improve portability of your code acorss operating systems
KbName('UnifyKeyNames');
% specify key names of interest in the study
activeKeys = [KbName('LeftArrow') KbName('RightArrow') KbName('Escape') KbName('Space')];
t2wait = 1.5;
RestrictKeysForKbCheck(activeKeys);
tStart = GetSecs;
timedOut = 0;

key_press.left = 0;
key_press.right = 0;
key_press.push_button = 0;
key_press.escape = 0;
key_press.space = 0;

% Keyboard checking :
my_fixationCross(scr,const);

Screen('Flip',scr.main);

if const.eyeMvt
    Eyelink('message','T6');
end

while ~key_press.push_button && ~timedOut

    [keyIsDown, seconds, keyCode] = KbCheck;
    if seconds > t2wait + tStart
        timedOut = 1;
        tRt = 1.5;
    elseif keyIsDown
        if (keyCode(my_key.escape)) && ~const.expStart
            key_press.push_button = 1;
            key_press.escape = 1;
            tRt = seconds;
        elseif (keyCode(my_key.space))
            key_press.push_button = 1;
            key_press.space = 1;
            tRt = seconds;
        elseif (keyCode(my_key.right))
            key_press.right = 1;
            key_press.push_button = 1;
            tRt = seconds;
        elseif (keyCode(my_key.left))
            key_press.left = 1;
            key_press.push_button = 1;
            tRt = seconds;
        end
    end
end
if const.eyeMvt && timedOut~=1
    Eyelink('message','Response');
end