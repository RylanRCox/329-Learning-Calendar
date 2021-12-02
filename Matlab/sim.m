function prNeedReminder = sim( needreminder_dbn, ex )

% set up inference engines
engine = bk_inf_engine( needreminder_dbn );    
T = 7;                          % define number of time steps in problem

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a series of evidence in advance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ex == 1,
  % NeedReminder
  ev = sample_dbn( needreminder_dbn, T);
  evidence = cell( 3, T);
  onodes   = needreminder_dbn.observed;
  evidence( onodes, : ) = ev( onodes, : ); % all cells besides onodes are empty
elseif ex == 2,
  evidence = cell( 4, T);
  for ii=1:T,
    %NeedReminder
    evidence{1,ii} = 2; % CheckedCalendar = {1 = WithinMonth | 2 = WithinWeek | 3 = WithinDay}
    evidence{2,ii} = 3; % Busyness =   {1 = Not Busy | 2 = Busy | 3 = Very Busy}
    evidence{4,ii} = 1; % Importance = {1 = NotImportant| 2 = Important| 3 = VeryImportant}
    evidence{5,ii} = 2; % TimeToEvent ={1 = Far | 2 = Medium | 3 = Soon}
  end;
else
  % TODO Update the fixed data
  reminderVal = 1; % NeedReminder = {1 = No Reminder | 2 = Email | 3 = Pop-up}
  evidence = sampleNeedReminder_seq( needreminder_dbn, reminderVal, T );
end;
evidence

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inference process: infer if user needs help over T time steps
% keep track of results and plot as we go
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup results to be stored
belief =   []; % NeedReminder = False
belief2 =  []; % NeedReminder = Email
belief3 =  []; % NeedReminder = Pop-up
exputil =  []; % exputil of not sending reminder
exputil2 = []; % exputil of sending email
exputil3 = []; % exputil of sending popup 
subplot( 1, 2, 1 );    % setup plot for graph

% at t=0, no evidence has been entered, so the probability is same as the
% prior encoded in the DBN itself
%
prNeedReminder = get_field( needreminder_dbn.CPD{ needreminder_dbn.names('NeedReminder') }, 'cpt' )

belief = [belief, prNeedReminder(1)];
belief2 = [belief2, prNeedReminder(2)];
belief3 = [belief3, prNeedReminder(3)];
subplot( 1, 2, 1 );
plot( belief, 'o-');
hold on;
plot(belief2,'*-');
hold off;
hold on;
plot(belief3,'*-');
hold off;

% log best decision
[bestA, euNone,euEmail, euPopUp] = get_meu( prNeedReminder(1), prNeedReminder(2),prNeedReminder(3));
exputil = [exputil2, euNone];
exputil2 = [exputil2, euEmail];
exputil3 = [exputil3, euPopUp];
disp(sprintf('t=%d: best action = %s, euNone = %f ,euNeedReminder = %f euUrgency=%f', 0, bestA,euNone ,euEmail, euPopUp));
subplot( 1, 2, 2 );
plot( exputil, 'o-');
hold on;
plot(exputil2, '*-');
hold off;
hold on;
plot(exputil3, '*-');
hold off;

% at t=1: initialize the belief state 
%
[engine, ll(1)] = dbn_update_bel1(engine, evidence(:,1));

marg = dbn_marginal_from_bel(engine, 1);
prNeedReminder = marg.T;

belief = [belief, prNeedReminder(1)];
belief2 = [belief2, prNeedReminder(2)];
belief3 = [belief3, prNeedReminder(3)];
subplot( 1, 2, 1 );
plot( belief, 'o-');
hold on;
plot(belief2,'*-');
hold off;
hold on;
plot(belief3,'*-');
hold off;

% log best decision
[bestA, euNone,euEmail, euPopUp] = get_meu( prNeedReminder(1), prNeedReminder(2),prNeedReminder(3));
exputil = [exputil2, euNone];
exputil2 = [exputil2, euEmail];
exputil3 = [exputil3, euPopUp];
disp(sprintf('t=%d: best action = %s, euNone = %f ,euNeedReminder = %f euUrgency=%f', 0, bestA,euNone ,euEmail, euPopUp));
subplot( 1, 2, 2 );
plot( exputil, 'o-');
hold on;
plot(exputil2, '*-');
hold off;
hold on;
plot(exputil3, '*-');
hold off;

% Repeat inference steps for each time step
%
for t=2:T,

    %% THE FIRST TIME WE OBSERVE A CHANGE IN ACTION DETERMINES WHEN 
  % update belief with evidence at current time step
  [engine, ll(t)] = dbn_update_bel(engine, evidence(:,t-1:t));
  % extract marginals of the current belief state
  i = 1;
  marg = dbn_marginal_from_bel(engine, i);
  prNeedReminder = marg.T;

  % log best decision
  [bestA, euNone, euEmail, euPopUp] = get_meu( prNeedReminder(1), prNeedReminder(2),prNeedReminder(3));
  exputil = [exputil2, euNone];
  exputil2 = [exputil2, euEmail];
  exputil3 = [exputil3, euPopUp];

  disp(sprintf('t=%d: best action = %s, euNone = %f ,euNeedReminder = %f euUrgency=%f', 0, bestA,euNone ,euEmail, euPopUp));
  
  subplot( 1, 2, 2 );
  plot( exputil, 'o-');
  hold on;
  plot(exputil2, '*-');
  hold off;
  hold on;
  plot(exputil3, '*-');
  hold off;
  
  xlabel( 'Time Steps' );
  ylabel( 'Expected Utility' );
  axis( [ 0 T -5 5] );
  legend('EU(No Notification)','EU(Email Notification)', 'EU(Pop-up notification)')
  
  % keep track of results and plot it
  belief = [belief, prNeedReminder(1)];
  belief2 = [belief2, prNeedReminder(2)];
  belief3 = [belief3, prNeedReminder(3)];
  
  subplot( 1, 2, 1 );
  plot( belief, 'o-');
  hold on;
  plot(belief2,'*-');
  hold off;
  hold on;
  plot(belief3,'*-');
  hold off;
  
  xlabel( 'Time Steps' );
  ylabel( 'Probability' );
  axis( [ 0 T 0 1] );
  legend('Pr(NoReminder)','Pr(EmailReminder)','Pr(PopUpReminder')
  pause(0.25);
end;

