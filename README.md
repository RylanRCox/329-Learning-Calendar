# 329-Learning-Calendar
Python based application that uses Matlab mixed with the google calendar API in order to learn a users prefrences and push appropriate notifications.
# Our task:
Create a dynamic Bayes net with 5+ variables (1 must be a hidden variable about the user e.g., forgetfulness), handcraft the model variables and CPTs clearly with an explanation of the parameters, identify the inference task and which variable(s) you query, simulate the DBN by sampling it and plotting the inferred variable(s) over time to ensure the model works as expected, define a simple utility function that quantifies how good/bad each system action is depending on the state of the query variables, use a built-in inference algorithm to update your belief distribution, compute the expected utility of each system action, take the best action, incorporate this into the calendar API and demonstrate this with 3 events that will yield 3 different system actions.
# CPT Definitions

## Urgency

| URG0 |(~URG \| URG0)|(URG \| URG0)|
|------|--------------|-------------|
|false |     0.55     |     0.45    |
|true  |     0.15     |     0.85    |

Urgency is initially just normalized because it is a hidden variable. The table above is the CPT for pr(Urgencyt | Urgencyt-1).
We set the variables to having an 55% chance the event is not urgent if it was previously not urgent. This makes sense because if the event was previously not urgent it is probably going to remain that way. Although,
as t increase and we approach the event it will most likely become urgent at some point, hence why there is a 45% chance it can become urgent.
If an event was already urgent we set the chance of it remaining urgent to 85%. In almost all cases if an event was urgent and we are getting closer to it as time increases it shall remain urgent. Although, there is a 15% chance it will become non-urgent because maybe the importance of the event has changed.
## EventImportance

| URG |(NotImp \| URG)|(Imp \| URG)|(VeryImp \| URG)|
|-----|---------------|------------|----------------|
|false|     0.45      |    0.35    |      0.2       |
|true |     0.2       |    0.3     |      0.5       |

When an event is not urgent there is a 45% chance that the event is unimportant, a 35% chance it is important, and a 20% chance it is very important. These values were chosen because Urgency is a combination of time left to the event and how important the event is. So if it is Non-urgent there is still a relatively high chance the event is important at 20% it just might be far off in the future.
When an event is urgent the percentage chances tend to lean more to the event being important. This is because even though there is a combination between time to the event and the importance to define urgency important events are still more urgent than non-important ones.
## TimeUntilEvent

| URG |(FarAway \| URG)|(MediumDistance \| URG)|(VeryClose \| URG)|
|-----|----------------|-----------------------|------------------|
|false|      0.7       |          0.2          |       0.1        |
|true |      0.05      |          0.4          |       0.55       |

When an event is not urgent there is a higher likely hood that the event is far away because there is less of an urgency around events in the far future.
Although, when an event is urgent there is a higher chance that the event is close or a medium distance away. This is because events closer to the current day have a higher urgency.
## NeedReminder

| NR0 |(~NR \| NR0)|(NR \| NR0)|
|-----|------------|-----------|
|false|     0.6    |    0.4    |
|true |     0.1    |    0.9    |

Intially NeedReminder is a normalized variable because it is a hidden variable. The table about is NeedReminder at time t given NeedReminder t-1. If the user previously did not need a reminder there is a higher chance they will not need one now at 60%. Although, since there is a chance something in the world has changed there is a 40% chance they might now need a reminder.
If the user previously did need a reminder there is an incredibly high chance they will still need one at 90%.
## Busyness

| NR  |(NotBusy \| NR)|(Busy \| NR)|(VeryBusy \| NR)|
|-----|---------------|------------|----------------|
|false|     0.75      |    0.2     |      0.05      |
|true |     0.15      |    0.35    |      0.5       |

When the user does not need a reminder there is a higher chance they are less busy at 75% and a very low chance they are very busy at 5%. When the user does need a reminder the percentage leans towards the user being busy and very busy. This makes sense because the busier the user is the more likely they are to need a reminder and the less busier they are the less likely they are to need a reminder.
## Preferences

| NR |(~WantReminder \| NR)|(WantReminder \| NR)|
|-----|--------------------|--------------------|
|false|         0.7        |        0.3         |
|true |         0.4        |        0.6         |

This variable is just based off of the users input notification preference. When the user needs doesn't need a reminder there is a higher likelyhood they did not want a reminder in the first place. If the user does need a reminder there is a higher chance they did want a reminder.
## CheckedCalendarRecently

| NR  |(WithinMonth \| NR)|(WithinWeek \| NR)|(WithinDay \| NR)|
|-----|-------------------|------------------|-----------------|
|false|        0.1        |       0.2        |      0.7        |
|true |        0.4        |       0.4        |      0.2        |

When the user does not need a reminder there is a higher chance that they have checked their calendar within the last day rather than the last week or month. When the user does need a reminder there is a higher chance that they have not checked within the last date. 