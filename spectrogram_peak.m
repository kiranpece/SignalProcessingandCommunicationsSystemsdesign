% Analyze a multi-frequency noisy signal and find peak frequencies

fs = 1000;                     % Sampling frequency
t = 0:1/fs:1-1/fs;             % Time vector

% Create a multi-frequency signal
f1 = 50; f2 = 120; f3 = 200;
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);

% Add Gaussian noise
noisy_signal = signal + 0.5*randn(size(t));

% Compute FFT
n = length(noisy_signal);
fft_vals = fft(noisy_signal);
freqs = (0:n-1)*(fs/n);

% Compute magnitude and phase
magnitude = abs(fft_vals)/n;
phase = angle(fft_vals);

% Plot original and noisy signal
figure;
subplot(3,1,1);
plot(t, noisy_signal);
title('Noisy Multi-frequency Signal');
xlabel('Time (s)'); ylabel('Amplitude');

% Plot magnitude spectrum
subplot(3,1,2);
stem(freqs(1:floor(n/2)), magnitude(1:floor(n/2)), 'filled');
title('Magnitude Spectrum');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

% Plot phase spectrum
subplot(3,1,3);
stem(freqs(1:floor(n/2)), phase(1:floor(n/2)), 'filled');
title('Phase Spectrum');
xlabel('Frequency (Hz)'); ylabel('Phase (radians)');

%% Identify peak frequencies
[pks, locs] = findpeaks(magnitude(1:floor(n/2)), freqs(1:floor(n/2)));
disp('Peak Frequencies (Hz):');
disp(locs);
