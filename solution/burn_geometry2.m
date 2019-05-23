function [Ab,Vb] = burn_geometry2(r,h,rb)
    %% INITIAL DIMENSIONS
    % burns from the bottom and from the slot
    % r = 0.012; % [m] motor radius
    % h = 0.070; % [m] motor length 
    
    if rb >= r % motor is burnt out
        Ab = 0; % [m^2] 
    else % there is grain remaining
        %% BURN AREA, X PROJECTION
        Abx = pi()*r^2 - (1/2*pi()*rb^2); % [m^2] burn area, x projection

        %% BURN AREA, Y PROJECTION 
        Aby = (h-rb) * (2*pi()*rb); % [m^2] burn area, y projection

        %% BURN AREA
        Ab = Abx + Aby; % [m^2] total burn area

        %% BURN VOLUME
        Vb = (pi()*r^2-Abx) * (h-rb) + rb*pi()*r^2; % [m^3]
    end