import matlab.engine

#def run_sim(IMP, TUE, CCR, BSY):
engine = matlab.engine.start_matlab()
engine.init(nargout=0)
actionArray = engine.simulation(2, 2, 2, 2)
print(actionArray)