function [ IMAGE ] = Image()
global S

task_info = strsplit(S.Task,'_');
Task = task_info{1};
Category = [task_info{2} '_' task_info{3}];
filedir = fullfile(pwd, '+TASK', ['+' Task], Category);

N = size(S.TaskParam.stim_list,1);

IMAGE = PTB_OBJECTS.VIDEO.Image().empty(N,0); % create array of objects
for i = 1 : N
    IMAGE(i,1).filename = fullfile(filedir, S.TaskParam.stim_list{i,1});
    IMAGE(i,1).mask = 'NoMask';
    IMAGE(i,1).Load();
    IMAGE(i,1).LinkToWindowPtr(S.PTB.Video.wPtr);
    IMAGE(i,1).MakeTexture();
    IMAGE(i,1).Move(S.PTB.Video.wRect(3:4)/2);
end

end % function
