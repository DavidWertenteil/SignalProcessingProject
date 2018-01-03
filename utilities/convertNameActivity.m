function act_names = convertNameActivity(number)
%
%  The original:
%      Walking (1)
%      WalkingUpstairs (2)
%      WalkingDownstairs (3)
%      Sitting (4)
%      Standing (5)
%      Laying (6)
%      DragLimp (7)
%      JumpLimp (8)
%      PersonFall (9)
%      PhoneFall (10)
%      Running(11)
%      AustoLimp(12)
%%
if(number == 7)
    act_names = 2;
elseif (number == 8)
    act_names = 3;
elseif (number == 12)
    act_names = 4;
else
    act_names = 1;
%end
%act_names = number;
%if(number == 11 || number == 12)
%    act_names = number - 2;
end


