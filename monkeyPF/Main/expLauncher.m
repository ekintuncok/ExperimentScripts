%% General experiment launcher %%
% PROJECT NAME: Monkey PF
% Last edit : 06/2023
% Modified by : Ekin Tuncok
% Based on a template by Martin Szinte

clear 
clc
const.path2project = '/Users/purplab/Documents/Experiments/Ekin/monkeyPF';
cd(const.path2project);
addpath(genpath('/Applications/Psychtoolbox'))
addpath(genpath('./'))

% Initial setting
% Here we call some default settings for setting up Psychtoolbox
%PsychDefaultSetup(2);
home;ListenChar(1);tic;

% Get the screen numbers
screens = Screen('Screens');
scr.main = max(screens);

% General settings 
const.expName      = 'monkeyPF';          % experiment name and folder
const.expStart     = 0; 
const.eyeMvt       = 1;

const.nbDebugTrials = false; % number of trials (for debugging)
oneScreenOnly =0;
if oneScreenOnly == 1
    PsychDebugWindowConfiguration(0,0.75);
end

cortask = 0;
const.task = 2;
const.practiceRound = 0;

if const.practiceRound == 1
    const.expStart  = 0;
    const.task      = 2;
    const.fromBlock = 99;
    const.eyeMvt    = 0;
end

% Path :
dir = (which('expLauncher'));cd(dir(1:end-18));

% Block definition
numBlockMain = 1;                           % number of block to play per run time
const.numBlockTot  = 10;                    % total number of block before analysis

% Subject configuration :
if const.expStart
    const.sjct = input(sprintf('\n\tInitials: '),'s');
    const.sjctCode = sprintf('%s_%s',const.sjct,const.expName);
    const.fromBlock  = input(sprintf('\n\tFrom Block nb: '));
    if const.fromBlock == 1
        const.sjct_age = input(sprintf('\n\tAge: '));
        const.sjct_gender = input(sprintf('\n\tGender (M or F): '),'s');
    end
else
    const.sjct = 'Anon';const.fromBlock = 1;const.sjct_age = 'XX';const.sjct_gender = 'X';
end


if const.eyeMvt == 1
    const.sjct_DomEye= input(sprintf('\n\tWhich eye will you track (R or L)? Please choose your dominant one : '),'s');
    if strcmp(const.sjct_DomEye,'L');       const.recEye = 1;
    elseif strcmp(const.sjct_DomEye,'R');   const.recEye = 2;
    end
end

const.sjctCode = sprintf('%s_%s',const.sjct,const.expName);
setScreen = Screen('Computer');
const.compName = convertCharsToStrings(setScreen.system);

%% Main experimental code
for block = const.fromBlock:(const.fromBlock+numBlockMain-1)
    const.fromBlock = block;
    commandwindow;
    main(const);clear expDes % go to real experiment
end
