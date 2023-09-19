function [textExp,button] = instructionConfig
% ----------------------------------------------------------------------
% [textExp,button] = instructionConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Write text of calibration and general instruction for the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% textExp : struct containing all text of general instructions.
% button : struct containing all button instructions.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 10/2021 by Ekin Tuncok
% ----------------------------------------------------------------------

%% Pause : 
pause_l1 = 'Pause:';
pause_l2 = 'Please take a break. Rest your eyes! ';
pause_b1 = 'Press [SPACE] TWICE to continue';

textExp.pause = {pause_l1;pause_l2;[]};
button.pause = {pause_b1};

%% End :
end_l1 = 'Experiment is over. Thank you for participating!';
end_b1 = ' PRESS [SPACE] TO QUIT';

textExp.end = {end_l1};
button.end =  {end_b1};

end