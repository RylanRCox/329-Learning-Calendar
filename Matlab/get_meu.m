function [action, eu_a,eu_EmailReminder, eu_PopUpReminder] = get_meu( prNoReminder, prEmailReminder, prPopUpReminder )

% set default
action = 'None';

% compute expected utility of each action
% EU(A) = sum_Read Pr(Read) x U(A, Read)
%
eu_a = prNoReminder * util_needreminder(1)+...
    ((1-prEmailReminder)* util_needreminder(2)) + ...
    (1-prPopUpReminder) * util_needreminder(3);

eu_None = 0;

%eu_pop = pr(pop) * util(pop) + pr(nothing) * util(nothing)
eu_PopUpReminder = prPopUpReminder * util_needreminder( 2 ) + ...
          (1 - (prNoReminder + prEmailReminder)) * util_needreminder( 1 );
      
%eu_pop = pr(email) * util(email) + pr(nothing) * util(nothing)
eu_EmailReminder = prEmailReminder * util_needreminder( 3 ) + ...
          (1 - (prNoReminder + prEmailReminder)) * util_needreminder( 1 );

if eu_EmailReminder > eu_None & eu_EmailReminder > eu_PopUpReminder
    action = "Email";
elseif eu_EmailReminder > eu_None & eu_PopUpReminder > eu_EmailReminder
    action = "Pop-up";
end

