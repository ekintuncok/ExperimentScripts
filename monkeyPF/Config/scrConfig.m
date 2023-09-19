function [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Give all information about the screen and the monitor.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing subject information and saving files.
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing all screen configuration.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 2023
% Project : Yeshurun98
% Version : -
% ----------------------------------------------------------------------

% Number of the exp screen:
scr.all = Screen('Screens');
scr.scr_num = max(scr.all);

setScreen = Screen('Computer');
const.compName = convertCharsToStrings(setScreen.system);

if ~const.expStart
    Screen('Preference', 'SkipSyncTests', 1);
end

const.desiredFD    = 90;
const.compName = convertCharsToStrings(setScreen.system);


%set(0,'units','centimeters')
%all_disp = get(0,'MonitorPositions');
%disp_size_cm = all_disp(2,:);
scr.dist = 57;
scr.disp_sizeX = 40.5;
scr.disp_sizeY = 30;

if strcmp(const.compName,'Mac OS 10.13.6')
    const.desiredRes   = [1280 1024];
    scr.gamma_name = 'R2ViewSonic';
    if ~isempty(scr.gamma_name)
        table = load(sprintf('GammaCalib/gamma/%s/%s.mat',scr.gamma_name,scr.gamma_name));
        table = table.table;
        Screen('LoadNormalizedGammaTable',scr.scr_num,table);
        newtable = Screen('ReadNormalizedGammaTable',scr.scr_num);
    end

elseif strcmp(const.compName,'Mac OS 13.3.0')
    const.desiredRes   = [1920, 1080];
end

% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY]=Screen('WindowSize',scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

scr.refreshRate = 90;
% Frame rate : (fps)
scr.frame_duration =1/(Screen('FrameRate',scr.scr_num));
if scr.frame_duration == inf
    scr.frame_duration = 1/scr.refreshRate;
elseif scr.frame_duration == 0
    scr.frame_duration = 1/scr.refreshRate;
end
scr.fd = scr.frame_duration;

% Frame rate : (hertz)
scr.hz = 1/(scr.frame_duration);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end

% Center of the screen :
scr.x_mid = (scr.scr_sizeX/2.0);
scr.y_mid = (scr.scr_sizeY/2.0);
scr.mid = [scr.x_mid,scr.y_mid];

scr.VisAngle      = (2*atand(scr.disp_sizeY/(2*scr.dist)));

% Fixation 
scr.ppd        = round(scr.scr_sizeY/scr.VisAngle);                                         % pixels per degree visual angle
scr.rad = 2.0 * scr.ppd;        % screen radius (for fixation forgiveness)

% Keyboard 

[keyboardIndices, productNames, ~] = GetKeyboardIndices;
deviceString = convertCharsToStrings(productNames{1,1});
scr.deviceNumber = [];
for i=1:length(productNames)                                                % for each possible device
    if strcmp(productNames{i},deviceString)                                 % compare the name to the name you want
        scr.deviceNumber=keyboardIndices(i);                                    % grab the correct id, and exit loop
        break;
    end
end
scr.main = scr.scr_num;
%% Saving procedure :
% scr_file = fopen(const.scr_fileDat,'w');
% fprintf(scr_file,'Resolution size X (pxl):\t%i\n',scr.scr_sizeX);
% fprintf(scr_file,'Resolution size Y (pxl):\t%i\n',scr.scr_sizeY);
% fprintf(scr_file,'Monitor size X (mm):\t%i\n',scr.disp_sizeX);
% fprintf(scr_file,'Monitor size Y (mm):\t%i\n',scr.disp_sizeY);
% fprintf(scr_file,'Subject distance (cm):\t%i\n',scr.dist);
% fprintf(scr_file,'Frame duration (fps):\t%i\n',scr.frame_duration);
% fprintf(scr_file,'Refresh Rate (hz):\t%i\n',scr.hz);
% fclose('all');

% .mat file
save([const.subj_output_dir, '/', const.scr_fileMat],'scr');

end
