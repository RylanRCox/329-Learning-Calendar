function DBN = mk_dbn

names = {'Urgency','NeedReminder', 'Busyness','LastCheckedCalendar','TimeUntilEvent','EventImportance'};   % easier to refer to later
ss    = length( names );
DBN   = names;

% intra-stage dependencies
intrac = {'Urgency', 'NeedReminder'; 'Urgency','TimeUntilEvent';'Urgency','EventImportance';'Busyness','NeedReminder';'LastCheckedCalendar','NeedReminder'};
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
onodes = [ find(cellfun(@isempty, strfind(names,'Busyness'))==0) find(cellfun(@isempty, strfind(names,'LastCheckedCalendar'))==0) find(cellfun(@isempty, strfind(names,'TimeUntilEvent'))==0) find(cellfun(@isempty, strfind(names,'EventImportance'))==0)]
onodes = sort(onodes)

% discretize nodes
URG     = 2;
NR      = 2;
BZNS    = 3;          
LCC     = 3;
TUE     = 3;
EI      = 3;
ns   = [URG NR BZNS LCC TUE EI];
dnodes = 1:ss;

% define equivalence classes
ecl1 = [1 2 5 6];
ecl2 = [7 2 5 6];   % nodes 6 7 and 8 are tied to nodes 2 3 and 4

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

NeedReminder0    = 1;
Busyness      = 2;
Preferences     = 3;
CheckedCalendarRecently = 4;
NeedReminder1    = 5;

% prior, Pr(NeedReminder0)
cpt = normalize( ones(URG,1) );
bnet.CPD{NeedReminder0} = tabular_CPD( bnet, NeedReminder0, 'CPT', cpt );

% transition function, Pr(NeedReminder_t|NeedReminder_t-1)
cpt = [.6 .1 .4 .9];
bnet.CPD{NeedReminder1} = tabular_CPD( bnet, NeedReminder1, 'CPT', cpt );

% transition function, Pr(Busyness_t | NeedReminder_t)
 cpt = [.75 0.15 0.2 0.35 0.05 0.5];
bnet.CPD{Busyness} = tabular_CPD( bnet, Busyness, 'CPT', cpt );

% transition function, Pr(CheckedCalendarRecently_t | NeedReminder_t)
 cpt = [.1 0.4 0.2 0.4 0.7 0.2];
bnet.CPD{CheckedCalendarRecently} = tabular_CPD( bnet, CheckedCalendarRecently, 'CPT', cpt );

DBN = bnet;
