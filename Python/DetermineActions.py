# ['Mon', 'Tues', 'Wed', 'Thur', 'Fr', 'Sat', 'Sun']['Mon', 'Tues', 'Wed', 'Thur', 'Fr', 'Sat', 'Sun']
#    0      1      2      3       4       5      6     0      1      2      3       4       5      6
# ['Email','None','popup','Email','None','popup','None']

def recieveActions(eventIndex, actions):
    actionList = []
    reminderOverrides = []
    popcount = 0
    for index, action in enumerate(actions):
        #
        if action == "popup":
            if popcount < 3:
                actionList.append((index, action))
                popcount += 1
        elif action not in actionList and action != "None":
            actionList.append((index, action))
        # Ignore actions suggested past the date of the event as we don't want to send reminders past the event
        if index == eventIndex:
            break

    for dateIndex, action in actionList:
        reminderOverrides.append(attachReminder(action, eventIndex, dateIndex))
    print(reminderOverrides)
    return reminderOverrides


def attachReminder(action, eventIndex, dateIndex):
    return {'method': action, 'minutes': (60 * 24) * (eventIndex - dateIndex)}

# recieveActions(6, ['popup','None','popup','popup','popup','popup','popup'])
