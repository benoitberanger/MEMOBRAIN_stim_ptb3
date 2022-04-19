classdef FixationCross < PTB_OBJECTS.VIDEO.Base
    %FIXATIONCROSS Class to prepare and draw a fixation cross in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        dim      % size of cross arms, in pixels
        width    % width of each arms, in pixels
        color    % [R G B a] from 0 to 255
        center   % [ CenterX CenterY ] of the cross, in pixels
        
        % Internal variables
        
        allCoords % coordinates of the cross for PTB, in pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
