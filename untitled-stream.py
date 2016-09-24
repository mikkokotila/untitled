#!/usr/bin/python

from TwitterAPI import TwitterAPI
import sys

CONSUMER_KEY = ''
CONSUMER_SECRET = ''
ACCESS_TOKEN_KEY = ''
ACCESS_TOKEN_SECRET = ''

api = TwitterAPI(CONSUMER_KEY,
                 CONSUMER_SECRET,
                 ACCESS_TOKEN_KEY,
                 ACCESS_TOKEN_SECRET)

KEYWORDS = 'keyword1, keyword2'
f = open('/root/dev/election/master.txt', 'a')
r = api.request('statuses/filter', {'track': KEYWORDS})

for item in r.get_iterator():
	try:
   		value = item['user']['statuses_count'], item['user']['followers_count'], item['user']['friends_count'], item['created_at'], item['user']['screen_name'], item['user']['id_str'], item['retweet_count'], item['favorite_count'], item['text']

   		s = str(value)
   		f.write(s)
  		f.write('\n')
	except Exception:
    		sys.exc_clear()
