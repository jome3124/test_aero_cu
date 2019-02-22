function rv = translate_data(handles)

fname = handles.fname;
data = csvread(fname);

data = transpose(data);
data = data(:);
ind = find(data == 255, 1);
data(1:ind) = [];

ctr = 1;
while ctr <= floor(length(data)/6)
    if data((ctr-1)*6+6) ~= 255
        tmp = data((ctr-1)*6+1:end);
        ind = find(tmp == 255, 1);
        data((ctr-1)*6+1:(ctr-1)*6+ind) = [];
        continue
    end
    
    minutes = dec2bin(data((ctr-1)*6+1), 8);
    seconds = dec2bin(data((ctr-1)*6+2), 8);
    milli_sec = dec2bin(data((ctr-1)*6+3), 8);
    min(ctr) = str2num(minutes);
    sec(ctr) = str2num(seconds);
    mil(ctr) = str2num(milli_sec);
    alignment(ctr) = data((ctr-1)*6+6);
    tmp = bin2dec(strcat(milli_sec, seconds, minutes));
    time(ctr) = tmp;
    force(ctr) = data((ctr-1)*6+4);
    pressure(ctr) = data((ctr-1)*6+5);
    ctr = ctr+1;
end

dlmwrite('newtest.csv', [time' force' pressure'], 'delimiter', ',', 'precision', 9);

end





