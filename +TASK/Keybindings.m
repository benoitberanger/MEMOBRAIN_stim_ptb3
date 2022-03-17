function Keybindings()
global S

task_info = strsplit(S.Task,'_');
Task = task_info{1};

switch S.Environement
    
    case 'MRI' %-----------------------------------------------------------
        
        switch Task
            
            case 'Language'
                S.Keybinds.TaskSpecific.Catch = KbName('b'); % blue in right hand
            case 'Landscapes'
                S.Keybinds.TaskSpecific.Catch = KbName('b'); % blue in right hand
                
        end
        
    case 'Keyboard' %------------------------------------------------------
        
        switch Task
            
            case 'Language'
                S.Keybinds.TaskSpecific.Catch = KbName('RightArrow');
            case 'Language'
                S.Keybinds.TaskSpecific.Catch = KbName('RightArrow');
        end
        
end

end % function
