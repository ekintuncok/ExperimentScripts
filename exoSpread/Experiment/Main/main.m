function main(const)

% set the directories:
const.output_dir = fullfile(const.path2project, 'Data');

if ~isfolder([const.output_dir, '/', const.sjct])
    mkdir(sprintf('Data/%s',const.sjct));
end

% current block output name and directory to be saved:
if const.task == 1 && const.practiceRound == 0
    const.subj_output_dir = [const.output_dir, '/', const.sjct, '/titration_block'];
elseif const.task == 2 && const.practiceRound == 0
    const.subj_output_dir = [const.output_dir, '/', const.sjct, sprintf('/block%i',const.fromBlock)];
elseif const.practiceRound == 1
    const.subj_output_dir = [const.output_dir, '/', const.sjct, '/practice_trials'];
end

if ~isfolder(const.subj_output_dir)
    mkdir(const.subj_output_dir);
end

% Screen configuration :
[scr] = scrConfig(const);

% Keyboard configuration :
[my_key] = keyConfig;

% Experimental constant :
[const, staircase] = constConfig(scr,const);

% Experimental design configuration :
[expDes] = designConfig(const);

% Instruction file :
[textExp, button] = instructionConfig;

% Open screen window :
% Set up alpha-blending for smooth (anti-aliased) lines
PsychImaging('PrepareConfiguration');
[scr.main, scr.rect] = Screen('OpenWindow', scr.scr_num, const.gray);
Screen('BlendFunction',scr.main, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% initialise EyeLink :
if const.eyeMvt
    [el,const] = initEyeLink(scr,const);
else
    el = [];
end

% Main part :
if const.expStart;ListenChar(2);end

GetSecs;
output = runTrials(scr, const, expDes, el, staircase, my_key, textExp, button);

% save the output
save([const.subj_output_dir, '/', const.const_fileMat],'const');
if const.task == 1 && const.practiceRound == 0
    save([const.subj_output_dir, '/', const.Output],'output');
elseif const.task == 2 && const.practiceRound == 0
    save([const.subj_output_dir, '/', const.Output],'output');
elseif const.practiceRound == 1
    save([const.subj_output_dir, '/', const.Output],'output');
end
% End
overDone(const);
end