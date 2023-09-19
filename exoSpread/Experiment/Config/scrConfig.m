function [scr]=scrConfig(const)

% Number of the exp screen:
scr.all = Screen('Screens');
scr.scr_num = max(scr.all);

setScreen = Screen('Computer');
const.compName = convertCharsToStrings(setScreen.system);

if ~const.expStart
    Screen('Preference', 'SkipSyncTests', 1);
end

const.desiredFD    = 100;
const.compName = convertCharsToStrings(setScreen.system);
scr.dist = 57;
scr.disp_sizeX = 40.5;
scr.disp_sizeY = 30;

if strcmp(const.compName,'Mac OS 10.13.6')
    const.desiredRes   = [1280 960];
    scr.gamma_name = 'R2ViewSonic';
    if ~isempty(scr.gamma_name)
        table = load(sprintf('GammaCalib/gamma/%s/%s.mat',scr.gamma_name,scr.gamma_name));
        table = table.table;
        Screen('LoadNormalizedGammaTable',scr.scr_num,table);
        newtable = Screen('ReadNormalizedGammaTable',scr.scr_num);
    end

elseif strcmp(const.compName,'Mac OS 13.4.1')
    const.desiredRes   = [1600, 900];
end

if const.in_R2 == 1
    Screen('Resolution',scr.scr_num,  const.desiredRes(1),  const.desiredRes(2), const.desiredFD );
end
[scr.scr_sizeX, scr.scr_sizeY] = Screen('WindowSize',scr.scr_num);
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
% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY] = Screen('WindowSize',scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

% Frame rate : (hertz)
scr.hz = 1/(scr.frame_duration);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end

% Center of the screen :
scr.x_mid = (scr.scr_sizeX/2);
scr.y_mid = (scr.scr_sizeY/2);
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

% .mat file
const.scr_fileMat = sprintf('%s_scr_file.mat',const.sjctCode);
save([const.subj_output_dir, '/', const.scr_fileMat],'scr');

end
