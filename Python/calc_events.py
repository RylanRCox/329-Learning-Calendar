from __future__ import print_function
import datetime
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

import DetermineActions
import Run_MatlabSim

SCOPES = ['https://www.googleapis.com/auth/calendar']


# Returns 1, 2, or 3
def get_event_dist(now, eventDate):
    distToEvent = (eventDate - now).days
    if distToEvent <= 2:
        return 1
    elif distToEvent > 5:
        return 3
    else:
        return 2


# Returns 1, 2 or 3
def get_busyness(numEvents):
    if numEvents < 10:
        return 1
    elif numEvents >= 20:
        return 3
    else:
        return 2


# Returns 1 or 2
def get_importance(color):
    if color and color == '11':
        return 2
    else:
        return 1


def main(checkedCalendarFreq,reset):
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('calendar', 'v3', credentials=creds)

    # Call the Calendar API
    # Sets date to the 12th
    now = (datetime.datetime.utcnow()+ datetime.timedelta(days=3)).isoformat() + 'Z'  # 'Z' indicates UTC time
    # Sets date to the 19th
    # now = (datetime.datetime.utcnow() + datetime.timedelta(days=10)).isoformat() + 'Z'  # 'Z' indicates UTC time
    # sets date to the 26th
    # now = (datetime.datetime.utcnow() + datetime.timedelta(days=17)).isoformat() + 'Z'  # 'Z' indicates UTC time

    #For actual use
    #now = datetime.datetime.utcnow().isoformat() + 'Z'  # 'Z' indicates UTC time
    end = (datetime.datetime.utcnow() + datetime.timedelta(days=7)).isoformat() + 'Z'

    print('Getting the upcoming events')
    events_result = service.events().list(calendarId='primary', timeMin=now,
                                          timeMax=end, singleEvents=True,
                                          orderBy='startTime').execute()
    events = events_result.get('items', [])

    if not events:
        print('No upcoming events found.')
    now = datetime.datetime.strptime(now, "%Y-%m-%dT%H:%M:%S.%fZ")
    for event in events:
        if reset:
            event['reminders'] = {'useDefault': False}
            updated_event = service.events().update(calendarId='primary', eventId=event['id'],
                                                    sendNotifications=True, body=event).execute()
        else:

            eventDate = datetime.datetime.strptime(event['start'].get('dateTime', event['start'].get('date')), "%Y-%m-%d")
            # Values for matlab
            busyness = get_busyness(len(events) - 1)
            eventImportance = get_importance(event.get('colorId'))
            distToEvent = get_event_dist(now, eventDate)
            # Send to matlab for simulation & recieve the actions desired
            actions = Run_MatlabSim.run_sim(eventImportance, distToEvent, busyness, checkedCalendarFreq)
            print(actions)
            # Recieve results and determine action
            overrides = DetermineActions.recieveActions((eventDate - now).days - 1, actions)
            #
            if overrides:
                if event['reminders'].get('overrides') is None:
                    reminders = {
                        'useDefault': False,
                        'overrides':
                            overrides
                    }
                    event['reminders'] = reminders
                    updated_event = service.events().update(calendarId='primary', eventId=event['id'],
                                                            sendNotifications=True, body=event).execute()
                    print(updated_event['updated'])
                    print(updated_event['reminders'])
                else:
                    print("This event already has reminders set!")


if __name__ == '__main__':
    main(3,True)
