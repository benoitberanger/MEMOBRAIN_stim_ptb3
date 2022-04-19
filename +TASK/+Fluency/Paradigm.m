function [ EP, TaskParam ] = Paradigm( OperationMode )
global S

if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Timings

p.txtInstruction = {'Repos', ...                   % first is the baseline instruction
    'Des animaux', 'Des fruits', 'Des vêtements'}; % and now all activation instructions

% all in seconds
p.durActivation  = 30.0;
p.durInstruction = 03.0;
p.durBaseline    = p.durActivation - p.durInstruction*2;


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.durActivation  = 03.0;
        p.durInstruction = 01.0;
        p.durBaseline    = p.durActivation - p.durInstruction;
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


%% Build planning

% Create and prepare
header = { 'event_name', 'onset', 'duration', 'content'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for iBlock = 2 : length(p.txtInstruction)
    
    EP.AddPlanning({'instruction' NextOnset(EP) p.durInstruction p.txtInstruction{1}      });
    EP.AddPlanning({'baseline'    NextOnset(EP) p.durBaseline    []                       });
    EP.AddPlanning({'instruction' NextOnset(EP) p.durInstruction p.txtInstruction{iBlock} });
    EP.AddPlanning({'activation'  NextOnset(EP) p.durActivation  []                       });
    
end

EP.AddPlanning({'instruction' NextOnset(EP) p.durInstruction p.txtInstruction{1} });
EP.AddPlanning({'baseline'    NextOnset(EP) p.durBaseline    [] });

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
