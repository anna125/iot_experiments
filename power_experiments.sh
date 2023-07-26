#!/bin/bash
#run ./power_experiments.sh $dev_auto $tag_dir


DATE=`date "+%Y%m%d_%H%M%S"`

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
