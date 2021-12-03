function [action, eu_None,eu_EmailReminder, eu_PopUpReminder] = get_meu( prNoReminder, prEmailReminder, prPopUpReminder )

% set default
action = 'None';

% compute expected utility of each action
% EU(A) = sum_Read Pr(Read) x U(A, Read)
%


eu_None = 

eu_EmailReminder = prNoReminder * util_needreminder( 2 ) + ...
          (1 - prNoReminder) * util_needreminder( 1 );

eu_PopUpReminder = prEmailReminder * util_urgency( 2 ) + ...
          (1 - prEmailReminder) * util_urgency( 1 );
% Determine best action
% if eu_needreminder > eu_urgency && eu_needreminder > eu_none,
%   action = 'Help';
% elseif eu_urgency > eu_needreminder && eu_urgency > eu_none,
%     action ='Hint';
% end;
if eu_EmailReminder > 0
    if eu_PopUpReminder > 0
        action = 'Email';
    else
        action = 'Push Notification';
    end
end

