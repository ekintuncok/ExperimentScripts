function [const, staircase]=constConfig(scr,const)

% Instructions
const.text_size = 20;
const.text_font = 'Helvetica';

% Color Configuration :
const.white = WhiteIndex(scr.scr_num);
const.black = BlackIndex(scr.scr_num);
const.gray  = GrayIndex(scr.scr_num);

const.red            = [200, 0, 0]; % Feedback inaccurate answer
const.green          = [0, 200, 0]; % Feedack accurate answer
const.blue           = [0, 0, 200]; % Feedback missed fixation
const.orange         = [255, 150, 0]; % Feedback response registered late (>2)
const.corrAns        = [const.green];
const.incorrAns      = [const.red];
const.missedFixation = [const.blue];
const.lateAnswer     = [const.orange];

% Time
const.my_clock_ini = clock;
const.num_locations = 8;

% Fixation cross
const.sideFP_val       = 0.2;         [const.sideFP_X,const.sideFP_Y] = vaDeg2pix(const.sideFP_val,scr);
const.thicknessFP_val  = 0.05;       [const.thicknessFP_X,const.thicknessFP_Y] = vaDeg2pix(const.thicknessFP_val,scr);
const.thicknessFP_X    = ceil(const.thicknessFP_X);

% Attentional cue:
const.cue_size_deg = 0.2;
[const.cue_size_xpix, const.cue_size_ypix] = vaDeg2pix(const.cue_size_deg ,scr);
const.cue_size = repmat(const.cue_size_xpix, 1, const.num_locations*4);
const.cue_radius_from_stimcenter = 2; % in degrees
% Eccentricity
const.gaborEcc = [3, 9]; % for cardinal locations
[const.gaborEcc_xpix, const.gaborEcc_ypix] = vaDeg2pix(const.gaborEcc ,scr);

% Spatial Frequency and contrast:
const.gaborContrast = 0.5;
const.gaborSF = 3; % cycles per degree (visual angle dist)
[xpix_in_VA, ypix_in_VA] = vaDeg2pix(const.gaborSF ,scr);
const.gaborSF_xpix       = 1/xpix_in_VA;
const.gaborSF_ypix       = 1/ypix_in_VA;

% Dimensions:
const.gaborSize           = 2; %in visual angles
[const.gaborDim_xpix,const.gaborDim_ypix] =  vaDeg2pix(const.gaborSize,scr);
const.gaborDim_xpix = round(const.gaborDim_xpix);
const.gaborDim_ypix = round(const.gaborDim_ypix);
const.texSize = const.gaborDim_xpix/2;
const.visible_size = 2 * const.texSize + 1;
const.gaborfwhm     = 1;        % full width at half maximum; fwhm also used in previous studies
const.gaborEnvSDeg  = const.gaborfwhm./(sqrt(8*log(2))); % desired standard deviation of gabor envelope in degree
const.gaborWidth    = const.gaborSize/(const.gaborEnvSDeg*4*pi);

% Gabor Locations:
const.angles = [0, 90, 180, 270];
const.angles_in_rad = deg2rad(const.angles);

[const.xDist, const.yDist] = pol2cart(reshape(repmat(const.angles_in_rad,const.num_locations/4,1), const.num_locations,[])',...
    repmat(const.gaborEcc_xpix, 1, const.num_locations/2));

% assign placeholder locations:
const.placeholders_loc = [];
for plchldr = 1:length(const.xDist)
    
    plchldr_lc(1, :) = [const.xDist(plchldr) + 1.2*scr.ppd; const.yDist(plchldr) + 1.2*scr.ppd];
    plchldr_lc(2, :) = [const.xDist(plchldr) + 1.2*scr.ppd; const.yDist(plchldr) - 1.2*scr.ppd];
    plchldr_lc(3, :) = [const.xDist(plchldr) - 1.2*scr.ppd; const.yDist(plchldr) + 1.2*scr.ppd];
    plchldr_lc(4, :) = [const.xDist(plchldr) - 1.2*scr.ppd; const.yDist(plchldr) - 1.2*scr.ppd];

    const.placeholders_loc = [const.placeholders_loc; plchldr_lc];
    plchldr_lc = zeros(4, 2);
end

for ii = 1:const.num_locations
    xDist_temp = scr.mid(1)+ const.xDist(ii) - (const.visible_size/2);
    yDist_temp = scr.mid(2)+ const.yDist(ii) - (const.visible_size/2);
    const.dest_rect(:,ii) = [xDist_temp yDist_temp const.visible_size+xDist_temp const.visible_size+yDist_temp];
end

const.src_rect = [0 0 const.visible_size const.visible_size];

% Create Gabor texture:
const.distractor_Gabor_ori = 0;
[const.x, const.y]=meshgrid(1:const.gaborDim_xpix, 1:const.gaborDim_xpix);
const.x =  const.x-mean( const.x(:));
const.y =  const.y-mean( const.y(:));
const.x = Scale( const.x)*const.gaborSize-const.gaborSize/2;
const.y = Scale( const.y)*const.gaborSize-const.gaborSize/2;

