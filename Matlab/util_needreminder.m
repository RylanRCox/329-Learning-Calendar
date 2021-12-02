function val = util_needreminder( NeedReminder )
% action = determine if we need to give a reminder
% NeedReminder = 1 (No Reminder), 2 (Email Reminder) 3 (Pop up reminder)
%
% utility_value \in [-5,+5]
%

% reference point
val = 0;

% doing stuff for the user gets a disruption penalty
val = val - 1; 

if NeedReminder == 1,
  val = val - 3;
  % Results in -4
else
  val = val + 5;
  % Results in +4
end;
