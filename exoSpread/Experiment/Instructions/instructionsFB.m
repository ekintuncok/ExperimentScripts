function instructionsFB(scr,const,my_key,imName)

while KbCheck; end
KbName('UnifyKeyNames');
dirImageFile = [const.path2project, '/Experiment', '/Instructions/Image/'];
dirImage = [dirImageFile,imName,'.tiff'];

% if exist(dirImage) % Display image
imageToDraw =  imread(dirImage);
t_handle = Screen('MakeTexture',scr.main,imageToDraw);

push_button = 0;
while ~push_button
    
    Screen('FillRect',scr.main,const.gray);
    Screen('DrawTexture',scr.main,t_handle, [], CenterRectOnPoint([0 0 scr.scr_sizeX scr.scr_sizeY],scr.x_mid,scr.y_mid));
    
    Screen('Flip',scr.main);
    
    [ keyIsDown, ~, keyCode ] = KbCheck(scr.deviceNumber);
    if keyIsDown
        if keyCode(my_key.space)
            push_button=1;
        elseif keyCode(my_key.escape) && ~const.expStart
            overDone;
        end
    end
end
end