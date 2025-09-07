%% BASK Modulation and Demodulation

fs = 1000;          % Sampling frequency
Tb = 0.1;           % Bit duration
t = 0:1/fs:Tb-1/fs; % Time vector for one bit

% Binary message (0s and 1s)
message = [1 0 1 1 0 1]; 

% Carrier signal frequency
fc = 50; 

bask_signal = [];
for bit = message
    if bit == 1
        % Transmit carrier for bit 1
        bask_signal = [bask_signal cos(2*pi*fc*t)];
    else
        % Transmit 0 for bit 0
        bask_signal = [bask_signal zeros(1,length(t))];
    end
end

% Plot BASK signal
figure;
plot(linspace(0,Tb*length(message), length(bask_signal)), bask_signal);
title('BASK Modulated Signal');
xlabel('Time (s)'); ylabel('Amplitude');

%% Simple Demodulation using envelope detection
demodulated = [];
for i = 1:length(message)
    segment = bask_signal((i-1)*length(t)+1 : i*length(t));
    if max(segment) > 0.5
        demodulated = [demodulated 1];
    else
        demodulated = [demodulated 0];
    end
end

disp('Original message:'); disp(message);
disp('Demodulated message:'); disp(demodulated);
