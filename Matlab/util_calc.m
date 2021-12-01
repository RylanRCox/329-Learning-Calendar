function val = util_calc( NeedReminder,Urgency )
% action = determine if we need to send a email or pop-up notification
% NeedReminder = 1 (email), 2 (pop up)
%
% utility_value \in [-5,+5]
%

% reference point
val = 0;
% Email notifications are less intrusive, so it is slightly better to send
% an email rather than a pop up notification
if Urgency == 1,
  val = val + 2;
  % Results in -4
else
  val = val -1;
  % Results in -2
end;
