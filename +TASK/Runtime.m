function Runtime()
global S

try
    %% Tuning of the task
    
    
    task_info = regexp(S.Task,'_','split');
    Task = task_info{1};
    
    TASK.Keybindings();
    [ EP, p ] = TASK.Paradigm( S.Task, S.OperationMode );
    
    
    %% Prepare recorders
    
    PTB_ENGINE.PrepareRecorders( S.EP );
    S.BR = EventRecorder({'trial#' 'block#' 'stim#' 'content_type' 'stim' 'RT(s)'}, S.TaskParam.nTrials);
    
    
    %% Initialize stim objects
    
    FIXATIONCROSS = TASK.PREPARE.FixationCross();
    switch Task
        case 'Language'
            TEXT  = TASK.PREPARE.Text ();
        case {'Landscapes','Objects'}
            IMAGE = TASK.PREPARE.Image();
    end
    
    %% Shortcuts
    
    ER          = S.ER; % EventRecorder
    BR          = S.BR; % BehaviourRecorder (EventRecorder)
    wPtr        = S.PTB.Video.wPtr;
    wRect       = S.PTB.Video.wRect;
    slack       = S.PTB.Video.slack;
    KEY_ESCAPE  = S.Keybinds.Common.Stop_Escape;
    KEY_Catch   = S.Keybinds.TaskSpecific.Catch;
    if S.MovieMode, moviePtr = S.moviePtr; end
    
    
    %% Planning columns
    
    columns = struct;
    for c = 1 : EP.Columns
%         col_name = matlab.lang.makeValidName( EP.Header{c} );
        columns.(EP.Header{c}) = c;
    end
    
    
    %% GO
    
    EXIT = false;
    secs = GetSecs();
    n_resp_ok = 0;
    n_catch = 0;
    
    % Loop over the EventPlanning
    nEvents = size( EP.Data , 1 );
    for evt = 1 : nEvents
        
        % Shortcuts
        evt_name     = EP.Data{evt,columns.event_name};
        evt_onset    = EP.Data{evt,columns.onset};
        evt_duration = EP.Data{evt,columns.duration};
        trial        = EP.Data{evt,columns.trial};
        stim_type    = EP.Data{evt,columns.stim_type};
        content      = EP.Data{evt,columns.content};
        
        if evt < nEvents
            next_evt_onset = EP.Data{evt+1,columns.onset};
        end
        
        switch evt_name
            
            case 'StartTime' % --------------------------------------------
                
                % Draw
                FIXATIONCROSS.Draw();
                Screen('DrawingFinished', wPtr);
                Screen('Flip',wPtr);
                
                StartTime     = PTB_ENGINE.StartTimeEvent(); % a wrapper, deals with hidemouse, eyelink, mri sync, ...
                
                
            case 'StopTime' % ---------------------------------------------
                
                StopTime = WaitSecs('UntilTime', StartTime + S.ER.Data{S.ER.EventCount,2} + S.EP.Data{evt-1,3} );
                
                % Record StopTime
                S.ER.AddStopTime( 'StopTime' , StopTime - StartTime );
                
                
            case {'baseline', 'activation'} % -------------------------------------------------
                
                % Draw
                switch Task
                    case 'Language'
                        TEXT.Draw(content);
                    case {'Landscapes','Objects'}
                        IMAGE(trial).Load();
                        IMAGE(trial).MakeTexture();
                        IMAGE(trial).Maximize();
                        IMAGE(trial).Draw();
                        IMAGE(trial).CloseTexture();
                end
                Screen('DrawingFinished', wPtr);
                
                % Flip at the right moment
                desired_onset =  StartTime + evt_onset - slack;
                real_onset = Screen('Flip', wPtr, desired_onset);
                if S.ParPort, PARPORT.SendMessage(S.ParPortMessages.(evt_name), S.ParPortMessages.duration); end
                
                % Save onset
                ER.AddEvent({evt_name real_onset-StartTime [] EP.Data{evt, 4:end}});
                
                if S.MovieMode, PTB_ENGINE.VIDEO.MOVIE.AddFrameFrontBuffer(wPtr,moviePtr, round(evt_duration/S.PTB.Video.IFI)); end
                
                fprintf('#trial=%2d   #block_type=%10s  stim_type=%5s   content=%5s \n',...
                    trial,...
                    evt_name,...
                    stim_type,...
                    content...
                    )
                
                has_responded = 0;
                
                % While loop for most of the duration of the event, so we can press ESCAPE
                next_onset = StartTime + next_evt_onset - slack - p.maxDurLoading;
                while secs < next_onset
                    
                    [keyIsDown, secs, keyCode] = KbCheck();
                    if keyIsDown
                        EXIT = keyCode(KEY_ESCAPE);
                        if EXIT, break, end
                        
                        if keyCode(KEY_Catch) && ~has_responded
                            has_responded = 1;
                            fprintf('>>> click <<<\n')
                        end
                        
                    end
                    
                end % while
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % if ESCAPE is pressed
        if EXIT
            StopTime = secs;
            
            % Record StopTime
            ER.AddStopTime( 'StopTime', StopTime - StartTime );
            
            Priority(0);
            
            fprintf('ESCAPE key pressed \n');
            break
        end
        
    end % for
    
    
    %% End of task execution stuff
    
    % Save some values
    S.StartTime = StartTime;
    S.StopTime  = StopTime;
    
    PTB_ENGINE.FinilizeRecorders();
    
    % Close parallel port
    if S.ParPort, CloseParPort(); end
    
    % Diagnotic
    switch S.OperationMode
        case 'Acquisition'
        case 'FastDebug'
            % plotDelay(EP,ER);
        case 'RealisticDebug'
            % plotDelay(EP,ER);
    end
    
    try % I really don't want to this feature to screw a standard task execution
        if exist('moviePtr','var')
            PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
        end
    catch
    end
    
    
catch err
    
    sca;
    Priority(0);
    
    rethrow(err);
    
    if exist('moviePtr','var') %#ok<UNRCH>
        PTB_ENGINE.VIDEO.MOVIE.Finalize(moviePtr);
    end
    
end % try

end % function
