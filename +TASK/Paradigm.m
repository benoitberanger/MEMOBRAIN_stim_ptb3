function [ EP, TaskParam ] = Paradigm( Task, OperationMode )
global S

if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
    Task = 'Language';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Events & blocks

p.nStimBlock     = 3;  % stim blocks, interleaved with rest, task starts & stop with rest blocks
p.nStimPerBlock  = 12; % number of stim per block, same for activtion & rest


%% Timings

% all in seconds
p.durStim = 3.0;


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.durStim = 0.1;
    case 'RealisticDebug'
        
    case 'Acquisition'
        % pass
end


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define a planning <--- paradigme

p.nTrials = (p.nStimBlock * 2  + 1) * p.nStimPerBlock;


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#trial',  '#block', '#stim', 'stim_type', 'content'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

counter_trial = 0;
counter_block = 0;
for iBlock = 1 : p.nStimBlock
    
    % Baseline
    counter_block = counter_block + 1;
    for iStim = 1 : p.nStimPerBlock
        counter_trial = counter_trial + 1;
        switch Task
            case 'Language'
                stim_type = 'text';
                content = 'xxxxx';
        end
        EP.AddPlanning({'Baseline' NextOnset(EP) p.durStim counter_trial counter_block iStim  stim_type content})
    end
    
    % Activation
    counter_block = counter_block + 1;
    for iStim = 1 : p.nStimPerBlock
        counter_trial = counter_trial + 1;
        switch Task
            case 'Language'
                stim_type = 'text';
                content = 'xxxxx';
        end
        EP.AddPlanning({'Activation' NextOnset(EP) p.durStim counter_trial counter_block iStim  stim_type content})
    end
    
end

% Last Baseline, so Activation is surrounded by Baseline
counter_block = counter_block + 1;
for iStim = 1 : p.nStimPerBlock
    counter_trial = counter_trial + 1;
    switch Task
        case 'Language'
            stim_type = 'text';
            content = 'xxxxx';
    end
    EP.AddPlanning({'Baseline' NextOnset(EP) p.durStim counter_trial counter_block iStim  stim_type content})
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));

EP.BuildGraph();


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargin < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot();
    
end


%% Save

TaskParam = p;

S.EP        = EP;
S.TaskParam = TaskParam;


end % function