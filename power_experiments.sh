#!/bin/bash
#run ./power_experiments.sh $dev_auto $tag_dir

#To retry the list of installed apps: adb shell "pm list packages -3"|cut -f 2 -d ":"
#To check the coordinate to tap: settings/Developer options/Pointer location

DATE=`date "+%Y%m%d_%H%M%S"`

#./auto_app2multi_list_dest.sh $phone $file_dev $dir_data

# The first parameter $1 should be the phone name, and a file "ids/phone_name" must exist
# If running the script witho only the first  parameter, dev_auto is used, and all experiments executed and tagged
# If running the script with additional parameters: $2 is the experiment file (default: 'dev_auto')
# $3 is the tag dir. If it is 'default' the experiment is tagged in the default directory, if 'notag' the experiment is not tagged (default: 'default') 
# $4 is the device to experiment with (if the option is not provided, all devices will be tested)
# $5 is the experiment to be started (if the option is not provided, all experiments for the chosen device will be started)
DEV_AUTO="$1"
TAG_DIR="$2"



while IFS=";" read name name_exp 
do
    mkdir $TAG_DIR
    mkdir $TAG_DIR/$name
    mkdir $TAG_DIR/$name/power

	/opt/moniotr/bin/dns-override wipe $name
	/opt/moniotr/bin/ip-block wipe $name

    echo "Starting experiment $name_exp for device $name"
	 /opt/moniotr/bin/tag-experiment cancel $name "power"
        /opt/moniotr/bin/tag-experiment start $name "power"
        ./kasa-power $name off
        sleep 2m
        ./kasa-power $name on
        sleep 5m
        echo $DATE $name $name_exp "power ok" >> $TAG_DIR/$name/exp_okA
        /opt/moniotr/bin/tag-experiment stop $name "power" $TAG_DIR

done < $DEV_AUTO
