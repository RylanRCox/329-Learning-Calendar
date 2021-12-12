# 329-Learning-Calendar
Python based application that uses Matlab mixed with the google calendar API in order to learn a users preferences and push appropriate notifications.
# Our task:
Create a dynamic Bayes net with 5+ variables (1 must be a hidden variable about the user e.g., forgetfulness), handcraft the model variables and CPTs clearly with an explanation of the parameters, identify the inference task and which variable(s) you query, simulate the DBN by sampling it and plotting the inferred variable(s) over time to ensure the model works as expected, define a simple utility function that quantifies how good/bad each system action is depending on the state of the query variables, use a built-in inference algorithm to update your belief distribution, compute the expected utility of each system action, take the best action, incorporate this into the calendar API and demonstrate this with 3 events that will yield 3 different system actions.
# Original Plan
We did Option 6: Bayes Net Reminder System

Our week-by-week plan was as follows:

Week 8: Gain a solid understanding of the steps we will need to do

Week 9: Initial project setup. Define & Explain model variables and CPTs. Identify inference & variables to Query

Week 10: Midterm break - minimal work done

Week 11: Simulate DBN & Plot inferred variables, define utility function and use built-in inference algorithm to update belief distribution

Week 12: compute the expected utility of each system action, take the best action, incorporate this into the calendar API and demonstrate this with 3 events that will yield 3 different system actions.

Week 13: Submit demonstration, finalize deliverables

Week 14: Submit deliverables

# Project Status
We have created a DBN model that contains two hidden variables and 4 observable ones. Additionally, we have hand crafted CPTs we are happy with for each of the nodes.Our DBN runs in Matlab and is able to be called from Python, returning the actions that we should take for an event. We
then process these actions in Python, and attach the appropriate reminders to the event. 
# File Structure
1. bnt-master
    - a library which contains all necessary files to run a DBN engine within Matlab. (https://github.com/bayesnet/bnt)
2. Matlab
    - All files pertaining to Matlab, this includes the file which runs the DBN, as well as expected utility calculations for each timestep, used to determine which action we take.
        - **get_remindermeu.m** calculates the expected utility of each action
        - **mk_reminders.m** creates our DBN.
        - **sim_reminder.m** uses a matlab engine to simulate our DBN over the span of 7 timesteps, which correlates to a week. This simulation outputs the best option for each timestep. A timestep according to our model, is defined by the passing of a single day.
        - **simulation.m** is a helper file that allows for our Python files to easily call our Matlab functions.
        - **util_needreminder.m** calculates the utility value of an action.
3. Python
    - This folder contains all Python code, including the code which calls the Google Calendar API.
        - **calc_events.py** The main python file that is run in order to query the calendar API, as well as send the respective actions back to the api. 
        - **credentials.json** is a json that contains the developer credentials in order to access the Google Calendar API.
        - **DetermineActions.py** A helper file for calc_events.py which contains all the functions to create the actions made by our system based off of the calculate action values. It contains logic for parsing the action array recieved from matlab, and returns an array of reminders that are sent back to the calendar API.
        - **init.m** is a helper file for Run_MatlabSim.py that initializes the Matlab engine to be used.
        - **Run_MatlabSim.py** contains a function to run and retrieve data from the Matlab engine containing our DBN.
        - **token.js** stores the users access and refresh tokens. This is created after the first succesful run of calc_events.py
4. Documentation
    - All documentation files including the final report.
        - **DBNModel.pdf** is a pdf file of what our DBN model looks like.
        - **FinalCPTs.xlsx** is an excel file containing our hand-crafted CPTs.
# Running the program

- **Matlab**
    - In order to run the DBN within matlab, you must ensure that the bnt-master package has been initialized correctly. To do so, you must add the folder to your path. There are two ways of doing so, either running init.m within the python folder, or manually running the following code in the matlab console:
        
            cd ../bnt-master
            addpath( genpathKPM(pwd) )
            cd ../Matlab
            addpath( genpathKPM(pwd) ) 
    - Once you have added bnt-master to your path, you can simulate the DBN using the command

            actionArray = sim_reminder( mk_reminders, IMP, TUE, CCR, BSY )
        - IMP is the event importance, and allows a value of either 1 or 2, Not important, and important respectively.
        - TUE is the time until the event, a value between 1 and 3 where 1 is very close, and 3 is very far. Very close is defined as an event being within 2 days, and very far is defined as an event being more than 5 days away. Any event in between is defined as being a medium distance, and correlates to the value of 2.
        - CCR is equivalent to the Checked Calendar Recently node, which is a value set by the user when calling the Python code. It takes in values from 1-3, correlating to a user checking their calendar daily, weekly, and monthly respectively.
        - BSY is the busyness of a user, determined by how many events are within the 7 day period we query. There are 3 possible values, again ranging from 1-3. The possible values are as follows: Not busy(1), Busy(2), and Very Busy(3). If a user has less than 5 events in their calendar, they are not busy. If they have more than 10 events, they are very busy. Any value in between suggests a user is busy.

- **Python**

    - To run this program you will need to have both python and matlab installed. The links for both of those are as follows: [Matlab Install](https://www.mathworks.com/help/install/), [Python Install](https://www.python.org/downloads/).

    - As well, you will need to install Matlab Engine API for python in order for our code to run. The instructions for that are as follows: [Matlab Engine](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

    - In addition, you will need to give the google calendar API access to your calendar. **Because our application has not been reviewed by google, the email you give access to must be in the list of approved emails.** 

        - An email account will be provided for easy test access, however, I have also given access to the google account associated with bowen.hui@ubc.ca
        - **If you have any issues accessing with the provided credentials, please email logandavidparker@gmail.com**

    - Once the following prerequisites are done, you can run the python code using the command
            
            %python calc_events.py CCR Reset?

        - CCR is the Checked Calendar Recently node, which is a value set based on your preferences. It takes in values from 1-3, correlating to a user checking their calendar daily, weekly, and monthly respectively. If you do not enter in a valid integer, you will run into an error running this code.

        - Reset? is a boolean flag used for testing, if this value is set to True, it will reset all the reminders set to events within the 7 days that are being read from the calendar. **When running the program with the goal of setting reminders, ensure the Reset? value is set to False.**
    - You can also run the program by commenting out line 117: main(sys.argv[0], sys.argv[1]) and uncommenting line 116: main(1, False). You can then set the parameters through that line, and execute the program using an editor of your choice.



