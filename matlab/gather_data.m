function rv = gather_data(handles)

fname = handles.fname;
%xlswrite(fname, {'Time [ms]', 'Force [Nm]', 'Pressure [kPa]'});
delete(fname);
k = 1;
ctr = 0;
total_data = zeros(1,1);
num_points = 6;

x = .00001;
% while (x < 1e-3)
%     tic
%     data = fscanf(handles.s, '%c', num_points);
%     x = toc;
% end

while (ctr < 10000)
    fprintf(handles.s, 's');
    data = fscanf(handles.s, '%c', num_points);
    if length(data) ~= num_points
        continue
    end
    data = uint8(data);
    plot(data);drawnow
     total_data((k-1)*num_points+1:(k-1)*num_points+num_points) = data;

    if (k == 10)
        dlmwrite(fname, total_data, 'delimiter', ',', '-append');
        k = 0;
    end
    
    k = k+1;
    ctr = ctr+1;
end



end