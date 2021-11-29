function [action, eu_needreminder, eu_urgency] = get_meu( prNeedReminder, prUrgency )

% set default
action = 'None';

% compute expected utility of each action
% EU(A) = sum_Read Pr(Read) x U(A, Read)
%
eu_none = 0;

eu_needreminder = prNeedReminder * util_needreminder( 2 ) + ...
          (1 - prNeedReminder) * util_needreminder( 1 );

eu_urgency = prUrgency * util_urgency( 2 ) + ...
          (1 - prUrgency) * util_urgency( 1 );
% Determine best action
% if eu_needreminder > eu_urgency && eu_needreminder > eu_none,
%   action = 'Help';
% elseif eu_urgency > eu_needreminder && eu_urgency > eu_none,
%     action ='Hint';
% end;
if eu_needreminder > 0
    if eu_urgency > 0
        action = 'Email';
    else
        action = 'Push Notification';
    end
end

