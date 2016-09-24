#!/bin/bash

#     - change 'keyword1' and 'keyword2' below
#     - you need to have users_data_keyword.csv for each keyword
#     - read the README.me for more information


for i in keyword1 keyword1;
do 
	cut -d ',' -f10 users_data_"$i".csv | sort -u | grep ^@ | awk -v n=100 '1; NR % n == 0 {print "~"}' | tr '\n' ' ' | tr -d '@' | tr ' ' ',' | tr '~' '\n' > input.temp
	while read HANDLES;
	do
		echo -e "$HANDLES" > handles.temp
		python ./untitled.py | grep ^'  "' | grep -v '"status":' | tr -d ',"' | grep -e screen_name -e has_extended_profile -e "profile_use_background_image " -e id -e verified -e followers_count -e listed_count -e utc_offset -e statuses_count -e friends_count -e location -e geo_enabled -e lang -e notifications -e url -e created_at -e time_zone -e protected -e default_profile_image | sed 's/\ \ //' | tr '[a-z]' '[A-Z]' | tr -d '(){}[]@%$#^&*<>,.;|' | sed 's/:/=(/' | sed 's/$/)/' | sed 's/( /(/' | tr -d "'" | grep -v ^DESCRIPTION | grep -v "_URL" | grep -v ^NAME >> temp.temp
		split -l 21 temp.temp parser-temp
		SPLITS=$(ls -l parser-temp* | rev | cut -d ' ' -f1 | rev)

		for OBJECT in $SPLITS;
		do 
			ROWS=$(cat $OBJECT | wc -l | tr -d ' '); echo -e "ROWS=($ROWS)" >> $OBJECT
    		cat $OBJECT | cut -d '=' -f2 | tr '\n' ',' | sed 's/,$/\n/' | sed 's/n$//' >> parser.temp
		done
	cut -d '=' -f1 $OBJECT | tr '\n' ',' | sed 's/$/\n/' >> "$i".csv
	sort -u parser.temp | sed 's/()/(NA)/g' | tr -d '()' >> "$i".csv
	rm parser-temp*
	rm *.temp
	done <input.temp
done
