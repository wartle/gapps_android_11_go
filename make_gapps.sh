#!/bin/bash
DISP="Nexus 4";
DEVICE="mako";
SYSBLK="/dev/block/mmcblk0p21";

if [ "$1" != "default" ] && [ "$1" != "clean" ] && [ "$#" -ne "3" ]; then
		echo "Usage: ./make_gapps.sh <DISPLEYABLE DEVICE NAME> <DEVICE CODENAME> <SYSTEM_PARTITION_BLOCK_DEVICE>";
		echo " ";
		echo "Example: ./make_gapps.sh \"Nexus 4\" \"mako\" \"/dev/block/mmcblk0p21\"";
		exit 1;
fi

if [ "$1" == "clean" ]; then
	rm META-INF/com/google/android/update-binary;
	rm *.zip;
	echo "Cleaned up!";
	exit 0;
fi

if [ "$1" != "default" ]; then
	DISP="$1";
	DEVICE="$2";
	SYSBLK="$3";
fi

cat update-binary | sed s@"###TARGET_DEVICE_DISP###"@"TARGET_DEVICE_DISP=\"$DISP\""@ > META-INF/com/google/android/update-binary;
sed -i s@"###TARGET_DEVICE###"@"TARGET_DEVICE=\"$DEVICE\""@ META-INF/com/google/android/update-binary;
sed -i s@"###SYSTEM_BLK###"@"SYSTEM_BLK=\"$SYSBLK\""@ META-INF/com/google/android/update-binary;
sed -i s@"###PACKAGER###"@"$(whoami)"@ META-INF/com/google/android/update-binary;
zip -r9 antman_gapps-arm-11.0-go-$(date '+%Y%m%d')-${DEVICE}.zip META-INF system unzip;
