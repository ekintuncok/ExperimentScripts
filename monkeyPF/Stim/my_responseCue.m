function my_responseCue(scr,const,colorMatrixCue)
% ----------------------------------------------------------------------
% my_fixationCross(scr,const,cueType, color)

% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross in the center of the screen
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% const = structure containing constant configurations.
% colorMatrix = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% ----------------------------------------------------------------------
% Output(s):
% 

% Draw the fixation cross using four different lines
Screen('DrawLine',scr.main,colorMatrixCue(1),scr.x_mid, scr.y_mid, scr.x_mid, scr.y_mid-const.sideFP_Y,const.thicknessFP_X); % upper WM
Screen('DrawLine',scr.main,colorMatrixCue(2), scr.x_mid, scr.y_mid, scr.x_mid, scr.y_mid+const.sideFP_Y,const.thicknessFP_X); % lower WM
Screen('DrawLine',scr.main,colorMatrixCue(3), scr.x_mid+const.sideFP_X, scr.y_mid, scr.x_mid, scr.y_mid,const.thicknessFP_X); % left HM
Screen('DrawLine',scr.main,colorMatrixCue(4), scr.x_mid-const.sideFP_X, scr.y_mid, scr.x_mid, scr.y_mid,const.thicknessFP_X); % right HM

% Flip to the screen
% Screen('Flip', scr.main);
end