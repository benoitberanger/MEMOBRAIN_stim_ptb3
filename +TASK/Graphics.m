function p = Graphics( p )


%% FixationCross (common)

p.FixationCross.Size     = 0.10;              %  Size_px = ScreenY_px * Size
p.FixationCross.Width    = 0.10;              % Width_px =    Size_px * Width
p.FixationCross.Color    = [000 000 000 255]; % [R G B a], from 0 to 255
p.FixationCross.Position = [0.50 0.50];       % Position_px = [ScreenX_px ScreenY_px] .* Position


%% Text

p.Text.Size   = 0.20;              % TextSize = ScreenY_px * Size
p.Text.Color  = [000 000 000 255]; % [R G B a], from 0 to 255
p.Text.Center = [0.5 0.5];         % Position_px = [ScreenX_px ScreenY_px] .* Position


end % function
