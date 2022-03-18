function Draw( self, content )

self.content = content;

Screen('TextSize' , self.wPtr, round(self.size) );

%[nx, ny, textbounds, wordbounds] = DrawFormattedText(win, tstring [, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft][, winRect])
DrawFormattedText(self.wPtr, self.content, 'center', 'center', self.color, [], [], [], [], [], self.rect);

end % function
