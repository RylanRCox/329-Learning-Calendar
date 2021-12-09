['Mon', 'Tues', 'Wed', 'Thur', 'Fr', 'Sat', 'Sun']


def recieveActions(event, eventIndex, actions):
    actionList = []
    reminderOverrides = ""
    popcount = 0
    for index, action in enumerate(actions):
        #
        if action == "Pop-up" and popcount < 3:
            actionList.append((index, action))
            popcount += 1
        elif action not in actionList and action != "None":
            actionList.append((index, action))
        # Ignore actions suggested past the date of the event as we don't want to send reminders past the event
        if index == eventIndex:
            break

    for dateIndex, action in actionList:
        if action == "Email":
            reminderOverrides + attachEmailReminder(event, dateIndex)
        elif action == "Pop-up":
            reminderOverrides + attachPopupReminder(event, dateIndex)
        else:
            continue
    print(reminderOverrides)
    return reminderOverrides


def attachEmailReminder(event, dateIndex):
    return 0


def attachPopupReminder(event, dateIndex):
    return 0
