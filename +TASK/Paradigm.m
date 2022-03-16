function [ EP, TaskParam ] = Paradigm( Task, OperationMode )
global S

if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
    Task = 'Language_Encoding_Immediate';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%% Load .csv


task_info = strsplit(Task,'_');
Task = task_info{1};
Category = [task_info{2} '_' task_info{3}];

switch Task
    case 'Language'
        filepath = fullfile(pwd, '+TASK', ['+' Task], [Category '.csv']);
        assert(exist(filepath,'file')>0, 'file does not exist : %s', filepath)
        stim_list = read_and_parse(filepath);
end

p.nTrials = size(stim_list,1);


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', '#trial',  'stim_type', 'content'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for iStim = 1 : p.nTrials
    switch Task
        case 'Language'
            stim_type = 'text';
            condition = stim_list{iStim,2};
            content   = stim_list{iStim,1};
    end
    EP.AddPlanning({condition NextOnset(EP) p.durStim iStim stim_type content});
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

function out = read_and_parse( fname )

% Read
fid = fopen(deblank(fname), 'rt');
if fid == -1
    error('file cannot be opened : %s', deblank(filename))
end
content = fread(fid, '*char')'; % read the whole file as a single char
fclose(fid);

% Parse
lines = strsplit(content,sprintf('\n'))'; lines(end) = [];
res = regexp(lines, ',', 'split');
out = vertcat(res{:});

end
