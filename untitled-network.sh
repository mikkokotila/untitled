. election-twitter.sh
	
	DAY=$(date +%b-%d -d "yesterday")

for KEYWORD in TRUMP HILLARY; 
do
	_data-prep_

	for HOURS in {00..23}
	do 

		for MINS in {0..5};
		do
			HOUR=("$HOURS":"$MINS")	
			export HOURS=$HOURS
			_sampling_
			_bucket-data_
			_network-data_
			eval "$(_env_)"
			_export-csv_
			rm "$KEYWORD".bash
		done
	done
done
root@NC-PH-1255-53:~/dev/election# cat election-twitter.sh 
_data-prep_(){
	YESTERDAY=$(date -d  "yesterday" | cut -d ' ' -f2,3)
	LC_ALL=C grep " $YESTERDAY" HILLARY.master > temp111  #<#<#<#<#<#<# REMOVE HARD CODING

	for i in {00..23}; 
	do 
		LC_ALL=C grep -ei $KEYWORD -e " $i:[0-9][0-9]:[0-9][0-9]" temp111 > $KEYWORD.$i #<#<#<#<#<#<# REMOVE HARD CODING
	done
} 


_sampling_(){ 	# taking the hour sample
	grep "\ $HOUR" "$KEYWORD".$HOURS | sed "s/\ u'//g" | sed "s/',/,/g" | sed "s/'\ ,/\ ,/g" | sed 's/\ u"//g' | sed "s/\\n/\ /g" | sed 's/\\u/\ /g' | sed "s/\\'/\'/g" | sed 's/\n/\ /g' | sed 's/^(//' | sed 's/)$//' | sed "s/'$//" > "$KEYWORD"
}

_num3_(){
        grep -e ^'[0-9]\{1,10\},[0-9]\{1,10\},[0-9]\{1,10\}'$
}

_num2_(){
        grep -e ^'[0-9]\{1,10\},[0-9]\{1,10\}'$
}

_num_(){
        grep -e ^'[0-9]\{1,10\}'$
}

_switch-api_(){

        CURRENT=$(t whoami | grep "Screen name" | cut -d ' ' -f4 | tr -d '@')
        NEXT=$(t accounts | grep ^[a-zA-Z] | grep -v $CURRENT | shuf | head -1)
        t set active $NEXT  > /dev/null 2>&1
}

_median_(){		# for calculating medians
	awk ' { a[i++]=$1; } END { print a[int(i/2)]; }'
}

_bucket-data_(){
	cut -d, -f9 "$KEYWORD" | tr '\ ' '\n' | sort | uniq -ic | sort -nr > "$KEYWORD".temp
}

_network-data_(){
	
	MEMORY_FVSF=
	MEMORY_TVSF=
	
	while read ROW; 
	do
        _switch-api_
        NAME=$(echo $ROW | cut -d, -f3);
        FOLLOWERS=$(echo $ROW |  cut -d, -f1);
        FOLLOWING=$(echo $ROW |  cut -d, -f2);

        if [ $FOLLOWERS -le 1000 ];
        then

                t followers $NAME -l > temp000;		

                while read ROW0; 
                do

                        TWEETS=$(echo $ROW0 | cut -d, -f1);
                        FOLLOWERS=$(echo $ROW0 | cut -d, -f3);
                        FOLLOWING=$(echo $ROW0 | cut -d, -f2);

                        THIS_TVSF=$(echo -e "scale=3; $TWEETS / $FOLLOWERS" | bc)
                        MEMORY_TVSF="$MEMORY_TVSF $THIS_TVSF"

                        THIS_FVSF=$(echo -e "scale=3; $FOLLOWERS / $FOLLOWING" | bc)
                        MEMORY_FVSF="$MEMORY_FVSF $THIS_FVSF"

                done < <(cat temp000 | sed 's/\ \ \ /~/g' | tr -s '~' | cut -d '~' -f3,6,7 | tr -d ' ' | tr '~' ',' | tr '@' '\n' | _num3_ | head -15 );
        fi

	done < <(while read NAME; do t whois $NAME | grep -e Followers -e Following | tr '\n' '~' | sed 's/Following//' | sed 's/Followers//' | sed "s/$/$NAME/" | tr -d ' ' | tr -d ',' | tr '~' ','; echo -e " "; done < <(cut -d ',' -f5 $KEYWORD | shuf | head -30));
}

_env_(){
	while IFS= read -r FUNCTION;
	do
		NAME=$(echo $FUNCTION | tr '[a-z]' '[A-Z]' | tr '-' '_')
		echo -e ""$KEYWORD"_"$NAME"=\$("$FUNCTION"); echo -e "\"$KEYWORD"_"$NAME"=$"$KEYWORD"_"$NAME"\" >> "$KEYWORD".bash;"
	 done < <(cat election-twitter.sh | grep ^[a-z] | grep -v '[A-Z]' | grep -v '_' | cut -d '(' -f1)
}

