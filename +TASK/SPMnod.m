function [ names , onsets , durations ] = SPMnod
global S

%SPMNOD Build 'names', 'onsets', 'durations' for SPM

EchoStart(mfilename)

try
    %% Preparation
    
    % 'names' for SPM
    
    if strcmp(S.Task, 'Fluency')
        names = {            
            'baseline'
            'activation'
            'instruction'
            };
    else
        names = {
            'baseline'
            'activation'
            'click'
            };
    end
    
    
    % 'onsets' & 'durations' for SPM
    onsets    = cell(size(names));
    durations = cell(size(names));
    
    % Shortcut
    EventData = S.ER.BlockData;
    
    num = [];
    for n = 1 : length(names)
        num.(names{n}) = n;
    end
    
    
    %% Onsets building
    
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        else
            onsets{num.(EventData{event,1})} = [onsets{num.(EventData{event,1})} ; EventData{event,2}];
        end
        
    end
    
    
    %% Durations building
    
    
    for event = 1:size(EventData,1)
        
        if strcmp(EventData{event,1}, 'StartTime') || strcmp(EventData{event,1}, 'StopTime')
            %pass
        else
            durations{num.(EventData{event,1})} = [ durations{num.(EventData{event,1})} ; EventData{event+1,2}-EventData{event,2}] ;
        end
        
    end
    
    %% Add Clicks to SPM model input
    
    if strcmp(S.Task, 'Fluency')
        %pass
    else
        
        keys = cellstr( KbName(struct2array(S.Keybinds.TaskSpecific)) );
        
        for f = 1:length(keys)
            click_spot.(keys{f}) = regexp(S.KL.KbEvents(:,1),keys{f});
            click_spot.(keys{f}) = ~cellfun(@isempty,click_spot.(keys{f}));
            click_spot.(keys{f}) = find(click_spot.(keys{f}));
        end
        click_onset    = [];
        click_duration = [];
        
        count = 0 ;
        for f = 1:length(keys)
            
            count = count + 1 ;
            
            if ~isempty(S.KL.KbEvents{click_spot.(keys{f}),2})
                click_idx = cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(:,2)) == 1;
                click_idx = find(click_idx);
                % if only 1 keypres and never released (wtf ?), need to deal with this unprobable case
                if size(S.KL.KbEvents{click_spot.(keys{f}),2}) < 3
                    S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} = [];
                end
                % the last click can be be unfinished : button down + end of stim = no button up
                if isempty(S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3})
                    S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),3} =  S.ER.Data{end,2} - S.KL.KbEvents{click_spot.(keys{f}),2}{click_idx(end),1};
                end
                click_onset    = [ click_onset    ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,1)) ];
                click_duration = [ click_duration ; cell2mat(S.KL.KbEvents{click_spot.(keys{f}),2}(click_idx,3)) ];
            else
                % pass
            end
            
        end
        
        % reorder
        [click_onset,i] = sort(click_onset,'ascend');
        click_duration = click_duration(i);
        
        onsets   {num.click} = click_onset;
        durations{num.click} = click_duration;
        
        if isempty(onsets{num.click})
            names    (num.click) = [];
            onsets   (num.click) = [];
            durations(num.click) = [];
        end
        
    end
    
    
catch err
    
    sca
    warning(err.message)
    
end

EchoStop(mfilename)

end % function
