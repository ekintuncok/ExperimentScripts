function instructions(scr,const,my_key,text,button)
while KbCheck; end
KbName('UnifyKeyNames');
push_button = 0;
while ~push_button

    Screen('Preference', 'TextAntiAliasing',1);
    Screen('TextSize',scr.main, const.text_size);
    Screen ('TextFont', scr.main, const.text_font);
    Screen('FillRect', scr.main, const.gray);

    sizeT = size(text);
    sizeB = size(button);
    lines = sizeT(1)+sizeB(1)+2;
    bound = Screen('TextBounds',scr.main,button{1,:});
    espace = ((const.text_size)*1.50);
    first_line = scr.y_mid - ((round(lines/2))*espace);

    addi = 0;
    for t_lines = 1:sizeT(1)
        Screen('DrawText',scr.main,text{t_lines,:},scr.x_mid-bound(3)/2,first_line+addi*espace, const.white);
        addi = addi+1;
    end
    addi = addi+2;
    for b_lines = 1:sizeB(1)
        Screen('DrawText',scr.main,button{b_lines,:},scr.x_mid-bound(3)/2,first_line+addi*espace, const.black);
    end
    Screen('Flip',scr.main);

    if const.in_R2 == 1
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(my_key.space)
                push_button=1;
            elseif keyCode(my_key.escape) && ~const.expStart
                overDone;
            end
        end
    else
        WaitSecs(10);
        push_button = 1;
    end
end