const.ori  = const.distractor_Gabor_ori/180*pi;
const.nx   = const.x*cos(const.ori) +  const.y*sin(const.ori);
const.modula = exp(-((const.x/const.gaborWidth).^2)-((const.y/const.gaborWidth).^2));

% Experimental timing
const.T1  = 0.6; % fixation
const.T2  = 0.04; % pre-cue
const.T3  = 0.1; % ISI
const.T4  = 0.1; % target display
const.T5  = 0.1; % ISI
const.T6  = 0.1; % response cue

const.numFrm_T1  =  round(const.T1/scr.frame_duration);
const.numFrm_T2  =  round(const.T2/scr.frame_duration);
const.numFrm_T3  =  round(const.T3/scr.frame_duration);
const.numFrm_T4  =  round(const.T4/scr.frame_duration);
const.numFrm_T5  =  round(const.T5/scr.frame_duration);
const.numFrm_T6  =  round(const.T6/scr.frame_duration);

const.numFrm_T1_start  = 1;
const.numFrm_T1_end    =  const.numFrm_T1_start  + const.numFrm_T1-1;

const.numFrm_T2_start  = const.numFrm_T1_end+1;
const.numFrm_T2_end    =  const.numFrm_T2_start  + const.numFrm_T2-1;

const.numFrm_T3_start  = const.numFrm_T2_end + 1;
const.numFrm_T3_end    =  const.numFrm_T3_start  + const.numFrm_T3-1;

const.numFrm_T4_start  = const.numFrm_T3_end+1;
const.numFrm_T4_end    =  const.numFrm_T4_start  + const.numFrm_T4-1;

const.numFrm_T5_start  = const.numFrm_T4_end+1;
const.numFrm_T5_end    =  const.numFrm_T5_start  + const.numFrm_T5-1;

const.numFrm_T6_start  = const.numFrm_T5_end+1;
const.numFrm_T6_end    =  const.numFrm_T6_start  + const.numFrm_T6-1;

const.numFrm_Tot =  const.numFrm_T1 + const.numFrm_T2 + const.numFrm_T3 + const.numFrm_T4 + const.numFrm_T5 + const.numFrm_T6;

% Eyelink fixation check setting

const.timeOut = 0.5;    % maximum eye fixation check time
const.tCorMin = 0.200;  % minimum correct eye fixation time

% Defines saving file names
const.const_fileMat =       sprintf('%s_const_file.mat',const.sjctCode);
const.expRes_fileCsv =      sprintf('%s_expRes.csv',const.sjctCode);
const.design_fileMat =      sprintf('%s_design.mat',const.sjctCode);
const.titration_design_fileMat =      sprintf('%s_titration_design.mat',const.sjctCode);
const.Output =              sprintf('%s_Output.mat',const.sjctCode);
const.staircase =           sprintf('%s_staircaseOutput.mat',const.sjctCode);

% .mat file
save([const.subj_output_dir, '/', const.const_fileMat],'const');

if const.task == 1
    staircase.whichStair        = 1; % QUEST = 2, bestPEST = 1;
    staircase.currStair         = 8;
    staircase.alphaRange        = [0.25:0.2:3, 3.5:0.25:15];
    staircase.fitBeta           = 2; % slope
    staircase.fitLambda         = 0.01; % lapse rate
    staircase.fitGamma          = 0.5; % guess rate
    staircase.PF                = @arbWeibull;
    staircase.threshPerformance = 0.80; % performance
    
    if const.staircase_calibration == 1
        staircase.updateAfterTrial = 10;
        staircase.preUpdateLevels = randi(45, 1, staircase.updateAfterTrial);
    end
    staircase.data = repmat(usePalamedes(staircase), const.num_locations, 1);
    
    fprintf('\nCreated the staircase parameters! \n');
    
elseif const.task == 2
    staircase = [];
    if exist(sprintf([const.output_dir '/%s/titration_block/%s_Output.mat'],const.sjct, const.sjctCode), 'file')
        load(sprintf([const.output_dir '/%s/titration_block/%s_Output.mat'],const.sjct, const.sjctCode));
        fprintf('>> Successfully loaded the staircase files. \n');
        const.numOfStaircases = const.num_locations;
        for loc = 1:const.numOfStaircases
            const.gaborOri(loc) =  output.staircase.data(loc).mean;
        end
        fprintf('>> Threshold levels are set to: %f\n', const.gaborOri)
    else
        const.gaborOri  = [10 12 15 14 18 12 17 20];
        if const.practiceRound == 0
            fprintf('>> WARNING! Couldn''t fetch the staircase file!\n');
        elseif const.practiceRound == 1
            fprintf('>> Using a predetermined set of tilt angles for the sake of practice round!\n');
        end
    end
end
end