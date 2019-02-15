function rv = gather_data(handles)

fname = handles.fname;
xlswrite(fname, {'Time [ms]', 'Force [Nm]', 'Pressure [kPa]'});
k = 1;
time = zeros(1,100);
force = zeros(1,100);
pressure = zeros(1,100);
while (true)
    data = fscanf(handles.s, 'uint8', 60);
    data = uint8(data);
    plot(data);drawnow
    
    for j = 1:10
        time((k-1)*10+j) = data((j-1)*6+1)*1000*60 + data((j-1)*6+2)*1000 + data((j-1)*6+3)*4;
        force((k-1)*10+j) = data((j-1)*6+4);
        pressure((k-1)*10+j) = data((j-1)*6+5);
    end
    if (k == 100)
        dlmwrite(fname, [time' force' pressure'], 'delimiter', ',', '-append');
        k = 1;
    end
    
    k = k+1;
end



end