
% Simple example: remove noise from a sine wave using a low-pass filter

fs = 1000;                  % Sampling frequency
t = 0:1/fs:1-1/fs;          % Time vector
signal = sin(2*pi*50*t);    % Original signal

% Add Gaussian noise
noisy_signal = signal + 0.5*randn(size(t));

% Design a low-pass filter
fc = 100;                    % Cut-off frequency
[b, a] = butter(6, fc/(fs/2), 'low');  % 6th order Butterworth filter

% Filter the noisy signal
denoised_signal = filter(b, a, noisy_signal);

% Plot the results
figure;
subplot(3,1,1);
plot(t, signal);
title('Original Signal');

subplot(3,1,2);
plot(t, noisy_signal);
title('Noisy Signal');

subplot(3,1,3);
plot(t, denoised_signal);
title('Denoised Signal');
xlabel('Time (s)');
