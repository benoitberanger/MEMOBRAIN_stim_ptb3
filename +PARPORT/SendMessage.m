function SendMessage( message, duration )

WriteParPort(message);
WaitSecs(duration);
WriteParPort(0);

end % end
