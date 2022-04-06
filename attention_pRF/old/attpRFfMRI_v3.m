echo off

%%%%%%%%%%%
prompt          = 'Subject code:';
output.Subject  = input(prompt,'s');
session         = 'nyu3t01';
task            = 'attpRF';
Scan            = 1;
eyeTrackON      = 0;
pilot           = 1;
oneScreenOnly   = 0; % To set the alpha filter on the screen
currentRun      = input(sprintf('\n\tCurrent Run: '));
practiceRound   = 0;

if Scan == 1 && currentRun == 1
    practiceRound      = input(sprintf('\n\tPractice round(1) or no practice round(2): '));
end
%%%%%%%%%%%
addpath(genpath('/Applications/Psychtoolbox'));
AssertOpenGL;
KbName('UnifyKeyNames');

if Scan == 0
    Screen('Preference', 'SkipSyncTests', 1);
end

commandwindow;
[keyboardIndices, productNames, ~] = GetKeyboardIndices;
saveFileName = ['att_pRF' output.Subject '.mat'];
deviceString = convertCharsToStrings(productNames{1,1});

% In case the computer name information will come useful:
% setScreen = Screen('Computer');
% compName = convertCharsToStrings(setScreen.system);

if Scan == 0
    stimDir = '/Users/ekintuncok/Library/Mobile Documents/com~apple~CloudDocs/PhD/Projects/attentionpRF/local code';    %     deviceString = 'iClever IC-BK10 Keyboard'; % change this
    keyPressNumbers    = [KbName('LeftArrow') KbName('RightArrow')];                                  % {'1!', '2@'} for scanner, {'80', '79'} for arrows on macbook
    w.ScreenWidth      = 477;
    w.ScreenHeight     = 270;
    w.AllScreens       = Screen('Screens');
    w.whichScreen      = 0; % change back to max
    w.ViewDistance     = 57;                                                    % in cm, ideal distance: 1 cm equals 1 visual degree (at 57 cm) - 107.5 at scanner with eye-tracking, 88 normal screen
    w.ScreenSizePixels = Screen('Rect', w.whichScreen);                                 % Scanner display = [0 0 1024 768];
else
    stimDir = '/Users/et2160/Desktop/2021_FYP/local code/';
    deviceString       = '932';                        % deviceString= 'Celeritas Dev'; %'Teensy Keyboard/Mouse';
    triggerBox         = '932';
    keyPressNumbers    = [KbName('9(') KbName('8*')];                           % [KbName('1!') KbName('2@')]
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
w.VisAngle      = (2*atand(w.ScreenHeight/(2*w.ViewDistance)));
w.refreshRate   = 60;
w.xCenter       = w.ScreenSizePixels(3)/2; w.yCenter = w.ScreenSizePixels(4)/2;
w.frameDuration = 1/w.refreshRate;

stim.meanLum    = 127;
stim.ppd        = round(w.ScreenSizePixels(4)/w.VisAngle);                                         % pixels per degree visual angle
sizepixel       = (2*atan2((w.ScreenHeight/w.ScreenSizePixels(4))/2, w.ViewDistance))*(180/pi);    % in visual degree
pointSize       = (2*atan2((2.54/72)/2, w.ViewDistance))*(180/pi);                                % fontsize is in points (not pixel!) 1 letter point is 1/72 of an inch visual angle
fNyquist        = 0.5/sizepixel;


