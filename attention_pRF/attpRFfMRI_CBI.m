%% run attention pRF experiment
% written by Ekin Tuncok (based on a template by Ilona Bloem)
% Last updated: 11/2021
clear all
close all
clc
echo off
% Options
Scan            = 0;
eyeTrackON      = 0;
pilot           = 0;
oneScreenOnly   = 0; % To set the alpha filter on the screen
currentScanSession  = input(sprintf('\n\tCurrent Scan Session: '));
currentRun      = input(sprintf('\n\tCurrent Run: '));
practiceRound   = 0;
if practiceRound
        fprintf('>>>>>>>>>>> practice round is ON........\n')
end

%%%%%%%%%%%
if Scan == 1
    prompt          = 'Subject code:';
    output.Subject  = input(prompt,'s');
    output.SubjectEdf  = output.Subject(7:end); % eye tracker subject code
else
    output.Subject  = 'test';
    output.SubjectEdf  = 'test';
end
session         = sprintf('nyu3t0%i', currentScanSession); % synch this to the current scan session input
task            = 'attPRF';

%%%%%%%%%%%
addpath(genpath('/Applications/Psychtoolbox'));
AssertOpenGL;
KbName('UnifyKeyNames');
% DisableKeysForKbCheck([]);

if Scan == 0
    Screen('Preference', 'SkipSyncTests', 1);
    fprintf('>>>>>>>>>>> CAREFUL! skip sync tests is active........\n')
end

commandwindow;
[keyboardIndices, productNames, ~] = GetKeyboardIndices;

deviceString = convertCharsToStrings(productNames{1,1});

if Scan == 0
    stimDir = '/Users/et2160/Desktop/ExperimentScripts/attention_pRF';
    dataDir = '/Users/et2160/Desktop/attention pRF/Data';
    subjDir = [dataDir, sprintf('/%s/0%i', output.Subject, currentScanSession)];
    if ~exist(subjDir, 'dir')
        mkdir(subjDir);
    end
    keyPressNumbers    = [KbName('LeftArrow') KbName('RightArrow')];   % {'1!', '2@'} for scanner, {'80', '79'} for arrows on macbook
    w.ScreenWidth      = 47.7;
    w.ScreenHeight     = 27;
    w.AllScreens       = Screen('Screens');
    w.whichScreen      = max(w.AllScreens); % change back to max
    w.ViewDistance     = 57;                                                    % in cm, ideal distance: 1 cm equals 1 visual degree (at 57 cm) - 107.5 at scanner with eye-tracking, 88 normal screen
    w.ScreenSizePixels = Screen('Rect', w.whichScreen);                                 % Scanner display = [0 0 1024 768];
else
    stimDir = '/Users/et2160/Desktop/ExperimentScripts/attention_pRF';
    dataDir = '/Users/et2160/Desktop/attention pRF/Data';
    subjDir = [dataDir, sprintf('/%s', output.Subject)];
    if ~exist(subjDir, 'dir')
        mkdir(subjDir);
    end
    deviceString       = '932';                        % deviceString= 'Celeritas Dev'; %'Teensy Keyboard/Mouse';
    triggerBox         = '932';
    keyPressNumbers    = [KbName('3#') KbName('4$')];                           % [KbName('1!') KbName('2@')]
    w.ScreenWidth      = 60;
    w.ScreenHeight     = 36.2;
    w.ViewDistance     = 85; % mirror to the projector + eyes to the mirror
    w.whichScreen      = 1;
    w.ScreenSizePixels = [0 0 1920 1080];                      % Scanner display = [0 0 1024 768];
    %     Datapixx('Open');
    %     Datapixx('RegWrRd');
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible')
end
designFileName = [subjDir, sprintf('/sub-%s_ses-%s_task-%s_experimentalDesignMat.mat', output.Subject, session, task)];
if currentRun < 10
    saveFileName = sprintf('/%s_ses-%s_task-%s_run-0%i_data.mat', output.Subject, session, task, currentRun);
    output.eyeTrackName = [output.SubjectEdf '_H0' num2str(currentRun)];
else
    saveFileName = sprintf('/%s_ses-%s_task-%s_run-%i_data.mat', output.Subject, session, task, currentRun);
    output.eyeTrackName = [output.SubjectEdf '_H' num2str(currentRun)];
