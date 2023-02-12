cd /home/tom/post/code/go/mine/power/Eagle

rrdtool graph power-1hr.png \
--start end-1h \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-6hr.png \
--start end-6h \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-1day.png \
--start end-1d \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-1week.png \
--start end-1w \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-30day.png \
--start end-30d \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-1yr.png \
--start end-1y \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \

rrdtool graph power-10yr.png \
--start end-10y \
--width 700 \
--end now \
--slope-mode \
--vertical-label "KW" \
--lower-limit 0 \
--alt-autoscale-max \
--right-axis-label "Degrees F" \
--right-axis 20:20 \
--slope-mode \
DEF:Power=powertemp.rrd:Power:AVERAGE \
LINE1:Power#0000FF:"Power      " \
GPRINT:Power:LAST:"Cur\: %5.2lf" \
GPRINT:Power:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Power:MAX:"Max\: %5.2lf" \
GPRINT:Power:MIN:"Min\: %5.2lf\n" \
DEF:EVSE=powertemp.rrd:evse:AVERAGE \
LINE2:EVSE#00FF00:"Evse       " \
GPRINT:EVSE:LAST:"Cur\: %5.2lf" \
GPRINT:EVSE:AVERAGE:"Avg\: %5.2lf" \
GPRINT:EVSE:MAX:"Max\: %5.2lf" \
GPRINT:EVSE:MIN:"Min\: %5.2lf\n" \
DEF:Temp=powertemp.rrd:Temperature:AVERAGE \
CDEF:realTemp=Temp,20,-,20,/      \
LINE3:realTemp#FF0000:"Temperature" \
GPRINT:Temp:LAST:"Cur\: %5.2lf" \
GPRINT:Temp:AVERAGE:"Avg\: %5.2lf" \
GPRINT:Temp:MAX:"Max\: %5.2lf" \
GPRINT:Temp:MIN:"Min\: %5.2lf\n" \