%% STIM
if currentRun == 1
    if Scan == 0
        stim.letterSize     = floor((1.2)/pointSize);
    else
        stim.letterSize     = floor((0.7)/pointSize);   % in letter points
    end
    
    stim.white  = WhiteIndex(w.whichScreen);
    stim.black  = BlackIndex(w.whichScreen);
    stim.gray   = GrayIndex(w.whichScreen);
    stim.red    = [1, 0, 0]; % Feedback inaccurate answer
    stim.green  = [0, 1, 0]; % Feedack accurate answer
    stim.blue   = [0, 0, 200]; % Feedback missed fixation
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
    stim.upperCue   = [stim.black, stim.white, stim.white, stim.white]; %upper
    stim.lowerCue   = [stim.white, stim.black, stim.white, stim.white]; %lower
    stim.leftCue    = [stim.white, stim.white, stim.white, stim.black]; %left
    stim.rightCue   = [stim.white, stim.white, stim.black, stim.white]; %right
    stim.neutralCue = [stim.black, stim.black, stim.black, stim.black]; %neutral
    
    % Gabor
    stim.gaborContrast     = 0.07;
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
    
    stim.verticalMask   = load('/Users/et2160/Desktop/attention pRF/verticalMappingMask.mat');
    stim.horizontalMask = load('/Users/et2160/Desktop/attention pRF/horizontalMappingMask.mat');
    stim.carrier        = load('/Users/et2160/Desktop/attention pRF/output.mat');
    
    
    stim.mappingStimMask = cat(3,stim.verticalMask.verticalMappingMask,stim.horizontalMask.horizontalMappingMask);
    stim.nullMask        = zeros(size(stim.mappingStimMask, 1), size(stim.mappingStimMask, 2), 4);
    stim.mappingStimMask = cat(3,stim.mappingStimMask,stim.nullMask );
    
    stim.numCarriers           = [8 16];
    stim.mappingStimContrast   = 0.2;
    stim.mappingStimEcc        = 12;
%     if Scan
%         stim.mappingStimDiameter = 1080; %% CHANGED THIS TO TRY
%     else
    stim.mappingStimDiameter = 2*stim.mappingStimEcc*stim.ppd;
%     end
    stim.mappingStimFlickerDur = 0.250; % showing 8 different patterns if MS duration = 1000ms, 16 otherwise
    stim.mappingStimFlickerRate= stim.mappingStimFlickerDur * w.frameDuration;
    % Feedback color
    stim.corrAns          = stim.green;
    stim.incorrAns        = stim.red;
    stim.lateAnswer       = stim.orange;
end
%% Initiate and generate data file
subjET = 125;
if exist(saveFileName, 'file')
    load(saveFileName);
    runnumber = length(TheData)+1;
    if runnumber < 10
        output.eyeTrackName = ['125' '_H0' num2str(runnumber)];
    else
        output.eyeTracsca
        kName = ['125' '_H' num2str(runnumber)];
    end
else
    runnumber = 1;
    output.eyeTrackName = ['125' '_H0' num2str(runnumber)];
end

