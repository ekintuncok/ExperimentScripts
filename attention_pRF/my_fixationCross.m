function my_fixationCross(window, stim , w , colorMat)
% ----------------------------------------------------------------------
% my_fixationCross(scr,const,cueType, color)

% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross in the center of the screen
% ---------------------------------------------------------------------
if size(colorMat, 2) == 4
    % Draw the fixation cross using four different lines
    Screen('DrawLine',window,colorMat(1), w.xCenter , w.yCenter , w.xCenter , w.yCenter+stim.fixationCrossPixel,stim.fixationCrossthicknessPixel); % lover WM
    Screen('DrawLine',window,colorMat(2), w.xCenter , w.yCenter, w.xCenter , w.yCenter-stim.fixationCrossPixel,stim.fixationCrossthicknessPixel); % upper WM
    Screen('DrawLine',window,colorMat(3), w.xCenter+stim.fixationCrossPixel, w.yCenter, w.xCenter , w.yCenter, stim.fixationCrossthicknessPixel); % right HM
    Screen('DrawLine',window,colorMat(4), w.xCenter-stim.fixationCrossPixel, w.yCenter, w.xCenter , w.yCenter, stim.fixationCrossthicknessPixel); % left HM
else
    Screen('DrawLine',window,colorMat, w.xCenter , w.yCenter , w.xCenter , w.yCenter+stim.fixationCrossPixel,stim.fixationCrossthicknessPixel); % lover WM
    Screen('DrawLine',window,colorMat, w.xCenter , w.yCenter, w.xCenter , w.yCenter-stim.fixationCrossPixel,stim.fixationCrossthicknessPixel); % upper WM
    Screen('DrawLine',window,colorMat, w.xCenter+stim.fixationCrossPixel, w.yCenter, w.xCenter , w.yCenter, stim.fixationCrossthicknessPixel); % right HM
    Screen('DrawLine',window,colorMat, w.xCenter-stim.fixationCrossPixel, w.yCenter, w.xCenter , w.yCenter, stim.fixationCrossthicknessPixel); % left HM
end
    
end