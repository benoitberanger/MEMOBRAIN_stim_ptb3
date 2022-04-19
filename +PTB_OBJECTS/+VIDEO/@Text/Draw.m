function Draw( self, content )

self.content = content;

Screen('TextSize' , self.wPtr, round(self.size) );

DrawFormattedText(self.wPtr, self.content, 'center', 'center', self.color);

end % function
