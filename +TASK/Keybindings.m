function Keybindings()
global S

task_info = strsplit(S.Task,'_');
Task = task_info{1};

switch S.Environement
    
    case 'MRI' %-----------------------------------------------------------
        
        S.Keybinds.TaskSpecific.Catch = KbName('b'); % blue in right hand
        
    case 'Keyboard' %------------------------------------------------------
        
        S.Keybinds.TaskSpecific.Catch = KbName('RightArrow');
        
end

end % function
