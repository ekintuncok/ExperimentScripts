function wait_key(scr,const,my_key,t)
% ----------------------------------------------------------------------
% waitSpace(scr,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Show start sceen and wait for space press.
% ----------------------------------------------------------------------
% Input(s) :
% scr : screen configurations
% const : struct containing all the constant configurations.
% my_key : keyboard keys names.
% t : trial count
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 2021-07-11
% Project : ppSacApp
% Version : 4.0
% ----------------------------------------------------------------------

while KbCheck(-1); end

% Button flag
key_press.space         = 0;
key_press.escape        = 0;
key_press.push_button   = 0;

% Keyboard checking :
if const.eyeMvt
    Eyelink('message','EVENT_PRESS_SPACE');
end

Screen('FillRect',scr.main,const.gray);

my_fixationCross(scr,const); 

Screen('Flip',scr.main);

while ~key_press.push_button
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                sca
            elseif (keyCode(my_key.space))
                key_press.space = 1;
                key_press.push_button = 1;
            end
        end
    end
end

end