end
deviceNumber = [];
for i=1:length(productNames)                                                % for each possible device
    if strcmp(productNames{i},deviceString)                                 % compare the name to the name you want
        deviceNumber=keyboardIndices(i);                                    % grab the correct id, and exit loop
        break;
    end
end
%% SCREEN PARAMETERS
w.frameRate     = 60;
w.Background    = GrayIndex(w.whichScreen);% fix to 60Hz - make sure this is correct!!
if Scan == 1
    w.VisAngle      = (2*atand(w.ScreenHeight/(2*w.ViewDistance)));
else
    w.VisAngle      = (2*atand(w.ScreenHeight/(2*w.ViewDistance)));
end
w.refreshRate   = 60;
w.xCenter       = w.ScreenSizePixels(3)/2; w.yCenter = w.ScreenSizePixels(4)/2;
w.frameDuration = 1/w.refreshRate;

stim.meanLum    = 127;
stim.ppd        = round(w.ScreenSizePixels(4)/w.VisAngle);                                         % pixels per degree visual angle
%% STIM
stim.white  = WhiteIndex(w.whichScreen);
stim.black  = BlackIndex(w.whichScreen);
stim.gray   = GrayIndex(w.whichScreen);
stim.red    = [1, 0, 0]; % Feedback inaccurate answer
stim.green  = [0, 1, 0]; % Feedack accurate answer
stim.blue   = [0, 0, 1]; % Feedback missed fixation
stim.orange = [255, 150, 0]; % Feedback response registered late (>2)

% Placeholders
stim.placeHoldersColor    = stim.gray + 50;
stim.placeHoldersDistance = 5; % in pixels

% Fixation Cross
stim.fixationCrossSize           = 0.35;
stim.fixationCrossPixel          = round(stim.fixationCrossSize*stim.ppd);
stim.fixationCrossthickness      = 0.02;
stim.fixationCrossthicknessPixel = round(stim.fixationCrossthickness*stim.ppd);
stim.fixationCrossColor          = [stim.white, stim.white, stim.white, stim.white];
% Cue
stim.upperCue   = [stim.white, stim.black, stim.white, stim.white]; %upper
stim.lowerCue   = [stim.black, stim.white, stim.white, stim.white]; %lower

stim.leftCue    = [stim.white, stim.white, stim.white, stim.black]; %left
stim.rightCue   = [stim.white, stim.white, stim.black, stim.white]; %right
stim.neutralCue = [stim.black, stim.black, stim.black, stim.black]; %neutral

% Gabor
stim.gaborContrast     = 0.10;
if practiceRound
    stim.gaborContrast = 1;
end
stim.gaborEcc          = 6;
stim.gaborEccPixel     = round(stim.gaborEcc*stim.ppd);
stim.gaborSpatialFreq  = 4;
stim.gaborSize         = 3;
stim.gaborSizePixel    = round(stim.gaborSize*stim.ppd);

stim.gaborfwhm     = 1;        % full width at half maximum; fwhm also used in previous studies
stim.gaborEnvSDeg  = stim.gaborfwhm./(sqrt(8*log(2))); % desired standard deviation of gabor envelope in degree
stim.gaborWidth    = stim.gaborSize/(stim.gaborEnvSDeg*4*pi);
stim.gaborwidthPix = round(stim.gaborWidth*stim.ppd);
stim.gaborSigma    = stim.gaborSize/stim.gaborEnvSDeg;
stim.gaborPhase    = 1;% in visual degree, change this to a random phase vector


stim.gaborUpper     = [w.xCenter-(stim.gaborSizePixel/2) w.yCenter-(stim.gaborEccPixel+(stim.gaborSizePixel/2))...
    w.xCenter+(stim.gaborSizePixel/2) w.yCenter-stim.gaborEccPixel+(stim.gaborSizePixel/2)];
stim.gaborLower     = [w.xCenter-(stim.gaborSizePixel/2) w.yCenter+stim.gaborEccPixel-(stim.gaborSizePixel/2)...
    w.xCenter+(stim.gaborSizePixel/2) w.yCenter+stim.gaborEccPixel+(stim.gaborSizePixel/2)];
stim.gaborLeft      = [w.xCenter-(stim.gaborEccPixel+(stim.gaborSizePixel/2)) w.yCenter-(stim.gaborSizePixel/2)...
    w.xCenter-stim.gaborEccPixel+(stim.gaborSizePixel/2) w.yCenter+(stim.gaborSizePixel/2)];
