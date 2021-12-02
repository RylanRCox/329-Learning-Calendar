function ev = sampleNeedReminder_seq( dbn, reminderVal, T )

% create empty evidence for T time steps
ev = cell(dbn.nnodes_per_slice, T);

% get index of observation variable(s)
onode1 = dbn.names('Busyness');
onode2 = dbn.names('CheckedCalendarRecently');

for t=1:T,
  % sample value of variable
  oval1 = stoch_obs('Busyness', dbn, reminderVal );
  oval2 = stoch_obs('CheckedCalendarRecently', dbn, reminderVal );
  % store sampled value into evidence structure
  ev{onode1, t} = oval1;
  ev{onode2, t} = oval2;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function only used in this file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = stoch_obs( varname, dbn, parentval )
cpt = get_field( dbn.CPD{ dbn.names( varname )}, 'cpt' );
val = sampleRow( cpt( parentval, : ) );

