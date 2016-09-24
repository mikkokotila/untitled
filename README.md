# untitled -- advanced research 

### what is it 

untitled is an open-source solution for advanced analysis of high volume keywords in Twitter. The basic premise is that you choose 1 or more keywords and get rich and very high quality signal taxonomy with over 50 signals in clean csv format. I've left the analysis for you. 

Twitter data can be analysed from three different "point of views". 

1) network activity 
2) user 
3) content

At the moment these scripts are focused on network activity and user. There is one output format where a row represents an aggregate of the network in a given time interval, and other where a row represents stats for a given user. 

(content summary tables will be added later)

### getting started 

1. Configuration

    1.1 setting up keywords  
    1.2 setting up and/or configuring api access keys 
    1.3 setting up upstart or similar (or crontab)
    1.4 configure network analysis complexity [OPTIONAL]
    
2. Process cycle

    2.1 start collecting tweets (start the upstart service) 
    2.2 start the main process (execute run.sh)
    2.3 access outputs in .csv files named according to the keywords 

Note that step 2.2 and 2.3 might take some time depending on the size of your dataset. 

There will be two separate .csv files for each keyword

- user level data  (for all users tweeting the topic) 

- network level data (aggregate for the keyword in 10 minute intervals)

### getting started 

- keywords
- network statistics time interval (default is 10 minutes) 
- network graph analysis complexity
- api keys
- upstart or similar / crontab 

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

Handles tweet collection. This process should be added ideally to upstart or similar. Crontab may do as well, but upstart or similar is much better. 

##### untitled-graph.sh

Handles network graph analysis. Note that this is not scalable at all in the current state, but gives an indication of the 3rd tier graph quality. 

##### untitled-network.sh

This is where most of the functions reside. All of the functions related to "network" aspect can be found here. 

##### untitled-users.sh
##### untitled-users.py
##### untitled-entropy.r 
