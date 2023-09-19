function my_feedback(scr,const,colorVector)
% ----------------------------------------------------------------------
% my_feedback(scr,const,colorVector)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw the feedback cross with the right color 
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% const = structure containing constant configurations.
% colorMatrix = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------

x = scr.x_mid;
y = scr.y_mid;

% Draw the fixation cross using four different lines
Screen('DrawLine',scr.main,colorVector, x, y, x, y+const.sideFP_Y,const.thicknessFP_X); % lover WM
Screen('DrawLine',scr.main,colorVector, x, y, x, y-const.sideFP_Y,const.thicknessFP_X); % upper WM
Screen('DrawLine',scr.main,colorVector, x+const.sideFP_X, y, x, y,const.thicknessFP_X); % right HM
Screen('DrawLine',scr.main,colorVector, x-const.sideFP_X, y, x, y,const.thicknessFP_X); % left HM

% Flip to the screen
% Screen('Flip', scr.main);
end