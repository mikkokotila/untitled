. untitled-network.sh
	
	DAY=$(date +%b-%d -d "yesterday")

for CANDIDATE in TRUMP HILLARY; 
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
			rm "$CANDIDATE".bash
		done
	done
done
