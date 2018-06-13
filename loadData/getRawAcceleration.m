function [acc, actid, actlabels, t, fs] = getRawAcceleration(varargin) %#ok<STOUT>

load('dataConvertedFromJson.mat');

% creates: subjects, fs, actlabels
p = inputParser;

defaultAccelerationType = 'total';
validAccelerationTypes = {'total','body'};
checkAccelerationType = @(x) any(validatestring(x,validAccelerationTypes));

defaultSubject = 1;

defaultComponent = 'x';
validComponents = {'x','y','z'};
checkComponent = @(x) any(validatestring(x,validComponents));

addParameter (p,'SubjectID',defaultSubject,@(x) x > 0 && x <= length(data));
addParameter (p,'AccelerationType',defaultAccelerationType,checkAccelerationType)
addParameter (p,'Component',defaultComponent,checkComponent)

parse(p,varargin{:})

subid = p.Results.SubjectID;
switch p.Results.AccelerationType
    case 'total', type = 'totalacc';
    case 'body', type = 'bodyacc';
end
switch p.Results.Component
    case 'x', component = 1;
    case 'y', component = 2;
    case 'z', component = 3;
end
        
acc = data(subid).(type)(:,component);
actid = data(subid).actid;
t = (1/fs) * (0:length(acc)-1)';

