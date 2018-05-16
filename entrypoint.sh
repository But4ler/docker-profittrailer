#!/bin/bash

BASE=/opt
APP=/app
PT="ProfitTrailer"

PT_VERSION=${PT_VERSION:-2.0.5}

echo "VERSION DEPLOYER: $PT_VERSION"
ls $BASE/*.zip

PT_DIR=$APP/$PT
PT_ZIP=$BASE/${PT}-${PT_VERSION}.zip
PT_JAR=$PT_DIR/${PT}.jar

# Other Java options
# Ref1: https://wiki.profittrailer.com/doku.php?id=linux_guide#configuring_profittrailer
# Ref2: https://github.com/Helmi/profit-docker/blob/master/profit-trailer/start

JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"		  # don't try to start AWT. Not sure this does anything but better safe than wasting memory
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"                      # Use UTF-8

JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC"
JAVA_OPTS="$JAVA_OPTS -Xmx512m"					  
JAVA_OPTS="$JAVA_OPTS -Xms512m"

PT_START="java $JAVA_OPTS -jar $PT_JAR"

[ -d "$PT_DIR" ] || mkdir "$PT_DIR" || {
   echo "Error: no $PT_DIR found and could not make it. Exiting."; exit -1;
}
unzip -oqd $APP $PT_ZIP $PT-${PT_VERSION}/${PT}.jar || {
  echo "Error: no $PT jar found. Exiting."; exit -1;
}
cd $PT_DIR || {
  echo "Error: problem with $PT_DIR. Exiting."; exit -1;
}

pcnt=$(/bin/ls -1 $PT_DIR/*.properties 2>/dev/null|/usr/bin/wc -l)
[[ $pcnt -gt 0 ]] || {
  echo "No properties found, extracting..."; unzip -o $PT_ZIP -d $APP;
  echo "Done! Now, edit your configuration files and reload the container."
  exit -1;
} || {
  echo "Error: no properties found and could not properly unzip $PT_ZIP. Exiting.";
  exit -1;
}

# start it
$PT_START