_export-csv_(){
	cat "$KEYWORD".bash | tail -36 | tr '=' '\n' | grep ^[0-9.] | tr '\n' ',' | sed 's/,$/\n/' | sed "s/\ $KEYWORD//" | sed "s/^/"$KEYWORD","$DAY","$HOURS:$MINS"0,/" >> "$KEYWORD".csv
}


## BASIC STATS FOR THE TEXT PART OF THE TWEET

tweets-total(){ 	# all tweets from the sample
	wc -l $KEYWORD
}

tweets-unique(){
	cut -d, -f9 $KEYWORD | sort -u | wc -l
}

tweets-original(){		# tweets that don't start with RT or @
	cut -d, -f9 $KEYWORD | grep -v ^"RT" | grep -v ^"@" | grep -v "http" | wc -l
}

tweets-mention(){	# tweets that start with a mention
	cut -d, -f9 $KEYWORD | grep ^"RT" | wc -l
}

tweets-rt(){
	cut -d, -f9 $KEYWORD | grep ^"RT" | wc -l
}

tweets-link(){
	cut -d, -f9 $KEYWORD | grep "http" | wc -l
}

tweets-hashtag(){	# tweets with hashtag
	cut -d, -f9 $KEYWORD | tr ' ' '\n' | grep ^"#" | wc -l
}

tweets-hashtag-unique(){	# unique hashtags
	cut -d, -f9 $KEYWORD | tr ' ' '\n' | grep ^"#" | sort | uniq | wc -l
}


## BASIC STATS FOR USERS

handles-unique(){
	cut -d, -f5 "$KEYWORD" | sort -u | wc -l
}

sum-tweets(){
	cut -d, -f1 "$KEYWORD" | tr -d ' ' | numsum
}

sum-followers(){
	cut -d, -f2 "$KEYWORD" | tr -d ' ' | numsum
}

sum-following(){
	cut -d, -f3 "$KEYWORD" | tr -d ' ' | numsum
}

median-followers(){
	cut -d, -f2 "$KEYWORD" | _median_
}

median-following(){
	cut -d, -f3 "$KEYWORD" | _median_
}

median-tweeets(){
	cut -d, -f1 "$KEYWORD" | _median_
}


median-tweets-per-following(){
	cut -d, -f1,3  "$KEYWORD" | sed 's/\ 0$/\ 1/' | awk '{ print $1, $1 / $2 }'| cut -d, -f2 | tr -d ' ' | _median_
}

median-followers-per-following(){
	cut -d, -f2,3  "$KEYWORD" | sed 's/\ 0$/\ 1/' | awk '{ print $1, $1 / $2 }'| cut -d, -f2 | tr -d ' ' | _median_
}


words-total(){
	cut -d, -f9  "$KEYWORD" | tr ' ' '\n' | wc -l
}

words-unique(){
	cut -d, -f9  "$KEYWORD" | tr ' ' '\n' | sort -ui | wc -l
}

words-positive(){
	grep -wf positive.bucket "$KEYWORD".temp | wc -l
}

words-negative(){
	grep -wf negative.bucket "$KEYWORD".temp | wc -l
}

words-emotional(){
	grep -wf negative.bucket "$KEYWORD".temp | wc -l
}

words-functional(){
	grep -wf functional.bucket "$KEYWORD".temp | wc -l
}

words-emotional-positive(){
	grep -wf emotional-positive.bucket "$KEYWORD".temp | wc -l
}

words-emotional-negative(){
	grep -wf emotional-negative.bucket "$KEYWORD".temp | wc -l
}

words-functional-positive(){
	grep -wf functional-positive.bucket "$KEYWORD".temp | wc -l
}

words-functional-negative(){
	grep -wf functional-negative.bucket "$KEYWORD".temp | wc -l
}

score-positive(){
	grep -wf positive.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-negative(){
	grep -wf negative.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-emotional(){
	grep -wf negative.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-functional(){
	grep -wf functional.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-emotional-positive(){
	grep -wf emotional-positive.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-emotional-negative(){
	grep -wf emotional-negative.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-functional-positive(){
	grep -wf functional-positive.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

score-functional-negative(){
	grep -wf functional-negative.bucket "$KEYWORD".temp | tr -s ' ' | cut -d ' ' -f2 | numsum
}

network-fvsf-median(){
	echo $MEMORY_FVSF | tr ' ' '\n' | _median_
}

network-tvsf-median(){
	echo $MEMORY_TVSF | tr ' ' '\n' | _median_
}
