function overDone(const)
% ----------------------------------------------------------------------
% overDone
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen, listen keyboard and save duration of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------

ListenChar(1);
%WaitSecs(2.0);

if const.eyeMvt
    statRecFile = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
    
    if statRecFile ~= 0
        fprintf(1,'\n\tEyelink EDF file correctly transfered');
    else
        fprintf(1,'\n\Error in Eyelink EDF file transfer');
        statRecFile2 = Eyelink('ReceiveFile',const.edffilename,const.edffilename);
        if statRecFile2 == 0
            fprintf(1,'\n\tEyelink EDF file is now correctly transfered');
        else
            fprintf(1,'\n\n\t!!!!! Error in Eyelink EDF file transfer !!!!!');
            my_sound(9,aud);
        end
    end
    Eyelink('CloseFile');
    WaitSecs(2.0);
    Eyelink('Shutdown');
    WaitSecs(2.0);
    
    oldDir = 'XX.edf';
    newDir = [const.subj_output_dir, sprintf('/%s_B%i.edf',const.sjct,const.fromBlock)];
    movefile(oldDir,newDir);
end


ShowCursor;
%Screen('CloseAll');
sca;
timeDur=toc/60;
fprintf(1,'\nTotal time : %2.0f min.\n\n',timeDur);

%PsychPortAudio('Stop', const.pahandle);
%PsychPortAudio('Close', const.pahandle); %added

clear mex;
clear fun;

end