%% Screen
if oneScreenOnly == 1
    PsychDebugWindowConfiguration(0,0.85);
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
% LUT - force linear LUT with ProPIXX
if Scan == 1
    Screen('LoadNormalizedGammaTable', window, linspace(0,1,256)'*ones(1,3));
end

%% Eye link setup
if eyeTrackON == 1
    [el, edf_filename] = eyeTrackingOn(window, output.eyeTrackName, rect, stim.ppd);
%     DrawFormattedText(window, LoadText, 'center', 'center', white);
%     Screen('Flip', window);
end


%% Experimental design matrix: prepares the pseudo-randomized experimental design matrix..
%  to be used in the main experimental loop
% TIMING PARAMETERS
%% TIMING OF EVENTS within the run
if currentRun == 1
    
    t.MySeed        = sum(100*clock); rng('default');                          % Make sure we're really using 'random' numbers
    t.sprev         = rng(t.MySeed);
    t.TheDate       = datestr(now,'yymmdd');                                   % Collect todays date
    t.TimeStamp     = datestr(now,'HHMM');                                     % Timestamp for saving out a uniquely named datafile (so you will never accidentally overwrite stuff)
    t.TR            = 1;                                                       % TR length
    t.phaseShift    = 0.2; % (seconds), contrast petal/grating phase shift rate
    
    t.initialBaseline = 8;
    t.fixation        = 0.3;
    t.preCue          = 0.3;
    t.mappingStim     = [1 2];
    t.ISI             = [0.05 0.3 0.4 0.5];
    t.gaborDisplay    = 0.1;
    t.ISI2            = 0.5;
    t.responseDur     = 1.2;
    t.feedbackDur     = 0.3;
    t.ending          = 8;
    %% Experimental design matrix maker
    design.numRuns    = 10;
    trialinRuns       = 52;
    
    design.numTrials  = design.numRuns * trialinRuns;
    
    design.runVector       = 1:10;
    design.numTrialsperRun = design.numTrials/design.numRuns;
    design.runCoding       = repmat(design.runVector',1,design.numTrialsperRun)';design.runCoding =design.runCoding (:);
    design.mappingStim  = 1:52;
    design.preCue       = 1:5;
    design.postCue      = 1:4;
    design.mappingDur   = 1:2;
    trialMat       = repelem(1:design.numRuns, trialinRuns)';
    
    % Mapping Stim
    startHere = 1;
    endHere   = numel(design.mappingStim);
    for iter = 1:design.numRuns
        trialMat(startHere:endHere, 2) =  randperm(numel(design.mappingStim))';
        startHere = startHere + numel(design.mappingStim);
        endHere = endHere  + numel(design.mappingStim);
    end
    
    % Duration
    for ind = 1:length(trialMat)
        if mod(trialMat(ind,2), 2) == 0
            trialMat(ind,5) = design.mappingDur(1);
        else
            trialMat(ind,5) = design.mappingDur(2);
        end
    end
    
    % Assign pre-cue
    for msInd = 1:numel(design.mappingStim)
        indices = find(trialMat(:,2) == msInd);
        trialMat(indices,3) = Shuffle(repelem(design.preCue, 1, numel(design.mappingDur)));
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
        indices = find(trialMat(:,3) == cueInd);
        trialMat(indices,4) = design.responseLocations(:,cueInd);
    end
    
    countIter = 1;
    for ind = 1:length(trialMat)
        if trialMat(ind,3) == 5
            trialMat(ind,4) = design.neutralCueAssign(countIter);
            countIter = countIter + 1;
        end
    end
    
    design.ISIproportions = [0.1 0.3 0.3 0.3];
    design.ISItrials      = design.numTrials*design.ISIproportions;
    design.ISIvector      = [t.ISI(1)*ones(design.ISItrials(1),1);...
        t.ISI(2)*ones(design.ISItrials(2),1);...
        t.ISI(3)*ones(design.ISItrials(3),1);...
        t.ISI(4)*ones(design.ISItrials(4),1)];
    
    trialMat(:,6) = Shuffle(design.ISIvector);
    design.tiltMatrix = [randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1);randsample([-1 1],design.numTrials,1)]';
    design.tiltMatrix = [design.runCoding design.tiltMatrix];
    
    t.numofUniqueEvents = 7; % T1 to T7
    t.stimType = repmat((1:t.numofUniqueEvents)', design.numTrials, 1);
    trial.TR   = 1;
    trial.T1   = repmat(t.fixation, design.numTrials, 1);
    trial.T2   = repmat(t.preCue, design.numTrials, 1);
    trial.T3   = trialMat(:,5);  % Mapping stim --
    trial.T4   = trialMat(:,6);
    trial.T5   = repmat(t.gaborDisplay, design.numTrials, 1);
    trial.T6   = repmat(t.ISI2, design.numTrials,1);
    trial.T7   = repmat(t.responseDur,design.numTrials,1);
    trial.T8   = repmat(t.feedbackDur,design.numTrials,1);
    
    t.trialDur = [trial.T1 ,trial.T2, trial.T3,trial.T4,trial.T5,trial.T6,trial.T7,trial.T8];
    
    % This part of the script recalculates trial durations in order to reduce
    % the overall jitter and have the timings more clean within one run. The
    % milliseconds are added to or subtracted from the response time. The response time ranges between
    % 1800 ms to 2250 ms
    
    for idx = 1:length(t.trialDur)
        t.trialDur(idx,9) = sum(t.trialDur(idx,1:8));
    end
    
    t.meanTrialDur = mean((t.trialDur(:,9))); % Here mean is 4.56, and the rounding up and down threshold was already
    % 4.5 due to the distribution of trial durations. Therefore, I'm using the
    % mean.
    
    for idx = 1:length(t.trialDur)
        if t.trialDur(idx, 9) < t.meanTrialDur
            if t.trialDur(idx,9)  < 4
                t.trialDur(idx,7)  = t.trialDur(idx,7) + 4 - t.trialDur(idx,9);
            elseif t.trialDur(idx, 9) > 4
                t.trialDur(idx,7)  = t.trialDur(idx,7) - (t.trialDur(idx,9) - 4);
            end
        else
            if t.trialDur(idx,9)  < 5
                t.trialDur(idx,7)  = t.trialDur(idx,7) + 5 - t.trialDur(idx,9);
            elseif t.trialDur(idx, 9) > 5
                t.trialDur(idx,7)  = t.trialDur(idx,7) - (t.trialDur(idx,9) - 5);
            end
        end
    end
    
    % Check and calculate the new trial durations:
    for idx = 1:length(t.trialDur)
        t.trialDur(idx,9) = sum(t.trialDur(idx,1:8));
    end
    
    % Replace the new response times with the old ones
    trial.T7(:) = t.trialDur(:,7);
    
    % Make the stimulus event durations matrix:
    startHere = 1;
    endHere   = t.numofUniqueEvents;
    
    for idx = 1:design.numTrials
        temp = [t.fixation, t.preCue, trial.T3(idx,1), trial.T4(idx,1), t.gaborDisplay, t.ISI2, trial.T7(idx,1)+t.feedbackDur]';
        t.allTimings(startHere:endHere,1) = temp;
        startHere = startHere + t.numofUniqueEvents;
        endHere = endHere + t.numofUniqueEvents;
    end
    
    t.totalTime           = sum(t.allTimings);
    t.allEvents           = [t.stimType t.allTimings];
    t.numRuns             = design.numRuns;
    t.numTrials           = design.numTrials;
    t.numTrialsperRun     = t.numTrials/t.numRuns;
    t.numEventsinBlock    = t.numTrialsperRun*t.numofUniqueEvents;
    t.eventType           = t.allEvents(1:t.numEventsinBlock)';
    t.runDuration         = round(t.totalTime/t.numRuns);
    output.TotalTRs       = t.runDuration/t.TR;
    
    t.runSingleTime       = reshape(t.allEvents(:,2), t.numEventsinBlock, t.numRuns);
    t.runAbsTime          = cumsum(t.runSingleTime, 1);
    
    output.timing = t.runAbsTime; % gives 234 TRs in each run
end
%% MAKE STIMULI
% Gabors
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


%% Wait for trigger
colorMat = stim.neutralCue;
my_fixationCross(window , stim, w, colorMat);
% Screen('DrawText',window,'fixate on the center', w.xCenter,w.yCenter + w.yCenter*0.1 ,[0 0 0]*255);
Screen('Flip', window);

triggerKey = KbName('5%');
if Scan 
    KbTriggerWait(triggerKey, deviceNumber);
    fprintf('Trigger detected \n')
else
    GetClicks;
end

%% Set the block information
currentTimings  = t.runAbsTime(:,currentRun);
currentTrialMat = trialMat(trialMat(:,1) == currentRun,:); % might not be needed
if pilot == 1
    currentTrialMat(:, 3) = 5;
end
%  currentTrialMat(:, 2) = [repmat(12,1,52)]';
currentTiltMat  = design.tiltMatrix(design.tiltMatrix(:,1) == currentRun,:);currentTiltMat(:,1) = [];
%% Initialize block variables
% preallocate
if currentRun == 1
    output.responses = zeros(t.numTrialsperRun, 7);
end
currentTrial    = 0;
output.realTime = zeros(t.numofUniqueEvents, t.numTrialsperRun);

% start recording responses
PsychHID('KbQueueCreate', deviceNumber);
PsychHID('KbQueueStart', deviceNumber);

startTime = GetSecs; %maybe use time
t.bufferTime = 0.005;
output.responseStart =[];
output.vblMapping  = [];

for idx = 1:length(t.eventType)
    if t.eventType(idx) == 1
        currentTrial = currentTrial + 1;
    end
    
    if currentRun == 1
        cumulativeTrial = currentTrial;
    else
        cumulativeTrial = ((currentRun-1) * t.numTrialsperRun) + currentTrial;
    end
    
    currentEvent           = t.eventType(idx);
    currentMappingLocation = currentTrialMat(currentTrial, 2);
    preCue                 = currentTrialMat(currentTrial, 3);
    responseCue            = currentTrialMat(currentTrial, 4);
    drawCW_CCW             = currentTiltMat(currentTrial,:);
    responseON = false;
    countPasses= 1;
    
    % Draws the mapping stimulus when the event type is called
    % Mapping stim comes first in the loop because it should be at the
    % back of the display when flipped.
    if  currentEvent == 3
        
        vblMapping = myMappingStim(window, currentTrialMat, currentTrial, MappingStim, stim, w, preCue);
        output.vblMapping = [output.vblMapping vblMapping(1) - startTime];
    end
    
    % Placeholders come the second, they are there independent of any
    % stim indexing
    squarePlaceHolders(stim, window);
    
    % Draws the fixation cross when the event type is called
    if currentEvent == 1
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

        thresholdValues = [10 10 10 10]; % Made up for now
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
            [keyIsDown, seconds, keyCode] = KbCheck;
            if seconds - tStart > t2wait - t.bufferTime
                answer = 99;
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
        elseif answer ~= 99 &&  drawCW_CCW(responseCue) ~= answer
            colorMat = stim.incorrAns*255;
        elseif answer == 99
            colorMat = stim.lateAnswer;
        end
        disp(answer) %% remove later
        my_fixationCross(window, stim , w, colorMat);
        squarePlaceHolders(stim, window);
        responseVBL = Screen('Flip',window);
        
        
        % this is to assure an equal response window
        
        if answer ~= 99
            WaitSecs(t2wait - reactionTime + t.feedbackDur)
        else
            WaitSecs(t.feedbackDur)
        end
        
        output.responseStart = [output.responseStart tStart-startTime];
        % independent of the RT
        
        output.responses(cumulativeTrial,:) = [currentRun, currentTrial, currentMappingLocation, responseCue, drawCW_CCW(responseCue), answer, reactionTime];
    end
    
    my_fixationCross(window, stim , w, colorMat);
    squarePlaceHolders(stim, window);
    vbl = Screen('Flip', window); % write this into a function or a matrix
    
    output.realTime(currentEvent,currentTrial) = vbl - startTime;
    
    if ~responseON
        while true
            if GetSecs - startTime > t.runAbsTime(idx, currentRun) - t.bufferTime
                break
            end
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
PsychHID('KbQueueStop', deviceNumber);
ShowCursor;
Priority(0);


% %% plot the timing
output.realTime(3,:) = output.vblMapping;
output.realTime(6,:) = output.responseStart;
output.realTime = output.realTime(:);
output.realTimeFull(:,currentRun) = output.realTime;
% output.realTime(:,2) = [0; t.runAbsTime(1:end-1,1)];
% figure;
% subplot(1,2,1)
% scatter(output.realTime(:,1),output.realTime(:,2))
% subplot(1,2,2)
% stem(output.realTime(:,1)-output.realTime(:,2))


if Scan == 1 && currentRun == 10
    %%% SAVE OUT THE DATA FILE
    data.w = w;
    data.t = t;
    data.stim = stim;
    data.output = output;
    save(sprintf('%s_ses-%s_task-%s_data.mat', output.Subject, session, task), 'data');
end


