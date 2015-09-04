#!/bin/bash

totalMemSize () {
  MEM=$(cat /proc/meminfo  | awk '/MemTotal: / { print int($2 / 1024) }')
  echo $MEM
}

heapSizeCalc () {
  MEM=$(totalMemSize)
  P50=$(expr $MEM / 2)
  FIXED=$(expr $MEM - 1024)
  if [ $MEM -ge 10240 ]; then
    FIXED=$(expr $MEM - 5120)
  fi
  P90=$(expr $MEM \* 9 / 10)
  RETVAL=1024
  if [ $FIXED -gt $P90 ]; then
    RETVAL=$P90
  else
    if [ $FIXED -gt $P50 ]; then
      RETVAL=$FIXED
    fi
  fi
  echo $RETVAL
}

javaOptsHeapSizeCalc () {
  BUF=$1
  MEM=$(totalMemSize)
  SIZE=$(heapSizeCalc)
  JAVA_MAX_MEMORY=$(expr $SIZE - $MEM \* $BUF / 100)
  echo "-XX:+UseG1GC -Xms${JAVA_MAX_MEMORY}m -Xmx${JAVA_MAX_MEMORY}m"
}

GCLOG=/var/log/gc.log
export JAVA_OPTS=""

export JAVA_ARGS=" \
    -XX:+PreserveFramePointer -XX:PermSize=128m -XX:MaxPermSize=128m \
    $(javaOptsHeapSizeCalc 0) \
    -XX:+HeapDumpOnOutOfMemoryError \
    -verbosegc \
    -XX:+DisableExplicitGC \
    -XX:+PrintGCDetails \
    -XX:+PrintGCDateStamps \
    -Xloggc:$GCLOG \
    "
echo $JAVA_ARGS