stim.gaborRight     = [w.xCenter+stim.gaborEccPixel-(stim.gaborSizePixel/2) w.yCenter-(stim.gaborSizePixel/2)...
    w.xCenter+stim.gaborEccPixel+(stim.gaborSizePixel/2) w.yCenter+(stim.gaborSizePixel/2)];

stim.gaborLocations = [stim.gaborUpper' stim.gaborLower' stim.gaborLeft' stim.gaborRight'];
stim.referenceGabor = 90;

stim.verticalMask   = load([stimDir '/verticalMappingMask.mat']);
stim.horizontalMask = load([stimDir '/horizontalMappingMask.mat']);
stim.carrier        = load([stimDir '/output.mat']);
% stim.carrier        = load('/Users/ekintuncok/Desktop/output.mat');

stim.mappingStimMask = cat(3,stim.verticalMask.verticalMappingMask,stim.horizontalMask.horizontalMappingMask);
stim.nullMask        = zeros(size(stim.mappingStimMask, 1), size(stim.mappingStimMask, 2), 4);
stim.mappingStimMask = cat(3,stim.mappingStimMask,stim.nullMask );

stim.numCarriers           = [8 16];
stim.mappingStimContrast   = 0.2;
stim.mappingStimEcc        = 12;

if Scan == 1
    stim.mappingStimDiameter = 2*stim.mappingStimEcc*stim.ppd;
else
    stim.mappingStimDiameter = 1080;
end

stim.mappingStimFlickerDur = 0.250; % showing 8 different patterns if MS duration = 1000ms, 16 otherwise
stim.mappingStimFlickerRate= stim.mappingStimFlickerDur * w.frameDuration;
% Feedback color
stim.corrAns          = stim.green;
stim.incorrAns        = stim.red;
stim.lateAnswer       = stim.blue;
%% Experimental design matrix: prepares the pseudo-randomized experimental design matrix..
% to be used in the main experimental loop
% TIMING PARAMETERS
t.TheDate       = datestr(now,'yymmdd');                                   % Collect todays date
t.TimeStamp     = datestr(now,'HHMM');                                     % Timestamp for saving out a uniquely named datafile (so you will never accidentally overwrite stuff)
t.TR            = 1;                                                       % TR length
t.phaseShift    = 0.2; % (seconds), contrast petal/grating phase shift rate

t.fixation        = 0.3;
t.preCue          = 0.3;
t.mappingStim     = [1 2];
t.ISI             = [0.05 0.3 0.4 0.5];
t.gaborDisplay    = 0.1;
t.ISI2            = 0.5;
t.responseDur     = 1.2;
t.feedbackDur     = 0.3;
t.exitGradient    = 6;
%% Experimental design matrix maker
if exist(designFileName,'file')
    fprintf('>>>>>>>>>>> loading the design matrix from Run 1....\n')
    load(designFileName);
