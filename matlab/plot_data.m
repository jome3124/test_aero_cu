 %Josh Mellin
%2/15/2019

%This function reads in the saved data and plots it so you can see it

%housekeeping
clear all; close all; clc

%read in the data and plot
fname = 'newtest.csv';
data = csvread(fname);
time = data(:,1);
force = data(:,2);
pressure = data(:,3);
%min = data(:,4);
%sec = data(:,5);
%mil = data(:,6);

%plot it
figure();
plot(time);
title('Just Time');

figure();
hold on
plot(time, force);
plot(time, pressure);
hold off
title('Force and Pressure');
xlabel('Time');
legend('Force', 'Pressure');


%make a new plot for the converted force and time
cforce = force - min(force);
cforce = cforce * 3.3/6*25/255;
ctime = time - time(1);
figure();
plot(ctime, cforce);
title('Thrust vs. Time');
xlabel('Time [ms]');
ylabel('Thrust [lb]');





