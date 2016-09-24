KEYWORD=$KEYWORD

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

done < <(while read NAME; do t whois $NAME | grep -e Followers -e Following | tr '\n' '~' | sed 's/Following//' | sed 's/Followers//' | sed "s/$/$NAME/" | tr -d ' ' | tr -d ',' | tr '~' ','; echo -e " "; done < <(cut -d ',' -f5 $CANDIDATE | shuf | head -30));

rm temp000;
