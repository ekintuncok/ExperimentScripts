function [el,const]=initEyeLink(scr,const)
% ----------------------------------------------------------------------
% [el,error]=initEyeLink(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Initializes eyeLink-connection, creates edf-file
% and writes experimental parameters to edf-file
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing many constant configuration.
% ----------------------------------------------------------------------
% Output(s):
% el : eye-link structure.
% const : struct containing edfFileName
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 12 / 03 / 2018
% Project : PirateAtt
% Version : 2.0
% ----------------------------------------------------------------------

%% Define EDF file name :
const.edffilename = 'XX.edf';

%% Modify different defaults settings :
el=EyelinkInitDefaults(scr.main);
el.backgroundcolour = GrayIndex(el.window);
el.msgfontcolour    = WhiteIndex(el.window);
el.imgtitlecolour   = WhiteIndex(el.window);
el.targetbeep       = 0;
el.feedbackbeep     = 0;

el.calibrationtargetcolour= BlackIndex(el.window);
el.displayCalResults = 1;
el.eyeimgsize=50;
EyelinkUpdateDefaults(el);
el.backgroundcolour = const.gray; %const.colBG;
el.calibrationtargetsize= 0.5; % const.calTargetRad_deg;        % radius (deg) of calibration target
el.calibrationtargetwidth=0.2; % const.calTargetWidth_deg; 	% radius (deg) of inside bull's eye of calibration target
el.txtCol = 15;
el.bgCol  = 0; 

%% Initialization of the connection with the Eyelink Gazetracker. 
dummymode = 0;


if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

%% open file to record data to
res = Eyelink('Openfile', const.edffilename);
if res~=0
    fprintf('Cannot create EDF file ''%s'' ', const.edffilename);
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Describe general information on the experiment :
Eyelink('command', 'add_file_preamble_text ''Experiment by NMH''');

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

%% Set up tracker personal configuration :
rand('state',sum(100*clock));
angle = 0:pi/3:5/3*pi;

refDist_val = 12/10/2;

% compute calibration target locations
[cx1,cy1] = pol2cart(angle,refDist_val); 	
[cx2,cy2] = pol2cart(angle+(pi/6),refDist_val*0.65);
cx = round(scr.x_mid + scr.x_mid*[0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid*[0 cy1 cy2]);

% start at center, select randomly, end at center
crp = randperm(12)+1;
c(1:2:28) = [cx(1) cx(crp) cx(1)];
c(2:2:28) = [cy(1) cy(crp) cy(1)];

% compute validation target locations (ca libration targets smaller radius)
[vx1,vy1] = pol2cart(angle,refDist_val*0.85);
[vx2,vy2] = pol2cart(angle+pi/6,refDist_val*0.5);

vx = round(scr.x_mid + scr.scr_sizeY/2*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.y_mid*[0 vy1 vy2]);

% start at center, select randomly, end at center
vrp = randperm(12)+1;
v(1:2:28) = [vx(1) vx(vrp) vx(1)];
v(2:2:28) = [vy(1) vy(vrp) vy(1)];

Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, scr.scr_sizeX-1, scr.scr_sizeY-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, scr.scr_sizeX-1, scr.scr_sizeY-1);

Eyelink('command', 'calibration_type = HV13');
Eyelink('command', 'generate_default_targets = NO');

Eyelink('command', 'randomize_calibration_order 0');
Eyelink('command', 'randomize_validation_order 0');
Eyelink('command', 'cal_repeat_first_target 0');
Eyelink('command', 'val_repeat_first_target 0');

Eyelink('command', 'calibration_samples=14');
Eyelink('command', 'calibration_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13');
Eyelink('command', sprintf('calibration_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',c));

Eyelink('command', 'validation_samples=14');
Eyelink('command', 'validation_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13');
Eyelink('command', sprintf('validation_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',v));


% Set parser
Eyelink('command', 'saccade_velocity_threshold = 35');
Eyelink('command', 'saccade_acceleration_threshold = 9500');

Eyelink('command', 'file_event_filter = RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'file_sample_data = RIGHT,GAZE,AREA');
Eyelink('command', 'link_event_filter = RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'link_sample_data  = RIGHT,GAZE,AREA');

Eyelink('command', 'heuristic_filter = 1 1');

%% Set pupil Tracking model in camera setup screen  (no = centroid. yes = ellipse)
Eyelink('command', 'use_ellipse_fitter =  NO');

%% set sample rate in camera setup screen
Eyelink('command', 'sample_rate = %d',1000);


% Test mode of eyelink connection :
status = Eyelink('IsConnected');
switch status
    case -1
        fprintf(1, '\tEyelink in dummymode.\n\n');
    case  0
        fprintf(1, '\tEyelink not connected.\n\n');
    case  1
        fprintf(1, '\tEyelink connected.\n\n');
end

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end


end