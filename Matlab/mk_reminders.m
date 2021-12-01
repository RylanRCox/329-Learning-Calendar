function DBN = mk_reminders

names = {'Urgency','NeedReminder', 'Busyness','CheckedCalendarRecently','TimeUntilEvent','EventImportance'};   % easier to refer to later
ss    = length( names );
DBN   = names;

% intra-stage dependencies
intrac = {'Urgency', 'NeedReminder'; 'Urgency','TimeUntilEvent';'Urgency','EventImportance';'Busyness','NeedReminder';'CheckedCalendarRecently','NeedReminder'};
[intra, names] = mk_adj_mat( intrac, names, 1 );
DBN = names   % potentially re-ordered names

%inter-stage dependencies
interc = {...
'NeedReminder', 'NeedReminder'; 'Urgency', 'Urgency'};
inter = mk_adj_mat( interc, names, 0 );

%interc = {...
%'Urgency', 'Urgency'};
%inter = mk_adj_mat( interc, names, 0 );

% observations
onodes = [ find(cellfun(@isempty, strfind(names,'Busyness'))==0) find(cellfun(@isempty, strfind(names,'CheckedCalendarRecently'))==0) find(cellfun(@isempty, strfind(names,'TimeUntilEvent'))==0) find(cellfun(@isempty, strfind(names,'EventImportance'))==0)]
onodes = sort(onodes)

% discretize nodes
URG     = 2;
NR      = 2;
BZNS    = 3;          
CCR     = 3;
TUE     = 3;
EI      = 3;
ns   = [CCR BZNS URG EI TUE NR];
dnodes = 1:ss;

% define equivalence classes
ecl1 = [1 2 3 4 5 6];
ecl2 = [7 8 3 4 5 6];   % nodes 6 7 and 8 are tied to nodes 2 3 and 4

% create the dbn structure based on the components defined above
bnet = mk_dbn( intra, inter, ns, ...
  'discrete', dnodes, ...
  'eclass1', ecl1, ...
  'eclass2', ecl2, ...
  'observed', onodes, ...
  'names', names );
DBN  = bnet;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% need to define CPTs for 
% prior, Pr(NeedHelp0)
% transition function, Pr(NeedHelp|NeedHelp_t-1)
% observation function, Pr(TaskTime_t|NeedHelp_t)
% observation function, Pr(Correct_t |NeedHelp_t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Urgency0                = 3;
NeedReminder0           = 6;
Busyness                = 2;
CheckedCalendarRecently = 1;
TimeUntilEvent          = 5;
EventImportance         = 4;
Urgency1                = 9;
NeedReminder1           = 12;

cpt = normalize( ones(URG,1) );
bnet.CPD{Urgency0} = tabular_CPD( bnet, Urgency0, 'CPT', cpt );

cpt = [ 0.55 0.15 ...
        0.45 0.85];
bnet.CPD{Urgency1} = tabular_CPD( bnet, Urgency1, 'CPT', cpt );

% prior, Pr(NeedReminder0)
cpt = [0.95 0.9 0.85 0.9 0.6 0.3 0.7 0.35 0.25 0.75 0.35 0.3 0.7 0.4 0.1 ...
       0.15 0.1 0.05 0.05 0.1 0.15 0.1 0.4 0.7 0.3 0.65 0.75 0.25 0.65 0.7 ...
       0.3 0.6 0.9 0.85 0.9 0.95];
bnet.CPD{NeedReminder0} = tabular_CPD( bnet, NeedReminder0, 'CPT', cpt );

% transition function, Pr(NeedReminder_t|NeedReminder_t-1)
cpt = [0.98 0.95 0.93 0.95 0.9 0.85 0.85 0.8 0.75 0.8 0.6 0.35 0.75 0.4 0.3 ...
       0.4 0.2 0.05 0.95 0.8 0.6 0.7 0.6 0.25 0.65 0.4 0.2 0.25 0.2 0.15 ... 
       0.15 0.1 0.05 0.07 0.05 0.02 0.02 0.05 0.07 0.05 0.1 0.15 0.15 0.2 ...
       0.25 0.2 0.4 0.65 0.25 0.6 0.7 0.6 0.8 0.95 0.05 0.2 0.4 0.3 0.4 ...
       0.75 0.35 0.6 0.8 0.75 0.8 0.85 0.85 0.9 0.95 0.93 0.95 0.98];
bnet.CPD{NeedReminder1} = tabular_CPD( bnet, NeedReminder1, 'CPT', cpt );

% transition function, Pr(Busyness_t | NeedReminder_t)
 cpt = [0.2 0.6 0.2];
bnet.CPD{Busyness} = tabular_CPD( bnet, Busyness, 'CPT', cpt );

% transition function, Pr(CheckedCalendarRecently_t | NeedReminder_t)
 cpt = [0.6 0.3 0.1];
bnet.CPD{CheckedCalendarRecently} = tabular_CPD( bnet, CheckedCalendarRecently, 'CPT', cpt );

 cpt = [0.7 0.05 ...
        0.2 0.4 ...
        0.1 0.55];
bnet.CPD{TimeUntilEvent} = tabular_CPD( bnet, TimeUntilEvent, 'CPT', cpt );

 cpt = [0.45 0.2 ...
        0.35 0.3 ...
        0.2 0.5];
bnet.CPD{EventImportance} = tabular_CPD( bnet, EventImportance, 'CPT', cpt );

DBN = bnet;