function instructionsFB(scr,const,my_key,imName)
% ----------------------------------------------------------------------
% instructionsFB(scr,const,my_key,imName,tEnd,fb)
% ----------------------------------------------------------------------
% Goal of the function :
% Display .tif file instructions and provide feedback "on top"
% ----------------------------------------------------------------------
% Input(s) :
% scr : main window pointer.
% const : struct containing all the constant configurations.
% imName : name of the file image to display
% tEnd : feedback / instruction duration (in s)
% fb : structure containing feedback info
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by by Nina HANNING (hanning.nina@gmail.com)
% based on a template by Martin SZINTE (martin.szinte@gmail.com)
% edited by Maya AGDALI
% Last update : 2021-07-08
% Project : ppSacApp
% Version : 3.0
% ----------------------------------------------------------------------
while KbCheck; end
KbName('UnifyKeyNames');
dirImageFile = '/Instructions/Image/';
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