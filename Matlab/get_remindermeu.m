function [action, eu_None,eu_EmailReminder, eu_PopUpReminder] = get_meu(prEmailReminder, prPopUpReminder )

% set default
action = 'none';

% compute expected utility of each action
% EU(A) = sum_Read Pr(Read) x U(A, Read)
%
% = prNoReminder * util_needreminder(1)+...
%    ((1-prEmailReminder)* util_needreminder(2)) + ...
%    (1-prPopUpReminder) * util_needreminder(3);

eu_None = 0;

%eu_pop = pr(pop) * util(pop) + pr(nothing) * util(nothing)
eu_PopUpReminder = prPopUpReminder * util_needreminder( 2 ) + ...
          (1 - (prPopUpReminder + prEmailReminder)) * util_needreminder( 1 );
      
%eu_pop = pr(email) * util(email) + pr(nothing) * util(nothing)
eu_EmailReminder = prEmailReminder * util_needreminder( 3 ) + ...
          (1 - (prPopUpReminder + prEmailReminder)) * util_needreminder( 1 );

if eu_EmailReminder > eu_None && eu_EmailReminder > eu_PopUpReminder
    action = "email";
elseif eu_PopUpReminder > eu_None && eu_PopUpReminder > eu_EmailReminder
    action = "popup";
end

