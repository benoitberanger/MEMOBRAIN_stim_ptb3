function [ ParPortMessages ] = Prepare()

% Open parallel port
OpenParPort();

% Set pp to 0
WriteParPort(0)


%% Prepare messages

% fill here...
msg.baseline   = 1;
msg.activation = 0;


%% Finalize

% Pulse duration
msg.duration    = 0.003; % seconds

ParPortMessages = msg; % shortcut


end % function
