#!/bin/bash

BASE=/opt
APP=/app
PT="ProfitTrailer"

PT_VERSION=${PT_VERSION:-2.0.6}
#PT_VERSION=${PT_VERSION} 

echo "VERSION DEPLOYER: $PT_VERSION"
ls -la $BASE/

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
# Test précédente installation
if [ $pcnt == 0 ]; then
  echo "No properties found, extracting..."; unzip -o $PT_ZIP -d $APP;
  mv $APP/$PT-$PT_VERSION/* /app/ProfitTrailer;
  rm -fr $APP/$PT-$PT_VERSION
  echo "Done! Now, edit your configuration files and reload the container."
  exit -1;

elif [ -e $PT_JAR ]; then
  echo "Installation PT version: $PT_VERSION"
  unzip -o $PT_ZIP -d $APP
  mv $APP/$PT-$PT_VERSION/${PT}.jar $PT_JAR

else
  echo "Error: check pliz"
  ls -la /app/*
fi

# start it
$PT_START
