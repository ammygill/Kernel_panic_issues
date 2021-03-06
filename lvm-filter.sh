#defining Colour
red=`tput setaf 1`
green=`tput setaf 2`
normal=`tput sgr0`

#Checking the Root file system and redirecting that to a file.
pvs -a --config 'devices { filter = [ "a|.*|" ] }' --noheadings \
    -opv_name,fmt,vg_name | awk 'BEGIN { f = ""; } \
    NF == 3 { n = "\42a|"$1"|\42, "; f = f n; } END \
        { print " "f"\"r|.*|\" ]" }' > /tmp/lvm-device-filter

#Checking the actual file for uncommented lines of filter in /etc/lvm/lvm.conf
grep -i "filter" /etc/lvm/lvm.conf | grep -v "#" > /tmp/uncommented_filter.txt

#If no filter statement in /etc/lvm/lvm.conf is uncommented
if [ $(echo $?) != 0  ]
    then
    echo "${red}Your System will come Up there is no issue in the System Regarding Lvm Filter${normal}"
else
    #
    for i in $(cat /tmp/lvm-device-filter)
    do
            if [ $i != `awk '{print $NF}' /tmp/lvm-device-filter` ]
        then
	
         for j in $(cat /tmp/uncommented_filter.txt)
        do
		cat /tmp/uncommented_filter.txt | grep -i "a|.*/|"
		if [ $(echo $? )  ==  0 ] 
		then
		echo "The System will Come UP In next boot no Problem detected in lvm filter"	
		break
		fi 
           	value=`cat  /tmp/uncommented_filter.txt | grep -i $i `
        	done
       		
		if [ $(echo $?) == 0 ]
        	then
            		echo "There is NO ISSUE in the lvm.conf file"                
           	 	break
        	else 
             	         echo "Please Check /etc/lvm/lvm.conf file ${red} ISSUE REPORTED${normal} "
            		 break
        	fi


    fi

done    
fi
