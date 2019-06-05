function rv = translate_data(handles)

fname = handles.fname;
data = csvread(fname);

data = transpose(data);
data = data(:);
ind = find(data == 255, 1);
data(1:ind) = [];

num_points = 6; %The number of points in each message
ctr = 1;
while ctr <= floor(length(data)/num_points)
    if data((ctr-1)*num_points+num_points) ~= 255
        tmp = data((ctr-1)*num_points+1:end);
        ind = find(tmp == 255, 1);
        data((ctr-1)*num_points+1:(ctr-1)*num_points+ind) = [];
        continue
    end
    
    minutes = dec2bin(data((ctr-1)*num_points+1), 8);
    seconds = dec2bin(data((ctr-1)*num_points+2), 8);
    milli_sec = dec2bin(data((ctr-1)*num_points+3), 8);
    min(ctr) = str2num(minutes);
    sec(ctr) = str2num(seconds);
    mil(ctr) = str2num(milli_sec);
    alignment(ctr) = data((ctr-1)*num_points+num_points);
    tmp = bin2dec(strcat(milli_sec, seconds, minutes));
    time(ctr) = tmp;
    v_force(ctr) = data((ctr-1)*num_points+4);
    v_ref(ctr) = data((ctr-1)*num_points+5);
    v_press(ctr) = data((ctr-1)*num_points+6);
    
    ctr = ctr+1;
end

dlmwrite('newtest.csv', [time' v_force' v_ref' v_press'], 'delimiter', ',', 'precision', 9);

end





