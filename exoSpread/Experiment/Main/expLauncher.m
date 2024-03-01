%% General experiment launcher %%
% PROJECT NAME: exoSpread
% Last edit : 08/2023
% Modified by : Ekin Tuncok
clear all
clc

% General settings
const.expName      = 'exoSpread';          % experiment name and folder
const.eyeMvt       = 1;
const.expStart = 0;
const.in_R2 = 0;

if const.in_R2 == 1
    const.path2project =  '/Users/purplab/Documents/Experiments/Ekin/exoSpread';
    oneScreenOnly = 0;
else
    oneScreenOnly = 1;
    const.path2project = '/Volumes/purplab/EXPERIMENTS/1_Current_Experiments/Ekin/exoSpread';
end

cd(const.path2project);
addpath(genpath('/Applications/Psychtoolbox'))
addpath(genpath('./'))
sca;
% Initial setting
% Here we call some default settings for setting up Psychtoolbox
%PsychDefaultSetup(2);
home;ListenChar(1);tic;

% Get the screen numbers
screens = Screen('Screens');
scr.main = max(screens);

const.nbDebugTrials = false; % number of trials (for debugging)
if oneScreenOnly == 1 && const.expStart == 0
    PsychDebugWindowConfiguration(0,0.40);
    const.expStart     = 0;
    const.eyeMvt       = 0;
end

const.practiceRound = input('>> practice (1) or no practice (0)?');
if const.practiceRound == 0
    const.task = input('>> staircase (1) or main experiment (2)?');
else
    const.task = 2;
end

if const.task == 1
    const.staircase_calibration = input('>> calibration (1) or no calibration (0)?');
end

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
const.numBlockTot  = 8;                    % total number of block before analysis

% Subject configuration :
if const.expStart
    const.sjct = input(sprintf('\n\tInitials: '),'s');
    const.sjctCode = sprintf('%s_%s',const.sjct,const.expName);
    if const.task == 1
        const.fromBlock = 0;
    else
        const.fromBlock = input(sprintf('\n\tFrom Block nb: '));
    end
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
commandwindow;
main(const);clear expDes % go to real experiment
