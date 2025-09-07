%% QPSK Modulation and Demodulation

fs = 1000;       % Sampling frequency
Tb = 0.1;        % Symbol duration
t = 0:1/fs:Tb-1/fs;

% Binary message (must be even number of bits)
message = [0 0 0 1 1 0 1 1]; 

% Map bits to symbols (Gray coding)
symbols = [];
for i = 1:2:length(message)
    b1 = message(i);
    b2 = message(i+1);
    % Phase mapping: 00->0, 01->pi/2, 11->pi, 10->3pi/2
    if b1==0 && b2==0
        phase = 0;
    elseif b1==0 && b2==1
        phase = pi/2;
    elseif b1==1 && b2==1
        phase = pi;
    else
        phase = 3*pi/2;
    end
    symbols = [symbols cos(2*pi*50*t + phase)];
end

% Plot QPSK signal
figure;
plot(linspace(0,Tb*length(message)/2, length(symbols)), symbols);
title('QPSK Modulated Signal');
xlabel('Time (s)'); ylabel('Amplitude');

%% Simple demodulation using phase detection
demodulated = [];
for i = 1:2:length(message)
    segment = symbols((i-1)*length(t)+1:i*length(t));
    phase = atan2(mean(sin(2*pi*50*t).*segment), mean(cos(2*pi*50*t).*segment));
    if phase < 0
        phase = phase + 2*pi;
    end
    % Map phase back to bits
    if phase < pi/4 || phase >= 7*pi/4
        demodulated = [demodulated 0 0];
    elseif phase >= pi/4 && phase < 3*pi/4
        demodulated = [demodulated 0 1];
    elseif phase >= 3*pi/4 && phase < 5*pi/4
        demodulated = [demodulated 1 1];
    else
        demodulated = [demodulated 1 0];
    end
end

disp('Original message:'); disp(message);
disp('Demodulated message:'); disp(demodulated);
