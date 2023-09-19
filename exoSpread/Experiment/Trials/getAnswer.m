function [key_press,tRt]=getAnswer(scr,const,my_key)

KbName('UnifyKeyNames');
% specify key names of interest in the study
activeKeys = [KbName('LeftArrow') KbName('RightArrow') KbName('Escape') KbName('Space')];
RestrictKeysForKbCheck(activeKeys);
key_press.left = 0;
key_press.right = 0;
key_press.push_button = 0;
key_press.escape = 0;
key_press.space = 0;
% Keyboard checking :
Screen('DrawDots', scr.main,[const.xDist; const.yDist], const.cue_size, const.white,  scr.mid, 1);
my_fixationCross(scr,const);

Screen('Flip',scr.main);

while ~key_press.push_button
    [keyIsDown, seconds, keyCode] = KbCheck;
    if keyIsDown
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
if const.eyeMvt
    Eyelink('message','Response');
end