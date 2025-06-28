# file to plot time series eog data
data = importdata("CoolTerm Capture (eogsaccade.CoolTermSettings) 2025-06-07 21-52-39-231.txt");
class(data);
#voltage=str2double(data)
# removing outliers from time series data
length(data);
for i=1:length(data)
  voltageitem=data(i);
  
  
  if (voltageitem > 20 | voltageitem < -20)
   #fprintf('outlier \n')
   data(i)= 0;
  endif
endfor
time = [1:length(data)]';
#data
#x = [1:time]
figure(1);
plot(data)
pbaspect([4 1 1])
xlim([200 500])

#finding first derivative by finite difference methods
dy1 = diff(data);
dt1 = diff(time);

vel1 = dy1./dt1;
velticks = [1:length(vel1)]'

#finding points where velocity apmiltude greater than 7 UV/sec for saccade data points
saccade_ticks= zeros([],1)';
for i = 1:velticks
  #if ( vel1(i) > 7 | vel1(i) < -7 )
    saccade_ticks(end+1)=i;
  #endif
endfor


  

[pks,locs] = findpeaks(vel1,"DoubleSided");

figure(2);
plot(velticks,vel1,locs,vel1(locs),'xm')
xlim([200 500])
pbaspect([4 1 1])

figure(3);
velticks(end+1)=0;
vel1(end+1)=0;
plot(data)
xlim([200 500])
pbaspect([4 1 1])

figure(4);
plot(saccade_ticks,data(saccade_ticks),"r")
xlim([200 500])
pbaspect([4 1 1])

saccade_ticks



