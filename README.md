# 329-Learning-Calendar
Python based application that uses Matlab mixed with the google calendar API in order to learn a users prefrences and push appropriate notifications.
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
Our DBN runs in Matlab and is able to be called from Python outputting desired values. We built CPTs we are happy with and creating a DBN model that contains two hidden variables and 4 observable ones.
# File Structure
1. bnt-master
    - contains all necessary files to run a DBN engine within Matlab. (Not written by us)
2. Matlab
    - All files pertaining to Matlab and running the DBN and calculating expected actions for each day.
        - get_remindermeu.m calculates the expected utility of each action
        - mk_reminders.m creates our DBN.
        - sim_reminder.m uses a matlab engine to simulate our DBN over the span of a week and outputs the best option for each day of the week.
        - simulation.m is a helper file that allows for our Python files to easily call our Matlab functions.
        - util_needreminder.m calculates the utility value of an action.
3. Python
    - All files pertaining to Python and calling the Google Calendar API.
        - 
4. Documentation
    - All documentation files including the final report.
# Requirements to run the program
To run this program you will need to have both python and matlab installed. The links for both of those are as follows: [Matlab Install](https://www.mathworks.com/help/install/), [Python Install](https://www.python.org/downloads/).

Secondly you wil nee to install Matlab Engine API for python in order for it to run. The instructions for that are as follows: [Matlab Engine](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

Finally you will need to use the google calendar API. Which ## NEEDS TO BE DESCRIBED ##
