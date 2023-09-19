function my_fixationCross(scr,const)
% ----------------------------------------------------------------------
% my_fixationCross(scr,const,cueType, color)

% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross in the center of the screen
% ---------------------------------------------------------------------

% Draw the fixation cross using four different lines
Screen('DrawLine',scr.main,const.white, scr.x_mid , scr.y_mid , scr.x_mid , scr.y_mid+const.sideFP_Y,const.thicknessFP_X); % lover WM
Screen('DrawLine',scr.main,const.white, scr.x_mid , scr.y_mid, scr.x_mid , scr.y_mid-const.sideFP_Y,const.thicknessFP_X); % upper WM
Screen('DrawLine',scr.main,const.white, scr.x_mid+const.sideFP_X, scr.y_mid, scr.x_mid , scr.y_mid, const.thicknessFP_X); % right HM
Screen('DrawLine',scr.main,const.white, scr.x_mid-const.sideFP_X, scr.y_mid, scr.x_mid , scr.y_mid, const.thicknessFP_X); % left HM

end