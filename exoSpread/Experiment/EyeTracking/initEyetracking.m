function EL = initEyetracking(const, w_ptr)

%% Initialize Eyetracker

[EL, exitFlag] = initEyelinkStates('eyestart', w_ptr, {const.eyeFile, const});
if exitFlag, return, end

% maybe just add these to const instead of EL?
EL.eyeDataDir = const.eyeDataDir;
EL.eyeFile = const.eyeFile; 