classdef Image < PTB_OBJECTS.VIDEO.Base
    %IMAGE Class to load, prepare and draw image in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        filename        % path of the image
        scale      = 1  % scaling factor of the image => 1 means original image
        center          % [X-center-PTB, Y-center-PTB] in pixels, PTB coordinates
        mask       = '' % mask of the images : str = 'NoMask', 'ShuffleMask', 'DarkMask'
        
        
        % Internal variables
        
        screen_x   % number of horizontal pixels of the screen
        screen_y   % number of vertical   pixels of the screen
        
        X         % image matrix
        map       % color map
        alpha     % transparency
        
        baseRect   % [x1 y1 x2 y2] pixels, PTB coordinates, original rectangle
        currRect   % [x1 y1 x2 y2] pixels, PTB coordinates, current  rectangle
        
        texPtr     % pointer to the texure in PTB
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        % no constructor, easier to manage and just fill the fields
        
    end % methods
    
    
end % class
