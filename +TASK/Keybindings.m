function Keybindings()
global S

switch S.Environement
    
    case 'MRI' %-----------------------------------------------------------
        
        S.Keybinds.TaskSpecific.Catch = KbName('b'); % blue in right hand
        
    case 'Keyboard' %------------------------------------------------------
        
        S.Keybinds.TaskSpecific.Catch = KbName('RightArrow');
        
end

end % function
