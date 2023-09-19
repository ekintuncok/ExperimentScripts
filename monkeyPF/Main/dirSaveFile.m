function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const]=dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Ekin T
% Last update : 06/2023
% Project : MonkeyPF
% Version : -
% ----------------------------------------------------------------------

output_dir = fullfile(const.path2project, 'Data');

if ~isfolder([output_dir, '/', const.sjct])
    mkdir(sprintf('Data/%s',const.sjct));
end
subj_output_dir = [output_dir, '/', const.sjct, sprintf('/Block%i',const.fromBlock)];

if ~isfolder(subj_output_dir)
    mkdir(subj_output_dir);
end

const.subj_output_dir = subj_output_dir;
% Defines saving file names
%const.scr_fileDat =         sprintf('%s_scr_file.dat',const.sjctCode);
const.scr_fileMat =         sprintf('%s_scr_file.mat',const.sjctCode);
%const.const_fileDat =       sprintf('%s_const_file.dat',const.sjctCode);
const.const_fileMat =       sprintf('%s_const_file.mat',const.sjctCode);
const.expRes_fileCsv =      sprintf('%s_expRes.csv',const.sjctCode);
const.design_fileMat =      sprintf('%s_design.mat',const.sjctCode);
const.Output =              sprintf('%s_Output.mat',const.sjctCode);
const.staircase =           sprintf('%s_staircaseOutput.mat',const.sjctCode);

end