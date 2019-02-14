function rv = gather_data(s)

figure();
while (true)
    data = fscanf(s, 'uint8', 60);
    data = uint8(data);
    plot(data);drawnow
    
end



end