function drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% drawTrialInfoEL(scr,const,expDes,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a box on the eyelink display.
% Modified for the fixation task
% ----------------------------------------------------------------------
% Input(s) :
% scr = window pointer
% const = struct containing constant configurations
% expDes = struct containing experiment design
% t : trial meter
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Nina HANNING (hanning.nina@gmail.com)
% Last update : 2021-07-11
% Project : ppSacApp
% Version : 4.0
% ----------------------------------------------------------------------

% o--------------------------------------------------------------------o
% | EL Color index                                                     |
% o---------------------------------o----------------------------------o
% | Nb |  Other(cross,box,line)     | Clear screen                     |
% o---------------------------------o----------------------------------o
% |  0 | black                      | black                            |
% o---------------------------------o----------------------------------o
% |  1 | dark blue                  | dark dark blue                   |
% o----o----------------------------o----------------------------------o
% |  2 | dark green                 | dark blue                        |
% o----o----------------------------o----------------------------------o
% |  3 | dark turquoise             | blue                             |
% o----o----------------------------o----------------------------------o
% |  4 | dark red                   | light blue                       |
% o----o----------------------------o----------------------------------o
% |  5 | dark purple                | light light blue                 |
% o----o----------------------------o----------------------------------o
% |  6 | dark yellow (brown)        | turquoise                        |
% o----o----------------------------o----------------------------------o
% |  7 | light gray                 | light turquoise                  |
% o----o----------------------------o----------------------------------o
% |  8 | dark gray                  | flashy blue                      |
% o----o----------------------------o----------------------------------o
% |  9 | light purple               | green                            |
% o----o----------------------------o----------------------------------o
% | 10 | light green                | dark dark green                  |
% o----o----------------------------o----------------------------------o
% | 11 | light turquoise            | dark green                       |
% o----o----------------------------o----------------------------------o
% | 12 | light red (orange)         | green                            |
% o----o----------------------------o----------------------------------o
% | 13 | pink                       | light green                      |
% o----o----------------------------o----------------------------------o
% | 14 | light yellow               | light green                      |
% o----o----------------------------o----------------------------------o
% | 15 | white                      | flashy green                     |
% o----o----------------------------o----------------------------------o

%% Colors
fixCol          = 10;
stimFrmCol      = 15;  %white
textCol         = 15;  %white
BGcol           =  0;  %black


%% Variables
blocknum  = const.fromBlock;
trialID   = expDes.expMat(t, 2);
% tDir 	  = expDes.expMat(t, 6);   % rand1: tilt direction (-1 left, 1 right)
% cueDir    = expDes.expMat(t, 8);   % rand4: cue direction (1=left, 2=neutral, 3=right)
% gabC      = expDes.expMat(t,11);   % rand7: gabor contrast
% tstPos    = expDes.expMat(t,13);   %        test position (1=left, 2=middle, 3=right)
% stdPos    = expDes.expMat(t,14);   %        standard position (1=left, 2=middle, 3=right)


%% Clear Screen :
eyeLinkClearScreen(BGcol);


%% Draw Stimulus

% Fixation target & boundary
eyeLinkDrawBox(scr.x_mid,scr.y_mid,const.sideFP_val*2,const.sideFP_val*2,2,[],fixCol);
eyeLinkDrawBox(scr.x_mid,scr.y_mid,const.sideFP_X*2,const.sideFP_X*2,1,fixCol,[]);


% Two lines of text during trial (slow process)
% corT = expDes.corTrial;
% remT = expDes.iniEndJ - expDes.corTrial;
% 
txtVal = {'THRESH','MAIN'};
% 
% text0 = sprintf('tCor=%3.0f | tRem=%3.0f | Block=%3.0f (%s) | TrialID=%3.0f | Contr=%1.3f',corT,remT,blocknum,txtVal{const.task},trialID);
text0 = sprintf('tCor=%3.0f | tRem=%3.0f | Block=%3.0f (%s) | TrialID=%3.0f | Contr=%1.3f',blocknum,txtVal{const.task},trialID);

eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 30,textCol,text0);
WaitSecs(0.1);

end