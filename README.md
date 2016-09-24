# untitled

### getting started 

This is a second part of a process where tweets have been collected for given keywords from Twitter Streaming API and individual files have been created 

### server configuration

Other than setting up upstart on the server that takes care of the TwitterApi streaming API connection for collecting tweets

### dependencies 

    ruby gem install t
    pip install twitter
    pip install TwitterAPI 

twitter will be used for user related queries. TwitterAPI for streaming (fetching tweets in an on-going manner from the Twitter Streaming API), and t for network graph related searches. 

##### For the current configuration, you'll need 15 Twitter API accounts. 

This has nothing to do with the fact that we're using more than one API wrapper to access Twitter data. 

4 -> twitter for user searches
1 -> TwitterApi for streaming
10 -> t for network graph analysis 

 Further note on API use...industrial social media listening platforms may use hundreds (or more) Twitter API keys at any given point in time. I question the merits of such an approach for commercial purpose, but we are solely interested in research here. 

### the scripts 

##### run.sh 

The main controller script that runs the program. 

#####untitled-stream.py


##### untitled-graph.sh
##### untitled-network.sh 
##### untitled-users.sh
##### untitled-users.py
##### untitled-entropy.r 



