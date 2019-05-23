function [Ab,Vb] = burn_geometry(r,h,rb)
    %% INITIAL DIMENSIONS
    % burns from the bottom and from the slot
    % r = 0.012; % [m] motor radius
    % h = 0.070; % [m] motor length 
    
    if rb >= r % motor is burnt out
        Ab = 0; % [m^2] 
    else % there is grain remaining
        %% BURN AREA, X PROJECTION
        theta = asin(rb/r); % angle subtended by rectangular burn projection
        %Abx = pi()*r^2 - (theta/(pi())*(pi()*r^2) + rb*sqrt(r^2-rb^2) + 1/2*pi()*rb^2); % [m^2] burn area, x projection
        Abx = pi()*r^2 - (theta/(pi())*(pi()*r^2) + 2*rb*sqrt(r^2-rb^2) + 1/2*pi()*rb^2); % [m^2] burn area, x projection

        %% BURN AREA, Y PROJECTION 
        Aby = (h-rb) * (pi()*rb+2*sqrt(r^2-rb^2)); % [m^2] burn area, y projection

        %% BURN AREA
        Ab = Abx + Aby; % [m^2] total burn area

        %% BURN VOLUME
        Vb = (pi()*r^2-Abx) * (h-rb) + rb*pi()*r^2; % [m^3]
    end