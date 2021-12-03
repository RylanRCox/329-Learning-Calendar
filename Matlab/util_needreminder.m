function val = util_needreminder( NeedReminder )
% action = determine if we need to give a reminder
% NeedReminder = 1 (No Reminder), 2 (Email Reminder) 3 (Pop up reminder)
%
% utility_value \in [-5,+5]
%

% reference point
val = 0;

% doing stuff for the user gets a disruption penalty

%Utility of doing nothing
if NeedReminder == 1
  val = val - 5;
%Utility of sending a pop-up
elseif NeedReminder == 2
  val = val + 2;
%Utility of sending an email
else
   val = val + 4;
    
end;
