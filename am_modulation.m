%% Basic AM Modulation and Demodulation

fs = 1000;                  % Sampling frequency
t = 0:1/fs:1-1/fs;          % Time vector

% Message signal (low frequency)
fm = 5;                      % Message frequency
Am = 1;                      % Message amplitude
message = Am * sin(2*pi*fm*t);

% Carrier signal (high frequency)
fc = 100;                    % Carrier frequency
Ac = 2;                       % Carrier amplitude
carrier = Ac * cos(2*pi*fc*t);

% AM Modulation
modulated = (1 + message) .* carrier;

% Plot message and modulated signals
figure;
subplot(3,1,1);
plot(t, message);
title('Message Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, carrier);
title('Carrier Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
plot(t, modulated);
title('AM Modulated Signal');
xlabel('Time (s)'); ylabel('Amplitude');

%% AM Demodulation using envelope detection
demodulated = abs(hilbert(modulated)) - mean(abs(hilbert(modulated)));

figure;
plot(t, demodulated, 'r', 'LineWidth', 1.5);
hold on;
plot(t, message, 'b--', 'LineWidth', 1.5);
title('Demodulated Signal vs Original Message');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Demodulated','Original Message');