else
    if currentRun > 1
        fprintf('CAREFUL! creating a separate design matrix for Run %d! check the design directory.... \n', currentScanSession)
    end
    fprintf('>>>>>>>>>>> creating the design matrix....\n')
    design.numRuns     = 10;
    design.trialinRuns = 52;
    
    design.numTrials  = design.numRuns * design.trialinRuns;
    
    design.runVector       = 1:10;
    design.numTrialsperRun = design.numTrials/design.numRuns;
    design.runCoding       = repmat(design.runVector',1,design.numTrialsperRun)';design.runCoding =design.runCoding (:);
    design.mappingStim  = 1:52;
    design.preCue       = 1:5;
    design.postCue      = 1:4;
    design.mappingDur   = 1:2;
    design.trialMat       = repelem(1:design.numRuns, design.trialinRuns)';
    
    % Mapping Stim
    startHere = 1;
    endHere   = numel(design.mappingStim);
    for iter = 1:design.numRuns
        design.trialMat(startHere:endHere, 2) =  randperm(numel(design.mappingStim))';
        startHere = startHere + numel(design.mappingStim);
        endHere = endHere  + numel(design.mappingStim);
    end
    
    % Duration
    for ind = 1:length(design.trialMat)
        if mod(design.trialMat(ind,2), 2) == 0
            design.trialMat(ind,5) = design.mappingDur(1);
        else
            design.trialMat(ind,5) = design.mappingDur(2);
        end
    end
    
    % Assign pre-cue
    for msInd = 1:numel(design.mappingStim)
        indices = find(design.trialMat(:,2) == msInd);
        design.trialMat(indices,3) = Shuffle(repelem(design.preCue, 1, numel(design.mappingDur)));
    end
    
    % Assign response-cue
    % cue validities
    design.validval   = 0.6;
    design.neutralval = 0.2;
    design.invalidval = 0.2;
    design.numValidTrials   = design.numTrials * design.validval;
    design.numNeutralTrials = design.numTrials * design.neutralval;
    design.numInvalidTrials = design.numTrials * design.invalidval;
    
    design.numValTrialsperLoc     = design.numValidTrials / numel(design.postCue);
    design.numNeutralTrialsperLoc = design.numNeutralTrials / numel(design.postCue);
    design.numInvalTrialsperLoc   = design.numInvalidTrials / numel(design.postCue);
    design.neutralCueAssign       = Shuffle(repelem(1:numel(design.postCue),1,design.numNeutralTrialsperLoc));
    design.validCueAssign         = Shuffle(repelem(1:numel(design.postCue),1,design.numValTrialsperLoc));
    design.invalidCueAssign       = Shuffle(repelem(1:numel(design.postCue),1,design.numInvalTrialsperLoc));
    
    remainingPerLoc = 2;
    
    for ind =1:length(design.postCue)
        addValid = repmat(design.postCue(ind),1,design.numValTrialsperLoc);
        currentSet = setdiff(design.postCue,design.postCue(ind));
        addInvalid = repmat(currentSet,1,floor((design.numInvalTrialsperLoc/(numel(design.postCue)-1))));
        if ind ~= 4
            remainingTrials = repelem(ind+1,remainingPerLoc, 1);
        else
            remainingTrials = repelem(1,remainingPerLoc, 1);
        end
        design.responseLocations(:,design.postCue(ind)) = [addValid'; addInvalid';remainingTrials];
        addInvalid = [];
        addValid = [];
    end
    
    % add the remaining trials with invalid cue:
    design.responseLocations = Shuffle(design.responseLocations,2);
    
    for cueInd = 1:length(design.postCue)
        indices = find(design.trialMat(:,3) == cueInd);
        design.trialMat(indices,4) = design.responseLocations(:,cueInd);
    end
    
    countIter = 1;
    for ind = 1:length(design.trialMat)
        if design.trialMat(ind,3) == 5
            design.trialMat(ind,4) = design.neutralCueAssign(countIter);
            countIter = countIter + 1;
        end
    end
    
    design.ISIproportions = [0.1 0.3 0.3 0.3];
    design.ISItrials      = design.numTrials*design.ISIproportions;
    design.ISIvector      = [t.ISI(1)*ones(design.ISItrials(1),1);...
        t.ISI(2)*ones(design.ISItrials(2),1);...
        t.ISI(3)*ones(design.ISItrials(3),1);...
        t.ISI(4)*ones(design.ISItrials(4),1)];
    
    design.trialMat(:,6) = Shuffle(design.ISIvector);
    design.tiltMatrix = [randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1)]';
    design.tiltMatrix = [design.runCoding design.tiltMatrix];
    
    design.TR   = 1;
    design.T1   = repmat(t.fixation, design.numTrials, 1);
    design.T2   = repmat(t.preCue, design.numTrials, 1);
    design.T3   = design.trialMat(:,5);  % Mapping stim --
    design.T4   = design.trialMat(:,6);
    design.T5   = repmat(t.gaborDisplay, design.numTrials, 1);
    design.T6   = repmat(t.ISI2, design.numTrials,1);
    design.T7   = repmat(t.responseDur,design.numTrials,1);
    design.T8   = repmat(t.feedbackDur,design.numTrials,1);
    
    design.trialDur = [design.T1 ,design.T2, design.T3,design.T4,design.T5,design.T6,design.T7,design.T8];
    
    % This part of the script recalculates trial durations in order to reduce
    % the overall jitter and have the timings more clean within one run. The
    % milliseconds are added to or subtracted from the response time. The response time ranges between
    % 1800 ms to 2250 ms
    
    for idx = 1:length(design.trialDur)
        design.trialDur(idx,9) = sum(design.trialDur(idx,1:8));
    end
    
    design.meanTrialDur = mean((design.trialDur(:,9))); % Here mean is 4.56, and the rounding up and down threshold was already
    % 4.5 due to the distribution of trial durations. Therefore, I'm using the
    % mean.
    
    for idx = 1:length(design.trialDur)
        if design.trialDur(idx, 9) < design.meanTrialDur
            if design.trialDur(idx,9)  < 4
                design.trialDur(idx,7)  = design.trialDur(idx,7) + 4 - design.trialDur(idx,9);
            elseif design.trialDur(idx, 9) > 4
                design.trialDur(idx,7)  = design.trialDur(idx,7) - (design.trialDur(idx,9) - 4);
            end
        else
            if design.trialDur(idx,9)  < 5
                design.trialDur(idx,7)  = design.trialDur(idx,7) + 5 - design.trialDur(idx,9);
            elseif design.trialDur(idx, 9) > 5
                design.trialDur(idx,7)  = design.trialDur(idx,7) - (design.trialDur(idx,9) - 5);
            end
        end
    end
    
    % Check and calculate the new trial durations:
    for idx = 1:length(design.trialDur)
        design.trialDur(idx,9) = sum(design.trialDur(idx,1:8));
    end
    
    % Replace the new response times with the old ones
    design.T7(:) = design.trialDur(:,7);
    
    % Make the stimulus event durations matrix:
    design.numofUniqueEvents = 7;
    design.allTimings = [];
    design.stimType =[];
    for idx = 1:design.numTrials
        timeintrial = [t.fixation, t.preCue, design.T3(idx,1), design.T4(idx,1), t.gaborDisplay, t.ISI2, design.T7(idx,1)+t.feedbackDur]';
        stimintrial = [1:7]';
        if mod(idx, 52) == 0
            timeintrial = [t.fixation, t.preCue, design.T3(idx,1), design.T4(idx,1), t.gaborDisplay, t.ISI2, design.T7(idx,1)+t.feedbackDur, t.exitGradient]';
            stimintrial = [1:8]';
        end
        design.allTimings = [design.allTimings; timeintrial];
        design.stimType   = [design.stimType; stimintrial];
    end
    save(designFileName, 'design');
