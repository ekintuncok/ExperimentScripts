function squarePlaceHolders(stim, window)

loc1 = stim.gaborUpper; loc2 = stim.gaborLower; loc3 = stim.gaborLeft; loc4 = stim.gaborRight;

% Upper VM
Screen('DrawLine', window , stim.placeHoldersColor, loc1(1), loc1(2), loc1(1)+stim.placeHoldersDistance, loc1(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc1(1), loc1(2), loc1(1), loc1(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc1(1), loc1(4), loc1(1)+stim.placeHoldersDistance, loc1(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc1(1), loc1(4), loc1(1), loc1(4)-stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc1(3), loc1(2), loc1(3)-stim.placeHoldersDistance, loc1(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc1(3), loc1(2), loc1(3), loc1(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc1(3), loc1(4), loc1(3)-stim.placeHoldersDistance, loc1(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc1(3), loc1(4), loc1(3), loc1(4)-stim.placeHoldersDistance, 2);

% Lower VM

Screen('DrawLine', window , stim.placeHoldersColor, loc2(1), loc2(2), loc2(1)+stim.placeHoldersDistance, loc2(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc2(1), loc2(2), loc2(1), loc2(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc2(1), loc2(4), loc2(1)+stim.placeHoldersDistance, loc2(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc2(1), loc2(4), loc2(1), loc2(4)-stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc2(3), loc2(2), loc2(3)-stim.placeHoldersDistance, loc2(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc2(3), loc2(2), loc2(3), loc2(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc2(3), loc2(4), loc2(3)-stim.placeHoldersDistance, loc2(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc2(3), loc2(4), loc2(3), loc2(4)-stim.placeHoldersDistance, 2);

% Left HM

Screen('DrawLine', window , stim.placeHoldersColor, loc3(1), loc3(2), loc3(1)+stim.placeHoldersDistance, loc3(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc3(1), loc3(2), loc3(1), loc3(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc3(1), loc3(4), loc3(1)+stim.placeHoldersDistance, loc3(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc3(1), loc3(4), loc3(1), loc3(4)-stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc3(3), loc3(2), loc3(3)-stim.placeHoldersDistance, loc3(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc3(3), loc3(2), loc3(3), loc3(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc3(3), loc3(4), loc3(3)-stim.placeHoldersDistance, loc3(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc3(3), loc3(4), loc3(3), loc3(4)-stim.placeHoldersDistance, 2);


% Right HM

Screen('DrawLine', window , stim.placeHoldersColor, loc4(1),loc4(2), loc4(1)+stim.placeHoldersDistance, loc4(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc4(1), loc4(2), loc4(1), loc4(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc4(1), loc4(4), loc4(1)+stim.placeHoldersDistance, loc4(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc4(1), loc4(4), loc4(1), loc4(4)-stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc4(3), loc4(2), loc4(3)-stim.placeHoldersDistance, loc4(2), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc4(3), loc4(2), loc4(3), loc4(2)+stim.placeHoldersDistance, 2);

Screen('DrawLine', window , stim.placeHoldersColor, loc4(3), loc4(4), loc4(3)-stim.placeHoldersDistance, loc4(4), 2);
Screen('DrawLine', window , stim.placeHoldersColor, loc4(3), loc4(4), loc4(3), loc4(4)-stim.placeHoldersDistance, 2);

end