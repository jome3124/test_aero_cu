clear all; close all; clc;

fid = fopen('text.txt', 'r');
data = fread(fid, 'double');
fclose(fid);

for k = 1:length(data)/2
data1(k) = data(2*k-1);
data2(k) = data(2*k);
end

figure();
hold on
plot(data1);
plot(data2);
hold off


