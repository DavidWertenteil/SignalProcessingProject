%function convertFromJson

% This file takes the default from-json table that saved in "dataFromWeb" and convert it to
% more fitted matrix and save it in "myFormatData.mat"

%%
names =  fieldnames(dataFromWeb(1));

for i = 1:numel(names)
    temp=getfield(dataFromWeb(1),names{i});
    tempsize=size(temp);
    
    for j=1:tempsize(1)
        idvec(j) = convertNameActivity(temp(j).activityNumber);     
        temaccarr=temp(j).values;
        accvec(j,:)=temaccarr;
    end
    data(i).actid = idvec';
    data(i).totalacc=accvec;
    clear('idvec','accvec');
end

