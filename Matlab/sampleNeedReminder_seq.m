function ev = sampleNeedReminder_seq( dbn, reminderVal, T )

% create empty evidence for T time steps
ev = cell(dbn.nnodes_per_slice, T);

% get index of observation variable(s)
onode1 = 5; %Busyness
onode2 = 4; %CCR
onode3 = 2; %TUE
onode4 = 1; %EI

for t=1:T,
  % sample value of variable
  oval1 = stoch_obs(onode1, dbn, reminderVal );
  oval2 = stoch_obs(onode2, dbn, reminderVal );
  oval3 = stoch_obs(onode3, dbn, reminderVal );
  oval4 = stoch_obs(onode3, dbn, reminderVal );
  % store sampled value into evidence structure
  ev{onode1, t} = oval1;
  ev{onode2, t} = oval2;
  ev{onode3, t} = oval3;
  ev{onode4, t} = oval4;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function only used in this file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = stoch_obs( varnum, dbn, parentval )
cpt = get_field( dbn.CPD{ varnum}, 'cpt' )
val = sampleRow( cpt( parentval, : ) );

