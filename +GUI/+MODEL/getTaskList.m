function TaskList = getTaskList()

% task_folder = './+TASK';
% 
% d = dir(fullfile(task_folder,'+*'));
% 
% dirname = {d.name}';
% TaskList_raw = regexprep(dirname, '\+', ''); % remove the + at the begining
% 
% % discard only UPPER case dirs
% TaskList_upper = upper(TaskList_raw);
% Task_idx = ~strcmp(TaskList_upper, TaskList_raw);
% TaskList = TaskList_raw(Task_idx);

TaskList = {
    'Landscapes_Encoding_Immediate' 'Language_Encoding_Immediate' 'Objects_Encoding_Immediate'
    'Landscapes_Encoding_Deferred'  'Language_Encoding_Deferred'  'Objects_Encoding_Deferred'
    'Landscapes_Recall_Immediate'   'Language_Recall_Immediate'   'Objects_Recall_Immediate'
    'Landscapes_Recall_Deferred'    'Language_Recall_Deferred'    'Objects_Recall_Deferred'
};

end % function
