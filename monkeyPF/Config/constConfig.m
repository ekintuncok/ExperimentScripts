function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing all constant data.


% Instructions
const.text_size = 20;
const.text_font = 'Helvetica';

% Color Configuration :
const.white = WhiteIndex(scr.scr_num);
const.black = BlackIndex(scr.scr_num);
const.gray  = GrayIndex(scr.scr_num);

const.red            = [1, 0, 0]; % Feedback inaccurate answer
const.green          = [0, 1, 0]; % Feedack accurate answer
const.blue           = [0, 0, 200]; % Feedback missed fixation
const.orange         = [255, 150, 0]; % Feedback response registered late (>2)
const.corrAns        = [const.green];
const.incorrAns      = [const.red];
const.missedFixation = [const.blue];
const.lateAnswer     = [const.orange];

% Time
const.my_clock_ini = clock;

% Fixation cross
const.sideFP_val       = 0.2;         [const.sideFP_X,const.sideFP_Y] = vaDeg2pix(const.sideFP_val,scr);
const.thicknessFP_val  = 0.05;       [const.thicknessFP_X,const.thicknessFP_Y] = vaDeg2pix(const.thicknessFP_val,scr);
const.thicknessFP_X    = ceil(const.thicknessFP_X);

% Gabor:
% Contrast: try different values to maximize performance
if const.practiceRound == 1
    const.gaborContrast = 1;
else
    const.gaborContrast = 0.8;
end

% Eccentricity 
const.gaborEcc = 7; % for cardinal locations
const.gaborEcc_IC = sqrt(const.gaborEcc^2/2);
[const.gaborEcc_xpix, const.gaborEcc_ypix] = vaDeg2pix(const.gaborEcc ,scr);
[const.gaborEcc_xpix_IC, const.gaborEcc_ypix_IC] = vaDeg2pix(const.gaborEcc_IC ,scr);

% Spatial Frequency
const.gaborSF = 2; % cycles per degree (visual angle dist)
[xpix_in_VA, ypix_in_VA] = vaDeg2pix(const.gaborSF ,scr);
const.gaborSF_xpix       = 1/xpix_in_VA; 
const.gaborSF_ypix       = 1/ypix_in_VA; 

% Dimensions:
const.gaborSize           = 2; %in visual angles 
[const.gaborDim_xpix,const.gaborDim_ypix] =  vaDeg2pix(const.gaborSize,scr);
const.gaborDim_xpix = round(const.gaborDim_xpix);
const.gaborDim_ypix = round(const.gaborDim_ypix);

% Gabor Locations:
const.num_locations = 8;
const.angle_offset = 5; % in degrees
const.angle_vals_set1 = [0, 45, 90, 135, 180, 225, 270, 315];
const.angle_vals_set2 = [0, 45, 90, 135, 180, 225, 270, 315] + const.angle_offset;
const.angle_vals_set3 = [0, 45, 90, 135, 180, 225, 270, 315] - const.angle_offset;

const.polarangle_in_rad = [const.angle_vals_set1; const.angle_vals_set2;const.angle_vals_set3];

const.jittered_polar_angle_rad = deg2rad(const.polarangle_in_rad);
[const.xDist, const.yDist] = pol2cart(const.jittered_polar_angle_rad, repmat(const.gaborEcc_xpix, 1, const.num_locations));

% Experimental timing 
const.T1  = 0.6;         
const.T2  = 0.3;       
const.T3  = 0.3;                
const.T4  = 0.5;             
const.T5  = 2;  

const.numFrm_T1  =  round(const.T1/scr.frame_duration);
const.numFrm_T2  =  round(const.T2/scr.frame_duration);
const.numFrm_T3  =  round(const.T3/scr.frame_duration);
const.numFrm_T4  =  round(const.T4/scr.frame_duration);
const.numFrm_T5  =  round(const.T5/scr.frame_duration);

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
const.numFrm_Tot =  const.numFrm_T1 + const.numFrm_T2 + const.numFrm_T3 + const.numFrm_T4;

%% Eylink fixation check setting
% Eye fixation check
const.timeOut = 3.0;    % maximum eye fixation check time
const.tCorMin = 0.200;  % minimum correct eye fixation time
% 
% %% Saving procedure :
% const_file = fopen(const.const_fileMat,'w');
% fprintf(const_file,'Subject initial :\t%s\n',const.sjct);
% if const.fromBlock == 1
%     fprintf(const_file,'Subject age :\t%s\n',const.sjct_age);
%     fprintf(const_file,'Subject gender :\t%s\n',const.sjct_gender);
% end
% fprintf(const_file,'Date : \t%i-%i-%i\n',const.my_clock_ini(3),const.my_clock_ini(2),const.my_clock_ini(1));
% fprintf(const_file,'Starting time : \t%ih%i\n',const.my_clock_ini(4),const.my_clock_ini(5));
% fclose('all');

% .mat file
save([const.subj_output_dir, '/', const.const_fileMat],'const');

end