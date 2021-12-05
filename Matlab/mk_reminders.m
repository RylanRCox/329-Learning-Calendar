function DBN = mk_reminders

names = {'Urgency','NeedReminder', 'Busyness','CheckedCalendarRecently','TimeUntilEvent','EventImportance'};   % easier to refer to later
ss    = length( names );
DBN   = names;

% intra-stage dependencies
intrac = {'TimeUntilEvent','Urgency';'EventImportance','Urgency';'Busyness','NeedReminder';'CheckedCalendarRecently','NeedReminder';'Urgency', 'NeedReminder'};
[intra, names] = mk_adj_mat( intrac, names, 1 );
DBN = names   % potentially re-ordered names

%inter-stage dependencies
interc = {...
'NeedReminder', 'NeedReminder'; 'Urgency', 'Urgency';};
inter = mk_adj_mat( interc, names, 0 );

%interc = {...
%'Urgency', 'Urgency'};
%inter = mk_adj_mat( interc, names, 0 );

% observations
onodes = [ find(cellfun(@isempty, strfind(names,'Busyness'))==0) find(cellfun(@isempty, strfind(names,'CheckedCalendarRecently'))==0) find(cellfun(@isempty, strfind(names,'TimeUntilEvent'))==0) find(cellfun(@isempty, strfind(names,'EventImportance'))==0)]
onodes = sort(onodes);

% discretize nodes
URG     = 2;
NR      = 3;
BZNS    = 3;          
CCR     = 3;
TUE     = 3;
EI      = 2;
ns =   [EI TUE URG CCR BZNS NR];
dnodes = 1:ss;

% define equivalence classes
ecl1 = [1 2 3 4 5 6];
ecl2 = [1 2 7 4 5 8];   % nodes 6 7 and 8 are tied to nodes 2 3 and 4

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
Busyness                = 5;
CheckedCalendarRecently = 4;
TimeUntilEvent          = 2;
EventImportance         = 1;
Urgency1                = 7;
NeedReminder1           = 8;

%Urgency CPTs
cpt = [0.5 0.7 0.9 0.1 0.3 0.5 ...
       0.5 0.3 0.1 0.9 0.7 0.5];
bnet.CPD{Urgency0} = tabular_CPD( bnet, Urgency0, 'CPT', cpt );

cpt = [ 0.5 0.7 0.9 0.1 0.3 0.5 0.2 0.3 0.4 0.01 0.05 0.1 0.5 0.3 0.1 0.9 ...
        0.7 0.5 0.8 0.7 0.6 0.99 0.95 0.9];
bnet.CPD{Urgency1} = tabular_CPD( bnet, 9, 'CPT', cpt );

% Pr(NeedReminder0)
cpt = [0.95 0.7 0.6 0.65 0.4 0.3 0.35 0.25 0.15 0.135 0.09 0.06 0.09 0.06 ...
    0.04 0.045 0.03 0.02 0.03 0.27 0.355 0.31 0.54 0.61 0.59 0.66 0.715 ...
    0.715 0.66 0.59 0.61 0.54 0.31 0.355 0.27 0.03 0.02 0.03 0.045 0.04 ...
    0.06 0.09 0.06 0.09 0.135 0.15 0.25 0.35 0.3 0.4 0.65 0.6 0.7 0.95];
bnet.CPD{NeedReminder0} = tabular_CPD( bnet, NeedReminder0, 'CPT', cpt );

% transition function, Pr(NeedReminder_t|NeedReminder_t-1)
cpt = [0.95 0.7 0.6 0.65 0.4 0.3 0.35 0.25 0.15 0.135 0.09 0.06 0.09 0.06 ...
    0.04 0.045 0.03 0.02 0.95 0.85 0.75 0.75 0.65 0.55 0.55 0.45 0.35 ... 
    0.6075 0.405 0.27 0.18 0.12 0.08 0.09 0.06 0.04 0.95 0.9 0.85 0.9 ...
    0.85 0.8 0.85 0.8 0.75 0.24 0.19 0.14 0.19 0.14 0.09 0.14 0.09 0.04 ...
    0.03 0.27 0.355 0.31 0.54 0.61 0.59 0.66 0.715 0.715 0.66 0.59 0.61 ... 
    0.54 0.31 0.355 0.27 0.03 0.01 0.09 0.16 0.17 0.23 0.27 0.18 0.145 ...
    0.0425 0.0425 0.145 0.18 0.27 0.23 0.17 0.16 0.09 0.01 0.01 0.01 0.01 ...
    0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 ...
    0.01 0.02 0.03 0.045 0.04 0.06 0.09 0.06 0.09 0.135 0.15 0.25 0.35 0.3 ...
    0.4 0.65 0.6 0.7 0.95 0.04 0.06 0.09 0.08 0.12 0.18 0.27 0.405 0.6075 ...
    0.35 0.45 0.55 0.55 0.65 0.75 0.75 0.85 0.95 0.04 0.09 0.14 0.09 0.14 ...
    0.19 0.14 0.19 0.24 0.75 0.8 0.85 0.8 0.85 0.9 0.85 0.9 0.95];
bnet.CPD{NeedReminder1} = tabular_CPD( bnet, 12, 'CPT', cpt );

% Pr(Busyness)
 cpt = [0.2 0.6 0.2];
bnet.CPD{Busyness} = tabular_CPD( bnet, Busyness, 'CPT', cpt );

% Pr(CheckedCalendarRecently)
 cpt = [0.6 0.3 0.1];
bnet.CPD{CheckedCalendarRecently} = tabular_CPD( bnet, CheckedCalendarRecently, 'CPT', cpt );

 cpt = [0.33 .34 .33];
bnet.CPD{TimeUntilEvent} = tabular_CPD( bnet, TimeUntilEvent, 'CPT', cpt );

 cpt = [.5 .5];
bnet.CPD{EventImportance} = tabular_CPD( bnet, EventImportance, 'CPT', cpt );

DBN = bnet;