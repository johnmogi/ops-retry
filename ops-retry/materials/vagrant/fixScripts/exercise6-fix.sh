#!/bin/bash
#add fix to exercise6-fix here
set -e

# At least 2 arguments should be passed
if [ $# -lt 2 ]
then
    echo "Please insert the correct number of arguments [min 2 arguments]"
    exit
else 
	case `hostname` in  
		server1) rmserver=server2 ;;
		server2) rmserver=server1 ;; 
	esac
fi

#Getting arguments 
FILES=${@:1:$#-1} #File lists
DIR=${@:$#} #last arguments - directory on remote server
myFileSizeCheck="" #calculate files size in bytes

for file in ${FILES}; do
		let myFileSizeCheck+=$(stat -c %s $file);
		#printf "%d\n" $myFileSizeCheck
done

scp $FILES `whoami`@$rmserver:$DIR
printf "%d\n" $myFileSizeCheck;

exit
