#!/bin/bash

cd /var/www/latex-builder/hook

for j in $(find . -name "*.job"); 
do 
	string=`cat $j`
	IFS=';' read -a array <<< "$string"
	mkdir "/var/www/latex-builder/outputs/${array[0]}"
	./build.sh ${array[0]} ${array[1]} ${array[2]} ${array[3]} ${array[4]} &> "/var/www/latex-builder/outputs/${array[0]}/debug.log"
	rm $j
done
