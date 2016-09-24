from twitter import *
import sys
import string
import simplejson as json

token = ""
token_secret = ""
consumer_secret = ""
consumer_key = ""

t = Twitter(auth=OAuth(token, token_secret, consumer_key, consumer_secret))

infile = open('handles.temp', 'r')
ids = infile.readline()

users = t.users.lookup(screen_name= ids, include_entities="false")

print json.dumps(users, indent=1)
