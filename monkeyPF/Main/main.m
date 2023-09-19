                            function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Main code of experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing subject information and saving files.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 01 / 2014
% Project : Yeshurun98
% Version : -
% ----------------------------------------------------------------------

% File directory :
[const] = dirSaveFile(const);

% Screen configuration :
[scr] = scrConfig(const);

% Keyboard configuration :
[my_key] = keyConfig;

% Experimental constant :
[const] = constConfig(scr,const);

% Experimental design configuration :
[expDes] = designConfig(const);

% Instruction file :
[textExp,button] = instructionConfig;

% Open screen window :
% Set up alpha-blending for smooth (anti-aliased) lines
PsychImaging('PrepareConfiguration');
[scr.main, scr.rect] = Screen('OpenWindow', scr.scr_num, const.gray);
Screen('BlendFunction',scr.main, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Initialise EyeLink :
if const.eyeMvt
    [el,const] = initEyeLink(scr,const);
else
    el = [];
end

% Main part :
if const.expStart;ListenChar(2);end

GetSecs;
if const.task == 1
    [Output, StaircaseOutput] = runTrials(scr,const,expDes,el,my_key,textExp,button);
    save([const.subj_output_dir, '/', const.Output],'Output');
    save([const.subj_output_dir, '/', const.staircase],'StaircaseOutput');
else
    [Output] = runTrials(scr,const,expDes,el,my_key,textExp,button);
    save([const.subj_output_dir, '/', const.Output],'Output');
end

save([const.subj_output_dir, '/', const.const_fileMat],'const');

% End
overDone(const);
end