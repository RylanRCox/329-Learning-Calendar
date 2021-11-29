function prNeedReminder = sim( needreminder_dbn, urgency_dbn, ex )

% set up inference engines
NeedReminder_engine = bk_inf_engine( needreminder_dbn );    
Urgency_engine = bk_inf_engine( urgency_dbn );
T = 50;                          % define number of time steps in problem

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a series of evidence in advance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ex == 1,
  % NeedReminder
  ev = sample_dbn( needreminder_dbn, T);
  evidence = cell( 3, T);
  onodes   = needreminder_dbn.observed;
  evidence( onodes, : ) = ev( onodes, : ); % all cells besides onodes are empty
  % Urgency
  ev2 = sample_dbn( urgency_dbn, T);
  evidence2 = cell( 2, T);
  onodes2   = urgency_dbn.observed;
  evidence2( onodes2, : ) = ev2( onodes2, : ); % all cells besides onodes are empty
elseif ex == 2,
  evidence = cell( 4, T);
  evidence2 = cell( 3, T);
  for ii=1:T,
    %NeedReminder
    evidence{2,ii} = 3; % Busyness =   {1 = Not Busy | 2 = Busy | 3 = Very Busy}
    evidence{3,ii} = 1; % Preference =  {1 = ~WantReminder | 2 = WantReminder}
    evidence{4,ii} = 1; % CheckedCalendar = {1 = WithinMonth | 2 = WithinWeek | 3 = WithinDay}
    %Urgency
    evidence2{2,ii} = 1; % Importance = {1 = NotImportant| 2 = Important| 3 = VeryImportant}
    evidence2{3,ii} = 2; % TimeToEvent ={1 = Far | 2 = Medium | 3 = Soon}
  end;
else
  % TODO Update the fixed data
  reminderVal = 1; % NeedReminder = {1 = false | 2 = true}
  urgencyVal = 1; % Urgency = {1 = false | 2 = true}
  evidence = sampleNeedReminder_seq( needreminder_dbn, reminderVal, T );
  evidence2 = sampleUrgency_seq( urgency_dbn, urgencyVal, T );
end;
evidence
evidence2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inference process: infer if user needs help over T time steps
% keep track of results and plot as we go
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup results to be stored
belief = [];
belief2 = [];
exputil = [];
exputil2 = [];
subplot( 1, 2, 1 );    % setup plot for graph

% at t=0, no evidence has been entered, so the probability is same as the
% prior encoded in the DBN itself
%
prNeedReminder = get_field( needreminder_dbn.CPD{ needreminder_dbn.names('NeedReminder') }, 'cpt' )
prUrgency = get_field(urgency_dbn.CPD{urgency_dbn.names('Urgency')}, 'cpt')

belief = [belief, prNeedReminder(2)];
belief2 = [belief2, prUrgency(2)];
subplot( 1, 2, 1 );
plot( belief, 'o-');
hold on;
plot(belief2,'*-');
hold off;

% log best decision
[bestA, euReminder, euUrgency] = get_meu( prNeedReminder(2), prUrgency(2) );
exputil = [exputil, euReminder];
exputil2 = [exputil2, euUrgency];
disp(sprintf('t=%d: best action = %s, euNeedReminder = %f euUrgency=%f', 0, bestA, euReminder, euUrgency));
subplot( 1, 2, 2 );
plot( exputil, 'o-');
hold on;
plot(exputil2, '*-');
hold off;

% at t=1: initialize the belief state 
%
[NeedReminder_engine, ll(1)] = dbn_update_bel1(NeedReminder_engine, evidence(:,1));
[Urgency_engine, ll(1)] = dbn_update_bel1(Urgency_engine, evidence2(:,1));

marg = dbn_marginal_from_bel(NeedReminder_engine, 1);
prNeedReminder = marg.T;
marg2 = dbn_marginal_from_bel(Urgency_engine,1);
prUrgency = marg2.T

belief = [belief, prNeedReminder(2)];
belief2 = [belief2, prUrgency(2)];
subplot( 1, 2, 1 );
plot( belief, 'o-');
hold on;
plot(belief2,'*-');
hold off;


% log best decision
[bestA, euReminder,euUrgency] = get_meu( prNeedReminder(2),prUrgency(2) );
exputil = [exputil, euReminder]; 
exputil2 = [exputil2, euUrgency]
disp(sprintf('t=%d: best action = %s, euNeedReminder = %f euUrgency=%f', 1, bestA, euReminder,euUrgency));
subplot( 1, 2, 2 );
plot( exputil, 'o-');
hold on;
plot(exputil2, '*-');
hold off;


% Repeat inference steps for each time step
%
for t=2:T,
  % update belief with evidence at current time step
  [NeedReminder_engine, ll(t)] = dbn_update_bel(NeedReminder_engine, evidence(:,t-1:t));
  [Urgency_engine, ll(t)] = dbn_update_bel(Urgency_engine, evidence2(:,t-1:t));
  % extract marginals of the current belief state
  i = 1;
  marg = dbn_marginal_from_bel(NeedReminder_engine, i);
  prNeedReminder = marg.T;
  marg2 = dbn_marginal_from_bel(Urgency_engine, i);
  prUrgency = marg2.T;


  % log best decision
  [bestA, euReminder, euUrgency] = get_meu( prNeedReminder(2), prUrgency(2) );
  
  exputil = [exputil, euReminder];
  exputil2 = [exputil2, euUrgency];

  disp(sprintf('t=%d: best action = %s, euNeedReminder = %f euUrgency=%f', t, bestA, euReminder,euUrgency));
  
  subplot( 1, 2, 2 );
  plot( exputil, 'o-');
  hold on;
  plot(exputil2, '*-');
  hold off;
  xlabel( 'Time Steps' );
  ylabel( 'Expected Utility' );
  axis( [ 0 T -5 5] );
  legend('EU(NeedReminder)','EU(Urgency)')
  % keep track of results and plot it
  belief = [belief, prNeedReminder(2)];
  belief2 = [belief2,prUrgency(2)];
  subplot( 1, 2, 1 );
  plot( belief, 'o-');
  hold on;
  plot(belief2,'*-');
  hold off;
  xlabel( 'Time Steps' );
  ylabel( 'Probability' );
  axis( [ 0 T 0 1] );
  legend('Pr(NeedReminder)','Pr(Urgency)')
  pause(0.25);
end;
