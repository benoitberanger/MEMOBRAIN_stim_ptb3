function Draw( self, content )

self.content = content;

Screen('TextSize' , self.wPtr, self.size );

[~, offsetBoundsRect, textHeight, xAdvance] = Screen('TextBounds', self.wPtr, self.content,  self.center(1), self.center(2));
Screen('DrawText', self.wPtr, self.content, offsetBoundsRect(1)-xAdvance/2, offsetBoundsRect(2)-textHeight/2, self.color);

end % function
