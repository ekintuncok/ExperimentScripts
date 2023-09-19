function complete  = my_Gabor(scr, Xposition, Yposition, const, angle, fixation)

% Get the centre coordinate of the window
[x, y] = RectCenter(scr.rect);
xCenter = x;
yCenter = y;
f = (const.gaborSF/scr.ppd);
cyclesPerSecond = 2;
gratingsize = const.gaborDim_xpix;
movieDurationSecs=const.T4;  
inc=const.white-const.gray;
texsize = gratingsize / 2;
filter_param = mean(texsize)/2;
p=ceil(1/f);
fr=f*2*pi;
visibleSize = 2 * texsize + 1;
x = meshgrid(-texsize:texsize + p, 1);
contrast = 0.16;
grating = const.gray+(inc*contrast)*sin(fr*x);
gratingtex = Screen('MakeTexture', scr.main , grating);
mask=ones(2*texsize+1, 2*texsize+1, 2) * const.gray;
[x,y]=meshgrid(-1*texsize:1*texsize,-1*texsize:1*texsize);
mask(:, :, 2)= round(const.white * (1 - exp(-((x/filter_param).^2)-((y/filter_param).^2))));
masktex=Screen('MakeTexture', scr.main, mask);

priorityLevel=MaxPriority(scr.main);
dstRect = zeros(4, const.num_locations);

for ii = 1:const.num_locations
    xDist = xCenter+Xposition(ii)-(visibleSize/2);
    yDist = yCenter+Yposition(ii)-(visibleSize/2);
    dstRect(:,ii) =[xDist yDist visibleSize+xDist visibleSize+yDist];
end

% Query duration of one monitor refresh interval:
ifi=Screen('GetFlipInterval', scr.main);

% We set PTB to wait one frame before re-drawing
waitframes = 1;

% Calculate the wait duration
waitDuration = waitframes * ifi;

% Recompute pixPerCycle, this time without the ceil() operation from above.
% Otherwise we will get wrong drift speed due to rounding errors
pixPerCycle = 1 / f;

% Translate requested speed of the grating (in cycles per second) into
% a shift value in "pixels per frame"
shiftPerFrame = cyclesPerSecond * pixPerCycle * waitDuration;

% Perform initial Flip to sync us to the VBL and for getting an initial
% VBL-Timestamp as timing baseline for our redraw loop:
vbl=Screen('Flip', scr.main);
% We choose an arbitary value at which our Gabor will drift
end_frame = vbl + movieDurationSecs;

frameCounter = 0;
ii = 1;
while (vbl < end_frame) && fixation

    if const.eyeMvt
        fixation = initEyelinkStates('fixcheck', scr.main, {scr.x_mid, scr.y_mid, scr.rad});
    end
    if ~ fixation
        DrawFormattedText(scr.main, sprintf('Please fixate'), 'center', 'center')
        Screen('Flip', scr.main); WaitSecs(1)
        complete = 0;
        return
    end


    xoffset = mod(frameCounter * shiftPerFrame, pixPerCycle);
    frameCounter = frameCounter + 1;
    srcRect = [xoffset 0 xoffset + visibleSize visibleSize];
    ii = ii + 1;
    my_fixationCross(scr,const);
    Screen('DrawTextures', scr.main, repelem(gratingtex, 1 ,const.num_locations), srcRect, dstRect, angle);
    Screen('DrawTextures', scr.main, repelem(masktex, 1 ,const.num_locations), [0 0 visibleSize visibleSize], dstRect, angle);
    vbl = Screen('Flip', scr.main, vbl + (waitframes - 0.5) * ifi);
end

complete = 1;

end



