import matlab.engine
def run_sim(importance, timeToEvent, busyness, usercheckfreq):
    engine = matlab.engine.start_matlab()
    engine.init(nargout=0)
    actionArray = engine.simulation(importance, timeToEvent, usercheckfreq, busyness)
    return actionArray


