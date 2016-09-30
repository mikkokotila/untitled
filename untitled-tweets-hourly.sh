#!/bin/bash

for i in {21..30}
do
	for i in {00..23}; 
	do 
		for a in {0..5}; 
		do  
			cat HILLARY.master | grep "Sep 29 $i:$a" | grep Trump | grep -iv hillary | wc -l | tr '\n' ','; 
			cat HILLARY.master | grep "Sep 29 $i:$a" | grep Hillary | grep -iv trump | wc -l | sed "s/$/,$i:"$a"0/"; 
		done; 
	done
done
