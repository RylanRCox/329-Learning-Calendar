function DBN = mk_urgency

names = {'Urgency','EventImportance', 'TimeToEvent'};
ss= length( names );
DBN = names;

intrac = {'Urgency','EventImportance'; 'Urgency','TimeToEvent'};
[intra, names] = mk_adj_mat( intrac, names, 0);
DBN = names;

interc = {'Urgency','Urgency'};
inter = mk_adj_mat( interc, names, 0);

onodes = [2 3];

URG     = 2;
IMP     = 3;
TIME    = 3;
ns      = [URG IMP TIME];
dnodes = 1:ss;

ecl1 = [1 2 3];
ecl2 = [4 2 3];

bnet = mk_dbn( intra, inter, ns, ...
  'discrete', dnodes, ...
  'eclass1', ecl1, ...
  'eclass2', ecl2, ...
  'observed', onodes, ...
  'names', names );
DBN  = bnet;

Urgency0   = 1;
EventImportance = 2;
TimeToEvent     = 3;
Urgency1   = 4;

cpt = normalize( ones(URG,1) );
bnet.CPD{Urgency0} = tabular_CPD( bnet, Urgency0, 'CPT', cpt );

cpt = [0.55 0.45 0.15 0.85];
bnet.CPD{Urgency1} = tabular_CPD( bnet, Urgency1, 'CPT', cpt );

cpt = [ 0.45 0.2 ...
        0.35 0.3 ...
        0.2 0.5];
bnet.CPD{EventImportance} = tabular_CPD(bnet, EventImportance, 'CPT', cpt );

cpt = [ 0.7 0.05 ...
        0.2 0.4 ...
        0.1 0.55];
bnet.CPD{TimeToEvent} = tabular_CPD(bnet, TimeToEvent, 'CPT', cpt );

DBN = bnet;