function vblMapping = myMappingStim(window, currentTrialMat, currentTrial, MappingStim, stim, w, preCue, eyeTrackON)


mappingStimStart = GetSecs;
currentMappingLocation = currentTrialMat(currentTrial, 2);

if currentTrialMat(currentTrial, 5) == 1
    numOfCarriers = 1:4;
else
    numOfCarriers = 1:8;
end

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

currentTrialCarriers = randsample(numOfCarriers, numel(numOfCarriers), false);
durMat        = [0 repmat(stim.mappingStimFlickerDur, 1, (numel(numOfCarriers)-1))];
flipTime      = mappingStimStart + cumsum(durMat);
vblMapping    = zeros(size(durMat, 2),1);

for mappingInd = 1:length(currentTrialCarriers)
    
    image = MappingStim(currentTrialCarriers(mappingInd)).textureHandles{currentMappingLocation};
    Screen('DrawTexture', window, image, [], CenterRectOnPoint([0 0 stim.mappingStimDiameter stim.mappingStimDiameter], w.xCenter, w.yCenter));
    squarePlaceHolders(stim, window);
    my_fixationCross(window, stim , w, colorMat);
    
    vblMapping(mappingInd) = Screen('Flip', window, flipTime(mappingInd));
    if mappingInd == 1 && eyeTrackON
        Eyelink('Message', 'MAPPINGSTIMSTART');
    end
    while true
        if GetSecs - mappingStimStart > stim.mappingStimFlickerDur - 0.005
            break
        end
    end
end