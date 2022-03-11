function Keybindings()
global S

switch S.Environement
    
    case 'MRI' %-----------------------------------------------------------
        
        %         switch S.Task
        %
        %             case 'NBack'
        %                 S.Keybinds.TaskSpecific.Catch    = KbName('b'); % blue   in right hand
        %
        %         end
        
    case 'Keyboard' %------------------------------------------------------
        
        %         switch S.Task
        %
        %             case 'NBack'
        %                 S.Keybinds.TaskSpecific.Catch    = KbName('RightArrow');
        %
        %         end
        
end

end % function