end
t.allTimings = design.allTimings;
t.stimType = design.stimType;

t.numofUniqueEvents = 7; % T1 to T7
t.totalTime           = sum(t.allTimings);
t.allEvents           = [t.stimType t.allTimings];
t.numRuns             = design.numRuns;
t.numTrials           = design.numTrials;
t.numPracticeTrials   = 30;
t.numTrialsperRun     = t.numTrials/t.numRuns;
t.numEventsinBlock    = t.numTrialsperRun*t.numofUniqueEvents +1;
t.eventType           = t.allEvents(1:t.numEventsinBlock)';
t.runDuration         = round(t.totalTime/t.numRuns);
output.TotalTRs       = t.runDuration/t.TR;

t.runSingleTime       = reshape(t.allEvents(:,2), t.numEventsinBlock, t.numRuns);
t.runAbsTime          = cumsum(t.runSingleTime, 1);

output.timing = t.runAbsTime; % gives 234 TRs in each run


%% Screen
if oneScreenOnly == 1
    PsychDebugWindowConfiguration(0,0.80);
end

% Open window
AssertOpenGL;
[window, rect] = Screen('OpenWindow', w.whichScreen, stim.meanLum);
white = [255 255 255]; red = [205 0 0]; green = [0 205 0]; blue = [0 0 255]; orange = [255 165 0]; black = [0 0 0];
Screen('BlendFunction',window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% Query maximum useable priorityLevel on this system:
priorityLevel=MaxPriority(window);
Priority(priorityLevel);
w.OriginalCLUT = Screen('ReadNormalizedGammaTable', window);
if Scan == 1
    Screen('LoadNormalizedGammaTable', window, linspace(0,1,256)'*ones(1,3));
end

%% Eye link setup
if eyeTrackON == 1
    [el, edf_filename] = eyeTrackingOn(window, output.eyeTrackName, rect, stim.ppd);
    %     DrawFormattedText(window, LoadText, 'center', 'center', white);
    %     Screen('Flip',1 window);
end

%% MAKE STIMULI
% Gabors
fprintf('>>>>>>>>>>> preparing the stimulus....\n')

stim.gabOri = 0;
[x,y]=meshgrid(1:stim.gaborSizePixel, 1:stim.gaborSizePixel);
x = x-mean(x(:));
y = y-mean(y(:));
x = Scale(x)*stim.gaborSize-stim.gaborSize/2;
y = Scale(y)*stim.gaborSize-stim.gaborSize/2;

ori             = stim.gabOri/180*pi;
nx              = x*cos(ori) + y*sin(ori);
stim.phaseSteps = 1:5; stim.gaborPhase = stim.phaseSteps * rand * 2 * pi;
Gabors          = struct('finalstims', {[] [] [] [] []}, 'textureHandles', {[] [] [] [] []});

for phase = 1:length(stim.gaborPhase)
    stim.gaborCarrier 	       = cos(nx * stim.gaborSpatialFreq * 2 * pi+stim.gaborPhase(phase)* 2 * pi);
    modula 	                   = exp(-((x/stim.gaborWidth).^2)-((y/stim.gaborWidth).^2));
    Gabors(phase).finalstims     = ((stim.gaborCarrier.*modula).* (stim.gaborContrast * w.Background) + w.Background);
    Gabors(phase).textureHandles = Screen('MakeTexture', window , (Gabors(phase).finalstims));
end

% Mapping stimulus
MappingStim         = struct('finalstims', {[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []}, 'textureHandles', {[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []});

[XX,YY] = meshgrid(-round(stim.mappingStimDiameter/2):round(stim.mappingStimDiameter/2)-1, -round(stim.mappingStimDiameter/2):round(stim.mappingStimDiameter/2)-1);
Eccen = sqrt(XX.^2+YY.^2);
Mask = zeros(stim.mappingStimDiameter);
Mask(Eccen < (stim.mappingStimDiameter/2)-(stim.ppd/4)) = 1;

Mask = conv2(Mask, fspecial('gaussian', stim.ppd, stim.ppd/4), 'same');% stim ppd marks the size of the filter and stim.ppd/4 is the std. change either to play around with the size of the gaussian

for drawCar = 1:length(stim.carrier.output)
    
    currentCarrier                  = stim.carrier.output{1, drawCar};
    MappingStim(drawCar).finalstims = bsxfun(@times, currentCarrier, stim.mappingStimMask) .* (stim.mappingStimContrast * stim.meanLum) + stim.meanLum;
    
    for ii = 1:size(MappingStim(drawCar).finalstims,3)
        tmpStim = ones(size(MappingStim(drawCar).finalstims,1), size(MappingStim(drawCar).finalstims,2), 2);
        tmpStim(:,:,1) = MappingStim(drawCar).finalstims(:,:,ii);
        tmpStim(:,:,2) = Mask*255;
        MappingStim(drawCar).textureHandles{ii} = Screen('MakeTexture', window ,tmpStim);
    end
end
fprintf('>>>>>>>>>>> completed...\n')

%% Wait for trigger
colorMat = stim.neutralCue;
my_fixationCross(window , stim, w, colorMat);
% Screen('DrawText',window,'fixate on the center', w.xCenter,w.yCenter + w.yCenter*0.1 ,[0 0 0]*255);
Screen('Flip', window);

if Scan == 1 && ~practiceRound
    triggerKey = KbName('5%');
    fprintf('>>>>>>>>>>> waiting for the trigger from the scanner.... \n')
elseif Scan == 1 && practiceRound
    triggerKey = KbName('3#');
    fprintf('>>>>>>>>>>> trigger key is set to the response box.... \n')
else
    triggerKey = KbName('space');
    fprintf('>>>>>>>>>>> trigger key is set to the space key.... \n')
end

KbTriggerWait(triggerKey, deviceNumber);
fprintf('>>>>>>>>>>> trigger detected \n')
RestrictKeysForKbCheck(keyPressNumbers);

if eyeTrackON
    [status, el] = eyeTrackingRecord(el, rect, stim.ppd);
end

%% Set the block information
currentTimings  = t.runAbsTime(:,currentRun);
currentdesign.trialMat = design.trialMat(design.trialMat(:,1) == currentRun,:);
if pilot == 1
    currentdesign.trialMat(:, 3) = 5;
end
currentTiltMat  = design.tiltMatrix(design.tiltMatrix(:,1) == currentRun,:);currentTiltMat(:,1) = [];
%% Initialize block variables
% preallocate
if currentRun == 1
    output.responses = zeros(t.numTrialsperRun, 8);
end
currentTrial    = 0;
output.realTime = zeros(t.numofUniqueEvents, t.numTrialsperRun);

startTime = GetSecs; %maybe use time
t.bufferTime = 0.005;
output.responseStart =[];
output.vblMapping  = [];

for idx = 1:length(t.eventType)
    if t.eventType(idx) == 1
        currentTrial = currentTrial + 1;
        fprintf('>>>>>>>>>>> current trial = %d....\n', currentTrial)
    end
    
    if currentRun == 1
        cumulativeTrial = currentTrial;
    else
        cumulativeTrial = ((currentRun-1) * t.numTrialsperRun) + currentTrial;
    end
    
    currentEvent           = t.eventType(idx);
    currentMappingLocation = currentdesign.trialMat(currentTrial, 2);
    preCue                 = currentdesign.trialMat(currentTrial, 3);
    responseCue            = currentdesign.trialMat(currentTrial, 4);
    drawCW_CCW             = currentTiltMat(currentTrial,:);
    responseON = false;
    
    % Draws the mapping stimulus when the event type is called
    % Mapping stim comes first in the loop because it should be at the
    % back of the display when flipped.
    if  currentEvent == 3 
        vblMapping = myMappingStim(window, currentdesign.trialMat, currentTrial, MappingStim, stim, w, preCue, eyeTrackON);
        output.vblMapping = [output.vblMapping vblMapping(1) - startTime];
    end
    
    % Placeholders come the second, they are there independent of any
    % stim indexing
    squarePlaceHolders(stim, window);
    
    % Draws the fixation cross when the event type is called
    if currentEvent == 1 || currentEvent == 8
        colorMat = stim.fixationCrossColor;
        my_fixationCross(window , stim, w, colorMat);
    end
    
    % Draws the pre-cue when the event type is called
    if currentEvent == 2 || currentEvent == 3
        if preCue     == 1
            colorMat  =  stim.upperCue;
        elseif preCue == 2
            colorMat  =  stim.lowerCue;
        elseif preCue == 3
            colorMat  =  stim.leftCue;
        elseif preCue == 4
            colorMat  =  stim.rightCue;
        else
            colorMat  =  stim.neutralCue;
        end
        my_fixationCross(window, stim , w, colorMat);
        
    end
    
    % Draws the SOA fixation cross when the event type is called
    if currentEvent == 4
        colorMat = stim.fixationCrossColor;
        my_fixationCross(window, stim , w, colorMat);
    end
    
    % Draws the response cue and the target display when the event type is called
    
    if currentEvent == 5
%         thresholdValues = [27.19 28.09 20.92 16.10]; % turn this into an input format for the sake 555555
%         thresholdValues = [14 14.5 10 8];
        thresholdValues = [11.2, 5.07, 4.95, 4.5];
        rotationMatrix = stim.referenceGabor + (thresholdValues .* drawCW_CCW);
        drawTrialPhase = randsample([1 5], 1);
        my_fixationCross(window, stim , w, colorMat);
        Screen('DrawTextures', window, [Gabors(drawTrialPhase).textureHandles,Gabors(drawTrialPhase).textureHandles...
            ,Gabors(drawTrialPhase).textureHandles,Gabors(drawTrialPhase).textureHandles], [], stim.gaborLocations, rotationMatrix);
    end
    
    if currentEvent == 6
        colorMat = stim.fixationCrossColor;
        my_fixationCross(window , stim, w, colorMat);
    end
    
    if currentEvent == 7
        if responseCue == 1
            colorMat = stim.upperCue;
        elseif responseCue == 2
            colorMat = stim.lowerCue;
        elseif responseCue == 3
            colorMat = stim.leftCue;
        elseif responseCue == 4
            colorMat = stim.rightCue;
        end
        responseON = true;
        t2wait = t.runSingleTime(idx, currentRun) - t.feedbackDur;
        tStart = GetSecs;
        timedOut = 0;
        buttonPush = 0;
        
        my_fixationCross(window, stim , w, colorMat);
        preResponseVBL = Screen('Flip',window);
        % % Keyboard checking :
        while ~buttonPush && ~timedOut
            [keyIsDown, seconds, keyCode] = KbCheck(deviceNumber);
            if seconds - tStart > t2wait - t.bufferTime
                answer = NaN;
                timedOut = 1;
                reactionTime = t2wait;
            elseif keyIsDown
                if (keyCode(keyPressNumbers(2)))
                    answer = 1;
                    buttonPush = 1;
                    reactionTime = seconds-tStart;
                elseif (keyCode(keyPressNumbers(1)))
                    answer = -1;
                    buttonPush = 1;
                    reactionTime = seconds-tStart;
                end
            end
        end
        
        if buttonPush && timedOut
            responseON = false;
        end
        
        % Give feedback
        if  drawCW_CCW(responseCue) == 1 && answer == 1 || drawCW_CCW(responseCue) == -1 && answer == -1
            colorMat = stim.corrAns*255;
        elseif drawCW_CCW(responseCue) == 1 && answer == -1 || drawCW_CCW(responseCue) == -1 && answer == 1
            colorMat = stim.incorrAns*255;
        elseif isnan(answer)
            colorMat = stim.lateAnswer*255;
            fprintf('>>>>>>>>>>> answer not registered...\n')
        end
        my_fixationCross(window, stim , w, colorMat);
        squarePlaceHolders(stim, window);
        responseVBL = Screen('Flip',window);
        
        % this is to assure an equal response window
        
        if ~isnan(answer)
            WaitSecs(t2wait - reactionTime + t.feedbackDur)
        else
            WaitSecs(t.feedbackDur)
        end
        
        output.responseStart = [output.responseStart tStart-startTime];
        % independent of the RT
        
        output.responses(currentTrial,:) = [currentRun, currentTrial, currentMappingLocation, preCue, responseCue, drawCW_CCW(responseCue), answer, reactionTime];
    end
    
    my_fixationCross(window, stim , w, colorMat);
    squarePlaceHolders(stim, window);
    vbl = Screen('Flip', window); % write this into a function or a matrix
    if currentEvent == 1 && eyeTrackON
        Eyelink('Message', 'FIXATIONSTART');
    elseif currentEvent == 5 && eyeTrackON
        Eyelink('Message', 'TARGETDISPLAY');
    end
    
    output.realTime(currentEvent,currentTrial) = vbl - startTime;
    
    if ~responseON
        while true
            if GetSecs - startTime > t.runAbsTime(idx, currentRun) - t.bufferTime
                break
            end
        end
    end
    if practiceRound
        if idx == design.numofUniqueEvents * t.numPracticeTrials
            break
        end
    end
end

output.totalScanDuration(currentRun) = GetSecs - startTime;
%% END THE EXPERIMENT
% End eyetracking
%%%%%%%%%%%%%%%%%%%
if eyeTrackON == 1
    % reset so tracker uses defaults calibration for other experiemnts
    Eyelink('command', 'generate_default_targets = yes')
    Eyelink('Command', 'set_idle_mode');
    Eyelink('command', ['screen_pixel_coords' num2str(w.ScreenSizePixels)])% ScreenSizePixels = [0 0 1024 768];
    
    Eyelink('StopRecording');
    Eyelink('CloseFile');
    status = Eyelink('ReceiveFile', edf_filename);
    
    fprintf('ReceiveFile status %d\n', status);
end
%%%%%%%%%%%%%%%%%%%

%% Clean up
if Scan == 1
    Screen('LoadNormalizedGammaTable', window, w.OriginalCLUT);
end
Screen('CloseAll');
% if Scan == 1
%     Datapixx('RegWrRd');
%     Datapixx('close');
% end
ShowCursor;
Priority(0);


%% Prepare the output
% plot the timing:
if Scan == 1 && ~practiceRound
    output.realTime(3,:) = output.vblMapping;
    output.realTime(7,:) = output.responseStart;
    output.realTime = output.realTime(:);
    output.realTimeFull(:,currentRun) = output.realTime;
    output.realTime(:,2) = [0; t.runAbsTime(1:end-1,currentRun)];
    checkTiming = figure(1);
    subplot(1,2,1)
    scatter(output.realTime(:,1),output.realTime(:,2))
    xlabel('real time')
    ylabel('calculated time')
    subplot(1,2,2)
    title('calculated time subtracted from real time')
    stem(output.realTime(:,1)-output.realTime(:,2))
    if currentRun == 10
        saveas(checkTiming, [subjDir, sprintf('/%s_ses-%s_task-%s_run-%i_timingPlot.svg', output.Subject, session, task, currentRun)])
    else
        saveas(checkTiming, [subjDir, sprintf('/%s_ses-%s_task-%s_run-%0i_timingPlot.svg', output.Subject, session, task, currentRun)])
    end
    
    % get the window, timing and stimulus details and the output:
    data.w = w;
    data.t = t;
    data.stim = stim;
    data.output = output;
    save([subjDir saveFileName], 'data');
    save([subjDir saveFileName], 'data');
    fprintf('>>>>>>>>>>> saving the output...\n');
end
