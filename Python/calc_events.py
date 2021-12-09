from __future__ import print_function
import datetime
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials



SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']


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


def get_importance(color):
    if color and color == '11':
        return 2
    else:
        return 1


def main():
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
    now = datetime.datetime.utcnow().isoformat() + 'Z'  # 'Z' indicates UTC time
    end = (datetime.datetime.utcnow() + datetime.timedelta(days=7)).isoformat() + 'Z'

    print('Getting the upcoming events')
    events_result = service.events().list(calendarId='primary', timeMin=now,
                                          timeMax=end, singleEvents=True,
                                          orderBy='startTime').execute()
    events = events_result.get('items', [])

    if not events:
        print('No upcoming events found.')
    reminders = {
        

    }
    now = datetime.datetime.strptime(now, "%Y-%m-%dT%H:%M:%S.%fZ")
    for event in events:
        print(event['reminders'].get(''))
        eventDate = event['start'].get('dateTime', event['start'].get('date'))
        # Values for matlab
        busyness = get_busyness(len(events) - 1)
        eventImportance = get_importance(event.get('colorId'))
        distToEvent = get_event_dist(now, datetime.datetime.strptime(eventDate, "%Y-%m-%d"))
        # Send to matlab for simulation & recieve the actions desired
        #  actions = Run_MatlabSim.run_sim(eventImportance, distToEvent, busyness, 3)
        # # Recieve results and determine action
        #  overrides = DetermineActions.recieveActions(event, distToEvent - 1, actions)
        #
        #  if overrides != "":
        #     service.events.update(calendarId='primary', eventId=event['id'])
        # start = event['start'].get('dateTime', event['start'].get('date'))
        # print(start, event['summary'])


if __name__ == '__main__':
    main()

# TODO: Get event data regarding distance to event, how important the event is
# TODO: Get data regarding how busy user schedule is, and when the last time they checked their calendar was
#
#
