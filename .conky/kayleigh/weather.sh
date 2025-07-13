#!/bin/bash
#curl wttr.in/Mechelen?format="Condition:+%C\n""Temperature:+%t\n""Wind+chill:+%f\n""Humidity:+%h\n""Pressure:+%P\n""Wind:+%w\n""Precipitation:+%p\n" --silent --max-time 3

case $1 in
  "--condition" ) 
    curl https://wttr.in/Mechelen?format=+%C --silent --max-time 3;;
  "--humidity" ) 
    curl https://wttr.in/Mechelen?format=+%h --silent --max-time 3;;
  "--temperature" ) 
    T=`curl https://wttr.in/Mechelen?format=+%t --silent --max-time 3 | strings -U x | awk -F'<' '{print $1}'`
    echo ${T};;
  "--wind" ) 
    W=`curl https://wttr.in/Mechelen?format=+%w --silent --max-time 3 | strings -U x | awk -F'>' '{print $2}'`
    echo ${W};;
  "--moonphase" ) 
    curl https://wttr.in/Mechelen?format=+%m --silent --max-time 3;;
  "--rain" ) 
    curl https://wttr.in/Mechelen?format=+%p --silent --max-time 3;;
  "--pressure" ) 
    curl https://wttr.in/Mechelen?format=+%P --silent --max-time 3;;
  "--uvindex" ) 
    curl https://wttr.in/Mechelen?format=+%u --silent --max-time 3;;
esac
